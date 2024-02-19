import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_link/models/story_model.dart';
import 'package:we_link/modules/story/full_screen_display.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/styles/colors.dart';
import 'package:we_link/shared/styles/texts.dart';


class StoryItems extends StatelessWidget {
  const StoryItems({
    Key? key,
    required this.stories,
    required this.index,
  }) : super(key: key);

  final List<StoryModel> stories;
  final int index;

  void listHandler(List<StoryModel> stories) {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pint('story in index: $index clicked');
        navigateTo(context, FullScreenStory(storyIndex: index));
      },
      child: Stack(
        children: [
          if (stories.last.storyImage != '')
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: WeLinkColors.myColor,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(stories.last.storyImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (stories.last.storyText != '' && stories.last.storyImage == '')
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: WeLinkColors.myColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    stories.last.storyText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.actor(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Badge(
                backgroundColor: Colors.deepPurpleAccent,
                label: Text(stories.length.toString()),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black.withOpacity(.7),
                  foregroundImage: NetworkImage(stories.last.profileImage),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 90,
              height: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12,
              ),
              padding: const EdgeInsets.all(1.0),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: WeLinkHints(
                hint: stories.last.name,
                fs: 12.0,
                maxLines: 1,
                fw: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
