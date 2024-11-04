import 'package:flutter/material.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/widgets/custom_alternate_textfield.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _bioTextController = TextEditingController(text: profile.bio);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEEB784),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
          },
          child: Stack(
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
                Padding(
                  // Padding for the container that holds the prof form
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 125.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.45),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(6, 3)),
                      ],
                    ),
                    child: ClipRRect(
                      // ClipRRect to allow for rounded corners
                      borderRadius: BorderRadius.circular(8.0),
                      child: Scaffold(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        body: SafeArea(
                          child: Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // TODO: Profile Picture
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: 100,
                                        child: Icon(
                                          Icons.person,
                                          size: 150,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  //Username
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
                                    child: Text.rich(TextSpan(
                                        text: "Name: ",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: profile.name,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          )
                                        ])),
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),

                                  //Bio
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: CustomAlternateTextfield(
                                      controller: _bioTextController,
                                      hintText: "Enter your bio here...",
                                      onChanged: (text) {
                                        profile.bio = _bioTextController.text;
                                        profile.updateProfile();
                                      },
                                    ),
                                  ),

                                  //email
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

                                  //Role
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
              ]),
        ));
  }
}
