import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final List<String> participantIds;
  final DateTime lastMessageTime;

  ChatRoom({
    required this.id,
    required this.participantIds,
    required this.lastMessageTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      participantIds: List<String>.from(json['participantIds']),
      lastMessageTime: (json['lastMessageTime'] as Timestamp).toDate(),
    );
  }
}
