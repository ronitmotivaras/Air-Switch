Air Switch - IoT-Based Light and Fan Control System 🌐💡🌀

Air Switch is an innovative IoT solution that allows users to control household appliances like lights and fans remotely. Developed with a Flutter mobile application and NodeMCU microcontroller, this project integrates modern IoT technologies to enable smart home automation.

🌟 Key Features
Light Control: Toggle the light on/off using the mobile app or voice commands.
Fan Control: Adjust fan speed (0 to 255) via the app or voice commands.
Voice Commands: Hands-free operation with integrated voice control.
Real-Time Status Updates: Get live feedback on device states (e.g., light status or fan speed).
Wi-Fi Connectivity: Seamless communication between the app and devices via NodeMCU.
User-Friendly Interface: Intuitive Flutter app for easy control.

🚀 Technology Stack
Microcontroller: NodeMCU (ESP8266)
Programming: Arduino (C/C++), Dart
Mobile App: Flutter Framework
Connectivity: Wi-Fi
Communication Protocol: RESTful API (HTTP)
Hardware Components:
Relay Module
L298N Motor Driver
12V Fan
AC Light

📚 How It Works
The NodeMCU microcontroller connects to a Wi-Fi network and interacts with the appliances.
A Flutter-based mobile app sends commands to the NodeMCU via RESTful APIs.
The fan’s speed is controlled using Pulse Width Modulation (PWM), while the light is toggled with simple on/off commands.
Real-time updates on appliance status are displayed in the app.

⚠️ Limitations
Wi-Fi Dependency: Requires a direct connection to the NodeMCU's hotspot.
Limited Range: Restricted to the Wi-Fi signal range of the NodeMCU.
No User Authentication: No differentiation between users or personalized settings.
.
🛠️ Setup Instructions
Compile and upload the NodeMCU firmware using the Arduino IDE.
Run the Flutter app on your device.
.

🤝 Contributions
Contributions are welcome! Feel free to open an issue or submit a pull request to improve this project.
