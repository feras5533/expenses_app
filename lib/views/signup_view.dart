import 'package:flutter/material.dart';

import '/views/login_view.dart';
import '/controllers/auth_controller.dart';
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
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isHidden = true;

  signUp() {
    var request = AuthController(context: context);

    request.createUserWithEmailAndPassword(
      userName: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phoneNumber: _phoneNumberController.text,
    );
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
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
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
                  height: height * 0.01,
                ),
                const Text(
                  "SignUp",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                const Text(
                  "SignUp To Continue Using The App",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
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
                  height: height * 0.02,
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
                  height: height * 0.02,
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
                  isPassword: true,
                  isHidden: isHidden,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const Text(
                  "Phone Number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                CustomTextField(
                  hintText: "ُEnter Your Phone Number",
                  controller: _phoneNumberController,
                  lastField: true,
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            CustomButton(
              title: "SignUp",
              onPressed: () {
                signUp();
              },
            ),

            // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ));
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
