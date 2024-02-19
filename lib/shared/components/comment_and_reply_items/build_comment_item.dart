import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_link/shared/components/components.dart';

import '../../../models/comment_model.dart';
import '../../../modules/feeds/reply_comment_screen.dart';
import '../../bloc/AppCubit/cubit.dart';
import '../../styles/icons_broken.dart';

Widget buildCommentItem(
    {required BuildContext context,
    required CommentModel comment,
    //required Widget replyWidget,
    index}) {
  var cubit = AppCubit.get(context);
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      // color: Colors.black.withOpacity(.2),
    ),
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
              right: 2.0,
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(comment.profileImage),
            ),
          ),
          Expanded(
            child: Container(
              alignment: AlignmentDirectional.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(.7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      comment.name,
                                      style: GoogleFonts.aclonica(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    comment.commentText,
                                    style: GoogleFonts.aclonica(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 20,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 8.0, top: 3, bottom: 3),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap:  () {},
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                IconBroken.Heart,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              navigateTo(context, const ReplyScreen());
                            },
                            child: const Text(
                              'replay',
                            ),
                          ),
                        ],
                      ),
                    ),
                    //replyWidget,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

FocusNode nodeFirst = FocusNode();
FocusNode nodeSecond = FocusNode();
