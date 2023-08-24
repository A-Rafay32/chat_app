import 'package:chat_app/auth/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/view/home_screen.dart';

class Auth extends ChangeNotifier {
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference? usersCollection;
  User? user;
  bool? isSignedIn;

  Future signIn(context) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim());
      print("${emailController.text.trim()} logged in");

      // setUserSignedStatus to true
      Helper.setUserSignedStatus(true);

      // getUserSignedStatus in isSignedIn
      isSignedIn = await Helper.getUserSignedStatus();

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } on FirebaseException catch (e) {
      print(e);
    }

    notifyListeners();
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
                email: emailController.text.trim(),
                password: passController.text.trim()))
            .user;

        if (user != null) {
          usersCollection = firestore.collection('users');
          usersCollection?.add({
            'groups': [],
            'status': "Unavailable",
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'profileImg': "",
          }).then((value) {
            print("user : ${nameController.text} created ");
            user?.updateDisplayName(nameController.text.trim());
          }).catchError((error) => print("failed to create user: $error"));
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      }
    } on FirebaseException catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future signOut() async {
    try {
      await auth.signOut();
      print("${auth.currentUser?.email} signed out");

      // setUserSignedStatus to true
      Helper.setUserSignedStatus(false);

      // getUserSignedStatus in isSignedIn
      isSignedIn = await Helper.getUserSignedStatus();
    } on FirebaseException catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
