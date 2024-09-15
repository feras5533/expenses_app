import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/common/prints.dart';
import '/models/categories_model.dart';
import '/widgets/custom_snackbar.dart';

class CategoriesController {
  BuildContext context;
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  String userId = FirebaseAuth.instance.currentUser!.uid;

  CategoriesController({
    required this.context,
  });

  addCategory({
    required String name,
    color,
  }) async {
    if (name.isNotEmpty) {
      try {
        var category = <String, dynamic>{
          "id": userId,
          "name": name,
          "percentage": 0.0,
          "total": 0.0,
        };
        await categories.doc().set(category).onError(
              (error, stackTrace) =>
                  printError("Error writing categories document: $error"),
            );
      } catch (e) {
        printError('Error adding category document: $e');
      }
    } else {
      customDialog(title: 'the name can\'t be empty', context: context);
    }
  }

  getCategoriesData() async {
    return categories.withConverter<CategoriesModel>(
      fromFirestore: (snapshot, options) =>
          CategoriesModel.fromFirestore(snapshot, options),
      toFirestore: (user, options) => user.toFirestore(),
    );
  }

  deleteCategory({required String docId}) async {
    try {
      await categories.doc(docId).delete();
      customDialog(title: 'The category has been deleted', context: context);
    } catch (e) {
      printError('Error deleting category document: $e');
    }
  }

  editCategory({
    required String docId,
    required String name,
  }) async {
    if (name.isNotEmpty) {
      try {
        await categories.doc(docId).update({
          'name': name,
        });
        customDialog(title: 'The category has been updated', context: context);
      } catch (e) {
        printError('Error updating category document: $e');
        customDialog(
            title: 'Somthing wrong happened\n try again please',
            context: context);
      }
    } else {
      customDialog(title: 'the name can\'t be empty', context: context);
    }
  }

  // calcCategoryTotal() {}

  // calculatePercentages() {}
}
