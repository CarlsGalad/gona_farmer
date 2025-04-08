import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';
import '../../provider/chat_customers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String userId;
  final String userName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.userId,
    required this.userName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final bool _isTyping = false;
  bool _isOnline = false; // This could be fetched from Firestore in a real app

  @override
  void initState() {
    super.initState();
    // Mark chat as read when opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).markChatAsRead(widget.chatId);
    });

    // Fetch online status (in a real app)
    _fetchUserStatus();
  }

  Future<void> _fetchUserStatus() async {
    // This would be replaced with actual Firestore logic
    // For demo, we'll just set it to true after a delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isOnline = true;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessagesStream = ref.watch(chatMessagesProvider(widget.chatId));
    final otherUserDetails = ref.watch(FutureProvider((ref) =>
        ref.watch(chatProvider.notifier).getUserDetails(widget.userId)));

    return Scaffold(
      appBar: _buildAppBar(otherUserDetails),
      body: Column(
        children: [
          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.userName} is typing...',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ).animate().fadeIn(),

          Expanded(
            child: chatMessagesStream.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return _buildEmptyChat();
                }
                return _buildChatList(messages);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        "Error loading messages",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(chatMessagesProvider(widget.chatId)),
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      AsyncValue<Map<String, dynamic>> userDetails) {
    return AppBar(
      elevation: 1,
      title: Row(
        children: [
          userDetails.when(
            data: (data) {
              // Check if profile image exists
              final hasProfileImage = data.containsKey('profileImage') &&
                  data['profileImage'] != null;

              return hasProfileImage
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(data['profileImage']),
                      radius: 20,
                    )
                  : CircleAvatar(
                      backgroundColor: AppColors.primaryColor.withAlpha(26),
                      radius: 20,
                      child: Text(
                        widget.userName[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
            },
            loading: () => CircleAvatar(
              backgroundColor: AppColors.primaryColor.withAlpha(26),
              radius: 20,
              child: const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            error: (_, __) => CircleAvatar(
              backgroundColor: AppColors.primaryColor.withAlpha(26),
              radius: 20,
              child: Text(
                widget.userName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isOnline
                            ? AppColors.primaryColor
                            : AppColors.textOnDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.phone_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Call feature not implemented yet")),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'clear':
                _showClearChatDialog();
                break;
              case 'block':
                _showBlockUserDialog();
                break;
              case 'report':
                _showReportDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20),
                  SizedBox(width: 8),
                  Text('Clear chat'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  Icon(Icons.block, size: 20),
                  SizedBox(width: 8),
                  Text('Block user'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, size: 20),
                  SizedBox(width: 8),
                  Text('Report'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear this chat?'),
        content: const Text(
            'This will delete all messages in this conversation. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement clear chat functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chat cleared")),
              );
            },
            child: const Text('CLEAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBlockUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block ${widget.userName}?'),
        content: Text(
            'You will no longer receive messages from ${widget.userName}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement block user functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${widget.userName} blocked")),
              );
            },
            child: const Text('BLOCK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report ${widget.userName}?'),
        content: const Text('Please select a reason for reporting this user.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement report functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Report submitted")),
              );
            },
            child: const Text('REPORT'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textOnDark,
          ),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start the conversation with ${widget.userName}',
            style: const TextStyle(
              color: AppColors.textOnDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _messageController.text = "Hi ${widget.userName}! How are you?";
              FocusScope.of(context).requestFocus(FocusNode());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Start conversation"),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildChatList(List<Map<String, dynamic>> messages) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final bool isMe = message['senderId'] == ref.watch(userIdProvider);
        final DateTime timestamp = message['timestamp'] != null
            ? (message['timestamp'] as Timestamp).toDate()
            : DateTime.now();

        // Check if this is the first message of the day
        bool showDateHeader = false;
        if (index == messages.length - 1) {
          showDateHeader = true;
        } else if (index < messages.length - 1) {
          final DateTime previousTimestamp =
              messages[index + 1]['timestamp'] != null
                  ? (messages[index + 1]['timestamp'] as Timestamp).toDate()
                  : DateTime.now();

          showDateHeader = !_isSameDay(timestamp, previousTimestamp);
        }

        return Column(
          children: [
            if (showDateHeader) _buildDateHeader(timestamp),
            _buildMessageBubble(
              message: message['text'],
              isMe: isMe,
              timestamp: timestamp,
              index: index,
            ),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildDateHeader(DateTime timestamp) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    String dateText;

    if (_isSameDay(timestamp, now)) {
      dateText = 'Today';
    } else if (_isSameDay(timestamp, yesterday)) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMMM dd, yyyy').format(timestamp);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              dateText,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isMe,
    required DateTime timestamp,
    required int index,
  }) {
    final timeString = DateFormat('h:mm a').format(timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryDark : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : null,
            bottomLeft: !isMe ? const Radius.circular(0) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeString,
                  style: TextStyle(
                    color: isMe
                        ? Colors.white.withAlpha(182)
                        : AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: Colors.white.withAlpha(182),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: 50 * index),
        );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: AppColors.primaryColor),
              onPressed: () {
                _showAttachmentOptions();
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: AppColors.textHint),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: AppColors.textSecondary),
                    onPressed: () {
                      // Show emoji picker
                    },
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (text) {
                  // Here you could implement typing indicator logic
                  // For example, notify the other user that this user is typing
                },
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Attach',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.photo,
                    label: 'Gallery',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      // Implement gallery picker
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      // Implement camera
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file,
                    label: 'Document',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      // Implement document picker
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.location_on,
                    label: 'Location',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      // Implement location picker
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withAlpha(52),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      await ref
          .read(chatProvider.notifier)
          .sendMessage(widget.chatId, message, widget.userId);
      _messageController.clear();

      // Scroll to bottom after sending
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send message: $e")));
      }
    }
  }
}
