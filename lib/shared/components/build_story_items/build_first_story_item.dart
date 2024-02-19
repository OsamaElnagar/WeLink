import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'package:we_link/models/login_model.dart';

import 'package:we_link/modules/story/story_screen.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/styles/icons_broken.dart';

class BuildFirstStoryItem extends StatelessWidget {
  const BuildFirstStoryItem({Key? key, required this.loginModel})
      : super(key: key);

  final LoginModel loginModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ConditionalBuilder(
          condition: loginModel.profileImage.isNotEmpty,
          builder: (context) => Container(
            height: 150,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(loginModel.profileImage),
                  fit: BoxFit.cover),
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.black.withOpacity(.5),
          child: GestureDetector(
            onTap: () {
              navigateTo(context, const NewStoryScreen());
            },
            child: const Icon(
              IconBroken.Paper_Plus,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
}
