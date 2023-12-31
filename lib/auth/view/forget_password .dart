import 'package:chat_app/auth/view/widgets/textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/colors.dart';
import '../view_model/auth.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;

    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: secondaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              )),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.transparent,
          height: h,
          width: w,
          child: Column(
            children: [
              SizedBox(
                height: h * 0.15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: w * 0.6,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Forgot",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: w * 0.6,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Password?",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                validator: (email) {
                  return (email != null &&
                          !EmailValidator.validate(email.toString()))
                      ? "Enter a correct email"
                      : null;
                },
                controller: context.read<Auth>().emailController,
                hintText: "Email",
              ),
              SizedBox(
                height: h * 0.15,
              ),
              GestureDetector(
                onTap: () {
                  context.read<Auth>().forgotPassword(
                      context.read<Auth>().emailController.text.trim(),
                      context);
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
                        "Reset Password",
                        style: TextStyle(fontSize: 17, color: Colors.white),
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
