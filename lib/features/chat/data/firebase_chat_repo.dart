import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/chat/domain/entities/chat_message.dart';
import 'package:social/features/chat/domain/entities/chat_room.dart';
import 'package:social/features/chat/domain/repos/chat_repo.dart';

class FirebaseChatRepo implements ChatRepo {
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<List<ChatRoom>> getChatRooms(String currUserId) {
    try {
      return firebaseFirestore
          .collection('chatRooms')
          .where('participantIds', arrayContains: currUserId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatRoom.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to fetch chat: $e');
    }
  }

  @override
  Stream<List<ChatMessage>> getMessages(String chatRoomId) {
    try {
      return firebaseFirestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  @override
  Future<void> sendMessage(String chatRoomId, ChatMessage chatMessage) async {
    try {
      final chatRoomRef =
          firebaseFirestore.collection('chatRooms').doc(chatRoomId);
      await chatRoomRef
          .collection('messages')
          .doc(chatMessage.id)
          .set(chatMessage.toJson());
      return chatRoomRef.update({
        'lastMessageTime': Timestamp.fromDate(chatMessage.timestamp),
      });
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<void> createChatRoom(ChatRoom chatRoom) {
    try {
      return firebaseFirestore
          .collection('chatRooms')
          .doc(chatRoom.id)
          .set(chatRoom.toJson());
    } catch (e) {
      throw Exception('Failed to create chat room: $e');
    }
  }
}
