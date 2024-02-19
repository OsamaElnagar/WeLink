
import 'package:flutter/material.dart';

class VisitedUserAction {
  void Function()? onTap;
  String title = '';
  Color? color;
  bool ignoring;

  VisitedUserAction({
    required this.onTap,
    required this.title,
    required this.color,
    this.ignoring = false,
  });
}

class VisitedUserActions extends StatelessWidget {
  const VisitedUserActions({
    Key? key,
    required this.actions,
  }) : super(key: key);

  final List<VisitedUserAction> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions
          .map(
            (action) => IgnorePointer(
          ignoring: action.ignoring,
          child: OutlinedButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all(BorderSide.none),
              backgroundColor: action.ignoring
                  ? MaterialStateProperty.all(Colors.grey)
                  : MaterialStateProperty.all(action.color),
            ),
            onPressed: action.onTap,
            child: Text(
              action.title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}