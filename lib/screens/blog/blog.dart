import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../models/blog_model.dart';
import 'blog_detial.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        title: Text(
          'News',
          style: GoogleFonts.abhayaLibre(fontSize: screenWidth * 0.08),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      body: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('news').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.green.shade100,
                  size: screenWidth * 0.1,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final newsDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: newsDocs.length,
              itemBuilder: (context, index) {
                final newsItem = NewsItem.fromMap(
                  newsDocs[index].data() as Map<String, dynamic>,
                );

                return Card(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.15,
                      child: newsItem.image.isNotEmpty
                          ? Image.network(
                              newsItem.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Display a placeholder image if there's an error loading the image
                                return const Icon(
                                  Icons.newspaper_sharp,
                                  size: 50,
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: LinearProgressIndicator(
                                    color: Colors.green,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.newspaper_sharp,
                                size: 50,
                              ),
                            ),
                    ),
                    title: Text(
                      newsItem.title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_2_rounded,
                          color: Colors.grey,
                        ),
                        Text(
                          ' ${newsItem.publisher}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.02,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                        const Text(
                          ' • ',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        const Icon(
                          Icons.access_time,
                          color: Colors.grey,
                        ),
                        Text(
                          newsItem.datePublished,
                          style: TextStyle(
                            fontSize: screenWidth * 0.02,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BlogPostDetailScreen(post: newsItem),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
