import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/shared/bloc/loginCubit/states.dart';
import '../../components/components.dart';
import '../../components/constants.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(LoginStates initialState) : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData visible = Icons.visibility;
  bool isShown = true;

  void changePasswordVisibility() {
    isShown = !isShown;
    visible = isShown ? Icons.visibility : Icons.visibility_off_sharp;

    emit(ChangePasswordVisibilityState());
  }

  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      String? receiverFCMToken = await FirebaseMessaging.instance.getToken();
      String? uid = value.user?.uid;
      pint('receiverFCMToken for $uid is:$receiverFCMToken');
      pint(uid);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"receiverFCMToken": receiverFCMToken});
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((onError) {
      pint(onError.toString());
      emit(LoginErrorState(onError.toString()));
    });
  }

  void resetPassword({required String email, context}) {
    emit(LoginResetPasswordLoadingState());
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('we sent you an email, please check your email!'),
        ),
      );
      emit(LoginResetPasswordSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(LoginResetPasswordErrorState(onError.toString()));
    });
  }
}
