import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/widgets/custom_alternate_textfield.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _bioTextController = TextEditingController(text: profile.bio);

  // @override
  // void dispose() {
  //   _bioTextController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEB784),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
        },
        child: Stack(
          clipBehavior: Clip.none,
          // Stack to allow for multiple background images
          children: [
            Container(
              // Container for the first background image
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/patterns/BigPawPattern.png",
                  ),
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
            Container(
              // Container for the second background image
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/patterns/SmallPawPattern.png",
                  ),
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
            // The Positioned widget is used to place its
            //child at a specific position within a Stack.
            Positioned(
              top: 155, // Position from the top
              left: MediaQuery.of(context).size.width / 2 -
                  100, // Center horizontally
              child: GestureDetector(
                onTap: () {}, //TODO: Add photo function
                child: const CircleAvatar(
                  // CircleAvatar for the profile picture
                  radius: 100,
                  backgroundColor: Colors.white,
                  child: Icon(
                    color: WoofCareColors.primaryTextAndIcons,
                    Icons.person,
                    size: 150,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 400, // Custom position from the top
              left: 20, // Custom position from the left
              right: 20, // Custom position from the right
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.45),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(6, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  // ClipRRect to allow for rounded corners
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: SafeArea(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Username
                              Container(
                                width: 300,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    text: "Name: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: profile.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Bio
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: CustomAlternateTextfield(
                                  controller: _bioTextController,
                                  hintText: "Enter your bio here...",
                                  onChanged: (text) {
                                    profile.bio = _bioTextController.text;
                                    profile.updateProfile();
                                  },
                                ),
                              ),
                              // Email
                              Container(
                                width: 300,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Email: ${profile.email}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              // Role
                              Container(
                                width: 300,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Role: ${profile.role}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
