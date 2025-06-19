import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:woofcare/firebase_options.dart';
import 'package:woofcare/ui/pages/forgotpw/forgot_pw_page.dart';

import '/config/constants.dart';
import '/config/theme.dart';
import '/ui/pages/export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


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
      initialRoute: "/",
      builder: (context, widget) {
        theme = WoofCareTheme.of(context);
    
        return widget!;
      },
      routes: {
        "/": (context) => const SplashPage(),
        "/home": (context) => const HomePage(),
        "/map": (context) => const MapPage(),
        "/login": (context) => const LogInPage(),
        "/forgotpw": (context) => const ForgotPasswordPage(),
        "/signup": (context) => const SignUpPage(),
        "/profile": (context) => const ProfilePage(),
        "/chat": (context) => const ChatPage(),
        "/article": (context) => const ArticlePage(),
      },
    );
  }
}
