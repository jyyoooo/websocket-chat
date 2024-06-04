import 'dart:developer';

import 'package:chat_app_ayna/model/chat_session.dart';
import 'package:chat_app_ayna/controller/blocs/session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'session_list_state.dart';

class SessionListCubit extends Cubit<SessionListState> {
  final UserSessionManager userSessionManager =
      UserSessionManager(FirebaseAuth.instance.currentUser!.uid);

  SessionListCubit() : super(SessionListInitial());

  Future<void> loadSessions() async {
    try {
      
      emit(SessionListLoading());
      final sessions = await userSessionManager.getAllSessions();
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
      await userSessionManager.createSession(sessionId, sessionName);
      loadSessions();
    } catch (e) {
      emit(SessionListError('Failed to add session: $e'));
    }
  }
}
