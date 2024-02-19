class ChatsModel {
  late String senderId = '';
  late String receiverId = '';
  late String messageId = '';
  late String textMessage = '';
  late String imageMessage = '';
  late String messageDateTime = '';
  late bool seen = false;

  ChatsModel({
    required this.senderId,
    required this.receiverId,
    required this.messageId,
    required this.textMessage,
    required this.imageMessage,
    required this.messageDateTime,
    required this.seen,
  });

  ChatsModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    messageId = json['messageId'];
    textMessage = json['textMessage'];
    imageMessage = json['imageMessage'];
    messageDateTime = json['messageDateTime'];
    seen = json['seen'] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId': messageId,
      'textMessage': textMessage,
      'imageMessage': imageMessage,
      'messageDateTime': messageDateTime,
      'seen': seen,
    };
  }
}
