import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/pages/home/home.dart';
import 'package:woofcare/ui/widgets/custom_button.dart';
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEB784),
        foregroundColor: WoofCareColors.primaryTextAndIcons,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Menu with additional actions
              //TODO: Implement menu actions
            },
          ),
        ],
      ),

      //Header
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
        },
        child: Column(
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
                    child: const CircleAvatar(
                      // CircleAvatar for the profile picture
                      radius: 75,
                      backgroundColor: Colors.white,
                      child: Icon(
                        color: WoofCareColors.primaryTextAndIcons,
                        Icons.person,
                        size: 100,
                      ),
                    )),
            
                //spacer between picture and text
                const SizedBox(
                  width: 5,
                ),
            
                //Profile Information
                Expanded(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, // This will minimize the space needed
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Username
                            SizedBox(
                              height: 30,
                              width: 300,
                              child: Text.rich(
                                TextSpan(
                                  text: profile.name,
                                  style: const TextStyle(
                                    fontFamily: "Abeezee",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: WoofCareColors.primaryTextAndIcons,
                                  ),
                                  children: const [
                                    TextSpan(
                                      //TODO: connect username to database
                                      text: " @username",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFA66E38),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
            
                            // Role
                            SizedBox(
                              width: 300,
                              child: Text(
                                profile.role,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontFamily: "Abeezee",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: WoofCareColors.primaryTextAndIcons,
                                ),
                              ),
                            ),
            
                            const SizedBox(
                              height: 5,
                            ),
            
                            //location
                            const SizedBox(
                              width: 300,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 24,
                                    color: Color(0xFF805832),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    //TODO: connect location to database + allow privacy
                                    "Location",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Abeezee",
                                      fontSize: 14,
                                      color: Color(0xFF805832),
                                    ),
                                  ),
                                ],
                              ),
                            ),
            
                            const SizedBox(
                              height: 5,
                            ),
            
                            //phone number
                            const SizedBox(
                              width: 300,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 24,
                                    color: Color(0xFF805832),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    //TODO: connect phone number to database + allow privacy
                                    "(123)456-7890",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Abeezee",
                                      fontSize: 14,
                                      color: Color(0xFF805832),
                                    ),
                                  ),
                                ],
                              ),
                            ),
            
                            const SizedBox(
                              height: 3,
                            ),
            
                            //email
                            SizedBox(
                              width: 300,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.mail_outline,
                                    size: 24,
                                    color: Color(0xFF805832),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    profile.email,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontFamily: "Abeezee",
                                      fontSize: 14,
                                      color: Color(0xFF805832),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),

            //spacer
            const SizedBox(
              height: 5,
            ),

          //button row
          //TODO: add functionality to buttons
          Row(
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 10, right:0),
      child: CustomButton(
          height: 60,
          width: 200,
          color: const Color(0xFFCAB096),
          fontColor: WoofCareColors.primaryTextAndIcons,
          fontSize: 14,
          borderRadius: 16,
          text: "Message",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 0),
        child: CustomButton(
          height: 60,
          borderRadius: 16,
          text: "Follow",
          fontSize: 14,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
    ),
  ],
),

//spacer
            const SizedBox(
              height: 20,
            ),

//About
Expanded(
  child: Container(
     width: double.infinity,
    decoration: const BoxDecoration(
    color: Color(0xFFF7FFF7),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
  ),
    alignment: Alignment.bottomCenter,
  ),
),
          ],
        ),
      
      ),
    );
  }
}
