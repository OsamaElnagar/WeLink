import 'package:flutter/material.dart';
import '../../styles/paddings.dart';
import '../../styles/texts.dart';
import '../components.dart';

class WeLinkAuthBanner extends StatelessWidget {
  const WeLinkAuthBanner({
    Key? key,
    required this.headline,
    required this.tour,
    this.height,
  }) : super(key: key);

  final String headline;
  final String tour;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AuthDecoratedContainer(
      child: WeLinkPaddings.weLinkAuthPadding(
        t: 50.0,
        b: 50.0,
        child: Column(
          children: [
            WeLinkHeadlines(headline: headline),
            const WeLinkSpacer(),
            WeLinkNormalTexts(norText: tour)
          ],
        ),
      ),
    );
  }
}

class AuthDecoratedContainer extends StatelessWidget {
  const AuthDecoratedContainer({
    Key? key,
    required this.child,
    this.height,
  }) : super(key: key);

  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white.withOpacity(.1),
        ),
        child: child);
  }
}
