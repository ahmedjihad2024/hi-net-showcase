# HiNet — Premium eSIM Marketplace

HiNet is a state-of-the-art Flutter application designed for purchasing and managing eSIMs globally. This repository serves as a **UI/UX and Architectural Showcase**, demonstrating modern Flutter development practices.

## 🚀 Project Overview
This app provides a seamless experience for users to:
* Browse and search for eSIM plans by country or region.
* Purchase plans using various payment methods (Apple Pay, Credit Cards).
* Manage active and expired eSIMs with detailed usage tracking.
* High-performance UI with smooth animations and responsive design.

## 🏗️ Architecture & Structure
The project follows **Clean Architecture** principles combined with **MVVM** for state management (Bloc/Riverpod), ensuring maintainability and scalability.

### Folder Structure
*   **`lib/presentation`**: Contains the UI layer (Views, Widgets, Blocs).
    *   `views/`: Feature-based UI modules (Home, Checkout, etc.).
    *   `res/`: Resource management (Colors, Fonts, Assets).
    *   `common/`: Reusable UI components and utilities.
*   **`lib/domain`**: *(Hidden)* Business logic, models, and repository interfaces.
*   **`lib/data`**: *(Hidden)* Implementation of repositories, API calls (Dio), and data persistence.
*   **`lib/app`**: Core application configurations and dependency injection.

---

## 🔒 Private Implementation Note
> [!IMPORTANT]
> To protect proprietary business logic and sensitive security configurations, the implementation details within the **Data** and **Domain** layers, as well as several utility modules, have been intentionally **hidden** (emptied).
> 
> The **Presentation layer** remains visible to demonstrate:
> * UI/UX implementation quality.
> * Modular feature organization.
> * State management patterns.
> * Custom widget design and animations.

---

## 🛠️ Tech Stack
* **Language**: Dart / Flutter
* **State Management**: BLoC & Riverpod
* **Networking**: Dio (with Interceptors)
* **Localizations**: Easy Localization
* **UI Utilities**: ScreenUtil, Svg, Shimmer, Smooth Corner

---
*Created with ❤️ by Ahmed Jihad*
