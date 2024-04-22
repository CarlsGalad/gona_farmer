import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back),
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.aboreto(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final blogDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: blogDocs.length,
            itemBuilder: (context, index) {
              final blogData = blogDocs[index].data() as Map<String, dynamic>;
              final blogPost = BlogPost(
                title: blogData['title'],
                publisher: blogData['publisher'],
                datePublished:
                    (blogData['datePublished'] as Timestamp).toDate(),
                content: blogData['content'],
              );
              return ListTile(
                title: Text(blogPost.title),
                subtitle: Text(
                    '${blogPost.publisher}, ${blogPost.datePublished.toString()}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BlogPostDetailScreen(post: blogPost),
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
