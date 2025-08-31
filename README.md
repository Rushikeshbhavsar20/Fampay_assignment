# FamPay Flutter Assignment - Contextual Cards

## Project Overview

This Flutter application demonstrates the implementation of a **Contextual Cards Container** - a plug-and-play component that displays dynamic cards based on API responses. The cards are rendered using JSON data from a backend API, making them completely configurable and dynamic.

## What We Built

- **Standalone Container**: A reusable component that displays a list of contextual cards
- **Dynamic Rendering**: Cards are rendered based on JSON responses from the API
- **Plug-and-Play**: Can be integrated into any screen/widget independently
- **Multiple Card Types**: Supports various design types (HC1, HC3, HC5, HC6, HC9)
- **Interactive Features**: 
  - Deep link handling for cards and CTAs
  - Long press actions on Big Display Cards (HC3)
  - Remind Later functionality (cards reappear on next app start)
  - Dismiss functionality (cards are permanently hidden)

## Features

✅ **Dynamic Card Rendering** - Cards adapt to API responses  
✅ **Multiple Design Types** - HC1, HC3, HC5, HC6, HC9  
✅ **Deep Link Handling** - All URLs and CTAs are functional  
✅ **Interactive Actions** - Remind Later & Dismiss functionality  
✅ **State Management** - BLoC pattern with proper state handling  
✅ **Persistence** - User preferences are saved locally  
✅ **Responsive Design** - Adapts to different screen sizes  

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── bloc/                             # Business Logic Components
│   ├── feed_bloc.dart               # Main BLoC for feed management
│   ├── feed_event.dart              # Events for feed actions
│   └── feed_state.dart              # States for feed UI
├── data/                             # Data Layer
│   ├── feed_repository.dart         # API communication
│   └── models/                      # Data models
│       ├── card_group.dart          # Card group structure
│       ├── card_model.dart          # Individual card model
│       ├── cta.dart                 # Call-to-action model
│       └── formatted_text.dart      # Rich text formatting
└── ui/                              # User Interface
    ├── contextual_cards_container.dart  # Main container widget
    ├── theme/                       # Theme and Design System
    │   └── app_theme.dart          # Centralized theme constants
    ├── constants/                   # Application Constants
    │   └── app_constants.dart      # API endpoints, keys, defaults
    └── widgets/                     # Individual card widgets
        ├── hc1_small_display.dart   # HC1 card implementation
        ├── hc3_big_display.dart     # HC3 card with actions
        ├── hc5_image_card.dart      # HC5 image card
        ├── hc6_small_arrow.dart     # HC6 arrow card
        ├── hc9_dynamic_width.dart   # HC9 dynamic width card
        └── formatted_text_widgets.dart # Rich text rendering                    
```

## Installation & Setup

### Prerequisites
- Flutter SDK (>=2.18.0)
- Dart SDK
- Android Studio / VS Code
- Git

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fampay_assignment
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## Dependencies

The project uses the following key dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3      # State management
  http: ^0.13.6             # API communication
  shared_preferences: ^2.2.2 # Local storage
  url_launcher: ^6.1.14     # Deep link handling
  flutter_svg: ^2.0.9       # SVG image support

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0   # Code quality and linting
```

## API Integration

The app fetches card data from Provided api by fampay


The API returns JSON data containing:
- Card groups with different design types
- Individual card properties (images, colors, text, CTAs)
- Deep link URLs for navigation

## Card Types Implementation

### HC1 - Small Display
- Compact card layout
- Basic information display
- CTA button integration

### HC3 - Big Display
- Large card with rich content
- Long press reveals action buttons
- Remind Later & Dismiss functionality

### HC5 - Image Card
- Image-focused card design
- Background image support


### HC6 - Small Arrow
- Arrow-based navigation card


### HC9 - Dynamic Width
- Adaptive width based on content
- Flexible layout system

## State Management

The app uses **BLoC (Business Logic Component)** pattern:

- **FeedBloc**: Manages feed data and user interactions
- **FeedEvent**: Defines user actions (fetch, refresh, dismiss, remind)
- **FeedState**: Represents UI states (loading, loaded, error)

## Local Storage

User preferences are persisted using `SharedPreferences`:
- **Dismissed Cards**: Permanently hidden cards
- **Snoozed Cards**: Temporarily hidden (reappear on app restart)

## URLs Link Handling

All URLs in the API response are handled:
- Card click actions
- CTA button navigation
- Formatted text entity links


## Build & Deploy

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```


## Key Implementation Details

1. **Modular Architecture**: Each card type is implemented as a separate widget
2. **Responsive Design**: Cards adapt to different screen sizes and orientations
3. **Error Handling**: Graceful fallbacks for API failures and parsing errors
4. **Performance**: Efficient rendering with proper widget keys and state management
5. **Accessibility**: Proper semantic labels and navigation support

## 📄 License
This project is created  as part of the FamPay Flutter assignment.

## 📱APK Download

-You can directly install and test the app using the pre-built APK:
[Download App](https://drive.google.com/drive/folders/1-njz5qKlfYKe-KtTMw1OmAWQSJfxt1l-?usp=drive_link)


Built with ❤️ using Flutter !
