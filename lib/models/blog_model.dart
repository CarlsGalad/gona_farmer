import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewsItem {
  final String title;
  final String publisher;
  final String datePublished;
  final String content;
  final String image;

  NewsItem({
    required this.title,
    required this.publisher,
    required this.datePublished,
    required this.content,
    required this.image,
  });

  factory NewsItem.fromMap(Map<String, dynamic> map) {
    // Convert Timestamp to a formatted date string
    final timestamp = map['date_published'] as Timestamp;
    final date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    final formattedDate = DateFormat.yMMMMd().format(date);

    return NewsItem(
        title: map['title'],
        publisher: map['publisher'],
        datePublished: formattedDate,
        image: map['image_url'],
        content: map['content']);
  }
}
