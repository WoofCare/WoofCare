import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/widgets/thumbs_up_widget.dart';

class Post extends StatelessWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> usersWhoLiked;
  
  Post({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.usersWhoLiked,
  });

  final currUser = AUTH.currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // The container that holds all the elements of the post
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: WoofCareColors.postBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              // Row that holds the profile pic and the rest of the post info
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.0,
                children: [
                  // TODO: currently an avatar icon placeholder
                  CircleAvatar(
                    backgroundColor: Color(0xFFCAB096),
                    child: Icon(
                      Icons.person,
                      color: WoofCareColors.primaryTextAndIcons,
                    ),
                  ),

                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.0,
                      children: [
                        Row(
                          spacing: 5.0,
                          children: [
                            // User's Email
                            Text(
                              user, 
                              style: TextStyle(
                                color: WoofCareColors.primaryTextAndIcons
                              ),
                            ),
                            
                            Text(
                              '·', 
                              style: TextStyle(
                                color: WoofCareColors.primaryTextAndIcons, 
                              ),
                            ),

                            Flexible(
                              // Posting time
                              child: Text(
                                time, 
                                style: TextStyle(
                                  color: WoofCareColors.primaryTextAndIcons.withValues(alpha: 0.5),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      
                        Text(
                          // The message of the post (the main part)
                          message,
                          style: TextStyle(
                            color: WoofCareColors.primaryTextAndIcons
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      
            // Row that holds the three interactions with the post (like it, comment it, share it)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ThumbsUpButton(postId: postId, numOfLikes: usersWhoLiked.length,),

                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.comment),
                  color: WoofCareColors.inputBackground,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.share),
                  color: WoofCareColors.inputBackground,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
