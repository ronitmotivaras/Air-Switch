import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'light_control.dart'; // Import LightControl screen

class MicButton extends StatefulWidget {
  const MicButton({Key? key}) : super(key: key);

  @override
  _MicButtonState createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = '';
  bool isLightOn = false; // Track light status
  bool isFanOn = false;   // Track fan status
  int fanSpeed = 1;       // Default fan speed (1-5)

  // Start or stop listening when the button is pressed
  void _toggleListening() async {
    print("Toggling listening...");
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (result) {
          print("Listening to result: ${result.recognizedWords}");
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

  // Process the voice command to turn the light on or off and control fan speed
  void _processVoiceCommand(String command) {
    print("You said: $command");

    // Make the command case-insensitive
    String lowerCommand = command.toLowerCase();

    // Handle light commands
    if (lowerCommand.contains('turn on the light') && !isLightOn) {
      toggleLight('on'); // Turn on the light
    } else if (lowerCommand.contains('turn off the light') && isLightOn) {
      toggleLight('off'); // Turn off the light
    } else if (lowerCommand.contains('turn on the light') && isLightOn) {
      _showError('Light is already ON');
    } else if (lowerCommand.contains('turn off the light') && !isLightOn) {
      _showError('Light is already OFF');
    }

    // Handle fan commands
    else if (lowerCommand.contains('turn on the fan') && !isFanOn) {
      toggleFan('on'); // Turn on the fan
    } else if (lowerCommand.contains('turn off the fan') && isFanOn) {
      toggleFan('off'); // Turn off the fan
    } else if (lowerCommand.contains('turn on the fan') && isFanOn) {
      _showError('Fan is already ON');
    } else if (lowerCommand.contains('turn off the fan') && !isFanOn) {
      _showError('Fan is already OFF');
    }

    // Handle fan speed commands
    else if (lowerCommand.contains('increase fan speed') && isFanOn) {
      if (fanSpeed < 5) {
        setState(() {
          fanSpeed++; // Increase fan speed
        });
        updateFanSpeed(fanSpeed * 80); // Update the fan speed on the server
      } else {
        _showError('Fan speed is already at the maximum!');
      }
    } else if (lowerCommand.contains('decrease fan speed') && isFanOn) {
      if (fanSpeed > 1) {
        setState(() {
          fanSpeed--; // Decrease fan speed
        });
        updateFanSpeed(fanSpeed * 80); // Update the fan speed on the server
      } else {
        _showError('Fan speed is already at the minimum!');
      }
    }
  }

  // Function to toggle the light state via the API
  Future<void> toggleLight(String state) async {
    String url = 'http://192.168.152.64/light?state=$state';

    try {
      final response = await http.get(Uri.parse(url)); // Send GET request

      if (response.statusCode == 200) {
        setState(() {
          isLightOn = (state == 'on');
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LightControl()),
        );
      } else {
        print('Error: ${response.statusCode}');
        _showError('Failed to control the light. Try again.');
      }
    } catch (e) {
      print('Error: $e');
      _showError('Unable to connect. Check your network.');
    }
  }

  // Function to toggle the fan state via the API
  Future<void> toggleFan(String state) async {
    String url = 'http://192.168.152.64/fan?state=$state';

    try {
      final response = await http.get(Uri.parse(url)); // Send GET request

      if (response.statusCode == 200) {
        setState(() {
          isFanOn = (state == 'on');
        });
      } else {
        print('Error: ${response.statusCode}');
        _showError('Failed to control the fan. Try again.');
      }
    } catch (e) {
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

  // Update the fan speed via the API
  Future<void> updateFanSpeed(int speed) async {
    String url = 'http://192.168.152.64/fan?speed=$speed';

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
