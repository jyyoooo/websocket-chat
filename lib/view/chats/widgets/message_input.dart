import 'package:flutter/material.dart';

class MessageInputField extends StatelessWidget {
  final String sessionId;

  const MessageInputField({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter your message',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Logic to send a message
            },
          ),
        ],
      ),
    );
  }
}
