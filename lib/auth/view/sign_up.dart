import 'package:chat_app/auth/view/widgets/textfield.dart';
import 'package:chat_app/auth/view_model/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  // TextEditingController passController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController nameController = TextEditingController();

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
                    top: 20,
                    left: 10,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(color: Colors.white, Icons.arrow_back_ios),
                    ))
              ]),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                  validator: (name) {
                    return (name!.length < 8)
                        ? "Name should be 8 characters long"
                        : null;
                  },
                  hintText: "Full Name",
                  controller:
                      Provider.of<Auth>(context, listen: false).nameController),
              CustomTextField(
                validator: (email) {
                  return (email != null &&
                          !EmailValidator.validate(email.toString()))
                      ? "Enter a correct email"
                      : null;
                },
                controller:
                    Provider.of<Auth>(context, listen: false).emailController,
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
                controller:
                    Provider.of<Auth>(context, listen: false).passController,
                hintText: "Password",
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  Provider.of<Auth>(context, listen: false).signUp(
                    context,
                  );
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
                        horizontal: w * 0.3,
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
  }
}
