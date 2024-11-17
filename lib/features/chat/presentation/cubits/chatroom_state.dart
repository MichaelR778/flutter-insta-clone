import 'package:social/features/chat/domain/entities/chat_room.dart';

abstract class ChatroomState {}

class ChatroomLoading extends ChatroomState {}

class ChatroomLoaded extends ChatroomState {
  final List<ChatRoom> chatRooms;
  ChatroomLoaded({required this.chatRooms});
}

class ChatroomError extends ChatroomState {
  final String message;
  ChatroomError({required this.message});
}
