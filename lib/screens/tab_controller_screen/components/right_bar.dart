import 'package:flutter/material.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class RightBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            child: Text(
              "Productos",
              style: CustomStyles.kTitleStyle,
            ),
          ),
          Spacer(),
          ActionButton(
            label: "Nueva Venta",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
