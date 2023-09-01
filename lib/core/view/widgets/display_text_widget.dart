import 'package:chat_app/core/view/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../auth/view_model/auth.dart';
import '../../../res/colors.dart';
import '../../model/model.dart';
import '../chat_screen.dart';

class DisplayTextWidget extends StatelessWidget {
  const DisplayTextWidget({
    super.key,
    required this.w,
    required this.widget,
    required this.messages,
    required this.alignment,
  });

  final double w;
  final ChatScreen widget;
  final QueryDocumentSnapshot messages;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: Colors.transparent,
      width: w,
      child: Row(
        mainAxisAlignment:
            messages["sendBy"] == Auth().auth.currentUser?.displayName
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: alignment == Alignment.centerLeft
            ? [
                const SizedBox(
                  width: 5,
                ),
                UserAvatar(
                    radius: 14,
                    filename: widget.chatType == ChatType.group
                        ? ""
                        : widget.objectMap["profileImg"]),
                const SizedBox(
                  width: 5,
                ),
                Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: w * 0.7),
                    decoration: BoxDecoration(
                        color: messages["sendBy"] ==
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
                      messages["text"],
                      style: TextStyle(
                        color: messages["sendBy"] ==
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
                    constraints: BoxConstraints(maxWidth: w * 0.7),
                    decoration: BoxDecoration(
                        color: messages["sendBy"] ==
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
                      messages["text"],
                      style: TextStyle(
                        color: messages["sendBy"] ==
                                Auth().auth.currentUser?.displayName
                            ? Colors.white
                            : primaryColor,
                      ),
                    )),
                UserAvatar(
                    radius: 14,
                    filename: widget.chatType == ChatType.group
                        ? ""
                        : widget.objectMap["profileImg"]),
                const SizedBox(
                  width: 5,
                ),
              ],
      ),
    );
  }
}
