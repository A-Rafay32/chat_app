import 'package:chat_app/core/model/data/database.dart';
import 'package:chat_app/core/utils/snackbar.dart';
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
            members: data.docs[index]["members"] as List,
            groupRoomId: data.docs[index].id,
            groupImg: data.docs[index]["groupImg"],
            groupName: data.docs[index]["groupName"],
            recentMsg: Message.fromJson(data.docs[index]["recentMsg"])));
  }

  static void onSendMessage(String groupRoomId) async {
    if (Database.msgController.text.isNotEmpty) {
      Map<String, dynamic> msgMap = {
        "sendBy": Auth().auth.currentUser?.displayName,
        "text": Database.msgController.text.trim(),
        "time": Timestamp.now(),
      };
      // msgMap.clear();
      Database.msgController.clear();

      //add message to db
      await Database.firebaseFirestore
          .collection("groups")
          .doc(groupRoomId)
          .collection("chats")
          .add(msgMap);

      // update recent message in both users

      await Database.firebaseFirestore
          .collection("groups")
          .doc(groupRoomId)
          .update({"recentMsg": msgMap});

      print("$msgMap sent");
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

  static void createGroup(String groupName, context) async {
    try {
      //create group
      DocumentReference groupDoc = await groupCollection.add({
        "admin": Auth().auth.currentUser!.displayName,
        "members": ["${Auth().auth.currentUser!.displayName}"],
        "groupImg": "",
        "groupName": groupName,
        "recentMsg": {"sendBy": "", "time": Timestamp.now(), "text": ""}
      });

      // //update id
      // await groupDoc.update({"groupRoomId": groupDoc.id});

      //update group array in user/admin
      QuerySnapshot user = await Database.usersCollection
          .where("email", isEqualTo: Auth().auth.currentUser!.email)
          .limit(1)
          .get();

      await Database.usersCollection.doc(user.docs.first.id).update({
        "groups": FieldValue.arrayUnion([groupDoc.id])
      });
    } on FirebaseException catch (e) {
      errorSnackBar(context, "Failed to create Group: $groupName");
      print("Group creation Failed : ${e.message}");
    }
  }

  static Future<List> addMemberInGroup(
      {context, groupDocId, memberEmail, memberName}) async {
    List groupMembers = [];
    try {
      QuerySnapshot memberSnapshot = await Database.usersCollection
          .where("email", isEqualTo: memberEmail)
          .get();

      QuerySnapshot groupSnapshot = await groupCollection
          .where("members", arrayContains: memberName)
          .get();

      if (memberSnapshot.docs.isNotEmpty) {
        // update user's group field
        await Database.usersCollection
            .doc(memberSnapshot.docs.first.id)
            .update({
          "groups": FieldValue.arrayUnion([groupDocId])
        }).then((value) {
          print("group: $groupDocId added in user's groups field");
          return null;
        });

        //update group's member field
        await groupCollection.doc(groupDocId).update({
          "members": FieldValue.arrayUnion([memberName])
        }).then((value) {
          print("$memberName added in group's member field");
          return null;
        });

        groupCollection.doc(groupDocId).get().then(
          (DocumentSnapshot snapshot) {
            groupMembers = snapshot.get("members");
          },
        );

        successSnackBar(context,
            "$memberName added to the ${groupSnapshot.docs.first["groupName"]}");
      } else {
        print("Couldnot fetch member ${memberSnapshot.docs.first.data()} ");
      }
    } on FirebaseException catch (e) {
      errorSnackBar(context, "Failed to add $memberName");
      print("Couldn't add member $memberEmail: $e");
    }
    return groupMembers;
  }

  static Future<List> getGroupMembers(String groupDocId) async {
    List groupMembers = [];
    await groupCollection
        .doc(groupDocId)
        .get()
        .then((DocumentSnapshot snapshot) {
      groupMembers = snapshot.get("members");
    });
    return groupMembers;
  }

  static Future<String?> getUserImage(String userName) async {
    String? profileImg = "";
    QuerySnapshot user =
        await Database.usersCollection.where("name", isEqualTo: userName).get();
    profileImg = user.docs.first.get("profileImg");

    return profileImg ?? "";
  }
}
