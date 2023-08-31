import 'package:chat_app/features/groups/group_utils/group_dialog.dart';
import 'package:flutter/material.dart';

import '../../../auth/view_model/auth.dart';
import '../../../core/view/chat_screen.dart';
import '../view/add_member_screen.dart';

class GroupPopupMenuButton extends StatelessWidget {
  const GroupPopupMenuButton({
    super.key,
    required this.widget,
  });

  final ChatScreen widget;
  String formatList(List<dynamic> list) {
    String str = "${list.join(" , ")}\t\t";
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      elevation: 2,
      itemBuilder: (context) => [
        if (Auth().auth.currentUser!.displayName == widget.objectMap["admin"])
          PopupMenuItem(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMemberScreen(
                            groupDocId: widget.documentId,
                          ),
                        ));
                  },
                  child: const Text(
                    "Add participant",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ))),
        if (Auth().auth.currentUser!.displayName == widget.objectMap["admin"])
          PopupMenuItem(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMemberScreen(
                            groupDocId: widget.documentId,
                          ),
                        ));
                  },
                  child: const Text(
                    "Set Group Image ",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ))),
        PopupMenuItem(
            child: TextButton(
                onPressed: () => showGroupInfoDialog(
                    context: context,
                    admin: widget.objectMap["admin"],
                    members: formatList(widget.objectMap["members"]),
                    name: widget.objectMap["groupName"]),
                child: const Text(
                  "See Group Info ",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                )))
      ],
    );
  }
}
