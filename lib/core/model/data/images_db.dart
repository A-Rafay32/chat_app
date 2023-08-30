import 'dart:io';

import 'package:chat_app/core/utils/pick_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/view_model/auth.dart';
import 'database.dart';

class ImageDB {
  final Reference storageRef = FirebaseStorage.instance.ref();
  static Reference userProfileRef =
      FirebaseStorage.instance.ref().child("userprofile");
  final Reference chatRoomRef =
      FirebaseStorage.instance.ref().child("chatroom");
  final Reference groupRef = FirebaseStorage.instance.ref().child("groups");

  void onSendImages(Reference ref, String RoomId) async {
    try {
      // Directory appDir = await getApplicationDocumentsDirectory();
      XFile? file = await PickImage().pickImage(ImageSource.gallery);
      // "$RoomId/${file.name}"
      if (file != null) {
        final task =
            await ref.child("$RoomId/${file.name}").putFile(File(file.path));

        //get Download url
        String downloadUrl = await ref.getDownloadURL();
        print("downloadUrl: $downloadUrl");
        print("RoomId: $RoomId");

        //add Message object to firestore
        await Database.chatRoomCollection.doc(RoomId).collection("chats").add({
          "sendBy": Auth().auth.currentUser?.displayName,
          "text": downloadUrl.toString(),
          "time": Timestamp.now(),
        }).then((value) {
          print("Image ${file.name} have been Uploaded");
          return null;
        });
      } else {
        //snackbar
        print("Failed to Pick the Image");
      }
    } on FirebaseException catch (e) {
      print("Image failed to upload $e");
    }
  }

  static void updateUserProfileImg() async {
    try {
      QuerySnapshot user = await Database.usersCollection
          .where("email", isEqualTo: Auth().auth.currentUser?.email ?? "")
          .get();

      XFile? file = await PickImage().pickImage(ImageSource.gallery);
      if (file != null) {
        final ref = FirebaseStorage.instance
            .ref("userprofile/${Auth().auth.currentUser?.displayName}");
        await ref.putFile(File(file.path));
        String newImage = await userProfileRef.getDownloadURL();
        await Database.usersCollection
            .doc(user.docs.first.id)
            .update({"profileImg": newImage});
        await Auth().auth.currentUser?.updatePhotoURL(newImage);
      }
    } on FirebaseException catch (e) {
      print("could not update user ProfileImg $e");
    }
  }
}
