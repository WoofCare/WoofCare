import 'package:cloud_firestore/cloud_firestore.dart';

/// Article Model - Defines the structure of an article in our app.
/// Each article contains a title, category, author, publish date, image, content, and source URL.
class Article {
  final String id;
  final String title;
  final String category;
  final String author;
  final DateTime date;
  final String imageUrl;
  final String content;
  final String? sourceUrl;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.date,
    required this.imageUrl,
    required this.content,
    this.sourceUrl,
  });

  /// Converts Firebase document data into an Article object.
  /// This is called when we fetch articles from Firestore database.
  factory Article.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Article(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      author: data['author'] ?? 'Voice of Stray Dogs',
      date: (data['date'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'] ?? '',
      content: data['content'] ?? '',
      sourceUrl: data['sourceUrl'],
    );
  }

  /// Converts an Article object into a format that can be saved to Firestore.
  /// This is used when adding or updating articles in the database.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'author': author,
      'date': Timestamp.fromDate(date),
      'imageUrl': imageUrl,
      'content': content,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
    };
  }
}
