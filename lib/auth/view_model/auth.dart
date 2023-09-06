import 'package:chat_app/auth/view/login.dart';
import 'package:chat_app/core/view/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/model/data/database.dart';
import '../../core/model/model.dart';
import '../../core/utils/snackbar.dart';

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
      print("email : ${emailController.text.trim()}");
      print("pass :${passController.text.trim()}");
      await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim());
      print("${emailController.text.trim()} logged in");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } on FirebaseAuthException catch (e) {
      errorSnackBar(context, e.message);
      print(e);
    }
  }

  Future signUp(context) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection("users")
          .where("email", isEqualTo: emailController.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("user with ${emailController.text.trim()} already exist");
      }
      user = (await auth.createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passController.text.trim()))
          .user;

      if (user != null) {
        UserModel userModel = UserModel(
            status: "Unavailable",
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            profileImg: "",
            groups: [""],
            recentMsg: Message(text: "", time: Timestamp.now(), sendBy: ""),
            password: passController.text.trim());

        // add user document
        await Database.usersCollection
            .add(UserModel.toJson(userModel))
            .then((value) {
          print("user : ${UserModel.toJson(userModel)} created ");
          user!.updateDisplayName(nameController.text.trim());
        });

        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const HomeScreen(),
        //     ));

        //pop out of Sign Up Screen
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      errorSnackBar(context, e.message);
      print("Error Login In, Make");
      print("FirebaseException: ${e.message}");
    }
    // notifyListeners();
  }

  Future forgotPassword(String email, context) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      successSnackBar(context, "Password reset email sent");
    } on FirebaseAuthException catch (e) {
      errorSnackBar(context, "Could not recover password");
      print("Could not recover password${e.message}");
    }
  }

  Future signOut(context) async {
    try {
      await auth.signOut();
      print("${auth.currentUser?.email} signed out");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    } on FirebaseAuthException catch (e) {
      errorSnackBar(context, e.message);
      print(e);
    } 
  }
}
