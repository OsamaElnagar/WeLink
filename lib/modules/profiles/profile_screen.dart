import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/modules/profiles/visited_profile_screen.dart';
import 'package:we_link/shared/bloc/AppCubit/cubit.dart';
import 'package:we_link/shared/bloc/AppCubit/states.dart';
import 'package:we_link/shared/components/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double bottomSheetHeight = 350;
  late Offset tapXY;
  RenderBox? overlay;

  //
  // @override
  // void initState() {
  //   AppCubit.get(context).getPosts();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return VisitedProfileScreen(
          userUid: uId!,
          showAppBar: false,
          personalProfile: true,
        );
      },
    );
  }

  // ↓ create the RelativeRect from size of screen and where you tapped
  RelativeRect get relRectSize =>
      RelativeRect.fromSize(tapXY & const Size(40, 40), overlay!.size);

  // ↓ get the tap position Offset
  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }
}
