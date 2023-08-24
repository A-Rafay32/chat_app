import 'package:chat_app/auth/view/widgets/textfield.dart';
import 'package:chat_app/auth/view_model/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Column(
      children: [
        Stack(children: [
          Container(
            height: size.height * 0.3,
            decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(500),
                  bottomLeft: Radius.circular(500),
                  bottomRight: Radius.circular(500),
                )),
          ),
          Positioned(
              top: 30,
              left: 30,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(color: Colors.white, Icons.arrow_back_ios),
              ))
        ]),
        CustomTextField(
            validator: (name) {
              (name!.length < 8) ? "Name should be 8 characters long" : null;
              return null;
            },
            hintText: "Full Name",
            controller:
                Provider.of<Auth>(context, listen: false).nameController),
        CustomTextField(
          validator: (email) {
            if (email!.isNotEmpty &&
                !EmailValidator.validate(email.toString())) {
              "Enter a correct email";
            } else {
              null;
            }
            return null;
          },
          controller: Provider.of<Auth>(context, listen: false).emailController,
          hintText: "Email",
        ),
        CustomTextField(
          validator: (password) {
            if (!RegExp(r'^[a-z A-Z 0-9]').hasMatch(password!) &&
                password.length < 8) {
              "Passwords should be alphanumeric and 8 characters long";
            }
            return null;
          },
          controller: Provider.of<Auth>(context, listen: false).passController,
          hintText: "Password",
        ),
        Expanded(child: Container()),
        Stack(children: [
          Container(
            height: size.height * 0.3,
            decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(500),
                  topLeft: Radius.circular(500),
                  bottomLeft: Radius.circular(500),
                  // bottomRight: Radius.circular(500),
                )),
          ),
          Positioned(
            left: 50,
            top: 50,
            bottom: 50,
            right: 50,
            child: GestureDetector(
              onTap: () {
                Provider.of<Auth>(context, listen: false).signUp(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.018,
                      horizontal: size.width * 0.2,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 19, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ],
    ));
  }
}
