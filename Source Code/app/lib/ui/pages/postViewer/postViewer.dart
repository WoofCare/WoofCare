import 'package:flutter/material.dart';

class PostViewerPage extends StatelessWidget {
  const PostViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Text(
          'Post Viewer Page',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}