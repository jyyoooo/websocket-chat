import 'package:flutter/material.dart';

class SessionListItem extends StatelessWidget {
  final String sessionId;
  final VoidCallback onTap;

  const SessionListItem({required this.sessionId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(sessionId),
      onTap: onTap,
    );
  }
}
