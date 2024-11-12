import 'package:social/features/auth/domain/entities/auth_user.dart';

class ProfileUser extends AuthUser {
  final String profileImageUrl;
  final String bio;
  final List<String> followers;
  final List<String> following;

  ProfileUser({
    required super.id,
    required super.email,
    required super.name,
    required this.profileImageUrl,
    required this.bio,
    required this.followers,
    required this.following,
  });

  ProfileUser copyWith({
    String? newName,
    String? newProfileImageUrl,
    String? newBio,
  }) {
    return ProfileUser(
      id: id,
      email: email,
      name: newName ?? name,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      bio: newBio ?? bio,
      followers: followers,
      following: following,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'followers': followers,
      'following': following,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profileImageUrl: json['profileImageUrl'] ?? '',
      bio: json['bio'] ?? '',
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }
}
