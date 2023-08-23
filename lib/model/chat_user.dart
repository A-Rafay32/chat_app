class ChatUser {
  String photoUrl;
  String name;
  int phoneNum;
  String aboutMe;
  int id;

  ChatUser(
      {required this.aboutMe,
      required this.name,
      required this.photoUrl,
      required this.phoneNum,
      required this.id});

  Map<dynamic, dynamic> toMap() {
    return {
      id: id,
      photoUrl: photoUrl,
      name: name,
      phoneNum: phoneNum,
      aboutMe: aboutMe,
    };
  }
}
