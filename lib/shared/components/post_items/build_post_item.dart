import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_link/models/post_model.dart';
import 'package:we_link/shared/bloc/post_cubit/post_cubit.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/components/constants.dart';
import 'package:we_link/shared/components/file_video_post.dart';
import 'package:we_link/shared/utility/dateTime_manager.dart';
import '../../../modules/profiles/visited_profile_screen.dart';
import 'items_designs/post_image_design.dart';
import 'items_designs/post_owner_design.dart';
import 'items_designs/post_text_design.dart';
import 'items_designs/reactions_design.dart';

class BuildPostItem extends StatelessWidget {
  const BuildPostItem({
    Key? key,
    required this.postModel,
    required this.moreVert,
    this.canOpenPersonalProfile = true,
  }) : super(key: key);
  final PostModel postModel;
  final Widget moreVert;
  final bool canOpenPersonalProfile;

  @override
  Widget build(BuildContext context) {
    String postDate = postModel.postDate;
    String detailedPostDate =
        DateFormat.yMMMMEEEEd().format(DateTime.parse(postDate));

    postDate = calculateElapsedTime(uploadDate: postDate);
    var postCubit = PostCubit.get(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
          child: PostOwner(
            postModel: postModel,
            postDate: '$postDate, $detailedPostDate',
            moreVert: moreVert,
            onTap: () {
              if (canOpenPersonalProfile) {
                navigateTo(
                    context,
                    VisitedProfileScreen(
                      userUid: postModel.userUid!,
                      personalProfile: uId==postModel.userUid!,
                    ));
              }
            },
          ),
        ),
        if (postModel.postText != '')
          //If I have a text whether I have an image and video or not.
          PostText(postText: postModel.postText),
        const SizedBox(height: 4),
        // If a post with an image!..
        if (postModel.postImage != '')
          PostImage(
            postCubit: postCubit,
            iconSize: 25,
            postModel: postModel,
            isVideoAvailable: (postModel.videoLink != '') ? true : false,
          ),
        if (postModel.videoLink != '')
          const Divider(color: Colors.grey, height: 1),

        if (postModel.videoLink != '')
          VideoPostOsama(
            videoLink: postModel.videoLink!,
          ),
        //Reactions Bar/////////////////////////////////🔽🔽🔽

        if (postModel.postText != '' && postModel.postImage == '')
          TextReactions(
            iconSize: 25,
            postModel: postModel,
          ),
        if (postModel.videoLink != '' && postModel.postImage != '')
          TextReactions(
            iconSize: 25,
            postModel: postModel,
          ),
        //Reactions Bar/////////////////////////////////🔼🔼🔼
      ],
    );
  }
}
