import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:woofcare/config/constants.dart';

import '/ui/pages/export.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;

  final List<Widget> pages = [
    const ConversationsPage(),
    const MapPage(),
    const ArticlePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Hi, ${profile.name}",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, "/profile"),
              icon: Image.asset(
                "assets/images/homePageButtons/ProfileButton.png",
                width: 40,
                height: 40,
              ),
            ),
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidComments),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidMap),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bookOpen),
              label: 'Articles',
            ),
          ],
          backgroundColor: const Color(0xFFE5E5E5),
          unselectedItemColor: const Color(0xFFA66E38),
          selectedItemColor: const Color(0xFF3F2917),
        ),
      ),
    );
  }
}
