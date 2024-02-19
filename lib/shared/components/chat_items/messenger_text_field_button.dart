import 'package:flutter/material.dart';
import 'package:we_link/models/login_model.dart';
import 'package:we_link/shared/styles/icons_broken.dart';

import '../../bloc/chat_cubit/chat_cubit.dart';
import '../../network/remote/http_services.dart';

class MessengerTextFieldButton extends StatelessWidget {
  const MessengerTextFieldButton({
    Key? key,
    required this.messageController,
    required this.cubit,
    required this.user,
  }) : super(key: key);

  final TextEditingController messageController;
  final ChatCubit cubit;
  final LoginModel user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black87),
              child: TextFormField(
                controller: messageController,
                maxLines: null,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) {
                              return SelectImage(cubit: cubit);
                            });
                      },
                      child: const Icon(
                        IconBroken.Image,
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'Type your message',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(20),
                      left: Radius.circular(20),
                    ))),
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.deepPurple,
                onFieldSubmitted: (v) {},
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: IconButton(
              onPressed: () {
                if (cubit.messageImageFile != null ||
                    messageController.text != '') {
                  if (cubit.messageImageFile != null) {
                    cubit.sendMessageWithImage(
                      receiverId: user.uId,
                      textMessage: messageController.text,
                      messageDateTime: DateTime.now().toLocal().toString(),
                      fromUser: cubit.user.name,
                      receiverFCMAPI: user.receiverFCMToken,
                    );
                    cubit.undoGetMessageImage();
                  } else {
                    cubit.senMessage(
                      receiverId: user.uId,
                      textMessage: messageController.text,
                      messageDateTime: DateTime.now().toLocal().toString(),
                      fromUser: cubit.user.name,
                      receiverFCMAPI: user.receiverFCMToken,
                    );
                  }
                  // HttpHelper.sendNotificationTo(
                  //   senderName: cubit.user.name,
                  //   receiverToken: user.receiverFCMToken,
                  //   messageBody: messageController.text,
                  //   loginModel: {
                  //     'name': user.name,
                  //     'phone': user.phone,
                  //     'email': user.email,
                  //     'bio': user.bio,
                  //     'profileImage': user.profileImage,
                  //     'profileCover': user.profileCover,
                  //     'uId': user.uId,
                  //     'receiverFCMToken': user.receiverFCMToken,
                  //   },
                  // );
                }
                messageController.clear();
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(
                IconBroken.Send,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

class SelectImage extends StatelessWidget {
  const SelectImage({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final ChatCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  cubit.getCameraMessageImage();
                },
                icon: const Icon(
                  IconBroken.Camera,
                  size: 35,
                  color: Colors.blue,
                ),
              ),
              const Text(
                'Camera',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  cubit.getGalleryMessageImage();
                },
                icon: const Icon(
                  IconBroken.Image_2,
                  size: 35,
                  color: Colors.deepPurple,
                ),
              ),
              const Text(
                'Gallery',
                style: TextStyle(
                    color: Colors.deepPurple),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
