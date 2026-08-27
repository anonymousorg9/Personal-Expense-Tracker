# Personal Finance Tracker

A modern, responsive personal finance tracking application built with **Flutter and Dart**.

The project is being developed incrementally with a clean architecture, a modern UI design system, light/dark theme support, automated testing, and a meaningful Git/GitHub commit history.

> **Project status:** 🚧 Under active development

---

## 📌 Project Overview

The Personal Finance Tracker is designed to help users monitor their income, expenses, budgets, spending patterns, and overall financial health through a clean and intuitive interface.

The application will progressively include:

* Dashboard and financial summary
* Income and expense tracking
* Transaction management
* Categories
* Budgets
* Reports and analytics
* Light and dark themes
* Local data persistence
* Secure application features
* Responsive layouts
* Testing
* Production-ready release

---

## 🎯 Current Progress

| Stage                     | Status      |
| ------------------------- | ----------- |
| Flutter SDK installation  | ✅ Completed |
| Dart environment setup    | ✅ Completed |
| Git configuration         | ✅ Completed |
| Android Studio setup      | ✅ Completed |
| Android SDK configuration | ✅ Completed |
| Flutter project creation  | ✅ Completed |
| GitHub repository         | ✅ Completed |
| Initial Git commit        | ✅ Completed |
| Project architecture      | ✅ Completed |
| Design system foundation  | ✅ Completed |
| Light theme foundation    | ✅ Completed |
| Dark theme foundation     | ✅ Completed |
| Basic application shell   | ✅ Completed |
| Dashboard                 | 🚧 Next     |
| Transactions              | ⏳ Planned   |
| Budgets                   | ⏳ Planned   |
| Reports                   | ⏳ Planned   |
| Local persistence         | ⏳ Planned   |
| Security                  | ⏳ Planned   |
| Testing expansion         | ⏳ Planned   |
| Release build             | ⏳ Planned   |

---

## 🛠️ Tech Stack

### Frontend

* Flutter
* Dart
* Material 3

### Development Tools

* Visual Studio Code
* Android Studio
* Git
* GitHub
* Google Chrome

### Packages Currently Used

* `provider`
* `go_router`
* `intl`

Additional packages will be introduced only when required by a feature.

---

## 📁 Project Structure

The application follows a feature-first structure:

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       ├── app_typography.dart
│       └── theme_controller.dart
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── extensions/
│   └── utils/
│
├── features/
│   ├── dashboard/
│   ├── transactions/
│   ├── budgets/
│   ├── reports/
│   ├── categories/
│   └── settings/
│
├── shared/
│   ├── widgets/
│   └── models/
│
└── main.dart
```

The structure will evolve as features are implemented.

---

## 🎨 Design Direction

The selected visual direction is:

**Modern Clean**

The application is being designed with:

* Clean layouts
* Strong visual hierarchy
* Rounded cards
* Consistent spacing
* Material 3 components
* Financial data visualization
* Minimal visual clutter
* Responsive layouts
* Light and dark themes

### Theme Modes

The application supports:

* System theme
* Light mode
* Dark mode

The theme system is centralized so the entire application can respond consistently to theme changes.

---

## 💻 Development Environment

The development environment is intentionally organized to keep large development files on the `E:` drive.

```text
E:\Development
├── Flutter
│   └── flutter
│
├── Android
│   └── SDK
│
├── Gradle
│
└── Projects
    └── personal_finance_tracker
```

The Flutter SDK and project are stored on the `E:` drive, while required Windows applications such as Git, Android Studio, and Visual Studio may remain installed on `C:`.

---

## 🌐 Current Development Target

For day-to-day development, the application is currently tested using Flutter Web.

Run:

```bash
flutter run -d web-server
```

Flutter provides a local development URL which can be opened in Google Chrome.

This allows rapid UI development and hot reload without requiring the Android emulator to remain running.

---

## ▶️ Running the Project

Clone the repository:

```bash
git clone https://github.com/anonymousorg9/Personal-Expense-Tracker.git
```

Navigate into the project:

```bash
cd Personal-Expense-Tracker
```

Install dependencies:

```bash
flutter pub get
```

Analyze the project:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Run the application in Chrome:

```bash
flutter run -d web-server
```

---

## 🧪 Testing

The project includes Flutter tests and is checked with:

```bash
flutter analyze
```

and:

```bash
flutter test
```

Current foundation status:

```text
flutter analyze → No issues found
flutter test    → All tests passed
```

Testing will be expanded as new features are implemented.

---

## 📜 Git Development History

The project is intentionally developed through meaningful commits so that the repository shows the progression of the application.

### Commit 1

```text
chore: initialize flutter project
```

Established the initial Flutter project and repository.

### Commit 2

```text
chore: establish project architecture and design system
```

Introduced the feature-first project structure, application foundation, Material 3 theme system, typography, colors, and light/dark theme support.

### Upcoming

```text
feat: build responsive app shell and dashboard
```

The next stage will replace the foundation screen with the first complete finance dashboard experience.

---

## 🗺️ Development Roadmap

```text
Project Initialization
        ↓
Architecture + Design System ✅
        ↓
Responsive App Shell
        ↓
Dashboard
        ↓
Transactions
        ↓
Categories
        ↓
Budgets
        ↓
Reports & Analytics
        ↓
Local Persistence
        ↓
Security
        ↓
Testing
        ↓
UI/UX Polish
        ↓
Release Build
```

---

## 📌 Project Goals

The goal is not only to create a functional Flutter application, but to demonstrate:

* Clean Flutter development
* Reusable UI architecture
* Responsive design
* State management
* Theme management
* Testing
* Git/GitHub workflow
* Incremental feature development
* Attention to UI/UX
* Production-oriented project organization

---

## 👨‍💻 Author

**Adithya Salaka**

Built with Flutter and Dart.

---

## 📄 License

This project is currently being developed as a personal/academic portfolio project.
