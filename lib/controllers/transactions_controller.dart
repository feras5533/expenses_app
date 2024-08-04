import 'package:expenses_app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/common/color_constants.dart';

List categories = [
  {
    "name": "Food",
    "percentage": 0.0,
    "total": 0.0,
    "color": green,
  },
  {
    "name": "Gift",
    "percentage": 0.0,
    "total": 0.0,
    "color": blue,
  },
  {
    "name": "Charity",
    "percentage": 0.0,
    "total": 0.0,
    "color": red,
  },
  {
    "name": "Transportation",
    "percentage": 0.0,
    "total": 0.0,
    "color": orange,
  },
];

class TransactionsController extends GetxController {
  List dailyTransactions = [];
  double total = 0.0;

  void addTransaction({
    required activeCategory,
    required transactionName,
    required transactionAmount,
    required context,
  }) {
    if (transactionName.isNotEmpty && transactionAmount.isNotEmpty) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      dailyTransactions.add({
        "name": transactionName,
        "date": formattedDate,
        "price": "\$$transactionAmount",
        "category": categories[activeCategory]['name'],
      });
      categories[activeCategory]['total'] += double.parse(transactionAmount);
      total += double.parse(transactionAmount);
      update();
      customDialog(
        title: 'The Transaction Has Been Added',
        context: context,
        error: false,
      );
      calculatePercentages();
    } else {
      customDialog(title: 'Please fill both the fields', context: context);
    }
  }

  List<dynamic> addCategory({
    required String name,
    color = green,
  }) {
    categories.add({
      "name": name,
      "percentage": 0.0,
      "total": 0.0,
      "color": color,
    });
    update();
    return categories;
  }

  void calculatePercentages() {
    double totalSum =
        categories.fold(0.0, (sum, category) => sum + category["total"]);

    for (var category in categories) {
      category["percentage"] = ((category["total"] / totalSum) * 100);
    }

    update();
  }
}
