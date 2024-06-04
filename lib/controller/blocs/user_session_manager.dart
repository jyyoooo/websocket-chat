import 'dart:developer';
import 'package:chat_app_ayna/model/chat_session.dart';
import 'package:chat_app_ayna/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class UserSessionManager {
  String? userId = FirebaseAuth.instance.currentUser!.uid;

  // dispose() {
  //   userId = null;
  // }

  Future<void> createSession(String sessionId, String sessionName) async {
    try {
      log('In add session');
      final userBox = await Hive.openBox<ChatSession>('${userId}_sessions');
      log('User box opened');
      final newSession =
          ChatSession(id: sessionId, name: sessionName, messages: []);
      log('New session creation: ${newSession.id} ${newSession.name} for $userId');
      await userBox.put(sessionId, newSession);
      log('Session put in userBox');
    } catch (e) {
      log('Error adding session: $e');
    }
  }

  Future<void> addMessage(String sessionId, Message message) async {
    try {
      final userBox = await Hive.openBox<ChatSession>('${userId}_sessions');
      final chatSession = userBox.get(sessionId);
      if (chatSession != null) {
        chatSession.messages.add(message);
        await chatSession.save();
      }
    } catch (e) {
      log('Error adding message: $e');
    }
  }

  Future<List<Message>> getMessages(String sessionId) async {
    try {
      final userBox = await Hive.openBox<ChatSession>('${userId}_sessions');
      final chatSession = userBox.get(sessionId);
      return chatSession?.messages ?? [];
    } catch (e) {
      log('Error getting messages: $e');
      return [];
    }
  }

  Future<List<ChatSession>> getAllSessions() async {
    try {
      log('actual user id: ${FirebaseAuth.instance.currentUser!.uid}');
      log('In get all sessions for $userId');
      final userBox = await Hive.openBox<ChatSession>(
          '${FirebaseAuth.instance.currentUser!.uid}_sessions');
      log('Box from getAllSessions: ${userBox.values.map((e) => e.name)}');
      return userBox.values.toList();
    } catch (e) {
      log('Error getting all sessions: $e');
      return [];
    }
  }
}
