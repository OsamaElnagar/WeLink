import 'package:flutter/cupertino.dart';

class WeLinkPaddings {
  static weLinkAuthPadding({l, r, t, b, child}) {
    return Padding(
      padding: EdgeInsets.only(
        left: l ?? 10,
        right: r ?? 10,
        top: t ?? 20,
        bottom: b ?? 20,
      ),
      child: child,
    );
  }
}
