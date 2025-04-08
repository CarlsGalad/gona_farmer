import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../models/chat_messages.dart';
import '../../provider/chat_messages.dart';
import 'message.dart'; // Import screens

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends ConsumerState<ChatListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _createNewChat() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final chatData = {
      'title': 'Chat with Admin',
      'senderName': user.displayName ?? 'Anonymous',
      'senderId': user.uid,
      'adminId': 'live_chat',
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      // Use ref.read to call the provider
      await ref.read(createChatProvider(chatData).future);

      if (!mounted) return;

      // Fetch the updated chat list using ref.read.  Crucially, use .future to await completion.
      final chats = await ref.read(chatListStreamProvider.future);

      // Find the newly created chat.
      final newChat = chats.firstWhere(
        (chat) => chat.senderId == user.uid && chat.title == 'Chat with Admin',
        orElse: () => throw Exception('Chat not found after creation'),
      );

      // Navigate to the ChatMessagesScreen.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatMessagesScreen(
            chatId: newChat.id,
            chatTitle: newChat.title,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return; // Prevent interacting with unmounted context
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error creating chat: $e"),
          backgroundColor: AppColors.error, // Use your error color
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground, // Use AppColors
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary, // Use AppColors
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.live_chat_with_admin,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary, // Use AppColors
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.accentColor, // Use AppColors
            ),
            onPressed: _createNewChat,
            tooltip: AppLocalizations.of(context)!.live_chat,
          ),
        ],
      ),
      body: FadeTransition(
        // Wrap with FadeTransition
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChatListHeader(context), // Header
              const SizedBox(height: 16),
              Expanded(
                child: ChatList(
                  onChatSelected: (chatId, chatTitle) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatMessagesScreen(
                          chatId: chatId,
                          chatTitle: chatTitle,
                        ),
                      ),
                    );
                  },
                  selectedChatId: '',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewChat, // Call _createNewChat
        backgroundColor: AppColors.accentColor,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildChatListHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight, // Use AppColors
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 24,
              color: AppColors.accentColor, // Use AppColors
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Conversations', // Use localized string if needed
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary, // Use AppColors
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chat with our support team', //Use localized string
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary, // Use AppColors
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatList extends ConsumerWidget {
  final String? selectedChatId;
  final Function(String, String) onChatSelected;

  const ChatList({
    super.key,
    required this.selectedChatId,
    required this.onChatSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListAsyncValue = ref.watch(chatListStreamProvider);

    return chatListAsyncValue.when(
      data: (chats) {
        if (chats.isEmpty) {
          return _buildEmptyState(context);
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ListView.separated(
              padding: EdgeInsets.zero, // Remove extra padding
              itemCount: chats.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppColors.border.withAlpha(128), // Use AppColors
              ),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _buildChatItem(context, chat);
              },
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppColors.accentColor, // Use AppColors
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error, // Use AppColors
            ),
            const SizedBox(height: 16),
            Text(
              "Error: $error",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary, // Use AppColors
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
            AppLocalizations.of(context)!.no_chats_available,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary, // Use AppColors
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new chat with our support team', // Use localized string
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

  Widget _buildChatItem(BuildContext context, ChatModel chat) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.primaryLight, // Use AppColors
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.chat_bubble_outline,
          color: AppColors.accentColor, // Use AppColors
          size: 20,
        ),
      ),
      title: Text(
        chat.title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary, // Use AppColors
        ),
      ),
      subtitle: Text(
        chat.senderName,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.textSecondary, // Use AppColors
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary, // Use AppColors
      ),
      selected: chat.id == selectedChatId,
      selectedTileColor:
          AppColors.primaryLight.withOpacity(0.3), // Use AppColors
      onTap: () => onChatSelected(chat.id, chat.title),
    );
  }
}
