import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/models/article.dart';
import 'package:woofcare/services/articles.dart';

/// ArticlePage - Main screen that displays all articles from Firebase.
/// Features: Search, category filtering, and real-time updates from database.

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  // Tracks which category is currently selected (All, Guide, Medical, Stories)
  String selectedCategory = 'All';

  // Controls the search input field
  final TextEditingController searchController = TextEditingController();

  // Service that handles all Firebase database operations
  final Articles _articleService = Articles();

  // Stores search results. null = show all articles, list = show filtered results
  List<Article>? searchResults;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Performs search when user types in the search bar.
  /// Empty query shows all articles, otherwise filters by title match.
  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = null;
      });
      return;
    }
    final results = await _articleService.searchArticles(query);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WoofCareColors.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              color: WoofCareColors.offWhite,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title and Profile Icon Row
                  SizedBox(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Articles Menu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: WoofCareColors.primaryTextAndIcons,
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: WoofCareColors.offWhite,
                          child: Icon(
                            Icons.person_outline,
                            color: WoofCareColors.buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  SizedBox(
                    height: 48,
                    child: TextField(
                      controller: searchController,
                      onChanged: _performSearch,
                      style: TextStyle(
                        fontSize: 16,
                        color: WoofCareColors.primaryTextAndIcons,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search for Articles...',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: WoofCareColors.primaryTextAndIcons.withOpacity(
                            0.6,
                          ),
                        ),
                        filled: true,
                        fillColor: WoofCareColors.textBoxColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: WoofCareColors.primaryTextAndIcons,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Category Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryButton('All'),
                        const SizedBox(width: 8),
                        _buildCategoryButton('Guide'),
                        const SizedBox(width: 8),
                        _buildCategoryButton('Medical'),
                        const SizedBox(width: 8),
                        _buildCategoryButton('Stories'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Articles List
            Expanded(
              child:
                  searchResults != null
                      ? _buildSearchResults()
                      : _buildArticlesList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single category filter button (All, Guide, Medical, Stories).
  /// Highlights the button if it's currently selected.
  Widget _buildCategoryButton(String category) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? WoofCareColors.buttonColor
                  : WoofCareColors.backgroundElementColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color:
                isSelected ? Colors.white : WoofCareColors.primaryTextAndIcons,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Builds the main article list using real-time data from Firebase.
  /// Automatically updates when articles are added/removed from database.
  Widget _buildArticlesList() {
    return StreamBuilder<List<Article>>(
      stream: _articleService.getArticlesByCategory(selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: WoofCareColors.buttonColor),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading articles',
              style: TextStyle(color: WoofCareColors.primaryTextAndIcons),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No articles found',
              style: TextStyle(
                color: WoofCareColors.primaryTextAndIcons,
                fontSize: 16,
              ),
            ),
          );
        }

        final articles = snapshot.data!;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildArticleCard(
                article: article,
                category: article.category,
                title: article.title,
                author: article.author,
                date: DateFormat('MMM yyyy').format(article.date),
                imageUrl: article.imageUrl,
              ),
            );
          },
        );
      },
    );
  }

  /// Displays filtered search results when user searches for articles.
  Widget _buildSearchResults() {
    if (searchResults!.isEmpty) {
      return Center(
        child: Text(
          'No articles found',
          style: TextStyle(color: WoofCareColors.primaryTextAndIcons),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: searchResults!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final article = searchResults![index];
        return _buildArticleCard(
          article: article,
          category: article.category,
          title: article.title,
          author: article.author,
          date: DateFormat('MMM yyyy').format(article.date),
          imageUrl: article.imageUrl,
        );
      },
    );
  }

  /// Builds a single article card with image, title, author, and date.
  /// Clicking opens the original article in a browser.
  Widget _buildArticleCard({
    required Article article,
    required String category,
    required String title,
    required String author,
    required String date,
    required String imageUrl,
  }) {
    return InkWell(
      onTap: () async {
        if (article.sourceUrl != null && article.sourceUrl!.isNotEmpty) {
          final messenger = ScaffoldMessenger.of(context);
          try {
            final uri = Uri.parse(article.sourceUrl!);
            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(
                content: Text('Could not open article: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This article has no source URL'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WoofCareColors.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Article Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    imageUrl.isNotEmpty
                        ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: WoofCareColors.buttonColor.withOpacity(
                                  0.1,
                                ),
                                child: Icon(
                                  Icons.pets,
                                  size: 60,
                                  color: WoofCareColors.buttonColor,
                                ),
                              ),
                        )
                        : Container(
                          color: WoofCareColors.buttonColor.withOpacity(0.1),
                          child: Icon(
                            Icons.pets,
                            size: 60,
                            color: WoofCareColors.buttonColor,
                          ),
                        ),
              ),
            ),
            const SizedBox(width: 16),
            // Article Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color: WoofCareColors.buttonColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: WoofCareColors.primaryTextAndIcons,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: WoofCareColors.primaryTextAndIcons,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          author,
                          style: TextStyle(
                            fontSize: 12,
                            color: WoofCareColors.buttonColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: WoofCareColors.primaryTextAndIcons,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
