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

  static User? user;
  static Map<String, dynamic>? userMap;
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

  Future signUp({context, email, password, name}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("user with $email already exist");
      }
      if (email != null && password != null) {
        user = (await auth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;

        if (user != null) {
          UserModel userModel = UserModel(
              status: "Unavailable",
              name: name,
              email: email,
              profileImg: "",
              groups: [""],
              recentMsg: Message(text: "", time: Timestamp.now(), sendBy: ""),
              password: password);

          // add user document
          await Database.usersCollection
              .add(UserModel.toJson(userModel))
              .then((value) {
            print("user : ${UserModel.toJson(userModel)} created ");
            user!.updateDisplayName(name);
          }).catchError((error) => print("failed to create user: $error"));

          //pop out of Sign Up Screen
          Navigator.pop(context);
        }
      }
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code}");
      print("FirebaseException: ${e.message}");
    }
    // notifyListeners();
  }

  Future signOut(context) async {
    try {
      await auth.signOut();
      print("${auth.currentUser?.email} signed out");
      // Navigator.popUntil(context, (route) => false);
    } on FirebaseException catch (e) {
      print(e);
    }
    // notifyListeners();
  }
}
