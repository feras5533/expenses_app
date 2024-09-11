import 'package:cloud_firestore/cloud_firestore.dart';
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

  CollectionReference userData =
      FirebaseFirestore.instance.collection('userData');

  Future createUserWithEmailAndPassword({
    required email,
    required password,
    required userName,
    required phoneNumber,
  }) async {
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          phoneNumber.isNotEmpty) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String userId = FirebaseAuth.instance.currentUser!.uid;
        var data = {
          "id": userId,
          "name": userName,
          "phoneNumber": phoneNumber,
        };
        await userData.add(data).then(
              (value) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomNavigationBarWidget(),
                ),
                (route) => false,
              ),
            );
      } else {
        customDialog(title: 'All the fields must be filled', context: context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        customDialog(
            title: 'The password provided is too weak', context: context);
      } else if (e.code == 'email-already-in-use') {
        customDialog(
            title: 'The account already exists for that email',
            context: context);
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
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: email,
              password: password,
            )
            .then(
              (value) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomNavigationBarWidget(),
                ),
                (route) => false,
              ),
            );
      } else {
        customDialog(title: 'All the fields must be filled', context: context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        printError(e);
        customDialog(
          title: 'No user found with the used data.',
          context: context,
        );
      } else {
        printError(e);
        customDialog(
          title: 'No user found with the used data.',
          context: context,
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
    if (!context.mounted) return;

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
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
      (route) => false,
    );
  }
}
