import 'package:social/features/chat/domain/entities/chat_message.dart';
import 'package:social/features/chat/domain/entities/chat_room.dart';

abstract class ChatRepo {
  Stream<List<ChatRoom>> getChatRooms(String currUserId);
  Stream<List<ChatMessage>> getMessages(String chatRoomId);
  Future<void> sendMessage(String chatRoomId, ChatMessage chatMessage);
  Future<void> createChatRoom(ChatRoom chatRoom);
}
