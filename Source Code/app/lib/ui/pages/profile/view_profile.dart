import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/ui/widgets/contact_info.dart';
import 'package:woofcare/ui/widgets/custom_button.dart';

import '/config/colors.dart';
import '/config/constants.dart';
import '/models/profile.dart';

class ViewProfilePage extends StatefulWidget {
  final String userName;
  final int? photoID;

  const ViewProfilePage({
    super.key,
    required this.userName,
    this.photoID,
  });

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  Profile? userProfile;
  bool isLoading = true;
  ImageProvider? profileImage;
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Fetch user profile by name
      QuerySnapshot snapshot = await FIRESTORE
          .collection("users")
          .where("name", isEqualTo: widget.userName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        setState(() {
          userProfile = Profile(
            id: doc.id,
            name: doc.get("name") as String,
            email: doc.get("email") as String? ?? "",
            role: doc.get("role") as String? ?? "",
            bio: doc.get("bio") as String? ?? "",
            reference: doc.reference,
          );
          email = userProfile!.email;
          phone = doc.get("phone") as String? ?? "(123) 456-7890";
          isLoading = false;
        });

        // Load profile image if available
        if (widget.photoID != null) {
          setState(() {
            profileImage = AssetImage(
              "assets/images/placeholders/${widget.photoID}.jpg",
            );
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading profile: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _openChat(BuildContext context) async {
    if (userProfile == null) return;

    try {
      // Check if conversation already exists
      QuerySnapshot snapshot = await FIRESTORE
          .collection('Conversations')
          .where("Participants", arrayContains: profile.name)
          .get();

      var conversations = snapshot.docs.where((doc) {
        List participants = doc["Participants"] as List;
        return participants.contains(userProfile!.name);
      });

      String chatID;
      if (conversations.isEmpty) {
        // Create new conversation
        DocumentReference newConvo = await FIRESTORE
            .collection("Conversations")
            .add({
              "messages": [],
              "Participants": [profile.name, userProfile!.name],
            });
        chatID = newConvo.id;
      } else {
        // Use existing conversation
        chatID = conversations.first.id;
      }

      if (!context.mounted) return;
      Navigator.pop(context); // Close profile page
      Navigator.pushNamed(
        context,
        '/chat',
        arguments: {
          'chatID': chatID,
          'participant': userProfile!.name,
          'photoID': widget.photoID,
        },
      );
    } catch (e) {
      print("Error opening chat: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error opening chat. Please try again."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: WoofCareColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: WoofCareColors.primaryBackground,
          foregroundColor: WoofCareColors.primaryTextAndIcons,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userProfile == null) {
      return Scaffold(
        backgroundColor: WoofCareColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: WoofCareColors.primaryBackground,
          foregroundColor: WoofCareColors.primaryTextAndIcons,
        ),
        body: const Center(
          child: Text("User not found"),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: WoofCareColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: WoofCareColors.primaryBackground,
        foregroundColor: WoofCareColors.primaryTextAndIcons,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                // Profile Picture
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: WoofCareColors.primaryTextAndIcons,
                      width: 3.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: WoofCareColors.offWhite,
                    backgroundImage: profileImage,
                    child: profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 100,
                            color: WoofCareColors.primaryTextAndIcons,
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 5),

                // Profile information
                Expanded(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Username
                            SizedBox(
                              height: 30,
                              width: 300,
                              child: Text(
                                userProfile!.name,
                                style: const TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: WoofCareColors.primaryTextAndIcons,
                                ),
                              ),
                            ),

                            // Role
                            SizedBox(
                              width: 300,
                              child: Text(
                                userProfile!.role,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: WoofCareColors.primaryTextAndIcons,
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            // Location
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

                            const SizedBox(height: 5),

                            ContactInfoSection(
                              isEditMode: false,
                              email: email,
                              phone: phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),

            const SizedBox(height: 20),

            // Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: CustomButton(
                    height: 60,
                    width: 200,
                    color: WoofCareColors.backgroundElementColor,
                    fontColor: WoofCareColors.primaryTextAndIcons,
                    fontSize: 14,
                    borderRadius: 16,
                    text: "Message",
                    onTap: () async {
                      await _openChat(context);
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
                        // TODO: Add follow functionality
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // About Information
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: WoofCareColors.offWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Biography Section
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'About:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: WoofCareColors.primaryTextAndIcons,
                        ),
                      ),
                    ),

                    // Biography box
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: WoofCareColors.offWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        userProfile!.bio.isEmpty
                            ? 'No biography available.'
                            : userProfile!.bio,
                        maxLines: 5,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 12,
                          color: WoofCareColors.primaryTextAndIcons,
                        ),
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
