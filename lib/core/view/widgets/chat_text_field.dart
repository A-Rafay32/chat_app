import 'package:flutter/material.dart';

import '../../../features/groups/model/group_database.dart';
import '../../../res/colors.dart';
import '../../model/data/database.dart';
import '../../model/data/images_db.dart';
import '../../model/model.dart';
import '../chat_screen.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    required this.h,
    required this.w,
    required this.widget,
  });

  final double h;
  final double w;
  final ChatScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: h * 0.06,
          width: w * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            style: const TextStyle(fontSize: 18, color: Colors.white),
            cursorColor: Colors.white,
            cursorHeight: 18,
            controller: Database.msgController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                suffixIcon: IconButton(
                    onPressed: () {
                      widget.chatType == ChatType.group
                          ? ImageDB.onSendImages(
                              ImageDB().groupRef, widget.documentId, context)
                          : ImageDB.onSendImages(ImageDB().chatRoomRef,
                              widget.documentId, context);
                    },
                    icon: const Icon(Icons.image)),
                suffixIconColor: Colors.white,
                prefixIconColor: Colors.white,
                prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                filled: true,
                fillColor: primaryColor),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration:
              const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
          child: IconButton(
              onPressed: () {
                widget.chatType == ChatType.group
                    ? GroupDB.onSendMessage(widget.documentId)
                    : Database.onSendMessage(
                        widget.documentId, widget.objectMap["name"]);
              },
              icon: const Icon(color: Colors.white, Icons.send)),
        )
      ],
    );
  }
}
