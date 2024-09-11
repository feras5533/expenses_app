import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_app/common/prints.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';

class UserController {
  BuildContext context;

  UserController({
    required this.context,
  });
  CollectionReference userData =
      FirebaseFirestore.instance.collection('userData');

  getUserData() async {
    CollectionReference<UserModel>? data;
    try {
      data = userData.withConverter<UserModel>(
        fromFirestore: (snapshot, options) =>
            UserModel.fromFirestore(snapshot, options),
        toFirestore: (user, options) => user.toFirestore(),
      );
    } catch (e) {
      printError('error on getUserData $e');
    }
    return data;
  }
}
