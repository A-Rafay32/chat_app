import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String filename;
  UserAvatar({
    super.key,
    required this.filename,
    this.radius = 27,
  });
  double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: filename == ""
            ? const AssetImage("assets/images/account.jpeg")
            : Image.network(filename).image,
      ),
    );
  }
}
