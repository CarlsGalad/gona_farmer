import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 15.0),
        //   child: IconButton(
        //     onPressed: () {
        //       Navigator.popUntil(context, (route) => true);
        //     },
        //     icon: const Icon(CupertinoIcons.back),
        //   ),
        // ),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: blogDocs.length > 7 ? 7 : blogDocs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(184, 181, 181, 1),
                                    offset: Offset(5, 2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0,
                                    blurStyle: BlurStyle.normal),
                                BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.9),
                                  offset: Offset(-6, -2),
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 300,
                            width: 200,
                            child: const Center(child: Text('we dey here')),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: ListView.builder(
                    itemCount: blogDocs.length,
                    itemBuilder: (context, index) {
                      final blogData =
                          blogDocs[index].data() as Map<String, dynamic>;
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
