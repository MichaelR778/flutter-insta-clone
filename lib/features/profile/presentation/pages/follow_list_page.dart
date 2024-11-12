import 'package:flutter/material.dart';
import 'package:social/features/profile/presentation/components/follow_list_tile.dart';

class FollowListPage extends StatelessWidget {
  final List<String> userIds;
  final String title;

  const FollowListPage({
    super.key,
    required this.userIds,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: userIds.length,
        itemBuilder: (context, index) {
          return FollowListTile(userId: userIds[index]);
        },
      ),
    );
  }
}
