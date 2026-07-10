# 🛠️ HelpDesk Lite

**HelpDesk Lite** is a production-ready internal support ticketing system built with Flutter and Firebase. It provides a seamless experience for employees to report issues and for support agents and managers to manage and resolve them efficiently.

---

## 🚀 Features

### 🔐 Authentication & Roles
- **Multi-Role Support:** Separate workflows for **Employees**, **Support Agents**, and **Managers**.
- **Secure Login/Register:** Powered by Firebase Authentication.
- **Password Recovery:** Integrated password reset via email.
- **Session Management:** Persistent login with automatic redirection based on user roles.

### 🎫 Ticket Management
- **Employee Portal:** Create, view, and track personal tickets. Ability to delete own tickets with confirmation.
- **Support Agent Console:** View department-specific tickets, assign tickets to self, and update status (In Progress, Resolved, Closed).
- **Manager Dashboard:** Full overview of all tickets, system statistics, and ability to delete any ticket.
- **Priority & Categories:** Organize tickets by priority (Low to Urgent) and categories (IT, HR, Finance, etc.).

### 💬 Collaboration
- **Real-time Comments:** Add and view comments on tickets for better communication between employees and agents.

### 🎨 UI/UX
- **Modern Design:** Built with Material 3 and Google Fonts.
- **User-Friendly Errors:** Custom error handling that translates technical codes into readable messages.
- **Interactive Elements:** Confirmation dialogs for sensitive actions (Delete, Logout).
- **Native Splash & Icons:** Professionally configured launcher icons and splash screens.

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [BLoC (flutter_bloc)](https://pub.dev/packages/flutter_bloc)
- **Navigation:** [GoRouter](https://pub.dev/packages/go_router)
- **Backend:** [Firebase](https://firebase.google.com/) (Auth, Firestore, Cloud Messaging)
- **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it) & [Injectable](https://pub.dev/packages/injectable)
- **Code Generation:** Build Runner, Json Serializable.

---

## 📁 Project Structure

```text
lib/
├── core/              # Core utilities, constants, DI, and theme
│   ├── config/        # Router and app config
│   ├── constants/     # Enums and app constants
│   ├── di/            # Dependency injection setup
│   ├── theme/         # Global app theme
│   └── utils/         # Helper classes (Error handling, etc.)
├── features/          # Feature-based modules
│   ├── authentication/
│   ├── employee/      # Employee dashboard & logic
│   ├── manager/       # Manager tools & stats
│   ├── support/       # Agent specific features
│   ├── tickets/       # Core ticketing logic (Domain, Data, Presentation)
│   └── notifications/
└── main.dart          # Entry point
```

---

## 🏁 Getting Started

### Prerequisites
- Flutter SDK (`^3.11.5`)
- Firebase Account & Project

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/help_desk_lite.git
   cd help_desk_lite
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup:**
   - Create a new Firebase project.
   - Add Android/iOS apps.
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in respective folders.
   - Enable **Email/Password Auth** and **Cloud Firestore**.

4. **Code Generation:**
   Generate the DI and Model files:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Icons & Splash (Optional):**
   If you have added your assets:
   ```bash
   flutter pub run flutter_launcher_icons
   flutter pub run flutter_native_splash:create
   ```

6. **Run the app:**
   ```bash
   flutter run
   ```