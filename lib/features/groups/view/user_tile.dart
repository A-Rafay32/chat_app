import 'package:chat_app/core/view/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  UserTile({
    super.key,
    required this.name,
    required this.filename,
    required this.status,
  });

  String name;
  String filename;
  String status;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    return Container(
      color: Colors.transparent,
      width: w,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    style:
                        const TextStyle(color: Colors.black, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    status,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            indent: 70,
            height: 20,
          )
        ],
      ),
    );
  }
}
