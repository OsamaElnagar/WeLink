// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/models/chat_model.dart';
import 'package:we_link/models/login_model.dart';
import 'package:we_link/shared/components/chat_items/messenger_text_field_button.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/components/constants.dart';
import 'package:we_link/shared/styles/icons_broken.dart';

import '../../shared/bloc/chat_cubit/chat_cubit.dart';
import '../../shared/components/chat_items/build_message_items.dart';
import '../../shared/styles/colors.dart';

class MessengerScreen extends StatefulWidget {
  LoginModel user;

  MessengerScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          var cubit = ChatCubit.get(context);

          if (state is ChatSendMessageSuccessState) {
            cubit.playSendMessageSound();
          }
        },
        builder: (context, state) {
          var cubit = ChatCubit.get(context);

          if (cubit.user.uId != uId) {
            cubit.initUser();
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: messengerAppBar(context),
            body: Container(
              color: WeLinkColors.myColor.withOpacity(.5),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream:
                              cubit.getMessages(receiverId: widget.user.uId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('error ');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('loading...');
                            }
                            return ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: snapshot.data!.docs.map(
                                (doc) {
                                  if (cubit.user.uId == doc['senderId']) {
                                    return MessageBuilder(
                                      seenMark: true,
                                      doc: doc,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      alignmentDirectional:
                                          AlignmentDirectional.topEnd,
                                      radius:
                                          const BorderRadiusDirectional.only(
                                        bottomEnd: Radius.circular(15),
                                        topEnd: Radius.circular(0),
                                        topStart: Radius.circular(10),
                                        bottomStart: Radius.circular(0),
                                      ),
                                      color: SoftareoColors.softareoOrange,
                                    );
                                  }
                                  return MessageBuilder(
                                    onVisibilityChanged: (info) {
                                      if (info.visibleFraction > .1) {
                                        ChatsModel message =
                                            ChatsModel.fromJson(doc.data());
                                        if (!message.seen) {
                                          List<String> ids = [
                                            cubit.user.uId,
                                            widget.user.uId
                                          ];
                                          ids.sort();
                                          String chatRoomId = ids.join('_');

                                          cubit.setMessageAsSeen(
                                            messageId: message.messageId,
                                            receiverId: message.receiverId,
                                            chatRoomId: chatRoomId,
                                          );
                                        }
                                      }
                                    },
                                    doc: doc,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    alignmentDirectional:
                                        AlignmentDirectional.topStart,
                                    radius: const BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(0),
                                      topEnd: Radius.circular(10),
                                      topStart: Radius.circular(0),
                                      bottomStart: Radius.circular(15),
                                    ),
                                    color: SoftareoColors.softareoCerise,
                                  );
                                },
                              ).toList(),
                            );
                          }),
                    ),
                  ),
                  const SizedBox(height: 80),
                  if (cubit.messageImageFile != null)
                    DisplaySelectedImage(cubit: cubit),
                  if (cubit.messageImageFile != null)
                    const SizedBox(height: 120),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: MessengerTextFieldButton(
              messageController: messageController,
              cubit: cubit,
              user: widget.user,
            ),
          );
        },
      );
    });
  }

  AppBar messengerAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: WeLinkColors.myColor,
      leadingWidth: 36,
      title: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(widget.user.profileImage),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name,
                  style: const TextStyle(fontSize: 16.0),
                  overflow: TextOverflow.ellipsis),
              Text(uId == widget.user.uId ? 'message your self..' : '',
                  style: const TextStyle(fontSize: 10.0, color: Colors.grey),
                  overflow: TextOverflow.ellipsis),
            ],
          )),
        ],
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          IconBroken.Arrow___Left_2,
          size: 30,
        ),
      ),
      actions: uId != widget.user.uId
          ? [
              IconButton(onPressed: () {}, icon: const Icon(IconBroken.Call)),
              IconButton(
                  onPressed: () async {
                    var receiverFCMToken =
                        await FirebaseMessaging.instance.getToken();
                    pint(receiverFCMToken.toString());
                  },
                  icon: const Icon(IconBroken.Video)),
            ]
          : [],
    );
  }
}

class DisplaySelectedImage extends StatelessWidget {
  const DisplaySelectedImage({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final ChatCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
            width: 280,
            height: 350,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image(
              image: FileImage(cubit.messageImageFile!),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
                radius: 20,
                child: IconButton(
                    onPressed: () {
                      cubit.undoGetMessageImage();
                    },
                    icon: const Icon(Icons.close))),
          ),
        ],
      ),
    );
  }
}

/*
shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                ChatsModel message = ChatsModel.fromJson(messages[index]);
                                if (cubit.user.uId == message.senderId) {
                                  return MessageBuilder(
                                      chatsModel: message,
                                      doc: message,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      alignmentDirectional:
                                          AlignmentDirectional.topEnd,
                                      radius:
                                          const BorderRadiusDirectional.only(
                                        bottomEnd: Radius.circular(15),
                                        topEnd: Radius.circular(0),
                                        topStart: Radius.circular(10),
                                        bottomStart: Radius.circular(0),
                                      ),
                                      color: SoftareoColors.softareoOrange);
                                }
                                return MessageBuilder(
                                    chatsModel: message,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    alignmentDirectional:
                                        AlignmentDirectional.topStart,
                                    radius: const BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(0),
                                      topEnd: Radius.circular(10),
                                      topStart: Radius.circular(0),
                                      bottomStart: Radius.circular(15),
                                    ),
                                    color: SoftareoColors.softareoCerise);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 5,
                                );
                              },
                              itemCount: messages.length,
 */
