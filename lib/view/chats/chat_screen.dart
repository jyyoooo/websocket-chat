import 'package:chat_app_ayna/controller/blocs/websocket_bloc/websocket_bloc.dart';
import 'package:chat_app_ayna/controller/blocs/websocket_bloc/websocket_event.dart';
import 'package:chat_app_ayna/controller/blocs/websocket_bloc/websocket_state.dart';
import 'package:chat_app_ayna/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String? sessionId;
  ChatScreen({super.key, this.sessionId});
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      context.read<WebSocketBloc>().add(SendMessage(Message(
          sender: FirebaseAuth.instance.currentUser!.uid,
          content: _controller.text,
          timestamp: DateTime.now(),
          sessionId: sessionId!)));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Chat with BLoC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<WebSocketBloc>().add(DisconnectWebSocket());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<WebSocketBloc, WebSocketState>(
              builder: (context, state) {
                if (state is WebSocketConnecting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WebSocketConnected) {
                  return const Center(child: Text('Connected'));
                } else if (state is WebSocketDisconnected) {
                  return const Center(child: Text('Disconnected'));
                } else if (state is WebSocketError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state is WebSocketMessageReceived) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.messages[index].content),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Unknown state'));
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
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
