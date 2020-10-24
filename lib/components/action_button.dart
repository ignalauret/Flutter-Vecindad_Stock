import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';

class ActionButton extends StatelessWidget {
  ActionButton({this.label, this.onTap});
  final String label;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 300,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CustomColors.kAccentColor,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
