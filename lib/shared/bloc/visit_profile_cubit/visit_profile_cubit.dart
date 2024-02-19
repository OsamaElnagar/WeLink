import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:we_link/shared/components/constants.dart';
import '../../../models/login_model.dart';
import '../../../models/post_model.dart';
import '../../components/components.dart';

part 'visit_profile_state.dart';

class VisitProfileCubit extends Cubit<VisitProfileStates> {
  VisitProfileCubit() : super(VisitProfileInitial());

  static VisitProfileCubit get(context) => BlocProvider.of(context);

  LoginModel? user;

  LoginModel undefinedUser = LoginModel(
    name: 'undefinedUser',
    phone: 'undefined',
    email: 'undefinedUser',
    bio: 'undefinedUser',
    profileImage: newUserProfileImageLink,
    profileCover: newUserCoverImageLink,
    uId: 'uId',
    receiverFCMToken: ''
  );

  List<PostModel> visitedUserPosts = [];

  Future<List<dynamic>> getUserPostLinks({required String userUid}) async {
    visitedUserPosts.clear();
    List<dynamic> links = [];
    emit(GetVisitedUserLinksLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('posts')
        .doc(userUid)
        .get()
        .then((value) {
      if (value.data() != null) {
        var postsLinkMap = value.data()!;
        links = postsLinkMap['posts'];
        links = links.map((link) => link.replaceFirst('posts/', '')).toList();

        pint(links);
      } else {
        links = [];
      }

      emit(GetVisitedUserLinksSuccessState());
    });
    return links;
  }

  void getVisitedUserPosts({required String userUid}) async {
    visitedUserPosts.clear();
    emit(GetVisitedUserPostsLoadingState());
    getUserPostLinks(userUid: userUid).then((links) {
      for (String link in links) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(link)
            .get()
            .then((value) {
          if (value.exists) {
            visitedUserPosts.add(PostModel.fromJson(value.data()!));
            visitedUserPosts.sort((a, b) => DateTime.parse(b.postDate)
                .compareTo(DateTime.parse(a.postDate)));
            pint(visitedUserPosts.length);
            pint(visitedUserPosts.first.name);
            emit(GetVisitedUserPostsSuccessState());
          }
        }).catchError((e) {
          pint("Document does not exist for link: $link");
          pint(e.toString());
          emit(GetVisitedUserPostsErrorState(e.toString()));
        });
      }
    });
  }

  Future<LoginModel?> searchForUser({
    required String userUid,
  }) async {
    emit(SearchForUserLoadingState());
    user = undefinedUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .get()
        .then((value) {
      if (value.data() != null) {
        user = LoginModel.fromJson(value.data()!);
      } else {
        user = undefinedUser;
      }
      emit(SearchForUserSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(SearchForUserErrorState(onError.toString()));
    });
    return user;
  }
}

