import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // Import speech to text package

class LightControl extends StatefulWidget {
  const LightControl({super.key});

  @override
  State<LightControl> createState() => _LightControlState();
}

class _LightControlState extends State<LightControl> {
  bool isLightOn = false; // Track light status
  stt.SpeechToText _speech = stt.SpeechToText(); // Speech-to-text instance
  bool _isListening = false; // Track whether voice recognition is active
  String _spokenText = ''; // The recognized spoken text

  @override
  void initState() {
    super.initState();
    _loadLightState(); // Load the saved light state on app start
  }

  // Function to load the saved light state from shared preferences
  Future<void> _loadLightState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLightOn = prefs.getBool('isLightOn') ?? false; // Default to false if no saved state
    });
  }

  // Function to toggle the light state via the API
  Future<void> toggleLight(String state) async {
    String url = 'http://192.168.152.64/light?state=$state';

    try {
      final response = await http.get(Uri.parse(url)); // Send GET request

      if (response.statusCode == 200) {
        // Request successful; update the UI and save state
        setState(() {
          isLightOn = (state == 'on');
        });
        _saveLightState(isLightOn); // Save the updated state
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

  // Function to save the light state in shared preferences
  Future<void> _saveLightState(bool state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLightOn', state); // Save the state of the light
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

  // Process the voice command to turn the light on or off
  void _processVoiceCommand(String command) {
    print("You said: $command"); // Debugging line

    // Make the command case-insensitive
    String lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('turn on the light') && !isLightOn) {
      toggleLight('on'); // Turn on the light
    } else if (lowerCommand.contains('turn off the light') && isLightOn) {
      toggleLight('off'); // Turn off the light
    } else if (lowerCommand.contains('turn on the light') && isLightOn) {
      _showError('Light is already ON'); // Show message if light is already on
    } else if (lowerCommand.contains('turn off the light') && !isLightOn) {
      _showError('Light is already OFF'); // Show message if light is already off
    }
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
            Image.asset(
              isLightOn ? 'assets/on.png' : 'assets/off.png',
              width: 150,
              height: 150,
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
            // Add voice command button
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
      ),
    );
  }
}
