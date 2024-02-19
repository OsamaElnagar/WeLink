part of 'post_cubit.dart';

@immutable
abstract class PostStates {}

class PostInitialState extends PostStates {}

class PostCIState extends PostStates {}

class PostPickGalleryImageSuccessState extends PostStates {}

class PostPickGalleryImageErrorState extends PostStates {}

class PostPickCameraImageSuccessState extends PostStates {}

class PostPickCameraImageErrorState extends PostStates {}

class PostUndoPickPostImageSuccessState extends PostStates {}

class PostCreatePostLoadingState extends PostStates {}

class PostCreatePostSuccessState extends PostStates {}

class PostCreatePostErrorState extends PostStates {
  final String error;

  PostCreatePostErrorState(this.error);
}

class PostUploadImageLoadingState extends PostStates {}

class PostUploadImageSuccessState extends PostStates {}

class PostUploadImageErrorState extends PostStates {
  final String error;

  PostUploadImageErrorState(this.error);
}


class PostUploadVideoLoadingState extends PostStates {}

class PostUploadVideoSuccessState extends PostStates {}
class PostUploadSuccessState extends PostStates {}

class PostUploadVideoErrorState extends PostStates {
  final String error;

  PostUploadVideoErrorState(this.error);
}


class PostClearImageListSuccessState extends PostStates {}

class PostLikeState extends PostStates {}

class PostDislikeState extends PostStates {}

class PickGalleryVideoSuccessState extends PostStates {}

class PickGalleryVideoErrorState extends PostStates {}

class PickCameraVideoSuccessState extends PostStates {}

class PickCameraVideoErrorState extends PostStates {}


class PostGetPostLoadingState extends PostStates {}

class PostGetPostSuccessState extends PostStates {}

class PostGetPostErrorState extends PostStates {
  final String error;

  PostGetPostErrorState(this.error);
}