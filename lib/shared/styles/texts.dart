// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'fonts.dart';

class WeLinkHints extends StatelessWidget {
  WeLinkHints({
    Key? key,
    required this.hint,
    this.textAlign,
    this.color,
    this.fs,
    this.fw,
    this.maxLines,
  }) : super(key: key);

  final String hint;
  final TextAlign? textAlign;
  Color? color;
  double? fs;
  int? maxLines;
  FontWeight? fw;

  @override
  Widget build(BuildContext context) {
    return Text(
      hint,
      maxLines: maxLines,
      style:
          WeLinkTextStyles.weLinkHintMontserrat(fs: fs, color: color, fw: fw),
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}

class WeLinkHeadlines extends StatelessWidget {
  WeLinkHeadlines({
    Key? key,
    required this.headline,
    this.color,
    this.textAlign,
    this.fs,
    this.fw,
  }) : super(key: key);

  final String headline;
  final TextAlign? textAlign;
  Color? color;
  double? fs;
  FontWeight? fw;

  @override
  Widget build(BuildContext context) {
    return Text(
      headline,
      textAlign: textAlign ?? TextAlign.center,
      style: WeLinkTextStyles.weLinkHeadlines(color: color, fs: fs, fw: fw),
    );
  }
}

class WeLinkNormalTexts extends StatelessWidget {
  WeLinkNormalTexts({
    Key? key,
    required this.norText,
    this.color,
    this.textAlign,
    this.fs,
    this.fw,
  }) : super(key: key);

  final String norText;
  final TextAlign? textAlign;
  Color? color;
  double? fs;
  FontWeight? fw;

  @override
  Widget build(BuildContext context) {
    return Text(
      norText,
      textAlign: textAlign ?? TextAlign.center,
      style: WeLinkTextStyles.weLinkRegularMontserrat(
          fs: fs, fw: fw, color: color),
    );
  }
}

SizedBox weLinkSpacer({width, height}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height ?? 25.0,
  );
}
