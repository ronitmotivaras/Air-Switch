import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the HTTP package

class LightControl extends StatefulWidget {
  const LightControl({super.key});

  @override
  State<LightControl> createState() => _LightControlState();
}

class _LightControlState extends State<LightControl> {
  bool isLightOn = false; // Track light status

  // Function to toggle the light state via the API
  Future<void> toggleLight() async {
    String newState = isLightOn ? 'off' : 'on'; // Determine next state
    String url = 'http://192.168.38.64/light?state=$newState'; // API endpoint

    try {
      final response = await http.get(Uri.parse(url)); // Send GET request

      if (response.statusCode == 200) {
        // Request successful; update the UI
        setState(() {
          isLightOn = !isLightOn; // Toggle the state
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

  // Function to show an error message in a SnackBar
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
            GestureDetector(
              onTap: toggleLight, // Call the API when tapped
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
          ],
        ),
      ),
    );
  }
}
