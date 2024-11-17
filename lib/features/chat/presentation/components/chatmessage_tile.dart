import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social/features/chat/domain/entities/chat_message.dart';

class ChatmessageTile extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatmessageTile({super.key, required this.chatMessage});

  @override
  Widget build(BuildContext context) {
    final currUser = context.read<AuthCubit>().currUser!;
    final myMessage = chatMessage.senderId == currUser.id;
    return Align(
      alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: myMessage ? Colors.blue.shade200 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(chatMessage.content),
      ),
    );
  }
}
