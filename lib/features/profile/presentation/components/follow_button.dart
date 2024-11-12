import 'package:flutter/material.dart';
import 'package:social/core/presentation/components/blue_button.dart';
import 'package:social/core/presentation/components/white_button.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final void Function()? toggleFollow;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.toggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    return isFollowing
        ? WhiteButton(
            text: 'Unfollow',
            onTap: toggleFollow,
            width: double.infinity,
            height: 30,
          )
        : BlueButton(
            text: 'Follow',
            onTap: toggleFollow,
            width: double.infinity,
            height: 30,
          );
  }
}
