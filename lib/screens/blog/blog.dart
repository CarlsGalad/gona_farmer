import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        title: Text(
          'News',
          style: GoogleFonts.abhayaLibre(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('news').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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

              return ListTile(
                leading: Image.network(
                  newsItem.image,
                  width: 100,
                  height: 100,
                ),
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
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
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
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
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
              );
            },
          );
        },
      ),
    );
  }
}
