import 'package:flutter/material.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class SideBar extends StatelessWidget {
  SideBar({this.selectPage, this.selectedIndex});

  final Function selectPage;
  final int selectedIndex;

  Widget _buildMenuItem(int index, String label, IconData icon) {
    return InkWell(
      onTap: () {
        selectPage(index);
      },
      child: Container(
        height: 40,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            Icon(
              icon,
              color: selectedIndex == index
                  ? CustomColors.kAccentColor
                  : Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: TextStyle(
                color: selectedIndex == index
                    ? CustomColors.kAccentColor
                    : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            alignment: Alignment.center,
            child: Image.asset("assets/img/logo.png"),
          ),
          _buildMenuItem(0, "Inicio", Icons.home_filled),
          _buildMenuItem(1, "Productos", Icons.local_grocery_store),
          _buildMenuItem(1, "Movimientos", Icons.compare_arrows),
        ],
      ),
    );
  }
}
