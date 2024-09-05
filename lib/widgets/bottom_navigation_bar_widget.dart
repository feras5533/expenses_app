import 'package:expenses_app/views/profile_view.dart';
import 'package:expenses_app/views/stats_view.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../common/prints.dart';
import '/controllers/transactions_controller.dart';
import '/common/color_constants.dart';
import '/views/categories_view.dart';
import '/views/create_transaction_view.dart';
import '/views/daily_transaction_view.dart';

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
  List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
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

  selectedTab(index) {
    setState(() {
      initData();
      pageIndex = index;
    });
  }

  initData() async {
    await getCategoriesData();
    await getTransactionsData();

    pages = [
      DailyTransactionView(
        transactions: transactions,
        key: navigatorKeys[1],
      ),
      CategoriesView(
        // categories: categories,
        key: navigatorKeys[2],
      ),
      StatsView(
        key: navigatorKeys[4],
      ),
      ProfileView(
        key: navigatorKeys[3],
      ),
      CreatTransactionView(
        categories: categories,
        key: navigatorKeys[0],
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
          : IndexedStack(
              index: pageIndex,
              children: pages,
            ),
      bottomNavigationBar: navBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          initData();
          selectedTab(4);
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

  Widget navBar() {
    List<IconData> iconItems = [
      Icons.wallet,
      Icons.calendar_month,
      Icons.stacked_bar_chart,
      Icons.person,
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
}
