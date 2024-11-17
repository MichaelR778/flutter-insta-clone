import 'package:social/features/chat/domain/entities/chat_message.dart';

abstract class ChatmessageState {}

class ChatmessageLoading extends ChatmessageState {}

class ChatmessageLoaded extends ChatmessageState {
  final List<ChatMessage> chatMessages;
  ChatmessageLoaded({required this.chatMessages});
}

class ChatmessageError extends ChatmessageState {
  final String message;
  ChatmessageError({required this.message});
}
