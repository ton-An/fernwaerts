# AGENTS.md

Guidance for coding agents working in `docs/`.

## Hard Rules

- Use MDX files under `content/docs/` for documentation pages.
- Use React components under `app/` for routes and landing page UI.
- Keep docs commands scoped to `docs/`.
- Preserve the Next.js/Fumadocs setup unless the task requires structural
  changes.
- Do not commit `.next/`, `node_modules/`, build output, or local env files.
- Keep product terminology consistent with the root `README.md`.

## Layout

- `app/`: Next.js app routes and React components.
- `app/(home)/`: home page components.
- `app/docs/`: documentation route.
- `content/docs/`: MDX documentation content.
- `lib/source.ts`: docs source configuration.
- `source.config.ts`: Fumadocs source config.
- `package.json`: scripts and dependencies.

```text
content/docs/
  index.mdx
  <topic>.mdx
```

## Writing Style

- Start with what the page helps the user do.
- Prefer short sections, direct setup steps, and concrete commands.
- List prerequisites before commands.
- Use ordered lists for procedures.
- Use fenced code blocks for commands.
- State expected outcomes after setup or verification steps.
- Use warnings only for destructive actions, privacy-sensitive behavior, or
  configuration that can expose data.
- Do not duplicate long setup procedures. Link to the canonical page.
- For contributor docs, describe purpose, inputs, outputs, failures, side
  effects, and verification.

## Workflows

Adding a docs page:

1. Add or update MDX under `content/docs/`.
2. Update source/navigation config if the page should appear in navigation.
3. Verify internal links.
4. Run the docs build when dependencies are available.

Changing public product/setup copy:

1. Check terminology against the root `README.md`.
2. Update related docs pages if setup behavior changes.
3. Build the docs site when dependencies are available.

Changing home page UI:

1. Update components under `app/(home)/`.
2. Run the docs build.
3. Use the dev server for visual review when layout changes.

## Commands

Run from `docs/`:

```bash
npm install
npm run dev
npm run build
```

## Verification

- MDX-only change: inspect formatting and links; run `npm run build` when
  practical.
- Navigation/source config change: run `npm run build`.
- React/layout change: run `npm run build`; use `npm run dev` for visual review
  when relevant.
- If verification cannot run, report the skipped command and reason.
