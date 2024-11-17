import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social/features/home/presentation/pages/home_page.dart';
import 'package:social/features/post/presentation/cubits/post_cubit.dart';
import 'package:social/features/post/presentation/cubits/post_state.dart';
import 'package:social/features/post/presentation/pages/create_post_page.dart';
import 'package:social/features/profile/presentation/pages/profile_page.dart';
import 'package:social/core/presentation/pages/pull_refresh_page.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late final currUser = context.read<AuthCubit>().currUser;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currUser = context.read<AuthCubit>().currUser!;
    return Scaffold(
      body: BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostUploaded) {
            setState(() {
              pageIndex = 0;
            });
          }
        },
        child: [
          const HomePage(),
          // Scaffold(body: Center(child: Text('Explore'))),
          const PullRefreshPage(),
          const Placeholder(),
          const Scaffold(body: Center(child: Text('Reels'))),
          ProfilePage(id: currUser.id),
        ][pageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        height: 55,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: ImageIcon(AssetImage('icons/home_unselected.png')),
            selectedIcon: ImageIcon(AssetImage('icons/home_selected.png')),
            label: 'Home',
          ),
          NavigationDestination(
            icon: ImageIcon(AssetImage('icons/search_unselected.png')),
            selectedIcon: ImageIcon(AssetImage('icons/search_selected.png')),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: ImageIcon(AssetImage('icons/Add.png')),
            selectedIcon: Icon(Icons.add_box),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: ImageIcon(AssetImage('icons/reels_unselected.png')),
            selectedIcon: ImageIcon(AssetImage('icons/reels_selected.png')),
            label: 'Reels',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
        selectedIndex: pageIndex,
        onDestinationSelected: (value) {
          if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePostPage(),
              ),
            );
            return;
          }
          setState(() {
            pageIndex = value;
          });
        },
      ),
    );
  }
}
