import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";

  // A simple method to return hard-coded responses
  String _getResponse(String message) {
    // Convert the input to lower case for easier matching
    String lowerMessage = message.toLowerCase();

    // Define some hard-coded responses
    if (lowerMessage.contains("hello") || lowerMessage.contains("hi")) {
      return "Hello! How can I help you today?";
    } else if (lowerMessage.contains("waste")) {
      return "Waste classification helps in recycling. What would you like to know?";
    } else if (lowerMessage.contains("thank you")) {
      return "You're welcome! If you have any other questions, feel free to ask.";
    } else if (lowerMessage.contains("bye")) {
      return "Goodbye! Have a great day!";
    } else {
      return "Sorry, I didn't understand that. Can you please rephrase?";
    }
  }

  // Handle the user input and generate a response
  void _sendMessage(String message) {
    setState(() {
      _response = _getResponse(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chatbot")),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: Text(_response))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Ask something..."),
              onSubmitted: (value) {
                _sendMessage(value);
                _controller.clear(); // Clear the input field
              },
            ),
          ),
        ],
      ),
    );
  }
}
