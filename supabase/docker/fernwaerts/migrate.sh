#!/usr/bin/env bash
# Runs once per container start as an s6 oneshot. Idempotent: postgres first-
# boot init scripts (baked into fernwaerts-postgres) handle the vendor SQL;
# this script only deals with what changes per Fernwaerts release.
#
# Steps:
#   1. Wait for the external db service to accept connections.
#   2. Create the powersync storage user + _powersync database (idempotent).
#   3. Create/update the powersync replication role.
#   4. Apply Fernwaerts declarative schema via `supabase db push` (idempotent).

set -euo pipefail

: "${POSTGRES_HOST:?required}"
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_DB:=postgres}"
: "${POSTGRES_PASSWORD:?required}"
: "${PS_SOURCE_PASSWORD:?required}"
: "${PS_STORAGE_PASSWORD:?required}"

DB_URL="postgresql://postgres:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable"
ADMIN_DB_URL="postgresql://supabase_admin:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable"
export PGPASSWORD="${POSTGRES_PASSWORD}"
export PGSSLMODE=disable

log() { printf '[migrate] %s\n' "$*"; }

log "waiting for postgres at ${POSTGRES_HOST}:${POSTGRES_PORT}"
until pg_isready -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U postgres -d "${POSTGRES_DB}" -q; do
  sleep 1
done
log "postgres is ready"

log "provisioning powersync storage user + database (idempotent)"
if psql "${ADMIN_DB_URL}" -tAc "SELECT 1 FROM pg_roles WHERE rolname='powersync_storage_user'" | grep -q 1; then
  psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q \
    -v ps_storage_pw="${PS_STORAGE_PASSWORD}" <<'SQL'
ALTER USER powersync_storage_user WITH PASSWORD :'ps_storage_pw';
SQL
else
  psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q \
    -v ps_storage_pw="${PS_STORAGE_PASSWORD}" <<'SQL'
CREATE USER powersync_storage_user WITH PASSWORD :'ps_storage_pw';
SQL
fi

if ! psql "${ADMIN_DB_URL}" -tAc "SELECT 1 FROM pg_database WHERE datname='_powersync'" | grep -q 1; then
  psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q -c \
    "CREATE DATABASE _powersync WITH OWNER powersync_storage_user"
fi

log "provisioning application database extensions"
psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q <<'SQL'
CREATE SCHEMA IF NOT EXISTS extensions;
CREATE EXTENSION IF NOT EXISTS moddatetime WITH SCHEMA extensions;
SQL

log "provisioning powersync replication role"
if psql "${ADMIN_DB_URL}" -tAc "SELECT 1 FROM pg_roles WHERE rolname='powersync_role'" | grep -q 1; then
  psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q \
    -v ps_source_pw="${PS_SOURCE_PASSWORD}" <<'SQL'
ALTER ROLE powersync_role WITH LOGIN REPLICATION BYPASSRLS PASSWORD :'ps_source_pw';
SQL
else
  psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q \
    -v ps_source_pw="${PS_SOURCE_PASSWORD}" <<'SQL'
CREATE ROLE powersync_role WITH LOGIN REPLICATION BYPASSRLS PASSWORD :'ps_source_pw';
SQL
fi

log "applying fernwaerts schema (supabase db push)"
cd /opt/migrate/supabase
supabase db push --yes --db-url "${DB_URL}"

log "provisioning powersync publication"
psql "${ADMIN_DB_URL}" -v ON_ERROR_STOP=1 -q <<'SQL'
DO $$
DECLARE
  sync_tables regclass[] := ARRAY[
    'public.public_info'::regclass,
    'public.role_permissions'::regclass,
    'public.users'::regclass,
    'public.devices'::regclass,
    'public.raw_location_data'::regclass,
    'public.activity_segments'::regclass,
    'public.visits'::regclass,
    'public.user_roles'::regclass
  ];
  sync_table regclass;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'powersync') THEN
    CREATE PUBLICATION powersync;
  END IF;

  FOREACH sync_table IN ARRAY sync_tables LOOP
    IF NOT EXISTS (
      SELECT 1
      FROM pg_publication_rel publication_rel
      JOIN pg_publication publication ON publication.oid = publication_rel.prpubid
      WHERE publication.pubname = 'powersync'
        AND publication_rel.prrelid = sync_table
    ) THEN
      EXECUTE format('ALTER PUBLICATION powersync ADD TABLE %s', sync_table);
    END IF;
  END LOOP;
END $$;
SQL

log "migrations complete"
