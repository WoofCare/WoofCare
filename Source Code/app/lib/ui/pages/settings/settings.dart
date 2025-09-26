import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/ui/pages/export.dart';
import 'package:woofcare/ui/pages/settings/settings.dart';
import 'package:woofcare/ui/widgets/custom_button.dart';
import 'package:woofcare/ui/widgets/custom_small_button.dart';
import '/config/colors.dart';
import '/config/constants.dart';

import '/config/constants.dart';
import '/services/auth.dart';
import '/ui/widgets/custom_button.dart';
import '/ui/widgets/custom_textfield.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {
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
                                color: WoofCareColors.dividerColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              "Notifications",
                              style: TextStyle(
                                color: WoofCareColors.primaryTextAndIcons,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Switch(
                              trackColor: MaterialStateProperty.all(
                                WoofCareColors.buttonColor,
                              ),
                              thumbColor: MaterialStateProperty.all(
                                WoofCareColors.offWhite,
                              ),
                              value: true,
                              onChanged: (val) {
                                // handle switch change
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              "Theme",
                              style: TextStyle(
                                color: WoofCareColors.primaryTextAndIcons,
                                fontSize: 16,
                              ),
                            ),
                            trailing: DropdownButton<String>(
                              value: "Light",
                              items:
                                  ["Light", "Dark"]
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                // handle dropdoSwn change
                              },
                            ),
                          ),
                          ExpansionTile(
                            title: const Text("Username", style: TextStyle(color: WoofCareColors.primaryTextAndIcons, fontSize: 16),),
                            trailing: const Icon(Icons.arrow_drop_down, color: WoofCareColors.primaryTextAndIcons,),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        labelText: "New Username",
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        // save action
                                      },
                                      child: const Text("Save"),
                                    ),
                                  ],
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
            ),
          ],
        ),
      ),
    );
  }
}
