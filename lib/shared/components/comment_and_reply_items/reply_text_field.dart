import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_link/shared/components/constants.dart';
import '../../bloc/AppCubit/cubit.dart';
import '../../styles/icons_broken.dart';
import 'build_comment_item.dart';






Widget buildCommentReplyFieldItem({
  required TextEditingController replyController,
  required BuildContext context,
  Function(String)? onChanged,
  required String replyText,
  required index,
}) {
  var cubit = AppCubit.get(context);

  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black54),
            child: TextFormField(
              focusNode: nodeFirst,
              autofocus: true,
              controller: replyController,
              decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 90,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cubit.getCameraCommentReplyImage();
                                        },
                                        icon: const Icon(IconBroken.Camera),
                                      ),
                                      const Text('Camera'),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cubit.getGalleryCommentReplyImage();
                                        },
                                        icon: const Icon(IconBroken.Image_2),
                                      ),
                                      const Text('Gallery'),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Icon(
                      IconBroken.Image,
                    ),
                  ),
                  hintText: 'Type a reply',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(20),
                        left: Radius.circular(20),
                      ))),
              style: const TextStyle(
                color: Colors.white,
              ),
              cursorColor: Colors.deepPurple,
              onChanged: onChanged,
              onFieldSubmitted: (v) {},
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: InkWell(
            onTap: () {
              if (replyText != '' || cubit.commentReplyImageFile != null) {
                var date = DateTime.now();
                String replyDate = DateFormat.yMMMMd().format(date);
                if (cubit.commentImageFile != null) {
                  cubit.createCommentReplyWithImage(
                    postId: cubit.feedPostId[postIndex],
                    commentId: cubit.commentId[index],
                    commentReplyText: replyText,
                    commentReplyDate: replyDate,
                  );
                  cubit.storeReplyWithImage(
                    postId: cubit.feedPostId[postIndex],
                    commentReplyText: replyText,
                    commentReplyDate: replyDate,
                  );
                } else {
                  cubit.createCommentReply(
                    postId: cubit.feedPostId[postIndex],
                    replyText: replyText,
                    replyDate: replyDate,
                    commentId: cubit.commentId[index],
                  );
                  cubit.storeReply(
                    postId: cubit.feedPostId[postIndex],
                    replyText: replyText,
                    replyDate: replyDate,
                    context: context,
                  );
                }
              }
              FocusScope.of(context).unfocus();
              replyController.clear();
            },
            child: const Icon(IconBroken.Send),
          ),
        ),
      ),
    ],
  );
}
