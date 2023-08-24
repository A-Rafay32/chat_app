import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import '../model/data/database.dart';
import '../../res/colors.dart';
import '../../auth/view_model/auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final Map<String, dynamic> userMap;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.userMap,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
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
                  height: size.height * 0.9,
                  width: size.width,
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
                              "${widget.userMap["name"]}",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            Text("${widget.userMap["status"]}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.grey.shade800))
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: Provider.of<Auth>(context, listen: false)
                                .firestore
                                .collection("chatroom")
                                .doc(widget.chatRoomId)
                                .collection("chats")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return GroupedListView<QueryDocumentSnapshot,
                                    DateTime>(
                                  padding: const EdgeInsets.all(8),
                                  elements: snapshot.data!.docs,
                                  groupBy: (QueryDocumentSnapshot messages) {
                                    Timestamp timestamp = messages["time"];
                                    DateTime dateTime = timestamp.toDate();
                                    int month = dateTime.month;
                                    int day = dateTime.day;
                                    int year = dateTime.year;
                                    return DateTime(year, month, day);
                                  },
                                  order: GroupedListOrder.DESC,
                                  groupHeaderBuilder:
                                      (QueryDocumentSnapshot messages) =>
                                          const SizedBox(),
                                  itemBuilder: (context,
                                          QueryDocumentSnapshot messages) =>
                                      Align(
                                    alignment: messages["sendBy"] ==
                                            Provider.of<Auth>(context,
                                                    listen: false)
                                                .auth
                                                .currentUser
                                                ?.displayName
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
                            height: size.height * 0.06,
                            width: size.width * 0.8,
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
                                  Database.onSendMessage(widget.chatRoomId);
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
