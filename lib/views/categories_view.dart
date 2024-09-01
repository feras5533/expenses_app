import 'package:expenses_app/common/prints.dart';
import 'package:flutter/material.dart';

import '/controllers/categories_controller.dart';
import '/common/color_constants.dart';
import '/json/day_month.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({
    super.key,
    required this.categories,
  });

  final List categories;
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  void initState() {
    super.initState();
    printWarning('CategoriesView init state');
  }

  int activeMonth = 3;

  bool isLoading = false;

  // getCategoriesData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   TransactionsController request = TransactionsController();
  //   widget.categories = await request.getCategoriesData();
  //   widget.categories = TransactionsController.categoriesList;
  //   printWarning(widget.categories);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  addCategory() async {
    CategoriesController request = CategoriesController(context: context);
    await request.addCategoryPopup();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.grey.withOpacity(0.08),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.grey.withOpacity(0.08),
                  spreadRadius: 10,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: height * 0.075,
                right: width * 0.05,
                left: width * 0.05,
                bottom: height * 0.03,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black),
                      ),
                      IconButton(
                        onPressed: () {
                          addCategory();
                        },
                        icon: const Icon(Icons.add),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        months.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                activeMonth = index;
                              });
                            },
                            child: SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width - 40) / 6,
                              child: Column(
                                children: [
                                  Text(
                                    months[index]['label'],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: activeMonth == index
                                            ? AppTheme.primaryColor
                                            : AppTheme.black.withOpacity(0.02),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: activeMonth == index
                                                ? AppTheme.primaryColor
                                                : AppTheme.black
                                                    .withOpacity(0.1))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          top: 7,
                                          bottom: 7),
                                      child: Text(
                                        months[index]['day'],
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: activeMonth == index
                                                ? AppTheme.white
                                                : AppTheme.black),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.categories.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,),
                          child: Column(children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: height * 0.015),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.02),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        //change
                                        widget.categories[index]['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: const Color(0xff67727d)
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                //change
                                                "\$${widget.categories[index]['total']}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${(widget.categories[index]['percentage']).toStringAsFixed(2)}%",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: const Color(0xff67727d)
                                                  .withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            height: 4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: const Color(0xff67727d)
                                                  .withOpacity(0.1),
                                            ),
                                          ),
                                          Container(
                                            width: widget.categories[index]
                                                    ['percentage'] *
                                                3,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: widget.categories[index]
                                                  ['color'],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
