import 'package:flutter/material.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/home_page/home_page.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/monthly_summary_detail_page/monthly_summary_detail_page.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/movements_page/movements_page.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/products_page/products_page.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/summary_page/summary_page.dart';

import 'components/right_bar.dart';
import 'components/side_bar.dart';

class TabControllerScreen extends StatefulWidget {
  @override
  _TabControllerScreenState createState() => _TabControllerScreenState();
}

class _TabControllerScreenState extends State<TabControllerScreen> {
  int selectedPageIndex = 0;
  Widget selectedPage;

  @override
  void initState() {
    selectedPage = HomePage();
    super.initState();
  }

  void showSummaryDetailPage(int month, int year) {
    setState(() {
      selectedPage = MonthlySummaryDetailPage(
          month, year, () => selectPage(selectedPageIndex));
    });
  }

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
    switch (index) {
      case 0:
        selectedPage = HomePage();
        break;
      case 1:
        selectedPage = ProductsPage();
        break;
      case 2:
        selectedPage = MovementsPage();
        break;
      case 3:
        selectedPage = SummaryPage(showSummaryDetailPage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Row(
        children: [
          Container(
            height: size.height,
            width: size.width * 0.15,
            child: SideBar(
              selectPage: selectPage,
              selectedIndex: selectedPageIndex,
            ),
          ),
          Container(
            height: size.height,
            width: size.width * 0.6,
            padding: const EdgeInsets.all(50),
            child: selectedPage,
          ),
          Container(
            color: Colors.black12,
            height: size.height * 0.9,
            width: 2,
          ),
          Container(
            height: size.height,
            width: size.width * 0.25 - 3,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            child: RightBar(),
          ),
        ],
      ),
    );
  }
}
