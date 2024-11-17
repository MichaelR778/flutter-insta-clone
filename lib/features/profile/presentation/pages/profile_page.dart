import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social/core/presentation/components/white_button.dart';
import 'package:social/features/chat/presentation/cubits/chatroom_cubit.dart';
import 'package:social/features/chat/presentation/cubits/chatroom_state.dart';
import 'package:social/features/chat/presentation/pages/chatroom_page.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/post/presentation/cubits/post_state.dart';
import 'package:social/features/post/presentation/cubits/profile_post_cubit.dart';
import 'package:social/features/profile/presentation/components/follow_button.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social/features/profile/presentation/cubits/profile_state.dart';
import 'package:social/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:social/features/profile/presentation/pages/follow_list_page.dart';
import 'package:social/features/profile/presentation/pages/profile_posts.dart';

class ProfilePage extends StatefulWidget {
  final String id;

  const ProfilePage({super.key, required this.id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final currUser = context.read<AuthCubit>().currUser!;

  void toggleFollow() {
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is! ProfileLoaded) return;

    final userProfile = profileState.userProfile;
    final isFollowing = userProfile.followers.contains(currUser.id);

    // update follower locally
    setState(() {
      if (isFollowing) {
        // unfollow
        userProfile.followers.remove(currUser.id);
      } else {
        // follow
        userProfile.followers.add(currUser.id);
      }
    });

    // update followers on db
    context
        .read<ProfileCubit>()
        .toggleFollow(currUser.id, widget.id)
        .catchError((error) {
      // revert changes
      setState(() {
        if (isFollowing) {
          // follow
          userProfile.followers.add(currUser.id);
        } else {
          // unfollow
          userProfile.followers.remove(currUser.id);
        }
      });
    });
  }

  void openChatRoom() {
    final state = context.read<ChatroomCubit>().state;

    if (state is ChatroomLoaded) {
      final chatRooms = state.chatRooms;
      final ids = [currUser.id, widget.id];
      ids.sort();
      final chatRoomId = ids.join('_');

      bool chatRoomExist =
          chatRooms.where((chatRoom) => chatRoom.id == chatRoomId).isNotEmpty;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatroomPage(
            targetUserId: widget.id,
            chatRoomId: chatRoomId,
            chatRoomExist: chatRoomExist,
          ),
        ),
      );
    }

    if (state is ChatroomError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.message)));
      print(state.message);
    }
  }

  void init() {
    context.read<ProfileCubit>().fetchProfile(widget.id);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    bool selfProfile = widget.id == currUser.id;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // profile loaded
        if (state is ProfileLoaded) {
          final userProfile = state.userProfile;

          return Scaffold(
            // appbar
            appBar: AppBar(
              title: Text(userProfile.email),
              // titleTextStyle: const TextStyle(
              //   color: Colors.black,
              //   fontSize: 18,
              // ),
              centerTitle: false,
              actions: [
                selfProfile
                    ? PopupMenuButton(
                        icon: const Icon(Icons.menu),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              context.read<AuthCubit>().logout();
                            },
                            child: const Text('Log out'),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),

            // body
            body: ListView(
              children: [
                // profile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // pfp and stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // profile picture
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                userProfile.profileImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'images/default_pfp.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          // stats
                          Column(
                            children: [
                              BlocBuilder<ProfilePostCubit, PostState>(
                                builder: (context, state) {
                                  if (state is PostsLoaded) {
                                    return Text(state.posts.length.toString());
                                  }
                                  return const Text('0');
                                },
                              ),
                              const Text('Posts'),
                            ],
                          ),

                          // followers
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FollowListPage(
                                  title: 'Followers',
                                  userIds: userProfile.followers,
                                ),
                              ),
                            ).then((value) => init()),
                            child: Column(children: [
                              Text(userProfile.followers.length.toString()),
                              const Text('Followers'),
                            ]),
                          ),

                          // followings
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FollowListPage(
                                  title: 'Following',
                                  userIds: userProfile.following,
                                ),
                              ),
                            ).then((value) => init()),
                            child: Column(children: [
                              Text(userProfile.following.length.toString()),
                              const Text('Following'),
                            ]),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // name
                      Text(
                        userProfile.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      // bio
                      Text(userProfile.bio.isEmpty
                          ? 'No bio set'
                          : userProfile.bio),

                      const SizedBox(height: 15),

                      // edit profile button
                      selfProfile
                          ? WhiteButton(
                              text: 'Edit Profile',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                    id: userProfile.id,
                                    name: userProfile.name,
                                    profileImageUrl:
                                        userProfile.profileImageUrl,
                                    bio: userProfile.bio,
                                  ),
                                ),
                              ),
                              width: double.infinity,
                              height: 30,
                            )

                          // follow/unfollow, message button
                          : Row(
                              children: [
                                Expanded(
                                  child: FollowButton(
                                    isFollowing: userProfile.followers
                                        .contains(currUser.id),
                                    toggleFollow: toggleFollow,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: WhiteButton(
                                    text: 'Message',
                                    onTap: openChatRoom,
                                    width: double.infinity,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                IgnorePointer(
                  child: DefaultTabController(
                    length: 3,
                    child: TabBar(
                      indicatorColor: Colors.black,
                      dividerColor: Colors.grey.shade200,
                      tabs: [
                        const Tab(
                          icon: ImageIcon(
                            AssetImage('icons/grid.png'),
                            color: Colors.black,
                          ),
                        ),
                        Tab(
                          icon: ImageIcon(
                            const AssetImage('icons/reels.png'),
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Tab(
                          icon: ImageIcon(
                            const AssetImage('icons/tags.png'),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 1),

                BlocConsumer<PostCubit, PostState>(
                  builder: (context, state) {
                    // loaded
                    if (state is PostsLoaded) {
                      final posts = state.posts
                          .where((post) => post.userId == widget.id)
                          .toList();
                      // user have post
                      if (posts.isNotEmpty) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                            crossAxisCount: 3,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePosts(posts: posts, index: index),
                                ),
                              ),
                              child: Image.network(post.imageUrl),
                            );
                          },
                        );
                      }

                      // no posts
                      else {
                        return const Center(child: Text('No posts'));
                      }
                    }

                    // loading
                    else if (state is PostsLoading || state is PostUploaded) {
                      return const SizedBox();
                    }

                    // other
                    else {
                      return const Center(child: Text('Something went wrong'));
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

        // loading
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // other
        else {
          return const Scaffold(
            body: Center(child: Text('Profile not found')),
          );
        }
      },
    );
  }
}
