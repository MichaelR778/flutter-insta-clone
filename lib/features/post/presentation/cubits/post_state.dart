import 'package:social/features/post/domain/entities/post.dart';

abstract class PostState {}

class PostsLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<Post> posts;
  PostsLoaded({required this.posts});
}

class PostError extends PostState {
  final String message;
  PostError({required this.message});
}

class PostUploaded extends PostState {}

class PostDeleted extends PostState {
  final String postId;
  PostDeleted({required this.postId});
}
