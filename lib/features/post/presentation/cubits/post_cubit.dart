import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/post/domain/entities/comment.dart';
import 'package:social/features/post/domain/entities/post.dart';
import 'package:social/features/post/domain/repos/post_repo.dart';
import 'package:social/features/post/presentation/cubits/post_state.dart';
import 'package:social/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  final List<Post> _posts = []; // save posts locally for quick update

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostsLoading());

  Future<void> createPost(
    String userId,
    String userName,
    String caption,
    String imagePath,
  ) async {
    try {
      final postId = DateTime.now().millisecondsSinceEpoch.toString();

      final imageUrl = await storageRepo.uploadPostImage(
        imagePath,
        '${userId}_$postId',
      );

      final newPost = Post(
        id: postId,
        userId: userId,
        caption: caption,
        imageUrl: imageUrl,
        timestamp: Timestamp.fromDate(DateTime.now()),
        likes: [],
        comments: [],
      );

      await postRepo.createPost(newPost);

      // add post locally
      _posts.insert(0, newPost);

      emit(PostUploaded());
      emit(PostsLoaded(posts: _posts));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
      emit(PostDeleted(postId: postId));

      // delete post locally
      _posts.removeWhere((post) => post.id == postId);
      emit(PostsLoaded(posts: _posts));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      _posts.clear();
      final posts = await postRepo.fetchAllPosts();
      _posts.addAll(posts);
      emit(PostsLoaded(posts: _posts));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      await postRepo.toggleLike(postId, userId);

      // sneaky update
      _posts.clear();
      final posts = await postRepo.fetchAllPosts();
      _posts.addAll(posts);
      emit(PostsLoaded(posts: _posts));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }
}
