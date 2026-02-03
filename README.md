# 🎧 Aurawear - Premium Audio E-Commerce App

A beautiful Flutter mobile application for browsing and purchasing premium audio equipment, built with **Clean Architecture** and **BLoC** pattern for scalability and maintainability.

## 📱 Project Overview

Aurawear is a UI demo project showcasing a modern e-commerce experience with a stunning **rose/pink aesthetic**. The app features product browsing, detailed views, and is structured for easy expansion into a full-stack application.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/               # Shared resources
│   ├── constants/      # App & API constants
│   ├── theme/          # Design system (colors, typography, theme)
│   ├── utils/          # Helper functions
│   ├── routes/         # Navigation & routing
│   └── error/          # Error handling & exceptions
│
├── features/           # Feature modules (layered architecture)
│   ├── products/
│   │   ├── domain/         # Business logic layer
│   │   │   ├── entities/       # Business objects
│   │   │   ├── repositories/   # Repository interfaces
│   │   │   └── usecases/       # Use cases
│   │   ├── data/           # Data layer
│   │   │   ├── models/         # Data models
│   │   │   ├── repositories/   # Repository implementations
│   │   │   └── datasources/    # Data sources (local/remote)
│   │   └── presentation/   # UI layer
│   │       ├── bloc/           # BLoC state management
│   │       ├── pages/          # Screens
│   │       └── widgets/        # Reusable components
│   │
│   ├── home/           # Home feature (same structure)
│   └── cart/           # Cart feature (placeholder for future)
│
└── shared/             # Shared UI components
    └── widgets/
```

## 🎨 Design System

### Color Palette
- **Primary**: Rose/Pink theme (`#E8B4B8`)
- **Accents**: Coral, Peach, Mint, Lavender
- **Text**: Dark gray, secondary gray, white
- **Functional**: Success, error, warning, info colors

### Typography
- Material 3 design system
- Responsive text styles (display, headline, title, body, label)
- Custom styles for prices, buttons, and hero sections

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.1 or higher)
- Dart SDK
- IDE (VS Code / Android Studio)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Aurawear
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc` ^8.1.6 - State management
- `equatable` ^2.0.7 - Value equality
- `dartz` ^0.10.1 - Functional programming (Either, Option)

### Future Dependencies (Commented)
- `dio` / `http` - HTTP client for API calls
- `shared_preferences` / `hive` - Local storage

## 🗂️ Project Features

### Current Features
- ✅ Professional folder structure
- ✅ Clean architecture setup
- ✅ Rose/pink theme configuration
- ✅ Product domain & data layers
- ✅ Mock product data
- ✅ Navigation setup
- ✅ Error handling framework

### Planned Features
- 🔜 Home screen UI
- 🔜 New arrivals page
- 🔜 Product detail page
- 🔜 Product widgets (cards, chips, color selector)
- 🔜 BLoC implementation
- 🔜 Search functionality
- 🔜 Cart feature
- 🔜 Backend API integration

## 🎯 Scalability

This architecture is designed for scalability:

1. **Easy to add features**: Copy the feature folder structure
2. **Ready for BLoC**: State management infrastructure in place
3. **Prepared for API**: Remote data sources ready for integration
4. **Testable**: Clean separation allows for comprehensive testing
5. **Maintainable**: Single responsibility principle throughout

## 📝 Development Guidelines

### Adding a New Feature
1. Create feature folder: `lib/features/[feature_name]`
2. Add domain layer (entities, repositories, use cases)
3. Add data layer (models, data sources, repository implementation)
4. Add presentation layer (BLoC, pages, widgets)

### Code Organization
- Keep business logic in domain layer (pure Dart, no Flutter)
- UI code only in presentation layer
- Data fetching only in data layer
- Use dependency injection for flexibility

## 🤝 Contributing

This is a demo project showing best practices in Flutter development with clean architecture.

## 📄 License

This project is for educational and demonstration purposes.

---

**Built with ❤️ using Flutter & Clean Architecture**
