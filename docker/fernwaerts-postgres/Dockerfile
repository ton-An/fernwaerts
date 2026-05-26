# syntax=docker/dockerfile:1.7
#
# Fernwaerts Postgres = supabase/postgres + the vendor SQL files baked in as
# first-boot init scripts. The supabase/postgres image runs anything in
# /docker-entrypoint-initdb.d/ on first start (when PGDATA is empty), which
# matches the upstream supabase/docker self-host pattern exactly — we just
# pre-load the same files at build time instead of mounting them.
#
# Build from the repo root:
#   docker build -f docker/fernwaerts-postgres/Dockerfile -t fernwaerts-postgres:dev .
#
# Pinned to the same tag upstream's docker-compose.yml uses; bump together.

FROM supabase/postgres:15.8.1.085

# Init-scripts run before migrations. Prefixes match upstream's mount paths:
# supabase/docker/docker-compose.yml -> volumes/db/*.sql.
COPY supabase/supabase_vendor/db/init-scripts/webhooks.sql /docker-entrypoint-initdb.d/init-scripts/98-webhooks.sql
COPY supabase/supabase_vendor/db/init-scripts/roles.sql    /docker-entrypoint-initdb.d/init-scripts/99-roles.sql
COPY supabase/supabase_vendor/db/init-scripts/jwt.sql      /docker-entrypoint-initdb.d/init-scripts/99-jwt.sql

# Migrations run after init-scripts. _supabase creates the internal database
# used by analytics; logs.sql adds the schema the Logflare backend writes to.
# realtime.sql and pooler.sql are intentionally omitted — Fernwaerts does not
# run Supabase Realtime or Supavisor.
COPY supabase/supabase_vendor/db/migrations/_supabase.sql  /docker-entrypoint-initdb.d/migrations/97-_supabase.sql
COPY supabase/supabase_vendor/db/migrations/logs.sql       /docker-entrypoint-initdb.d/migrations/99-logs.sql
