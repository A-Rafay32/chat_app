import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import '../../features/groups/model/group_database.dart';
import '../../res/colors.dart';
import '../../auth/view_model/auth.dart';
import '../model/data/database.dart';
import '../model/model.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final Map<String, dynamic> userMap;
  final ChatType chatType;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.userMap,
    required this.chatType,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    widget.chatType == ChatType.group
        ? GroupDB.getGroupMessages(widget.chatRoomId)
        : Database.getMessages(widget.chatRoomId);
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
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                            color: secondaryColor, Icons.more_vert_sharp))
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
                                  ? "${widget.userMap["name"]}"
                                  : "${widget.userMap["groupName"]}",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            Text(
                                widget.chatType != ChatType.group
                                    ? "${widget.userMap["status"]}"
                                    : "",
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
                                ? GroupDB.groupChats
                                : Database.chats,
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
                                    child: Container(
                                        margin: const EdgeInsets.all(12),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            color: messages["sendBy"] ==
                                                    Provider.of<Auth>(context,
                                                            listen: false)
                                                        .auth
                                                        .currentUser
                                                        ?.displayName
                                                ? primaryColor
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            )),
                                        // elevation: 8.0,
                                        child: Text(
                                          messages["message"],
                                          style: TextStyle(
                                            color: messages["sendBy"] ==
                                                    Provider.of<Auth>(context,
                                                            listen: false)
                                                        .auth
                                                        .currentUser
                                                        ?.displayName
                                                ? Colors.white
                                                : primaryColor,
                                          ),
                                        )),
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
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  suffix: Icon(
                                      color: Colors.white,
                                      Icons.file_upload_outlined),
                                  suffixIcon: Icon(Icons.image),
                                  suffixIconColor: Colors.white,
                                  prefixIconColor: Colors.white,
                                  prefixIcon:
                                      Icon(Icons.emoji_emotions_outlined),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                                      ? GroupDB.onSendMessage(widget.chatRoomId)
                                      : Database.onSendMessage(
                                          widget.chatRoomId);
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
