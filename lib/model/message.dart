import 'package:hive/hive.dart';
part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends HiveObject {
  @HiveField(0)
  String sender;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  String sessionId;

  Message(
      {required this.sender,
      required this.content,
      required this.timestamp,
      required this.sessionId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sessionId: json['sessionId'],
      sender: json['sender'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
