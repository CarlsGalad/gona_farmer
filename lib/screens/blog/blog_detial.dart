import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../models/blog_model.dart';

class BlogPostDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogPostDetailScreen({super.key, required this.post});

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
          'News Details',
          style: GoogleFonts.bebasNeue(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              textAlign: TextAlign.justify,
            ),
            Text(
              'Published by: ${post.publisher}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Published on: ${post.datePublished.toString()}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Text(
              post.content,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
