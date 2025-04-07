import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_customers.g.dart';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@riverpod
String? userId(Ref ref) {
  return ref.watch(firebaseAuthProvider).currentUser?.uid;
}

@riverpod
class Chat extends _$Chat {
  @override
  FutureOr<void> build() {
    return Future.value();
  }

  Stream<List<Map<String, dynamic>>> getChats() {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return Stream.value([]);
    }

    final firestore = ref.watch(firebaseFirestoreProvider);
    return firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        List<dynamic> participants = doc['participants'];
        String otherParticipantId =
            participants.firstWhere((id) => id != userId);

        return {
          'chatId': doc.id,
          'otherParticipantId': otherParticipantId,
          'lastMessage': doc['lastMessage'] ?? '',
          'lastMessageTime': doc['lastMessageTime'],
          'unread': doc['unreadByFarm'] ??
              false, // Include unread status specifically for the farm
        };
      }).toList();
    });
  }

  Future<void> sendMessage(
      String chatId, String messageText, String receiverId) async {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      throw Exception("User not authenticated");
    }

    if (messageText.trim().isEmpty) return;

    final firestore = ref.watch(firebaseFirestoreProvider);
    try {
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': userId,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Check who is sending the message
      bool isSenderFarm = await _isFarm(userId);

      await firestore.collection('chats').doc(chatId).update({
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        // Set unread flags based on who is sending the message
        'unreadByUser': isSenderFarm ? true : false,
        'unreadByFarm': isSenderFarm ? false : true,
      });
    } catch (e) {
      debugPrint('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  // Helper method to determine if a user is a farm
  Future<bool> _isFarm(String uid) async {
    final firestore = ref.watch(firebaseFirestoreProvider);
    try {
      // Check if user exists in the farms collection
      DocumentSnapshot farmDoc =
          await firestore.collection('farms').doc(uid).get();
      return farmDoc.exists;
    } catch (e) {
      debugPrint("Error checking if user is farm: $e");
      return false;
    }
  }

  // Mark messages as read when opening a chat
  Future<void> markChatAsRead(String chatId) async {
    final userId = ref.watch(userIdProvider);
    if (userId == null) return;

    final firestore = ref.watch(firebaseFirestoreProvider);

    // Determine if current user is a farm
    bool isFarm = await _isFarm(userId);

    // Update the appropriate unread field
    if (isFarm) {
      await firestore.collection('chats').doc(chatId).update({
        'unreadByFarm': false,
      });
    } else {
      await firestore.collection('chats').doc(chatId).update({
        'unreadByUser': false,
      });
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    final firestore = ref.watch(firebaseFirestoreProvider);
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'senderId': doc['senderId'],
                'text': doc['text'],
                'timestamp': doc['timestamp'],
              })
          .toList();
    });
  }

  Future<String> initializeChat(String otherUserId) async {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      throw Exception("User not authenticated. Please sign in.");
    }

    List<String> ids = [userId, otherUserId];
    ids.sort();
    final chatId = ids.join('_');

    final firestore = ref.watch(firebaseFirestoreProvider);
    DocumentSnapshot chatDoc =
        await firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      await firestore.collection('chats').doc(chatId).set({
        'participants': [userId, otherUserId],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'unreadByFarm': false,
        'unreadByUser': false,
      });
    }
    return chatId;
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    final firestore = ref.watch(firebaseFirestoreProvider);
    try {
      // First check if the user exists in the users collection
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // If profile image is missing, try to get it
        if (!userData.containsKey('profileImage')) {
          userData['profileImage'] = null;
        }

        return userData;
      } else {
        // If not found in users, check farms collection as fallback
        DocumentSnapshot farmDoc =
            await firestore.collection('farms').doc(userId).get();

        if (farmDoc.exists) {
          return farmDoc.data() as Map<String, dynamic>;
        }

        return {'name': 'Unknown User'};
      }
    } catch (e) {
      debugPrint("Error fetching user details: $e");
      return {'name': 'Error'};
    }
  }
}

@riverpod
Stream<List<Map<String, dynamic>>> chatList(Ref ref) {
  return ref.watch(chatProvider.notifier).getChats();
}

@riverpod
Stream<List<Map<String, dynamic>>> chatMessages(Ref ref, String chatId) {
  // Mark as read when opening messages
  ref.watch(chatProvider.notifier).markChatAsRead(chatId);

  return ref.watch(chatProvider.notifier).getMessages(chatId);
}
