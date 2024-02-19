import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Backgrounds {
  static Widget authBackground() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15,sigmaY: 15),
      child : const Image(
        image: AssetImage('assets/images/f.jpg'),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
