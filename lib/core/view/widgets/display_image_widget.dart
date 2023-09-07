import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/view/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../auth/view_model/auth.dart';
import '../../../features/groups/model/group_database.dart';
import '../../../res/colors.dart';
import '../../model/model.dart';
import '../chat_screen.dart';

class DisplayImageWidget extends StatefulWidget {
  const DisplayImageWidget({
    super.key,
    required this.widget,
    required this.chatType,
    required this.alignment,
    required this.messages,
  });
  final Alignment alignment;
  final ChatScreen widget;
  final ChatType chatType;
  final QueryDocumentSnapshot messages;

  @override
  State<DisplayImageWidget> createState() => _DisplayImageWidgetState();
}

class _DisplayImageWidgetState extends State<DisplayImageWidget> {
  String? userImg;

  void getProfileImage() async {
    userImg = await GroupDB.getUserImage(widget.messages["sendBy"]);
    // return await GroupDB.getUserImage(widget.messages["sendBy"]);
    print("userImg : $userImg");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                child: CachedNetworkImage(
                  imageUrl: widget.messages["text"],
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    padding: const EdgeInsets.all(40),
                    child: const CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                  height: 200,
                  width: 200,
                ),
              ),
            ]
          : [
              const SizedBox(
                width: 5,
              ),
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                child: CachedNetworkImage(
                  imageUrl: widget.messages["text"],
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    child: const Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                  height: 200,
                  width: 200,
                ),
              ),
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
            ],
    );
  }
}
