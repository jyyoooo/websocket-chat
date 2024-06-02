import 'package:chat_app_ayna/model/message.dart';
import 'package:equatable/equatable.dart';

abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebSocket extends WebSocketEvent {}

class DisconnectWebSocket extends WebSocketEvent {}

class SendMessage extends WebSocketEvent {
  final Message message;

  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ReceiveMessage extends WebSocketEvent {
  final Message message;

  const ReceiveMessage(this.message);

  @override
  List<Object> get props => [message];
}
