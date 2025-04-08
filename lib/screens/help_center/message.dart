import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../provider/chat_messages.dart'; // Import your app colors

class ChatMessagesScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String? chatTitle;

  const ChatMessagesScreen({
    super.key,
    required this.chatId,
    this.chatTitle,
  });

  @override
  ChatMessagesScreenState createState() => ChatMessagesScreenState();
}

class ChatMessagesScreenState extends ConsumerState<ChatMessagesScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose(); // Dispose the ScrollController
    _animationController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(sendMessageProvider({
        'chatId': widget.chatId,
        'content': _messageController.text.trim(),
      }).future); // Use .future
      _messageController.clear();

      // Scroll to bottom after sending message.  Wrapped in a Future.delayed
      // to ensure the UI has updated.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0, // Scroll to the top (since the list is reversed)
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (!mounted) return; // Prevent interacting with unmounted context.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error sending message: $e"),
          backgroundColor: AppColors.error, // Use your error color
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      //Use mounted to prevent interacting with unmounted context.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.chatTitle ?? AppLocalizations.of(context)!.message_title,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: FadeTransition(
        // Add FadeTransition for animation
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: ChatMessages(
                  chatId: widget.chatId,
                  scrollController:
                      _scrollController, // Pass the ScrollController
                ),
              ),
            ),
            _buildMessageInput(), // Input field at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white, // White background for input area
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.type_a_message,
                  hintStyle: GoogleFonts.poppins(
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                textCapitalization:
                    TextCapitalization.sentences, // Capitalize sentences
                maxLines: null, // Allow multiple lines
                textInputAction:
                    TextInputAction.send, //Show send on the keyboard
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.accentColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      // Show loading indicator
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
              onPressed: _isLoading
                  ? null
                  : _sendMessage, // Disable button during loading
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessages extends ConsumerWidget {
  final String chatId;
  final ScrollController? scrollController; // Add ScrollController

  const ChatMessages({
    super.key,
    required this.chatId,
    this.scrollController, // Make it optional
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsyncValue = ref.watch(chatMessagesStreamProvider(chatId));

    return messagesAsyncValue.when(
      data: (messages) {
        if (messages.isEmpty) {
          return _buildEmptyState(context);
        }
        return ListView.builder(
          controller: scrollController, // Use the provided ScrollController
          reverse: true,
          padding: EdgeInsets.zero,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isSender =
                message.senderId == FirebaseAuth.instance.currentUser!.uid;
            return ChatBubble(
              message: message.content,
              isSender: isSender,
              timestamp: message.timestamp.toDate(),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppColors.accentColor,
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              "Error: $error",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textSecondary.withAlpha(128), // Use AppColors
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.no_messages_in_this_chat,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary, // Use AppColors
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Send your first message to start the conversation', //Use localized string
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary, // Use AppColors
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final DateTime? timestamp; // Add timestamp

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    this.timestamp, // Make it optional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // Add vertical padding
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end, // Align to bottom
        children: [
          if (!isSender) ...[
            // Profile icon for other users
            Container(
              width: 32, // Adjust size as needed
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight, // Use AppColors
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent, // Example icon, change as needed
                color: AppColors.accentColor, // Use AppColors
                size: 16, //Adjust size as needed
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSender ? AppColors.accentColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isSender ? 16 : 4),
                  bottomRight: Radius.circular(isSender ? 4 : 16),
                ),
                border: isSender
                    ? null
                    : Border.all(color: AppColors.border), // Use AppColors
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                // Use Column for message and timestamp
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isSender
                          ? Colors.white
                          : AppColors.textPrimary, // Use AppColors
                    ),
                  ),
                  if (timestamp != null) ...[
                    // Show timestamp if available
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(timestamp!), // Format the timestamp
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: isSender
                            ? Colors.white.withAlpha(182)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isSender) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight, // Use AppColors
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person, // Use profile icon
                color: AppColors.accentColor, // Use AppColors
                size: 16,
              ),
            ), // Profile icon for the user
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return 'Today ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
