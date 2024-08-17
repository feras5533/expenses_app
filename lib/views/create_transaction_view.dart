import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/transactions_controller.dart';
import '/common/color_constants.dart';

class CreatTransactionView extends StatefulWidget {
  const CreatTransactionView({super.key});

  @override
  _CreatTransactionViewState createState() => _CreatTransactionViewState();
}

class _CreatTransactionViewState extends State<CreatTransactionView> {
  int activeCategory = 0;
  final TextEditingController _transactionName = TextEditingController();
  final TextEditingController _transactionAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey.withOpacity(0.05),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: AppTheme.white, boxShadow: [
              BoxShadow(
                color: AppTheme.grey.withOpacity(0.08),
                spreadRadius: 10,
                blurRadius: 3,
              ),
            ]),
            child: Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.075,
                right: Get.width * 0.05,
                left: Get.width * 0.05,
                bottom: Get.height * 0.03,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Create A Transaction",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<TransactionsController>(
            init: TransactionsController(),
            builder: (controller) => Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 15,
                ),
                children: [
                  Text(
                    "Choose The Transaction Type",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black.withOpacity(0.5)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        categories.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  activeCategory = index;
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(
                                7,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    border: Border.all(
                                        width: 2,
                                        color: activeCategory == index
                                            ? AppTheme.primaryColor
                                            : Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: Column(
                                    children: [
                                      Text(
                                        categories[index]['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.width * 0.15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "transaction name",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Color(0xff67727d)),
                      ),
                      TextFormField(
                        controller: _transactionName,
                        cursorColor: AppTheme.black,
                        textInputAction: TextInputAction.next,
                        onTapOutside: (event) {
                          Get.focusScope!.unfocus();
                        },
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black),
                        decoration: const InputDecoration(
                          hintText: "Enter The Transaction Name",
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Transaction Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          TextFormField(
                            controller: _transactionAmount,
                            keyboardType: TextInputType.number,
                            onTapOutside: (event) {
                              Get.focusScope!.unfocus();
                            },
                            onFieldSubmitted: (value) {
                              Get.focusScope!.unfocus();
                            },
                            cursorColor: AppTheme.black,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.black,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Enter The Transaction Amount",
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          controller.addTransaction(
                            activeCategory: activeCategory,
                            transactionName: _transactionName.text,
                            transactionAmount: _transactionAmount.text,
                            context: context,
                          );

                          setState(() {
                            _transactionName.text = "";
                            _transactionAmount.text = "";
                          });
                        },
                        borderRadius: BorderRadius.circular(15),
                        hoverColor: Colors.grey.withOpacity(0.2),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            Icons.arrow_forward,
                            color: AppTheme.black,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
