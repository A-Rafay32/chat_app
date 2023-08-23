import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import 'contants.dart';
import 'login/view_model/auth.dart';

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
  final List<Message> messages = [];

  TextEditingController msgController = TextEditingController();

  // FirebaseFirestore? _firestore;

  // FirebaseAuth? _auth;

  @override
  void initState() {
    msgController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  void onSendMessage() async {
    //  Provider.of<Auth>(context ,listen : false).auth.currentUser.displayName;
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> msgMap = {
        "sendBy": Provider.of<Auth>(context, listen: false)
            .auth
            .currentUser
            ?.displayName,
        "message": msgController.text.trim(),
        "time": FieldValue.serverTimestamp(),
      };

      await Provider.of<Auth>(context, listen: false)
          .firestore
          .collection("chatroom")
          .doc(widget.chatRoomId)
          .collection("chats")
          .add(msgMap);
      print("$msgMap sent");
      // msgMap.clear();
      msgController.clear();
    } else {
      print("Can't send empty messages");
    }
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
                                // return ListView.builder(
                                //   itemCount: snapshot.data?.docs.length,
                                //   itemBuilder: (context, index) {
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
                                // Text(
                                //   snapshot.data?.docs[index]["message"],
                                //   style: const TextStyle(
                                //       color: Colors.black),
                                // );
                                //   },
                                // );
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
                              controller: msgController,
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
                                  onSendMessage();
                                },
                                icon: const Icon(
                                    color: Colors.white, Icons.send)),
                          )
                        ],
                      )
                      // Row(
                      //   mainAxisAlignment = MainAxisAlignment.spaceAround,
                      //   children = [
                      //
                      //   ],
                      // )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class Message {
  String text;
  DateTime date;
  bool isSentByMe;

  Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}

//   Message(
//       text: 'Hello!',
//       date: DateTime.now().subtract(const Duration(minutes: 1)),
//       isSentByMe: true),
//   Message(
//       text: 'How are you',
//       date: DateTime.now().subtract(const Duration(minutes: 2)),
//       isSentByMe: false),
//   Message(
//       text: 'What are you upto?',
//       date: DateTime.now().subtract(const Duration(minutes: 3)),
//       isSentByMe: true),
//   Message(
//       text: 'Just checking in ',
//       date: DateTime.now().subtract(const Duration(minutes: 4)),
//       isSentByMe: false),
//   Message(
//       text: 'Let\'s meet up soon.',
//       date: DateTime.now().subtract(const Duration(minutes: 5)),
//       isSentByMe: true),
//   Message(
//       text: 'Have a great day!',
//       date: DateTime.now().subtract(const Duration(minutes: 6)),
//       isSentByMe: false),
//   Message(
//       text: 'Thinking of you.',
//       date: DateTime.now().subtract(const Duration(minutes: 7)),
//       isSentByMe: true),
//   Message(
//       text: 'Wishing you the best.',
//       date: DateTime.now().subtract(const Duration(minutes: 8)),
//       isSentByMe: false),
//   Message(
//       text: 'Take care  ',
//       date: DateTime.now().subtract(const Duration(minutes: 9)),
//       isSentByMe: true),
//   Message(
//       text: 'Good luck!',
//       date: DateTime.now().subtract(const Duration(minutes: 10)),
//       isSentByMe: false),
// ].toList();
