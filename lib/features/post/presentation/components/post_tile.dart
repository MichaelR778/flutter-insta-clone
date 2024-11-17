import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social/features/post/domain/entities/post.dart';
import 'package:social/features/post/presentation/components/comment_section.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social/features/profile/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;

  const PostTile({super.key, required this.post});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  bool loading = true;
  String profileImageUrl = '';
  String userName = '';
  late final currUser = context.read<AuthCubit>().currUser!;

  void fetchProfile() async {
    final userProfile =
        await context.read<ProfileCubit>().getProfile(widget.post.userId);
    setState(() {
      profileImageUrl = userProfile.profileImageUrl;
      userName = userProfile.name;
      loading = false;
    });
  }

  void toggleLike() {
    final isLiked = widget.post.likes.contains(currUser.id);

    // update like locally
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currUser.id);
      } else {
        widget.post.likes.add(currUser.id);
      }
    });

    // update like on db
    context
        .read<PostCubit>()
        .toggleLike(widget.post.id, currUser.id)
        .catchError((error) {
      if (isLiked) {
        widget.post.likes.add(currUser.id);
      } else {
        widget.post.likes.remove(currUser.id);
      }
    });
  }

  void openCommentSection() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return CommentSection(post: widget.post);
      },
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // top row
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(id: widget.post.userId),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                // profile picture
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: loading
                      ? const SizedBox()
                      : ClipOval(
                          child: Image.network(
                            profileImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'images/default_pfp.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),

                const SizedBox(width: 8),

                // username
                loading
                    ? Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                    : Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                const Expanded(child: SizedBox()),

                // delete post / report
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    showDragHandle: true,
                    builder: (BuildContext context) {
                      return ListTile(
                        title: Text(
                          widget.post.userId == currUser.id
                              ? 'Delete'
                              : 'Report',
                          style: const TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          if (widget.post.userId == currUser.id) {
                            context
                                .read<PostCubit>()
                                .deletePost(widget.post.id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reported')),
                            );
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // post image
        GestureDetector(
          // TODO: make function to like only, no unlike, like anim
          // onDoubleTap: toggleLike,
          child: Container(
            color: Colors.grey.shade200,
            child: Image.network(
              widget.post.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // bottom stuff
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // like, comment etc buttons
              Row(
                children: [
                  // like
                  GestureDetector(
                    onTap: toggleLike,
                    child: widget.post.likes.contains(currUser.id)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_outline),
                  ),
                  widget.post.likes.isNotEmpty
                      ? Text(widget.post.likes.length.toString())
                      : const SizedBox(),

                  const SizedBox(width: 15),

                  // comment
                  GestureDetector(
                    onTap: openCommentSection,
                    child: const ImageIcon(AssetImage('icons/Comment.png')),
                  ),
                  widget.post.comments.isNotEmpty
                      ? Text(widget.post.comments.length.toString())
                      : const SizedBox(),

                  const SizedBox(width: 15),

                  // share icon
                  const ImageIcon(AssetImage('icons/share.png')),

                  const Expanded(child: SizedBox()),

                  // save icon
                  const ImageIcon(AssetImage('icons/save.png')),
                ],
              ),

              const SizedBox(height: 5),

              // caption
              widget.post.caption.isNotEmpty
                  ? SizedBox(
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '$userName ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(text: widget.post.caption),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),

              // time stamp
              Text(
                DateFormat('yyyy-MM-dd').format(widget.post.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade400,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
