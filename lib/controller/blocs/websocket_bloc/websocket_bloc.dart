import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:chat_app_ayna/model/message.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chat_app_ayna/controller/blocs/user_session_manager.dart';
part 'websocket_event.dart';
part 'websocket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketChannel? _channel;
  final List<Message> _messages = [];

  WebSocketBloc() : super(WebSocketInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<DisconnectWebSocket>(_onDisconnectWebSocket);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onConnectWebSocket(
    ConnectWebSocket event,
    Emitter<WebSocketState> emit,
  ) async {
    log('Connecting socket...');
    emit(WebSocketConnecting());

    _channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));

    try {
      _channel!.stream.listen(
        (message) async {
          log('Message runtimeType: ${message.runtimeType}');
          if (!message.contains('Request served')) {
            log('message: $message');
            final decodedMessage = jsonDecode(message);
            log('decoded message runtimeType: ${decodedMessage.runtimeType}');
            add(ReceiveMessage(Message.fromJson(decodedMessage)));
            log('Received message from socket: $decodedMessage');
          }
        },
        onDone: () {
          // if (!isClosed) emit(WebSocketDisconnected());
        },
        onError: (error) {
          // if (!isClosed) emit(WebSocketError(error.toString()));
        },
      );
    } catch (e) {
      log('Error connecting WebSocket: $e');
    }

    emit(WebSocketConnected());

    final userSessionManager = UserSessionManager();

    // Load existing messages from Hive
    final existingMessages =
        await userSessionManager.getMessages(event.sessionID);
    _messages.addAll(existingMessages);
    if (!isClosed) emit(WebSocketMessageReceived(List.from(_messages)));
  }

  FutureOr<void> _onDisconnectWebSocket(
    DisconnectWebSocket event,
    Emitter<WebSocketState> emit,
  ) async {
    log('closing sink');
    await _channel?.sink.close();
    log('sink closed ');

    // emit(WebSocketDisconnected());
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<WebSocketState> emit,
  ) async {
    final messageJson = jsonEncode(event.message.toJson());
    _channel?.sink.add(messageJson);
    _messages.add(event.message);

    final userSessionManager = UserSessionManager();

    await userSessionManager.addMessage(event.message.sessionId, event.message);
    if (!isClosed) emit(WebSocketMessageReceived(List.from(_messages)));
  }

  Future<void> _onReceiveMessage(
    ReceiveMessage event,
    Emitter<WebSocketState> emit,
  ) async {
    final message = Message(
      sessionId: event.message.sessionId,
      sender: FirebaseAuth.instance.currentUser!.uid,
      content: event.message.content,
      timestamp: DateTime.now(),
    );
    _messages.add(message);

    final userSessionManager = UserSessionManager();

    await userSessionManager.addMessage(message.sessionId, message);
    if (!isClosed) emit(WebSocketMessageReceived(List.from(_messages)));
  }

  // bool _isValidJson(String str) {
  //   log('Is valid json function called');
  //   try {
  //     jsonDecode(str);
  //     log('Json decode completed');
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // @override
  // Future<void> close() async {
  //   log('in close channel sink');
  //   final response = await _channel?.sink.close();
  //   log('close response : $response');
  //   return super.close();
  // }
}
