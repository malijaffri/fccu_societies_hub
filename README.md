# 🎓 FCCU Societies Hub

A cross-platform mobile application built with **Flutter** that serves as a centralized hub for student societies at **Forman Christian College University (FCCU), Lahore**. The app lets students discover societies, browse posts and events, engage with comments, and participate in campus life — all in one place.

---

## 📱 Screenshots

> _Add screenshots here after building the app._

---

## ✨ Features

- **Authentication** — Register and log in with Firebase Auth. Guest browsing mode supported.
- **Home Feed** — Browse posts from all societies in a scrollable, card-based feed.
- **Societies** — View all FCCU student societies and explore their individual profiles.
- **Events** — Discover upcoming society events with dates, locations, and details.
- **Posts** — View post details with media grids, reactions, and comment threads.
- **Comments** — Comment on posts (authenticated users only; guests are prompted to sign up).
- **Create Post** — Compose posts with text, media, and society tagging.
- **Create Event** — Schedule events with date/time pickers and location fields.
- **Search** — Global search across posts and societies with filter chips.
- **Profile & Settings** — View your profile, manage account settings, and sign out.
- **Dark Mode** — Full light and dark theme support with a clean green-tinted palette.
- **Session Management** — Role-aware routing for authenticated, guest, and logged-out states.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart SDK `^3.10.8`) |
| State Management | Riverpod (`flutter_riverpod ^3.3.1`) |
| Navigation | GoRouter (`^17.2.3`) |
| Backend / Auth | Firebase Auth, Cloud Firestore, Firebase Storage |
| Image Handling | `image_picker`, `cached_network_image`, `flutter_image_compress` |
| Camera | `camera ^0.12.0+1` |
| Local Storage | `shared_preferences ^2.5.5` |
| Utilities | `uuid`, `intl`, `timeago`, `equatable`, `path_provider` |
| Markdown | `flutter_markdown_plus` |
| Permissions | `permission_handler` |

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── router/          # GoRouter setup & route definitions
│   ├── theme/           # App colors, spacing, radius, theme config
│   ├── timeago_messages/
│   ├── utils/
│   └── widgets/         # Shared widgets (scaffold, error, loading, etc.)
│
└── features/
    ├── auth/            # Login, register, welcome screens + Firebase auth
    ├── comments/        # Comment threads, composer, guest prompt
    ├── create_event/    # Event creation form + widgets
    ├── create_post/     # Post composer with media picker + society selector
    ├── events/          # Events list screen + event cards
    ├── feed/            # Home feed screen
    ├── posts/           # Post detail, post card, media grid, reactions
    ├── profile/         # Profile screen + settings
    ├── search/          # Search screen with filter chips
    ├── session/         # Session mode (authenticated / guest / logged out)
    ├── societies/       # Society list, society detail, society cards
    └── users/           # User model, user providers, user repository
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.10.8`)
- A Firebase project with **Authentication**, **Firestore**, and **Storage** enabled
- Android Studio / Xcode (for running on device/emulator)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/malijaffri/fccu_societies_hub.git
   cd fccu_societies_hub
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   - Go to the [Firebase Console](https://console.firebase.google.com/) and create a project.
   - Enable **Email/Password** authentication.
   - Create a **Firestore** database and **Storage** bucket.
   - Download the config files and place them:
     - `google-services.json` → `android/app/`
     - `GoogleService-Info.plist` → `ios/Runner/`
   - Run FlutterFire CLI to generate `firebase_options.dart`:
     ```bash
     dart pub global activate flutterfire_cli
     flutterfire configure
     ```

4. **Run the app**

   ```bash
   flutter run
   ```

---

## 🏛️ Architecture

The app follows a **feature-first** folder structure with a clean separation of concerns:

- **Repositories** — Abstract data-source interfaces with both Firestore (production) and mock (development/testing) implementations.
- **Providers** — Riverpod providers that expose data streams and state to the UI.
- **Screens** — Full-page views composed of smaller, reusable widgets.
- **Session Layer** — A dedicated `session` feature manages authentication state and controls route redirection (authenticated → home, logged out → welcome, guest → limited access).

---

## 🎨 Design

The app uses a **green-tinted FCCU-inspired** color palette:

| Token | Color |
|---|---|
| Primary | `#229A86` |
| Secondary | `#56CD9E` |
| Light Background | `#F6FBF8` |
| Dark Background | `#0F1513` |

---

## 🔐 Authentication Flow

```
App Launch
    │
    ├── Logged Out  →  /welcome  →  /login or /register
    │
    ├── Guest Mode  →  Browse feed, societies, events (read-only)
    │                  Prompted to sign up on interaction
    │
    └── Authenticated  →  Full access (create posts, events, comment, profile)
```

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

---

## 👥 Team

Developed by students of **Forman Christian College University, Lahore, Pakistan**.

- **Mali Jaffri** — [@malijaffri](https://github.com/malijaffri)

---

## 📄 License

This project is private and not published to pub.dev. All rights reserved.
