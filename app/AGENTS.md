# AGENTS.md

Guidance for coding agents working in `app/`.

## Hard Rules

- Check `git status` from the repository root before editing.
- Preserve this flow:
  `Widget/Page -> Cubit -> Use Case -> Repository Contract -> Repository Impl -> Data Source`.
- Cubits call use cases, not repositories or data sources.
- Use cases contain business logic and depend on repository contracts only.
- Repository implementations map exceptions into `Failure` values.
- Data sources own platform, storage, HTTP, Supabase, and PowerSync calls.
- Feature code stays in `lib/features/<feature>/` unless it is genuinely shared.
  Shared infrastructure belongs in `lib/core/`.
- Do not manually edit generated files.
- Do not log location data, tokens, server keys, credentials, or device IDs.

## Style

- Follow `analysis_options.yaml`: 80-column formatting, single quotes,
  const/final preferences, sorted constructors, and typed public APIs.
- Generated files include `*.freezed.dart`, `*.g.dart`, Drift outputs, generated
  localizations, and generated asset/icon files. Update source files and
  regenerate instead of editing generated output.

## Layout

- `lib/main.dart`: app entry point and routes.
- `lib/core/dependency_injector.dart`: GetIt registrations.
- `lib/core/data/datasources/supabase_handler.dart`: Supabase/PowerSync setup.
- `lib/core/drift/`: PowerSync/Drift schema and generated database.
- `lib/features/`: feature modules.
- `test/`: Flutter tests.

```text
lib/features/<feature>/
  data/{datasources,repository_implementations}/
  domain/{models,repositories,usecases}/
  presentation/{cubits,pages,widgets}/
```

```text
presentation/pages/<name>_page/
  <name>_page.dart
  _private_part.dart
```

Use `part` files only for page-specific private widgets. Reusable widgets go in
`presentation/widgets/`.

## Canonical Patterns

Mirror these files when adding similar code:

- Multi-part page: `lib/features/map/presentation/pages/map_page/map_page.dart`
  - imports in page file
  - `part` declarations after imports
  - `pageName` and `route` on the page class
  - page doc explains coordination between the page, Cubit, and major widgets
    only when that behavior is not obvious
- Private page parts: `lib/features/map/presentation/pages/map_page/_map.dart`,
  `lib/features/map/presentation/pages/map_page/_modal.dart`,
  `lib/features/map/presentation/pages/map_page/_location_markers.dart`
  - `part of '<page_file>.dart';` at top
  - private widget names with leading underscores
  - short docs for non-obvious private parts/handlers
- Complex presentation widget docs:
  `lib/features/in_app_notification/presentation/widgets/in_app_notification/in_app_notification_widget.dart`
  - explains user interactions and relevant internal components
  - keeps useful detail when the widget behavior is not obvious
- Multi-step use case:
  `lib/features/authentication/domain/usecases/initialize_app.dart`
- Stream-returning use case:
  `lib/features/location_tracking/domain/usecases/get_locations_by_date.dart`
- Repository contract:
  `lib/features/location_tracking/domain/repositories/location_data_repository.dart`
- Repository failure mapping:
  `lib/features/authentication/data/repository_implementations/authentication_repository_impl.dart`
- Data source contract/implementation:
  `lib/features/location_tracking/data/datasources/location_data_remote_data_source.dart`

Only add canonical references when the file is the pattern agents should copy.
Before documentation work, read the relevant canonical examples and existing
docs in the target file; match useful detail, not only file structure.

## Documentation

- Write docs only when they add information a reader cannot get from the name,
  type, initializer, or surrounding pattern.
- Public APIs that define behavior or architectural contracts should have Dart
  doc comments (`///`). This usually includes Cubits, use cases, repository and
  data source contracts, reusable widgets with interaction/state behavior, and
  public methods with non-obvious effects.
