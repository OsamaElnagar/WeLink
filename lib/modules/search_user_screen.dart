import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/modules/profiles/visited_profile_screen.dart';
import 'package:we_link/shared/bloc/chat_cubit/chat_cubit.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/styles/colors.dart';

import '../models/login_model.dart';
import '../shared/components/chat_items/build_chat_item.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);

  final bool showAppBar;

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {


  @override
  void initState() {
    ChatCubit cubit = ChatCubit.get(context);
    cubit.searchResultsStream = cubit.searchUsersByName('',showAll: true);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ChatCubit cubit = ChatCubit.get(context);
        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  title: const Text('Search on WeLink'),
                )
              : null,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  onChanged: (query) {
                    setState(() {
                      cubit.searchUsersByName(query,showAll: true);
                    });
                  },
                  hintText: 'Search by name',
                ),
              ),
              SearchResultsStream(
                searchResultsStream: cubit.searchResultsStream!,
                showAppBar: widget.showAppBar,
              ),
            ],
          ),
        );
      },
    );
  }
}

class SearchResultsStream extends StatelessWidget {
  const SearchResultsStream({
    Key? key,
    required Stream<List<LoginModel>> searchResultsStream,
    required this.showAppBar,
  })  : _searchResultsStream = searchResultsStream,
        super(key: key);

  final Stream<List<LoginModel>> _searchResultsStream;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<LoginModel>>(
        stream: _searchResultsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<LoginModel> users = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemBuilder: (context, index) {
                  LoginModel user = users[index];
                  if (!showAppBar) {
                    return BuildChatItem(
                      user: user,
                      // lastMessage: cubit.lastMessages[index],
                    );
                  }
                  return UserSearchResultItem(user: user);
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class UserSearchResultItem extends StatelessWidget {
  const UserSearchResultItem({Key? key, required this.user}) : super(key: key);

  final LoginModel user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => navigateTo(context, VisitedProfileScreen(userUid: user.uId)),
      child: Container(
        decoration: BoxDecoration(
          color: WeLinkColors.myColor.withOpacity(.5),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.profileImage),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  Text(
                    user.bio,
                    style: const TextStyle(
                      fontSize: 15,
                      //fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
