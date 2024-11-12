import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/post/domain/entities/comment.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  String profileImageUrl = '';
  String userName = '';

  void fetchProfile() async {
    final userProfile =
        await context.read<ProfileCubit>().getProfile(widget.comment.userId);
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // pfp
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Container(
              width: 35,
              height: 35,
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
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // username
                Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.comment.text,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
