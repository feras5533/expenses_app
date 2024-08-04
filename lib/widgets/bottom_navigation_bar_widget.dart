import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '/common/color_constants.dart';
import '/views/budget_view.dart';
import '/views/create_transaction_view.dart';
import '/views/daily_view.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int pageIndex = 0;

  List<Widget> pages = [
    const DailyView(),
    const BudgetView(),
    const CreatTransactionView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body(),
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
      activeColor: primary,
      splashColor: secondary,
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
      pageIndex = index;
    });
  }
}
