import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../auth/view_model/auth.dart';

class Database {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference chatRoomCollection =
      FirebaseFirestore.instance.collection("chatroom");

  static TextEditingController msgController = TextEditingController();

  static Stream<QuerySnapshot>? chats;

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
    return user.docs[0].data();
  }

  static void onSendMessage(String chatRoomId) async {
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> msgMap = {
        "sendBy": Auth().auth.currentUser?.displayName,
        "message": msgController.text.trim(),
        "time": Timestamp.now(),
      };

      await firebaseFirestore
          .collection("chatroom")
          .doc(chatRoomId)
          .collection("chats")
          .add(msgMap);
      print("$msgMap sent");
      // msgMap.clear();
      msgController.clear();
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
}
