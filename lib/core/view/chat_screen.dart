import 'package:chat_app/core/model/data/images_db.dart';
import 'package:chat_app/core/view/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../auth/view_model/auth.dart';
import '../../features/groups/group_utils/group_popup_menu.dart';
import '../../features/groups/model/group_database.dart';
import '../../res/colors.dart';
import '../model/data/database.dart';
import '../model/model.dart';

class ChatScreen extends StatefulWidget {
  // documentId is chatRoomId for ChatType.one2one
  // documentId is groupDocId for ChatType.group
  final String documentId;
  final Map<String, dynamic> objectMap;
  final ChatType chatType;

  const ChatScreen({
    super.key,
    required this.documentId,
    required this.objectMap,
    required this.chatType,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String formatList(List<dynamic> list) {
    String str = "${list.join(" , ")}\t\t";
    return str;
  }

  bool checkForImage(String image) {
    if (image.contains(".jpg") ||
        image.contains(".png") ||
        image.contains(".jpeg")) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    widget.chatType == ChatType.group
        ? GroupDB.getGroupMessages(widget.documentId)
        : Database.getMessages(widget.documentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        color: backgroundColor,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                            color: secondaryColor,
                            Icons.arrow_back_ios_new_sharp)),
                    if (widget.chatType == ChatType.group)
                      GroupPopupMenuButton(
                        widget: widget,
                      ),
                  ]),
            ),
            Positioned(
                top: 70,
                child: Container(
                  height: h * 0.9,
                  width: w,
                  decoration: const BoxDecoration(
                      color: chatBGColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              widget.chatType != ChatType.group
                                  ? "${widget.objectMap["name"]}"
                                  : "${widget.objectMap["groupName"]}",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            Text(
                                widget.chatType != ChatType.group
                                    ? "${widget.objectMap["status"]}"
                                    : formatList(widget.objectMap["members"]),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.grey.shade800))
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: widget.chatType == ChatType.group
                                ? GroupDB.groupCollection
                                    .doc(widget.documentId)
                                    .collection("chats")
                                    .snapshots()
                                : Database.chatRoomCollection
                                    .doc(widget.documentId)
                                    .collection("chats")
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: h * 0.3,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                          color: primaryColor),
                                    ),
                                  ],
                                );
                              }
                              if (snapshot.data != null) {
                                return GroupedListView<QueryDocumentSnapshot,
                                    Timestamp>(
                                  padding: const EdgeInsets.all(8),
                                  elements: snapshot.data!.docs,
                                  groupBy: (element) => element["time"],
                                  order: GroupedListOrder.ASC,
                                  groupHeaderBuilder:
                                      (QueryDocumentSnapshot messages) =>
                                          const SizedBox(),
                                  itemBuilder: (context,
                                          QueryDocumentSnapshot messages) =>
                                      Align(
                                    alignment: messages["sendBy"] ==
                                            Auth().auth.currentUser?.displayName
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: checkForImage(messages["text"]) ==
                                            true
                                        ? Image.network(messages["text"])
                                        : Row(
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              UserAvatar(
                                                  radius: 14,
                                                  filename: widget.chatType ==
                                                          ChatType.group
                                                      ? ""
                                                      : widget.objectMap[
                                                          "profileImg"]),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                  margin:
                                                      const EdgeInsets.all(12),
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                      color: messages[
                                                                  "sendBy"] ==
                                                              Auth()
                                                                  .auth
                                                                  .currentUser
                                                                  ?.displayName
                                                          ? primaryColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(20),
                                                      )),
                                                  // elevation: 8.0,
                                                  child: Text(
                                                    messages["text"],
                                                    style: TextStyle(
                                                      color: messages[
                                                                  "sendBy"] ==
                                                              Auth()
                                                                  .auth
                                                                  .currentUser
                                                                  ?.displayName
                                                          ? Colors.white
                                                          : primaryColor,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: h * 0.06,
                            width: w * 0.8,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                              cursorColor: Colors.white,
                              cursorHeight: 18,
                              controller: Database.msgController,
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        widget.chatType == ChatType.group
                                            ? ImageDB.onSendImages(
                                                ImageDB().groupRef,
                                                widget.documentId)
                                            : ImageDB.onSendImages(
                                                ImageDB().chatRoomRef,
                                                widget.documentId);
                                      },
                                      icon: const Icon(Icons.image)),
                                  suffixIconColor: Colors.white,
                                  prefixIconColor: Colors.white,
                                  prefixIcon:
                                      const Icon(Icons.emoji_emotions_outlined),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  filled: true,
                                  fillColor: primaryColor),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 5),
                            decoration: const BoxDecoration(
                                color: primaryColor, shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  widget.chatType == ChatType.group
                                      ? GroupDB.onSendMessage(widget.documentId)
                                      : Database.onSendMessage(
                                          widget.documentId,
                                          widget.objectMap["name"]);
                                },
                                icon: const Icon(
                                    color: Colors.white, Icons.send)),
                          )
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
