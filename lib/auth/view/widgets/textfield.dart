import 'package:chat_app/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  bool isObscure = true;

  void setObscureText() {
    setState(() {
      isObscure = !isObscure;
    });
  }

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
        obscureText: widget.hintText == "Password" ? isObscure : false,
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black),
        controller: widget.controller,
        onChanged: (value) {
          print(value);
        },
        focusNode: _focusNode,
        decoration: InputDecoration(
          suffixIcon: widget.hintText == "Email"
              ? Icon(Icons.email_outlined,
                  color: _focusNode.hasFocus ? primaryColor : Colors.grey)
              : widget.hintText == "Password"
                  ? IconButton(
                      onPressed: () => setObscureText(),
                      icon: (isObscure)
                          ? SvgPicture.asset("assets/icons/eye_closed.svg",
                              height: 30,
                              width: 30,
                              colorFilter: _focusNode.hasFocus
                                  ? const ColorFilter.mode(
                                      primaryColor, BlendMode.srcIn)
                                  : const ColorFilter.mode(
                                      Colors.grey, BlendMode.srcIn))
                          : SvgPicture.asset("assets/icons/eye_open.svg",
                              height: 30,
                              width: 30,
                              colorFilter: _focusNode.hasFocus
                                  ? const ColorFilter.mode(
                                      primaryColor, BlendMode.srcIn)
                                  : const ColorFilter.mode(
                                      Colors.grey, BlendMode.srcIn)),
                    )
                  : null,
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
