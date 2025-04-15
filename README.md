# Fernwärts 📍
[![codecov](https://codecov.io/gh/ton-An/fernwaerts/graph/badge.svg?token=X5F77OEGXS)](https://codecov.io/gh/ton-An/fernwaerts)

A privacy-focused Flutter application that tracks your location history. It has an open codebase, is self hosted and a blast to use.

|   |   |   |
|---|---|---|
![](/docs/public/assets/screenshots/home.png)  |  ![](/docs/public/assets/screenshots/map.png) |  ![](/docs/public/assets/screenshots/map_modal.png)

## Features

- **Privacy First**: Your data remains under your control, whether used locally or self-hosted
- **Smart Insights**: Automatically categorizes visits by place, city, and country
- **Activity Recognition**: Identifies walking, cycling, running, and driving
- **Multi-platform**: Available for iOS, Android, macOS, Linux, and Web

## Getting Started (with the App)

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- An IDE (VS Code, Android Studio, etc.)

### Installation

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
   flutter run
   ```

## Getting Started (with the Server)

Coming soon... (Some things need to be done first. Like adding row level security to the database)

## Documentation

Comprehensive documentation is available at our [documentation site](https://ton-an.github.io/fernwaerts/). (In very early stages)

## Project Structure

This project follows the Clean Architecture pattern with three primary layers:

- **Data Layer**: Contains repositories and data sources (local and remote)
- **Domain Layer**: Houses business logic through use cases
- **Presentation Layer**: Manages UI components and state using Cubits

## Contributing

I welcome contributions. A contributor guide will be added soon.

## License
This project is dual-licensed:
- **MIT License** for general use, modification, and distribution.
- **Proprietary License** that reserves the exclusive right to publish on the **Google Play Store** and **Apple App Store** to the original author (Anton Heuchert).

Publishing to any other store, such as **AltStore**, **Aptoide**, or similar alternative platforms, is explicitly allowed under the MIT License.

By using this software, you agree to comply with both licenses. See `LICENSE` and `LICENSE.store` for full details.

**Your Journey, Your Data – Open, Private, Yours.**