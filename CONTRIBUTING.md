# Contributing to Fernwärts

Thank you for your interest in contributing to Fernwärts! This guide will help you understand how to contribute effectively to the project.

## Table of Contents
- [Getting Started](#getting-started)
- [Setting Up Your Development Environment](#setting-up-your-development-environment)
  - [App](#app)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [App Flavors](#app-flavors)
  - [Server](#server)
  - [Optional Setup: Continue for AI-assisted Coding](#optional-setup-continue-for-ai-assisted-coding)
- [Project Architecture](#project-architecture)
  - [Architecture Layers](#architecture-layers)
  - [Data Flow](#data-flow)
- [Code Style Guidelines](#code-style-guidelines)
  - [Architecture Principles](#architecture-principles)
  - [Naming Conventions](#naming-conventions)
  - [Widget Structure](#widget-structure)
  - [Required Packages](#required-packages)
- [Pull Request Process](#pull-request-process)
  - [Commit Types](#commit-types)
- [Testing Guidelines](#testing-guidelines)

## Getting Started

Before contributing, please familiarize yourself with the project structure and documentation.

## Setting Up Your Development Environment

### App

#### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (compatible with Flutter version)
- An IDE (preferably VS Code)
- Git

#### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ton-An/fernwaerts.git
   ```

2. Navigate to the app directory:
   ```bash
   cd fernwaerts/app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run --flavor Development
   ```

#### App Flavors
##### Understanding App Flavors

The app uses three different "flavors" (build variants):

##### What are flavors?
Flavors allow you to create different versions of your app from the same codebase. Each flavor can have its own configuration, such as app name, icon, and API endpoints.

##### Available Flavors
1. **Development**
   - Purpose: For local development and testing
   - Package name: Different from production (to allow installation alongside production app)
   - Use when: Writing and testing code on your local machine

2. **Staging**
   - Purpose: For beta testing and pre-release validation
   - Used for: TestFlight/Play Store beta releases before going to production
   - Use when: Testing the app in a production-like environment before final release

3. **Production**
   - Purpose: The public release version
   - Used for: App Store and Play Store releases
   - Use when: Building the final version for end users

##### Running with a Specific Flavor
```bash
flutter run --flavor Development   # For development
flutter run --flavor Staging       # For staging testing
flutter run --flavor Production    # For production testing
```

## Server

### Build the Migration Containers

1. Clone the repository:
   ```bash
   git clone https://github.com/ton-An/fernwaerts.git
   ```

2. Navigate to the supabase directory:
   ```bash
   cd fernwaerts/supabase
   ```

3. Build the containers:
   ```bash
   docker build -t fernwaerts-migrator:dev . && docker build -f Dockerfile.vendor -t fernwaerts-supabase-vendor-migrator:dev .
   ```

## Optional Setup: Continue for AI-assisted Coding

If you'd like to use `Continue` for AI-powered coding assistance:

### Prerequisites
- [Ollama](https://ollama.ai/)
- VS Code

1. **Install Continue**:
   - Use the [Continue VSCode extension](https://marketplace.visualstudio.com/items?itemName=Continue.continue).

2. **Pull Recommended Models**
   ```bash
   ollama pull codellama:13b-code-q4_K_M 
   ollama pull nomic-embed-text:latest
   ```

## Project Architecture

Fernwärts follows the **Clean Architecture** pattern to ensure modularity, maintainability, and testability.

### Architecture Layers

The project is divided into three main layers:

1. **Data Layer**:
   - **Repositories**: Decide between local and remote data sources and convert exceptions to Failures
   - **Data Sources**: Handle API communication, local storage, etc.

2. **Domain Layer**:
   - **Use Cases**: Contain business logic
   - **Repository Contracts**: Define interfaces for repositories
   - **Models**: Core data structures used across the application

3. **Presentation Layer**:
   - **UI Components**: Flutter widgets
   - **State Management**: Cubits (using flutter_bloc)

### Data Flow

1. UI interacts with **Cubits** in the Presentation Layer
2. **Cubits** call Use Cases in the Domain Layer
3. **Use Cases** communicate with **Repositories**
4. **Repositories** communicate with **Data Sources**
5. **Data Sources** call APIs or access local storage

## Code Style Guidelines

### Architecture Principles

- Follow **SOLID principles**
- Keep functions, classes, use cases, and widgets small and focused
- Use explicit typing for variables, parameters, and return types
- Prioritize readability above all

### Naming Conventions

- **Classes**: PascalCase (`SignInCubit`, `AuthenticationRepository`)
- **Methods**: camelCase (`getTokenBundle()`, `signInUser()`)
- **Variables**: camelCase (`authenticationRepository`)
- **Constants**: `k` prefix (`kTokenBundleKey`)
- **Private Members**: `_` prefix (`_saveTokens()`)

### Widget Structure

Divide widgets into smaller components if they get too complex:
```
calendar/
  calendar.dart
  _header.dart
  _day_cell.dart
```

### Required Packages

The following packages are mandatory for the project:
- `freezed` (for immutable models and unions)
- `get_it` (for dependency injection)
- `flutter_bloc` (for state management using Cubits)
- `go_router` (for routing management)
- `dartz` (for functional programming and error handling)
- `mocktail` (for testing and mocking dependencies)

## Pull Request Process

1. Ensure your code follows our style guidelines
2. Write and run tests for new functionality
3. Update documentation as necessary
4. Follow the commit message convention:

```
[project] <type>(<scope>): <short summary>

<optional detailed description>

<optional issue/task reference>
```

### Commit Types

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
- **delete**: Deleting files/code/features

## Testing Guidelines

We use the following testing strategy:
- **Unit Tests**: For business logic and use cases
- **Widget Tests**: For UI components
- **Integration Tests**: For feature workflows

Run tests with: `flutter test`

