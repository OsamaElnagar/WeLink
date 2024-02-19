import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_link/shared/bloc/post_cubit/post_cubit.dart';
import 'package:we_link/shared/components/constants.dart';
import '../../../modules/feeds/comment_screen.dart';
import '../../styles/icons_broken.dart';

class StreamOnLoveNumber extends StatelessWidget {
  final String postId;
  final PostCubit postCubit;
  final Color? textColor;

  const StreamOnLoveNumber({
    Key? key,
    required this.postId,
    required this.postCubit,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   // Show a loading indicator while fetching data
        //   return const Text('...');
        // }

        if (!snapshot.hasData || snapshot.data == null) {
          // Handle case where document doesn't exist or data is null
          return const Text(' ');
        }

        var postData = snapshot.data!;
        List postLikes = postData.get('postLikes') as List<dynamic>;

        // Calculate the length of the postLikes list
        int likesCount = postLikes.length;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                postLikes.contains(uId)
                    ? postCubit.dislikePost(
                        context: context,
                        postUid: postId,
                      )
                    : postCubit.likePost(
                        context: context,
                        postUid: postId,
                      );
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  IconBroken.Heart,
                  color: postLikes.contains(uId) ? Colors.red : Colors.grey,
                  size: 25,
                ),
              ),
            ),
            Text(
              ' $likesCount',
              style: TextStyle(color: textColor),
            ),
          ],
        );
      },
    );
  }
}

class StreamOnCommentsNumber extends StatelessWidget {
  final String postId;
  final String postOwner;
  final Color? textColor;
  final PostCubit postCubit;

  const StreamOnCommentsNumber({
    Key? key,
    required this.postId,
    this.textColor,
    required this.postCubit,
    required this.postOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   // Show a loading indicator while fetching data
        //   return const Text('...');
        // }

        if (!snapshot.hasData || snapshot.data == null) {
          // Handle case where document doesn't exist or data is null
          return const Text('!?');
        }

        var postData = snapshot.data!;
        var postComments = postData.get('postComments') as Map<String, dynamic>;

        // Calculate the length of the postComments map
        int commentsCount = postComments.length;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  useSafeArea: true,
                  constraints: const BoxConstraints.expand(),
                  backgroundColor: Colors.white,
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
                  builder: (context) => CommentsSheet(
                    postUid: postId,
                    postOwner: postOwner,
                  ),
                );

                // navigateTo(context,
                //     CommentsScreen(postUid: postId, postOwner: postOwner,));
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  IconBroken.More_Square,
                  color: postComments.containsKey(uId)
                      ? Colors.green
                      : Colors.greenAccent,
                  size: 25,
                ),
              ),
            ),
            Text(
              ' $commentsCount',
              style: TextStyle(color: textColor),
            ),
          ],
        );
      },
    );
  }
}

class StreamOnShareNumber extends StatelessWidget {
  final String postId;

  final Color? textColor;
  final PostCubit postCubit;

  const StreamOnShareNumber({
    Key? key,
    required this.postId,
    this.textColor,
    required this.postCubit,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   // Show a loading indicator while fetching data
        //   return const Text('...');
        // }

        if (!snapshot.hasData || snapshot.data == null) {
          // Handle case where document doesn't exist or data is null
          return const Text('!?');
        }

        var postData = snapshot.data!;
        List postShares = postData.get('postShares') as List<dynamic>;

        // Calculate the length of the postShares map
        int sharesCount = postShares.length;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: null,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  IconBroken.Send,
                  color: postShares.contains(uId)
                      ? Colors.blue
                      : Colors.lightBlueAccent,
                  size: 25,
                ),
              ),
            ),
            Text(
              ' $sharesCount',
              style: TextStyle(color: textColor),
            ),
          ],
        );
      },
    );
  }
}
