import 'package:chat_app/core/model/data/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/view_model/auth.dart';
import '../../../core/model/model.dart';
import 'group_model.dart';

class GroupDB extends Database {
  static CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  static Future<QuerySnapshot>? groups;
  static Stream<QuerySnapshot>? groupChats;
  static List<Group>? groupList;

  static void getGroups() async {
    groups = groupCollection.get();

    QuerySnapshot data = await groupCollection.get();
    groupList = List.generate(
        data.docs.length,
        (index) => Group(
            admin: data.docs[index]["admin"],
            users: data.docs[index]["users"] as List,
            groupRoomId: data.docs[index].id,
            groupImg: data.docs[index]["groupImg"],
            groupName: data.docs[index]["groupName"],
            recentMessage:
                Message.fromJson(data.docs[index]["recentMessage"])));
  }

  static void onSendMessage(String groupRoomId) async {
    if (Database.msgController.text.isNotEmpty) {
      Map<String, dynamic> msgMap = {
        "sendBy": Auth().auth.currentUser?.displayName,
        "message": Database.msgController.text.trim(),
        "time": Timestamp.now(),
      };

      await Database.firebaseFirestore
          .collection("groups")
          .doc(groupRoomId)
          .collection("chats")
          .add(msgMap);
      print("$msgMap sent");
      // msgMap.clear();
      Database.msgController.clear();
    } else {
      print("Can't send empty messages");
    }
  }

  static void getGroupMessages(String groupRoomId) {
    groupChats = Database.firebaseFirestore
        .collection("groups")
        .doc(groupRoomId)
        .collection("chats")
        .snapshots();
  }
}
