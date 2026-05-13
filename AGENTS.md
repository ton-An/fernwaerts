# AGENTS.md

Repository-wide guidance for coding agents.

## Hard Rules

- Use the scoped `AGENTS.md` nearest to the files being changed:
  - `app/AGENTS.md`: Flutter client.
  - `supabase/AGENTS.md`: Supabase, PowerSync, migrations, Edge Functions.
  - `docs/AGENTS.md`: Next.js/Fumadocs docs site.
- Check `git status` before editing.
- Do not revert user changes or unrelated local modifications.
- Keep changes scoped to the task.
- Prefer `rg` for search.
- For Dart and Flutter package, dependency, `pub`, hot reload/restart, and
  package-source inspection tasks, use the Dart MCP server before shell commands
  or web search.
- Use structured tools/parsers for structured files when practical.
- Do not commit secrets, Supabase keys, local env files, dependency folders,
  build output, local volumes, or device-specific artifacts.
- Avoid logging location data, tokens, credentials, server keys, or device IDs.

## Product Constraints

Fernwaerts is a privacy-focused, self-hosted location history product.

Sensitive areas:

- location history
- authentication/session handling
- device identity
- Supabase row-level security
- PowerSync sync filters
- offline/local-first persistence

Preserve per-user data isolation when changing any of these areas.

## Git Workflow

- Before creating a commit or pull request, inspect recent history and match the
  repository's existing naming style.
- Prefer the current repository style for commit messages and PR titles:
  `[area] type(optional_scope): concise summary`
- Use the top-level project area in brackets, for example `[app]`, `[docs]`,
  `[supabase]`, or `[general]` for repository-level maintenance.
- Use slash-separated combinations such as `[app/supabase]` when a change spans
  multiple project areas.
- Use the same change types already present in history, such as `feat`, `fix`,
  `chore`, `test`, `refactor`, or combinations like `feat/chore` when the PR
  genuinely spans multiple change types.
- Do not add tool-specific prefixes such as `[codex]`.
- For commits authored by Codex, add the trailer
  `Co-authored-by: Codex <codex@openai.com>`.
- Use short snake_case branch names, for example `pre_alpha_polish` or
  `location_visualization`.

## Cross-Project Workflows

Database schema change:

1. Update `supabase/migrations/`.
2. Review RLS policies.
3. Review `supabase/powersync/config/sync_rules.yaml`.
4. Update Flutter Drift/PowerSync schema.
5. Update affected app data sources/repositories/tests.

New synced domain model:

1. Update Supabase schema and sync rules.
2. Update app domain model.
3. Update app data source/repository/use case.
4. Update UI state that consumes it.
5. Add or update focused tests.

Auth or invite flow change:

1. Update Supabase Edge Function behavior.
2. Update Flutter remote data source and repository failure mapping.
3. Update Cubit state handling.
4. Update user-facing docs/copy if behavior changes.

Public setup/docs change:

1. Update `README.md` if the top-level product/setup story changes.
2. Update `docs/` pages for user-facing setup behavior.

## Verification

- Use the narrowest command that verifies the change, then broaden when the
  affected surface justifies it.
- Flutter-only change: use relevant `flutter test` target and `flutter analyze`
  from `app/` when practical.
- Supabase migration/sync change: manually inspect RLS and sync scope; run local
  Supabase commands when available.
- Docs-only change: run `npm run build` from `docs/` when dependencies are
  installed.
- Documentation-only change: no runtime tests required; check Markdown and links
  when practical.
- For cross-project changes, report touched areas and verification commands.
