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
        (route) => false,
      );
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarWidget(),
        ),
        (route) => false,
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
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const BottomNavigationBarWidget(),
      ),
      (route) => false,
    );
  }

  Future signout() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
      (route) => false,
    );
  }
}
