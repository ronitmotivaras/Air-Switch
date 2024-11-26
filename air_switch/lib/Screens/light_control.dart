import 'package:flutter/material.dart';

class LightControl extends StatefulWidget {
  const LightControl({super.key});

  @override
  State<LightControl> createState() => _LightControlState();
}

class _LightControlState extends State<LightControl> {
  bool isLightOn = false; // State to track light status

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
              Text(
                isLightOn ? 'Light is ON' : 'Light is OFF',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              IconButton(
                icon: Icon(
                  isLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                  size: 100,
                  color: isLightOn ? Colors.yellow[700] : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isLightOn = !isLightOn; // Toggle light state
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
