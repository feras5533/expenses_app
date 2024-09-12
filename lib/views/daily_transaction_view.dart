import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_app/common/prints.dart';
import 'package:expenses_app/models/transaction_model.dart';
import 'package:expenses_app/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/controllers/transactions_controller.dart';
import '/common/color_constants.dart';
import '/json/day_month.dart';

class DailyTransactionView extends StatefulWidget {
  const DailyTransactionView({
    super.key,
  });

  @override
  _DailyTransactionViewState createState() => _DailyTransactionViewState();
}

class _DailyTransactionViewState extends State<DailyTransactionView> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;

  bool isLoading = true;
  int activeDay = 3;
  // CollectionReference? totalTransactions;
  CollectionReference<TransactionModel>? transactions;

  transactionView() async {
    TransactionsController request = TransactionsController();
    transactions = await request.getTransactionsData();
  }

  calcTotal() {
    TransactionsController request = TransactionsController();
    return request.calcTotal();
  }

  initData() async {
    await transactionView();
    await calcTotal();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return customScaffold(
      toolbarHeight: height * 0.2,
      appBarTitle: appBar(
        height: height,
        width: width,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : StreamBuilder<QuerySnapshot<TransactionModel>>(
              stream: transactions!.where('id', isEqualTo: userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<TransactionModel> transactionList =
                      snapshot.data!.docs.map((doc) => doc.data()).toList();
                  return Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: transactionList.length,
                          itemBuilder: (context, index) {
                            final TransactionModel transaction =
                                transactionList[index];

                            return customTransaction(
                                width, transactionList, transaction);
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: (width * 0.1) / 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.black.withOpacity(0.4),
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: StreamBuilder<double>(
                                stream: calcTotal(), // Inject the stream here.
                                builder: (context, snapshot) {
                                  printWarning(
                                      'snapshot.data ${snapshot.data}');
                                  if (snapshot.hasData) {
                                    // Render the UI with the total value.
                                    return Text(
                                      "\$${snapshot.data!.toStringAsFixed(2)}", // Format the total to two decimal places.
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppTheme.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  } else {
                                    return Text(
                                      "\$ ${snapshot.data}", // Default text when no data is available.
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppTheme.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('There is no Categories yet\n Try Adding some'),
                  );
                }
              }),
    );
  }

  Padding customTransaction(
    double width,
    List<TransactionModel> transactionList,
    TransactionModel transaction,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (width * 0.1) / 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.name,
                    style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.black,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${transaction.category} . ${transaction.date}",
                    style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.black.withOpacity(0.5),
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                "\$ ${transaction.price}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: width * 0.02),
            child: const Divider(
              thickness: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  appBar({
    height,
    width,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Daily Transactions",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.03,
        ),
        //change
        Row(
          children: List.generate(
            days.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    //change
                    activeDay = index;
                  });
                },
                child: SizedBox(
                  width: (width * 0.9) / 7,
                  child: Column(
                    children: [
                      Text(
                        days[index]['label'],
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Container(
                        height: height * 0.04,
                        decoration: BoxDecoration(
                          color: activeDay == index
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: activeDay == index
                                ? AppTheme.primaryColor
                                : AppTheme.black.withOpacity(
                                    0.2,
                                  ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            days[index]['day'],
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: activeDay == index
                                    ? AppTheme.white
                                    : AppTheme.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
