import 'package:chat_app/res/colors.dart';
import 'package:flutter/material.dart';

void successSnackBar(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: primaryColor,
      content: Container(
        color: primaryColor,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.check, color: Colors.white)
          ],
        ),
      )));
}

void errorSnackBar(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red.shade400,
      content: Container(
        color: Colors.red.shade400,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.error_sharp, color: Colors.white)
          ],
        ),
      )));
}
