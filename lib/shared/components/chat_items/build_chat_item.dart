import 'package:flutter/material.dart';

import '../../../models/login_model.dart';
import '../../../modules/chat/messenger_screen.dart';
import '../../styles/colors.dart';
import '../../styles/icons_broken.dart';
import '../components.dart';

class BuildChatItem extends StatelessWidget {
  const BuildChatItem({
    Key? key,
    required this.user,
    this.lastMessage,
  }) : super(key: key);

  final LoginModel user;

  final dynamic lastMessage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            MessengerScreen(
              user: user,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: WeLinkColors.myColor.withOpacity(.5),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            CircleAvatar(
              radius: 31,
              backgroundColor: Colors.deepPurple,
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(user.profileImage),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ///////////////////////////
                  // i will display here th last message
                  if (lastMessage == null)
                    const Text(
                      'be the first to say hello!',
                      style: TextStyle(
                        fontSize: 15,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  if (lastMessage != null)
                    Text(
                      lastMessage.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                IconBroken.More_Circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
