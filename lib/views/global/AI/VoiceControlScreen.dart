import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceControlScreen extends StatefulWidget {
  const VoiceControlScreen({super.key});

  @override
  _VoiceControlScreenState createState() => _VoiceControlScreenState();
}

class _VoiceControlScreenState extends State<VoiceControlScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _text = "";

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Control")),
      body: Column(
        children: [
          Text(_isListening ? "Listening..." : "Press the button to speak"),
          const SizedBox(height: 20),
          Text(_text),
          ElevatedButton(
            onPressed: _isListening ? _stopListening : _startListening,
            child: Icon(_isListening ? Icons.mic_off : Icons.mic),
          ),
        ],
      ),
    );
  }
}
