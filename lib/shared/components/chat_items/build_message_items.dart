import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:we_link/models/chat_model.dart';
import 'package:we_link/shared/components/image_bottom_sheet_viewer.dart';
import 'package:we_link/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageBuilder extends StatelessWidget {
  const MessageBuilder({
    Key? key,
    required this.alignmentDirectional,
    required this.radius,
    required this.color,
    required this.crossAxisAlignment,
    required this.doc,
    this.onVisibilityChanged,
    this.seenMark = false,
  }) : super(key: key);

  final DocumentSnapshot doc;
  final AlignmentDirectional alignmentDirectional;
  final BorderRadiusDirectional radius;
  final CrossAxisAlignment crossAxisAlignment;
  final Color color;
  final bool seenMark;
  final void Function(VisibilityInfo)? onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    ChatsModel message =
        ChatsModel.fromJson(doc.data() as Map<String, dynamic>);

    String messageDateTime = message.messageDateTime;
    messageDateTime =
        DateFormat.E().add_jm().format(DateTime.parse(messageDateTime));

    return VisibilityDetector(
      key: Key(message.messageId),
      onVisibilityChanged: onVisibilityChanged,
      child: Align(
        alignment: alignmentDirectional,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.textMessage != '' && message.imageMessage == '')
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: color, borderRadius: radius),
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 4.0, left: 4, right: 4),
                        child: Text(
                          message.textMessage,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MessageStatusIndicator(seenMark: seenMark, message: message),
                            Text(
                              messageDateTime.substring(3),
                              style: const TextStyle(
                                color: SoftareoColors.softareoRoyalBlue,
                                fontSize: 13,
                                height: .5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (message.textMessage == '' && message.imageMessage != '')
                Container(
                  padding: const EdgeInsets.all(2),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(5),
                      topEnd: Radius.circular(5),
                      topStart: Radius.circular(5),
                      bottomStart: Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      InkWell(
                        onTap: () =>
                            showImageSheetViewer(context, message.imageMessage),
                        child: ImageMessage(message: message, color: color),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 4, right: 4, left: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MessageStatusIndicator(seenMark: seenMark, message: message),
                            Text(
                              messageDateTime.substring(3),
                              style: const TextStyle(
                                color: SoftareoColors.softareoRoyalBlue,
                                fontSize: 13,
                                height: .5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (message.textMessage != '' && message.imageMessage != '')
                Container(
                  padding: const EdgeInsets.all(2),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: 244,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(5),
                      topEnd: Radius.circular(5),
                      topStart: Radius.circular(5),
                      bottomStart: Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      InkWell(
                          onTap: () => showImageSheetViewer(
                              context, message.imageMessage),
                          child: ImageMessage(message: message, color: color)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          message.textMessage,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MessageStatusIndicator(seenMark: seenMark, message: message),
                          Text(
                            messageDateTime.substring(3),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                color: SoftareoColors.softareoRoyalBlue,
                                fontSize: 13,
                                height: .5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageStatusIndicator extends StatelessWidget {
  const MessageStatusIndicator({
    Key? key,
    required this.seenMark,
    required this.message,
  }) : super(key: key);

  final bool seenMark;
  final ChatsModel message;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (seenMark && !message.seen) {
        return const Icon(
          Icons.check_circle_outline_rounded,
          size: 18,
          //color: Colors.grey,
        );
      } else if (seenMark && message.seen) {
        return const Icon(
          Icons.check_circle,
          size: 18,
          color: Colors.blue,
        );
      }
      return const SizedBox();
    });
  }
}

class ImageMessage extends StatelessWidget {
  final ChatsModel message;
  final Color color;

  const ImageMessage({Key? key, required this.message, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(5),
            topEnd: Radius.circular(5),
            topStart: Radius.circular(5),
            bottomStart: Radius.circular(5),
          )),
      child: CachedNetworkImage(
        imageUrl: message.imageMessage,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
