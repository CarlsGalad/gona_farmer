import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String content;
  final String senderId;
  final Timestamp timestamp;

  ChatMessageModel({
    required this.content,
    required this.senderId,
    required this.timestamp,
  });

  factory ChatMessageModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ChatMessageModel(
      content: data['content'] as String,
      senderId: data['senderId'] as String,
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }
}

class ChatModel {
  final String id;
  final String title;
  final String senderName;
  final String senderId;
  final String adminId;
  final Timestamp timestamp;

  ChatModel({
    required this.id,
    required this.title,
    required this.senderName,
    required this.senderId,
    required this.adminId,
    required this.timestamp,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ChatModel(
      id: doc.id,
      title: data['title'] as String,
      senderName: data['senderName'] as String,
      senderId: data['senderId'] as String,
      adminId: data['adminId'] as String,
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'senderName': senderName,
      'senderId': senderId,
      'adminId': adminId,
      'timestamp': timestamp,
    };
  }
}
