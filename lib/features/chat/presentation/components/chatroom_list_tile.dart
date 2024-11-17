import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/chat/domain/entities/chat_room.dart';
import 'package:social/features/chat/presentation/pages/chatroom_page.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';

class ChatroomListTile extends StatefulWidget {
  final String targetUserId;
  final ChatRoom chatRoom;

  const ChatroomListTile({
    super.key,
    required this.targetUserId,
    required this.chatRoom,
  });

  @override
  State<ChatroomListTile> createState() => _ChatroomListTileState();
}

class _ChatroomListTileState extends State<ChatroomListTile> {
  String profileImageUrl = '';
  String userName = '';

  void fetchProfile() async {
    final userProfile =
        await context.read<ProfileCubit>().getProfile(widget.targetUserId);
    setState(() {
      profileImageUrl = userProfile.profileImageUrl;
      userName = userProfile.name;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 45,
        height: 45,
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
      title: Text(userName),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatroomPage(
            targetUserId: widget.targetUserId,
            chatRoomId: widget.chatRoom.id,
          ),
        ),
      ),
      // trailing: Text(widget.chatRoom.lastMessageTime.hour.toString()),
      // trailing: Image.network(
      //   'inserturlhere',
      //   fit: BoxFit.cover,
      //   errorBuilder: (context, error, stackTrace) => Image.asset(
      //     'images/default_pfp.png',
      //     fit: BoxFit.cover,
      //   ),
      // ),
    );
  }
}
