# Account Atlas - Your Accounts, Your Services, One Place

  

A Flutter-based mobile application for managing digital subscriptions and account information in one place.

  

## Download
(Currently available on Google Play. The iOS version is under review.)
  

| App Store | Google Play |
|---|---|
| [<img width="120" height="40" alt="App Store" src="https://github.com/user-attachments/assets/2d85e984-1949-4262-9aae-63f36ca00726" />](https://apps.apple.com/us/app/account-atlas-track-accounts/id6758081039) | [<img width="120" height="40" alt="Google Play" src="https://github.com/user-attachments/assets/bcc419e6-1d8c-44bf-b5df-1454f3c89df9" />](https://play.google.com/store/apps/details?id=co.novelus.accountatlas) |

  

## About

### Screenshots

<p align="center">

<img width="18%"  alt="home-1" src="https://github.com/user-attachments/assets/615b90c8-494d-44d9-a198-d3fdb85528b1" />

<img width="18%"  alt="home-2" src="https://github.com/user-attachments/assets/f786b525-a911-4ba0-b02f-2adb3c9654ee" />

<img width="18%"  alt="account-detail" src="https://github.com/user-attachments/assets/9417ac21-e54e-4ef9-84ce-d036bcedaaf8" />

<img width="18%"  alt="services" src="https://github.com/user-attachments/assets/524ec14d-4f2d-49ff-a1f6-90c8f30373cd" />

<img width="18%"  alt="service-detail" src="https://github.com/user-attachments/assets/19f0a094-969a-4ffd-9b04-4164fc9ed3bc" />

</p>

  

### Concept

AccountAtlas helps you manage all your digital subscriptions and account credentials in one place.

Register your accounts, connect them to your services, and see everything organized clearly—by category, subscription status, and account. No bank connections needed—your data stays on your device.

  

### Recommended For

- Users managing multiple accounts across different services

- People who want to track their subscription spending at a glance

- Anyone who wants to know which account is linked to which service

- People who want to see monthly/yearly fixed costs and upcoming payment dates

  

## Key Features

  

### 1. Dashboard

- Monthly and yearly spending totals

- Top expense categories by percentage

- Upcoming payment notifications with D-day display

- Active subscription count

  

### 2. Account Management

- Register accounts (Email, Phone, Google, Apple, GitHub, Facebook, etc.)

- View all services linked to each account

- Track spending per account

  

### 3. Service Management

- Add/edit/delete services and subscriptions

- Category-based organization (Video, Music, Shopping, Tool, SNS, AI, Game, Education, Others)

- Support for monthly and yearly billing cycles

- Service catalog with pre-configured popular services

  

### 4. Search & Filter

- Filter by category, subscription status, or price

- Sort by recently added, highest/lowest cost

- Real-time total calculation as you filter

  

## Tech Stack & Architecture

  

### Architecture

```

lib/

├── core/

│ ├── app/ # App configuration and shell

│ ├── config/ # Environment configuration (dev/prod)

│ ├── constants/ # Colors, spacing, text sizes

│ ├── router/ # Navigation (go_router)

│ ├── storage/ # Database and mock data

│ ├── theme/ # App theme and gaps

│ └── utils/ # Formatters and helpers

├── features/

│ ├── accounts/ # Account management feature

│ │ ├── data/ # Datasources, DTOs, mappers, repositories

│ │ ├── domain/ # Entities, usecases, enums, failures

│ │ └── presentation/ # Views, ViewModels, state, widgets

│ ├── services/ # Service/subscription management

│ │ ├── data/

│ │ ├── domain/

│ │ └── presentation/

│ ├── home/ # Dashboard feature

│ │ ├── domain/

│ │ └── presentation/

│ ├── analytics/ # Spending analytics

│ ├── settings/ # App settings

│ └── shared/ # Shared widgets and utilities

└── main.dart # App entry point

```

  

### Design Patterns

- **Clean Architecture**: Separation of data, domain, and presentation layers

- **MVVM Pattern**: Model-View-ViewModel for presentation layer

- **Repository Pattern**: Data source abstraction

- **Riverpod**: Reactive state management

  

### Database

- **SQLite (sqflite)**: Local data persistence

- Three main tables: `accounts`, `account_services`, `plans`

- Relational structure: Account → Services → Plans (1:N relationships)

  

## Dependencies

  

### Core Packages

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^3.0.3 | State management |
| `go_router` | ^17.0.0 | Declarative routing |
| `sqflite` | ^2.4.2 | SQLite database |
| `path_provider` | ^2.1.5 | File system paths |

  

### UI/UX Packages

| Package | Version | Purpose |
|---------|---------|---------|
| `intl` | ^0.20.2 | Date/currency formatting |
| `font_awesome_flutter` | ^10.12.0 | Icon library |
| `url_launcher` | ^6.3.2 | External links |

  

### Development Packages

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_native_splash` | ^2.4.7 | Splash screen |
| `flutter_launcher_icons` | ^0.14.4 | App icon generation |
| `build_runner` | ^2.10.4 | Code generation |

  

## Environment Setup

  

### Development/Production Environments

Environment configuration via `lib/core/config/env_config.dart`.

  

```bash

# Development (with mock data)

flutter run --dart-define=ENV=dev

  

# Production

flutter run --dart-define=ENV=prod

```

## Contributing

Contributions are welcome! If you have suggestions for improvements or find bugs, please feel free to open an issue or submit a pull request.

1.  **Fork** the Project
2.  **Create** your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  **Commit** your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  **Push** to the Branch (`git push origin feature/AmazingFeature`)
5.  **Open** a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.
  

---
