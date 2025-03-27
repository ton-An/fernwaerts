# Copilot Instructions for Flutter App Development

## General Project Context

- This Flutter application follows the **Clean Architecture** pattern, ensuring modularity and maintainability.
- Code should adhere to the **SOLID principles** and be structured for clarity and maintainability.

## Architecture Overview

This project is divided into three main layers:

- **Data Layer**:
  - **Repositories** decide between the local and remote data source and convert exceptions to Failures
  - **Data Sources** handle API communication, local storage etc.
- **Domain Layer**: Contains use cases (business logic), repository contracts and models.
- **Presentation Layer**: Manages UI and state using Flutter widgets and Cubits.

#### **Data Flow**

1. UI interacts with **Cubits** in the Presentation Layer.
2. **Cubits** call Use Cases in the Domain Layer.
3. **Use Cases** communicate with **Repositories**, which fetch data from API or local storage.
4. **Repositories** communicate with **Data Sources**
5. **Data Sources** call APIs, etc.

## Style Guide

- Readability is of upmost importance
- Use **explicit typing** for variables, parameters, and return types.
- Keep functions, classes, use cases and widgets small and focused.
- Divide a widget into parts if it gets to big
- Use **private members** (`_prefix`) to encapsulate logic.
- Organize widgets within a structured library format:
  ```
  calendar/
    calendar.dart
    _header.dart
    _day_cell.dart
  ```
- Naming Conventions:
  - **Classes**: PascalCase (`SignInCubit`, `AuthenticationRepository`).
  - **Methods**: camelCase (`getTokenBundle()`, `signInUser()`).
  - **Variables**: camelCase (`authenticationRepository`).
  - **Constants**: `k` prefix (`kTokenBundleKey`).
  - **Private Members**: `_prefix` (`_saveTokens()`).

## Required Packages

The following packages are **mandatory**:

- `freezed` (for immutable models and unions)
- `get_it` (for dependency injection)
- `flutter_bloc` (for state management using Cubits)
- `go_router` (for routing management)
- `dartz` (for functional programming and error handling)
- `mocktail` (for testing and mocking dependencies)
-

## Commit Message Guidelines

Each commit message should follow this format:

```
[project] <type>(<scope>): <short summary>

<optional detailed description>

<optional issue/task reference>
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation updates
- **style**: Code style changes (formatting, whitespace, etc.)
- **refactor**: Code restructuring without changing functionality
- **perf**: Performance improvements
- **test**: Adding or modifying tests
- **chore**: Maintenance tasks like dependency updates
- **ci**: CI/CD pipeline-related changes
- **build**: Build system modifications
- **revert**: Reverting a previous commit
