# Investor Deal Management App

A mini investment deal management application built with Flutter, focusing on clean architecture, BLoC state management, and a premium fintech UI.

## Features
- **Mock Authentication**: Secure session-based login with persistent storage.
- **Deal Feed**: Browse investment opportunities from various industries with high-performance filtering.
- **Search & Advanced Filtering**: Efficient search by company name and filters for ROI, Risk Level, and Industry.
- **Dynamic Details**: Comprehensive deal overview including financial highlights and an ROI projection graph.
- **Interest Tracking**: Express interest in deals and manage them in a dedicated 'My Interests' dashboard.
- **Rich UI/UX**: Modern design system using Google Fonts, custom color tokens, smooth animations (flutter_animate), and data visualizations (fl_chart).

---

## 🏗 Architecture
This project follows **Clean Architecture** principles to ensure separation of concerns and maintainability:

### Layers:
1.  **Domain (Core Logic)**:
    - Entities: Plain Dart objects for business data models.
    - Repositories: Interfaces defining the contract for data operations.
2.  **Data (Implementation)**:
    - Models: Data transfer objects with JSON serialization.
    - Repositories: Implementation of domain interfaces, handling both local persistence and remote mock data.
    - Data Sources: Logic for fetching data from the assets (JSON) and SharedPreferences.
3.  **Presentation (UI & State)**:
    - BLoCs: Handle all business logic and state transitions (Auth and Deal management).
    - Screens & Widgets: Purely UI components that react to BLoC states.

### State Management:
- **BLoC (Business Logic Component)**: Used for robust state handling.
- **GetIt**: Service locator for dependency injection.

---

## 🛠 Tech Stack
- **State Management**: `flutter_bloc`
- **Navigation & DI**: `GetIt`, `Material Routing`
- **Local Persistence**: `shared_preferences`
- **Typography & Icons**: `google_fonts`, `cupertino_icons`
- **Analytics/Charts**: `fl_chart`
- **Animations**: `flutter_animate`
- **Data Integrity**: `equatable`

---

## 🚀 Getting Started

### Prerequisites:
- Flutter SDK (>= 3.0.0)
- Dart SDK

### Installation:
1.  Clone the repository.
2.  Run `flutter pub get` to install dependencies.
3.  Run the application using `flutter run`.

### Mock Credentials:
- Any email and a password of at least 6 characters will work.
- Try: `investor@example.com` / `password123`

---

## 📱 Screenshots & UX
The UI leverages a deep-blue "Premium Fintech" palette, utilizing clear typography and subtle micro-animations for a high-end feel.
- **Login**: Smooth fade-in and slide-up animations for the credentials card.
- **Deal Cards**: Clean layouts with color-coded risk indicators.
- **Detail View**: Interactive charts and structured financial breakdowns.
