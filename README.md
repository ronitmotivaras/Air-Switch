Air Switch - IoT-Based Light and Fan Control System 🌐💡🌀
Air Switch is an innovative IoT project that enables seamless control of household appliances like lights and fans via a Flutter mobile app and a NodeMCU microcontroller. This system integrates IoT technologies with mobile and voice control to offer a smart home automation experience.

🌟 Key Features
Light Control: Toggle the light on/off using the app or voice commands.
Fan Control: Adjust fan speed from 0 to 255 using the app or voice commands.
Real-Time Status: Check the current status of lights and fans via the app or endpoints.
Voice Commands: Hands-free operation with integrated voice control.
Wi-Fi Connectivity: Communicates with the NodeMCU over the same Wi-Fi network.
User-Friendly Interface: Simple and intuitive Flutter app for control.
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
The NodeMCU microcontroller connects to a Wi-Fi network and controls the appliances.
The Flutter app sends commands to the NodeMCU via RESTful APIs.
The fan’s speed is controlled using Pulse Width Modulation (PWM), and the light is toggled using on/off commands.
Real-time status updates of devices are displayed in the app.
🌐 API Endpoints
Use the following endpoints to control and monitor your devices:

Light Control
Turn on/off:
http://192.168.152.64/light?state=on
http://192.168.152.64/light?state=off
Check status:
http://192.168.152.64/status/light
Fan Control
Set fan speed (0–255):
http://192.168.152.64/fan?speed=0 to 255
Check status:
http://192.168.152.64/status/fan
⚠️ Note: Replace the IP address 192.168.152.64 with the one assigned by your NodeMCU, as it may vary.

🎙️ Voice Commands
Control your devices hands-free using these voice commands:

Light
"Turn on the light"
"Turn off the light"
Fan
"Turn on the fan"
"Increase fan speed" (Minimum speed: 1)
"Decrease fan speed" (Maximum speed: 5)
"Turn off the fan"
Voice Assistance Notes:

Grant permissions for voice control in the app.
Use exact phrases as programmed in the NodeMCU for accurate recognition.
⚡ Additional Information
Both the NodeMCU and your phone must be connected to the same Wi-Fi network.
No internet connection is required for this system to work.
Ensure the hardware is powered on before using the Flutter app.
Grant the necessary permissions for voice control functionality.
🔧 Components
Microcontroller:
NodeMCU (ESP8266)
Additional Hardware:
Fan
Light Bulb
Motor Driver (L298N)
Relay Module
⚠️ Limitations
Wi-Fi Dependency: Requires connection to the same Wi-Fi network.
Limited Range: Operates within the Wi-Fi signal range of the NodeMCU.
No User Authentication: Cannot differentiate between users.
🛠️ Setup Instructions
Upload the firmware to the NodeMCU using the Arduino IDE.
Install and run the Flutter app on your mobile device.
🤝 Contributions
Contributions are welcome! Feel free to open an issue or submit a pull request to improve the project.

