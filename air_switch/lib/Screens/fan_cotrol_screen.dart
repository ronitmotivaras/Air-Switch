import 'package:flutter/material.dart';

class FanControlScreen extends StatefulWidget {
  const FanControlScreen({super.key});

  @override
  State<FanControlScreen> createState() => _FanControlScreenState();
}

class _FanControlScreenState extends State<FanControlScreen> {
  bool isFanOn = false; // State to track fan on/off
  int fanSpeed = 0; // Default fan speed (starts from 0)

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
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

              // Toggle Fan On/Off Icon
              IconButton(
                icon: Icon(
                  isFanOn ? Icons.power : Icons.power_off,
                  size: 80,
                  color: isFanOn ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isFanOn = !isFanOn; // Toggle fan state
                    if (!isFanOn) fanSpeed = 0; // Reset speed if fan is turned off
                  });
                },
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
                IconButton(
                  icon: const Icon(
                    Icons.speed,
                    size: 60,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      fanSpeed = (fanSpeed + 1) % 6; // Cycle between 0 and 5
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
