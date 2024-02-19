import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/shared/bloc/post_cubit/post_cubit.dart';
import '../../../../models/post_model.dart';
import '../../../styles/icons_broken.dart';
import '../../streams/stream_on_react_num.dart';

class TextReactions extends StatelessWidget {
  const TextReactions({
    Key? key,
      required this.iconSize,
    required this.postModel,

  }) : super(key: key);
  final double iconSize;
  final PostModel postModel;


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var postCubit = PostCubit.get(context);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamOnLoveNumber(
              postId: postModel.postUid,
              postCubit: postCubit,
            ),
            StreamOnCommentsNumber(
              postId: postModel.postUid,
              postOwner: postModel.name,
              postCubit: postCubit,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      IconBroken.Send,
                      color: Colors.blue,
                      size: iconSize,
                    ),
                  ),
                ),
                const Text(
                  '0',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

