import 'dart:io';

import 'package:chat_app/core/model/model.dart';
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

  static void onSendImages(
      Reference ref, String RoomId, context, ChatType chatType) async {
    try {
      String downloadUrl = '';
      // Directory appDir = await getApplicationDocumentsDirectory();
      XFile? pickedFile = await PickImage().pickImage(ImageSource.gallery);
      // "$RoomId/${file.name}"
      if (pickedFile != null) {
        selectedImage = pickedFile;
        final storageRef =
            ref.child("$RoomId/").child("${selectedImage!.name}/");
        await storageRef.putFile(File(selectedImage!.path));
        //get Download url
        downloadUrl = await storageRef.getDownloadURL();

        print("downloadUrl: $downloadUrl");
        print("RoomId: $RoomId");

        //add Message object to firestore
        if (chatType == ChatType.group) {
          await Database.groupCollection.doc(RoomId).collection("chats").add({
            "sendBy": Auth().auth.currentUser?.displayName,
            "text": downloadUrl.toString(),
            "time": Timestamp.now(),
          }).then((value) {
            print("Image ${selectedImage!.name} have been Uploaded");
            return null;
          });
        } else {
          await Database.chatRoomCollection
              .doc(RoomId)
              .collection("chats")
              .add({
            "sendBy": Auth().auth.currentUser?.displayName,
            "text": downloadUrl.toString(),
            "time": Timestamp.now(),
          }).then((value) {
            print("Image ${selectedImage!.name} have been Uploaded");
            return null;
          });
        }
      } else {
        //snackbar
        errorSnackBar(context, "Failed to send the image");
        print("Failed to Pick the Image");
      }
    } on FirebaseException catch (e) {
      errorSnackBar(context, "Could not send the image");
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

        await storageRef.putFile(File(selectedImage!.path));

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

  static void updateGroupImg(context, String groupName) async {
    String downloadUrl = '';
    try {
      QuerySnapshot group = await Database.groupCollection
          .where("groupName", isEqualTo: groupName)
          .get();

      XFile? file = await PickImage().pickImage(ImageSource.gallery);
      if (file != null) {
        selectedImage = file;

        final storageRef = FirebaseStorage.instance
            .ref("groups/$groupName")
            .child(selectedImage!.name);

        await storageRef.putFile(File(selectedImage!.path));

        downloadUrl = await storageRef.getDownloadURL();

        await Database.groupCollection
            .doc(group.docs.first.id)
            .update({"groupImg": downloadUrl});

        successSnackBar(context, "Group Image updated");
      }
    } on FirebaseException catch (e) {
      errorSnackBar(context, "Could not update Image");
      print("could not update group Img $e");
    }
  }
}
