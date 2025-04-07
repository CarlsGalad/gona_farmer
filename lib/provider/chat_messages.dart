import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gona_vendor/models/chat_messages.dart';

final chatCollectionProvider =
    Provider<CollectionReference<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance.collection('liveChats');
});

// Provider to create a new chat
final createChatProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, chatData) async {
  final collection = ref.read(chatCollectionProvider);
  await collection.add(chatData);
});

// Provider to stream the list of chats
final chatListStreamProvider = StreamProvider<List<ChatModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }

  final collection = ref.watch(chatCollectionProvider);
  return collection
      .where('senderId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList();
  });
});

// Provider to stream chat messages for a specific chat
final chatMessagesStreamProvider =
    StreamProvider.family<List<ChatMessageModel>, String>((ref, chatId) {
  final collection = ref.watch(chatCollectionProvider);
  return collection
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => ChatMessageModel.fromFirestore(doc))
        .toList();
  });
});

// Provider to send a message
final sendMessageProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, messageData) async {
  final chatId = messageData['chatId'] as String;
  final content = messageData['content'] as String;

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User not logged in"); // Or handle appropriately
  }

  final collection = ref.read(chatCollectionProvider);
  await collection.doc(chatId).collection('messages').add({
    'content': content,
    'senderId': user.uid,
    'timestamp': FieldValue.serverTimestamp(),
  });
});
