import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social/features/post/domain/entities/post.dart';
import 'package:social/features/post/presentation/components/post_tile.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/post/presentation/cubits/post_state.dart';

class ProfilePosts extends StatefulWidget {
  final List<Post> posts;
  final int index;
  final List<String> deletedPostIds = [];

  ProfilePosts({
    super.key,
    required this.posts,
    required this.index,
  });

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  final itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: widget.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.posts
        .where((post) => !widget.deletedPostIds.contains(post.id))
        .toList();
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostDeleted) {
          setState(() {
            widget.deletedPostIds.add(state.postId);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Posts')),
        body: ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostTile(post: post);
          },
        ),
      ),
    );
  }
}
