import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:social/features/core/presentation/components/white_button.dart';
import 'package:social/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social/features/profile/presentation/pages/profile_page.dart';

class FollowListTile extends StatefulWidget {
  final String userId;

  const FollowListTile({super.key, required this.userId});

  @override
  State<FollowListTile> createState() => _FollowListTileState();
}

class _FollowListTileState extends State<FollowListTile> {
  String profileImageUrl = '';
  String userName = '';

  void fetchProfile() async {
    final userProfile =
        await context.read<ProfileCubit>().getProfile(widget.userId);
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(id: widget.userId),
        ),
      ),
      // profile picture
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

      // username
      title: Text(
        userName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
