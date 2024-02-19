import 'package:flutter/material.dart';
import 'package:we_link/shared/styles/colors.dart';

bool? lastPage = false;
String? uId;
var fcmToken;
var postIndex;
var commentIndex;

var storyIndex;

String newUserProfileImageLink =
    'https://firebasestorage.googleapis.com/v0/b/social-app-201c9.appspot.com/o/newUserProfileImage.png?alt=media&token=ffae77f4-3a8f-4947-9c92-9b78a5f94222';
String newUserCoverImageLink =
    'https://firebasestorage.googleapis.com/v0/b/social-app-201c9.appspot.com/o/newUserCoverImage.png?alt=media&token=4f00e83a-629b-4b27-abb5-73a1ec54d4ab';
bool wannaSearchForUser = false;
FocusNode modifyPostTextNode = FocusNode();
FocusNode searchUserNode = FocusNode();

class MediaSource {
  static String camera = 'Camera';
  static String gallery = 'gallery';
}

TextStyle labelStyle() {
  return const TextStyle(
      fontSize: 15, fontWeight: FontWeight.w600, color: WeLinkColors.myColor);
}

// void printFullText(String text) {
//   final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
//   pattern.allMatches(text).forEach((match) => pint(match.group(0)));
// }
