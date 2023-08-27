import 'package:chat_app/core/model/model.dart';

class Group {
  String admin;
  String groupImg;
  String groupName;
  String groupRoomId;
  List<dynamic> users;
  Message recentMessage;

  Group(
      {required this.admin,
      required this.users,
      required this.groupImg,
      required this.groupName,
      required this.groupRoomId,
      required this.recentMessage});

  static Map<String, dynamic> toMap(Group group) {
    return {
      "admin": group.admin,
      "users": group.users,
      "groupImg": group.groupImg,
      "groupName": group.groupName,
      "groupRoomId": group.groupRoomId,
      "recentMessage": group.recentMessage,
    };
  }
}
