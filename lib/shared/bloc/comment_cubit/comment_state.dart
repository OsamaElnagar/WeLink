part of 'comment_cubit.dart';

@immutable
abstract class CommentStates {}

class CommentInitial extends CommentStates {}

class CommentCIState extends CommentStates {}

class CreateCommentLoadingState extends CommentStates {}

class CreateCommentSuccessState extends CommentStates {}

class CreateCommentErrorState extends CommentStates {
  final String error;

  CreateCommentErrorState(this.error);
}

class GetCommentLoadingState extends CommentStates {}

class GetCommentSuccessState extends CommentStates {}

class GetCommentErrorState extends CommentStates {
  final String error;

  GetCommentErrorState(this.error);
}

class CreateCommentReplyLoadingState extends CommentStates {}

class CreateCommentReplySuccessState extends CommentStates {}

class CreateCommentReplyErrorState extends CommentStates {
  final String error;

  CreateCommentReplyErrorState(this.error);
}

class GetCommentReplyLoadingState extends CommentStates {}

class GetCommentReplySuccessState extends CommentStates {}

class GetCommentReplyErrorState extends CommentStates {
  final String error;

  GetCommentReplyErrorState(this.error);
}

class StoreReplyLoadingState extends CommentStates {}

class StoreReplySuccessState extends CommentStates {}

class StoreReplyErrorState extends CommentStates {
  final String error;

  StoreReplyErrorState(this.error);
}

class GetStoredReplyLoadingState extends CommentStates {}

class GetStoredReplySuccessState extends CommentStates {
  final String commentId;

  GetStoredReplySuccessState(this.commentId);
}

class GetStoredReplyErrorState extends CommentStates {
  final String error;

  GetStoredReplyErrorState(this.error);
}

class GetGalleryImageSuccessState extends CommentStates {}

class GetGalleryImageErrorState extends CommentStates {}

class GetCameraImageSuccessState extends CommentStates {}

class GetCameraImageErrorState extends CommentStates {}

class UndoGetCommentImageSuccessState extends CommentStates {}
