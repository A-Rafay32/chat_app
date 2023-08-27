import "package:chat_app/res/colors.dart";
import "package:flutter/material.dart";

import "model/group_database.dart";

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
                GroupDB.createGroup(controller.text.trim());
                controller.clear();
                Navigator.pop(context);
              }

              //showSnackbar
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
