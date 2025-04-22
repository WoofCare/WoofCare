import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/ui/pages/articles/articles.dart';
import 'package:woofcare/ui/pages/navigation/navigation.dart';
import 'package:woofcare/ui/pages/post/post.dart';
import 'package:woofcare/ui/pages/postViewer/postViewer.dart';
import '/config/constants.dart';
import '/config/theme.dart';
import '/ui/pages/export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const WoofCare());
}

class WoofCare extends StatelessWidget {
  const WoofCare({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WoofCare",
      theme: WoofCareTheme.of(context),
      initialRoute: "/home",
      builder: (context, widget) {
        theme = WoofCareTheme.of(context);

        return widget!;
      },
      routes: {
        "/navigation": (context) => const NavPage(),
        "/home": (context) => const HomePage(),
        "/post": (context) => const PostPage(),
        "/login": (context) => const LogInPage(),
        "/signup": (context) => const SignUpPage(),
        "/profile": (context) => const ProfilePage(),
        "/articles": (context) => const ArticlesPage(),
        "/postViewer": (context) => const PostViewerPage(),
      },
    );
  }
}
