class PostModel {
   String name = '';
   String postUid = '';
   String profileImage = '';
   String postDate = '';
   String postText = '';
   String? userUid = '';
   String? postImage = '';
   String? videoLink = '';
   List<dynamic> postLikes = []; // list of string values
   Map<String,dynamic> postComments = {};
   List<dynamic> postShares = []; // list of string values

  PostModel({
    required this.name,
    required this.postUid,
    required this.userUid,
    required this.profileImage,
    required this.postDate,
    required this.postText,
    required this.postImage,
    required this.postLikes,
    required this.postComments,
    required this.postShares,
    required this.videoLink,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    postUid = json['postUid'];
    userUid = json['userUid'];
    profileImage = json['profileImage'];
    postDate = json['postDate'];
    postText = json['postText'];
    postImage = json['postImage'];
    postLikes = json['postLikes'];
    postComments = json['postComments'];
    postShares = json['postShares'];
    videoLink = json['videoLink'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'postUid': postUid,
      'userUid': userUid,
      'profileImage': profileImage,
      'postDate': postDate,
      'postText': postText,
      'postImage': postImage,
      'postLikes': postLikes,
      'postComments': postComments,
      'postShares': postShares,
      'videoLink': videoLink,
    };
  }
}
