import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social/features/chat/presentation/components/chatroom_list_tile.dart';
import 'package:social/features/chat/presentation/cubits/chatroom_cubit.dart';
import 'package:social/features/chat/presentation/cubits/chatroom_state.dart';

class ChatroomListPage extends StatelessWidget {
  const ChatroomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ChatroomCubit>().loadChatRooms(),
        child: ListView(
          children: [
            BlocBuilder<ChatroomCubit, ChatroomState>(
              builder: (context, state) {
                // loading
                if (state is ChatroomLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // loaded
                else if (state is ChatroomLoaded) {
                  final chatRooms = state.chatRooms;

                  if (chatRooms.isEmpty) {
                    return const Center(
                      child: Text('No messages'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chatRooms.length,
                    itemBuilder: (context, index) {
                      final chatRoom = chatRooms[index];
                      final targetUserId = chatRoom.participantIds.firstWhere(
                          (id) => id != context.read<AuthCubit>().currUser!.id);
                      return ChatroomListTile(
                        key: ValueKey(chatRoom.id),
                        targetUserId: targetUserId,
                        chatRoom: chatRoom,
                      );
                    },
                  );
                }

                // error
                else if (state is ChatroomError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                // other
                else {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
