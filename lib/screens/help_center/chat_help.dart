import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back)),
        title: Text(
          'Chat',
          style: GoogleFonts.bebasNeue(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: ChatMessages()),
            BottomAppBar(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        String message = _messageController.text;
                        if (message.isNotEmpty) {
                          // Get recipient's user ID (for example, hardcoding it here)
                          String recipientId = 'scg0NQ8alasA6Rkt9d1R';
                          addMessage(message, recipientId);
                          _messageController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addMessage(String message, String userId) async {
    try {
      String? senderId = FirebaseAuth.instance.currentUser?.uid;
      if (senderId != null) {
        String recipientId = 'scg0NQ8alasA6Rkt9d1R';
        DocumentReference documentReference =
            await FirebaseFirestore.instance.collection('messages').add({
          'senderId': senderId,
          'recipientId': recipientId,
          'message': message,
          'timestamp': DateTime.now(),
        });
        print('Message added with ID: ${documentReference.id}');
      } else {
        print('User not authenticated');
      }
    } catch (e) {
      print('Error adding message: $e');
    }
  }
}

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      // If user is not authenticated, return a placeholder widget
      return const Center(
        child: Text('User not authenticated'),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('senderId',
              isEqualTo: currentUserId) // Filter by senderId for current user
          .where('recipientId',
              isEqualTo:
                  'scg0NQ8alasA6Rkt9d1R') // Filter by recipientId for customer care
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading messages'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages'),
          );
        }

        // Also fetch messages where current user is the recipient and customer care is the sender
        // ignore: unused_local_variable
        var secondStream = FirebaseFirestore.instance
            .collection('messages')
            .where('senderId',
                isEqualTo:
                    'scg0NQ8alasA6Rkt9d1R') // Filter by senderId for customer care
            .where('recipientId',
                isEqualTo:
                    currentUserId) // Filter by recipientId for current user
            .snapshots();

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 50, top: 4, bottom: 4),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(184, 181, 181, 1),
                      offset: Offset(5, 2),
                      blurRadius: 6.0,
                      spreadRadius: 3.0,
                      blurStyle: BlurStyle.normal,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 0.9),
                      offset: Offset(-6, -2),
                      blurRadius: 5.0,
                      spreadRadius: 3.0,
                    ),
                  ],
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white),
                ),
                child: ListTile(
                  title: Text(
                    data['message'],
                    style: GoogleFonts.abel(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
