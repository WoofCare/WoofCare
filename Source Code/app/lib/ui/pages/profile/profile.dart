import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:woofcare/ui/pages/home/home.dart';
import 'package:woofcare/ui/widgets/custom_button.dart';
import 'package:woofcare/ui/widgets/custom_stat.dart';
import '/config/colors.dart';
import '/config/constants.dart';
import '/ui/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _bioTextController = TextEditingController(text: profile.bio);
  bool _editMode = false;

  // @override
  // void dispose() {
  //   _bioTextController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFEEB784),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEEB784),
          foregroundColor: WoofCareColors.primaryTextAndIcons,
          actions: [
            MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: () {
                    setState(() {
                      _editMode = !_editMode;
                    });
                  },
                  leadingIcon: _editMode
                      ? const Icon(Icons.create_rounded)
                      : const Icon(Icons.create_outlined),
                  child: const Text('Edit Mode'),
                ),
              ],
              builder: (BuildContext context, MenuController controller, Widget? child) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                );
              },
            )
          ],
        ),
        //Header
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
          },
          child: Column(
            children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                const SizedBox(width: 20), // Spacer on the left
            
                // Profile Picture
                
                GestureDetector(
                  onTap: () {}, //TODO: Add photo function
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: WoofCareColors.primaryTextAndIcons, // Stroke color
                        width: 3.0, // Stroke width
                      ),
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
                    )
                  )
                  ),
            
                //spacer between picture and text
                const SizedBox(
                  width: 5,
                ),

                //profile information 
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
                                    )
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      )
                    )
                ),
                const SizedBox(
                  width: 20,
                ), // Spacer on the right
              ],
              ),
               
              // Spacer
              const SizedBox(height: 20),

            
              // Button Row
              //TODO: add functionality to buttons
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right:0),
                    child: CustomButton(
                        height: 60,
                        width: 200,
                        color: WoofCareColors.backgroundElementColor,
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
                        color: WoofCareColors.buttonColor,
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

              // Spacer
              const SizedBox(height: 20),

              // AboutInformation
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: WoofCareColors.offWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )
                  ),
                  child: Column(
                  children: [
                  // Row of two buttons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 25),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            backgroundColor: WoofCareColors.buttonColor,
                          ),
                          child: Text('About', style: TextStyle(fontSize: 12, color: WoofCareColors.offWhite)),
                        ),
                        SizedBox(width: 25),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 25),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            backgroundColor: WoofCareColors.backgroundElementColor
                          ),
                          child: Text('Posts', style: TextStyle(fontSize: 12, color: WoofCareColors.primaryTextAndIcons)),
                        ),
                      ],
                    ),
                  ),

                  //Stats
                  //TODO: connect stats to database
                  Container(
                    height: 60, // controls vertical height of stats and dividers
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        custom_stat('1.2K', 'Posts'),
                        VerticalDivider(
                          color: WoofCareColors.dividerColor,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                        custom_stat('345', 'Followers'),
                        VerticalDivider(
                          color: WoofCareColors.dividerColor,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                        custom_stat('87', 'Following'),
                        VerticalDivider(
                          color: WoofCareColors.dividerColor,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                        custom_stat('5', 'Reports'),
                      ],
                    ),
                  ),

                  // Spacer
                  const SizedBox(height: 20),

                  // Biography Section
                  Container(alignment : Alignment.center,
                    padding: EdgeInsets.only(left: 16),
                    child: Text('About:', 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: WoofCareColors.primaryTextAndIcons
                      )
                    )
                  ),
                  // Biography box
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: WoofCareColors.offWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _editMode
                        ? TextField(
                            controller: _bioTextController,
                            maxLines: 10,
                            maxLength: 500,
                            buildCounter: (
                              BuildContext context, {
                              required int currentLength,
                              required bool isFocused,
                              required int? maxLength,
                            }) {
                              return Text(
                                '$currentLength / $maxLength',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: WoofCareColors.primaryTextAndIcons,
                                ),
                              );
                            },
                            style: TextStyle(fontSize: 12, color: WoofCareColors.primaryTextAndIcons),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(color: WoofCareColors.backgroundElementColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(color: WoofCareColors.backgroundElementColor),
                              ),
                              hintText: 'Enter your biography...',
                              hintStyle: TextStyle(color: WoofCareColors.primaryTextAndIcons),
                              fillColor: WoofCareColors.textBoxColor,
                            ),
                          )
                        : Text(
                            _bioTextController.text.isEmpty
                                ? 'This is the biography box. Here you can write a short description about the user.'
                                : _bioTextController.text,
                            maxLines: 10,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 12, color: WoofCareColors.primaryTextAndIcons),
                          ),
                  ),

                  // Spacer
                  const SizedBox(height: 10),

                  Divider(
                    color: WoofCareColors.dividerColor,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16,
                  ),

                  // List of item
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3, // Example item count
                      itemBuilder: (context, index) => ListTile(
                          leading: Icon(Icons.pets, color: WoofCareColors.primaryTextAndIcons),
                          title: Text('Item ${index + 1}', 
                          style: 
                            TextStyle(color: WoofCareColors.primaryTextAndIcons, fontSize: 12)),
                          /*subtitle: Text('Subtitle for item ${index + 1}', style: TextStyle(color: WoofCareColors.buttonColor)),*/
                           )
                          ) 
                  )
                ],
                ),
              ),
              ),
            ]
          )
        ),
        ),
      );
  }
}
