import 'package:social/features/post/domain/entities/comment.dart';
import 'package:social/features/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);
  Future<List<Post>> fetchAllPosts();
  Future<List<Post>> fetchUserPosts(String userId);
  Future<void> toggleLike(String postId, String userId);
  Future<void> addComment(String postId, Comment comment);
  Future<void> deleteComment(String postId, String commentId);
}
