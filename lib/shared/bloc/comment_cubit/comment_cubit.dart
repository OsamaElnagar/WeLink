import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:we_link/models/post_model.dart';
import '../../../models/comment_model.dart';
import '../../../models/comment_reply_model.dart';
import '../../../models/login_model.dart';
import '../../components/components.dart';
import '../AppCubit/cubit.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentStates> {
  CommentCubit() : super(CommentInitial());

  static CommentCubit get(context) => BlocProvider.of(context);

  late LoginModel user;
  ImagePicker picker = ImagePicker();
  File? commentImageFile;
  File? commentReplyImageFile;
  List<CommentModel> comments = [];
  List<String> commentId = [];
  List<CommentReplyModel> commentsReply = [];
  List<CommentReplyModel> storedReply = [];
  String? newCommentId;
  List<String> replyId = [];
  List<int> commentCounter = [];
  String? newPostId;

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
    emit(CommentCIState());
  }

//********************

  void createComment(
      {required String postUid,
      required String commentText,
      String? commentImage,
      required String commentDate,
      context}) {
    emit(CreateCommentLoadingState());

    String commentUid = const Uuid().v4();

    CommentModel commentModel = CommentModel(
      name: user.name,
      profileImage: user.profileImage,
      uId: user.uId,
      commentUid: commentUid,
      commentText: commentText,
      commentImage: commentImage ?? '',
      commentDate: commentDate,
    );
    FirebaseFirestore.instance.collection('posts').doc(postUid).update({
      "postComments.$commentUid": commentModel.toMap(),
    }).then((value) {
      //getComments(feedPostId: postUid);
      emit(CreateCommentSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(CreateCommentErrorState(onError.toString()));
    });
  }

  void createCommentWithImage({
    required String postUid,
    required String commentText,
    required String commentDate,
  }) {
    emit(CreateCommentLoadingState());
    compressImage(originalImage: commentImageFile);
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'commentsImages/${Uri.file(commentImageFile!.path).pathSegments.last}')
        .putFile(commentImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createComment(
          postUid: postUid,
          commentText: commentText,
          commentDate: commentDate,
          commentImage: value,
        );
      }).catchError((onError) {
        pint(onError.toString());
        emit(CreateCommentErrorState(onError.toString()));
      });
      emit(CreateCommentSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(CreateCommentErrorState(onError.toString()));
    });
  }

  Future<void> getComments({required String postUid}) async {
    emit(GetCommentLoadingState());
    comments.clear();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .get()
        .then((post) {
      PostModel postModel = PostModel.fromJson(post.data()!);

      Map<String, dynamic> commentsMap = postModel.postComments;

      commentsMap.forEach((commentUid, commentData) {
        // Convert the comment data into a CommentModel object
        CommentModel comment = CommentModel.fromJson(commentData);
        comments.add(comment);
        pint(comments.first.commentText);
        pint(comments.last.commentText);
      });
      emit(GetCommentSuccessState());
    }).catchError((error) {
      pint('error getting comments'+error);
      emit(GetCommentErrorState(error.toString()));
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
    emit(CreateCommentReplyLoadingState());
    CommentReplyModel commentReplyModel = CommentReplyModel(
        name: user.name,
        profileImage: user.profileImage,
        uId: user.uId,
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
      emit(CreateCommentReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(CreateCommentReplyErrorState(onError.toString()));
    });
  }

  void createCommentReplyWithImage({
    required String postId,
    required String commentId,
    required String commentReplyText,
    required String commentReplyDate,
  }) {
    emit(CreateCommentReplyLoadingState());
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
        emit(CreateCommentReplyErrorState(onError.toString()));
      });
      emit(CreateCommentReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(CreateCommentReplyErrorState(onError.toString()));
    });
  }

  void getCommentsReply({
    required String postId,
    required String commentId,
  }) {
    commentsReply.clear();
    replyId.clear();

    emit(GetCommentReplyLoadingState());
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
      emit(GetCommentReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(GetCommentReplyErrorState(onError.toString()));
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
    emit(StoreReplyLoadingState());
    CommentReplyModel commentReplyModel = CommentReplyModel(
        name: user.name,
        profileImage: user.profileImage,
        uId: user.uId,
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
      emit(StoreReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(StoreReplyErrorState(onError.toString()));
    });
  }

  void storeReplyWithImage({
    required String postId,
    required String commentReplyText,
    required String commentReplyDate,
  }) {
    emit(StoreReplyLoadingState());
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
        emit(StoreReplyErrorState(onError.toString()));
      });
      emit(StoreReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(StoreReplyErrorState(onError.toString()));
    });
  }

  void getStoredReply({
    required String postId,
  }) {
    storedReply.clear();
    replyId.clear();
    emit(GetStoredReplyLoadingState());
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

      emit(GetStoredReplySuccessState(newCommentId!));
    }).catchError((onError) {
      pint(onError.toString());
      emit(GetStoredReplyErrorState(onError.toString()));
    });
  }

  void getGalleryCommentImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentImageFile = File(pickedFile.path);

      emit(GetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(GetGalleryImageErrorState());
    }
  }

  void getCameraCommentImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      commentImageFile = File(pickedFile.path);
      emit(GetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(GetCameraImageErrorState());
    }
  }

  void undoGetCommentImage(value) {
    commentImageFile = null;
    emit(UndoGetCommentImageSuccessState());
  }

  void getGalleryCommentReplyImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentReplyImageFile = File(pickedFile.path);

      emit(GetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(GetGalleryImageErrorState());
    }
  }

  void getCameraCommentReplyImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      commentReplyImageFile = File(pickedFile.path);
      emit(GetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(GetCameraImageErrorState());
    }
  }

  void undoGetCommentReplyImage(value) {
    commentReplyImageFile = null;
    emit(UndoGetCommentImageSuccessState());
  }

  List<CommentModel> removeDuplicates(List<CommentModel> comments) {
    List<CommentModel> distinct;
    List<CommentModel> dummy = comments;

    for (int i = 0; i < comments.length; i++) {
      for (int j = 1; j < dummy.length; j++) {
        if (dummy[i].name == comments[j].name) {
          if (dummy[i].commentText == comments[j].commentText) {
            // dummy.removeAt(j);
          }
        }
      }
    }
    distinct = dummy;
    pint(distinct.toString());

    return distinct.map((e) => e).toSet().toList();
  }

  List<CommentReplyModel> removeDuplicatedReply(List<CommentReplyModel> reply) {
    List<CommentReplyModel> distinct;
    List<CommentReplyModel> dummy = reply;

    for (int i = 0; i < reply.length; i++) {
      for (int j = 1; j < dummy.length; j++) {
        if (dummy[i].name == reply[j].name) {
          if (dummy[i].replyText == reply[j].replyText) {
            // dummy.removeAt(j);
          }
        }
      }
    }
    distinct = dummy;
    pint(distinct.toString());

    return distinct.map((e) => e).toSet().toList();
  }
}
