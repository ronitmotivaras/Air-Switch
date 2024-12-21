import 'package:flutter/material.dart';

class FanControlScreen extends StatefulWidget {
  const FanControlScreen({super.key});

  @override
  State<FanControlScreen> createState() => _FanControlScreenState();
}

class _FanControlScreenState extends State<FanControlScreen> {
  bool isFanOn = false; // State to track fan on/off
  int fanSpeed = 1; // Default fan speed (starts from 0)

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
                    onTap: () {
                      setState(() {
                        isFanOn = !isFanOn; // Toggle fan state
                        if (!isFanOn) fanSpeed = 1; // Reset speed if fan is turned off
                      });
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
                      onTap: () {
                        setState(() {
                          fanSpeed = (fanSpeed + 1) % 6; // Cycle between 0 and 5
                        });
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
