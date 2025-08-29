# Student APK

This directory contains the source code for the student-facing Flutter application.

## Folder Overview (top-level)

- android/: Android-specific project files and Gradle configuration.
- assets/: Images, fonts and other static assets used by the app.
- build/: Flutter build outputs.
- ios/: iOS platform-specific project files.
- lib/: Main Dart source code (documented below).
- test/: Unit and widget tests.
- web/: Web-specific configuration (if used).

## /lib — Complete structure

The following is the precise layout of the lib directory and the purpose of each file/folder:

lib/
├── main.dart                     # App entrypoint: initializes services, DI, routes
├── routes.dart                   # Centralized route names and RouteFactory
├── theme.dart                    # App ThemeData, color & typography tokens
├── screens/                      # All UI screens and page routes
│   ├── dashboard_page.dart       # Student dashboard (landing after login)
│   ├── get_started_page.dart     # Onboarding / welcome flow
│   ├── loading.dart              # Generic loading screen / placeholder
│   ├── login.dart                # Login form and auth logic integration
│   ├── profile_page.dart         # View/edit student profile
│   ├── settings_page.dart        # App and account settings
│   ├── forgot_pass_pages/        # Password recovery flow
│   │   ├── forgot_password_step1.dart   # Email input + send OTP
│   │   ├── forgot_password_step2.dart   # OTP verification
│   │   └── forgot_password_step3.dart   # New password entry
│   ├── materials_pages/         # Study material browsing and viewers
│   │   ├── files_page.dart              # File list & downloads
│   │   ├── materials_page.dart          # Overview of materials per subject
│   │   ├── subject_content_page.dart    # Chapter/content viewer
│   │   └── subject_page.dart            # Subject list and navigation
│   └── sign_up_pages/           # Multi-step signup flow
│       ├── signup_step1_page.dart
│       ├── signup_step2_page.dart
│       ├── signup_step3_page.dart
│       ├── signup_step4_page.dart
│       └── verification_complete_page.dart
├── utils/                       # Helper utilities and constants
│   ├── fonts.dart                # Font family definitions and helpers
│   └── ui_constants.dart         # Colors, paddings, durations, common styles
└── widgets/                     # Reusable widgets & UI primitives
    ├── arcanum_logo.dart
    ├── common_widgets.dart
    ├── glass_frame.dart
    ├── triangle_logo.dart
    └── triangle_painter.dart

## Detailed descriptions (separate from folder tree)

This section explains responsibilities, interactions, and expected behavior for each major sub-area in lib/. Use this as a reference for implementing, testing, or extending features.

1) App entry & routing
- main.dart: boots the app, initializes any required services (analytics, storage, HTTP client), sets up the Theme and calls runApp(). Keep initialization lightweight; complex async setup should show a native/splash screen.
- routes.dart: exposes named routes and a RouteFactory that maps route names to Widgets. Contains navigation helpers used across the app.

2) Screens
- dashboard_page.dart
  - Displays personalized content: enrolled subjects, recent materials, announcements.
  - Fetches summary data from backend when opened and shows placeholders while loading.
  - Should use Pull-to-Refresh and deep-link handlers where applicable.

- get_started_page.dart
  - Onboarding slides or one-time welcome flow. Sets a persisted flag when complete.

- loading.dart
  - Generic full-screen loading widget used during heavy async init or long-running actions.

- login.dart
  - Contains the login Form widget, validation logic, and calls the auth API via a central service (api helper in utils or an auth service if present in future).
  - Handles error states and shows inline field errors + global snackbars.

- sign_up_pages/*
  - Multi-step sign up flow separated per page to keep forms small. Each step validates its inputs and aggregates state into a temporary DTO (in-memory model or local provider/state management). The final step performs a submit to the registration endpoint and shows verification_complete_page.dart.

- forgot_pass_pages/*
  - Three-step password recovery: email -> OTP -> reset. Each page handles its own validations and transitions to the next step on success.

- materials_pages/*
  - materials_page.dart: shows subjects or categories. Offers search and sort. Uses subject_page.dart to drill down.
  - subject_page.dart: lists chapters/topics for a subject; page links to subject_content_page.dart.
  - subject_content_page.dart: renders content for a chapter — may embed a PDF viewer, video player, or display text content. Provide download/share actions.
  - files_page.dart: lists all downloadable files and shows upload history or server-provided meta.

- profile_page.dart & settings_page.dart
  - profile_page.dart: view & edit basic user information, profile image upload (use multipart upload / cloud storage endpoints).
  - settings_page.dart: preference toggles (notifications, dark mode, etc.) and logout action.

3) utils/
- fonts.dart: central place to declare and reference custom fonts used across the app.
- ui_constants.dart: keep color palette, text styles, spacing constants, animation durations, and commonly used InputDecoration/BoxDecoration builders. Import this file rather than hardcoding values in Widgets.

4) widgets/
- common_widgets.dart: shared UI primitives (primary button, text input wrappers, list tiles with icons, empty state widget, error cards).
- glass_frame.dart: a composable container that implements the frosted glass effect used in the app's visual language.
- triangle_* files: decorative components and custom painters used in app branding.

5) Integration points & suggestions
- Networking: There is no dedicated services/ folder in this APK; place centralized API helpers in utils/api_helper.dart (create this file if adding new network logic). Keep token storage in secure local storage and refresh logic centralized.
- State management: The project currently uses page-level StatefulWidgets. For larger features (materials viewer, chat), adopt Provider, Riverpod, or Bloc for predictable state flows.
- Tests: Add unit tests for utils/ and widget tests for common_widgets.dart and form validation logic in login and signup pages.

## Quick development notes
- Keep UI code small and pull repetitive styles/behavior into widgets/ and utils/.
- Document any added services or models in this README when created.

## Key files
- pubspec.yaml — dependency and asset configuration
- lib/main.dart — app entry
- lib/routes.dart — navigation map
