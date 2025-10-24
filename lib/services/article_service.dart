import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:woofcare/models/article.dart';

class ArticleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'articles';

  // Get all articles
  Stream<List<Article>> getAllArticles() {
    return _firestore
        .collection(collectionName)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList());
  }

  // Get articles by category
  Stream<List<Article>> getArticlesByCategory(String category) {
    if (category == 'All') {
      return getAllArticles();
    }
    return _firestore
        .collection(collectionName)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          final articles = snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();
          // Sort by date in memory instead of using Firestore orderBy (to avoid index requirement)
          articles.sort((a, b) => b.date.compareTo(a.date));
          return articles;
        });
  }

  // Search articles by title
  Future<List<Article>> searchArticles(String query) async {
    final snapshot = await _firestore.collection(collectionName).get();
    final allArticles =
        snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();

    return allArticles
        .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get single article by ID
  Future<Article?> getArticleById(String id) async {
    final doc = await _firestore.collection(collectionName).doc(id).get();
    if (doc.exists) {
      return Article.fromFirestore(doc);
    }
    return null;
  }

  // Add new article
  Future<void> addArticle(Article article) async {
    await _firestore.collection(collectionName).add(article.toFirestore());
  }

  // Update article
  Future<void> updateArticle(String id, Article article) async {
    await _firestore
        .collection(collectionName)
        .doc(id)
        .update(article.toFirestore());
  }

  // Delete article
  Future<void> deleteArticle(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}