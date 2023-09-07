import 'package:chat_app/core/view/widgets/user_avatar.dart';
import 'package:chat_app/features/groups/model/group_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../auth/view_model/auth.dart';
import '../../../res/colors.dart';
import '../../model/model.dart';
import '../chat_screen.dart';

class DisplayTextWidget extends StatefulWidget {
  const DisplayTextWidget({
    super.key,
    required this.w,
    required this.widget,
    required this.messages,
    required this.chatType,
    required this.alignment,
  });

  final double w;
  final ChatScreen widget;
  final ChatType chatType;
  final QueryDocumentSnapshot messages;
  final Alignment alignment;

  @override
  State<DisplayTextWidget> createState() => _DisplayTextWidgetState();
}

class _DisplayTextWidgetState extends State<DisplayTextWidget> {
  String? userImg;

  void getProfileImage() async {
    
    userImg = await GroupDB.getUserImage(widget.messages["sendBy"]);
    // return await GroupDB.getUserImage(widget.messages["sendBy"]);
    print("userImg : $userImg");
  }

  @override
  void initState() {
    getProfileImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: Colors.transparent,
      width: widget.w,
      child: Row(
        mainAxisAlignment:
            widget.messages["sendBy"] == Auth().auth.currentUser?.displayName
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: widget.alignment == Alignment.centerLeft
            ? [
                const SizedBox(
                  width: 5,
                ),
                UserAvatar(
                    radius: 14,
                    filename: widget.chatType == ChatType.group
                        ? userImg.toString()
                        : widget.messages["sendBy"] ==
                                Auth().auth.currentUser?.displayName
                            ? Auth().auth.currentUser?.photoURL
                            : widget.widget.objectMap["profileImg"]),
                const SizedBox(
                  width: 5,
                ),
                Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: widget.w * 0.7),
                    decoration: BoxDecoration(
                        color: widget.messages["sendBy"] ==
                                Auth().auth.currentUser?.displayName
                            ? primaryColor
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                    // elevation: 8.0,
                    child: Text(
                      widget.messages["text"],
                      style: TextStyle(
                        color: widget.messages["sendBy"] ==
                                Auth().auth.currentUser?.displayName
                            ? Colors.white
                            : primaryColor,
                      ),
                    )),
              ]
            : [
                const SizedBox(
                  width: 5,
                ),
                Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: widget.w * 0.7),
                    decoration: BoxDecoration(
                        color: widget.messages["sendBy"] ==
                                Auth().auth.currentUser?.displayName
                            ? primaryColor
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        )),
                    // elevation: 8.0,
                    child: Text(
                      widget.messages["text"],
                      style: TextStyle(
                        color: widget.messages["sendBy"] ==
                                Auth().auth.currentUser?.displayName
                            ? Colors.white
                            : primaryColor,
                      ),
                    )),
                UserAvatar(
                    radius: 14,
                    filename: widget.chatType == ChatType.group
                        ? userImg.toString()
                        : widget.messages["sendBy"] ==
                                Auth().auth.currentUser?.displayName
                            ? Auth().auth.currentUser?.photoURL
                            : widget.widget.objectMap["profileImg"]),
                const SizedBox(
                  width: 5,
                ),
              ],
      ),
    );
  }
}
