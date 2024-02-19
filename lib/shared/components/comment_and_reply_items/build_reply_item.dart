
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_link/models/comment_reply_model.dart';
import '../../styles/icons_broken.dart';

Row buildReplyItem({
  required BuildContext context,
  required CommentReplyModel commentReplyModel,
  index,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(commentReplyModel.profileImage)),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            right: 15.0,
          ),
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
                                commentReplyModel.name,
                                style: GoogleFonts.aclonica(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              commentReplyModel.replyText,
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
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(.7),
                      ),
                      child: const Icon(
                        IconBroken.More_Circle,
                        color: Colors.white,
                        size: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
              //almost will be disabled...!
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'like',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // InkWell(
                  //   onTap: () {},
                  //   child: const Text(
                  //     'replay',
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}