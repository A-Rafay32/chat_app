import 'package:flutter/material.dart';

import '../../../res/colors.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.validator,
    required this.hintText,
    required this.controller,
    this.autofillHints = const [AutofillHints.email],
  });
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  Iterable<String>? autofillHints;

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
      child: TextFormField(
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
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          hintStyle: TextStyle(
              color: _focusNode.hasFocus ? primaryColor : Colors.grey),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofillHints: widget.autofillHints,
        validator: widget.validator,
      ),
    );
  }
}
