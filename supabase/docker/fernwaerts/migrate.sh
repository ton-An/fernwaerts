#!/usr/bin/env bash
# Runs once per container start as an s6 oneshot. Idempotent.
#
# Steps:
#   1. Wait for the external db service to accept connections.
#   2. Create the powersync storage user + _powersync database (idempotent).
#   3. Apply Fernwaerts schema via `supabase db push`.
#   4. Set the powersync replication role password (runtime secret).

set -euo pipefail

: "${POSTGRES_HOST:?required}"
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_DB:=postgres}"
: "${POSTGRES_PASSWORD:?required}"
: "${PS_SOURCE_PASSWORD:?required}"
: "${PS_STORAGE_PASSWORD:?required}"

# Connection settings go through libpq env vars so the password never appears
# in process argv (visible in `ps` for the lifetime of each command). The
# supabase CLI uses pgconn, which honors the same env vars, so the push URL
# below carries no password either.
export PGHOST="${POSTGRES_HOST}"
export PGPORT="${POSTGRES_PORT}"
export PGDATABASE="${POSTGRES_DB}"
export PGPASSWORD="${POSTGRES_PASSWORD}"
export PGSSLMODE=disable

DB_URL="postgresql://postgres@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable"

log() { printf '[migrate] %s\n' "$*"; }

log "waiting for postgres at ${POSTGRES_HOST}:${POSTGRES_PORT}"
until pg_isready -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U postgres -d "${POSTGRES_DB}" -q; do
  sleep 1
done
log "postgres is ready"

log "provisioning powersync storage user + database"
if psql -U supabase_admin -tAc "SELECT 1 FROM pg_roles WHERE rolname='powersync_storage_user'" | grep -q 1; then
  psql -U supabase_admin -v ON_ERROR_STOP=1 -q \
    -v pw="${PS_STORAGE_PASSWORD}" <<'SQL'
ALTER USER powersync_storage_user WITH PASSWORD :'pw';
SQL
else
  psql -U supabase_admin -v ON_ERROR_STOP=1 -q \
    -v pw="${PS_STORAGE_PASSWORD}" <<'SQL'
CREATE USER powersync_storage_user WITH PASSWORD :'pw';
SQL
fi

if ! psql -U supabase_admin -tAc "SELECT 1 FROM pg_database WHERE datname='_powersync'" | grep -q 1; then
  psql -U supabase_admin -v ON_ERROR_STOP=1 -q -c \
    "CREATE DATABASE _powersync WITH OWNER powersync_storage_user"
fi

log "applying fernwaerts schema (supabase db push)"
cd /opt/migrate/supabase
supabase db push --yes --db-url "${DB_URL}"

log "setting powersync replication role password"
psql -U supabase_admin -v ON_ERROR_STOP=1 -q \
  -v pw="${PS_SOURCE_PASSWORD}" <<'SQL'
ALTER ROLE powersync_role WITH PASSWORD :'pw';
SQL

log "migrations complete"
