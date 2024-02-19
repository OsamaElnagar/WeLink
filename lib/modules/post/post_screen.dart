import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/shared/bloc/post_cubit/post_cubit.dart';
import 'package:we_link/shared/components/file_video_post.dart';
import 'package:we_link/shared/components/lottie_animations/lottie_assets_names.dart';
import 'package:we_link/shared/components/lottie_animations/lottie_builder.dart';
import 'package:we_link/shared/components/post_items/uploading_post/add_to_your_post.dart';
import 'package:we_link/shared/components/post_items/uploading_post/image_file_for_post.dart';
import 'package:we_link/shared/components/post_items/uploading_post/write_post_text.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/icons_broken.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  bool whileCreatingPost = false;
  TextEditingController textEditingController = TextEditingController();
  String postText = '';

  bool isBlank(String text) {
    return (text.trim().isEmpty == false && text.length >= 5) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {
        if (state is PostUploadSuccessState ||
            state is PostCreatePostSuccessState) {
          PostCubit.get(context).clearPostImagesList();
          textEditingController.clear();
          postText = '';
          showToast(msg: 'Post Uploaded Successfully', state: ToastStates.success);
        }
        if (state is PostCreatePostErrorState) {
          showToast(msg: 'Failed to upload!', state: ToastStates.error);
        }  
      },
      builder: (context, state) {
        var cubit = PostCubit.get(context);
        var user = cubit.user;
        var postImageFile = cubit.postImageFile;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Upload your post'),
            actions: [
              TextButton(
                onPressed: () {
                  postText = '';
                  cubit.clearPostImagesList();
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is PostCreatePostLoadingState)
                  const LinearProgressIndicator(),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: const AssetLotties(asset: createPost),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Tell people what\'s in your mind...!',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // ProfileBannerAndName(user: user),
                const SizedBox(height: 10),
                WritePostTextField(
                  textEditingController: textEditingController,
                  onChanged: (inputText) {
                    setState(() {
                      postText = inputText;
                    });
                  },
                  onFieldSubmitted: (text) {
                    setState(() {
                      whileCreatingPost = true;
                    });
                  },
                ),
                const SizedBox(height: 10),
                AddToYourPost(cubit: cubit),
                if (postImageFile != null)
                  ImageFileForPost(cubit: cubit, postImageFile: postImageFile),
                if (cubit.postVideoFile != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      FileVideoPostOsama(file: cubit.postVideoFile!),
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple.withOpacity(.8),
                        child: IconButton(
                          onPressed: () {
                            dialogMessage(
                              context: context,
                              title: const Text(
                                'remove',
                                style: TextStyle(color: Colors.red),
                              ),
                              content: const Text(
                                'Are you sure deleting this photo?',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      cubit.undoPickPostVideo();
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text(
                                    'Ok',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                          icon: const Icon(IconBroken.Close_Square),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: IgnorePointer(
            ignoring: (postText != '' || postImageFile != null) ? false : true,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              onPressed: () {
                if (!isBlank(postText) ||
                    postImageFile != null ||
                    cubit.postVideoFile != null) {
                  if (cubit.postImageFile != null ||
                      cubit.postVideoFile != null) {
                    cubit.uploadPostWithImageOrVideo(
                      postText: postText,
                      postDate: DateTime.now().toLocal().toString(),
                      context: context,
                    );
                  } else {
                    cubit.createFeedPost(
                        postText: postText,
                        postDate: DateTime.now().toLocal().toString(),
                        context: context);
                  }
                }
              },
              label: Text(
                '     post now     ',
                style: TextStyle(
                  fontSize: 20,
                  color: (isBlank(postText) == false ||
                          postImageFile != null ||
                          cubit.postVideoFile != null)
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
