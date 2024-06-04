import 'dart:developer';
import 'package:chat_app_ayna/model/message.dart';
import 'package:chat_app_ayna/controller/blocs/user_session_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final userSessionManager = UserSessionManager();
  final String sessionId;

  ChatCubit(this.sessionId) : super(ChatInitial());

  Future<void> loadMessages() async {
    log('in load mgs');
    try {
      emit(ChatLoading());
      final messages = await userSessionManager.getMessages(sessionId);
      if (messages.isEmpty) {
        emit(ChatEmpty());
      } else {
        emit(ChatLoaded(messages));
      }
    } catch (e) {
      emit(ChatError('Failed to load messages: $e'));
    }
  }

  Future<void> sendMessage(Message message) async {
    try {
      await userSessionManager.addMessage(sessionId, message);
      loadMessages();
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }
}
