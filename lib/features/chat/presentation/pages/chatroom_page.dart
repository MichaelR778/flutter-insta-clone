import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/chat/presentation/components/chatmessage_tile.dart';
import 'package:social/features/chat/presentation/cubits/chatmessage_cubit.dart';
import 'package:social/features/chat/presentation/cubits/chatmessage_state.dart';
import 'package:social/features/chat/presentation/cubits/chatroom_cubit.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';

class ChatroomPage extends StatefulWidget {
  final String targetUserId;
  final String chatRoomId;
  final bool chatRoomExist;

  const ChatroomPage({
    super.key,
    required this.targetUserId,
    required this.chatRoomId,
    this.chatRoomExist = true,
  });

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  final textController = TextEditingController();
  String profileImageUrl = '';
  String userName = '';
  bool loaded = false;

  void sendMessage() {
    if (textController.text.isEmpty) return;

    context
        .read<ChatmessageCubit>()
        .sendMesssage(widget.chatRoomId, textController.text);
    textController.clear();
  }

  void fetchProfile() async {
    final userProfile =
        await context.read<ProfileCubit>().getProfile(widget.targetUserId);
    setState(() {
      profileImageUrl = userProfile.profileImageUrl;
      userName = userProfile.name;
    });
  }

  void init() async {
    fetchProfile();
    if (!widget.chatRoomExist) {
      await context.read<ChatroomCubit>().createChatRoom(widget.targetUserId);
    }
    setState(() {
      loaded = true;
    });
    context.read<ChatmessageCubit>().loadMessage(widget.chatRoomId);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  profileImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'images/default_pfp.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(userName),
          ],
        ),
      ),
      body: loaded
          ? BlocConsumer<ChatmessageCubit, ChatmessageState>(
              builder: (context, state) {
                // loading
                if (state is ChatmessageLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // loaded
                else if (state is ChatmessageLoaded) {
                  final messages = state.chatMessages;

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatmessageTile(chatMessage: message);
                    },
                  );
                }

                // else
                else {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
              },
              listener: (context, state) {
                if (state is ChatmessageError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Message',
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
