import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/app_colors.dart';
import '../../models/blog_model.dart';
import 'blog_detial.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedCategory = "All"; // Initial category
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  List<String> _categories = ["All"]; // Initialize with "All"

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
    _fetchCategories(); // Fetch categories on initialization
  }

  Future<void> _fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance.collection('news').get();
    if (snapshot.docs.isNotEmpty) {
      final fetchedCategories = snapshot.docs
          .map((doc) => doc['category'] as String)
          .toSet()
          .toList();
      setState(() {
        _categories = ["All", ...fetchedCategories];
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'News',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.accentColor),
            onPressed: () {
              _showFilterDialog(); //Show filter dialog
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildCategoryChips(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildNewsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search news...',
        hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        prefixIcon: const Icon(Icons.search, color: AppColors.accentColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(
                category,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.accentColor,
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (bool selected) {
                setState(() {
                  _selectedCategory = selected ? category : "All";
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsList() {
    Query query = FirebaseFirestore.instance.collection('news');

    // Apply category filter (excluding featured filter for now)
    if (_selectedCategory != "All") {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    // Apply search filter.  This uses a simple "starts with" and is case-insensitive.
    if (_searchQuery.isNotEmpty) {
      String upperSearch = _searchQuery[0].toUpperCase() +
          _searchQuery.substring(1); //For Title search
      query = query
          .where('title', isGreaterThanOrEqualTo: _searchQuery)
          .where('title', isLessThan: '${_searchQuery}z');
      query = query
          .where('title', isGreaterThanOrEqualTo: upperSearch)
          .where('title', isLessThan: '${upperSearch}z'); //For title
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.accentColor,
              size: 50,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: AppColors.error),
          ));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            'No news articles available.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ));
        }

        //Separate featured and non-featured news
        final allNewsDocs = snapshot.data!.docs;
        final featuredNews = allNewsDocs
            .where((doc) =>
                (doc.data() as Map<String, dynamic>)['is_feature'] == true)
            .toList();
        final nonFeaturedNews = allNewsDocs
            .where((doc) =>
                (doc.data() as Map<String, dynamic>)['is_feature'] != true)
            .toList(); // Explicitly check for false or null.

        return ListView.builder(
            itemCount: featuredNews.length +
                nonFeaturedNews.length +
                (featuredNews.isNotEmpty
                    ? 1
                    : 0), // Add 1 for the "Featured" header
            itemBuilder: (context, index) {
              if (featuredNews.isNotEmpty && index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Featured News",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentColor),
                  ),
                );
              }
              if (index <
                  featuredNews.length + (featuredNews.isNotEmpty ? 1 : 0)) {
                //It is a featured News
                final newsItem = NewsItem.fromMap(
                  featuredNews[index - (featuredNews.isNotEmpty ? 1 : 0)].data()
                      as Map<String, dynamic>,
                );
                return _buildNewsCard(newsItem, isFeatured: true);
              } else {
                //It is a normal News
                final newsItem = NewsItem.fromMap(
                  nonFeaturedNews[index -
                          featuredNews.length -
                          (featuredNews.isNotEmpty ? 1 : 0)]
                      .data() as Map<String, dynamic>,
                );
                return _buildNewsCard(newsItem, isFeatured: false);
              }
            });
      },
    );
  }

  Widget _buildNewsCard(NewsItem newsItem, {required bool isFeatured}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogPostDetailScreen(post: newsItem),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 120,
                height: 120,
                child: newsItem.image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: newsItem.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.accentColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.newspaper,
                                size: 40, color: AppColors.textSecondary)),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.newspaper,
                            size: 40, color: AppColors.textSecondary),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // Row for title and featured badge
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          newsItem.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isFeatured) ...[
                        const SizedBox(width: 8),
                        _buildFeaturedBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          newsItem.publisher,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        newsItem.datePublished,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
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
    );
  }

  Widget _buildFeaturedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            AppColors.accentColor.withAlpha(52), // Lighter shade of accent
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Featured",
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.accentColor,
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder for the dialog
          builder: (BuildContext context, StateSetter dialogSetState) {
            // Use a different StateSetter
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter News',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Category Filter (using the same categories as the chips)
                  Wrap(
                    spacing: 8.0,
                    children: _categories.map((category) {
                      bool isSelected = _selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category,
                            style: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary)),
                        selected: isSelected,
                        selectedColor: AppColors.accentColor,
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onSelected: (bool selected) {
                          dialogSetState(() {
                            // Use the dialog's StateSetter
                            _selectedCategory = selected ? category : "All";
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12)),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('Apply Filters',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
