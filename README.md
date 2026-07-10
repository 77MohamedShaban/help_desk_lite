# 🛠️ HelpDesk Lite

**HelpDesk Lite** is a production-ready internal support ticketing system built with Flutter and
Firebase. It provides a seamless experience for employees to report issues and for support agents
and managers to manage and resolve them efficiently.

---

## 📸 Screenshots
<div align="center">
    <table style="width:100%">
    <tr>
      <td>
         <img width="200" alt="Screenshot_20260711_010208" src="https://github.com/user-attachments/assets/adb7ac9b-2345-4d76-b249-918677e2944c" />
      </td>
       <td>
         <img width="200" alt="Screenshot_20260711_010254" src="https://github.com/user-attachments/assets/23e2d990-3de2-43d7-ae57-f2ccf37e1f79" />
      </td>
        <td>
<img width="200" alt="Screenshot_20260711_010242" src="https://github.com/user-attachments/assets/5f3140fa-c94c-45b1-9301-02ecd820d57f" />
      </td>
       <td>
         <img width="200"  alt="Screenshot_20260711_005614" src="https://github.com/user-attachments/assets/e1354399-c9fb-4fe3-8b33-ff706a1ff9c1" />
      </td>
      <td>
<img width="200" alt="Agint" src="https://github.com/user-attachments/assets/3f87b30d-62e1-4a2b-a540-2c1e82f04516" />
      </td>
       </tr>
  </table>
   <table style="width:100%">
    <tr>
          <td>
<img width="200" alt="Agint_2" src="https://github.com/user-attachments/assets/e2c3e717-f1dc-4c80-bf0a-cd5f6ebe571c" />
      </td>  
       <td>
<img width="200" alt="Screenshot_20260711_005405" src="https://github.com/user-attachments/assets/c8ddd84a-4af1-4905-8df9-a0d92d091b08" /> 
      </td>   
       <td>
<img width="200"  alt="Screenshot_20260711_005629" src="https://github.com/user-attachments/assets/05149ff4-e3c2-4a19-92c4-97dfe4cb42a0" />
      </td> 
       <td>
<img width="200" alt="Screenshot_20260711_005652" src="https://github.com/user-attachments/assets/7129cdce-28ae-4566-b6dd-b5d2eef7d505" />
      </td>  
       <td>
<img width="200" alt="Screenshot_20260711_005800" src="https://github.com/user-attachments/assets/874c9728-177b-48d2-9e70-688a1904c7ab" /> 
      </td>
       </tr>
  </table>
</div>
## 🚀 Features

### 🔐 Authentication & Roles

- **Multi-Role Support:** Separate workflows for **Employees**, **Support Agents**, and **Managers
  **.
- **Secure Login/Register:** Powered by Firebase Authentication.
- **Password Recovery:** Integrated password reset via email.
- **Session Management:** Persistent login with automatic redirection based on user roles.

### 🎫 Ticket Management

- **Employee Portal:** Create, view, and track personal tickets. Ability to delete own tickets with
  confirmation.
- **Support Agent Console:** View department-specific tickets, assign tickets to self, and update
  status (In Progress, Resolved, Closed).
- **Manager Dashboard:** Full overview of all tickets, system statistics, and ability to delete any
  ticket.
- **Priority & Categories:** Organize tickets by priority (Low to Urgent) and categories (IT, HR,
  Finance, etc.).

### 💬 Collaboration

- **Real-time Comments:** Add and view comments on tickets for better communication between
  employees and agents.

### 🎨 UI/UX

- **Modern Design:** Built with Material 3 and Google Fonts.
- **User-Friendly Errors:** Custom error handling that translates technical codes into readable
  messages.
- **Interactive Elements:** Confirmation dialogs for sensitive actions (Delete, Logout).
- **Native Splash & Icons:** Professionally configured launcher icons and splash screens.

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [BLoC (flutter_bloc)](https://pub.dev/packages/flutter_bloc)
- **Navigation:** [GoRouter](https://pub.dev/packages/go_router)
- **Backend:** [Firebase](https://firebase.google.com/) (Auth, Firestore, Cloud Messaging)
- **Dependency Injection:
  ** [GetIt](https://pub.dev/packages/get_it) & [Injectable](https://pub.dev/packages/injectable)
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
   git clone https://github.com/77MohamedShaban/help_desk_lite.git
   cd help_desk_lite
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup:**
    - Create a new Firebase project.
    - Add Android/iOS apps.
    - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them
      in respective folders.
    - Enable **Email/Password Auth** and **Cloud Firestore**.

4. **Code Generation:**
   Generate the DI and Model files:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app:**
   ```bash
   flutter run
   ```
