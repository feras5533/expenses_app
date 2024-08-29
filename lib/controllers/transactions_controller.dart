import 'package:expenses_app/common/prints.dart';
import 'package:expenses_app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsController extends GetxController {
  var db = FirebaseFirestore.instance;

  addTransaction({
    required activeCategory,
    required transactionName,
    required transactionAmount,
    required context,
  }) {
    if (transactionName.isNotEmpty && transactionAmount.isNotEmpty) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      var transaction = {
        "name": transactionName,
        "date": formattedDate,
        "price": transactionAmount,
        "category": activeCategory['name'],
      };
      db.collection("transactions").doc().set(transaction).onError(
          (e, _) => printError("Error writing transactions document: $e"));

      calcTotal(
        // activeCategory: activeCategory,
        transactionAmount: transactionAmount,
      );
      update();
      customDialog(
        title: 'The Transaction Has Been Added',
        context: context,
        error: false,
      );
      // calculatePercentages();
    } else {
      customDialog(title: 'Please fill both the fields', context: context);
    }
  }

  calcTotal({
    // required activeCategory,
    required transactionAmount,
  }) async {
    double total = 0.0;

    // activeCategory['total'] += double.parse(transactionAmount);
    total += double.parse(transactionAmount);

    var totalStore = {
      'total': total,
    };
    db
        .collection("total")
        .doc('total')
        .set(totalStore)
        .onError((e, _) => printError("Error writing total document: $e"));
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
    db
        .collection("categories")
        .doc()
        .set(totalStore)
        .onError((e, _) => printError("Error writing total document: $e"));
  }

  addCategory({
    required String name,
    color,
  }) {
    var category = <String, dynamic>{
      "name": name,
      "percentage": 0.0,
      "total": 0.0,
    };
    db
        .collection("categories")
        .doc()
        .set(category)
        .onError((e, _) => printError("Error writing categories document: $e"));
    getCategoriesData();
    update();
  }

  getCategoriesData() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('categories');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    var allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
    // categories.addAll(allData);
  }

  getTransactionsData() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('transactions');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
    // categories.addAll(allData);
  }

  void calculatePercentages() {
    // double totalSum =
    //     categories.fold(0.0, (double sum, category) => sum + category["total"]);

    // for (var category in categories) {
    //   category["percentage"] = ((category["total"] / totalSum) * 100);
    // }

    // update();
  }
}
