import 'package:flutter/material.dart';

class SocialMediaFeed extends StatefulWidget {
  const SocialMediaFeed({super.key});

  @override
  State<SocialMediaFeed> createState() => _SocialMediaFeedState();
}

class _SocialMediaFeedState extends State<SocialMediaFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [Post(), Post(), Post()]),
            ),
          ),
        ],
      ),
    );
  }
}

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
        constraints: BoxConstraints.expand(height: 700),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Icon(Icons.insert_photo)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
