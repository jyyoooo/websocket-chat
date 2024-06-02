import 'package:hive/hive.dart';

class UserSessionManager {
  final String userId;

  UserSessionManager(this.userId);

  Future<void> addSession(String sessionId) async {
    final userBox = await Hive.openBox('${userId}_sessions');
    userBox.put(sessionId, []);
  }

  Future<void> addMessage(String sessionId, String message) async {
    final userBox = await Hive.openBox('${userId}_sessions');
    final List<String> messages = userBox.get(sessionId, defaultValue: []);
    messages.add(message);
    userBox.put(sessionId, messages);
  }

  Future<List<String>> getMessages(String sessionId) async {
    final userBox = await Hive.openBox('${userId}_sessions');
    return userBox.get(sessionId, defaultValue: []);
  }

  Future<List<dynamic>> getAllSessions() async {
    final userBox = await Hive.openBox('${userId}_sessions');
    return userBox.keys.toList();
  }
}
