import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/profile/domain/entities/profile_user.dart';
import 'package:social/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser> fetchProfile(String id) async {
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(id).get();

      if (!userDoc.exists) throw Exception('User not found');

      final userData = userDoc.data();

      return ProfileUser.fromJson(userData!);
    } catch (e) {
      throw Exception('Get profile failed: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      firebaseFirestore.collection('users').doc(updatedProfile.id).update({
        'profileImageUrl': updatedProfile.profileImageUrl,
        'bio': updatedProfile.bio,
        'name': updatedProfile.name,
      });
    } catch (e) {
      throw Exception('Update profile failed: $e');
    }
  }

  @override
  Future<void> toggleFollow(String currUid, String targetUid) async {
    try {
      final currUserRef = firebaseFirestore.collection('users').doc(currUid);
      final targetUserRef =
          firebaseFirestore.collection('users').doc(targetUid);

      final currDoc = await currUserRef.get();
      final targetDoc = await targetUserRef.get();

      if (!currDoc.exists || !targetDoc.exists) {
        throw Exception('User not found');
      }

      final currData = currDoc.data()!;

      final currFollowing = List<String>.from(currData['following'] ?? []);
      final isFollowing = currFollowing.contains(targetUid);

      if (isFollowing) {
        // unfollow
        await currUserRef.update({
          'following': FieldValue.arrayRemove([targetUid]),
        });
        await targetUserRef.update({
          'followers': FieldValue.arrayRemove([currUid]),
        });
      } else {
        // follow
        await currUserRef.update({
          'following': FieldValue.arrayUnion([targetUid]),
        });
        await targetUserRef.update({
          'followers': FieldValue.arrayUnion([currUid]),
        });
      }
    } catch (e) {
      throw Exception('Follow toggle failed: $e');
    }
  }
}
