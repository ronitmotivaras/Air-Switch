import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MicButton extends StatefulWidget {
  const MicButton({Key? key}) : super(key: key);

  @override
  _MicButtonState createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = '';
  bool isFanOn = false; // Track fan status
  int fanSpeed = 1; // Default fan speed (1-5)

  // Start or stop listening when the button is pressed
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
          const SnackBar(content: Text('Speech recognition not available')),
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
    print("You said: $command");

    // Check if the user says "turn on the fan" when it's already on
    if (command.contains('turn on the fan') && !isFanOn) {
      setState(() {
        isFanOn = true;
      });
      _updateFanSpeed(fanSpeed * 80); // Set fan to current speed
      _saveFanState(isFanOn, fanSpeed);
    } else if (command.contains('turn on the fan') && isFanOn) {
      _showError('Fan is already ON'); // Show message if fan is already on

      // Check if the user says "turn off the fan" when it's already off
    } else if (command.contains('turn off the fan') && isFanOn) {
      setState(() {
        isFanOn = false;
        fanSpeed = 1; // Reset speed when turning off
      });
      _updateFanSpeed(0); // Turn off the fan by setting speed to 0
      _saveFanState(isFanOn, fanSpeed);
    } else if (command.contains('turn off the fan') && !isFanOn) {
      _showError('Fan is already OFF'); // Show message if fan is already off

      // Handle speed change commands only when the fan is on
    } else if (command.contains('increase fan speed') && isFanOn) {
      if (fanSpeed < 5) {
        setState(() {
          fanSpeed++; // Increase fan speed (up to 5)
        });
        _updateFanSpeed(fanSpeed * 80); // Update fan speed
        _saveFanState(isFanOn, fanSpeed);
      } else {
        _showError('Fan speed is already at the maximum!');
      }
    } else if (command.contains('decrease fan speed') && isFanOn) {
      if (fanSpeed > 1) {
        setState(() {
          fanSpeed--; // Decrease fan speed (down to 1)
        });
        _updateFanSpeed(fanSpeed * 80); // Update fan speed
        _saveFanState(isFanOn, fanSpeed);
      } else {
        _showError('Fan speed is already at the minimum!');
      }
    } else if ((command.contains('increase fan speed') || command.contains('decrease fan speed')) && !isFanOn) {
      _showError('The fan is off. Please turn it on first.');
    }
  }

  // Function to update fan speed via the API
  Future<void> _updateFanSpeed(int speed) async {
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

  // Function to save the fan state and speed in shared preferences
  Future<void> _saveFanState(bool isOn, int speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFanOn', isOn);  // Save fan on/off state
    await prefs.setInt('fanSpeed', speed); // Save fan speed
  }

  // Function to show error messages in a SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,  // Position the button 50 pixels from the bottom of the screen
      right: 35,   // Position the button 35 pixels from the right of the screen
      child: ElevatedButton(
        onPressed: _toggleListening,  // Start or stop listening
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isListening ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              _isListening ? 'Stop Listening' : 'Start Listening',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
