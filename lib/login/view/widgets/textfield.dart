import 'package:flutter/material.dart';

import '../../../contants.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key, required this.hintText, required this.controller});
  final TextEditingController controller;
  final String hintText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: TextField(
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black),
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.password_outlined),
          prefixIconColor: _focusNode.hasFocus ? Colors.black : Colors.grey,
          focusColor: primaryColor,
          hintText: widget.hintText,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          hintStyle: TextStyle(
              color: _focusNode.hasFocus ? primaryColor : Colors.grey),
        ),
      ),
    );
  }
}
