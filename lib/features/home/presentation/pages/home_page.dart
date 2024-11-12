import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/post/presentation/components/post_tile.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/post/presentation/cubits/post_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void fetchAllPosts() {
    if (mounted) {
      context.read<PostCubit>().fetchAllPosts();
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/instagram_word_logo.png',
          height: 40,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const ImageIcon(
              AssetImage('icons/Messenger.png'),
            ),
          ),
        ],
      ),

      // body
      body: ListView(
        children: [
          BlocConsumer<PostCubit, PostState>(
            builder: (context, state) {
              // loading
              if (state is PostsLoading || state is PostUploaded) {
                return Column(
                  children: [
                    // top row
                    Padding(
                      padding: const EdgeInsets.all(8),
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
                          ),

                          const SizedBox(width: 8),

                          Container(
                            width: 60,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // post image
                    SizedBox(
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ],
                );
              }

              // loaded
              else if (state is PostsLoaded) {
                final posts = state.posts;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostTile(post: post);
                  },
                );
              }

              // else
              else {
                return const Center(child: Text('Something went wrong!'));
              }
            },
            listener: (context, state) {
              if (state is PostError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
