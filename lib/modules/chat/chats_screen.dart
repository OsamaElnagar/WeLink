import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/models/login_model.dart';
import 'package:we_link/modules/search_user_screen.dart';
import 'package:we_link/shared/bloc/chat_cubit/chat_cubit.dart';
import 'package:we_link/shared/components/chat_items/build_chat_item.dart';
import 'package:we_link/shared/styles/colors.dart';


class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {


  @override
  void initState() {
    ChatCubit cubit = ChatCubit.get(context);
    cubit.getChatsByUser();
    cubit.searchResultsStream = cubit.searchUsersByName('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ChatCubit cubit = ChatCubit.get(context);
        return Column(
          children: [
            ChatsList(cubit:cubit),
            //const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: WeLinkColors.myColor.shade100,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text(
                'People on WeLink',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
            SearchResultsStream(
              searchResultsStream: cubit.searchResultsStream!,
              showAppBar: false,
            ),
          ],
        );
      },
    );
  }
}

class ChatsList extends StatelessWidget {
  const ChatsList({Key? key, required this.cubit}) : super(key: key);

  final ChatCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cubit.chats.length,
      separatorBuilder: (context, index) => const SizedBox(height: 5),
      itemBuilder: (context, index) {
        LoginModel user = cubit.chats[index];
        return BuildChatItem(user: user);
      },
    );
  }
}
