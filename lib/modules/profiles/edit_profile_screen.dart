import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_link/shared/bloc/AppCubit/cubit.dart';
import 'package:we_link/shared/bloc/AppCubit/states.dart';
import 'package:we_link/shared/styles/colors.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icons_broken.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  double bottomSheetHeight = 350;
  bool wannaEditName = false;
  bool wannaEditPhone = false;
  bool wannaEditBio = false;
  bool wannaEditEmail = false;
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode bioNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var profileModel = AppCubit.get(context).loginModel;
        var profileImageFile = AppCubit.get(context).profileImageFile;
        var coverImageFile = AppCubit.get(context).coverImageFile;

        return Scaffold(
          backgroundColor: WeLinkColors.myColor.shade400,
          appBar: AppBar(
            elevation: 0,
            title: const Text('Profile Modify'),
            actions: [
              TextButton(
                onPressed: () {
                  if (nameController.text != '' ||
                      phoneController.text != '' ||
                      emailController.text != '' ||
                      bioController.text != '') {
                    cubit.updateProfile(
                      name: nameController.text != ''
                          ? nameController.text
                          : profileModel!.name,
                      phone: phoneController.text != ''
                          ? phoneController.text
                          : profileModel!.phone,
                      email: emailController.text != ''
                          ? emailController.text
                          : profileModel!.email,
                      bio: bioController.text != ''
                          ? bioController.text
                          : profileModel!.bio,
                    );
                  }

                  cubit.getUserData();
                  if (state is AppGetUserDataSuccessState) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Update Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  if (state is AppUpdateProfileLoadingState ||
                      state is AppUpdateCoverImageLoadingState ||
                      state is AppUpdateProfileImageLoadingState)
                    const LinearProgressIndicator(
                      color: Colors.deepPurple,
                      value: 50,
                    ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  //here is the profile image and cover.
                  SizedBox(
                    width: double.infinity,
                    height: 210,
                    child: Stack(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: SizedBox(
                                height: 160,
                                width: MediaQuery.of(context).size.width,
                                child: Image(
                                  image: NetworkImage(
                                      profileModel!.profileCover),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => SizedBox(
                                      height: 70,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Gallery',
                                                style: GoogleFonts.lobster(
                                                    fontSize: 20,
                                                    color:
                                                        Colors.deepPurple),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    cubit
                                                        .getGalleryCoverImage();
                                                  },
                                                  child: const Icon(
                                                      IconBroken.Image_2,
                                                      color:
                                                          Colors.yellow)),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 20.0,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Camera',
                                                style: GoogleFonts.lobster(
                                                    fontSize: 20,
                                                    color:
                                                        Colors.deepPurple),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    cubit
                                                        .getCameraCoverImage();
                                                  },
                                                  child: const Icon(
                                                    IconBroken.Camera,
                                                    color: Colors.blue,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      WeLinkColors.myColor,
                                  child: Icon(IconBroken.Camera),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            child: CircleAvatar(
                              backgroundColor: WeLinkColors.myColor,
                              radius: 65,
                              child: CircleAvatar(
                                radius: 62,
                                backgroundImage:
                                    NetworkImage(profileModel.profileImage),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(.25, 1.0),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Gallery',
                                              style: GoogleFonts.lobster(
                                                  fontSize: 20,
                                                  color: WeLinkColors.myColor),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  cubit
                                                      .getGalleryProfileImage();
                                                },
                                                child: const Icon(
                                                    IconBroken.Image_2,
                                                    color: Colors.yellow)),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Camera',
                                              style: GoogleFonts.lobster(
                                                  fontSize: 20,
                                                  color: WeLinkColors.myColor),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  cubit
                                                      .getCameraProfileImage();
                                                },
                                                child: const Icon(
                                                  IconBroken.Camera,
                                                  color: Colors.blue,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    WeLinkColors.myColor,
                                child: Icon(IconBroken.Camera),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  if (profileImageFile != null || coverImageFile != null)
                    Row(
                      children: [
                        if (profileImageFile != null)
                          TextButton(
                            onPressed: () {
                              cubit.updateProfileImage(
                                name: nameController.text != ''
                                    ? nameController.text
                                    : profileModel.name,
                                phone: phoneController.text != ''
                                    ? phoneController.text
                                    : profileModel.phone,
                                email: emailController.text != ''
                                    ? emailController.text
                                    : profileModel.email,
                                bio: bioController.text != ''
                                    ? bioController.text
                                    : profileModel.bio,
                              );
                              cubit.undoGetProfileImage();
                            },
                            child: const Text(
                                'Use this photo as profile image',style: TextStyle(color: Colors.white),),
                          ),
                        if (coverImageFile != null)
                          TextButton(
                            onPressed: () {
                              cubit.updateProfileCover(
                                name: nameController.text != ''
                                    ? nameController.text
                                    : profileModel.name,
                                phone: phoneController.text != ''
                                    ? phoneController.text
                                    : profileModel.phone,
                                email: emailController.text != ''
                                    ? emailController.text
                                    : profileModel.email,
                                bio: bioController.text != ''
                                    ? bioController.text
                                    : profileModel.bio,
                              );
                              cubit.undoGetCoverImage();
                            },
                            child:
                                const Text('Use this photo as cover image',style: TextStyle(color: Colors.white),),
                          ),
                      ],
                    ),
                  if (profileImageFile != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            image: FileImage(profileImageFile),
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
                                      setState(() {
                                        AppCubit.get(context)
                                            .undoGetProfileImage();
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
                  if (coverImageFile != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            image: FileImage(coverImageFile),
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
                                      setState(() {
                                        AppCubit.get(context)
                                            .undoGetCoverImage();
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
                  const SizedBox(
                    height: 50.0,
                  ),
                  InfoUpdateItem(controller: nameController, node: nameNode,hint: profileModel.name,),
                  const SizedBox(
                    height: 5.0,
                  ),
                 InfoUpdateItem(controller: phoneController, node: phoneNode, hint: profileModel.phone),
                  const SizedBox(
                    height: 5.0,
                  ),
                  InfoUpdateItem(controller: emailController, node: emailNode, hint: profileModel.email),
                  const SizedBox(
                    height: 5.0,
                  ),
                  InfoUpdateItem(controller: bioController, node: bioNode, hint: profileModel.bio),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class InfoUpdateItem extends StatelessWidget {
  const InfoUpdateItem({
    Key? key,
    required this.controller,
    required this.node, required this.hint,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode node;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: WeLinkColors.myColor),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        focusNode: node,
        decoration:  InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.horizontal(
              right: Radius.circular(20),
              left: Radius.circular(20),
            ))),
        style: const TextStyle(
          color: Colors.white,
        ),
        cursorColor: WeLinkColors.myColor,
        // onChanged: onChanged,
        onFieldSubmitted: (v) {},
      ),
    );
  }
}
