import 'package:chat_app/contants.dart';
import 'package:chat_app/login/view/widgets/sign_in_options.dart';
import 'package:chat_app/login/view/widgets/textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../sign_up.dart';
import '../view_model/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SizedBox(
        // padding: const EdgeInsets.only(right: 20),

        height: size.height,
        width: size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      height: size.height * 0.3,
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
                height: 20,
              ),
              CustomTextField(
                controller:
                    Provider.of<Auth>(context, listen: false).emailController,
                hintText: "Email",
              ),
              CustomTextField(
                controller:
                    Provider.of<Auth>(context, listen: false).passController,
                hintText: "Password",
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {},
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
                height: 20,
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
                        vertical: size.height * 0.018,
                        horizontal: size.width * 0.3,
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 30,
              // ),
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.1,
                  ),
                  child: const Text(
                    "Or Sign in With",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              Row(
                children: [
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  SignInOptions(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(0),
                    size: size,
                    title: "Facebook",
                    icon: Icons.facebook_sharp,
                  ),
                  Expanded(child: Container()),
                  SignInOptions(
                    topLeft: const Radius.circular(0),
                    topRight: const Radius.circular(20),
                    size: size,
                    title: "Google",
                    icon: Icons.wb_twilight_outlined,
                  ),
                  // const SizedBox(
                  //   width: 10,
                  // )
                ],
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.18),
                child: Container(
                    child: RichText(
                  text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                          color: Colors.black, fontSize: size.height * 0.024),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Sign up ",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: size.height * 0.024),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                              })
                      ]),
                )),
              ),
              // const SizedBox(
              //   height: 0,
              // ),
            ]),
      ),
    );
  }
}
