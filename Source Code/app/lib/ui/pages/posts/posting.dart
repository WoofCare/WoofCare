import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';

import '/config/constants.dart';
import '/ui/widgets/custom_button.dart';
import '/ui/widgets/custom_textfield.dart';

class PostingPage extends StatefulWidget {
  final ScrollController scrollController;

  const PostingPage({super.key, required this.scrollController});

  @override
  State<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  final currUser = AUTH.currentUser!;
  final _postTextController = TextEditingController();

  void postMessage() {
    if (_postTextController.text.isNotEmpty) {
      FIRESTORE.collection("User Posts").add({
        'email': currUser.email,
        'message': _postTextController.text,
        'timestamp': Timestamp.now(),
        'likes': [],
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Decoration for the box (shadow, border radius, color)
      decoration: const BoxDecoration(
        color: WoofCareColors.secondaryBackground,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        // Column to hold the rows of info and inputs ("Exit" and "Post"), and input field for posting (and images in the future)
        children: [
          // Row containing "Exit" and "Post" button
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: WoofCareColors.primaryTextAndIcons,
                    ),
                    tooltip: "Back",
                  ),
                ),

                CustomButton(
                  text: 'Post',
                  fontSize: 12,
                  verticalPadding: 12,
                  horizontalPadding: 40,
                  margin: 10,
                  fontWeight: FontWeight.w200,

                  onTap: () => postMessage(),
                ),
              ],
            ),
          ),

          // Row containing user's info (profile pic and email)
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Row(
              spacing: 10.0,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFCAB096),
                  child: Icon(
                    Icons.person,
                    color: WoofCareColors.primaryTextAndIcons,
                  ),
                ),

                Text(
                  "${AUTH.currentUser!.email}",
                  style: TextStyle(color: WoofCareColors.primaryTextAndIcons),
                ),
              ],
            ),
          ),

          // Dog Description text field
          CustomTextField(
            controller: _postTextController,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            hintText: "What's on your mind?",
            horizontalPadding: 0,
            minLines: 20,
            maxLines: 20,
            top: 15,
            bottom: 15,
          ),
        ],
      ),
    );
  }
}
