import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_link/modules/chat/messenger_screen.dart';
import 'package:we_link/shared/bloc/AppCubit/cubit.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/components/profile_items/profile_banner_and_name.dart';
import 'package:we_link/shared/bloc/visit_profile_cubit/visit_profile_cubit.dart';
import 'package:we_link/shared/components/lottie_animations/lottie_builder.dart';

import '../../shared/components/lottie_animations/lottie_assets_names.dart';
import '../../shared/components/post_items/build_post_item.dart';
import '../../shared/components/profile_items/visited_user_actions.dart';
import '../../shared/styles/colors.dart';

class VisitedProfileScreen extends StatelessWidget {
  final String userUid;
  final bool showAppBar;
  final bool personalProfile;

  const VisitedProfileScreen({
    Key? key,
    required this.userUid,
    this.showAppBar = true,
    this.personalProfile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VisitProfileCubit()
        ..searchForUser(userUid: userUid)
        ..getVisitedUserPosts(userUid: userUid),
      child: BlocConsumer<VisitProfileCubit, VisitProfileStates>(
        listener: (context, state) {
          if (state is SearchForUserLoadingState) {}
        },
        builder: (context, state) {
          var cubit = VisitProfileCubit.get(context);

          return RefreshIndicator(
            color: Colors.deepPurple,
            onRefresh: () {
              return Future.delayed(
                const Duration(milliseconds: 1800),
                () {
                  cubit.getVisitedUserPosts(userUid: userUid);
                },
              );
            },
            child: Scaffold(
              appBar: showAppBar
                  ? AppBar(
                      title: Text(
                        '${cubit.user?.name}\'s profile',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    )
                  : null,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          ProfileBannerAndName(user: cubit.user!),
                          Builder(
                            builder: (context) {
                              if (!personalProfile) {
                                return VisitedUserActions(
                                  actions: [
                                    VisitedUserAction(
                                      onTap: () {},
                                      title: 'Add Friend',
                                      color: WeLinkColors.myColor,
                                    ),
                                    VisitedUserAction(
                                      onTap: () {},
                                      title: 'Follow',
                                      color: Colors.blue,
                                    ),
                                    VisitedUserAction(
                                      onTap: () => cubit.user != null
                                          ?navigateTo(context,
                                          MessengerScreen(user: cubit.user!)):null,
                                      title: 'Chat',
                                      color: Colors.green,
                                    ),
                                  ],
                                );
                              } else {
                                return VisitedUserActions(
                                  actions: [
                                    VisitedUserAction(
                                      onTap: () {},
                                      title: 'Add Friend',
                                      color: WeLinkColors.myColor,
                                      ignoring: true,
                                    ),
                                    VisitedUserAction(
                                      onTap: () {},
                                      title: 'Follow',
                                      color: Colors.blue,
                                      ignoring: true,
                                    ),
                                    VisitedUserAction(
                                      onTap: () => cubit.user != null
                                          ? navigateTo(
                                              context,
                                              MessengerScreen(
                                                  user: cubit.user!))
                                          : null,
                                      title: 'Chat',
                                      color: Colors.green,
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Posts',
                              style: GoogleFonts.alef(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ConditionalBuilder(
                            condition: cubit.visitedUserPosts.isNotEmpty,
                            builder: (context) => ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => BuildPostItem(
                                postModel: cubit.visitedUserPosts[index],
                                canOpenPersonalProfile: false,
                                moreVert: Container(),
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: cubit.visitedUserPosts.length,
                            ),
                            fallback: (context) => Column(
                              children: [
                                const AssetLotties(asset: userHasNoPosts),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'It seems like ${cubit.user?.name} does not have any posts.',
                                    style: GoogleFonts.allertaStencil(
                                        color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              floatingActionButton: personalProfile
                  ? FloatingActionButton.extended(
                      label: const Text(
                        'Sign out',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                'Are you sure you want to sign out?'),
                            actions: [
                              OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('NO'),
                              ),
                              OutlinedButton(
                                onPressed: () => AppCubit.get(context).signOut(context),
                                child: const Text('Sign out'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),

                      //shape: const CircleBorder(),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
