import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/view/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../auth/view_model/auth.dart';
import '../../../res/colors.dart';
import '../../model/model.dart';
import '../chat_screen.dart';

class DisplayImageWidget extends StatelessWidget {
  const DisplayImageWidget({
    super.key,
    required this.widget,
    required this.alignment,
    required this.messages,
  });
  final Alignment alignment;
  final ChatScreen widget;
  final QueryDocumentSnapshot messages;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              CachedNetworkImage(
                imageUrl: messages["text"],
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
            ]
          : [
              const SizedBox(
                width: 5,
              ),
              CachedNetworkImage(
                imageUrl: messages["text"],
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
              const SizedBox(
                width: 5,
              ),
              UserAvatar(
                  radius: 14,
                  filename: widget.chatType == ChatType.group
                      ? ""
                      : widget.objectMap["profileImg"]),
            ],
    );
  }
}
