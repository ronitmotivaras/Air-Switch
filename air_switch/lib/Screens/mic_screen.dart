import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    checkFanStatus(); // Fetch initial fan status on startup
  }

  // Map speed level to PWM value
  int getPwmValue(int speed) {
    switch (speed) {
      case 1:
        return 80;
      case 2:
        return 120;
      case 3:
        return 180;
      case 4:
        return 220;
      case 5:
        return 255;
      default:
        return 0; // Default to 0 if invalid speed
    }
  }

  // Fetch the current fan status from the server
  Future<void> checkFanStatus() async {
    String url = 'http://192.168.152.64/status/fan'; // URL to check fan status
    try {
      final response = await http.get(Uri.parse(url)); // Send GET request
      if (response.statusCode == 200) {
        String responseBody = response.body.toLowerCase();
        setState(() {
          if (responseBody.contains("on")) {
            isFanOn = true;
            int extractedSpeed = int.parse(RegExp(r'\d+').stringMatch(responseBody) ?? '0');
            fanSpeed = (extractedSpeed >= 80 && extractedSpeed <= 255)
                ? (extractedSpeed - 60) ~/ 40
                : 1;
          } else {
            isFanOn = false;
            fanSpeed = 1; // Reset speed if fan is off
          }
        });
      } else {
        _showError('Failed to get fan status. Try again.');
      }
    } catch (e) {
      _showError('Unable to connect. Check your network.');
    }
  }

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
        _showError('Speech recognition not available');
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _updateLightState(bool turnOn) async {
    String url = 'http://192.168.152.64/light'; // API endpoint for light
    String state = turnOn ? 'on' : 'off'; // Set state to on or off
    try {
      final response = await http.get(Uri.parse('$url?state=$state'));
      if (response.statusCode == 200) {
        setState(() {
          // Optionally update any state related to light (e.g., light status)
        });
        String status = turnOn ? 'Light turned ON' : 'Light turned OFF';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
      } else {
        _showError('Failed to update light. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Unable to connect. Check your network.');
    }
  }


  void _processVoiceCommand(String command) {
    if (command.contains('turn on the fan') && !isFanOn) {
      _updateFanState(true, fanSpeed);
    } else if (command.contains('turn off the fan') && isFanOn) {
      _updateFanState(false, 0);
    } else if (command.contains('increase fan speed') && isFanOn) {
      if (fanSpeed < 5) {
        _updateFanState(true, fanSpeed + 1);
      } else {
        _showError('Fan speed is already at the maximum!');
      }
    } else if (command.contains('decrease fan speed') && isFanOn) {
      if (fanSpeed > 1) {
        _updateFanState(true, fanSpeed - 1); // Ensure fanSpeed decreases
      } else {
        _showError('Fan speed is already at the minimum!');
      }
    } else if ((command.contains('increase fan speed') || command.contains('decrease fan speed')) && !isFanOn) {
      _showError('The fan is off. Please turn it on first.');
    }

    // Add logic to handle light commands
    else if (command.contains('turn on the light')) {
      _updateLightState(true);
    } else if (command.contains('turn off the light')) {
      _updateLightState(false);
    }
  }

  // Update the fan state and speed via the API
  Future<void> _updateFanState(bool turnOn, int speed) async {
    String url = 'http://192.168.152.64/fan'; // API endpoint
    int pwmValue = turnOn ? getPwmValue(speed) : 0; // Get PWM value or 0 for off
    try {
      final response = await http.get(Uri.parse('$url?speed=$pwmValue'));
      if (response.statusCode == 200) {
        setState(() {
          isFanOn = turnOn;
          fanSpeed = turnOn ? speed : 1; // Reset speed to 1 when turning off
        });
        String status = turnOn ? 'Fan turned ON at speed $speed' : 'Fan turned OFF';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
      } else {
        _showError('Failed to update fan. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Unable to connect. Check your network.');
    }
  }

  // Show error messages in a SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      right: 35,
      child: ElevatedButton(
        onPressed: _toggleListening,
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
