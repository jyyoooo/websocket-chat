part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;

  ChatLoaded(this.messages);
}

class ChatEmpty extends ChatState {}

class ChatError extends ChatState {
  final String error;

  ChatError(this.error);
}
