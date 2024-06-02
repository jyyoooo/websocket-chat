import 'package:chat_app_ayna/controller/session_repo.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'chat_screen.dart';

class SessionListScreen extends StatefulWidget {
  const SessionListScreen({super.key});

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Sessions'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<String>('sessions').listenable(),
        builder: (context, Box<String> sessionsBox, _) {
          return ListView.builder(
            itemCount: sessionsBox.length,
            itemBuilder: (context, index) {
              final sessionId = sessionsBox.keyAt(index);
              return ListTile(
                title: Text(sessionId),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(sessionId: sessionId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showCreateSessionDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateSessionDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Session'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter session name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await SessionRepository().createSession(context,controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
