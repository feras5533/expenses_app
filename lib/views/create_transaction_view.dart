import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_app/common/prints.dart';
import 'package:expenses_app/widgets/custom_scaffold.dart';
import 'package:expenses_app/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/categories_model.dart';
import '/controllers/transactions_controller.dart';
import '/common/color_constants.dart';

class CreatTransactionView extends StatefulWidget {
  const CreatTransactionView({
    super.key,
  });

  @override
  _CreatTransactionViewState createState() => _CreatTransactionViewState();
}

class _CreatTransactionViewState extends State<CreatTransactionView> {
  @override
  void initState() {
    super.initState();
    getCategoriesData();
  }

  final TextEditingController _transactionName = TextEditingController();
  final TextEditingController _transactionAmount = TextEditingController();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<CategoriesModel>? categories;

  int activeCategory = 0;
  String categoryName = '';
  bool isLoading = true;
  getCategoriesData() async {
    TransactionsController request = TransactionsController();
    categories = await request.getCategoriesData();
    setState(() {
      isLoading = false;
    });
  }

  addTransaction() async {
    TransactionsController request = TransactionsController();
    if (_transactionName.text.isNotEmpty &&
        _transactionAmount.text.isNotEmpty) {
      await request.addTransaction(
        //categories[activeCategory]
        activeCategory: categoryName,
        transactionName: _transactionName.text,
        transactionAmount: _transactionAmount.text,
        context: context,
      );

      setState(() {
        _transactionName.clear();
        _transactionAmount.clear();
      });
    } else {
      customDialog(title: 'the fields must be filled', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return customScaffold(
      toolbarHeight: height * 0.08,
      appBarTitle: Text(
        "Create A Transaction",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Choose The Transaction Category",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black.withOpacity(0.5)),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ))
                  : StreamBuilder<QuerySnapshot<CategoriesModel>>(
                      stream: categories!
                          .where('id', isEqualTo: userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<CategoriesModel> categoriesList = snapshot
                              .data!.docs
                              .map((doc) => doc.data())
                              .toList();

                          return SizedBox(
                            height: 100,
                            child: ListView.builder(
                              itemCount: categoriesList.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final CategoriesModel category =
                                    categoriesList[index];

                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            activeCategory = index;
                                            categoryName = category.name;
                                          },
                                        );
                                        printWarning(category.name);
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppTheme.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                ),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(25),
                                            child: Column(
                                              children: [
                                                Text(
                                                  category.name,
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
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text(
                                'There is no Categories yet\n Try Adding some'),
                          );
                        }
                      },
                    ),
              SizedBox(
                height: width * 0.15,
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
                      FocusScope.of(context).unfocus();
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
                      FocusScope.of(context).unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
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
                  InkWell(
                    onTap: () {
                      addTransaction();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
