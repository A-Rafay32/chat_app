import 'package:chat_app/core/view/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar({
    super.key,
    required this.name,
    required this.filename,
  });

  final String name;
  final String filename;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          UserAvatar(
            filename: filename,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}
