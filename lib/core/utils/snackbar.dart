import 'package:chat_app/res/colors.dart';
import 'package:flutter/material.dart';

void successSnackBar(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: primaryColor,
      content: Container(
        color: primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
      )));
}

void errorSnackBar(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red.shade400,
      content: Container(
        color: Colors.red.shade400,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      )));
}
