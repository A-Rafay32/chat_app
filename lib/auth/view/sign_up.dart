import 'package:chat_app/auth/view/widgets/textfield.dart';
import 'package:chat_app/auth/view_model/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.transparent,
          height: h,
          width: w,
          child: Column(
            children: [
              Stack(children: [
                Container(
                  height: h * 0.3,
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
                      icon:
                          const Icon(color: Colors.white, Icons.arrow_back_ios),
                    ))
              ]),
              CustomTextField(
                  validator: (name) {
                    (name!.length < 8)
                        ? "Name should be 8 characters long"
                        : null;
                    return null;
                  },
                  hintText: "Full Name",
                  controller: nameController
                  // Provider.of<Auth>(context, listen: false).nameController
                  ),
              CustomTextField(
                validator: (email) {
                  (email != null && !EmailValidator.validate(email.toString()))
                      ? "Enter a correct email"
                      : null;
                  return null;
                },
                controller: emailController,
                // Provider.of<Auth>(context, listen: false).emailController,
                hintText: "Email",
              ),
              CustomTextField(
                validator: (password) {
                  if (!RegExp(r'^[a-z A-Z 0-9]').hasMatch(password!) &&
                      password.length < 8) {
                    return "Passwords should be alphanumeric and 8 characters long";
                  }
                  return null;
                },
                controller: passController,
                // Provider.of<Auth>(context, listen: false).passController,
                hintText: "Password",
              ),
              Expanded(child: Container()),
              Stack(children: [
                Container(
                  height: h * 0.3,
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
                      Auth().signUp(
                          context: context,
                          email: emailController.text.trim(),
                          name: nameController.text.trim(),
                          password: passController.text.trim());
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
                            vertical: h * 0.018,
                            horizontal: w * 0.2,
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
          ),
        ));
  }
}
