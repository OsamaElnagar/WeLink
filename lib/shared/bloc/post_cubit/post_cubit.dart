import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_link/models/login_model.dart';
import 'package:we_link/shared/bloc/AppCubit/cubit.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/network/remote/posts_service.dart';

import '../../../models/comment_model.dart';
import '../../../models/post_model.dart';
import '../../components/constants.dart';

part 'post_state.dart';

class PostUploadProgress {
  final int percentage;

  PostUploadProgress(this.percentage);
}

class PostCubit extends Cubit<PostStates> {
  PostCubit() : super(PostInitialState());

  static PostCubit get(context) => BlocProvider.of(context);

  late LoginModel user;
  PostModel? postModel;
  ImagePicker picker = ImagePicker();
  File? postImageFile;
  File? postVideoFile;
  List postImageFiles = [];
  List<String> myPostId = [];
  List<String> feedPostId = [];
  List<String> commentId = [];
  List<PostModel> feedPosts = [];
  List<PostModel> myPosts = [];
  List<CommentModel> comments = [];
  String? newPostId;
  String repeatedId = '';
  CollectionReference<Map<String, dynamic>> postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<LoginModel?> initUser(context) async {
    var cubit = AppCubit.get(context);
    if (cubit.loginModel != null) {
      user = cubit.loginModel!;
    } else {
      user = (await cubit.getUserData())!;
    }
    pint(user.email);
    return user;
  }

  List<PostModel> posts = [];

  void getPosts() {
    PostService.getPostsStream().listen((List<PostModel> newPosts) {
      posts.addAll(newPosts);
    });
    emit(PostGetPostSuccessState());
  }

  void getGalleryPostImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImageFile = File(pickedFile.path);

      emit(PostPickGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(PostPickGalleryImageErrorState());
    }
  }

  void getCameraPostImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      postImageFile = File(pickedFile.path);
      emit(PostPickCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(PostPickCameraImageErrorState());
    }
  }

  void undoPickPostImage() {
    postImageFile = null;
    emit(PostUndoPickPostImageSuccessState());
  }

  void undoPickPostVideo() {
    postVideoFile = null;
    emit(PostUndoPickPostImageSuccessState());
  }

  void clearPostImagesList() {
    postImageFiles.clear();
    postImageFile = null;
    postVideoFile = null;
    emit(PostClearImageListSuccessState());
  }

  final StreamController<PostUploadProgress> _uploadProgressController =
      StreamController<PostUploadProgress>();

  Future<void> createFeedPost({
    required String postText,
    required String postDate,
    String? postImage,
    String? postVideo,
    context,
  }) async {
    emit(PostCreatePostLoadingState());
    String postUid = generateShortUuid();
    PostModel postModel = PostModel(
      name: user.name,
      postUid: postUid,
      userUid: user.uId,
      profileImage: user.profileImage,
      postDate: postDate,
      postText: postText,
      postImage: postImage ?? '',
      videoLink: postVideo ?? '',
      postLikes: [],
      postComments: {},
      postShares: [],
    );

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .set(postModel.toMap())
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('posts')
          .doc(uId)
          .update({
        "posts": FieldValue.arrayUnion(['posts/$postUid']),
      });

      emit(PostCreatePostSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(PostCreatePostErrorState(onError.toString()));
    });
  }

  Future<void> uploadPostWithImageOrVideo(
      {required String postText, required String postDate, context}) async {
    emit(PostCreatePostLoadingState());

    String postImageLink = '';
    String postVideoLink = '';

    if (postImageFile != null) {
      pint('image file is available');
      emit(PostUploadImageLoadingState());
      compressImage(originalImage: postImageFile);
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
              'postsImages/${Uri.file(postImageFile!.path).pathSegments.last}')
          .putFile(postImageFile!)
          .then((value) async {
        await value.ref.getDownloadURL().then((postImage) async {
          postImageLink = postImage;
          emit(PostUploadImageSuccessState());
        }).catchError((onError) {
          pint(onError.toString());
          emit(PostUploadImageErrorState(onError.toString()));
        });
      }).catchError((onError) {
        pint(onError.toString());
        emit(PostUploadImageErrorState(onError.toString()));
      });
    }

    if (postVideoFile != null) {
      emit(PostUploadVideoLoadingState());
      pint('image file is available');
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
              'postsVideos/${Uri.file(postVideoFile!.path).pathSegments.last}')
          .putFile(postVideoFile!)
          .then((p0) async {
        await p0.ref.getDownloadURL().then((postVideo) async {
          postVideoLink = postVideo;
          emit(PostUploadVideoSuccessState());
        }).catchError((onError) {
          pint(onError.toString());
          emit(PostUploadVideoErrorState(onError.toString()));
        });
      }).catchError((onError) {
        pint(onError.toString());
        emit(PostUploadVideoErrorState(onError.toString()));
      });
    }

    await createFeedPost(
      postText: postText,
      postDate: postDate,
      postImage: postImageLink,
      postVideo: postVideoLink,
    ).then((value) {
      emit(PostUploadSuccessState());
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
    emit(PostCIState());
  }

//********************

  Future<void> pickPostVideo({required String source}) async {
    if (source == MediaSource.camera) {
      var pickedFile = await picker.pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        postVideoFile = File(pickedFile.path);
        emit(PickGalleryVideoSuccessState());
      } else {
        pint('No Video selected');
        emit(PickGalleryVideoErrorState());
      }
    } else {
      var pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        postVideoFile = File(pickedFile.path);

        emit(PickCameraVideoSuccessState());
      } else {
        pint('No Video selected');
        emit(PickCameraVideoErrorState());
      }
    }
  }

  Future<void> likePost({
    required BuildContext context,
    required String postUid,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postUid).update({
        'postLikes': FieldValue.arrayUnion([user.uId])
      });
    } on FirebaseException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error Liking Post!'),
        ),
      );
    }
    emit(PostLikeState());
  }

  Future<void> dislikePost({
    required BuildContext context,
    required String postUid,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postUid).update({
        'postLikes': FieldValue.arrayRemove([user.uId])
      });
    } on FirebaseException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error Disliking Post!'),
        ),
      );
    }
    emit(PostDislikeState());
  }
}
