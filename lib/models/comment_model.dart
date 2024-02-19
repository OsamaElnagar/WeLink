class CommentModel {
  late String name = '';
  late String profileImage = '';
  late String uId = '';
  late String commentUid = '';
  late String commentText = '';
  late String? commentImage = '';
  late String commentDate = '';

  CommentModel({
    required this.name,
    required this.profileImage,
    required this.uId,
    required this.commentUid,
    required this.commentText,
    required this.commentImage,
    required this.commentDate,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profileImage'];
    uId = json['uId'];
    commentUid = json['commentUid'];
    commentText = json['commentText'];
    commentImage = json['commentImage'];
    commentDate = json['commentDate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImage': profileImage,
      'uId': uId,
      'commentUid': commentUid,
      'commentText': commentText,
      'commentImage': commentImage,
      'commentDate': commentDate,
    };
  }
}
