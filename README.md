# PennyVault

**PennyVault** is a complete, modern "Privacy-First" Personal Expense Tracker built with Flutter. It's designed to run entirely in the browser, ensuring your financial data never leaves your device.

## Core Features
- **Privacy-First (Offline-First Web):** Uses [Hive](https://pub.dev/packages/hive) to store all transaction records locally in the browser's IndexedDB. Your data is yours and yours alone.
- **Data Visualization:** Beautiful, animated charts powered by [fl_chart](https://pub.dev/packages/fl_chart) to help you understand your spending habits at a glance.
- **Responsive Design:** Optimized for both Desktop (split view) and Mobile (single column).
- **Modern UI:** A clean "Fintech" aesthetic with full support for Light and Dark modes.
- **Classic State Management:** Built using the [Provider](https://pub.dev/packages/provider) pattern for predictable and efficient UI updates.

## Technical Stack
- **Framework:** Flutter (Web)
- **State Management:** Provider (ChangeNotifier)
- **Persistence:** 
  - **Hive:** For high-performance storage of transaction records.
  - **Shared Preferences:** For simple user settings (e.g., theme preference).
- **Architecture:** MVVM (Model-View-ViewModel) to maintain a clean separation of concerns.

## Why this Stack?

### Why Provider?
Provider was chosen for its simplicity and robustness within this project's scope. It allows for clean, reactive updates without the overhead of more complex state management solutions, making it ideal for a focused utility app like PennyVault.

### Offline-First Web
By leveraging Hive, PennyVault stores data directly in the browser. Unlike traditional web apps that rely on cloud backends, PennyVault's offline-first approach ensures that:
1. **Speed:** Instant data access and saves.
2. **Privacy:** No financial data is ever transmitted to a server.
3. **Availability:** The app works even without an internet connection once loaded.

## How to Run locally

1. Ensure you have [Flutter installed](https://docs.flutter.dev/get-started/install).
2. Clone the repository and navigate to the project directory.
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run -d chrome
   ```

## Development
To regenerate the data storage adapters (when modifying models):
```bash
dart run build_runner build --delete-conflicting-outputs
```