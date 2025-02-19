import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/config/constants.dart';

import 'package:woofcare/ui/pages/chat/chat.dart';
import 'package:woofcare/ui/pages/conversations/conversations.dart';
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
      initialRoute: "/login",
      builder: (context, widget) {
        theme = WoofCareTheme.of(context);

        return widget!;
      },
      routes: {
        "/login": (context) => const LogInPage(),
        "/signup": (context) => const SignUpPage(),
        "/profile": (context) => const ProfilePage(),
        "/conversations": (context) => const ConversationsPage(),
        "/chat": (context) => const ChatPage()
      },
    );
  }
}
