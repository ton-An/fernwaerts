# AGENTS.md

Guidance for coding agents working in `supabase/`.

## Hard Rules

- Application schema changes go through `migrations/`.
- User-owned data must stay user-scoped in RLS and PowerSync.
- Do not add user-owned tables to global PowerSync buckets.
- Do not log tokens, passwords, invite links, credentials, or location data.
- Use service-role access only where the operation requires it.
- Do not edit vendored Supabase files unless the task specifically requires it.
- Do not commit local volumes, database data, `.env` files, keys, or runtime
  artifacts.

## Layout

- `migrations/`: application database migrations.
- `functions/`: Supabase Edge Functions.
- `powersync/config/powersync.yaml`: PowerSync service config.
- `powersync/config/sync_rules.yaml`: PowerSync sync rules.
- `docker-compose.yaml`: self-hosted Supabase/PowerSync runtime stack.
- `supabase_vendor/`: vendored Supabase service config and migrations.

## Workflows

Synced user-owned table:

1. Add migration with table definition.
2. Include `user_id` referencing `public.users` when records are user-owned.
3. Enable row-level security.
4. Add policies restricting access to `auth.uid() = user_id`.
5. Add the table to the PowerSync `user_data` bucket.
6. Update `../app/lib/core/drift/`.
7. Update affected Flutter data sources, repositories, and tests.

Global reference data:

1. Add migration and seed data.
2. Enable row-level security.
3. Add read-only policies for public or authenticated access.
4. Add the table to `public_info` or `general_info` sync buckets.
5. Update Flutter schema/lookup code if the app reads it locally.

PowerSync rule change:

1. Decide whether data is public/general or user-scoped.
2. Use `request.user_id()` for user-owned buckets.
3. Restart PowerSync locally when testing; sync rule changes are not hot-loaded.

Edge Function change:

1. Validate HTTP method.
2. Validate required request fields.
3. Authenticate the caller unless the operation is public setup.
4. Check authorization before service-role mutations.
5. Return structured errors when Flutter maps them to specific `Failure`s.
6. Update Flutter remote data source/repository mapping if response shape or
   status codes change.

## Documentation

- SQL comments explain non-obvious security, privacy, or sync implications.
- Do not comment routine column definitions.
- Edge Function comments explain product rules, authorization, cleanup behavior,
  or service-role mutations.
- Document expected request fields and response/failure shapes when Flutter
  depends on them.

## Commands

Run from `supabase/`:

```bash
supabase start
supabase db reset
supabase functions serve
docker build -t fernwaerts-migrator:dev .
docker build -f Dockerfile.vendor -t fernwaerts-supabase-vendor-migrator:dev .
```

## Verification

- Migration change: review SQL, RLS policies, and affected sync rules.
- Sync-rule change: review bucket scope and restart PowerSync locally when
  testing.
- Edge Function change: serve functions locally if Supabase CLI is available.
- Client-visible backend change: also run affected Flutter tests from `../app/`.
- If verification cannot run, report the skipped command and reason.
