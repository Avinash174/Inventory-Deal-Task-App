# Investor Deal App

A cross-platform investment deal management application built with Flutter. This project demonstrates a robust implementation of Clean Architecture, BLoC state management, and modern UI design principles.

## Features

- **Authentication**: Local session-based login and signup with persistent storage.
- **Deal Dashboard**: Browse curated investment opportunities with real-time search.
- **Advanced Filtering**: Filter deals by ROI, Risk Level, Industry, and Availability (Open/Closed).
- **Deal Analysis**: Detailed view for each company including ROI projection charts and risk breakdowns.
- **Interest Tracking**: Express interest in specific deals with local persistence and a dedicated interest dashboard.
- **Responsive UI**: Clean, minimalist fintech-style design using Google Fonts and custom themed components.

## Technical Implementation

### Architecture

The project follows the **Clean Architecture** pattern to ensure a high level of testability and scalability:

- **Domain Layer**: Contains the core business logic, including Entities and abstract Repository definitions.
- **Data Layer**: Handles data retrieval from local assets (JSON-based mock API) and persists user state via `SharedPreferences`.
- **Presentation Layer**: Utilizes the **BLoC (Business Logic Component)** pattern for predictable state transitions and UI updates.

### State Management
- **flutter_bloc**: Decouples business logic from UI components.
- **GetIt**: Implements dependency injection for repositories and data sources.
- **Equatables**: Used for efficient value-based comparisons within states and events.

## Project Structure

```text
lib/
├── auth/            # Authentication feature (UI, BLoC, Repository)
├── deals/           # Investment deals feature (Detail views, Feed, Logic)
├── core/            # Common theme, base errors, and utility classes
└── main.dart        # Application entry point & dependency initialization
```

## Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK

### Setup
1. Clone the repository.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Launch the application:
   ```bash
   flutter run
   ```

### Credentials
For testing, you can use any email and a password of 6+ characters.
- **Email**: `investor@example.com`
- **Password**: `password123`

## Implementation Decisions

- **Local Data**: Used a JSON asset file to simulate a REST API backend with artificial latency (1500ms) to showcase loading states.
- **ROI Visualization**: Integrated `fl_chart` for dynamic projection graphs.
- **Persistence**: Used `SharedPreferences` to maintain the user session and save 'Interested' markings across app restarts.
