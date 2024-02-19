import 'package:flutter/material.dart';

class GestureItem extends StatelessWidget {
  const GestureItem({
    Key? key,
    required this.onTap,
    required this.iconColor,
    this.icon,
  }) : super(key: key);

  final Function() onTap;
  final Color iconColor;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(.7),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          color: iconColor,
          size: 40,
        ),
      ),
    );
  }
}
