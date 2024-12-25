import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fan_control_screen.dart';
import 'light_control_screen.dart';
import 'mic_screen.dart'; // Import the mic button widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLightOn = false; // Track light status
  bool isFanOn = false; // Track fan status
  int fanSpeed = 0; // Track fan speed

  @override
  void initState() {
    super.initState();
    _getLightStatus(); // Get the light status when the screen is initialized
    _getFanStatus(); // Get the fan status when the screen is initialized
  }

  // Function to get the light status from the server
  Future<void> _getLightStatus() async {
    String url = 'http://192.168.152.64/status/light'; // URL to check the light status

    try {
      final response = await http.get(Uri.parse(url)); // Send GET request

      if (response.statusCode == 200) {
        setState(() {
          isLightOn = response.body.contains("ON"); // Parse response to set the light state
        });
      } else {
        // Handle server errors
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
    }
  }

  // Function to get the fan status from the server
  Future<void> _getFanStatus() async {
    String url = 'http://192.168.152.64/status/fan'; // URL to check the fan status

    try {
      final response = await http.get(Uri.parse(url)); // Send GET request

      if (response.statusCode == 200) {
        if (response.body.contains("OFF")) {
          setState(() {
            isFanOn = false;
            fanSpeed = 0;
          });
        } else {
          setState(() {
            isFanOn = true;
            fanSpeed = int.parse(response.body.split('with speed ')[1]);
          });
        }
      } else {
        // Handle server errors
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Air Switch',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Light Image Button
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LightControl()),
                          );
                        },
                        child: Image.asset(
                          'assets/light.png',
                          width: 150, // Adjust width to fit your design
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Light',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  // Fan Image Button
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FanControlScreen()),
                          );
                        },
                        child: Image.asset(
                          'assets/fan.png',
                          width: 150, // Adjust width as needed
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Fan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Add the mic button to the stack (it will be positioned at the bottom right)
          const MicButton(),  // This places the mic button at the bottom right
        ],
      ),
    );
  }
}
