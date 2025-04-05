import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/app_colors.dart';
import '../../models/blog_model.dart';

class BlogPostDetailScreen extends StatefulWidget {
  final NewsItem post;

  const BlogPostDetailScreen({super.key, required this.post});

  @override
  State<BlogPostDetailScreen> createState() => _BlogPostDetailScreenState();
}

class _BlogPostDetailScreenState extends State<BlogPostDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _sharePost() {
    Share.share(
      'Check out this article: ${widget.post.title}\n\n${widget.post.content.substring(0, widget.post.content.length > 100 ? 100 : widget.post.content.length)}...',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(77),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(77),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.share_rounded,
                color: Colors.white,
              ),
              onPressed: _sharePost,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Hero image
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image with gradient overlay
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                      stops: [0.0, 0.8],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    widget.post.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        if (!_imageLoaded) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _imageLoaded = true;
                              });
                            }
                          });
                        }
                        return child;
                      }
                      return Container(
                        color: AppColors.primaryLight,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryLight,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load image',
                                style: GoogleFonts.abel(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Gradient overlay for better text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(182),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category tag
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 60,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.post.category,
                  style: GoogleFonts.abel(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Title and author info
          Positioned(
            top: MediaQuery.of(context).size.height * 0.32,
            left: 16,
            right: 16,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.title,
                      style: GoogleFonts.abel(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withAlpha(128),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(52),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.post.publisher,
                          style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(52),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.post.datePublished,
                          style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content container
          Positioned(
            top: MediaQuery.of(context).size.height * 0.42,
            left: 0,
            right: 0,
            bottom: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Featured tag if applicable
                          if (widget.post.isFeature) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: AppColors.accentColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Featured Article',
                                    style: GoogleFonts.abel(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Content
                          Text(
                            widget.post.content,
                            style: GoogleFonts.abel(
                              fontSize: 16,
                              height: 1.6,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.justify,
                          ),

                          // Share button at the bottom
                          const SizedBox(height: 32),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: _sharePost,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              icon: const Icon(Icons.share),
                              label: Text(
                                'Share this article',
                                style: GoogleFonts.abel(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
