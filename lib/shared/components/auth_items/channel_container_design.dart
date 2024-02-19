import 'package:flutter/material.dart';

class ChannelContainer extends StatelessWidget {
  const ChannelContainer({
    Key? key, this.height,
  }) : super(key: key);

  final double?height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      width: 60,
      height: height ?? 20,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.55),
      ),
    );
  }
}
