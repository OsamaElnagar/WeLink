class LoginModel {
  String name = '';
  String phone = '';
  String email = '';
  String bio = '';
  String profileImage = '';
  String profileCover = '';
  String uId = '';
  String receiverFCMToken = '';

  LoginModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.bio,
    required this.profileImage,
    required this.profileCover,
    required this.uId,
    required this.receiverFCMToken,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    bio = json['bio'];
    profileImage = json['profileImage'];
    profileCover = json['profileCover'];
    uId = json['uId'];
    receiverFCMToken = json['receiverFCMToken'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'bio': bio,
      'profileImage': profileImage,
      'profileCover': profileCover,
      'uId': uId,
      'receiverFCMToken': receiverFCMToken,
    };
  }
}
