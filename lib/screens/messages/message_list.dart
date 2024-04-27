import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../messages.dart';

class MessagesScreen extends StatefulWidget {
  final String recipientId; // Recipient's ID

  const MessagesScreen({super.key, required this.recipientId});

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back)),
        title: Text(
          'Messages',
          style: GoogleFonts.aboreto(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: widget.recipientId)
            .snapshots(), // Filter chats where recipient participates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No chats yet.'),
            );
          }
          final chats = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatData = chats[index].data() as Map<String, dynamic>;
              final participants = chatData['participants'] as List<dynamic>;
              // Get the other participant's ID (assuming there are 2)
              final otherParticipantId = participants
                  .firstWhere((id) => id != widget.recipientId) as String;

              // Display chat title (can be customized)
              String chatTitle = chatData['messageTitle'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipientMessageScreen(
                        senderId: otherParticipantId,
                        messageTitle: chatTitle,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
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
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(
                        chatTitle,
                        style: GoogleFonts.abel(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
