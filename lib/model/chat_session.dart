import 'package:hive/hive.dart';
import 'message.dart';
part 'chat_session.g.dart';

@HiveType(typeId: 0)
class ChatSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<Message> messages;

  ChatSession({
    required this.id,
    required this.name,
    required this.messages,
  });
}
