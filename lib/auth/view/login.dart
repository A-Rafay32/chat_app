import 'package:chat_app/auth/view/forget_password%20.dart';
import 'package:chat_app/res/colors.dart';
import 'package:chat_app/auth/view/widgets/textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_up.dart';
import '../view_model/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      body: Container(
        color: Colors.transparent,
        height: h,
        width: w,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      height: h * 0.3,
                      decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(500),
                            bottomLeft: Radius.circular(500),
                            bottomRight: Radius.circular(500),
                          )),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              CustomTextField(
                validator: (email) {
                  return email != null &&
                          !(EmailValidator.validate(email.toString()))
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
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen(),
                      ));
                },
                child: const Text(
                  'I forgot my password',
                  style: TextStyle(
                    fontSize: 17,
                    // fontWeight: FontWeight.w600,
                    color: backgroundColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<Auth>(context, listen: false).signIn(context);
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
                        "Sign In",
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.18),
                child: Container(
                    child: RichText(
                  text: TextSpan(
                      text: "Don't have an account? ",
                      style:
                          TextStyle(color: Colors.black, fontSize: h * 0.021),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Sign up ",
                            style: TextStyle(
                                color: primaryColor, fontSize: h * 0.021),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                              })
                      ]),
                )),
              ),
              const SizedBox(
                height: 20,
              )
            ]),
      ),
    );
  }
}
