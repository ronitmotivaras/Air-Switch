import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FanControlScreen extends StatefulWidget {
  const FanControlScreen({super.key});

  @override
  State<FanControlScreen> createState() => _FanControlScreenState();
}

class _FanControlScreenState extends State<FanControlScreen> {
  bool isFanOn = false; // State to track fan on/off
  int fanSpeed = 1; // Default fan speed (1-5)

  // Function to send fan speed to the server
  Future<void> updateFanSpeed(int speed) async {
    String url = 'http://192.168.152.64/fan?speed=$speed'; // API endpoint
    try {
      final response = await http.get(Uri.parse(url)); // Send GET request
      if (response.statusCode == 200) {
        print('Fan speed updated to $speed');
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
      body: Center( // Center everything vertically and horizontally
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
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
                        await updateFanSpeed(fanSpeed * 51); // Set fan to current speed
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
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          fanSpeed = (fanSpeed % 5) + 1; // Cycle between 1 and 5
                        });
                        await updateFanSpeed(fanSpeed * 51); // Map speed to 0-255 range
                      },
                      child: Image.asset(
                        'assets/fan_speed_button.png', // Image for speed control
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
