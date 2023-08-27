import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatType { one2one, group }

class UserModel {
  String profileImg;
  String name;
  String email;
  String status;
  List<dynamic> groups;
  Message recentMsg;
  String password;

  UserModel(
      {required this.status,
      required this.name,
      required this.email,
      required this.profileImg,
      required this.groups,
      required this.recentMsg,
      required this.password});

  static Map<String, dynamic> toJson(UserModel user) {
    return {
      "password": user.password,
      "profileImg": user.profileImg,
      "name": user.name,
      "email": user.email,
      "status": user.status,
      "groups": user.groups,
      "recentMsg": Message.toJson(user.recentMsg),
    };
  }

  static UserModel fromJson(Map<String, dynamic> user) {
    return UserModel(
        status: user["status"],
        name: user["name"],
        email: user["email"],
        profileImg: user["profileImg"],
        groups: user["groups"],
        recentMsg: Message.fromJson(user["recentMsg"]),
        password: user["status"]);
  }
}

class chatRoom {
  String chatRoomId;
  List<Message> chats;

  chatRoom({required this.chatRoomId, required this.chats});
}

class Message {
  String text;
  Timestamp time;
  String sendBy;

  Message({
    required this.text,
    required this.time,
    required this.sendBy,
  });

  static Message fromJson(Map<String, dynamic> map) {
    return Message(text: map["text"], time: map["time"], sendBy: map["sendBy"]);
  }

  static Map<String, dynamic> toJson(Message msg) {
    return {
      "text": msg.text,
      "sendBy": msg.sendBy,
      "time": msg.time,
    };
  }
}
