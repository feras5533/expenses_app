import 'package:expenses_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import '../common/images_urls.dart';
import '/widgets/custom_snackbar.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/custom_button.dart';
import '/common/color_constants.dart';
import '/views/signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isHidden = true;

  login() {
    var request = AuthController(context: context);
    request.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  loginWithGoogle() {
    var request = AuthController(context: context);
    request.signInWithGoogle();
  }

  @override
  void dispose() {
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
          padding: const EdgeInsetsDirectional.all(20),
          shrinkWrap: true,
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
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  "Login To Continue Using The App",
                  style: TextStyle(
                    color: AppTheme.grey,
                  ),
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
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.topRight,
                    child: Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.grey,
                        color: AppTheme.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CustomButton(
                title: "login",
                onPressed: () {
                  login();
                }),
            SizedBox(
              height: height * 0.02,
            ),
            const Center(
              child: Text(
                'Or Sign in With',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    customDialog(
                      title: 'this feature in not available',
                      context: context,
                    );
                  },
                  icon: Image.asset(ImagesUrls.facebookLogo),
                ),
                IconButton(
                  onPressed: () {
                    customDialog(
                      title: 'this feature in not available',
                      context: context,
                    );
                  },
                  icon: Image.asset(ImagesUrls.appleLogo),
                ),
                IconButton(
                  onPressed: () {
                    // customDialog(
                    //   title: 'this feature in not available',
                    //   context: context,
                    // );
                    loginWithGoogle();
                  },
                  icon: Image.asset(ImagesUrls.googleLogo),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SignUpView(),
                ));
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't Have An Account ? ",
                      ),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
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
