# CliniX Dashboard (Frontend UI)

> A Flutter UI prototype for monitoring the CliniX Intelligent Power Management System.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android__%7C__iOS__%7C__Web-blue)
![Status](https://img.shields.io/badge/Status-UI%20Prototype%20(Mock%20Data)-important)
![License](https://img.shields.io/badge/License-MIT-teal)
![Languages](https://img.shields.io/badge/Languages-Tamil%20|%20Telugu%20|%20Hindi%20|%20Marathi%20|%20English-brightgreen)

A beautiful and responsive Flutter dashboard designed for the **CliniX** system. This frontend prototype demonstrates the user interface for remote monitoring of power sources (Grid, Solar, Battery, Generator), displaying voltage metrics, battery status, and system logs, all powered by realistic mock data.

##  App Demo

Watch the UI Showcase in this demo video

<p align="center">
  <img src="/Application/media/app_demo.gif" alt="CliniX App Demo" width="300"/>
</p>

##  Screen Gallery

<div align="center">
  <table>
    <tr>
      <td align="center"><strong>Splash Screen</strong></td>
      <td align="center"><strong>Role Selection</strong></td>
      <td align="center"><strong>Login Screen</strong></td>
      <td align="center"><strong>Dashboard</strong></td>
      <td align="center"><strong>Battery</strong></td>
      <td align="center"><strong>Log Data</strong></td>
      <td align="center"><strong>Settings</strong></td>
    </tr>
    <tr>
      <td><img src="/Application/media/Splash_Screen.png" width="200"></td>
      <td><img src="/Application/media/Role_Selection.png" width="200"></td>
      <td><img src="/Application/media/Login_Screen.png" width="200"></td>
      <td><img src="/Application/media/Dashboard.png" width="200"></td>
      <td><img src="/Application/media/Battery.png" width="200"></td>
      <td><img src="/Application/media/Log_Data.png" width="200"></td>
      <td><img src="/Application/media/Settings.png" width="200"></td>
    </tr>
  </table>
</div>

##  Features

1. **Modern UI/UX:** Clean, intuitive interface built with Flutter's Material Design.
2. **Live Data Simulation:** Mock voltage graphs and battery metrics that simulate real-time data.
3. **Power Source Tracking:** Visualizes the current active power source (Grid, Solar, Battery, Generator).
4. **Predicted Backup Time:** Displays estimated battery runtime during outages.
5. **Historical Logs:** View a history of power source switching events.
6. 6. **Multilingual Interface:** Full support for **English, Tamil, Hindi, Telugu, and Marathi**, ensuring accessibility for rural clinics and diverse communities. This feature makes the app **inclusive, user-friendly, and highly impactful** in real-world healthcare scenarios.  


## Getting Started

### Prerequisites

1. **Flutter SDK:** Ensure you have Flutter installed on your machine. This project is built with Flutter 3.13.0+.
2. **An IDE:** such as Android Studio, VS Code, or IntelliJ IDEA with the Flutter plugin.

### Installation & Running the App

1.  **Navigate to the dashboard directory** from the project root:
    ```bash
    cd dashboard
    ```

2.  **Install the project dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application on your preferred device:**
    ```bash
    # Run on a connected Android device/emulator
    flutter run

    # Run in a web browser
    flutter run -d chrome

    # Run on an iOS simulator (macOS only)
    flutter run -d iPhone
    ```

The app will launch with a 5-second splash screen and then proceed to the login screen. You can use any credentials to log in and view the mock dashboard.

## Project Structure
```bash
/Application/ # Flutter Application
 ├── /lib/
 │ └── main.dart
 │ └── localizations/
 │       └── app_localizations.dart
 ├── /media/
 │ ├── Battery.png
 │ ├── Dashboard.png
 │ ├── Log_Data.png
 │ ├── Splash_Screen.png
 │ └── app_demo.gif
 ├── FLUTTER_README.md
 ├── pubspec.lock
 └── pubspec.yaml
```

## Data Flow (Mock Implementation)

This is a **frontend-only prototype**. All data is generated locally to simulate a connected backend.

1. **Dashboard Data:** The `DashboardScreen()` uses a `_generateDummyData()` method to create a list of `FlSpot` points, simulating voltage readings over time.
2. **Battery Data:** The `BatteryScreen()` displays hardcoded values for battery charge (82%) and backup time (3 hrs 45 mins).
3. **Log Data:** The `LogDataScreen()` displays a static list of `ListTile` widgets with example timestamps and power sources.

## UI/UX Overview

The design prioritizes clarity and user trust in a critical environment:
1. **Color Scheme:** Uses a professional teal/white theme, with red/orange/green in the voltage chart to intuitively signal status.
2. **Navigation:** Simple bottom navigation bar for switching between the three main sections.
3. **Data Visualization:** Utilizes the `fl_chart` package to render a clear, informative line graph for voltage monitoring.

## Future Integration Plan

This UI is structured to be easily connected to a live backend. The integration path would involve:

1.  **Adding Data Models:** Creating formal Dart model classes (e.g., `PowerData`, `BatteryStatus`, `LogEntry`) in a `models/` directory.
2.  **Implementing State Management:** Introducing a state management solution like `Provider` or `Bloc` to manage the app's state and fetch data.
3.  **Creating Services:** Adding a `services/` directory with classes to handle API calls (REST, MQTT, or WebSockets) to the CliniX hardware gateway.
4.  **Replacing Mock Data:** Swapping the hardcoded values and dummy data generators with calls to the new services.

## Building for Production

You can build this prototype into a standalone application for demonstration.

1. **Build an Android APK:**
```bash
flutter build apk --release
```
2. **Build for Web**
```bash
flutter build web --release
# The built files will be in the `/build/web` directory and can be deployed to any web server.
```
## Dependencies
This project uses the following key packages (as defined in pubspec.yaml):

> flutter: The core framework.

> fl_chart: For rendering the interactive voltage line chart.

> telephony: (Planned for future SMS features).

> permission_handler: (Planned for handling device permissions).

For information about the hardware system this UI is designed to monitor, including the PLC, ESP32, and AI model, please see the main README.md.

## License
This project is part of the CliniX Power Management System. See main repository for licensing details.







