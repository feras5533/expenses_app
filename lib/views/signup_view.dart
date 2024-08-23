import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expenses_app/common/prints.dart';
import 'package:expenses_app/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/widgets/bottom_navigation_bar_widget.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  createUserWithEmailAndPassword({
    required email,
    required password,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.off(const BottomNavigationBarWidget());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        printWarning('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        printWarning('The account already exists for that email.');
      }
    } catch (e) {
      printError(e);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsetsDirectional.all(20),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.adobe_outlined,
                    size: 70,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                const Text(
                  "SignUp",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                const Text(
                  "SignUp To Continue Using The App",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                const Text(
                  "username",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                CustomTextField(
                  hintText: "ُEnter Your username",
                  controller: _usernameController,
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                const Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                CustomTextField(
                  hintText: "ُEnter Your Email",
                  controller: _emailController,
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                const Text(
                  "Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                CustomTextField(
                  hintText: "ُEnter Your Password",
                  controller: _passwordController,
                  lastField: true,
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            CustomButton(
              title: "SignUp",
              onPressed: () {
                createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
              },
            ),

            // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
            InkWell(
              onTap: () {
                Get.to(const LoginView());
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Have An Account ? ",
                      ),
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
