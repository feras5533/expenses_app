import 'package:expenses_app/common/prints.dart';
import 'package:expenses_app/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/views/daily_transaction_view.dart';

class TransactionsController {
  CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference total = FirebaseFirestore.instance.collection('total');
  String userId = FirebaseAuth.instance.currentUser!.uid;

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
        "price": transactionAmount,
        "category": activeCategory['name'],
      };
      await transactions
          .add(transaction)
          .then((value) => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DailyTransactionView(),
              )))
          .onError(
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

  addCategory({
    required String name,
    color,
  }) {
    var category = <String, dynamic>{
      "id": userId,
      "name": name,
      "percentage": 0.0,
      "total": 0.0,
    };
    categories.doc().set(category).onError(
          (error, stackTrace) =>
              printError("Error writing categories document: $error"),
        );
  }

  getCategoriesData() async {
    QuerySnapshot querySnapshot =
        await categories.where("id", isEqualTo: userId).get();

    List categoriesList = querySnapshot.docs.map((doc) => doc.data()).toList();
    return categoriesList;
  }

  getTransactionsData() async {
    QuerySnapshot querySnapshot =
        await transactions.where("id", isEqualTo: userId).get();

    List transactionsList =
        querySnapshot.docs.map((doc) => doc.data()).toList();
    return transactionsList;
  }

  calcTotal({
    // required activeCategory,
    required transactionAmount,
  }) async {
    double totalTransactions = 0.0;

    // activeCategory['total'] += double.parse(transactionAmount);
    // total += double.parse(transactionAmount);

    var totalStore = {
      'total': totalTransactions,
    };
    total.add(totalStore).onError(
          (error, stackTrace) =>
              printError("Error writing total document: $error"),
        );
  }

  calcCategoryTotal({
    required activeCategory,
    required transactionAmount,
  }) async {
    double total = 0.0;

    activeCategory['total'] += double.parse(transactionAmount);
    total += double.parse(transactionAmount);

    var totalStore = {
      'total': total,
    };
    categories.add(totalStore);
    // db
    //     .collection("categories")
    //     .doc()
    //     .set(totalStore)
    //     .onError((e, _) => printError("Error writing total document: $e"));
  }

  calculatePercentages() {
    // double totalSum =
    //     categories.fold(0.0, (double sum, category) => sum + category["total"]);

    // for (var category in categories) {
    //   category["percentage"] = ((category["total"] / totalSum) * 100);
    // }

    // update();
  }
}
