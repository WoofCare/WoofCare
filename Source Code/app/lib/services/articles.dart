import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:woofcare/models/article.dart';

/// ArticleService - Handles all communication between the app and Firebase Firestore.
/// Acts as a middleman to fetch, search, and manage articles in the database.
class Articles {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'articles';

  /// Fetches all articles from Firebase, sorted by newest first.
  Stream<List<Article>> getAllArticles() {
    return _firestore
        .collection(collectionName)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList(),
        );
  }

  /// Filters articles by category (Guide, Medical, Stories, or All).
  Stream<List<Article>> getArticlesByCategory(String category) {
    if (category == 'All') {
      return getAllArticles();
    }
    return _firestore
        .collection(collectionName)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          final articles =
              snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();
          // Sort by date in memory instead of using Firestore orderBy (to avoid index requirement)
          articles.sort((a, b) => b.date.compareTo(a.date));
          return articles;
        });
  }

  /// Searches for articles by title based on user input.
  Future<List<Article>> searchArticles(String query) async {
    final snapshot = await _firestore.collection(collectionName).get();
    final allArticles =
        snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();

    return allArticles
        .where(
          (article) =>
              article.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  //   final doc = await _firestore.collection(collectionName).doc(id).get();
  //   if (doc.exists) {
  //     return Article.fromFirestore(doc);
  //   }
  //   return null;
  // }

  /// Adds a new article to the Firebase database.
  /// This is typically called by the Python scraper, not the app directly.
  Future<void> addArticle(Article article) async {
    await _firestore.collection(collectionName).add(article.toFirestore());
  }

  /// Updates
  // Future<void> updateArticle(String id, Article article) async {
  //   await _firestore
  //       .collection(collectionName)
  //       .doc(id)
  //       .update(article.toFirestore());
  // }

  /// Deletes
  // Future<void> deleteArticle(String id) async {
  //   await _firestore.collection(collectionName).doc(id).delete();
  // }
}
