import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:we_link/modules/auth/login_screen.dart';
import 'package:we_link/shared/styles/texts.dart';
import '../network/local/cache_helper.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Future navigate2(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

class WeLinkSpacer extends StatelessWidget {
  const WeLinkSpacer({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 25.0,
    );
  }
}

void unFocusNodes(List<FocusNode> nodes) {
  for (var node in nodes) {
    node.unfocus();
  }
}

void showToast({
  required String msg,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 12.0);
}

enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.warning:
      color = Colors.yellow;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
  }
  return color;
}

void signOut(context) {
  CacheHelper.removeData(key: 'uId').then((value) {
    if (value) {
      navigate2(context, const LoginScreen());
    }
  });
}

void clearPref(context) {
  CacheHelper.clearData().then((value) {
    // if (value) {
    //   navigate2(context, const OnBoarding());
    // }
  });
}

void printFulltext(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((element) {
    debugPrint(element.group(0));
  });
}

void pint(text) {
  debugPrint(text.toString());
}

void dialogMessage({
  required BuildContext context,
  required Widget title,
  required Widget content,
  required List<Widget> actions,
}) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: title,
            content: content,
            actions: actions,
          ));
}

Widget gradientButton({
  required BuildContext context,
  Function()? onPressed,
  required String title,
}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    width: 190,
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.redAccent[700]!,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )),
    child: MaterialButton(
      onPressed: onPressed,
      child: WeLinkHeadlines(headline: title, fs: 22),
    ),
  );
}

String generateShortUuid() {
  String standardUuid = const Uuid().v4();
  String shortUuid = standardUuid.substring(0, 20);
  return shortUuid;
}
