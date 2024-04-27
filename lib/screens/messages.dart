import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipientMessageScreen extends StatefulWidget {
  final String senderId; // Sender's ID
  final String messageTitle;

  const RecipientMessageScreen({
    super.key,
    required this.senderId,
    required this.messageTitle,
  });

  @override
  _RecipientMessageScreenState createState() => _RecipientMessageScreenState();
}

class _RecipientMessageScreenState extends State<RecipientMessageScreen> {
  final String _recipientId = FirebaseAuth.instance.currentUser!.uid;

  String _generateThreadId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return '<span class="math-inline">${sortedIds[0]}_</span>${sortedIds[1]}';
  }

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      String threadId = _generateThreadId(_recipientId, widget.senderId);

      // Construct the message object
      Map<String, dynamic> messageData = {
        'message': message,
        'senderId': _recipientId,
        'timestamp': Timestamp.now(),
      };

      // Add the message only under the recipient's ID
      FirebaseFirestore.instance.collection('chats').doc(threadId).update({
        'participants': FieldValue.arrayUnion([_recipientId, widget.senderId]),
        'thread': {
          _recipientId: FieldValue.arrayUnion([messageData]),
        },
      });

      // Clear the message field
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String threadId = _generateThreadId(_recipientId, widget.senderId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        title: Text(
          widget.messageTitle,
          style: GoogleFonts.aboreto(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(threadId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  // Handle error
                  print('Error: ${snapshot.error}');
                  return const Center(
                    child: Text('An error occurred while fetching data.'),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text('No messages yet.'),
                  );
                }

                final threadData =
                    snapshot.data!.data() as Map<String, dynamic>;
                final thread = threadData['thread'] as Map<String, dynamic>;

                // Inside the StreamBuilder builder function
                return ListView.builder(
                  reverse: true, // Display newest messages at the top
                  itemCount: thread.length,
                  itemBuilder: (context, index) {
                    final message = thread.entries
                        .elementAt(index)
                        .value; // Access message data
                    final String senderId =
                        thread.entries.elementAt(index).key; // Get sender ID

                    return _buildMessageBubble(message, senderId);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add a new method to build each message bubble
  Widget _buildMessageBubble(Map<String, dynamic> message, String senderId) {
    final bool isRecipientMessage = senderId == _recipientId;
    final Timestamp timestamp = message['timestamp'] as Timestamp;
    final String formattedTime = _formatTimestamp(timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: isRecipientMessage
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          // Display message content
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isRecipientMessage ? Colors.grey[300] : Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message['message'],
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          // Display timestamp (optional)
          if (isRecipientMessage)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }

// Add a method to format the timestamp (optional)
  String _formatTimestamp(Timestamp timestamp) {
    // Implement your desired timestamp formatting logic here (e.g., hh:mm AM/PM)
    // You can use DateFormat from package:intl
    return timestamp.toDate().toString(); // Replace with your formatting
  }
}
