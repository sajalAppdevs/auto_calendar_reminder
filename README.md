# Auto Calendar Reminder

A Flutter application that demonstrates integration testing in action through a practical calendar reminder implementation. This project serves as an educational resource for understanding how to implement and structure integration tests in Flutter applications.

## Features

- Create and manage calendar event reminders
- Material Design 3 UI with modern aesthetics
- Persistent data storage using SharedPreferences
- Comprehensive integration tests demonstrating best practices
- Drag-to-delete functionality for reminder management

## Project Structure

```
├── lib/
│   ├── data/           # Data layer implementation
│   ├── presentation/   # UI components and controllers
│   └── main.dart       # Application entry point
├── integration_test/   # Integration test cases
│   ├── app_test.dart
│   ├── home_screen_test.dart
│   ├── create_option_screen_test.dart
│   └── test_util.dart
└── test/              # Widget tests
```

## Getting Started

### Prerequisites

- Flutter SDK (>=2.18.1 <3.0.0)
- Dart SDK
- Android Studio/VS Code with Flutter plugins

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Testing

This project showcases different types of tests:

### Integration Tests

Run integration tests with:
```bash
flutter test integration_test
```

The integration tests cover:
- Home screen functionality
- Create option screen interactions
- Navigation testing
- UI state management
- Data persistence

### Widget Tests

Run widget tests with:
```bash
flutter test
```

## Dependencies

- shared_preferences: ^2.0.15 (Data persistence)
- intl: ^0.17.0 (Date formatting)
- flutter_test: Testing utilities
- integration_test: Integration testing framework
- network_image_mock: ^2.1.1 (Testing utilities)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
