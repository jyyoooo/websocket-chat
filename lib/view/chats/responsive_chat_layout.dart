import 'dart:developer';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'session_list_screen.dart';

class ResponsiveChatScreen extends StatelessWidget {
  final String userId;

  const ResponsiveChatScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return NarrowLayout(userId: userId);
        } else {
          return WideLayout(userId: userId);
        }
      },
    );
  }
}

class NarrowLayout extends StatelessWidget {
  final String userId;

  const NarrowLayout({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => SessionListScreen(userId: userId),
        );
      },
    );
  }
}

class WideLayout extends StatefulWidget {
  final String userId;

  const WideLayout({super.key, required this.userId});

  @override
  _WideLayoutState createState() => _WideLayoutState();
}

class _WideLayoutState extends State<WideLayout> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String? selectedSessionId;

  void _onSessionSelected(String sessionId) {
    setState(() {
      selectedSessionId = sessionId;
      log('selected session: $selectedSessionId');
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
        builder: (context) => ChatScreen(
          sessionId: selectedSessionId!,
          userId: widget.userId,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SessionListScreen(
            userId: widget.userId,
            onSessionSelected: _onSessionSelected,
          ),
        ),
        Expanded(
          flex: 2,
          child: Navigator(
            key: _navigatorKey,
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Center(
                    child: selectedSessionId == null
                        ? const Text('Select a chat')
                        : ChatScreen(
                            sessionId: selectedSessionId!,
                            userId: widget.userId,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
