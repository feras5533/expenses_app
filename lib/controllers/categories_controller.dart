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
  CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');
  String userId = FirebaseAuth.instance.currentUser!.uid;

  CategoriesController({
    required this.context,
  });

  addCategory({
    required String name,
  }) async {
    if (name.isNotEmpty) {
      try {
        var existingCategory = await categories
            .where('id', isEqualTo: userId)
            .where('name', isEqualTo: name)
            .get();

        if (existingCategory.docs.isNotEmpty) {
          customDialog(
              title: 'Category with the same name \nalready exists',
              context: context);
        } else {
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
        }
      } catch (e) {
        printError('Error adding category document: $e');
      }
    } else {
      customDialog(title: 'The name can\'t be empty', context: context);
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
      // Reference to the category document
      var foundCategory = categories.doc(docId);

      // Fetch the category name based on the docId
      var categorySnapshot = await foundCategory.get();
      var categoryName = categorySnapshot['name'];

      // Query transactions that are associated with the category name
      var categoryTransactions = await transactions
          .where('category', isEqualTo: categoryName)
          .where('id', isEqualTo: userId)
          .get();

      // Delete each transaction linked to the category
      for (var docSnapshot in categoryTransactions.docs) {
        // printWarning(docSnapshot.data());
        await docSnapshot.reference.delete();
      }

      // Delete the category itself
      await foundCategory.delete();

      customDialog(
          title: 'The category and related \ntransactions have been deleted',
          context: context);
    } catch (e) {
      printError('Error deleting category or transactions: $e');
    }
  }

  // deleteCategory({required String docId}) async {
  //   try {
  //     var foundCategory = categories.doc(docId);
  //     var categoryTransactions =
  //         await transactions.where('id', isEqualTo: userId).get();
  //     await foundCategory.delete();
  //     customDialog(title: 'The category has been deleted', context: context);
  //   } catch (e) {
  //     printError('Error deleting category document: $e');
  //   }
  // }

  editCategory({
    required String docId,
    required String name,
  }) async {
    if (name.isNotEmpty) {
      try {
        await categories.doc(docId).set({
          'name': name,
        }, SetOptions(merge: true));
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
