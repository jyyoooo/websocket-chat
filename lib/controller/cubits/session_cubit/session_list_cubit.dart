import 'dart:developer';

import 'package:chat_app_ayna/model/chat_session.dart';
import 'package:chat_app_ayna/controller/blocs/user_session_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'session_list_state.dart';

class SessionListCubit extends Cubit<SessionListState> {
  // final userSessionManager = UserSessionManager();

  SessionListCubit() : super(SessionListInitial());

  

  Future<void> loadSessions() async {
    try {
      emit(SessionListLoading());
      final sessions = await UserSessionManager().getAllSessions();
      if (sessions.isEmpty) {
        emit(SessionListEmpty());
      } else {
        emit(SessionListLoaded(sessions));
      }
    } catch (e) {
      emit(SessionListError('Failed to load sessions: $e'));
    }
  }

  Future<void> addSession(String sessionId, String sessionName) async {
    try {
      log('in add session');
      await UserSessionManager().createSession(sessionId, sessionName);
      loadSessions();
    } catch (e) {
      emit(SessionListError('Failed to add session: $e'));
    }
  }

  
}
