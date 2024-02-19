import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/shared/bloc/AppCubit/states.dart';
import 'package:we_link/shared/bloc/story_cubit/story_cubit.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/styles/icons_broken.dart';

import '../../shared/components/build_story_items/build_gesture_item.dart';

class NewStoryScreen extends StatefulWidget {
  const NewStoryScreen({Key? key}) : super(key: key);

  @override
  State<NewStoryScreen> createState() => _NewStoryScreenState();
}

class _NewStoryScreenState extends State<NewStoryScreen> {
  bool whileCreatingStory = false;
  TextEditingController textEditingController = TextEditingController();
  String storyText = '';
  bool wannaAddStoryText = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return BlocConsumer<StoryCubit, StoryStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = StoryCubit.get(context);
        var storyImageFile = cubit.storyImageFile;
        FocusNode txtStoryNode = FocusNode();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create new story'),
            actions: [
              IconButton(
                onPressed: () {
                  if (storyImageFile != null || storyText != '') {
                    if (storyImageFile != null) {
                      cubit.createStoryWithImage(
                          storyText: storyText,
                          storyDate: DateTime.now().toLocal().toString());
                    } else {
                      cubit.createStory(
                        storyDate: DateTime.now().toLocal().toString(),
                        storyText: storyText,
                      );
                    }
                  }
                  storyText = '';
                  cubit.getStories();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check_circle_sharp),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is AppCreateStoryLoadingState ||
                    state is AppCreateStoryImageLoadingState)
                  const LinearProgressIndicator(),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureItem(
                            onTap: () {
                              setState(() {
                                wannaAddStoryText = false;
                              });
                              cubit.getGalleryStoryImage();
                            },
                            icon: IconBroken.Image,
                            iconColor: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: GestureItem(
                            onTap: () {
                              setState(() {
                                wannaAddStoryText = false;
                              });
                              cubit.getCameraStoryImage();
                            },
                            icon: IconBroken.Camera,
                            iconColor: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: GestureItem(
                            onTap: () {
                              setState(() {
                                wannaAddStoryText = !wannaAddStoryText;
                              });
                              FocusScope.of(context).requestFocus(txtStoryNode);
                            },
                            icon: IconBroken.Edit_Square,
                            iconColor: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (wannaAddStoryText)
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        controller: textEditingController,
                        focusNode: txtStoryNode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        onChanged: (inputText) {
                          setState(() {
                            storyText = inputText;
                          });
                        },
                        onFieldSubmitted: (text) {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            whileCreatingStory = true;
                          });
                        },
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (storyImageFile != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: FileImage(storyImageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(.4),
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
                                    cubit.undoGetStoryImage();
                                    Navigator.pop(context);
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'i will ask for storage permission \nfrom user to disp local images here'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

