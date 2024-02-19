import 'dart:math';

import 'package:flutter/material.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/components/constants.dart';

import '../../modules/profiles/edit_profile_screen.dart';
import '../../modules/post/post_screen.dart';
import '../../modules/story/story_screen.dart';
import '../styles/colors.dart';
import '../styles/icons_broken.dart';


// This Classes need some enhancing.

const Duration upperDuration =  Duration(milliseconds: 700);
const Duration lowerDuration =  Duration(milliseconds: 400);

class AnimatedFeedsFAB extends StatefulWidget {
  const AnimatedFeedsFAB({Key? key}) : super(key: key);

  @override
  State<AnimatedFeedsFAB> createState() => _AnimatedFeedsFABState();
}

class _AnimatedFeedsFABState extends State<AnimatedFeedsFAB>
    with SingleTickerProviderStateMixin {
  bool toggle = true;
  late AnimationController _controller;
  late Animation<double> _animation;
  double labelSize = 26.0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final containerKey = UniqueKey();

  Alignment alignment1 = const Alignment(0.5, 0.8);
  Alignment alignment2 = const Alignment(0.5, 0.8);
  Alignment alignment3 = const Alignment(0.5, 0.8);
  Alignment alignmentT1 = const Alignment(0.48, 0.8);
  Alignment alignmentT2 = const Alignment(0.48, 0.8);
  Alignment alignmentT3 = const Alignment(0.48, 0.8);

  double size = 50.0;
  double sizeM = 60.0;
  double sizeC = 60.0;
  double sizeD = 60.0;

  void collapseFAB() {
    setState(() {
      if (toggle) {
        toggle = !toggle;
        _controller.forward();
        sizeM = 80;
        sizeD = 80;
        sizeC = 80;
        size = 50;
        //1
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignment1 = const Alignment(0.5, -1.0);
          },
        );
        //2
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignment2 = const Alignment(0.5, -0.35);
          },
        );
        //3
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignment3 = const Alignment(0.5, 0.3);
          },
        );

        //t1
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignmentT1 = const Alignment(-0.4, -0.82);
          },
        );
        //t2
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignmentT2 = const Alignment(-0.12, -0.15);
          },
        );
        //t3
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignmentT3 = const Alignment(0.08, 0.5);
          },
        );
      } else {
        toggle = !toggle;
        _controller.reverse();
        sizeM = 40;
        sizeC = 40;
        sizeD = 40;
        size = 40;
        alignment1 = alignment2 = alignment3 = const Alignment(0.5, 0.8);
        alignmentT1 = alignmentT2 = alignmentT3 = const Alignment(0.48, 0.8);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(1.2, 1),
      child: SizedBox(
        height: 230.0,
        width: 190.0,
        child: Stack(
          children: [
            //t1
            AnimatedAlign(
              alignment: alignmentT1,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: sizeM,
                decoration: const BoxDecoration(),
                child: Text(
                  'New Post',
                  style: labelStyle(),
                ),
              ),
            ),
            //1
            AnimatedAlign(
              alignment: alignment1,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: WeLinkColors.subButton,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: IconButton(
                    onPressed: () {
                      navigateTo(context, const NewPostScreen());
                      collapseFAB();
                    },
                    icon: const Icon(
                      IconBroken.Upload,
                      color: Colors.white,
                    )),
              ),
            ),
            //t2
            AnimatedAlign(
              alignment: alignmentT2,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: sizeC,
                decoration: const BoxDecoration(),
                child:  Text('Camera',
                  style: labelStyle(),),
              ),
            ),
            //2
            AnimatedAlign(
              alignment: alignment2,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: WeLinkColors.subButton,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: IconButton(
                    onPressed: () {
                      collapseFAB();
                    },
                    icon: const Icon(
                      IconBroken.Camera,
                      color: Colors.white,
                    )),
              ),
            ),
            //t3
            AnimatedAlign(
              alignment: alignmentT3,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: sizeD,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child:  Text('Status',
                  style: labelStyle(),),
              ),
            ),
            //3
            AnimatedAlign(
              alignment: alignment3,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: WeLinkColors.subButton,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: IconButton(
                    onPressed: () {
                      navigateTo(context, const NewStoryScreen());
                      collapseFAB();
                    },
                    icon: const Icon(
                      IconBroken.Document,
                      color: Colors.white,
                    )),
              ),
            ),
            //mainButton
            Align(
              alignment: const Alignment(0.5, 0.9),
              child: Transform.rotate(
                angle: _animation.value * pi * (3 / 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: toggle ? 70.0 : 50.0,
                  width: toggle ? 70.0 : 50.0,
                  decoration: BoxDecoration(
                    color: WeLinkColors.myColor,
                    borderRadius: BorderRadius.circular(60.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,  // Shadow color
                        offset: Offset(0, 2), // Offset of the shadow (horizontal, vertical)
                        blurRadius: 2,       // Blur radius
                        spreadRadius: 0,     // Spread radius
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        collapseFAB();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedChatsFAB extends StatefulWidget {
  const AnimatedChatsFAB({Key? key}) : super(key: key);

  @override
  State<AnimatedChatsFAB> createState() => _AnimatedChatsFABState();
}

class _AnimatedChatsFABState extends State<AnimatedChatsFAB>
    with SingleTickerProviderStateMixin {
  bool toggle = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  Alignment alignment1 = const Alignment(0.5, 0.8);
  Alignment alignment2 = const Alignment(0.5, 0.8);
  Alignment alignment3 = const Alignment(0.5, 0.8);
  Alignment alignmentT1 = const Alignment(0.48, 0.8);
  Alignment alignmentT2 = const Alignment(0.48, 0.8);
  Alignment alignmentT3 = const Alignment(0.48, 0.8);

//const Alignment(1.07,1.01),

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final containerKey = UniqueKey();

  double size = 50.0;
  double sizeM = 60.0;
  double sizeC = 60.0;
  double sizeD = 60.0;

  // double size3 = 50.0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void collapseFAB() {
    setState(() {
      if (toggle) {
        toggle = !toggle;
        _controller.forward();
        sizeM = 80;
        sizeD = 80;
        sizeC = 80;
        size = 50;
        //1
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignment1 = const Alignment(0.5, -1.0);
          },
        );
        //2
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignment2 = const Alignment(0.5, -0.35);
          },
        );
        //3
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignment3 = const Alignment(0.5, 0.3);
          },
        );

        //t1
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignmentT1 = const Alignment(-0.4, -0.82);
          },
        );
        //t2
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignmentT2 = const Alignment(-0.12, -0.15);
          },
        );
        //t3
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignmentT3 = const Alignment(0.08, 0.5);
          },
        );
      } else {
        toggle = !toggle;
        _controller.reverse();
        sizeM = 40;
        sizeC = 40;
        sizeD = 40;
        size = 40;
        alignment1 = alignment2 = alignment3 = const Alignment(0.5, 0.8);
        alignmentT1 = alignmentT2 = alignmentT3 = const Alignment(0.48, 0.8);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(1.2, 1),
      child: SizedBox(
        height: 230.0,
        width: 190.0,
        child: Stack(
          children: [
            //t1
            AnimatedAlign(
              alignment: alignmentT1,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: sizeM,
                decoration: const BoxDecoration(),
                child:  Text('New Chat',
                  style: labelStyle(),),
              ),
            ),
            //1
            AnimatedAlign(
              alignment: alignment1,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: WeLinkColors.subButton,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: IconButton(
                    onPressed: () {
                      collapseFAB();
                    },
                    icon: const Icon(
                      IconBroken.Chat,
                      color: Colors.white,
                    )),
              ),
            ),
            //t2
            AnimatedAlign(
              alignment: alignmentT2,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: sizeC,
                decoration: const BoxDecoration(),
                child:  Text('New\nGroup',
                  style: labelStyle(),),
              ),
            ),
            //2
            AnimatedAlign(
              alignment: alignment2,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: WeLinkColors.subButton,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: IconButton(
                    onPressed: () {
                      collapseFAB();
                    },
                    icon: const Icon(
                      IconBroken.Category,
                      color: Colors.white,
                    )),
              ),
            ),
            //t3
            AnimatedAlign(
              alignment: alignmentT3,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: sizeD,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child:  Text('Call',
                  style: labelStyle(),),
              ),
            ),
            //3
            AnimatedAlign(
              alignment: alignment3,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: WeLinkColors.subButton,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: IconButton(
                    onPressed: () {
                      collapseFAB();
                    },
                    icon: const Icon(
                      IconBroken.Call,
                      color: Colors.white,
                    )),
              ),
            ),
            //mainButton
            Align(
              alignment: const Alignment(0.5, 0.9),
              child: Transform.rotate(
                angle: _animation.value * pi * (3 / 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: toggle ? 70.0 : 50.0,
                  width: toggle ? 70.0 : 50.0,
                  decoration: BoxDecoration(
                    color: WeLinkColors.myColor,
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        collapseFAB();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedProfileFAB extends StatefulWidget {
  const AnimatedProfileFAB({Key? key}) : super(key: key);

  @override
  State<AnimatedProfileFAB> createState() => _AnimatedProfileFABState();
}

class _AnimatedProfileFABState extends State<AnimatedProfileFAB>
    with SingleTickerProviderStateMixin {
  bool toggle = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  Alignment alignment1 = const Alignment(0.5, 0.8);
  Alignment alignment2 = const Alignment(0.5, 0.8);
  Alignment alignment3 = const Alignment(0.5, 0.8);
  Alignment alignmentT1 = const Alignment(0.48, 0.8);
  Alignment alignmentT2 = const Alignment(0.48, 0.8);
  Alignment alignmentT3 = const Alignment(0.48, 0.8);

//const Alignment(1.07,1.01),

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final containerKey = UniqueKey();

  double size = 50.0;
  double sizeM = 60.0;
  double sizeC = 60.0;
  double sizeD = 60.0;

  // double size3 = 50.0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void collapseFAB() {
    setState(() {
      if (toggle) {
        toggle = !toggle;
        _controller.forward();
        sizeM = 80;
        sizeD = 80;
        sizeC = 80;
        size = 50;
        //1
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignment1 = const Alignment(0.5, -1.0);
          },
        );
        //2
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignment2 = const Alignment(0.5, -0.35);
          },
        );
        //3
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignment3 = const Alignment(0.5, 0.3);
          },
        );

        //t1
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignmentT1 = const Alignment(-0.4, -0.82);
          },
        );
        //t2
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignmentT2 = const Alignment(-0.12, -0.15);
          },
        );
        //t3
        Future.delayed(
          const Duration(milliseconds: 10),
          () {
            alignmentT3 = const Alignment(0.08, 0.5);
          },
        );
      } else {
        toggle = !toggle;
        _controller.reverse();
        sizeM = 40;
        sizeC = 40;
        sizeD = 40;
        size = 40;
        alignment1 = alignment2 = alignment3 = const Alignment(0.5, 0.8);
        alignmentT1 = alignmentT2 = alignmentT3 = const Alignment(0.48, 0.8);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(1.2, 1),
      child: SizedBox(
        height: 230.0,
        width: 190.0,
        child: Stack(
          children: [
            //t1
            AnimatedAlign(
              alignment: alignmentT1,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: sizeM,
                decoration: const BoxDecoration(),
                child:  Text('New Post',
                  style: labelStyle(),),
              ),
            ),
            //1
            AnimatedAlign(
              alignment: alignment1,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: WeLinkColors.subButton,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: IconButton(
                    onPressed: () {
                      navigateTo(context, const NewPostScreen());
                      collapseFAB();
                    },
                    icon: const Icon(
                      IconBroken.Upload,
                      color: Colors.white,
                    )),
              ),
            ),
            //t2
            AnimatedAlign(
              alignment: alignmentT2,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: sizeC,
                decoration: const BoxDecoration(),
                child:  Text('Update\nProfile',
                  style: labelStyle(),),
              ),
            ),
            //2
            AnimatedAlign(
              alignment: alignment2,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: WeLinkColors.subButton,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: IconButton(
                    onPressed: () {
                      navigateTo(context, const EditProfileScreen());
                      collapseFAB();
                    },
                    icon: const Icon(
                      IconBroken.Profile,
                      color: Colors.white,
                    )),
              ),
            ),
            //t3
            AnimatedAlign(
              alignment: alignmentT3,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: sizeD,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child:  Text('Status ',
                  style: labelStyle(),),
              ),
            ),
            //3
            AnimatedAlign(
              alignment: alignment3,
              duration: toggle
                  ? upperDuration
                  : lowerDuration,
              curve: toggle ? Curves.easeIn : Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: toggle ? Curves.easeIn : Curves.easeOut,
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: WeLinkColors.subButton,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: IconButton(
                    onPressed: () {
                      collapseFAB();
                      navigateTo(context, const NewStoryScreen());
                    },
                    icon: const Icon(
                      IconBroken.Document,
                      color: Colors.white,
                    )),
              ),
            ),
            //mainButton
            Align(
              alignment: const Alignment(0.5, 0.9),
              child: Transform.rotate(
                angle: _animation.value * pi * (3 / 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: toggle ? 70.0 : 50.0,
                  width: toggle ? 70.0 : 50.0,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        collapseFAB();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
