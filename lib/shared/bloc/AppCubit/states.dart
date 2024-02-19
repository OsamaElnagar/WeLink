abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBNBState extends AppStates {}

class AppChangeBSHeightState extends AppStates {}

class AppPlayPauseVideoState extends AppStates {}

class AppGetUserDataLoadingState extends AppStates {}

class AppGetUserDataSuccessState extends AppStates {}

class AppGetUserDataErrorState extends AppStates {
  final String error;

  AppGetUserDataErrorState(this.error);
}

class AppRefreshFeedPostState extends AppStates {}

class AppGetFeedPostLoadingState extends AppStates {}

class AppGetFeedPostSuccessState extends AppStates {}
class AppGetFeedPostNoMoreDataState extends AppStates {}

class AppFillPostCommentsSuccessState extends AppStates {}

class AppGetFeedPostErrorState extends AppStates {
  final String error;

  AppGetFeedPostErrorState(this.error);
}

class AppGetGalleryImageSuccessState extends AppStates {}

class AppGetGalleryImageErrorState extends AppStates {}

class AppGetCameraImageSuccessState extends AppStates {}

class AppGetCameraImageErrorState extends AppStates {}

class AppUndoGetMessageImageSuccessState extends AppStates {}

class AppUndoGetProfileImageSuccessState extends AppStates {}

class AppUndoGetCoverImageSuccessState extends AppStates {}

class AppUndoGetCommentImageSuccessState extends AppStates {}


class AppUndoGetPostImageErrorState extends AppStates {
  final String error;

  AppUndoGetPostImageErrorState(this.error);
}

class AppUploadPostImageSuccessState extends AppStates {}

class AppUploadPostImageErrorState extends AppStates {
  final String error;

  AppUploadPostImageErrorState(this.error);
}

class AppSignOutSuccessState extends AppStates {}

class AppSignOutErrorState extends AppStates {
  final String error;

  AppSignOutErrorState(this.error);
}

class AppCreateCommentLoadingState extends AppStates {}

class AppCreateCommentSuccessState extends AppStates {}

class AppCreateCommentErrorState extends AppStates {
  final String error;

  AppCreateCommentErrorState(this.error);
}

class AppGetCommentLoadingState extends AppStates {}

class AppGetCommentSuccessState extends AppStates {}

class AppGetCommentErrorState extends AppStates {
  final String error;

  AppGetCommentErrorState(this.error);
}

class AppCreateCommentReplyLoadingState extends AppStates {}

class AppCreateCommentReplySuccessState extends AppStates {}

class AppCreateCommentReplyErrorState extends AppStates {
  final String error;

  AppCreateCommentReplyErrorState(this.error);
}

class AppGetCommentReplyLoadingState extends AppStates {}

class AppGetCommentReplySuccessState extends AppStates {}

class AppGetCommentReplyErrorState extends AppStates {
  final String error;

  AppGetCommentReplyErrorState(this.error);
}

class AppStoreReplyLoadingState extends AppStates {}

class AppStoreReplySuccessState extends AppStates {}

class AppStoreReplyErrorState extends AppStates {
  final String error;

  AppStoreReplyErrorState(this.error);
}

class AppGetStoredReplyLoadingState extends AppStates {}

class AppGetStoredReplySuccessState extends AppStates {
  final String commentId;

  AppGetStoredReplySuccessState(this.commentId);
}

class AppGetStoredReplyErrorState extends AppStates {
  final String error;

  AppGetStoredReplyErrorState(this.error);
}

class AppLikePostSuccessState extends AppStates {}

class AppLikePostErrorState extends AppStates {
  final String error;

  AppLikePostErrorState(this.error);
}

class AppUnlikePostSuccessState extends AppStates {}

class AppUnlikePostErrorState extends AppStates {
  final String error;

  AppUnlikePostErrorState(this.error);
}

class AppLikeFeedPostSuccessState extends AppStates {}

class AppLikeFeedPostErrorState extends AppStates {
  final String error;

  AppLikeFeedPostErrorState(this.error);
}

class AppUnlikeFeedPostSuccessState extends AppStates {}

class AppUnlikeFeedPostErrorState extends AppStates {
  final String error;

  AppUnlikeFeedPostErrorState(this.error);
}

class AppFillCommentCounterSuccessState extends AppStates {}

class AppFillCommentCounterErrorState extends AppStates {
  final String error;

  AppFillCommentCounterErrorState(this.error);
}

class AppUpdateProfileImageLoadingState extends AppStates {}

class AppUpdateProfileImageSuccessState extends AppStates {}

class AppUpdateProfileImageErrorState extends AppStates {
  final String error;

  AppUpdateProfileImageErrorState(this.error);
}

class AppUpdateCoverImageLoadingState extends AppStates {}

class AppUpdateCoverImageSuccessState extends AppStates {}

class AppUpdateCoverImageErrorState extends AppStates {
  final String error;

  AppUpdateCoverImageErrorState(this.error);
}

class AppUpdateProfileLoadingState extends AppStates {}

class AppUpdateProfileSuccessState extends AppStates {}

class AppUpdateProfileErrorState extends AppStates {
  final String error;

  AppUpdateProfileErrorState(this.error);
}

class AppCreateStoryLoadingState extends AppStates {}

class AppCreateStorySuccessState extends AppStates {}

class AppCreateStoryErrorState extends AppStates {
  final String error;

  AppCreateStoryErrorState(this.error);
}

class AppCreateStoryImageLoadingState extends AppStates {}

class AppCreateStoryImageSuccessState extends AppStates {}

class AppCreateStoryImageErrorState extends AppStates {
  final String error;

  AppCreateStoryImageErrorState(this.error);
}

class AppGetStoryLoadingState extends AppStates {}

class AppGetStorySuccessState extends AppStates {}

class AppGetStoryErrorState extends AppStates {
  final String error;

  AppGetStoryErrorState(this.error);
}

class AppWannaSearchSuccessState extends AppStates {}

class AppWannaSearchErrorState extends AppStates {
  final String error;

  AppWannaSearchErrorState(this.error);
}

class AppUpdateStoryIndexSuccessState extends AppStates {}

class AppSwipeLeftState extends AppStates {}

class AppSwipeRightState extends AppStates {}


class AppModifyPostLoadingState extends AppStates {}

class AppModifyPostSuccessState extends AppStates {}

class AppModifyPostErrorState extends AppStates {
  final String error;

  AppModifyPostErrorState(this.error);
}



class AppCIState extends AppStates {}
class SplashAssetsState extends AppStates {}
class SplashAssetsErrorState extends AppStates {
  final String error;

  SplashAssetsErrorState(this.error);
}
