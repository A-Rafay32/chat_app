import 'package:chat_app/auth/view_model/auth.dart';
import 'package:chat_app/core/model/data/database.dart';
import 'package:chat_app/core/model/data/images_db.dart';
import 'package:chat_app/res/colors.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({required this.image, super.key});

  String image;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    Database.getCurrentUser();
    nameController.text = Auth.userMap?["name"] ?? "";
    emailController.text = Auth.userMap?["email"] ?? "";
    statusController.text = Auth.userMap?["status"] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  Database.updateUserInfo(emailController.text,
                      nameController.text, statusController.text);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ))
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          UserProfileImageWidget(
            h: h,
            w: w,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: TextField(
              controller: nameController,
              cursorColor: Colors.black,
              decoration: TextFieldDecoration(
                  hintText: "Full Name", label: "Full Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: TextField(
              controller: emailController,
              cursorColor: Colors.black,
              decoration:
                  TextFieldDecoration(hintText: "Email", label: "Email"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: TextField(
              controller: statusController,
              cursorColor: Colors.black,
              decoration:
                  TextFieldDecoration(hintText: "Status", label: "Status"),
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: GestureDetector(
                onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        actions: [
                          TextButton(
                              style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.all(10)),
                                  backgroundColor:
                                      MaterialStatePropertyAll(primaryColor)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                          TextButton(
                              style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.all(10)),
                                  backgroundColor:
                                      MaterialStatePropertyAll(primaryColor)),
                              onPressed: () {
                                Database.delCurrentUserAccount(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ))
                        ],
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        contentPadding: const EdgeInsets.all(20),
                        elevation: 2,
                        content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Are you Sure?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 21)),
                            ]),
                      ),
                    ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_sharp,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Delete Account",
                      style:
                          TextStyle(color: Colors.red.shade400, fontSize: 19),
                    )
                  ],
                )),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  InputDecoration TextFieldDecoration({String? hintText, String? label}) {
    return InputDecoration(
      labelText: label.toString(),
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}

class UserProfileImageWidget extends StatelessWidget {
  UserProfileImageWidget({
    super.key,
    required this.h,
    required this.w,
  });

  final double h;
  final double w;
  final String image = Auth.userMap?["profileImg"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.all(10),
      height: h * 0.35,
      width: w,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 80,
            backgroundImage: image == ""
                ? Image.asset("assets/images/account.jpeg").image
                : Image.network(image).image,
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              ImageDB.updateUserProfileImg(context);
            },
            child: Row(
              children: [
                SizedBox(
                  width: w * 0.17,
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                    )),
                const Text(
                  "Add a cover photo",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
