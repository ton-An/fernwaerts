# AGENTS.md

Guidance for coding agents working in `supabase/`.

## Hard Rules

- Application schema changes should update the declarative files in `schemas/`
  before generating or editing migrations.
- User-owned data must stay user-scoped in RLS and PowerSync.
- Do not add user-owned tables to global PowerSync buckets.
- Do not log tokens, passwords, invite links, credentials, or location data.
- Use service-role access only where the operation requires it.
- Use the Codex `supabase` and `supabase-postgres-best-practices` skills for
  Supabase and Postgres work when available.
- Do not edit vendored Supabase files unless the task specifically requires it.
- Do not commit local volumes, database data, `.env` files, keys, or runtime
  artifacts.

## Layout

- `migrations/`: application database migrations.
- `schemas/`: declarative application schema, split by object/domain and ordered
  by filename.
- `functions/`: Supabase Edge Functions.
- `powersync/config/powersync.yaml`: PowerSync service config.
- `powersync/config/sync_rules.yaml`: PowerSync sync rules.
- `docker-compose.yaml`: self-hosted Supabase/PowerSync runtime stack.
- `supabase_vendor/`: vendored Supabase service config and migrations.

## Workflows

Declarative schema change:

1. Update or add the relevant file under `schemas/`.
2. Keep object files ordered so dependencies are created before dependents.
3. Generate migrations from the declarative schema when the task requires one.
4. Review generated SQL before committing it; do not hand-edit generated output
   when the source belongs in `schemas/`.
5. Re-check RLS, grants, seed data, and PowerSync sync rules for changed tables.

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
