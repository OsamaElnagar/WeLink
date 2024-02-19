// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../styles/texts.dart';
import 'auth_banner.dart';

class AuthBottomBar extends StatelessWidget {
  AuthBottomBar({
    Key? key,
    required this.question,
    required this.decision,
    this.onPressed,
  }) : super(key: key);

  final String question;
  final String decision;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AuthDecoratedContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            WeLinkNormalTexts(
              norText: question,
              fs: 15.0,
            ),
            TextButton(
              onPressed: onPressed,
              child: WeLinkNormalTexts(
                norText: decision,
                color: Colors.blue,
                fs: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
