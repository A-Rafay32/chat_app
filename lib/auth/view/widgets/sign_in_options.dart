import 'package:flutter/material.dart';

import '../../../res/colors.dart';

class SignInOptions extends StatelessWidget {
  const SignInOptions({
    super.key,
    required this.h,
    required this.w,
    required this.title,
    required this.icon,
    required this.topLeft,
    required this.topRight,
  });

  final double h;
  final double w;

  final String title;
  final IconData icon;
  final Radius topLeft;
  final Radius topRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w * 0.43,
      // margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.23),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
            topLeft: topLeft,
            topRight: topRight,
          )),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: h * 0.015,
          horizontal: 20,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: primaryColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
