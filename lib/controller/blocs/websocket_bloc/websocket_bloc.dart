import 'package:chat_app_ayna/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'websocket_event.dart';
import 'websocket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  late WebSocketChannel _channel;
  final List<Message> _messages = [];

  WebSocketBloc() : super(WebSocketInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<DisconnectWebSocket>(_onDisconnectWebSocket);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  void _onConnectWebSocket(
    ConnectWebSocket event,
    Emitter<WebSocketState> emit,
  ) {
    emit(WebSocketConnecting());

    _channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));

    _channel.stream.listen(
      (message) {
        add(ReceiveMessage(message));
      },
      onDone: () {
        emit(WebSocketDisconnected());
      },
      onError: (error) {
        emit(WebSocketError(error.toString()));
      },
    );

    emit(WebSocketConnected());
  }

  void _onDisconnectWebSocket(
    DisconnectWebSocket event,
    Emitter<WebSocketState> emit,
  ) {
    _channel.sink.close();
    emit(WebSocketDisconnected());
  }

  void _onSendMessage(
    SendMessage event,
    Emitter<WebSocketState> emit,
  ) {
    _channel.sink.add(event.message);
    _messages.add(event.message);
    emit(WebSocketMessageReceived(List.from(_messages)));
  }

  void _onReceiveMessage(
    ReceiveMessage event,
    Emitter<WebSocketState> emit,
  ) {
    final message = Message(
      sessionId: event.message.sessionId,
      sender: FirebaseAuth.instance.currentUser!.uid,
      content: event.message.content,
      timestamp: DateTime.now(),
    );
    _messages.add(message);
    emit(WebSocketMessageReceived(List.from(_messages)));
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    return super.close();
  }
}
