import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:speech_to_text/speech_to_text.dart' as stt; // Import speech to text

class FanControlScreen extends StatefulWidget {
  const FanControlScreen({super.key});

  @override
  State<FanControlScreen> createState() => _FanControlScreenState();
}

class _FanControlScreenState extends State<FanControlScreen> {
  bool isFanOn = false; // State to track fan on/off
  int fanSpeed = 1; // Default fan speed (1-5)
  stt.SpeechToText _speech = stt.SpeechToText(); // Speech-to-text instance
  bool _isListening = false; // Track if the app is currently listening to voice input
  String _spokenText = ''; // The recognized speech

  @override
  void initState() {
    super.initState();
    _loadFanState(); // Load saved fan state and speed when the app starts
  }

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

  // Save the fan state and speed in shared preferences
  Future<void> _saveFanState(bool isOn, int speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFanOn', isOn);  // Save fan on/off state
    await prefs.setInt('fanSpeed', speed); // Save fan speed
  }

  // Load the fan state and speed from shared preferences
  Future<void> _loadFanState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFanOn = prefs.getBool('isFanOn') ?? false; // Load fan on/off state
      fanSpeed = prefs.getInt('fanSpeed') ?? 1;  // Load fan speed, default to 1
    });
  }

  // Function to start or stop listening for voice input
  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
          });
          _processVoiceCommand(_spokenText); // Process the spoken text
        });
      } else {
        print("Speech recognition is not available.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech recognition not available')),
        );
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  // Process the voice command to turn the fan on or off and adjust the speed
  void _processVoiceCommand(String command) {
    print("You said: $command"); // Debugging line
    if (command.contains('turn on the fan') && !isFanOn) {
      setState(() {
        isFanOn = true;
      });
      updateFanSpeed(fanSpeed * 80); // Set fan to current speed
      _saveFanState(isFanOn, fanSpeed);
    } else if (command.contains('turn off the fan') && isFanOn) {
      setState(() {
        isFanOn = false;
        fanSpeed = 1; // Reset speed when turning off
      });
      updateFanSpeed(0); // Turn off the fan by setting speed to 0
      _saveFanState(isFanOn, fanSpeed);
    } else if (command.contains('increase fan speed') && isFanOn && fanSpeed < 5) {
      setState(() {
        fanSpeed++; // Increase fan speed (up to 5)
      });
      updateFanSpeed(fanSpeed * 80); // Update fan speed
      _saveFanState(isFanOn, fanSpeed);
    } else if (command.contains('decrease fan speed') && isFanOn && fanSpeed > 1) {
      setState(() {
        fanSpeed--; // Decrease fan speed (down to 1)
      });
      updateFanSpeed(fanSpeed * 80); // Update fan speed
      _saveFanState(isFanOn, fanSpeed);
    }
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
                        await updateFanSpeed(fanSpeed * 80); // Set fan to current speed
                      }
                      // Save the updated state and speed
                      await _saveFanState(isFanOn, fanSpeed);
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
                        await updateFanSpeed(fanSpeed * 80); // Map speed to 0-255 range
                        // Save the updated speed
                        await _saveFanState(isFanOn, fanSpeed);
                      },
                      child: Image.asset(
                        'assets/fan_speed_button.png', // Image for speed control
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ],
                  // Voice Command Button
                  IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.purple,
                      size: 40,
                    ),
                    onPressed: _toggleListening, // Start or stop listening
                  ),
                  if (_spokenText.isNotEmpty)
                    Text(
                      'You said: $_spokenText',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
