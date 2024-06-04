import 'dart:developer';

import 'package:chat_app_ayna/controller/blocs/session_controller.dart';
import 'package:chat_app_ayna/controller/blocs/websocket_bloc/websocket_bloc.dart';
import 'package:chat_app_ayna/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String sessionId;
  final String userId;

  const ChatScreen({super.key, required this.sessionId, required this.userId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketBloc webSocketBloc;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    webSocketBloc = WebSocketBloc();
    webSocketBloc.add(ConnectWebSocket(sessionID: widget.sessionId));
  }

  @override
  void dispose() {
    log('in dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<WebSocketBloc, WebSocketState>(
              bloc: webSocketBloc,
              builder: (context, state) {
                if (state is WebSocketConnecting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WebSocketError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state is WebSocketMessageReceived) {
                  if (state.messages.isEmpty) {
                    return const Center(child: Text('No messages'));
                  } else {
                    return ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return ListTile(
                          title: Text(message.content),
                          subtitle: Text(
                              DateFormat('hh:mm a').format(message.timestamp)),
                        );
                      },
                    );
                  }
                } else {
                  return const Center(child: Text('No connection'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final messageContent = _messageController.text;
                    if (messageContent.isNotEmpty) {
                      final message = Message(
                        sessionId: widget.sessionId,
                        sender: widget.userId,
                        content: messageContent,
                        timestamp: DateTime.now(),
                      );
                      webSocketBloc.add(SendMessage(message));
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
