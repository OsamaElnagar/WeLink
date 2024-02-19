import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/models/post_model.dart';
import 'package:we_link/shared/bloc/AppCubit/cubit.dart';
import 'package:we_link/shared/bloc/AppCubit/states.dart';
import 'package:we_link/shared/bloc/story_cubit/story_cubit.dart';
import 'package:we_link/shared/components/build_story_items/buildStoryItem.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/components/constants.dart';
import 'package:we_link/shared/components/post_items/build_post_item.dart';
import 'package:we_link/shared/components/post_items/feeds_stream_list.dart';
import 'package:we_link/shared/styles/colors.dart';

import '../../models/story_model.dart';
import '../../shared/components/build_story_items/build_first_story_item.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final ScrollController _scrollController = ScrollController();
  late Offset tapXY;
  RenderBox? overlay;

  RelativeRect get relRectSize =>
      RelativeRect.fromSize(tapXY & const Size(40, 40), overlay!.size);

  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<StoryCubit, StoryStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            var storyCubit = StoryCubit.get(context);
            return RefreshIndicator(
              color: Colors.deepPurple,
              onRefresh: () {
                return Future.delayed(
                  const Duration(milliseconds: 1800),
                  () {
                    storyCubit.getStories();
                  },
                );
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Stories for today',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: WeLinkColors.myColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 152,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConditionalBuilder(
                                condition: cubit.loginModel != null,
                                builder: (context) => BuildFirstStoryItem(
                                    loginModel: cubit.loginModel!),
                                fallback: (context) => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              ConditionalBuilder(
                                condition: storyCubit.bigStories.isNotEmpty,
                                builder: (context) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    reverse: false,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      storyIndex = index;

                                      if (storyCubit
                                          .bigStories[index].isNotEmpty) {
                                        List<StoryModel> stories =
                                            storyCubit.bigStories[index];
                                        return StoryItems(
                                          stories: stories,
                                          index: index,
                                        );
                                      }
                                      return null;
                                    },
                                    itemCount: storyCubit.bigStories.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      width: 2,
                                    ),
                                  );
                                },
                                fallback: (context) => const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => pint(uId),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'WeLink Timeline',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: WeLinkColors.myColor,
                          ),
                        ),
                      ),
                    ),
                    FirestorePagination(
                      shrinkWrap: true,
                      limit: 5,
                      isLive: true,
                      query: FirebaseFirestore.instance
                          .collection('posts')
                          .orderBy('postDate', descending: true),
                      itemBuilder: (context, documentSnapshot, index) {
                        final data =
                            documentSnapshot.data() as Map<String, dynamic>?;
                        PostModel post = PostModel.fromJson(data!);
                        return BuildPostItem(
                            postModel: post, moreVert: const Center());
                      },
                    ),
                    //FeedsStreamList(scrollController: _scrollController),
                    /*
                    ConditionalBuilder(
                      condition: AppCubit.get(context).feedPosts.isNotEmpty,
                      builder: (context) => ListView.separated(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        reverse: false,
                        itemBuilder: (context, index) {
                          return BuildPostItem(
                            postModel: cubit.feedPosts[index],
                            moreVert: InkWell(
                              onTapDown: getPosition,
                              onTap: () {
                                showMenu(
                                  context: context,
                                  position: relRectSize,
                                  items: [
                                    popupDo(
                                        onPress: () {}, childLabel: 'Follow'),
                                    popupDo(
                                        onPress: () {},
                                        childLabel: 'Hide post'),
                                    popupDo(
                                        onPress: () {},
                                        childLabel: 'Show more'),
                                    popupDo(
                                        onPress: () {},
                                        childLabel: 'Show less'),
                                  ],
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.more_vert,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: AppCubit.get(context).feedPosts.length,
                      ),
                      fallback: (context) => const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            AssetLotties(asset: userHasNoPosts),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'No posts here yet!? be the first to post in this app.',
                                style: TextStyle(
                                    color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    */

                    const SizedBox(height: 40),
                    //const MyDetectorWidget(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
