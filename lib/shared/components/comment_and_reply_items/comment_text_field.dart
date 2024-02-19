import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_link/shared/bloc/comment_cubit/comment_cubit.dart';
import 'package:we_link/shared/styles/colors.dart';
import '../../styles/icons_broken.dart';

Widget buildCommentFieldItem({
  required TextEditingController commentController,
  required BuildContext context,
  Function(String)? onChanged,
  required String commentText,
  required String postUid,
  required index,
}) {
  var cubit = CommentCubit.get(context);
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black54),
            child: TextFormField(
              controller: commentController,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 90,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      cubit.getCameraCommentImage();
                                    },
                                    label: const Text('Camera'),
                                    icon: const Icon(IconBroken.Camera),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      cubit.getGalleryCommentImage();
                                    },
                                    icon: const Icon(IconBroken.Image_2),
                                    label: const Text('Gallery'),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Icon(
                      IconBroken.Image,
                      color: WeLinkColors.myColor,
                    ),
                  ),
                  hintText: 'Type a comment..',
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
              if (commentText != '' || cubit.commentImageFile != null) {
                var date = DateTime.now();
                String commentDate = DateFormat.yMMMMd().format(date);
                if (cubit.commentImageFile != null) {
                  cubit.createCommentWithImage(
                      postUid: 'cubit.feedPostId[index]',
                      commentText: commentText,
                      commentDate: commentDate);
                } else {
                  cubit.createComment(
                    postUid: postUid,
                    commentText: commentText,
                    commentDate: commentDate,
                  );
                }
              }
              FocusScope.of(context).unfocus();
              commentController.clear();
            },
            child: const Icon(IconBroken.Send),
          ),
        ),
      ),
    ],
  );
}
