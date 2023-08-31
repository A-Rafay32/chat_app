import 'dart:io';

import 'package:chat_app/core/utils/pick_images.dart';
import 'package:chat_app/core/utils/snackbar.dart';
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

  static XFile? selectedImage;

  static void onSendImages(Reference ref, String RoomId) async {
    try {
      String downloadUrl = '';
      // Directory appDir = await getApplicationDocumentsDirectory();
      XFile? pickedFile = await PickImage().pickImage(ImageSource.gallery);
      // "$RoomId/${file.name}"
      if (pickedFile != null) {
        selectedImage = pickedFile;
        final task =
            await ref.child("$RoomId/").putFile(File(selectedImage!.path));

        //get Download url
        downloadUrl = await ref.getDownloadURL();
        print("downloadUrl: $downloadUrl");
        print("RoomId: $RoomId");

        //add Message object to firestore
        await Database.chatRoomCollection.doc(RoomId).collection("chats").add({
          "sendBy": Auth().auth.currentUser?.displayName,
          "text": downloadUrl.toString(),
          "time": Timestamp.now(),
        }).then((value) {
          print("Image ${selectedImage!.name} have been Uploaded");
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

  static void updateUserProfileImg(context) async {
    String downloadUrl = '';
    try {
      QuerySnapshot user = await Database.usersCollection
          .where("email", isEqualTo: Auth().auth.currentUser?.email ?? "")
          .get();

      XFile? file = await PickImage().pickImage(ImageSource.gallery);
      if (file != null) {
        selectedImage = file;

        final storageRef = FirebaseStorage.instance
            .ref("userprofile/${Auth().auth.currentUser?.displayName}")
            .child(selectedImage!.name);

        final task = storageRef.putFile(File(selectedImage!.path));

        downloadUrl = await storageRef.getDownloadURL();

        await Database.usersCollection
            .doc(user.docs.first.id)
            .update({"profileImg": downloadUrl});

        await Auth().auth.currentUser?.updatePhotoURL(downloadUrl);
        successSnackBar(context, "Profile Image updated");
      }
    } on FirebaseException catch (e) {
      errorSnackBar(context, "Couldnot update Image");
      print("could not update user ProfileImg $e");
    }
  }
}
