import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/shared/bloc/story_cubit/story_cubit.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/styles/texts.dart';
import 'package:we_link/shared/utility/dateTime_manager.dart';
import '../../models/story_model.dart';
import '../../shared/styles/colors.dart';

class FullScreenStory extends StatefulWidget {
  FullScreenStory({Key? key, required this.storyIndex}) : super(key: key);

  int storyIndex;

  @override
  State<FullScreenStory> createState() => _FullScreenStoryState();
}

class _FullScreenStoryState extends State<FullScreenStory> {
  int subStoryIndex = 0;
  bool stillStoryToRight = true;
  bool stillStoryToLeft = false;
  double linearProgressValue = 0.0;
  final double endValue = 1.0;
  final Duration duration = const Duration(seconds: 10);
  final int steps = 100; // Number of steps to complete the animation
  bool storySeen = false;

  @override
  void initState() {
    super.initState();
    //startAnimation();
  }

  void startAnimation() {
    setState(() {
      storySeen = false;
    });
    double stepValue = endValue / steps;
    int stepDurationMilliseconds = (duration.inMilliseconds / steps).round();
    linearProgressValue = 0.0;
    for (int i = 0; i < steps; i++) {
      Future.delayed(Duration(milliseconds: i * stepDurationMilliseconds), () {
        setState(() {
          linearProgressValue += stepValue;
          if (linearProgressValue >= endValue ) {
            setState(() {
              pint('a7aaa');
              linearProgressValue = 0.0;
              storySeen = true;
            });
          }
        });
      });
    }

  }

  void swipeRight({required List stories, required List fullStories}) {
    setState(() {
      int maxStoriesLength = stories.length;
      //startAnimation();
      if (subStoryIndex < maxStoriesLength - 1) {
        subStoryIndex++;
        stillStoryToLeft = true;
      } else if (widget.storyIndex < fullStories.length - 1) {
        setState(() {
          widget.storyIndex++;
        });
        subStoryIndex = 0;
      }
      if (widget.storyIndex == fullStories.length - 1 &&
          subStoryIndex == maxStoriesLength - 1) {
        setState(() {
          stillStoryToRight = false;
        });
      }
    });
  }

