import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_link/shared/styles/texts.dart';

import '../../models/boarding_model.dart';
import '../styles/colors.dart';

class OnBoardingBuilder extends StatelessWidget {
  const OnBoardingBuilder({Key? key, required this.boardingModel})
      : super(key: key);

  final BoardingModel boardingModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FadeInDown(
            animate: true,
            duration: const Duration(seconds: 1),
            child: SvgPicture.asset(
               boardingModel.image,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        FadeInRight(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: WeLinkHeadlines(
                headline: boardingModel.title,
                color: WeLinkColors.myColor,
              )),
        ),
        const SizedBox(
          height: 10,
        ),
        FadeInUp(

          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: WeLinkHints(
                hint: boardingModel.body,
              )),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
