import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:we_link/shared/bloc/post_cubit/post_cubit.dart';
import 'package:we_link/shared/components/post_items/build_post_item.dart';

import '../../bloc/AppCubit/cubit.dart';
import '../../bloc/AppCubit/states.dart';
import '../../styles/texts.dart';
import '../lottie_animations/lottie_assets_names.dart';
import '../lottie_animations/lottie_builder.dart';

class FeedsStreamList extends StatefulWidget {
  const FeedsStreamList({
    Key? key,
    required this.scrollController,
    this.moreVert= const Center(),
  }) : super(key: key);

  final ScrollController scrollController;
  final Widget moreVert;

  @override
  State<FeedsStreamList> createState() => _FeedsStreamListState();
}

class _FeedsStreamListState extends State<FeedsStreamList> {
  @override
  void initState() {
    PostCubit cubit = PostCubit.get(context);
    cubit.getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {},
      builder: (context, state) {
        PostCubit cubit = PostCubit.get(context);

        return ConditionalBuilder(
          condition: (cubit.posts.isNotEmpty),
          builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: cubit.posts.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                final post = cubit.posts[index];
                return BuildPostItem(
                  postModel: post,
                  moreVert: widget.moreVert,
                );
              },
            ),
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
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyDetectorWidget extends StatefulWidget {
  const MyDetectorWidget({Key? key}) : super(key: key);

  @override
  State<MyDetectorWidget> createState() => _MyDetectorWidgetState();
}

class _MyDetectorWidgetState extends State<MyDetectorWidget> {
  String endMessage = 'Getting new posts..';

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostStates>(
      listener: (context, state) {
        if (state is AppGetFeedPostNoMoreDataState) {
          setState(() {
            endMessage = 'No more posts';
          });
        }
      },
      child: VisibilityDetector(
        key: const Key('my-widget-key'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          debugPrint(
              'Widget ${visibilityInfo.key} is $visiblePercentage% visible');

          if (visiblePercentage >= 0.1) {
            if (endMessage != 'No more posts') {
              //AppCubit.get(context).getFeedPostsEr(refreshPosts: false);
              setState(() {
                PostCubit.get(context).getPosts();
              });
            }
          }
        },
        child: SizedBox(
          height: 50,
          child: Center(
            child: WeLinkHints(
              hint: endMessage,
            ),
          ),
        ),
      ),
    );
  }
}

/*
StreamBuilder<List<PostModel>>(
          stream: PostService.getPostsStream(
            limit: 5,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  children: [
                    AssetLotties(asset: loadPosts),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Loading posts...',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Column(
                  children: [
                    AssetLotties(asset: userHasNoPosts),
                    Text('Error fetching posts'),
                  ],
                ),
              );
            } else {
              return ConditionalBuilder(
                condition: (snapshot.hasData || snapshot.data!.isNotEmpty),
                builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    final post = snapshot.data![index];
                    return BuildPostItem(
                        postModel: post, moreVert: const Center());
                  },
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
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        )
 */
