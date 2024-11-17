import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/repos/auth_repo.dart';
import 'package:social/features/chat/domain/entities/chat_message.dart';
import 'package:social/features/chat/domain/repos/chat_repo.dart';
import 'package:social/features/chat/presentation/cubits/chatmessage_state.dart';

class ChatmessageCubit extends Cubit<ChatmessageState> {
  final ChatRepo chatRepo;
  final AuthRepo authRepo;
  StreamSubscription? messagesSubscription;

  ChatmessageCubit({
    required this.chatRepo,
    required this.authRepo,
  }) : super(ChatmessageLoading());

  Future<void> loadMessage(String chatRoomId) async {
    emit(ChatmessageLoading());
    messagesSubscription?.cancel();

    messagesSubscription = chatRepo.getMessages(chatRoomId).listen(
      (messages) {
        emit(ChatmessageLoaded(chatMessages: messages));
      },
      onError: (error) {
        emit(ChatmessageError(message: error.toString()));
      },
    );
  }

  Future<void> sendMesssage(String chatRoomId, String content) async {
    try {
      final currUser = await authRepo.getCurrUser();
      final chatMessage = ChatMessage(
        id: '${currUser!.id}_${DateTime.now().millisecondsSinceEpoch}',
        senderId: currUser.id,
        content: content,
        timestamp: DateTime.now(),
      );
      await chatRepo.sendMessage(chatRoomId, chatMessage);
    } catch (e) {
      emit(ChatmessageError(message: e.toString()));
    }
  }
}
