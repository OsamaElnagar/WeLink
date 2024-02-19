import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:we_link/shared/components/sound_assets/asset_names.dart';
import 'package:we_link/shared/network/remote/firebase_api.dart';
import '../../../models/chat_model.dart';
import '../../../models/login_model.dart';
import '../../../models/post_model.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../../components/sound_assets/play_sound.dart';
part 'chat_state.dart';


class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  late LoginModel user;
  Map<String, dynamic> userSearched = {};
  List<ChatsModel> lastMessages = [];
  List<LoginModel> allUsers = [];
  File? messageImageFile;
  String messageId = '';

  LoginModel undefinedUser = LoginModel(
    name: 'undefinedUser',
    phone: 'undefined',
    email: 'undefinedUser',
    bio: 'undefinedUser',
    profileImage: newUserProfileImageLink,
    profileCover: newUserCoverImageLink,
    uId: 'undefinedUser',
    receiverFCMToken: 'undefined',
  );
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<LoginModel> initUser() async {
    emit(ChaInitUserLoadingState());
    user = undefinedUser;
    user = await usersCollection.doc(uId).get().then((value) {
      return LoginModel.fromJson(value.data()!);
    });
    emit(ChatInitUserSuccessState());
    pint(user.email);
    return user;
  }

  void playSendMessageSound() async {
    Player.play(sendMessage);
  }

  ImagePicker picker = ImagePicker();
  List<PostModel> visitedUserPosts = [];

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
    emit(ChatCIState());
  }

  //********************

  void getGalleryMessageImage() async {
    var pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      messageImageFile = File(pickedFile.path);

      emit(ChatGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(ChatGetGalleryImageErrorState());
    }
  }

  void getCameraMessageImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      messageImageFile = File(pickedFile.path);
      emit(ChatGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(ChatGetCameraImageErrorState());
    }
  }

  void undoGetMessageImage() {
    messageImageFile = null;
    emit(ChatUndoGetMessageImageSuccessState());
  }



  void senMessage({
    required String receiverId,
    required String receiverFCMAPI,
    required String fromUser,
    required String textMessage,
    String? imageMessage,
    required String messageDateTime,
  }) async {
    emit(ChatSendMessageLoadingState());

    List<String> ids = [user.uId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    String mID = generateShortUuid();

    ChatsModel chatsModel = ChatsModel(
      senderId: user.uId,
      receiverId: receiverId,
      messageId: mID,
      textMessage: textMessage,
      imageMessage: imageMessage ?? '',
      messageDateTime: messageDateTime,
      seen: false,
    );
    await db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(mID)
        .set(chatsModel.toMap())
        .then((value) async {
      await db
          .collection('chat_rooms')
          .doc(chatRoomId)
          .set({"last_message": chatsModel.toMap()});
      emit(ChatSendMessageSuccessState());
    }).catchError((error) {
      emit(ChatSendMessageErrorState(error.toString()));
    });
    FirebaseApi().sendMessageNotification(
        toUser: receiverFCMAPI,
        fromUser: fromUser,
        messageBody: "$textMessage" "${imageMessage != '' ? '🖼️' : null}");
  }

  void sendMessageWithImage({
    required String receiverId,
    required String textMessage,
    required String messageDateTime,
    required String receiverFCMAPI,
    required String fromUser,
  }) {
    emit(ChatSendMessageWithImageLoadingState());
    compressImage(originalImage: messageImageFile);
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${user.uId}/Chats/$receiverId/Messages/${Uri.file(messageImageFile!.path).pathSegments.last}')
        .putFile(messageImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        senMessage(
          receiverId: receiverId,
          textMessage: textMessage,
          messageDateTime: messageDateTime,
          imageMessage: value,
          fromUser: fromUser,
          receiverFCMAPI: receiverFCMAPI,
        );
      }).catchError((onError) {
        pint(onError.toString());
        emit(ChatSendMessageErrorState(onError.toString()));
      });
    }).catchError((onError) {
      pint(onError.toString());
      emit(ChatSendMessageWithImageErrorState(onError.toString()));
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String receiverId}) {
    List<String> ids = [uId!, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    var snapshot = db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('messageDateTime', descending: false)
        .snapshots();

    return snapshot;
  }

  Future<void> setMessageAsSeen({
    required String messageId,
    required String receiverId,
    required String chatRoomId,
  }) async {
    emit(ChatSetMessageSeenLoadingState());

    await db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({'seen': true})
        .then((value) {})
        .catchError((error) {
          emit(ChatSetMessageSeenErrorState(error.toString()));
        });
  }

  Future<List<String>> getChatRoomIds(String userId) async {
    List<String> chatRoomIds = [];
    List<String> chatIds = [];

    QuerySnapshot chatRoomsSnapshot =
        await FirebaseFirestore.instance.collection('chat_rooms').get();
    for (var roomDoc in chatRoomsSnapshot.docs) {
      chatRoomIds.add(roomDoc.id);
    }
    pint(chatRoomIds.length);
    for (var joinedId in chatRoomIds) {
      List<String> ids = joinedId.split('_');
      if (ids.contains(userId)) {
        // Add the ID joined with your ID to the list
        chatIds.add(ids.firstWhere((id) => id != userId));
      }
    }

    return chatIds;
  }

  List<LoginModel> chats = [];

  Future<List<LoginModel>> getChatsByUser() async {
    emit(ChatGetChatsByUserLoadingState());
    List<String> chatIds = await getChatRoomIds(uId!);
    chats.clear();
    for (String userUid in chatIds) {
      pint("Receiver ID: $userUid");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get()
          .then((value) {
        if (value.data() != null) {
          chats.add(LoginModel.fromJson(value.data()!));
          emit(ChatGetChatsByUserSuccessState());
        }
      }).catchError((onError) {
        pint(onError.toString());
        emit(ChatGetChatsByUserErrorState(onError.toString()));
      });
    }

    return chats;
  }

  Stream<List<LoginModel>>? searchResultsStream;

  Stream<List<LoginModel>> searchUsersByName(
    String query, {
    bool showAll = false,
  }) {
    return searchResultsStream = FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '$query\uf8ff')
        .snapshots()
        .map((querySnapshot) {
      List<LoginModel> users = [];

      for (var doc in querySnapshot.docs) {
        LoginModel user = LoginModel.fromJson(doc.data());

        // Check if the user is not in the chats list
       if (!showAll) {
         if (!chats.any((chatUser) => chatUser.uId == user.uId)) {
           users.add(user);
         }
       }  else
       {
         users.add(user);
       }
      }

      return users;
    });
  }

  Future<Map<String, dynamic>> getLastMessages(String userId) async {
    Map<String, dynamic> lastMessages = {};

    QuerySnapshot chatRoomsSnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .get();

    for (QueryDocumentSnapshot roomDoc in chatRoomsSnapshot.docs) {
      String roomId = roomDoc.id;

      QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('messageDateTime', descending: true)
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isNotEmpty) {
        lastMessages[roomId] = messagesSnapshot.docs.first.data();
      }
    }

    return lastMessages;
  }
}
