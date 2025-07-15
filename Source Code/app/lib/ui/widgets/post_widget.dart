import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: 500),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: WoofCareColors.postBackground,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Icon(Icons.insert_photo)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up), color: WoofCareColors.inputBackground,),
                  IconButton(onPressed: () {}, icon: Icon(Icons.comment), color: WoofCareColors.inputBackground,),
                  IconButton(onPressed: () {}, icon: Icon(Icons.share), color: WoofCareColors.inputBackground,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
