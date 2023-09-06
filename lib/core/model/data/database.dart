import 'package:chat_app/core/model/model.dart';
import 'package:chat_app/core/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/view_model/auth.dart';

class Database {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  static CollectionReference chatRoomCollection =
      FirebaseFirestore.instance.collection("chatroom");

  static TextEditingController msgController = TextEditingController();

  static Stream<QuerySnapshot>? chats;
  static List<UserModel>? userList;

  static String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  static Future<Map<String, dynamic>> getUser(String name) async {
    QuerySnapshot<Map<String, dynamic>> user = await firebaseFirestore
        .collection("users")
        .where("name", isEqualTo: name)
        .get();
    return user.docs.first.data();
  }

  static Future<QuerySnapshot> getUserQuerySnapshot(String name) async {
    return await firebaseFirestore
        .collection("users")
        .where("name", isEqualTo: name)
        .get();
  }

  static void onSendMessage(String chatRoomId, String receiverName) async {
    QuerySnapshot userSender =
        await getUserQuerySnapshot(Auth().auth.currentUser?.displayName ?? "");
    QuerySnapshot userReceiver = await getUserQuerySnapshot(receiverName);

    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> msgMap = {
        "sendBy": Auth().auth.currentUser?.displayName,
        "text": msgController.text.trim(),
        "time": Timestamp.now(),
      };

      msgController.clear();
      // add message to db
      await firebaseFirestore
          .collection("chatroom")
          .doc(chatRoomId)
          .collection("chats")
          .add(msgMap);
      print("$msgMap sent");

      // update recent message in both users
      if (userSender.docs.isNotEmpty) {
        await firebaseFirestore
            .collection("users")
            .doc(userSender.docs.first.id)
            .update({"recentMsg": msgMap});
      }
      if (userReceiver.docs.isNotEmpty) {
        await firebaseFirestore
            .collection("users")
            .doc(userReceiver.docs.first.id)
            .update({"recentMsg": msgMap});
      }

      // msgMap.clear();
    } else {
      print("Can't send empty messages");
    }
  }

  static void getMessages(String chatRoomId) {
    chats = firebaseFirestore
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .snapshots();
  }

  static void getUsersList() async {
    QuerySnapshot data = await usersCollection.get();

    userList = List.generate(
        data.docs.length,
        (index) => UserModel(
            status: data.docs[index]["status"],
            name: data.docs[index]["name"],
            email: data.docs[index]["email"],
            profileImg: data.docs[index]["profileImg"],
            groups: data.docs[index]["groups"] as List,
            recentMsg: Message.fromJson(data.docs[index]["recentMsg"]),
            password: data.docs[index]["password"]));
  }

  // static void getUser() async {
  //   QuerySnapshot user = await usersCollection
  //       .where("email", isEqualTo: Auth().auth.currentUser?.email ?? "")
  //       .get();
  //   Map<String, dynamic> map = user.docs.first.data() as Map<String, dynamic>;

  //   Auth.userStatus = map["status"];

  //   print("user Status : ${Auth.userStatus}");
  // }

  static void updateUserEmail(String newEmail) async {
    try {
      QuerySnapshot user = await usersCollection
          .where("email", isEqualTo: Auth().auth.currentUser?.email ?? "")
          .limit(1)
          .get();
      await usersCollection.doc(user.docs.first.id).update({"email": newEmail});
      await Auth().auth.currentUser!.updateEmail(newEmail);
    } on FirebaseException catch (e) {
      print("error updating email : $e");
    }
  }

  static void updateUserName(String newName) async {
    try {
      QuerySnapshot user = await usersCollection
          .where("email", isEqualTo: Auth().auth.currentUser?.email ?? "")
          .limit(1)
          .get();
      await usersCollection.doc(user.docs.first.id).update({"name": newName});
      await Auth().auth.currentUser!.updateDisplayName(newName);
    } on FirebaseException catch (e) {
      print("error updating name : $e");
    }
  }

  static void updateUserStatus(String newStatus) async {
    try {
      QuerySnapshot user = await usersCollection
          .where("email", isEqualTo: Auth().auth.currentUser?.email ?? "")
          .limit(1)
          .get();
      await usersCollection
          .doc(user.docs.first.id)
          .update({"status": newStatus});
    } on FirebaseException catch (e) {
      print("error updating status : $e");
    }
  }

  static void updateUserInfo(
      String newEmail, String newName, String newStatus) {
    try {
      updateUserEmail(newEmail);
      updateUserName(newName);
      updateUserStatus(newStatus);
    } on FirebaseException catch (e) {
      print("error updating user info $e");
    }
  }

  static void getCurrentUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> user = await firebaseFirestore
          .collection("users")
          .where("name", isEqualTo: Auth().auth.currentUser?.displayName)
          .get();
      Auth.userMap = user.docs.first.data();
    } on FirebaseException catch (e) {
      print("Could not fetch current user $e");
    }
  }

  static void delCurrentUserAccount(context) async {
    try {
      // remove account
      await Provider.of<Auth>(context, listen: false)
          .auth
          .currentUser
          ?.delete();
      // remove user document
      QuerySnapshot user = await getUserQuerySnapshot(
          Auth().auth.currentUser?.displayName ?? "");
      await usersCollection.doc(user.docs.first.id).delete();
      successSnackBar(context, "Your Account Has Been Removed");
    } on FirebaseException catch (e) {
      errorSnackBar(context, "Could not perform action, Try Again");
      print("could not delete user account : ${e.message}");
    }
  }
}
