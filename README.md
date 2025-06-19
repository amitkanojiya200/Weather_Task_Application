# flutter_application_1

File Structure 
lib/
├── app.dart
├── main.dart
│
├── models/
│   ├── task_model.dart
│   └── task_model.g.dart
│
├── providers/
│   ├── theme_provider.dart
│   ├── task_provider.dart
│   └── weather_provider.dart
│
├── services/
│   ├── weather_service.dart
│   └── notification_service.dart (unused now)
│
├── views/
│   ├── task_form.dart
│   ├── task_screen.dart
│   ├── weather_screen.dart
│   └── settings_screen.dart



# 🌦️ Weather & Task Planner App (Flutter)

A cross-platform Flutter app that combines **real-time weather info** with a **daily task planner** — built for productivity and convenience.

## 🚀 Features

### 🔸 Weather Forecast
- Search any city
- Real-time temperature, description & weather icon
- Auto-loads last searched city on launch
- Powered by OpenWeatherMap API

### 🔸 Task Planner
- Add tasks with title, description, date & time
- Edit, delete, or mark complete/incomplete
- Filter by: Today | Upcoming | Completed
- Tasks saved locally using Hive (works offline)

### 🔸 UI / UX
- Clean, modular UI with 3 tabs:
  - Weather | Tasks | Settings
- Light/Dark Mode toggle using Provider

---

## 🛠️ Setup Instructions

### 1. Clone the Repo
```bash
git clone https://github.com/YOUR_USERNAME/weather_task_planner.git
cd weather_task_planner
```

Install Dependencies :- flutter pub get
Generate Hive Adapter :- dart run build_runner build

Add Weather PI Key :- final String apiKey = '5804c693770ea8d087efebd79a3ab2a5';
Else Create your own key with :- https://openweathermap.org/api

To run the App :- flutter run -d chrome  OR   press F5 

Dependecies :- 
```
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.0
  shared_preferences: ^2.2.2
  http: ^0.13.6
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_local_notifications: ^16.3.0
  intl: ^0.19.0
  build_runner: ^2.4.6
  hive_generator: ^2.0.1
  timezone: ^0.9.2
```



