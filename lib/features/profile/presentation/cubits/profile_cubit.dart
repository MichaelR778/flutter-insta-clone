import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/profile/domain/entities/profile_user.dart';
import 'package:social/features/profile/domain/repos/profile_repo.dart';
import 'package:social/features/profile/presentation/cubits/profile_state.dart';
import 'package:social/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({
    required this.profileRepo,
    required this.storageRepo,
  }) : super(ProfileLoading());

  Future<void> fetchProfile(String id) async {
    try {
      emit(ProfileLoading());
      final userProfile = await profileRepo.fetchProfile(id);
      emit(ProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<ProfileUser> getProfile(String id) async {
    return profileRepo.fetchProfile(id);
  }

  Future<void> updateProfile({
    required String id,
    String? newName,
    String? newProfileImagePath,
    String? newBio,
  }) async {
    try {
      emit(ProfileLoading());

      String? imageUrl;
      if (newProfileImagePath != null) {
        imageUrl =
            await storageRepo.uploadProfilePicture(newProfileImagePath, id);
      }

      final userProfile = await profileRepo.fetchProfile(id);
      final updatedProfile = userProfile.copyWith(
        newName: newName,
        newProfileImageUrl: imageUrl,
        newBio: newBio,
      );

      await profileRepo.updateProfile(updatedProfile);
      fetchProfile(id);
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> toggleFollow(String currUid, String targetUid) async {
    try {
      await profileRepo.toggleFollow(currUid, targetUid);
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
