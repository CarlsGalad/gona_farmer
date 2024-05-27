import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  LiveChatScreenState createState() => LiveChatScreenState();
}

class LiveChatScreenState extends State<LiveChatScreen> {
  String? selectedChatId;
  String? selectedChatTitle;
  final TextEditingController _messageController = TextEditingController();

  Future<void> _createNewChat() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final chatData = {
      'title': 'Chat with Admin',
      'senderName': user.displayName ?? 'Anonymous',
      'senderId': user.uid,
      'adminId': 'live_chat', // Set the admin ID to 'live_chat'
      'timestamp': FieldValue.serverTimestamp(),
    };

    final newChat =
        await FirebaseFirestore.instance.collection('liveChats').add(chatData);
    setState(() {
      selectedChatId = newChat.id;
      selectedChatTitle = chatData['title'] as String?;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat with Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewChat,
          ),
        ],
      ),
      body: Row(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              color: Colors.black12,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('liveChats')
                        .where('senderId',
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final chats = snapshot.data!.docs;
                      if (chats.isEmpty) {
                        return const Center(child: Text('No chats available'));
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            return ListTile(
                              title: Text(chat['title']),
                              subtitle: Text(chat['senderName']),
                              onTap: () {
                                setState(() {
                                  selectedChatId = chat.id;
                                  selectedChatTitle = chat['title'];
                                });
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            width: 2,
            color: Color.fromARGB(255, 26, 25, 25),
          ),
          Flexible(
            flex: 3,
            child: selectedChatId == null
                ? const Center(
                    child: Text('Please select a chat'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          selectedChatTitle ?? 'Message Title',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('liveChats')
                                .doc(selectedChatId)
                                .collection('messages')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final messages = snapshot.data!.docs;
                              if (messages.isEmpty) {
                                return const Center(
                                    child: Text('No messages in this chat'));
                              }
                              return ListView.builder(
                                reverse: true,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message = messages[index];
                                  return ChatBubble(
                                    message: message['content'],
                                    isSender: message['senderId'] ==
                                        FirebaseAuth.instance.currentUser!.uid,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  fillColor: Colors.black12,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () async {
                                if (_messageController.text.trim().isEmpty) {
                                  return;
                                }
                                final user = FirebaseAuth.instance.currentUser;
                                if (user == null || selectedChatId == null) {
                                  return;
                                }

                                await FirebaseFirestore.instance
                                    .collection('liveChats')
                                    .doc(selectedChatId)
                                    .collection('messages')
                                    .add({
                                  'content': _messageController.text.trim(),
                                  'senderId': user.uid,
                                  'timestamp': FieldValue.serverTimestamp(),
                                });
                                _messageController.clear();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const ChatBubble({super.key, required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSender ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
