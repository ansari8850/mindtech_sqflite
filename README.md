# mindtech_task

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

// PACKAGE I HAVE USE , PATTERN I HAVE FOLLOW , STATEMANAGEMENT I HAVE USE , DATABASE I HAVE / HELP I HAVE TAKEN FROM 

# Flutter User Management App(MindTech Task)




| `get` | ^4.7.2 | State management, routing aur dialogs ke liye use kiya gaya hai. Simple aur powerful hai. |
| `sqflite` | ^2.4.1 | Local database (SQLite) access ke liye. Users ko save karne ke liye use kiya. |
| `email_validator` | ^3.0.0 | Email input ko validate karne ke liye. |
| `intl` | ^0.20.2 | Date formatting ke liye use kiya. Jaise date of birth select karne ke time. |
| `path` | ^1.9.0 | File path manage karne ke liye (DB location ke liye zaruri). |

---

## 🏗️ Architecture - MVC Pattern

App me **MVC** (Model-View-Controller) pattern follow kiya gaya hai:

### ✅ Model
- File: `user_model.dart`
- Ye class user ka structure define karta hai (name, email, dob, mobile, etc.).
- Includes `toMap()` and `fromMap()` methods — SQLite ke liye helpful.

### ✅ View
- Ye UI part hai — `Form`, `TextFormFields`, `ListView`, etc.
- Validation, input aur display yahi handle karta hai.
- View me directly koi business logic nahi hota.

### ✅ Controller
- File: `user_controller.dart`
- Sabhi business logic yaha likha gaya hai (form validation, DB calls, state updates).
- `GetX` ka use karke reactive programming implement kiya gaya hai (`Rx` variables).
- Controllers automatically UI ko notify karte hain jab data change hota hai.

---

## 💡 Features

- Form validation for name, email, mobile and DOB.
- Minimum age check (DOB se age calculate karte hain, minimum 20 required hai).
- Local database (SQLite) me data store hota hai.
- `GetX` ke dialogs aur snackbar use kiye gaye hain for better user interaction.
- Clean and modular code base — easily scalable.

---
