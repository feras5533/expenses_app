import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/common/prints.dart';
import '/models/transaction_model.dart';
import '/widgets/custom_snackbar.dart';

class TransactionsController {
  BuildContext context;
  CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference total = FirebaseFirestore.instance.collection('total');
  String userId = FirebaseAuth.instance.currentUser!.uid;

  TransactionsController({
    required this.context,
  });

  addTransaction({
    required activeCategory,
    required transactionName,
    required transactionAmount,
    required context,
  }) async {
    if (transactionName.isNotEmpty && transactionAmount.isNotEmpty) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      var transaction = {
        "id": userId,
        "name": transactionName,
        "date": formattedDate,
        "price": double.parse(transactionAmount),
        "category": activeCategory,
      };
      await transactions.add(transaction).onError(
            (error, stackTrace) =>
                printError("Error writing transactions document: $error"),
          );

      customDialog(
        title: 'The Transaction Has Been Added',
        context: context,
        error: false,
      );
    } else {
      customDialog(title: 'Please fill both the fields', context: context);
    }
  }

  getTransactionsData() async {
    return transactions.withConverter<TransactionModel>(
      fromFirestore: (snapshot, options) =>
          TransactionModel.fromFirestore(snapshot, options),
      toFirestore: (user, options) => user.toFirestore(),
    );
  }

  Stream<double> calcTotal() async* {
    double totalTransactions = 0.0;
    try {
      var querySnapshot =
          await transactions.where('id', isEqualTo: userId).get();

      for (var docSnapshot in querySnapshot.docs) {
        totalTransactions += docSnapshot.get('price');
        yield totalTransactions;
      }
    } catch (e) {
      printError("Error completing: $e");
    }
  }

  deleteTransaction({required String docId}) async {
    try {
      await transactions.doc(docId).delete();
      customDialog(
          title: 'The transaction has\n been deleted', context: context);
    } catch (e) {
      printError('Error deleting transaction document: $e');
    }
  }

  editTransaction({
    required String docId,
    required String name,
    required double price,
  }) async {
    try {
      await categories.doc(docId).update({
        'name': name,
        'price': price,
      });
      customDialog(
          title: 'The transaction has\n been updated', context: context);
    } catch (e) {
      printError('Error updating transaction document: $e');
      customDialog(
          title: 'Somthing wrong happened\n try again please',
          context: context);
    }
  }

 
}
