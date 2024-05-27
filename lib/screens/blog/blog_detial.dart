import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/blog_model.dart';

class BlogPostDetailScreen extends StatelessWidget {
  final NewsItem post;

  const BlogPostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              height: 400,
              child: SizedBox(
                height: 400,
                child: Container(
                  color: Colors.white,
                  height: 400,
                  child: Image.network(
                    post.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 260,
              left: 16.0,
              right: 100.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(0.1, 0.9)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_2_rounded,
                        color: Colors.grey,
                      ),
                      Text(
                        ' ${post.publisher}',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      const Text(
                        ' • ',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      const Icon(
                        Icons.access_time,
                        color: Colors.grey,
                      ),
                      Text(
                        post.datePublished,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 380, // Adjust to make space for rounded container
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          post.content,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40, // Adjust as needed
              left: 16,
              child: IconButton(
                icon: const Icon(CupertinoIcons.back, color: Colors.grey),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
