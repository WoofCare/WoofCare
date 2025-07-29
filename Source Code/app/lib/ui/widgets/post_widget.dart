import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';

class Post extends StatelessWidget {
  final String message;
  final String user;
  final String time;
  
  const Post({
    super.key,
    required this.message,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // constraints: BoxConstraints(
        //   maxWidth: 300
        // ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: WoofCareColors.postBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.0,
                children: [
                  // Expanded(child: Icon(Icons.insert_photo)),
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
                            Text(
                              user, 
                              style: TextStyle(
                                color: WoofCareColors.primaryTextAndIcons
                              ),
                            ),
                            Flexible(
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
                          message,
                          style: TextStyle(
                            color: WoofCareColors.primaryTextAndIcons
                          ),
                          // maxLines: 1,
                          // softWrap: false,
                          // overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.thumb_up),
                  color: WoofCareColors.inputBackground,
                ),
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
