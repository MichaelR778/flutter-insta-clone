import 'package:social/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser> fetchProfile(String id);
  Future<void> updateProfile(ProfileUser updatedProfile);
  Future<void> toggleFollow(String currUid, String targetUid);
}
