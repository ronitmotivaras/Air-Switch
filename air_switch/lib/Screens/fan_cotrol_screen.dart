import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FanControlScreen extends StatefulWidget {
  const FanControlScreen({super.key});

  @override
  State<FanControlScreen> createState() => _FanControlScreenState();
}

class _FanControlScreenState extends State<FanControlScreen> {
  bool isFanOn = false; // Track fan status
  int fanSpeed = 1; // Default fan speed (1-5)

  // Map speed level to PWM value
  int getPwmValue(int speed) {
    switch (speed) {
      case 1:
        return 80;
      case 2:
        return 120;
      case 3:
        return 180;
      case 4:
        return 220;
      case 5:
        return 255;
      default:
        return 0; // Default to 0 if invalid speed
    }
  }

  // Function to check the fan status from the server
  Future<void> checkFanStatus() async {
    String url = 'http://192.168.152.64/status/fan'; // URL to check fan status

    try {
      final response = await http.get(Uri.parse(url)); // Send GET request

      if (response.statusCode == 200) {
        String responseBody = response.body.toLowerCase();
        setState(() {
          if (responseBody.contains("on")) {
            isFanOn = true;
            // Extract speed from response and map it to 1-5
            int extractedSpeed = int.parse(RegExp(r'\d+').stringMatch(responseBody) ?? '0');
            fanSpeed = (extractedSpeed >= 80 && extractedSpeed <= 255)
                ? (extractedSpeed - 60) ~/ 40
                : 1;
          } else {
            isFanOn = false;
            fanSpeed = 1; // Reset speed if fan is off
          }
        });
      } else {
        print('Error: ${response.statusCode}');
        _showError('Failed to get fan status. Try again.');
      }
    } catch (e) {
      print('Error: $e');
      _showError('Unable to connect. Check your network.');
    }
  }

  // Function to send fan speed to the server
  Future<void> updateFanSpeed(int speed) async {
    int pwmValue = getPwmValue(speed);
    String url = 'http://192.168.152.64/fan?speed=$pwmValue'; // API endpoint
    try {
      final response = await http.get(Uri.parse(url)); // Send GET request
      if (response.statusCode == 200) {
        print('Fan speed updated to $speed (PWM: $pwmValue)');
      } else {
        print('Error: ${response.statusCode}');
        _showError('Failed to update fan speed. Try again.');
      }
    } catch (e) {
      print('Error: $e');
      _showError('Unable to connect. Check your network.');
    }
  }

  // Function to show error messages in a SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    checkFanStatus(); // Check the fan status when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fan Control',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min, // Prevent column expansion
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: [
                  // Fan status text
                  Text(
                    isFanOn ? 'Fan is ON' : 'Fan is OFF',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Toggle Fan On/Off Image
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isFanOn = !isFanOn; // Toggle fan state
                      });
                      // Update fan state on the server
                      if (!isFanOn) {
                        fanSpeed = 1; // Reset speed if fan is turned off
                        await updateFanSpeed(0); // Send speed 0 to turn off the fan
                      } else {
                        await updateFanSpeed(fanSpeed); // Set fan to current speed
                      }
                    },
                    child: Image.asset(
                      isFanOn ? 'assets/on.png' : 'assets/off.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Speed Control (only visible if the fan is on)
                  if (isFanOn) ...[
                    Text(
                      'Speed: $fanSpeed',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (fanSpeed > 1) {
                              setState(() {
                                fanSpeed--; // Decrease speed
                              });
                              await updateFanSpeed(fanSpeed); // Update server
                            } else {
                              _showError('Fan speed is already at the minimum!');
                            }
                          },
                          child: Image.asset(
                            'assets/minus.png', // Image for decrease button
                            width: 60,
                            height: 60,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () async {
                            if (fanSpeed < 5) {
                              setState(() {
                                fanSpeed++; // Increase speed
                              });
                              await updateFanSpeed(fanSpeed); // Update server
                            } else {
                              _showError('Fan speed is already at the maximum!');
                            }
                          },
                          child: Image.asset(
                            'assets/plus.png', // Image for increase button
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
