import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/v1.dart';
import 'package:we_link/models/chat_model.dart';
import 'package:we_link/models/comment_model.dart';
import 'package:we_link/models/comment_reply_model.dart';
import 'package:we_link/models/like_post_model.dart';
import 'package:we_link/models/login_model.dart';
import 'package:we_link/models/post_model.dart';
import 'package:we_link/modules/chat/chats_screen.dart';
import 'package:we_link/shared/components/post_items/feeds_stream_list.dart';
import 'package:we_link/modules/auth/login_screen.dart';
import 'package:we_link/modules/notification_screen.dart';
import 'package:we_link/shared/bloc/AppCubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/network/local/cache_helper.dart';
import '../../../models/boarding_model.dart';
import '../../../models/story_model.dart';
import '../../../modules/feeds/feeds_screen.dart';
import '../../../modules/profiles/profile_screen.dart';
import '../../../modules/settings_screen.dart';
import '../../components/constants.dart';
import '../../styles/icons_broken.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit(AppStates initialState) : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;
  PostModel? postModel;
  LikePostModel? likePostModel;
  File? postImageFile;
  File? postVideoFile;
  File? profileImageFile;
  File? coverImageFile;
  File? commentImageFile;
  File? commentReplyImageFile;
  File? messageImageFile;

  //File? compressedMessageImageFile;
  ImagePicker picker = ImagePicker();
  List postImageFiles = [];
  List<String> myPostId = [];
  List<String> feedPostId = [];
  List<String> commentId = [];
  List<PostModel> feedPosts = [];
  List<PostModel> myPosts = [];
  List<CommentModel> comments = [];
  String? newPostId;
  List<CommentReplyModel> commentsReply = [];
  List<CommentReplyModel> storedReply = [];
  String? newCommentId;
  List<String> replyId = [];
  List<int> commentCounter = [];
  List<LoginModel> allUsers = [];
  List<List<StoryModel>> bigStories = [];
  List<String> storyId = [];
  List<ChatsModel> messages = [];
  Map<String, dynamic> userSearched = {};
  List<PostModel> visitedUserPosts = [];
  String repeatedId = '';
  List<String> usersUIds = [];
  List<PostModel> gg = [];
  Set<String> uniquePostIds = <String>{};

  Future<LoginModel?> getUserData() async {
    emit(AppGetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      loginModel = LoginModel.fromJson(value.data()!);
      pint(loginModel!.name.toString());
      emit(AppGetUserDataSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetUserDataErrorState(onError.toString()));
    });
    return loginModel;
  }

  void playPauseVideo(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    emit(AppPlayPauseVideoState());
  }

  int currentLimit = 5;
  DocumentSnapshot? lastVisiblePost;

  void getFeedPostsEr({required bool refreshPosts}) {
    emit(AppGetFeedPostLoadingState());

    Query query = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('postDate', descending: true)
        .limit(currentLimit);

    if (refreshPosts) {
      // If refreshPosts is true, clear existing data
      feedPosts.clear();
      uniquePostIds.clear();
      lastVisiblePost = null;
    }
    else if (lastVisiblePost != null) {
      // If not refreshing and lastVisiblePost is not null, start after the last visible post
      query = query.startAfterDocument(lastVisiblePost!);
    }

    query.get().then((value) {
      if (value.docs.isNotEmpty) {
        lastVisiblePost = value.docs.last;

        for (var element in value.docs) {
          var postData = element.data();
          if (postData != null && postData is Map<String, dynamic>) {
            if (!uniquePostIds.contains(element.id)) {
              uniquePostIds.add(element.id);
              feedPostId.add(element.id);
              feedPosts.add(PostModel.fromJson(postData));
            }
          } else {
            // Handle the case where the data is null or not of the expected type
            pint("Invalid post data");
          }
        }

        emit(AppGetFeedPostSuccessState());
      } else {
        emit(AppGetFeedPostNoMoreDataState());
      }
    }).catchError((onError) {
      pint(onError.toString());
      pint(onError.runtimeType.toString());
      emit(AppGetFeedPostErrorState(onError.toString()));
    });
  }

  void modifyPost({
    required String feedPostId,
    required String postText,
    required String postImage,
  }) {
    emit(AppModifyPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(feedPostId)
        .update({'postText': postText, 'postImage': postImage}).then((value) {
      emit(AppModifyPostSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppModifyPostErrorState(onError.toString()));
    });
    /////////////////////////////
    FirebaseFirestore.instance
        .collection('posts')
        .doc(feedPostId)
        .update({'postText': postText, 'postImage': postImage}).then((value) {
      emit(AppModifyPostSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppModifyPostErrorState(onError.toString()));
    });
  }

  //********************
  String compressedImagePath = "/storage/emulated/0/Download/";

  Future compressImage({required originalImage}) async {
    if (originalImage == null) return null;
    pint('${await originalImage!.length()}' + ' before');
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      originalImage!.path,
      "$compressedImagePath/file1.jpg",
      quality: 10,
    );
    if (compressedFile != null) {
      originalImage = compressedFile;
      pint('${await originalImage!.length()}' ' after');
    }
    emit(AppCIState());
  }

  //********************

  void wannaSearch(context) {
    wannaSearchForUser = !wannaSearchForUser;
    FocusScope.of(context).requestFocus(searchUserNode);
    emit(AppWannaSearchSuccessState());
  }

  void getGalleryProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void getGalleryCoverImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraCoverImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      coverImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void getGalleryPostImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraPostImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      postImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void undoGetProfileImage() {
    profileImageFile = null;
    emit(AppUndoGetProfileImageSuccessState());
  }

  void undoGetCoverImage() {
    coverImageFile = null;
    emit(AppUndoGetCoverImageSuccessState());
  }

  void getGalleryCommentReplyImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentReplyImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraCommentReplyImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      commentReplyImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void undoGetCommentReplyImage(value) {
    commentReplyImageFile = null;
    emit(AppUndoGetCommentImageSuccessState());
  }

  void updateProfileImage({
    required String name,
    required String phone,
    required String email,
    required String bio,
  }) {
    emit(AppUpdateProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'profileImages/${Uri.file(profileImageFile!.path).pathSegments.last}')
        .putFile(profileImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateProfile(
          name: name,
          phone: phone,
          email: email,
          bio: bio,
          profileImage: value,
        );
      }).catchError((onError) {});
      emit(AppUpdateProfileImageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppUpdateProfileImageErrorState(onError.toString()));
    });
  }

  void updateProfileCover({
    required String name,
    required String phone,
    required String email,
    required String bio,
  }) {
    emit(AppUpdateCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'coverImages/${Uri.file(coverImageFile!.path).pathSegments.last}')
        .putFile(coverImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateProfile(
          name: name,
          phone: phone,
          email: email,
          bio: bio,
          profileCover: value,
        );
      }).catchError((onError) {});
      emit(AppUpdateCoverImageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppUpdateCoverImageErrorState(onError.toString()));
    });
  }

  void updateProfile({
    required String name,
    required String phone,
    required String email,
    required String bio,
    String? profileImage,
    String? profileCover,
  }) {
    emit(AppUpdateProfileLoadingState());
    LoginModel newLoginModel = LoginModel(
        name: name,
        phone: phone,
        email: email,
        bio: bio,
        profileImage: profileImage ?? loginModel!.profileImage,
        profileCover: profileCover ?? loginModel!.profileCover,
        uId: loginModel!.uId,
        receiverFCMToken: loginModel!.receiverFCMToken);
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginModel!.uId)
        .update(newLoginModel.toMap())
        .then((value) {
      emit(AppUpdateProfileSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppUpdateProfileErrorState(onError.toString()));
    });
  }

  void createCommentReply({
    required String postId,
    required String commentId,
    replyText,
    replyDate,
    String? replyImage,
    context,
  }) {
    emit(AppCreateCommentReplyLoadingState());
    CommentReplyModel commentReplyModel = CommentReplyModel(
        name: loginModel!.name,
        profileImage: loginModel!.profileImage,
        uId: loginModel!.uId,
        replyText: replyText,
        replyImage: replyImage ?? '',
        replyDate: replyDate);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .add(commentReplyModel.toMap())
        .then((value) {
      getCommentsReply(postId: postId, commentId: commentId);
      emit(AppCreateCommentReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreateCommentReplyErrorState(onError.toString()));
    });
  }

  void createCommentReplyWithImage({
    required String postId,
    required String commentId,
    required String commentReplyText,
    required String commentReplyDate,
  }) {
    emit(AppCreateCommentReplyLoadingState());
    compressImage(originalImage: commentReplyImageFile);
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'replyImages/${Uri.file(commentReplyImageFile!.path).pathSegments.last}')
        .putFile(commentReplyImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createCommentReply(
          postId: postId,
          commentId: commentId,
          replyText: commentReplyText,
          replyDate: commentReplyDate,
          replyImage: value,
        );
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppCreateCommentReplyErrorState(onError.toString()));
      });
      emit(AppCreateCommentReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreateCommentReplyErrorState(onError.toString()));
    });
  }

  void getCommentsReply({
    required String postId,
    required String commentId,
  }) {
    commentsReply.clear();
    replyId.clear();

    emit(AppGetCommentReplyLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .get()
        .then((value) {
      for (var element in value.docs) {
        commentsReply.add(CommentReplyModel.fromJson(element.data()));
        replyId.add(element.id);
      }
      newCommentId = commentId;
      emit(AppGetCommentReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetCommentReplyErrorState(onError.toString()));
    });
  }

  ////////////////////////////////////////////
  // do store a replies collection so every body inside the post can see it .

  void storeReply({
    required String postId,
    required replyText,
    required replyDate,
    String? replyImage,
    context,
  }) {
    emit(AppStoreReplyLoadingState());
    CommentReplyModel commentReplyModel = CommentReplyModel(
        name: loginModel!.name,
        profileImage: loginModel!.profileImage,
        uId: loginModel!.uId,
        replyText: replyText,
        replyImage: replyImage ?? '',
        replyDate: replyDate);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('reply')
        .add(commentReplyModel.toMap())
        .then((value) {
      getStoredReply(
        postId: postId,
      );
      emit(AppStoreReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppStoreReplyErrorState(onError.toString()));
    });
  }

  void storeReplyWithImage({
    required String postId,
    required String commentReplyText,
    required String commentReplyDate,
  }) {
    emit(AppStoreReplyLoadingState());
    compressImage(originalImage: commentReplyImageFile);
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'replyImages/${Uri.file(commentReplyImageFile!.path).pathSegments.last}')
        .putFile(commentReplyImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        storeReply(
          postId: postId,
          replyText: commentReplyText,
          replyDate: commentReplyDate,
          replyImage: value,
        );
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppStoreReplyErrorState(onError.toString()));
      });
      emit(AppStoreReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppStoreReplyErrorState(onError.toString()));
    });
  }

  void getStoredReply({
    required String postId,
  }) {
    storedReply.clear();
    replyId.clear();
    emit(AppGetStoredReplyLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('reply')
        .get()
        .then((value) {
      for (var element in value.docs) {
        storedReply.add(CommentReplyModel.fromJson(element.data()));
        replyId.add(element.id);
      }

      emit(AppGetStoredReplySuccessState(newCommentId!));
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetStoredReplyErrorState(onError.toString()));
    });
  }

  Future<void> signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update({"receiverFCMToken": ''});
      navigate2(context, const LoginScreen());
      await CacheHelper.removeData(key: 'uid');

      loginModel = null;
      uId = null;
      emit(AppSignOutSuccessState());
    } catch (error) {
      pint(error.toString());
      emit(AppSignOutErrorState(error.toString()));
    }
  }

  int currentIndex = 0;
  double bottomSheetHeight = 350;

  List<Widget> appTitles = [
    const Text('Feeds'),
    const Text('Chats'),
    const Text('Profile'),
  ];

  void changeBottomSheetHeight() {
    if (bottomSheetHeight == 350) {
      bottomSheetHeight = 700;
    } else {
      bottomSheetHeight = 350;
    }
    emit(AppChangeBSHeightState());
  }

  void changeIndex(index) async {
    currentIndex = index;
    emit(AppChangeBNBState());
  }

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(IconBroken.Chat), label: 'Chats'),
    const BottomNavigationBarItem(
        icon: Icon(IconBroken.Profile), label: 'Profile'),
    const BottomNavigationBarItem(
        icon: Icon(IconBroken.Notification), label: 'Notifications'),
  ];

  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    const ProfileScreen(),
    const NotificationScreen(),
    const SettingScreen(),
  ];

  void endBoarding(context) {
    CacheHelper.putData('lastPage', lastPage!).then((value) {
      if (value) {
        navigate2(context, const LoginScreen());
      }
    }).catchError((onError) {});
  }

  List<BoardingModel> boarding = [
    BoardingModel(
      title: 'See the latest news ',
      body: 'Stay notified with the trending news around the world',
      image: 'assets/SVGs/welcome1.svg',
    ),
    BoardingModel(
      title: 'Show your self to the world',
      body: 'Keep the world in backup with your latest updates',
      image: 'assets/SVGs/welcome2.svg',
    ),
    BoardingModel(
      title: 'Communicate with your friends',
      body: 'reach your friends easily and professionally ',
      image: 'assets/SVGs/welcome3.svg',
    ),
  ];
}
