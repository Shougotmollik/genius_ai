# genius_ai

A comprehensive Flutter application designed for bar and restaurant management, featuring inventory tracking, recipe management, supplier coordination, and an AI-powered chatbot assistant.

## 🚀 Features

- **Inventory Management**: Track ingredients, stocks, and purchases for both bars and restaurants.
- **Recipe & Menu System**: Manage complex recipes and menu items with detailed cost analysis.
- **Supplier Coordination**: Maintain supplier profiles, track orders, and manage procurement workflows.
- **AI Chatbot**: Intelligent assistant to help manage operations and answer queries.
- **Authentication & User Management**: Secure login and role-based access for staff and administrators.
- **Real-time Notifications**: Stay updated with order statuses and inventory alerts.
- **Data Analytics**: Visual charts and reports for sales and performance (via `fl_chart`).
- **Media Support**: Integrated image picking, cropping, and compression for product/ingredient photos.

## 📁 Project Structure

The project follows a modular structure using the GetX pattern:

- **`lib/config`**: Application-wide configurations and environment settings.
- **`lib/constants`**: Global constants, including string literals and UI styling tokens.
- **`lib/controller`**: GetX controllers handling business logic and state management.
- **`lib/model`**: Data models and serialization logic for API interactions.
- **`lib/services`**: Core services for API communication, local storage, and connectivity.
- **`lib/utils`**: Helper classes and utility functions for common tasks.
- **`lib/view`**:
    - `bar/`: UI components and screens specifically for bar operations.
    - `restaurant/`: UI components and screens for restaurant management.
    - `onboarding/`: Authentication and initial setup screens.
    - `widgets/`: Reusable UI components used across the application.
- **`lib/main.dart`**: The application entry point.
- **`lib/controller_binding.dart`**: Centralized dependency injection using GetX bindings.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **UI Scaling**: [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- **Networking**: [http](https://pub.dev/packages/http) with [pretty_http_logger](https://pub.dev/packages/pretty_http_logger)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Icons & Graphics**: [flutter_svg](https://pub.dev/packages/flutter_svg)
- **Utils**: [intl](https://pub.dev/packages/intl), [excel](https://pub.dev/packages/excel), [pinput](https://pub.dev/packages/pinput)

## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.10.0 or higher)
- [Dart SDK](https://dart.dev/get-started/sdk)
- Android Studio / VS Code with Flutter extension

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/Shougotmollik/genius_ai.git
    cd genius_ai
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

## 🎨 Assets

- **Fonts**: Inter (Regular, Medium, Bold)
- **Icons**: SVG-based custom icons in `assets/icons/`
- **Images**: Branding and placeholder images in `assets/image/` and `assets/logo/`

---
*Built with ❤️ for better hospitality management.*
