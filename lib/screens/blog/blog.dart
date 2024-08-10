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
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        title: Text(
          'News',
          style: GoogleFonts.abhayaLibre(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('news').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.green.shade100, size: 50));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final newsDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: newsDocs.length,
              itemBuilder: (context, index) {
                final newsItem = NewsItem.fromMap(
                    newsDocs[index].data() as Map<String, dynamic>);

                return Card(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: ListTile(
                    leading: SizedBox(
                        width: 100,
                        height: 100,
                        child: newsItem.image.isNotEmpty
                            ? Image.network(
                                newsItem.image,
                                width: 100,
                                height: 100,
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
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                              ))),
                    title: Text(
                      newsItem.title,
                      style: const TextStyle(fontSize: 25),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.person_2_rounded,
                          color: Colors.grey,
                        ),
                        Text(
                          ' ${newsItem.publisher}',
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
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
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                        )
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
