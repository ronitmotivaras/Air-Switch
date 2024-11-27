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
      body: SingleChildScrollView( // Enable scrolling
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height, // Make container fill the screen
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLightOn = !isLightOn; // Toggle light state
                    });
                  },
                  child: Image.asset(
                    isLightOn ? 'assets/on.png' : 'assets/off.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20), // Space between image and text
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
        ),
      ),
    );
  }
}
