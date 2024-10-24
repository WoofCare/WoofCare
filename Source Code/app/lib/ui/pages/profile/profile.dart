import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() async {
    super.initState();

    try {
      //get user document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("userData")
          .doc(widget.uid)
          .get();

      //initialize fields
      firstName = userDoc.get('firstName');
      lastName = userDoc.get('lastName');
      email = userDoc.get('email');
      role = userDoc.get('role');
      bio = "Hi, my name is " + firstName + " " + lastName + "...";
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  String firstName = "";
  String lastName = "";
  String bio = "";
  String password = "******";
  String userID = "";
  String email = "";
  String role = "";
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
                        "Name: $firstName $lastName",
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
                        "Role: $role",
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
