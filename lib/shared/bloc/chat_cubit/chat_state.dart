part of 'chat_cubit.dart';

@immutable
abstract class ChatStates {}

class ChatInitial extends ChatStates {}

class ChatCIState extends ChatStates {}

class ChaInitUserLoadingState extends ChatStates {}

class ChatInitUserSuccessState extends ChatStates {}

class ChatSendMessageLoadingState extends ChatStates {}

class ChatSendMessageSuccessState extends ChatStates {}

class ChatSendMessageErrorState extends ChatStates {
  final String error;

  ChatSendMessageErrorState(this.error);
}

class ChatSendMessageWithImageLoadingState extends ChatStates {}

class ChatSendMessageWithImageSuccessState extends ChatStates {}

class ChatSendMessageWithImageErrorState extends ChatStates {
  final String error;

  ChatSendMessageWithImageErrorState(this.error);
}

class ChatGetMessageSuccessState extends ChatStates {}

class ChatGetMessageErrorState extends ChatStates {
  final String error;

  ChatGetMessageErrorState(this.error);
}

class ChatSetMessageSeenLoadingState extends ChatStates {}

class ChatSetMessageSeenSuccessState extends ChatStates {}

class ChatSetMessageSeenErrorState extends ChatStates {
  final String error;

  ChatSetMessageSeenErrorState(this.error);
}

class ChatGetGalleryImageSuccessState extends ChatStates {}

class ChatGetGalleryImageErrorState extends ChatStates {}

class ChatGetCameraImageSuccessState extends ChatStates {}

class ChatGetCameraImageErrorState extends ChatStates {}

class ChatUndoGetMessageImageSuccessState extends ChatStates {}

class ChatGetLastMessageLoadingState extends ChatStates {}

class ChatGetLastMessageSuccessState extends ChatStates {}

class ChatGetLastMessageErrorState extends ChatStates {
  final String error;

  ChatGetLastMessageErrorState(this.error);
}



class ChatGetChatsByUserLoadingState extends ChatStates {}

class ChatGetChatsByUserSuccessState extends ChatStates {}

class ChatGetChatsByUserErrorState extends ChatStates {
  final String error;

  ChatGetChatsByUserErrorState(this.error);
}
