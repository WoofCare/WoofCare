import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      initialRoute: "/report",
      builder: (context, widget) {
        theme = WoofCareTheme.of(context);

        return widget!;
      },
      routes: {
        "/home": (context) => const HomePage(),
        "/login": (context) => const LogInPage(),
        "/signup": (context) => const SignUpPage(),
        "/profile": (context) => const ProfilePage(),
        "/report": (context) => const ReportingPage(),
      },
    );
  }
}
