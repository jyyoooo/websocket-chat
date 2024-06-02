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
}
