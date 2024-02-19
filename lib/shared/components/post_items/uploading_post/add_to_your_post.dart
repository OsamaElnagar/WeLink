import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_link/shared/bloc/post_cubit/post_cubit.dart';
import 'package:we_link/shared/styles/colors.dart';
import 'package:we_link/shared/styles/icons_broken.dart';

class AddToYourPost extends StatelessWidget {
  const AddToYourPost({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final PostCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: WeLinkColors.myColor.withOpacity(.7),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'add to your post',
                  style: GoogleFonts.aclonica(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: () {
                  cubit.getGalleryPostImage();
                },
                icon: const Icon(
                  IconBroken.Image,
                  size: 40,
                  color: Colors.yellow,
                ),
              ),
              IconButton(
                onPressed: () {
                  cubit.getCameraPostImage();
                },
                icon: const Icon(
                  IconBroken.Camera,
                  size: 40,
                  color: Colors.greenAccent,
                ),
              ),
              IconButton(
                onPressed: () {
                  const TextStyle style = TextStyle(
                    color: Colors.white,
                  );
                  showDialog<String>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: WeLinkColors.myColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text(
                          'Choose Where to look for video?',
                          style: style,
                        ),
                        content: SizedBox(
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  cubit.pickPostVideo(source: 'Gallery');
                                },

                                child: const Text(
                                  'Gallery',
                                  style: style,
                                ),

                              ),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  cubit.pickPostVideo(source: 'Camera');
                                },

                                child: const Text(
                                  'Camera',
                                  style: style,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  IconBroken.Play,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.emoji_emotions_rounded,
                  size: 40,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
