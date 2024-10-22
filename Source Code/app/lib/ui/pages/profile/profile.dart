import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //TODO: Initialize user info
  String firstName = "";
  String lastName = "";
  String bio =
      "Hi, my name is John. This is my bio, I love helping stray dogs and my community. Reach out to me if you need any help!";
  String username = "johndoe";
  String password = "******";
  String userID = "";
  String email = "johndoe@gmail.com";
  String association = "Voice Of Stray Dogs";
  String profilePictureAsset = "";

  DateTime dateofBirth = DateTime(2000);

  List followers = [];
  List following = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 178, 235, 173),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/patterns/BigPawPattern.png",
                  ),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Profile Picture
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/ProfPic.png",
                          width: 200, // Set the bounding box width
                          height: 200, // Set the bounding box height
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

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
                      child: Text(
                        "Username: $username",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),

                    //Bio
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
                      child: Text(bio,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 15,
                          )),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),

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
                        "Email: $email",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),

                    //Associations
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
                        "Associations: $association",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15,
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
    );
  }
}
