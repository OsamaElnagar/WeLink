import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class PostText extends StatelessWidget {
  const PostText({
    Key? key, required this.postText,
  }) : super(key: key);
  final String postText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ReadMoreText(
        postText,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }
}
