part of 'websocket_bloc.dart';

abstract class WebSocketState extends Equatable {
  const WebSocketState();
  @override
  List<Object> get props => [];
}

class WebSocketInitial extends WebSocketState {}

class WebSocketConnecting extends WebSocketState {}

class WebSocketConnected extends WebSocketState {}

class WebSocketDisconnected extends WebSocketState {}

class WebSocketError extends WebSocketState {
  final String error;

  const WebSocketError(this.error);
  @override
  List<Object> get props => [error];
}

class WebSocketMessageReceived extends WebSocketState {
  final List<Message> messages;

  const WebSocketMessageReceived(this.messages);
  @override
  List<Object> get props => [messages];
}
