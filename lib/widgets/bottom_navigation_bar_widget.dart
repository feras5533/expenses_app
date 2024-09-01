import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '/controllers/transactions_controller.dart';
import '/common/color_constants.dart';
import '/views/categories_view.dart';
import '/views/create_transaction_view.dart';
import '/views/daily_transaction_view.dart';
import '/common/prints.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  List<Widget> pages = [];
  List categories = [];
  List transactions = [];

  int pageIndex = 0;
  bool isLoading = true;

  getCategoriesData() async {
    TransactionsController request = TransactionsController();
    categories = await request.getCategoriesData();
    printWarning(categories);
  }

  getTransactionsData() async {
    TransactionsController request = TransactionsController();
    transactions = await request.getTransactionsData();
    printWarning(transactions);
  }

  initData() async {
    await getCategoriesData();
    await getTransactionsData();

    pages = [
      DailyTransactionView(
        transactions: transactions,
      ),
      CategoriesView(
        categories: categories,
      ),
      CreatTransactionView(
        categories: categories,
      ),
    ];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : body(),
      bottomNavigationBar: navBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectedTab(2);
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget body() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget navBar() {
    List<IconData> iconItems = [
      Icons.calendar_month,
      Icons.wallet,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: AppTheme.primaryColor,
      splashColor: AppTheme.secondaryColor,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 20,
      iconSize: 25,
      rightCornerRadius: 20,
      onTap: (index) {
        selectedTab(index);
      },
    );
  }

  selectedTab(index) {
    setState(() {
      getCategoriesData();
      getTransactionsData();
      pageIndex = index;
    });
  }
}
