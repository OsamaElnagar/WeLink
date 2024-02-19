import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_link/shared/bloc/post_cubit/post_cubit.dart';
import 'package:we_link/shared/components/post_items/items_designs/post_image_full_screen.dart';
import 'package:we_link/shared/components/streams/stream_on_react_num.dart';

import '../../../../models/post_model.dart';
import '../../../styles/icons_broken.dart';

class PostImage extends StatelessWidget {
  const PostImage({
    Key? key,
    required this.iconSize,
    required this.postModel,
    required this.postCubit,
    required this.isVideoAvailable,
  }) : super(key: key);
  final PostCubit postCubit;
  final PostModel postModel;
  final double iconSize;
  final bool isVideoAvailable;


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
              showDragHandle: true,
              useSafeArea: true,
              constraints: const BoxConstraints.expand(),
              backgroundColor: CupertinoColors.systemPurple,
              context: context,
              enableDrag: true,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  side: BorderSide(
                    color: Colors.cyan,
                    width: 1,
                  )
              ),
              builder: (context) => PostImageFullScreen(
                  postModel: postModel, postCubit: postCubit),
            );
          },
          child: Hero(
            tag: postModel.postImage!,
            child: Placeholder(
              strokeWidth: 0,
              color: Colors.white,
              fallbackHeight: 400,
              child: Image(
                image: NetworkImage(postModel.postImage!),
                fit: BoxFit.cover,
                height: 400,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.deepPurple.withOpacity(.5),
                  ));
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Some errors occurred!'),
              ),
            ),
          ),
        ),
        if(!isVideoAvailable)Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.6),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 60.0,
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StreamOnLoveNumber(
                postId: postModel.postUid,
                postCubit: postCubit,
                textColor: Colors.white,
              ),
              StreamOnCommentsNumber(
                  postCubit: postCubit,
                  postId: postModel.postUid,
                  postOwner: postModel.name,
                  textColor: Colors.white),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    IconBroken.Send,
                    color: Colors.blue,
                  ),
                  Text(
                    '0',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
