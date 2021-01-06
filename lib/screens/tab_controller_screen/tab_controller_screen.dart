import 'package:flutter/material.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/home_page/home_page.dart';
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

  final List<Widget> _pages = [
    HomePage(),
    ProductsPage(),
    MovementsPage(),
    SummaryPage(),
  ];


  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
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
            child: _pages[selectedPageIndex],
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
