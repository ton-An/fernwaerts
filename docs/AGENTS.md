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

## Documentation Framework

Use the Diataxis documentation framework for all product and contributor
documentation. Every documentation page must fit one primary document type:

- Tutorial: learning-oriented lessons that guide newcomers through a practical
  first success.
- How-to guide: problem-oriented recipes that help users complete a specific
  task.
- Reference: information-oriented descriptions of commands, configuration,
  APIs, schemas, options, or behavior.
- Explanation: understanding-oriented discussion that clarifies concepts,
  tradeoffs, architecture, or design decisions.

Do not mix document types unless the page clearly benefits the reader. If a
task requires multiple modes, split the content into separate pages or clearly
separated sections.

## Writing Style

- Write in simple, clear, unambiguous language.
- Do not use marketing jargon or buzzwords.
- Put the reader's goal before implementation detail.
- Use consistent terminology.
- Keep instructions accurate and current. Verify commands, filenames, config
  keys, and technical claims before presenting them as facts.
- Use short sections with descriptive headings.
- Prefer concrete steps, examples, and expected outcomes over abstract advice.
- Use ordered lists for procedures and fenced code blocks for commands.
- Use warnings only for destructive actions, privacy-sensitive behavior, or
  configuration that can expose data.

## Documentation Workflow

Follow this workflow for every documentation request before writing full
content:

1. Acknowledge and clarify the request. Determine the document type, target
   audience, reader goal, and scope, including what should be excluded.
2. Propose a structure. Provide a detailed outline with section titles and a
   short purpose for each section.
3. Wait for approval before drafting full documentation, unless the user has
   explicitly asked for an immediate edit and the missing details can be safely
   inferred from local context.
4. Generate or edit the content in well-formatted Markdown or MDX.
5. Verify formatting, links, code snippets, commands, navigation changes, and
   build behavior according to the scope of the change.

When adding or updating a docs page:

1. Confirm the page's Diataxis type and reader goal.
2. Add or update MDX under `content/docs/`.
3. Update source/navigation config if the page should appear in navigation.
4. Check internal links and terminology.
5. Run the docs build when dependencies are available.

When changing public product/setup copy:

1. Confirm the target audience and setup outcome.
2. Check terminology against the root `README.md`.
3. Update related docs pages if setup behavior changes.
4. Build the docs site when dependencies are available.

When changing contributor documentation:

1. Confirm whether the page is a how-to guide, reference, or explanation.
2. Describe purpose, inputs, outputs, failures, side effects, and verification
   when they are relevant to the document type.
3. Link to canonical setup or workflow pages instead of duplicating long
   procedures.

When changing home page UI:

1. Update components under `app/(home)/`.
2. Run the docs build.
3. Use the Playwright MCP server to open the local docs site, inspect the
   rendered page, and capture screenshots when layout changes.

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
- React/layout change: run `npm run build`; use the Playwright MCP server to
  open, click through, and screenshot the local page when visual review is
  relevant.
- If verification cannot run, report the skipped command and reason.
