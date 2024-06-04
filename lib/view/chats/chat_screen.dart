import 'package:chat_app_ayna/controller/blocs/websocket_bloc/websocket_bloc.dart';
import 'package:chat_app_ayna/model/message.dart';
import 'package:chat_app_ayna/view/authentication/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
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
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: BlocBuilder<WebSocketBloc, WebSocketState>(
              bloc: webSocketBloc,
              builder: (context, state) {
                if (state is WebSocketConnecting) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (state is WebSocketError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state is WebSocketMessageReceived) {
                  if (state.messages.isEmpty) {
                    return const Center(child: Text('No messages'));
                  } else {
                    return _messagesBuilder(state);
                  }
                } else {
                  return const Center(child: Text('No connection'));
                }
              },
            ),
          ),
          _createAndSendMessageWidgets(),
        ],
      ),
    );
  }

  //refactored widgets

  Widget _createAndSendMessageWidgets() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              labelText: 'Message...',
              controller: _messageController,
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_up_circle_fill),
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
    );
  }

  Widget _messagesBuilder(WebSocketMessageReceived state) {
    return ListView.builder(
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        final bool isCurrentUser = index % 2 == 0;
        return Align(
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.black,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
