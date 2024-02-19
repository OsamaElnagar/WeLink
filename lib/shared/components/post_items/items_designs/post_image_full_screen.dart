import 'package:flutter/material.dart';
import 'package:we_link/shared/bloc/post_cubit/post_cubit.dart';
import 'package:we_link/shared/components/post_items/items_designs/post_text_design.dart';
import 'package:we_link/shared/components/streams/stream_on_react_num.dart';

import '../../../../models/post_model.dart';

class PostImageFullScreen extends StatelessWidget {
  const PostImageFullScreen({
    Key? key,
    required this.postModel,
    required this.postCubit,
  }) : super(key: key);

  final PostModel postModel;
  final PostCubit postCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                size: 30,
                //color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 30,
                //color: Colors.white,
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Hero(
              tag: postModel.postImage!,
              child: Image(
                image: NetworkImage(
                  postModel.postImage!,
                ),
                errorBuilder: (context, error, stackTrace) =>
                    const Placeholder(),
              ),
            ),
          ),
        ),
        if (postModel.postText != '') PostText(postText: postModel.postText),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    StreamOnLoveNumber(
                      postId: postModel.postUid,
                      postCubit: postCubit,
                      textColor: Colors.white,
                    ),
                    const Text(
                      'likes',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    StreamOnCommentsNumber(
                      postId: postModel.postUid,
                      postOwner: postModel.name,
                      postCubit: postCubit,
                      textColor: Colors.white,
                    ),
                    const Text(
                      'comments',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    StreamOnShareNumber(
                      postId: postModel.postUid,
                      postCubit: postCubit,
                      textColor: Colors.white,
                    ),
                    const Text(
                      'shares',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
