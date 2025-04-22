import 'package:flutter/material.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: const Center(
        child: Text(
          'Articles Page',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}