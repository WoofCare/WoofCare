import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/models/article.dart';
import 'package:woofcare/services/article_service.dart';
import 'package:woofcare/utils/add_sample_data.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  String selectedCategory = 'All';
  final TextEditingController searchController = TextEditingController();
  final ArticleService _articleService = ArticleService();
  List<Article>? searchResults;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ArticlesMenu',
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
                  const SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    controller: searchController,
                    onChanged: _performSearch,
                    decoration: InputDecoration(
                      hintText: 'Search forArticle',
                      hintStyle: TextStyle(
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
                        horizontal: 20,
                        vertical: 0.5,
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
              child: searchResults != null
                  ? _buildSearchResults()
                  : _buildArticlesList(),
            ),
          ],
        ),
      ),
    );
  }

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
          color: isSelected
              ? WoofCareColors.buttonColor
              : WoofCareColors.backgroundElementColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : WoofCareColors.primaryTextAndIcons,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No articles found',
                  style: TextStyle(
                    color: WoofCareColors.primaryTextAndIcons,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await addSampleArticles();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Sample articles added! Check the page.'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WoofCareColors.buttonColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Add Sample Articles',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: WoofCareColors.buttonColor.withOpacity(0.1),
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
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: WoofCareColors.primaryTextAndIcons,
                    ),
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
                      Text(
                        author,
                        style: TextStyle(
                          fontSize: 12,
                          color: WoofCareColors.buttonColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: WoofCareColors.primaryTextAndIcons,
                        ),
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
