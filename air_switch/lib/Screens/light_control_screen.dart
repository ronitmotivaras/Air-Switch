import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LightControl extends StatefulWidget {
  const LightControl({super.key});

  @override
  State<LightControl> createState() => _LightControlState();
}

class _LightControlState extends State<LightControl> {
  bool isLightOn = false; // Track light status

  @override
  void initState() {
    super.initState();
    _getLightStatus(); // Get the light status when the screen is initialized
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
        _showError('Failed to get light status. Try again.');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      _showError('Unable to connect. Check your network.');
    }
  }

  // Function to toggle the light state via the API
  Future<void> _toggleLight(String state) async {
    String url = 'http://192.168.152.64/light?state=$state';

    try {
      final response = await http.get(Uri.parse(url)); // Send GET request

      if (response.statusCode == 200) {
        // Request successful; update the UI
        setState(() {
          isLightOn = (state == 'on');
        });
      } else {
        // Handle server errors
        print('Error: ${response.statusCode}');
        _showError('Failed to control the light. Try again.');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      _showError('Unable to connect. Check your network.');
    }
  }

  // Function to show error message in SnackBar
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
          'Light Control',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display light status with image
            GestureDetector(
              onTap: () {
                if (isLightOn) {
                  _toggleLight('off'); // Turn off the light on tap if it's on
                } else {
                  _toggleLight('on'); // Turn on the light on tap if it's off
                }
              },
              child: Image.asset(
                isLightOn ? 'assets/on.png' : 'assets/off.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isLightOn ? 'Light is ON' : 'Light is OFF',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
