# AGENTS.md

Guidance for coding agents working in `app/`.

## Hard Rules

- Preserve this flow:
  `Widget/Page -> Cubit -> Use Case -> Repository Contract -> Repository Impl -> Data Source`.
- Cubits call use cases, not repositories or data sources.
- Use cases contain business logic and depend on repository contracts only.
- Repository implementations map exceptions into `Failure` values.
- Data sources own platform, storage, HTTP, Supabase, and PowerSync calls.
- Feature code stays in `lib/features/<feature>/` unless it is genuinely
  shared. Shared infrastructure belongs in `lib/core/`.
- Do not manually edit generated files.
- Do not log location data, tokens, server keys, credentials, or device IDs.

## Style

- Follow `analysis_options.yaml`: 80-column formatting, single quotes, const/final
  preferences, sorted constructors, and typed public APIs.
- Generated files include `*.freezed.dart`, `*.g.dart`, Drift outputs, and generated
  asset/icon files; update sources and regenerate instead of editing them.

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
  - page doc lists major internal components
- Private page parts:
  `lib/features/map/presentation/pages/map_page/_map.dart`,
  `lib/features/map/presentation/pages/map_page/_modal.dart`,
  `lib/features/map/presentation/pages/map_page/_location_markers.dart`
  - `part of '<page_file>.dart';` at top
  - private widget names with leading underscores
  - short docs for non-obvious private parts/handlers
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

## Documentation

- New public APIs must have Dart doc comments (`///`).
- Document public classes, widgets, Cubits, states, use cases, models,
  repository contracts, data source contracts, public methods, and non-obvious
  public fields.
- Use `{@template name}` and `{@macro name}` for reusable class-level contracts.
- Repository/data source behavior is documented on the abstract contract.
  Implementations add docs only for differing or non-obvious behavior.
- Private code gets docs only for non-obvious behavior: workarounds, gestures,
  animations, sync, platform/API constraints, or privacy implications.
- When touching undocumented existing code, document the public API you changed.
  Do not mass-document unrelated code.
- Avoid comments that restate implementation.

Use labels when relevant: `Parameters:`, `Returns:`, `Failures:`, `Throws:`,
`Emits:`, `States:`.

## Workflows

Use case:

1. Add under `domain/usecases/`.
2. Depend on repository contracts.
3. Return `Either<Failure, T>` for recoverable failures.
4. Register in `lib/core/dependency_injector.dart`.
5. Add/update focused tests under matching `test/features/...`.
6. Add template/macro docs.

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

- Domain-only change: matching use case/model tests.
- Repository/data source change: matching repository/data source tests plus
  `flutter analyze`.
- Routing, DI, or shared core change: `flutter analyze` plus broader
  `flutter test`.
- Generated schema/model change: build generation, then analyzer/tests.
- UI-only change: analyzer and relevant widget tests if present.
- Use existing `mocktail` mocks, fixtures, and `test/features/...` layout when
  adding tests.
- If verification cannot run, report the skipped command and reason.

## Commands

Run from `app/`:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
dart format <files>
flutter analyze
flutter test
flutter run --flavor Development
```

Focused test examples:

```bash
flutter test test/features/authentication/domain/usecases/sign_in_test.dart
flutter test test/features/location_tracking/domain/usecases/get_locations_by_date_test.dart
```

## Naming

- Private page/widget part files: `_name.dart`
- Use cases: imperative names such as `SignIn`, `InitializeApp`,
  `GetLocationsByDate`
- Repository contracts: `domain/repositories/`
- Repository implementations: `data/repository_implementations/`
