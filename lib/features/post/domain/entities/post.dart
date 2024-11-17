import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/features/post/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String caption;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.caption,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'caption': caption,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Comment> comments = (json['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];

    return Post(
      id: json['id'],
      userId: json['userId'],
      caption: json['caption'],
      imageUrl: json['imageUrl'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(json['likes']),
      comments: comments,
    );
  }
}
