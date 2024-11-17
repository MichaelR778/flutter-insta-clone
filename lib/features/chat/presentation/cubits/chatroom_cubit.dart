import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/domain/repos/auth_repo.dart';
import 'package:social/features/chat/domain/entities/chat_room.dart';
import 'package:social/features/chat/domain/repos/chat_repo.dart';
import 'package:social/features/chat/presentation/cubits/chatroom_state.dart';

class ChatroomCubit extends Cubit<ChatroomState> {
  final ChatRepo chatRepo;
  final AuthRepo authRepo;
  StreamSubscription? chatRoomsSubscription;

  ChatroomCubit({
    required this.chatRepo,
    required this.authRepo,
  }) : super(ChatroomLoading()) {
    // loadChatRooms();
  }

  Future<void> loadChatRooms() async {
    emit(ChatroomLoading());
    chatRoomsSubscription?.cancel();

    final currUser = await authRepo.getCurrUser();
    chatRoomsSubscription = chatRepo.getChatRooms(currUser!.id).listen(
      (chatRooms) {
        // chatRooms
        //     .sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
        emit(ChatroomLoaded(chatRooms: chatRooms));
      },
      onError: (error) {
        emit(ChatroomError(message: error.toString()));
      },
    );
  }

  Future<void> createChatRoom(String targetUserId) async {
    try {
      final currUser = await authRepo.getCurrUser();
      final ids = [currUser!.id, targetUserId];
      ids.sort();
      final chatRoom = ChatRoom(
        id: ids.join('_'),
        participantIds: ids,
        lastMessageTime: DateTime.now(),
      );
      await chatRepo.createChatRoom(chatRoom);
    } catch (e) {
      emit(ChatroomError(message: e.toString()));
    }
  }
}
