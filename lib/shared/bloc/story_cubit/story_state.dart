part of 'story_cubit.dart';

@immutable
abstract class StoryStates {}
class StoryInitialSate extends StoryStates {}


class StoryGetUserDataLoadingState extends StoryStates {}

class StoryGetUserDataSuccessState extends StoryStates {}

class StoryGetUserDataErrorState extends StoryStates {
  final String error;

  StoryGetUserDataErrorState(this.error);
}
class StoryGetGalleryImageSuccessState extends StoryStates {}

class StoryGetGalleryImageErrorState extends StoryStates {}

class StoryGetCameraImageSuccessState extends StoryStates {}

class StoryGetCameraImageErrorState extends StoryStates {}

class StoryUndoGetStoryImageSuccessState extends StoryStates {}


class StoryUploadImageLoadingSate extends StoryStates {}

class StoryUploadImageSuccessSate extends StoryStates {}

class StoryUploadImageErrorSate extends StoryStates {
  final String error;

  StoryUploadImageErrorSate(this.error);
}

class StoryUploadToFireLoadingSate extends StoryStates {}

class StoryGetLoadingSate extends StoryStates {}

class StoryGetSuccessSate extends StoryStates {}

class StoryGetErrorSate extends StoryStates {
  final String error;

  StoryGetErrorSate(this.error);
}
