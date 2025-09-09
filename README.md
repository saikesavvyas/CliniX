# CliniX

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![GitHub issues](https://img.shields.io/github/issues/saikesavvyas/CliniX)
![GitHub stars](https://img.shields.io/github/stars/saikesavvyas/CliniX)
![GitHub forks](https://img.shields.io/github/forks/saikesavvyas/CliniX)
![App: Flutter](https://img.shields.io/badge/App-Flutter-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/Platform-Android__%7C__iOS__%7C__Web-lightgrey)
![Hardware: PLC](https://img.shields.io/badge/Hardware-PLC-green)
![Microcontroller: ESP32](https://img.shields.io/badge/Microcontroller-ESP32-red)
![AI: Python](https://img.shields.io/badge/AI-Python-blue)

An Industry-Grade, end-to-end IoT solution designed to guarantee an uninterrupted and intelligently managed power supply for critical medical equipment in remote clinics. The system automates source switching and load management, predicts energy needs with AI, and provides full remote oversight via a cross-platform dashboard.

## Table of Contents

- [About The Project](#about-the-project)
  - [Key Features](#key-features)
  - [System Architecture](#system-architecture)
- [Hardware Bill of Materials (BOM)](#hardware-bill-of-materials-bom)
- [Software & Firmware](#software--firmware)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Hardware Setup & Wiring](#hardware-setup--wiring)
  - [Installation & Configuration](#installation--configuration)
- [Usage](#usage)
  - [Normal Operation](#normal-operation)
  - [AI-Powered Predictive Switching](#ai-powered-predictive-switching)
  - [SMS Alert System](#sms-alert-system)
  - [Remote Dashboard App](#remote-dashboard-app)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)

## About The Project

Rural clinics face significant challenges due to unstable power grids, directly impacting patient care and vaccine preservation. This project provides a life-saving, robust, smart, and remotely accessible power management system that ensures continuity of critical medical services with minimal human intervention.

### Key Features

*   **Four-Source Automatic Switching:** Seamless transition between **Grid (Primary)**, **Solar (Secondary)**, **Battery (Tertiary)**, and **Generator (Fallback)** based on availability.
*   **Three-Tier Priority Load Management:** Intelligent load-shedding to prioritize life-saving equipment.
    *   **Tier 1 (Critical):** Refrigerators, Ventilators, ICU equipment. *Never shed.*
    *   **Tier 2 (Important):** Lighting, Fans, Communication devices. *Shed after Tier 3.*
    *   **Tier 3 (Non-Critical):** Air Conditioning, Water Heaters. *Shed first.*
*   **AI-Driven Predictive Power Management:** A machine learning model forecasts weather conditions to proactively manage energy, switching to battery *before* solar output drops due to clouds.
*   **GSM-Based SMS Alerts:** An ESP32 with a GSM module sends real-time SMS alerts to clinic staff for critical events like grid failure, low generator fuel, or total power loss.
*   **Cross-Platform Remote Dashboard:** A Flutter application provides real-time remote monitoring and control from any device (Android, iOS, Web). View status, historical data charts, and execute manual overrides from anywhere.

### System Architecture

The following diagram illustrates the end-to-end flow of data and control in our system, from the physical power sources to the remote user's dashboard.

```mermaid
flowchart TD
    %% Define all nodes with icons and styling
    Grid[Grid Power]
    Solar[Solar Power]
    Battery[Battery Bank]
    Generator[Generator]

    PLC[Central PLC<br>Main Controller]
    PLC_Logic[Source Switching Logic<br>Load Priority Management]

    ESP32[ESP32 Module<br>Data Gateway]
    GSM[GSM Module]

    Broker[MQTT Broker<br>Mosquitto/HiveMQ]
    AI[AI Prediction Server<br>Weather Forecast API]

    Flutter[Flutter Dashboard App<br>Android/iOS/Web]

    %% Define connections with protocol labels
    PowerSources <-->|Monitors & Controls| PLC
    PLC <-->|Modbus RTU/Ethernet| ESP32
    ESP32 <-->|SMS| GSM
    ESP32 <-..->|MQTT Pub/Sub| Broker
    ESP32 <-..->|HTTP REST API| AI
    Broker <-..->|MQTT over Internet| Flutter

    %% Group nodes with clean, minimal styling
    subgraph PowerSources [Power Sources]
        Grid
        Solar
        Battery
        Generator
    end

    subgraph ControlLayer [Control Layer]
        PLC
        PLC_Logic
    end

    subgraph GatewayLayer [Gateway Layer]
        ESP32
        GSM
    end

    subgraph CloudLayer [Cloud Services]
        Broker
        AI
    end

    subgraph ApplicationLayer [Application Layer]
        Flutter
    end

    %% Apply consistent styling
    classDef source fill:#f8f9fa,stroke:#495057,stroke-width:1.5px,color:#000
    classDef control fill:#e9ecef,stroke:#6c757d,stroke-width:1.5px,color:#000
    classDef gateway fill:#dee2e6,stroke:#495057,stroke-width:1.5px,color:#000
    classDef cloud fill:#f8f9fa,stroke:#495057,stroke-width:1.5px,color:#000
    classDef app fill:#e9ecef,stroke:#6c757d,stroke-width:1.5px,color:#000
    classDef protocol fill:#ffffff,stroke:#adb5bd,stroke-width:1px,color:#495057

    class Grid,Solar,Battery,Generator source
    class PLC,PLC_Logic control
    class ESP32,GSM gateway
    class Broker,AI cloud
    class Flutter app
```
## Hardware Bill of Materials (BOM)

| Component | Quantity | Description / Notes |
| :--- | :--- | :--- |
| **Programmable Logic Controller (PLC)** | 1 | e.g., Siemens LOGO!, Allen-Bradley Micro800, or any PLC with analog I/O and communication ports (Modbus). |
| **ESP32 Development Board** | 1 | Serves as communication gateway and SMS module controller. |
| **GSM Module (SIM800L / SIM900A)** | 1 | For sending SMS alerts. |
| **Voltage Sensors (AC & DC)** | 4 | To detect presence of Grid, Solar output, Battery voltage, Generator output. |
| **Contactors / Relays** | 6 | For switching loads between sources (4P) and shedding Tier 2/3 loads (2P). Rated for your clinic's current. |
| **DC Power Supply** | 1 | 24V/12V to power the PLC, ESP32, sensors, and contactor coils. |
| **Enclosure** | 1 | IP-rated enclosure for safety. |
| **Fuses, Terminal Blocks, Wiring** | - | As required. |

## Software & Firmware

This project involves multiple codebases:

1.  **PLC Logic:** Written in Ladder Logic, Function Block Diagram, or Structured Text (vendor-specific software, e.g., TIA Portal, CODESYS, OpenPLC).
2.  **ESP32 Firmware:** Written in C++ (Arduino Framework). Handles communication with the PLC, sending SMS, calling the AI API, and managing MQTT messages.
3.  **AI Weather Prediction Model:** A Python-based model (e.g., using Scikit-learn, TensorFlow) hosted on a server to predict solar irradiance.
4.  **Flutter Dashboard Application:** Written in Dart using the Flutter framework. Provides the UI for remote monitoring and control.

## Getting Started

### Prerequisites

*   **Hardware:** Components listed in the BOM.
*   **Software:**
    *   PLC programming software (specific to your PLC model).
    *   Arduino IDE or PlatformIO for ESP32 development.
    *   Flutter SDK for building the dashboard app.
    *   Python 3.x for the AI model.

### Hardware Setup & Wiring

**Warning: Working with mains voltage is extremely dangerous. If you are not a qualified electrician, consult one for the high-power wiring section.**

1.  **Source Inputs:** Connect Grid, Solar, Battery, and Generator lines to the main input contactors. Use voltage sensors on each line for detection.
2.  **Load Outputs:** Connect the critical load bus to the output of the source-switching contactors. Connect Tier 2 and Tier 3 loads to separate contactors controlled by the PLC for shedding.
3.  **PLC & ESP32:**
    *   Connect the voltage/current sensor outputs to the PLC's analog input channels.
    *   Connect the PLC's digital outputs to the contactor coils.
    *   Wire the ESP32 to the GSM module (TXD/RXD, GND, VCC).
    *   Establish a communication link (RS485 recommended) between the PLC and the ESP32.

### Installation & Configuration

1.  **Clone the repositories:**
    ```bash
    # For ESP32 Firmware
    git clone https://github.com/saikesavvyas/esp32-firmware-repo.git
    # For Flutter Dashboard
    git clone https://github.com/saikesavvyas/Application-repo.git
    # For AI Model
    git clone https://github.com/saikesavvyas/ai-model-repo.git
    ```

2.  **Configure the ESP32 Firmware:**
    *   Open the project in Arduino IDE/PlatformIO.
    *   Update `config.h` with your settings: WiFi credentials, API endpoint, and registered phone numbers.
    *   Upload the code to the ESP32.

3.  **Program the PLC:**
    *   Open the project file in your PLC software.
    *   Set the analog input scaling factors based on your sensor specifications.
    *   Define the Modbus holding registers for communication with the ESP32.
    *   Download the logic to the PLC.

4.  **Setup the Flutter Dashboard:**
    *   Navigate to the Flutter project directory.
    *   Run `flutter pub get` to install dependencies.
    *   Run `flutter run` to build and deploy to your device/emulator.

## Usage

### Normal Operation
1.  Power on the system. The PLC will perform a self-check.
2.  The system defaults to **Grid** power if available.
3.  If grid fails, it switches to **Solar**. Excess solar energy charges the battery.
4.  If solar is insufficient, it draws from the **Battery**.
5.  If the battery is depleted, it automatically starts the **Generator**.
6.  The PLC continuously monitors total load and sheds loads based on their priority tier.

### AI-Powered Predictive Switching
1.  The ESP32 queries the weather prediction API periodically.
2.  If cloudy weather is predicted, the ESP32 sends a command to the PLC.
3.  The PLC conserves battery or preemptively switches to ensure a smooth transition.

### SMS Alert System
The system sends automatic alerts for events like:
*   `[CLINIC POWER] CRITICAL: All sources down! Manual intervention required!`

### Remote Dashboard App
The Flutter dashboard provides a real-time view and control panel.
1.  **Dashboard View:** See the active power source, battery percentage, solar output, and load.
2.  **Historical Data:** View charts for energy usage and source availability over time.
3.  **Manual Control:** Authorized users can manually force a source switch or manage load tiers.

## Project Structure
```bash
/CliniX/
│
├── /firmware/ 
│ ├── /src/
│ │ ├── main.cpp
│ │ ├── modbus_handler.cpp
│ │ ├── sms_handler.cpp
│ │ ├── mqtt_handler.cpp n
│ │ └── config.h.example
│ └── platformio.ini
│
├── /Application/ 
│ ├── /android/
│ ├── /ios/
│ ├── /lib/
│ │ └── main.dart
│ │ └── services/
│       └── mqtt_service.dart 
│ ├── /linux/
│ ├── /macos/
│ ├── /media/
│ │ ├── Battery.png
│ │ ├── Dashboard.png
│ │ ├── Log_Data.png
│ │ ├── Splash_Screen.png
│ │ └── app_demo.gif
│ ├── /web/
│ ├── FLUTTER_README.md
│ ├── pubspec.lock
│ └── pubspec.yaml
│
├── /AI Model/ 
│ ├── ModelPrediction.py
│ ├── ModelTraining.py
│ └── requirements.txt
│
├── /PLC Simulation/ 
│ └── /CliniX Ladder Logic/      **REQUIRES ISPSOFT SOFTWARE TO ACCESS THE CONTENTS OF THE FOLDER**
│ └── /Images/                   **LADDER LOGIC SCREENSHOTS FOR REFERENCE ( IF ISPSOFT IS NOT AVAILABLE)**
│ 
├── LICENSE
└── README.md
```


## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch 
3. Commit your Changes 
4. Push to the Branch 
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` file for more information. **This license may not cover all regulatory safety requirements for medical equipment. Deploy at your own risk and ensure compliance with local electrical codes.**

## Contact

| Sai Kesav Vyas S | saikesavv@gmail.com |
| :--- | :--- |
| Heam Anand A | heamu08@gmail.com |
| Ashwathi Rangan V | ranganashwathi@gmail.com |
| Sharmila R | milasharmila2006@gmail.com |


Project Link: [https://github.com/saikesavvyas/CliniX](https://github.com/saikesavvyas/CliniX)

## Acknowledgements

*   [OpenPLC Project](https://www.openplcproject.com/)
*   [TinyGSM Library](https://github.com/vshymanskyy/TinyGSM)
*   [PubSubClient (MQTT) Library](https://github.com/knolleary/pubsubclient)
*   [Flutter MQTT Client](https://pub.dev/packages/mqtt_client)
*   Shoutout to healthcare workers in rural areas.
