import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/views/login_view.dart';
import '/common/prints.dart';
import '/widgets/bottom_navigation_bar_widget.dart';
import '/widgets/custom_snackbar.dart';

class AuthController {
  BuildContext context;
  AuthController({
    required this.context,
  });

  Future createUserWithEmailAndPassword({
    required email,
    required password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarWidget(),
        ),
        (route) => true,
      );
      // Get.offAll(() => const BottomNavigationBarWidget());
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

  Future signInWithEmailAndPassword({
    required email,
    required password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Get.offAll(() => const BottomNavigationBarWidget());
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarWidget(),
        ),
        (route) => true,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        printWarning('No user found with the used data.');
        customDialog(
          title: 'user not found.1',
          context: context.mounted,
        );
      } else {
        printError(e);
        customDialog(
          title: 'No user found with the \nused data.',
          context: context.mounted,
        );
      }
    }
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    // Get.offAll(() => const BottomNavigationBarWidget());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const BottomNavigationBarWidget(),
      ),
      (route) => true,
    );
  }

  Future signout() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    // Get.offAll(() => const LoginView());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
      (route) => true,
    );
  }
}
