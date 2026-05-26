#!/usr/bin/env bash
# Runs once per container start as an s6 oneshot. Idempotent: postgres first-
# boot init scripts (baked into fernwaerts-postgres) handle the vendor SQL;
# this script only deals with what changes per Fernwaerts release.
#
# Steps:
#   1. Wait for the external db service to accept connections.
#   2. Create the powersync storage user + _powersync database (idempotent).
#   3. Apply Fernwaerts declarative schema via `supabase db push` (idempotent).
#   4. Set the password on the powersync replication role.

set -euo pipefail

: "${POSTGRES_HOST:?required}"
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_DB:=postgres}"
: "${POSTGRES_PASSWORD:?required}"
: "${PS_SOURCE_PASSWORD:?required}"
: "${PS_STORAGE_PASSWORD:?required}"

DB_URL="postgresql://postgres:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable"
export PGPASSWORD="${POSTGRES_PASSWORD}"

log() { printf '[migrate] %s\n' "$*"; }

log "waiting for postgres at ${POSTGRES_HOST}:${POSTGRES_PORT}"
until pg_isready -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U postgres -d "${POSTGRES_DB}" -q; do
  sleep 1
done
log "postgres is ready"

log "provisioning powersync storage user + database (idempotent)"
psql "${DB_URL}" -v ON_ERROR_STOP=1 -q \
  -v ps_storage_pw="${PS_STORAGE_PASSWORD}" <<'SQL'
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'powersync_storage_user') THEN
    EXECUTE format('CREATE USER powersync_storage_user WITH PASSWORD %L', :'ps_storage_pw');
  ELSE
    EXECUTE format('ALTER USER powersync_storage_user WITH PASSWORD %L', :'ps_storage_pw');
  END IF;
END $$;
SQL

if ! psql "${DB_URL}" -tAc "SELECT 1 FROM pg_database WHERE datname='_powersync'" | grep -q 1; then
  psql "${DB_URL}" -v ON_ERROR_STOP=1 -q -c \
    "CREATE DATABASE _powersync WITH OWNER powersync_storage_user"
fi

log "applying fernwaerts schema (supabase db push)"
cd /opt/migrate/supabase
supabase db push --yes --db-url "${DB_URL}"

log "setting powersync_role password"
psql "${DB_URL}" -v ON_ERROR_STOP=1 -q \
  -v ps_source_pw="${PS_SOURCE_PASSWORD}" <<'SQL'
ALTER ROLE powersync_role WITH PASSWORD :'ps_source_pw';
SQL

log "migrations complete"
