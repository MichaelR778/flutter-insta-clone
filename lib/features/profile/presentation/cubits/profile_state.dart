import 'package:social/features/profile/domain/entities/profile_user.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileUser userProfile;
  ProfileLoaded({required this.userProfile});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
