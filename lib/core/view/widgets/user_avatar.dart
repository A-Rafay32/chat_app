import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String filename;
  const UserAvatar({
    super.key,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 27,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 27,
        backgroundImage: Image.asset('assets/images/$filename').image,
      ),
    );
  }
}
