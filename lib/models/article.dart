import 'package:cloud_firestore/cloud_firestore.dart';

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
