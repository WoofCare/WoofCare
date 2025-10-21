import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/pages/posts/posts.dart';

import '/ui/pages/export.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 1;

  final List<Widget> pages = [
    const ConversationsPage(),
    const MapPage(),
    const SocialMediaFeed(),
    const ArticlePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hi, ${profile.name}",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        automaticallyImplyLeading: false,
        shape: Border(
          bottom: BorderSide(
            color: WoofCareColors.primaryTextAndIcons.withValues(alpha: 0.2),
            width: 1,
          )
        ),
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
      body: pages[currentPageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: WoofCareColors.primaryTextAndIcons.withValues(alpha: 0.05),
          border: Border(
            top: BorderSide(
              color: WoofCareColors.primaryTextAndIcons.withValues(alpha: 0.1),
              width: 1,
            )
          )
        ),
        child: BottomNavigationBar(
          iconSize: 20,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentPageIndex,
          onTap: (value) {
            setState(() {
              currentPageIndex = value;
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
              icon: FaIcon(FontAwesomeIcons.signsPost),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bookOpen),
              label: 'Articles',
            ),
          ],
          backgroundColor: WoofCareColors.secondaryBackground,
          unselectedItemColor: const Color(0xFFA66E38),
          selectedItemColor: const Color(0xFF3F2917),
        ),
      ),
    );
  }
}
