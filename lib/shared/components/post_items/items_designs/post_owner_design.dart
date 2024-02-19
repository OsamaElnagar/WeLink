import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/post_model.dart';
import '../../image_bottom_sheet_viewer.dart';

class PostOwner extends StatelessWidget {
  const PostOwner({
    Key? key,
    required this.postModel,
    required this.postDate,
    required this.moreVert,
    required this.onTap,
  }) : super(key: key);

  final PostModel postModel;
  final String postDate;
  final Widget moreVert;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          radius: 29,
          borderRadius: BorderRadius.circular(50),
          onTap: () => showImageSheetViewer(context, postModel.profileImage),
          child: CircleAvatar(
            radius: 26.5,
            backgroundColor: Colors.deepPurple,
            child: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(postModel.profileImage),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postModel.name,
                    style: GoogleFonts.aclonica(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    postDate,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      height: .6,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        moreVert
      ],
    );
  }
}
