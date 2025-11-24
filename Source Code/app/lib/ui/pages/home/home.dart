import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WoofCareColors.secondaryBackground,
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: GoogleFonts.aBeeZee(
                  color: WoofCareColors.primaryTextAndIcons.withValues(
                    alpha: 0.7,
                  ),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                profile.name,
                style: GoogleFonts.aBeeZee(
                  color: WoofCareColors.primaryTextAndIcons,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        shape: Border(
          bottom: BorderSide(
            color: WoofCareColors.primaryTextAndIcons.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/profile"),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WoofCareColors.backgroundElementColor,
                  border: Border.all(
                    color: WoofCareColors.primaryTextAndIcons,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/homePageButtons/ProfileButton.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
            ),
          ),
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
