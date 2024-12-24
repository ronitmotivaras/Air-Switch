import 'package:flutter/material.dart';
import 'fan_cotrol_screen.dart';
import 'light_control.dart';
import 'mic_screen.dart'; // Import the mic button widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