- Skip docs for simple state/value classes, enum values, pass-through
  constructors, obvious fields, and marker/base classes when their purpose is
  fully expressed by the code.
- Use `{@template ...}` and `{@macro ...}` only when the same contract is
  genuinely reused. Do not add template/macro boilerplate for one-off or
  self-explanatory APIs.
- Do not replace useful detailed docs with shorter summaries. Preserve existing
  explanations unless they are wrong, and improve them in place when needed.
- Repository/data source behavior is documented on the abstract contract.
  Implementations add docs only for differing or non-obvious behavior.
- Private code gets docs only for non-obvious behavior: workarounds, gestures,
  animations, sync, platform/API constraints, or privacy implications.
- When touching undocumented existing code, document only the changed API when
  the change introduces or clarifies a meaningful contract. Do not
  mass-document nearby code.
- Avoid comments that restate implementation.

Use labels when the documented code has that kind of contract:
`Parameters:`, `Returns:`, `Failures:`, `Throws:`, `Emits:`, `States:`,
`State management:`, `Sub-components:`. Prefer labeled sections over unlabeled
prose for those topics.

## Change Workflows

Use case:

1. Add under `domain/usecases/`.
2. Depend on repository contracts.
3. Return `Either<Failure, T>` for recoverable failures.
4. Register in `lib/core/dependency_injector.dart`.
5. Add/update focused tests under matching `test/features/...`.
6. Treat the signature as the primary contract. Add docs only for behavior,
   failure semantics, or constraints that the signature cannot express.

Repository behavior:

1. Update `domain/repositories/`.
2. Implement in `data/repository_implementations/`.
3. Keep exception-to-`Failure` mapping in the repository implementation.
4. Put platform/storage/HTTP/Supabase/PowerSync calls in data sources.
5. Document data source behavior on the abstract data source contract.
6. Test success and failure mapping.

Cubit-backed screen:

1. Add route page under `presentation/pages/`.
2. Put page-specific private parts beside the page file.
3. Put reusable view pieces under `presentation/widgets/`.
4. Put Cubit and states under `presentation/cubits/<name>_cubit/`.
5. Register injectable Cubits in `dependency_injector.dart`.
6. Wire navigable routes in `lib/main.dart`.
7. Document Cubit states and public methods with emitted states.
8. Cover state changes with Cubit/widget tests when behavior changes.

Synced data:

1. Follow `../supabase/AGENTS.md`.
2. Update Supabase migrations and PowerSync sync rules.
3. Update `lib/core/drift/schema.dart`.
4. Update domain models, data source mapping, repository behavior, and tests.
5. Regenerate code when schema/model generation is affected.

## Verification

Run commands from `app/`. Prefer focused checks before broad ones.

- Start with the narrowest command that exercises the change. Broaden when the
  affected surface crosses feature, routing, DI, persistence, or sync
  boundaries.
- Domain-only: matching use case/model tests.
- Repository/data source: matching tests; add `flutter analyze` when contracts,
  imports, or failure mapping changed.
- Routing, DI, shared core, or generated schema/model: run generation when
  needed, `flutter analyze`, and relevant feature tests. Use broader
  `flutter test` when shared behavior is affected.
- UI-only: `flutter analyze` and relevant widget tests if present.
- Use existing `mocktail` mocks, fixtures, and `test/features/...` layout when
  adding tests.
- If verification cannot run, report the skipped command and reason.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format <files>
```

Focused test examples:

```bash
flutter test test/features/authentication/domain/usecases/sign_in_test.dart
flutter test test/features/location_tracking/domain/usecases/get_locations_by_date_test.dart
```

```bash
flutter analyze
flutter test
flutter run --flavor Development
```

## Naming

- Private page/widget part files: `_name.dart`
- Use cases: imperative names such as `SignIn`, `InitializeApp`,
  `GetLocationsByDate`
- Repository contracts: `domain/repositories/`
- Repository implementations: `data/repository_implementations/`
