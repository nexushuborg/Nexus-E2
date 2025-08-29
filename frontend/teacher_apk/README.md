# Teacher APK

This directory contains the source code for the teacher-facing Flutter application.

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
├── models/                       # Data models and in-memory DTOs
│   └── signup_data.dart          # Teacher signup/register DTO and validators
├── screens/                      # All UI screens and page routes
│   ├── dashboard_page.dart       # Teacher dashboard (overview, stats, announcements)
│   ├── get_started_page.dart     # Onboarding / welcome flow
│   ├── loading.dart              # Generic loading screen / placeholder
│   ├── Login.dart                # Login form and auth logic integration
│   ├── profile_page.dart         # View/edit teacher profile and credentials
│   ├── settings_page.dart        # App and account settings
│   ├── upload_notes.dart         # Material upload & management UI
│   ├── forgot_pass_pages/        # Password recovery flow
│   │   ├── forgot_password_email.dart   # Email input + send OTP
│   │   ├── forgot_password_otp.dart     # OTP verification
│   │   └── new_password.dart            # New password entry
│   └── sign_up_pages/           # Multi-step signup flow
│       ├── signup_step1_page.dart
│       ├── signup_step2_page.dart
│       ├── signup_step3_page.dart
│       └── verification_complete_page.dart
├── services/                     # API and backend integration services
│   └── api_service.dart          # REST client, auth token handling, file upload helpers
├── utils/                        # Helper utilities and constants
│   └── ui_constants.dart         # Colors, paddings, durations, common styles
└── widgets/                      # Reusable widgets & UI primitives
    ├── arcanum_logo.dart
    ├── common_widgets.dart
    ├── glass_frame.dart
    ├── triangle_logo.dart
    └── triangle_painter.dart

## Detailed descriptions (separate from folder tree)

This section explains responsibilities, interactions, and expected behavior for each major sub-area in lib/. Use this as a reference for implementing, testing, or extending features.

1) App entry & routing
- main.dart: boots the app, initializes required services (secure storage, HTTP client, analytics), configures global error handlers, and calls runApp(). Keep long-running init behind a splash screen.
- routes.dart: centralized route registry mapping route names to Widgets and handling route guards (auth checks) where needed.

2) Models
- signup_data.dart: DTO to accumulate sign-up form state across multiple pages, includes JSON serialization helpers and local validation methods.

3) Services
- api_service.dart:
  - Central REST client that wraps HTTP calls, attaches auth headers, and handles common error mapping.
  - Exposes methods used by screens: login(), register(), uploadFile(), getMaterials(), etc.
  - Implements retry/backoff and standardizes response parsing.

4) Screens
- dashboard_page.dart
  - Shows teacher-specific information: uploaded materials summary, pending verifications, recent student activity, and quick actions (upload, announcements).
  - Uses cards and lists with pull-to-refresh and paginated lists for long feeds.

- upload_notes.dart
  - UI for selecting subject/topic, picking files (PDF, images, videos), adding metadata (title, description), and triggering upload via services/api_service.uploadFile().
  - Shows upload progress and result, with retry on failure.
  - Supports batch uploads and draft saving.

- Login.dart
  - Handles credential input and two-factor/OTP flows if enabled.
  - Stores auth tokens securely and navigates to dashboard on success.

- sign_up_pages/*
  - Multi-step registration with client-side validation on each step. The collected data is stored in models/signup_data.dart and submitted at the final step.

- forgot_pass_pages/*
  - Email -> OTP -> new password flow with resend OTP and throttling UI.

- profile_page.dart & settings_page.dart
  - Profile editing (name, bio, contact), document uploads for verification, and toggles for notifications, theme, and account management (delete account, logout).

5) utils/
- ui_constants.dart: centralize all UI tokens (primary/secondary colors, text styles, radiuses, paddings, durations) to ensure consistent styling.

6) widgets/
- common_widgets.dart: shared UI elements like primary/secondary buttons, form field wrappers, card components, list tiles, progress indicators, and confirmation dialogs.
- glass_frame.dart: reusable container implementing frosted glass visuals.
- branding widgets (triangle_logo, arcanum_logo): small, self-contained components used by multiple screens.

7) Integration points & suggestions
- Networking: api_service.dart should be the single source for network calls. Keep authentication token refresh logic there and use secure storage for tokens.
- File uploads: use multipart uploads with progress events; consider leveraging backend chunked upload API for large files.
- State management: for forms and upload flows consider using Provider or Riverpod to manage transient state across multiple screens.
- Tests: add unit tests for services and models, widget tests for common widgets and form validation flow.

## Quick development notes
- Keep UI small and reuse widgets from widgets/ and values from utils/.
- Document any new services, models, or significant UI components in this README.

## Key files
- pubspec.yaml — dependency and asset configuration
- lib/main.dart — app entry
- lib/routes.dart — navigation map
- lib/services/api_service.dart — central networking integration
