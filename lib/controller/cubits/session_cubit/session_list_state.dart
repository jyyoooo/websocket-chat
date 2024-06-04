part of 'session_list_cubit.dart';

abstract class SessionListState {}

class SessionListInitial extends SessionListState {}

class SessionListLoading extends SessionListState {}

class SessionListLoaded extends SessionListState {
  final List<ChatSession> sessions;

  SessionListLoaded(this.sessions);
}

class SessionListEmpty extends SessionListState {}

class SessionListError extends SessionListState {
  final String error;

  SessionListError(this.error);
}
