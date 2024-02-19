import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/shared/bloc/comment_cubit/comment_cubit.dart';
import 'package:we_link/shared/components/constants.dart';
import 'package:we_link/shared/components/lottie_animations/lottie_assets_names.dart';
import 'package:we_link/shared/components/lottie_animations/lottie_builder.dart';
import '../../shared/components/comment_and_reply_items/build_comment_item.dart';
import '../../shared/components/comment_and_reply_items/comment_text_field.dart';

class CommentsSheet extends StatefulWidget {
  const CommentsSheet(
      {Key? key, required this.postUid, required this.postOwner})
      : super(key: key);

  final String postUid;
  final String postOwner;

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  TextEditingController commentController = TextEditingController();
  String commentText = '';
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentCubit()
        ..initUser(context)
        ..getComments(postUid: widget.postUid),
      child: BlocConsumer<CommentCubit, CommentStates>(
        listener: (context, state) {
          if (state is CreateCommentSuccessState) {
            var cCubit = CommentCubit.get(context);
            cCubit.getComments(postUid: widget.postUid);
          }
        },
        builder: (context, state) {
          var cCubit = CommentCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Comments on ${widget.postOwner}\'s Post',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: null,
                        child: Text(
                          cCubit.comments.length.toString(),
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ConditionalBuilder(
                  builder: (context) => Expanded(
                    child: SingleChildScrollView(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return buildCommentItem(
                            context: context,
                            comment: cCubit.comments[index],
                            index: index,
                            // replyWidget: StreamBuilder<QuerySnapshot>(
                            //   stream: FirebaseFirestore.instance
                            //       .collection('posts')
                            //       .doc(cubit.feedPostId[postIndex])
                            //       .collection('comments')
                            //       .doc(cubit.commentId[index])
                            //       .collection('reply')
                            //       .snapshots(),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasData) {
                            //       if (snapshot.data!.docs.isNotEmpty) {
                            //         return InkWell(
                            //           onTap: () {
                            //             commentIndex = index;
                            //             cubit.getCommentsReply(
                            //                 postId:
                            //                     cubit.feedPostId[postIndex],
                            //                 commentId: cubit
                            //                     .commentId[commentIndex]);
                            //             navigateTo(
                            //                 context, const ReplyScreen());
                            //           },
                            //           child: Text(
                            //             '${snapshot.data!.docs.length.toString()} replies',
                            //             style: const TextStyle(
                            //                 color: Colors.blue),
                            //           ),
                            //         );
                            //       } else {
                            //         return Container();
                            //       }
                            //     }
                            //     return Container();
                            //   },
                            // ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 28.0, right: 28.0, top: 5, bottom: 5),
                            child: Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[300],
                            ),
                          );
                        },
                        itemCount: cCubit.comments.length,
                      ),
                    ),
                  ),
                  condition: cCubit.comments.isNotEmpty,
                  fallback: (context) => const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AssetLotties(asset: userHasNoPosts),
                          Text(
                            'No comments here yet!\n be the first to comment.',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: buildCommentFieldItem(
              postUid: widget.postUid,
              commentController: commentController,
              context: context,
              onChanged: (inputText) {
                setState(() {
                  commentText = inputText;
                });
              },
              commentText: commentText,
              index: postIndex,
            ),
          );
        },
      ),
    );
  }
}
