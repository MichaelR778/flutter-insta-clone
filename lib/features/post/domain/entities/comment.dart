import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final Timestamp timestamp;

  Comment(
      {required this.id,
      required this.postId,
      required this.userId,
      required this.text,
      required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      text: json['text'],
      timestamp: json['timestamp'],
    );
  }
}
