import 'package:chat_app/core/view/widgets/chat_text_field.dart';
import 'package:chat_app/core/view/widgets/display_image_widget.dart';
import 'package:chat_app/core/view/widgets/display_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  ScrollController scrollController = ScrollController();

  void scrollDown() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400), curve: Curves.ease);
    });
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
      resizeToAvoidBottomInset: false,
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
            AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                curve: Curves.ease,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
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
                                    ?.copyWith(
                                        color:
                                            const Color.fromARGB(255, 8, 3, 3)))
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
                              Future.microtask(scrollDown);
                              return GroupedListView<QueryDocumentSnapshot,
                                      Timestamp>(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(8),
                                  elements: snapshot.data?.docs ?? [],
                                  groupBy: (element) => element["time"],
                                  order: GroupedListOrder.ASC,
                                  groupHeaderBuilder:
                                      (QueryDocumentSnapshot messages) =>
                                          const SizedBox(),
                                  itemBuilder: (context,
                                      QueryDocumentSnapshot messages) {
                                    //scrolling

                                    return Container(
                                      color: Colors.transparent,
                                      child: checkForImage(messages["text"]) ==
                                              true
                                          ? DisplayImageWidget(
                                              alignment: messages["sendBy"] ==
                                                      Auth()
                                                          .auth
                                                          .currentUser
                                                          ?.displayName
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              messages: messages,
                                              widget: widget,
                                            )
                                          : DisplayTextWidget(
                                              alignment: messages["sendBy"] ==
                                                      Auth()
                                                          .auth
                                                          .currentUser
                                                          ?.displayName
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              messages: messages,
                                              w: w,
                                              widget: widget,
                                            ),
                                    );
                                  });
                              // } else {
                              //   return Container();
                              // }
                            }),
                      ),
                      SizedBox(
                        height: h * 0.07,
                      )
                    ],
                  ),
                )),
            AnimatedPositioned(
                duration: const Duration(milliseconds: 70),
                curve: Curves.ease,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                child: ChatTextField(h: h, w: w, widget: widget))
          ],
        ),
      ),
    );
  }
}
