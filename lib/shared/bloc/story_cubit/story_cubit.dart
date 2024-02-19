import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/login_model.dart';
import '../../../models/story_model.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../AppCubit/cubit.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryStates> {
  StoryCubit() : super(StoryInitialSate());

  static StoryCubit get(context) => BlocProvider.of(context);
  List<List<StoryModel>> bigStories = [];
  File? storyImageFile;
  File? storyVideoFile;
  String compressedImagePath = "/storage/emulated/0/Download/";
  ImagePicker picker = ImagePicker();

  late LoginModel user;

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
    //emit(AppCIState());
  }

  void getGalleryStoryImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      storyImageFile = File(pickedFile.path);

      emit(StoryGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(StoryGetGalleryImageErrorState());
    }
  }

  void getCameraStoryImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      storyImageFile = File(pickedFile.path);
      emit(StoryGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(StoryGetCameraImageErrorState());
    }
  }

  void undoGetStoryImage() {
    storyImageFile = null;
    emit(StoryUndoGetStoryImageSuccessState());
  }

  void createStory({
    required String storyDate,
    required String storyText,
    String? storyImage,
  }) async {
    emit(StoryUploadToFireLoadingSate());
    String storyUid = generateShortUuid();

    StoryModel storyModel = StoryModel(
      name: user.name,
      storyUid: storyUid,
      profileImage: user.profileImage,
      storyDate: storyDate,
      storyText: storyText,
      storyImage: storyImage ?? '',
    );

    try {
      final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('stories').doc(uId);

      await documentReference.update({
        'stories': FieldValue.arrayUnion([storyModel.toMap()])
      });

      emit(StoryUploadImageSuccessSate());
    } catch (error) {
      pint(error.toString());
      emit(StoryUploadImageErrorSate(error.toString()));
    }
  }


  void createStoryWithImage({
    required String storyText,
    required String storyDate,
  }) {
    emit(StoryUploadImageLoadingSate());
    compressImage(originalImage: storyImageFile);
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'storiesImages/${Uri.file(storyImageFile!.path).pathSegments.last}')
        .putFile(storyImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createStory(
            storyDate: storyDate, storyText: storyText, storyImage: value);
        emit(StoryUploadImageSuccessSate());
      }).catchError((onError) {
        pint(onError.toString());
        emit(StoryUploadImageErrorSate(onError.toString()));
      });
    }).catchError((onError) {
      pint(onError.toString());
      emit(StoryUploadImageErrorSate(onError.toString()));
    });
  }

  void getStories() async {
    emit(StoryGetLoadingSate());
    bigStories.clear();
    QuerySnapshot<Map<String, dynamic>> allData =
        await FirebaseFirestore.instance.collection('stories').get();
    for (var userStorySnapshot in allData.docs) {
      try {
        final List<dynamic> storyList =
            (userStorySnapshot.data())['stories'] ?? [];

        final List<StoryModel> stories = storyList.map((storyMap) {
          StoryModel story = StoryModel.fromJson(storyMap);

          return story;
        }).toList();

        bigStories.add(stories );
      } catch (e) {
        pint(e.toString());
        emit(StoryGetErrorSate(e.toString()));
      }
    }
    pint(bigStories.toString());
    emit(StoryGetSuccessSate());
  }
}
