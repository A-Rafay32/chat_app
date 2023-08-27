import 'package:chat_app/core/model/model.dart';

class Group {
  String admin;
  String groupImg;
  String groupName;
  String groupRoomId;
  List<dynamic> members;
  Message recentMsg;

  Group(
      {required this.admin,
      required this.members,
      required this.groupImg,
      required this.groupName,
      required this.groupRoomId,
      required this.recentMsg});

  static Map<String, dynamic> toMap(Group group) {
    return {
      "admin": group.admin,
      "members": group.members,
      "groupImg": group.groupImg,
      "groupName": group.groupName,
      "groupRoomId": group.groupRoomId,
      "recentMsg": Message.toJson(group.recentMsg),
    };
  }
}
