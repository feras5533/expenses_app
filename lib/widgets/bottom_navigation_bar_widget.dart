import 'package:expenses_app/views/profile_view.dart';
import 'package:expenses_app/views/stats_view.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
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

  int pageIndex = 0;

  selectedTab(index) {
    setState(() {
      initData();
      pageIndex = index;
    });
  }

  initData() async {
    pages = [
      const DailyTransactionView(),
      const CategoriesView(),
      const StatsView(),
      const ProfileView(),
      const CreatTransactionView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
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
