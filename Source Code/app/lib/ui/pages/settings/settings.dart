import 'package:flutter/material.dart';
import 'package:woofcare/ui/pages/export.dart';
import 'package:woofcare/ui/widgets/custom_small_button.dart';

import '/config/colors.dart' as app_colors;
import '/ui/widgets/custom_textfield.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

//default dropdown values
String selectedLanguage = "English"; // default selected language

class _SettingsPageState extends State<SettingsPage> {
  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text("Settings"),
        backgroundColor: const Color(0xFFEEB784),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background images
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset("assets/images/patterns/BigPawPattern.png"),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset("assets/images/patterns/SmallPawPattern.png"),
            ),

            // White card form container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                width: double.infinity,
                height: double.infinity, // 👈 makes it fill available height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3F2917),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Divider to separate title from options
                    const Divider(height: 1, thickness: 1),

                    // Settings list (scrollable)
                    Expanded(
                      //notifications
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: [
                          ListTile(
                            title: const Text(
                              "Account Settings",
                              style: TextStyle(
                                color: app_colors.WoofCareColors.dividerColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ExpansionTile(
                            title: Text(
                              "Change Email",
                              style: TextStyle(
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_drop_down,
                              color:
                                  app_colors.WoofCareColors.primaryTextAndIcons,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      controller: _emailTextController,
                                      hintText: "New Email",
                                      maxLines: 1,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextField(
                                      controller: _emailTextController,
                                      hintText: "Confirm New Email",
                                      maxLines: 1,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 12),
                                    CustomSmallButton(
                                      text: "Save",
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text(
                              "Change Password",
                              style: TextStyle(
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_drop_down,
                              color:
                                  app_colors.WoofCareColors.primaryTextAndIcons,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      controller: _passwordTextController,
                                      hintText: "New Password",
                                      maxLines: 1,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextField(
                                      controller: _passwordTextController,
                                      hintText: "Confirm New Password",
                                      maxLines: 1,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 12),
                                    CustomSmallButton(
                                      text: "Save",
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            title: Text(
                              "Language",
                              style: TextStyle(
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                                fontSize: 16,
                              ),
                            ),
                            trailing: DropdownButton<String>(
                              value: selectedLanguage,
                              isExpanded: false,
                              dropdownColor: Colors.white,
                              underline: const SizedBox(),
                              items:
                                  ["English", "Other", "Longer Language"]
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              color:
                                                  app_colors
                                                      .WoofCareColors
                                                      .primaryTextAndIcons,
                                              fontWeight:
                                                  e == selectedLanguage
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    selectedLanguage = val;
                                  });
                                }
                              },
                            ),
                          ),
                          SwitchListTile(
                            title: Text(
                              "Notifications",
                              style: TextStyle(
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                                fontSize: 16,
                              ),
                            ),
                            value: true,
                            activeTrackColor:
                                app_colors.WoofCareColors.buttonColor,
                            activeColor: app_colors.WoofCareColors.offWhite,
                            onChanged: (val) {
                              // handle switch change
                            },
                          ),
                          ListTile(
                            title: const Text(
                              "Privacy Settings",
                              style: TextStyle(
                                color: app_colors.WoofCareColors.dividerColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Location Sharing",
                              style: TextStyle(
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                                fontSize: 14,
                              ),
                            ),
                            trailing: DropdownButton<String>(
                              value: selectedLanguage,
                              isExpanded: false,
                              dropdownColor: Colors.white,
                              underline: const SizedBox(),
                              items:
                                  ["English", "Other", "Longer Language"]
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              color:
                                                  app_colors
                                                      .WoofCareColors
                                                      .primaryTextAndIcons,
                                              fontWeight:
                                                  e == selectedLanguage
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    selectedLanguage = val;
                                  });
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Profile Viewing",
                              style: TextStyle(
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                                fontSize: 14,
                              ),
                            ),
                            trailing: DropdownButton<String>(
                              value: selectedLanguage,
                              isExpanded: false,
                              dropdownColor: Colors.white,
                              underline: const SizedBox(),
                              items:
                                  ["English", "Other", "Longer Language"]
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              color:
                                                  app_colors
                                                      .WoofCareColors
                                                      .primaryTextAndIcons,
                                              fontWeight:
                                                  e == selectedLanguage
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    selectedLanguage = val;
                                  });
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              "More",
                              style: TextStyle(
                                color: app_colors.WoofCareColors.dividerColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ListTile(
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                              ),
                              onPressed: () {
                                // 🔹 Navigate to another page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              },
                            ),
                            title: Text(
                              "About Us",
                              style: TextStyle(
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              // Optional: also navigate when tapping the tile itself
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                              ),
                              onPressed: () {
                                // 🔹 Navigate to another page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              },
                            ),
                            title: Text(
                              "Privacy Policy",
                              style: TextStyle(
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              // Optional: also navigate when tapping the tile itself
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                              ),
                              onPressed: () {
                                // 🔹 Navigate to another page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              },
                            ),
                            title: Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                color:
                                    app_colors
                                        .WoofCareColors
                                        .primaryTextAndIcons,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              // Optional: also navigate when tapping the tile itself
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text(
                              "Log Out",
                              style: TextStyle(
                                color: Color(
                                  0xFFFF926C,
                                ), // Bootstrap's red color
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              //TODO: Implement logout functionality
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LogInPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
