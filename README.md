# 📰 Flutter News Reader

A **News Reader App** built with **Flutter** following **Clean Architecture** principles and **BLoC state management**.  
The app fetches news from multiple sources, caches them locally, and gracefully handles errors (e.g., falling back to cached data).

[⬇️ Download Release APK](https://limewire.com/d/QTJDL#1mEdkNBMTY)
---

## ✨ Features
- Fetches aggregated news from multiple sources (Microsoft, Apple, Google, Tesla).
- Clean Architecture (Domain, Data, Presentation layers).
- State management using **flutter_bloc**.
- Local caching for offline support.
- Error handling (fallback to cached data when network fails).
- Unit tests & BLoC tests.
- Network requests with **Dio**.
- Image rendering with **CachedNetworkImage** (with a default fallback image).

---

## 📂 Project Structure

```
lib/
 ┣ core/                # Common utilities, helpers, configs
 ┣ data/                # Models, data sources, repositories implementations
 ┃ ┣ datasources/       # Local & Remote data sources (Dio, shared prefs)
 ┃ ┣ models/            # Data models (API response, ArticleModel)
 ┃ ┗ repositories/      # Repository implementation
 ┣ domain/              # Entities, Repository interfaces, UseCases
 ┣ presentation/        # UI layer, BLoC, Widgets, Screens
 ┣ main.dart            # Entry point
```

### Clean Architecture Layers
1. **Domain Layer**
    - Entities (core business objects).
    - UseCases (application-specific business rules).
    - Abstract repositories.

2. **Data Layer**
    - Repository implementations.
    - Data sources (remote API with Dio, local storage).
    - Models (converting JSON <-> Entities).

3. **Presentation Layer**
    - BLoC for state management.
    - UI (Flutter widgets, pages).

---

## 📚 Dependencies

Key Flutter packages used in this project:

- **flutter_bloc** – BLoC state management
- **equatable** – Value equality for entities & states
- **dio** – HTTP client for networking
- **cached_network_image** – Image caching with placeholders & error fallback
- **bloc_test** – Testing utilities for BLoC
- **mocktail&mock** – Mocking for unit tests
- **flutter_test** – Default Flutter testing framework

---

## 🛠 Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.0)
- Dart SDK
- Android Studio / VS Code
- Android Emulator / Physical Device

---

## ▶️ Run the Project

```bash
# Get dependencies
flutter pub get

# Run on emulator or device
flutter run
```

---

## 🧪 Run Tests

```bash
flutter test
```

Includes:
- Repository tests
- UseCase tests
- BLoC tests

---

## 📦 Build Release APK / AAB

Note: Steps 1–3 (keystore generation, key.properties, and Gradle configuration) are already done in this project. You only need to run Step 4 to build the Android release output

### 1. Generate Keystore
```bash
keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
```

### 2. Create `key.properties`
In `android/` folder:

```properties
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=my-key-alias
storeFile=../app/my-release-key.jks
```

### 3. Configure `build.gradle.kts`
Already configured to load `key.properties` and sign the release build.

### 4. Build APK or AppBundle
```bash
# Build release APK
flutter build apk --release

# Build release AAB (for Play Store)
flutter build appbundle --release
```

Output files will be located in:
- `build/app/outputs/flutter-apk/`
- `build/app/outputs/bundle/release/`

---

