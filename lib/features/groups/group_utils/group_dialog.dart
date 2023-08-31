import "package:chat_app/core/utils/snackbar.dart";
import "package:chat_app/res/colors.dart";
import "package:flutter/material.dart";

import '../model/group_database.dart';

Future<dynamic> showGroupInfoDialog({context, name, admin, members}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.start,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
      actions: [
        TextButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 229, 104, 102))),
            onPressed: () {},
            child: const SizedBox(
              width: 150,
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Exit group",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )),
      ],
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(20),
      elevation: 2,
      content: Container(
        // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Group Name : $name",
                style: const TextStyle(color: Colors.black, fontSize: 18)),
            const SizedBox(
              height: 20,
            ),
            Text("Group Admin : $admin",
                style: const TextStyle(color: Colors.black, fontSize: 18)),
            const SizedBox(
              height: 20,
            ),
            Text("Group Members :$members  ",
                style: const TextStyle(color: Colors.black, fontSize: 18)),
          ],
        ),
      ),
    ),
  );
}

Future<dynamic> showCreateGroupDialog(
    context, TextEditingController controller) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        TextButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                backgroundColor: MaterialStatePropertyAll(primaryColor)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
        TextButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                backgroundColor: MaterialStatePropertyAll(primaryColor)),
            onPressed: () {
              // create group
              if (controller.text.isNotEmpty) {
                GroupDB.createGroup(controller.text.trim(), context);
                //showSnackbar
                successSnackBar(
                    context, "Group: ${controller.text.trim()}  created");
                controller.clear();
                Navigator.pop(context);
              }
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ))
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(20),
      elevation: 2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Create Group",
              style: TextStyle(color: Colors.black, fontSize: 21)),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.black87,
            controller: controller,
            decoration: TextFieldDecoration(),
          )
        ],
      ),
    ),
  );
}

InputDecoration TextFieldDecoration() {
  return const InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54),
      gapPadding: 10,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54),
      gapPadding: 10,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54),
      gapPadding: 10,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}
