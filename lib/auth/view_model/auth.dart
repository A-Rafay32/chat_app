import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/model/data/database.dart';
import '../../core/model/model.dart';

class Auth extends ChangeNotifier {
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  static Stream<User?> authStateChanges =
      FirebaseAuth.instance.authStateChanges();

  User? user;
  bool? isSignedIn;

  Future signIn(context) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim());
      print("${emailController.text.trim()} logged in");
    } on FirebaseException catch (e) {
      print(e);
    }

    // notifyListeners();
  }

  Future signUp(context) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection("users")
          .where("email", isEqualTo: emailController.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("user with ${emailController.text.trim()} already exist");
      } else {
        user = (await auth.createUserWithEmailAndPassword(
                email: emailController.text.trim().toString(),
                password: passController.text.trim().toString()))
            .user;

        if (user != null) {
          UserModel userModel = UserModel(
              status: "Unavailable",
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              profileImg: "",
              groups: [],
              recentMsg: Message(text: "", time: Timestamp.now(), sendBy: ""),
              password: passController.text.trim());

          Database.usersCollection
              .add({UserModel.toJson(userModel)}).then((value) {
            print("user : ${nameController.text} created ");
            user!.updateDisplayName(nameController.text.trim());
          }).catchError((error) => print("failed to create user: $error"));
        }
      }
    } on FirebaseException catch (e) {
      print(e);
    }
    // notifyListeners();
  }

  Future signOut() async {
    try {
      await auth.signOut();
      print("${auth.currentUser?.email} signed out");
    } on FirebaseException catch (e) {
      print(e);
    }
    // notifyListeners();
  }
}
