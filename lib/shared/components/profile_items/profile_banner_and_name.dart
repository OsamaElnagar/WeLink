import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_link/shared/components/image_bottom_sheet_viewer.dart';

import '../../../models/login_model.dart';

class ProfileBannerAndName extends StatelessWidget {
  const ProfileBannerAndName({
    Key? key,
    required this.user,
  }) : super(key: key);

  final LoginModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          //color: WeLinkColors.myColor.withOpacity(.4),
          width: double.infinity,
          height: 230,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: InkWell(
                  onTap: () => showImageSheetViewer(context, user.profileCover),
                  child: Image(
                    image: NetworkImage(user.profileCover),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  //color: Colors.cyanAccent.withOpacity(.3),
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 140,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.actor(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user.bio,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,bottom: 20),
                  child: InkWell(
                    onTap: () => showImageSheetViewer(context, user.profileImage),
                    child: SizedBox(
                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        radius: 65,
                        child: CircleAvatar(
                          radius: 62,
                          backgroundImage: NetworkImage(user.profileImage),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
      ],
    );
  }
}
