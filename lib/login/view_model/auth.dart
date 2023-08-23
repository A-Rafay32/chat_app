import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';

class Auth extends ChangeNotifier {
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference? usersCollection;

  bool isSignIn = false;

  Future signIn(context) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim());
      print("${emailController.text.trim()} logged in");
      isSignIn = true;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
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
        User? user = (await auth.createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passController.text.trim()))
            .user;

        if (user != null) {
          usersCollection = firestore.collection('users');
          usersCollection?.add({
            'messages': [],
            'groups': [],
            'status': "Unavailable",
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'password': passController.text.trim(),
          }).then((value) {
            print("user : ${nameController.text} created ");
            user.updateDisplayName(nameController.text.trim());
          }).catchError((error) => print("failed to create user: $error"));
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
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
      isSignIn = false;
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
