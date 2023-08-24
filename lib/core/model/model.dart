class UserModel {
  String profileImg;
  String name;
  String email;
  String status;
  List<String> groups;
  int id;

  UserModel(
      {required this.status,
      required this.name,
      required this.email,
      required this.profileImg,
      required this.groups,
      required this.id});

  Map<dynamic, dynamic> toMap(UserModel user) {
    return {
      id: user.id,
      profileImg: user.profileImg,
      name: user.name,
      email: user.email,
      status: user.status,
      groups: user.groups,
    };
  }
}

class chatRoom {
  String chatRoomId;
  List<Message> chats;

  chatRoom({required this.chatRoomId, required this.chats});
}

class Message {
  String text;
  DateTime date;
  bool isSentByMe;

  Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}
