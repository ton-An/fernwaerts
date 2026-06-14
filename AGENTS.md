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
- Reuse utilities, helpers, and packages already used in the codebase before
  adding new ones, and factor shared logic into one place instead of duplicating
  it across files.
- Prefer `rg` for search.
- For Dart and Flutter package, dependency, `pub`, hot reload/restart,
  package-source inspection, and API documentation lookup tasks, use the Dart
  MCP server before shell commands or web search.
- For launching, controlling, and inspecting iOS simulators, use XcodeBuildMCP
  simulator tools.
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

## Dart MCP Setup

- Before using Dart MCP tools, call `add_roots` for `file://<repo-root>` and
  `file://<repo-root>/app`, deriving `<repo-root>` from the current checkout.
- Use the `app/` root for Flutter package operations.

## Agent Skills

- Repo-local skills live under `.agents/skills/`; read the relevant `SKILL.md`
  before PowerSync, Supabase, or Postgres work.
- Keep detailed skill guidance in the skill files, not in `AGENTS.md`.

## AGENTS.md Maintenance

When editing any `AGENTS.md`:

- Read the affected section and any scoped `AGENTS.md` that may override or
  extend it.
- When correcting bad guidance, delete or replace stale, duplicate, or
  over-specific rules before adding new ones.
- Prefer general, durable guidance over rules tailored to one mistake.
- Keep rules short, actionable, and easy to verify in review.
- Avoid duplication; update or replace existing guidance instead of adding a
  second rule for the same concern.
- Use canonical examples only when they are intended models for future work.
- Avoid long exception lists.

## Git Workflow

- Before creating a commit or pull request, inspect recent history and match the
  repository's existing naming style.
- Prefer the current repository style for commit messages and PR titles:
  `[area] type(scope): concise summary`
- Use the top-level project area in brackets, for example `[app]`, `[docs]`,
  `[supabase]`, or `[general]` for repository-level maintenance.
- Use slash-separated combinations such as `[app/supabase]` when a change spans
  multiple project areas.
- Use the scope for the affected feature or layer, for example
  `[app] feat(settings): impl update password and request otp in repo and datasource`.
- Use the same change types already present in history, such as `feat`, `fix`,
  `chore`, `test`, `refactor`, or combinations like `feat/chore` when the PR
  genuinely spans multiple change types.
- Split unrelated edits into separate commits. Each commit should contain one
  coherent change, even when the edits were made during the same task.
- Do not add tool-specific prefixes such as `[codex]`.
- For commits authored by Codex, add the trailer
  `Co-authored-by: Codex <codex@openai.com>`.
- Use short snake_case branch names, for example `pre_alpha_polish` or
  `location_visualization`.

### Pull Requests

- Before creating a PR, inspect the full branch diff, confirm that every change
  belongs to the requested scope, and run the relevant verification.
- Default to a draft PR unless the user explicitly requests ready for review.
- Write the PR title in the same style as the repository's commit messages,
  using the convention above, and derive the description from the actual diff
  and verification results; do not rely on auto-generated fill text.
- Keep the description focused and use only the sections that add information:
  - `Summary`: one short paragraph stating what changed and why.
  - `Changes`: a few bullets covering reviewer-relevant behavior or design
    decisions, not a file inventory.
  - `Verification`: exact commands run and their outcome.
  - `Fixes <issue>` or `Known follow-up`: include only when applicable.
- For bug fixes, state the root cause and observable behavior change without
  retelling the implementation step by step.
- Omit empty sections, title repetition, exhaustive file walkthroughs,
  implementation diaries, marketing language, generic risk boilerplate, and
  unsupported claims about tests or compatibility.

## Cross-Project Workflows

Database schema change:

1. Follow `supabase/AGENTS.md` for schema and migration updates.
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
