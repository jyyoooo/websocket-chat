import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SessionRepository {
  createSession(BuildContext context, String newSessionName) {
    if (newSessionName.isNotEmpty) {
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;
      final sessions = Hive.box<String>('sessions');
      final userSession = sessions.get(currentUserID);
      
    }
  }
}
