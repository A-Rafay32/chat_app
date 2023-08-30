import 'package:chat_app/core/view/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ConversationRow extends StatelessWidget {
  ConversationRow(
      {super.key,
      required this.name,
      required this.message,
      required this.filename,
      required this.onTap,
      required this.time,
      required this.msgCount});

  String name;
  String message;
  String filename;
  int msgCount;
  String time;

  Function() onTap;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: w,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    UserAvatar(filename: filename),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: Colors.transparent,
                          width: w * 0.8,
                          child: Text(
                            message,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25, top: 5),
                  child: Column(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (msgCount > 0)
                        CircleAvatar(
                          radius: 7,
                          backgroundColor: const Color(0xFF27c1a9),
                          child: Text(
                            msgCount.toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              indent: 70,
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
