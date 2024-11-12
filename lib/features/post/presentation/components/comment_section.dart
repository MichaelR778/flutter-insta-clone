import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social/features/post/domain/entities/comment.dart';
import 'package:social/features/post/domain/entities/post.dart';
import 'package:social/features/post/presentation/components/comment_tile.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';

class CommentSection extends StatefulWidget {
  final Post post;

  const CommentSection({super.key, required this.post});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late final currUser = context.read<AuthCubit>().currUser!;
  final commentController = TextEditingController();

  void addComment() {
    if (commentController.text.isEmpty) return;

    final commentId = DateTime.now().millisecondsSinceEpoch.toString();

    final newComment = Comment(
      id: commentId,
      postId: widget.post.id,
      userId: currUser.id,
      text: commentController.text,
      timestamp: Timestamp.fromDate(DateTime.now()),
    );

    // add comment locally
    setState(() {
      widget.post.comments.add(newComment);
    });

    // clear textfield and pop keyboard
    commentController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    // add comment in db
    context.read<PostCubit>().addComment(widget.post.id, newComment).catchError(
          (error) => widget.post.comments
              .removeWhere((comment) => comment.id == newComment.id),
        );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = widget.post.comments.reversed.toList();
    return Scaffold(
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return CommentTile(comment: comment);
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () {
                addComment();
              },
              icon: const Icon(Icons.arrow_upward),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
