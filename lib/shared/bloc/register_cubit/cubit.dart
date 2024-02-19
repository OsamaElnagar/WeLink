import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/models/login_model.dart';
import 'package:we_link/shared/bloc/register_cubit/states.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/components/constants.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit(RegisterStates initialState) : super(RegisterInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData visible = Icons.visibility;
  bool isShown = true;
  LoginModel? loginModel;

  void changePasswordVisibility() {
    isShown = !isShown;
    visible = isShown ? Icons.visibility : Icons.visibility_off_sharp;

    emit(ChangePasswordVisibilityState());
  }

  void userRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      var receiverFCMToken = await FirebaseMessaging.instance.getToken();
      createUser(
          name: name,
          phone: phone,
          email: email,
          uId: value.user!.uid,
          receiverFCMToken: receiverFCMToken);
    }).catchError((onError) {
      pint(onError.toString());
      emit(RegisterErrorState(onError.toString()));
    });
  }

  void createUser({
    required String name,
    required String phone,
    required String email,
    String? uId,
    String? receiverFCMToken,
  }) async {
    emit(RegisterLoadingState());
    loginModel = LoginModel(
      name: name,
      phone: phone,
      email: email,
      bio: 'New WeLink User 🤍',
      uId: uId!,
      receiverFCMToken: receiverFCMToken!,
      profileImage: newUserProfileImageLink,
      profileCover: newUserCoverImageLink,
    );
   await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(loginModel!.toMap())
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('posts')
          .doc(uId)
          .set({"posts": []});
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(uId)
          .set({"stories": []});

      emit(RegisterCreateUserSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(RegisterCreateUserErrorState(onError));
    });
  }
}
