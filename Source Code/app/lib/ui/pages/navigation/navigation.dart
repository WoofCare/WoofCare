import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:woofcare/ui/pages/articles/articles.dart';
import 'package:woofcare/ui/pages/home/home.dart';
import 'package:woofcare/ui/pages/post/post.dart';
import 'package:woofcare/ui/pages/postViewer/postViewer.dart';
import 'package:woofcare/ui/pages/profile/profile.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<StatefulWidget> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentPage = 0;

  final List<Widget> pages = [
    const ProfilePage(),
    const HomePage(),
    const PostPage(),
    const PostViewerPage(),
    const ArticlesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome to WoofCare",
          style: TextStyle(
            color: Color(0xFFFF7FFF7),
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/profile"),
            icon: const Icon(
              Icons.account_circle,
              size: 35,
            ),
          )
        ],
      ),
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.map,), 
            label: 'Map'
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.comments),
             label: 'Chats'
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.plus),
             label: 'Add Post'
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookmark),
             label: 'Post Viewer'
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookOpen),
             label: 'Articles'
          ),
        ],
        backgroundColor: const Color(0xFFE5E5E5),
        unselectedItemColor: const Color(0xFFA66E38) ,
        selectedItemColor: const Color(0xFF3F2917),
      ),
    );
  }
}