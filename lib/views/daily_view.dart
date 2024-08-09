import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/transactions_controller.dart';
import '/common/color_constants.dart';
import '/json/day_month.dart';

class DailyView extends StatefulWidget {
  const DailyView({super.key});

  @override
  _DailyViewState createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  int activeDay = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<TransactionsController>(
        init: TransactionsController(),
        builder: (controller) => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: grey.withOpacity(0.08),
                    spreadRadius: 10,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: Get.height * 0.075,
                  right: Get.width * 0.05,
                  left: Get.width * 0.05,
                  bottom: Get.height * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daily Transaction",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: black),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
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
                              width: (Get.width * 0.9) / 7,
                              child: Column(
                                children: [
                                  Text(
                                    days[index]['label'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.015,
                                  ),
                                  Container(
                                    height: Get.height * 0.04,
                                    decoration: BoxDecoration(
                                      color: activeDay == index
                                          ? primary
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: activeDay == index
                                            ? primary
                                            : black.withOpacity(
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
                                                ? white
                                                : black),
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
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: (Get.width * 0.1) / 2),
                    child: Column(
                      children: List.generate(
                        controller.dailyTransactions.length,
                        (index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.dailyTransactions[index]
                                            ['name'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: black,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${controller.dailyTransactions[index]['category']} . ${controller.dailyTransactions[index]['date']}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: black.withOpacity(0.5),
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${controller.dailyTransactions[index]['price']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: Get.width * 0.02),
                                child: const Divider(
                                  thickness: 0.8,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: (Get.width * 0.1) / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                        fontSize: 16,
                        color: black.withOpacity(0.4),
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "\$${controller.total}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
