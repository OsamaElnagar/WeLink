import 'dart:io';

import 'package:flutter/material.dart';

import '../../../bloc/post_cubit/post_cubit.dart';
import '../../../styles/icons_broken.dart';
import '../../components.dart';

class ImageFileForPost extends StatefulWidget {
  const ImageFileForPost({Key? key, required this.cubit, this.postImageFile}) : super(key: key);

  final PostCubit cubit;
  final File? postImageFile;

  @override
  State<ImageFileForPost> createState() => _ImageFileForPostState();
}

class _ImageFileForPostState extends State<ImageFileForPost> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Padding(
          padding:  const EdgeInsets.all(8.0),
          child: Image(
            image: FileImage(widget.postImageFile!),
            fit: BoxFit.cover,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.deepPurple.withOpacity(.8),
          child: IconButton(
            onPressed: () {
              dialogMessage(
                context: context,
                title: const Text(
                  'remove',
                  style: TextStyle(color: Colors.red),
                ),
                content: const Text(
                  'Are you sure deleting this photo?',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        widget.cubit.undoPickPostImage();
                        Navigator.pop(context);
                      });
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
            icon: const Icon(IconBroken.Close_Square),
          ),
        ),
      ],
    );
  }
}