  void swipeLeft(List stories) {
    setState(() {
      //startAnimation();
      int maxStoriesLength = stories.length;
      if (subStoryIndex != 0 && subStoryIndex <= maxStoriesLength - 1) {
        subStoryIndex--;
        stillStoryToRight = true;

        pint(subStoryIndex.toString());
      } else if (widget.storyIndex != 0) {
        setState(() {
          widget.storyIndex--;
          subStoryIndex = maxStoriesLength - 1;
        });
      }
      if (widget.storyIndex == 0 && subStoryIndex == 0) {
        stillStoryToLeft = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoryCubit, StoryStates>(
      listener: (context, state) {
        var cubit = StoryCubit.get(context);
        if (storySeen) {
          setState(() {
            swipeRight(
                stories: cubit.bigStories[widget.storyIndex],
                fullStories: cubit.bigStories);
          });
        }
      },
      builder: (context, state) {
        var cubit = StoryCubit.get(context);
        return Scaffold(
          backgroundColor: WeLinkColors.myColor,
          body: SafeArea(
            child: buildSliderStoryItem(
              switchLeft: () => swipeLeft(cubit.bigStories[widget.storyIndex]),
              switchRight: () => swipeRight(
                  stories: cubit.bigStories[widget.storyIndex],
                  fullStories: cubit.bigStories),
              storyModel: cubit.bigStories,
              storyIndex: widget.storyIndex,
              subStoryIndex: subStoryIndex,
              context: context,
              stillStoryToRight: stillStoryToRight,
              stillStoryToLeft: stillStoryToLeft,
              linearProgressValue: linearProgressValue,
            ),
          ),
        );
      },
    );
  }
}

Widget buildSliderStoryItem({
  required List<List<StoryModel>> storyModel,
  context,
  required int storyIndex,
  required int subStoryIndex,
  required double linearProgressValue,
  required VoidCallback switchRight,
  required VoidCallback switchLeft,
  required bool stillStoryToRight,
  required bool stillStoryToLeft,
}) {
  String storyDate = calculateElapsedTime(
      uploadDate: storyModel[storyIndex][subStoryIndex].storyDate);
  return Stack(
    children: [
      Column(
        children: [
          if (storyModel[storyIndex][subStoryIndex].storyImage != '')
            Expanded(
              child: Image(
                image: NetworkImage(
                  storyModel[storyIndex][subStoryIndex].storyImage!,
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
          if (storyModel[storyIndex][subStoryIndex].storyText != '' &&
              storyModel[storyIndex][subStoryIndex].storyImage != '')
            Expanded(
              child: Container(
                color: WeLinkColors.myColor,
                padding: const EdgeInsets.all(8.0),
                child: WeLinkNormalTexts(
                  norText:
                      'Caption: ${storyModel[storyIndex][subStoryIndex].storyText}',
                ),
              ),
            ),
          if (storyModel[storyIndex][subStoryIndex].storyText != '' &&
              storyModel[storyIndex][subStoryIndex].storyImage == '')
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: WeLinkNormalTexts(
                      norText: storyModel[storyIndex][subStoryIndex].storyText,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Container(
          alignment: Alignment.center,
          //color: Colors.red,
          height: 70,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    storyModel[storyIndex].length,
                    (index) => SizedBox(
                      width: MediaQuery.of(context).size.width /
                              (storyModel[storyIndex].length) -
                          5,
                      child: LinearProgressIndicator(
                        value:
                            index == subStoryIndex ? linearProgressValue : 0.0,
                        color: index == subStoryIndex ? Colors.green : null,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          storyModel[storyIndex][subStoryIndex].profileImage),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeLinkNormalTexts(
                            norText:
                                storyModel[storyIndex][subStoryIndex].name),
                        WeLinkHints(
                          hint: storyDate,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      if (stillStoryToLeft)
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: switchLeft,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 1.0,
                  )),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
          ),
        ),
      if (stillStoryToRight)
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: switchRight,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 1.0,
                  )),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
    ],
  );
}

// class SliderStoryItem extends StatelessWidget {
//   SliderStoryItem({
//     Key? key,
//     required this.storyModel,
//     required this.storyIndex,
//     required this.subStoryIndex,
//     required this.stillStoryToLeft,
//     required this.stillStoryToRight,
//     required this.switchRight,
//     required this.switchLeft,
//   }) : super(key: key);
//   List<List<StoryModel>> storyModel;
//   int storyIndex;
//   int subStoryIndex;
//    VoidCallback switchRight;
//    VoidCallback switchLeft;
//    bool stillStoryToRight;
//    bool stillStoryToLeft;
//   double theDouble = 0.0;
//   final double endValue = 1.0;
//   final Duration duration = const Duration(seconds: 10);
//   final int steps = 100; // Number of steps to complete the animation
//   void startAnimation() {
//     double stepValue = endValue / steps;
//     int stepDurationMilliseconds = (duration.inMilliseconds / steps).round();
//
//     for (int i = 0; i < steps; i++) {
//       Future.delayed(Duration(milliseconds: i * stepDurationMilliseconds), () {
//         setState(() {
//           theDouble += stepValue;
//         });
//       });
//     }
//   }
//
//   String storyDate = calculateElapsedTime(
//       uploadDate: storyModel[storyIndex][subStoryIndex].storyDate);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Column(
//           children: [
//             if (storyModel[storyIndex][subStoryIndex].storyImage != '')
//               Expanded(
//                 child: Image(
//                   image: NetworkImage(
//                     storyModel[storyIndex][subStoryIndex].storyImage!,
//                   ),
//                   fit: BoxFit.fitWidth,
//                 ),
//               ),
//             if (storyModel[storyIndex][subStoryIndex].storyText != '' &&
//                 storyModel[storyIndex][subStoryIndex].storyImage != '')
//               Expanded(
//                 child: Container(
//                   color: WeLinkColors.myColor,
//                   padding: const EdgeInsets.all(8.0),
//                   child: WeLinkNormalTexts(
//                     norText:
//                         'Caption: ${storyModel[storyIndex][subStoryIndex].storyText}',
//                   ),
//                 ),
//               ),
//             if (storyModel[storyIndex][subStoryIndex].storyText != '' &&
//                 storyModel[storyIndex][subStoryIndex].storyImage == '')
//               Expanded(
//                 child: Container(
//                   alignment: Alignment.center,
//                   decoration: const BoxDecoration(),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: WeLinkNormalTexts(
//                         norText:
//                             storyModel[storyIndex][subStoryIndex].storyText,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         Align(
//           alignment: Alignment.topLeft,
//           child: Container(
//             alignment: Alignment.center,
//             //color: Colors.red,
//             height: 70,
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: List.generate(
//                       storyModel[storyIndex].length,
//                       (index) => SizedBox(
//                         width: MediaQuery.of(context).size.width /
//                                 (storyModel[storyIndex].length) -
//                             5,
//                         child: const LinearProgressIndicator(
//                           value: .8,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 25,
//                         backgroundImage: NetworkImage(
//                             storyModel[storyIndex][subStoryIndex].profileImage),
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           WeLinkNormalTexts(
//                               norText:
//                                   storyModel[storyIndex][subStoryIndex].name),
//                           WeLinkHints(
//                             hint: storyDate,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       InkWell(
//                         onTap: () => Navigator.pop(context),
//                         child: const Icon(
//                           Icons.close,
//                           color: Colors.white,
//                           size: 25,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (stillStoryToLeft)
//           Align(
//             alignment: Alignment.centerLeft,
//             child: InkWell(
//               onTap: switchLeft,
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                     color: Colors.black26,
//                     border: Border.all(
//                       color: Colors.black, // Border color
//                       width: 1.0,
//                     )),
//                 child: const Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         if (stillStoryToRight)
//           Align(
//             alignment: Alignment.centerRight,
//             child: InkWell(
//               onTap: switchRight,
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                     color: Colors.black26,
//                     border: Border.all(
//                       color: Colors.black, // Border color
//                       width: 1.0,
//                     )),
//                 child: const Icon(
//                   Icons.arrow_forward_ios,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
