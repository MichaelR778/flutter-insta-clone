import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/post/domain/entities/comment.dart';
import 'package:social/features/post/domain/entities/post.dart';
import 'package:social/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> createPost(Post post) async {
    try {
      await firebaseFirestore
          .collection('posts')
          .doc(post.id)
          .set(post.toJson());
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await firebaseFirestore.collection('posts').doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postSnapshots = await firebaseFirestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      final posts =
          postSnapshots.docs.map((doc) => Post.fromJson(doc.data())).toList();

      return posts;
    } catch (e) {
      throw Exception('Error fetching all posts: $e');
    }
  }

  @override
  Future<List<Post>> fetchUserPosts(String userId) async {
    try {
      final postSnapshots = await firebaseFirestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();

      final posts =
          postSnapshots.docs.map((doc) => Post.fromJson(doc.data())).toList();
      posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return posts;
    } catch (e) {
      throw Exception('Error fetching user posts: $e');
    }
  }

  @override
  Future<void> toggleLike(String postId, String userId) async {
    try {
      final postDoc =
          await firebaseFirestore.collection('posts').doc(postId).get();

      if (!postDoc.exists) throw Exception('Post not found');

      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      final hasLiked = post.likes.contains(userId);

      if (hasLiked) {
        post.likes.remove(userId);
      } else {
        post.likes.add(userId);
      }

      await firebaseFirestore.collection('posts').doc(postId).update({
        'likes': post.likes,
      });
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      final postDoc =
          await firebaseFirestore.collection('posts').doc(postId).get();

      if (!postDoc.exists) throw Exception('Post not found');

      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      post.comments.add(comment);

      await firebaseFirestore.collection('posts').doc(postId).update({
        'comments': post.comments.map((comment) => comment.toJson()).toList(),
      });
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final postDoc =
          await firebaseFirestore.collection('posts').doc(postId).get();

      if (!postDoc.exists) throw Exception('Post not found');

      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      post.comments.removeWhere((comment) => comment.id == commentId);

      await firebaseFirestore.collection('posts').doc(postId).update({
        'comments': post.comments.map((comment) => comment.toJson()).toList(),
      });
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }
}
