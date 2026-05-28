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

ADMIN_DB_URL="postgresql://supabase_admin:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable"
DB_URL="postgresql://postgres:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable"
export PGPASSWORD="${POSTGRES_PASSWORD}"
export PGSSLMODE=disable

log() { printf '[migrate] %s\n' "$*"; }

log "waiting for postgres at ${POSTGRES_HOST}:${POSTGRES_PORT}"
until pg_isready -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U postgres -d "${POSTGRES_DB}" -q; do
  sleep 1
done
log "postgres is ready"

log "provisioning powersync storage user + database"
if psql "${ADMIN_DB_URL}" -tAc "SELECT 1 FROM pg_roles WHERE rolname='powersync_storage_user'" | grep -q 1; then
  psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q \
    -v pw="${PS_STORAGE_PASSWORD}" <<'SQL'
ALTER USER powersync_storage_user WITH PASSWORD :'pw';
SQL
else
  psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q \
    -v pw="${PS_STORAGE_PASSWORD}" <<'SQL'
CREATE USER powersync_storage_user WITH PASSWORD :'pw';
SQL
fi

if ! psql "${ADMIN_DB_URL}" -tAc "SELECT 1 FROM pg_database WHERE datname='_powersync'" | grep -q 1; then
  psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q -c \
    "CREATE DATABASE _powersync WITH OWNER powersync_storage_user"
fi

log "applying fernwaerts schema (supabase db push)"
cd /opt/migrate/supabase
supabase db push --yes --db-url "${DB_URL}"

log "setting powersync replication role password"
psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q \
  -v pw="${PS_SOURCE_PASSWORD}" <<'SQL'
ALTER ROLE powersync_role WITH PASSWORD :'pw';
SQL

log "migrations complete"
