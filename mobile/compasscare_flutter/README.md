# CompassCare Flutter Foundation

Flutter foundation for CompassCare mobile app (Android + iOS) with:
- Single backend configuration (no separate app environments)
- `flutter_bloc` state management
- `http` network client foundation
- `sqflite` local database foundation
- Base tab shell for the 5 app modules
- Light and dark theme toggle
- Milestone 2 data pipeline for Medications:
  - API fetch via `http`
  - Local cache in SQLite
  - Repository fallback to cache
  - Bloc-driven UI state
- Milestone 3 Medications functionality:
  - Add medication (validated form)
  - Mark medication as taken
  - Remove medication
  - Optimistic local state + SQLite sync
- Milestone 4 Appointments functionality:
  - Appointments list from API with SQLite cache fallback
  - Add appointment (validated form)
  - Remove appointment
  - Bloc operation states and success/error feedback
- Milestone 5 Documents + Care Team functionality:
  - Documents list with file-type icons and SQLite cache fallback
  - Care team list with online/offline status and SQLite cache fallback
  - Bloc state handling for loading/refresh/error feedback
- Milestone 6 Shopping functionality:
  - Shopping tab with featured links and category-based links
  - Personalized medication suggestions based on cached/remote medications
  - Graceful fallback to static links when personalization is unavailable
  - External link launch with in-app error handling
- Milestone 7 Shell UX enhancements:
  - App-level shell header state with `ShellHeaderCubit`
  - Care-team avatars shown in app bar across tabs
  - Online-status indicators and cached-data indicator in header
  - Header data sourced from repository with SQLite fallback path

## Run

From `mobile/compasscare_flutter`:

```bash
flutter pub get
```

### Run App

```bash
flutter run -t lib/main.dart
```

## API Base URL Override

By default, the app uses:

`https://asset-linker-graziellevoller.replit.app`

You can override at runtime with `--dart-define`:

```bash
flutter run -t lib/main.dart --dart-define=API_BASE_URL=https://your-backend.example.com
```

## Verify

```bash
flutter analyze
flutter test
```

## Milestone 2 Architecture (Medications sample)

```
UI (MedicationsPage)
  -> MedicationsBloc
    -> MedicationsRepository
      -> MedicationRemoteDataSource (http /api/medications)
      -> MedicationLocalDataSource (sqflite medications_cache)
```
