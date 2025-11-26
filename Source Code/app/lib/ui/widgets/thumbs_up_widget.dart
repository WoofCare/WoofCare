import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/config/constants.dart';

class ThumbsUpButton extends StatefulWidget {
  final String postId;
  final int numOfLikes;

  const ThumbsUpButton({
    super.key,
    required this.postId,
    required this.numOfLikes,
  });

  @override
  State<ThumbsUpButton> createState() => _ThumbsUpButtonState();
}

class _ThumbsUpButtonState extends State<ThumbsUpButton> {
  bool isLiked = false;
  final currUser = AUTH.currentUser!;

  void postLiked() {
    setState(() {
      isLiked = !isLiked;
    });

    // Get a reference from the post that holds the current thumbs up widget
    DocumentReference postRef = FIRESTORE
        .collection('posts')
        .doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'likes': FieldValue.arrayUnion([currUser.email]),
      });
    } else {
      postRef.update({
        'likes': FieldValue.arrayRemove([currUser.email]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: postLiked,
          icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined),
          color:
              isLiked
                  ? WoofCareColors.primaryTextAndIcons
                  : WoofCareColors.inputBackground,
        ),

        Text(
          widget.numOfLikes.toString(),
          style: TextStyle(color: WoofCareColors.primaryTextAndIcons),
        ),
      ],
    );
  }
}
