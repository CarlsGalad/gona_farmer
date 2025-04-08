import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';
import '../../provider/chat_customers.dart';
import 'chat.dart';

class MessageList extends ConsumerStatefulWidget {
  const MessageList({super.key});

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatListStream = ref.watch(chatListProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          _buildAppBar(),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isSearching ? _buildSearchBar() : const SizedBox.shrink(),
          ),
          Expanded(
            child: chatListStream.when(
              data: (chats) {
                // Filter chats based on search query
                List<Map<String, dynamic>> filteredChats = chats;
                if (_searchQuery.isNotEmpty) {
                  filteredChats = chats.where((chat) {
                    final userName = chat['userName'] as String? ?? '';
                    final lastMessage = chat['lastMessage'] as String? ?? '';
                    return userName
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        lastMessage
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                  }).toList();
                }

                if (filteredChats.isEmpty) {
                  return _searchQuery.isNotEmpty
                      ? _buildNoSearchResultsState()
                      : _buildEmptyState();
                }

                return _buildChatList(filteredChats);
              },
              loading: () => _buildLoadingState(),
              error: (error, stackTrace) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Messages',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: AppColors.primaryColor.withAlpha(26),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: GoogleFonts.poppins(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(chatListProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 600.ms,
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat_bubble_outline,
                size: 80, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            'No conversations yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Connect with customers to chat about your products',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 600.ms,
          ),
    );
  }

  Widget _buildNoSearchResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            'No results found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'No conversations match "$_searchQuery"',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
              });
            },
            icon: const Icon(Icons.clear),
            label: const Text('Clear Search'),
            style:
                TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildChatList(List<Map<String, dynamic>> chats) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final otherParticipantId = chat['otherParticipantId'] as String;
        final lastMessage = chat['lastMessage'] as String? ?? 'No messages';
        final lastMessageTime = chat['lastMessageTime'] as Timestamp?;
        final isUnread = chat['unread'] as bool? ?? false;

        return FutureBuilder<Map<String, dynamic>>(
          future: ref
              .read(chatProvider.notifier)
              .getUserDetails(otherParticipantId),
          builder: (context, userSnapshot) {
            String userName = 'Loading...';
            String? userImage;
            bool isLoading =
                userSnapshot.connectionState == ConnectionState.waiting;

            if (!isLoading && userSnapshot.data != null) {
              userName =
                  userSnapshot.data!['name'] as String? ?? 'Unknown user';
              userImage = userSnapshot.data!['profileImage'] as String?;
              chat['userName'] = userName; // Cache the name
              chat['userImage'] = userImage; // Cache the image URL
            }

            return _buildChatTile(
              userName: userName,
              userImage: userImage,
              lastMessage: lastMessage,
              lastMessageTime: lastMessageTime,
              isUnread: isUnread,
              isLoading: isLoading,
              onTap: () async {
                if (isLoading) return;

                final chatId = await ref
                    .read(chatProvider.notifier)
                    .initializeChat(otherParticipantId);

                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatId: chatId,
                        userId: otherParticipantId,
                        userName: userName,
                      ),
                    ),
                  );
                }
              },
              index: index,
            );
          },
        );
      },
    );
  }

  Widget _buildChatTile({
    required String userName,
    String? userImage,
    required String lastMessage,
    required Timestamp? lastMessageTime,
    required bool isUnread,
    required bool isLoading,
    required VoidCallback onTap,
    required int index,
  }) {
    String timeText = '';
    if (lastMessageTime != null) {
      final now = DateTime.now();
      final dateTime = lastMessageTime.toDate();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        timeText = DateFormat('MMM d').format(dateTime);
      } else {
        timeText = DateFormat('h:mm a').format(dateTime);
      }
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isUnread ? AppColors.primaryColor.withAlpha(13) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(9),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // User Avatar - now properly handling profile image if available
            _buildAvatar(userName, userImage, isLoading),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name and Time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          userName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight:
                                isUnread ? FontWeight.w600 : FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (timeText.isNotEmpty)
                        Text(
                          timeText,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isUnread
                                ? AppColors.primaryColor
                                : Colors.grey.shade500,
                            fontWeight:
                                isUnread ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Last Message and Unread Indicator
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isUnread
                                ? Colors.grey.shade800
                                : Colors.grey.shade600,
                            fontWeight:
                                isUnread ? FontWeight.w500 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.1, end: 0, duration: 300.ms);
  }

  Widget _buildAvatar(String userName, String? imageUrl, bool isLoading) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    // If there's an image URL, display it
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to initial if image fails to load
              return _buildInitialAvatar(userName);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 60,
                  height: 60,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      );
    }

    // If no image URL, show initial
    return _buildInitialAvatar(userName);
  }

  Widget _buildInitialAvatar(String userName) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withAlpha(182),
            AppColors.primaryColor
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha(52),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          userName.isNotEmpty ? userName[0].toUpperCase() : '?',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        final weekday = DateFormat('EEEE').format(dateTime);
        return weekday;
      } else {
        return DateFormat('MMM d').format(dateTime);
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
