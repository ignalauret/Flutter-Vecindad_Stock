import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';

class ActionButton extends StatelessWidget {
  ActionButton({this.label, this.onTap, this.fontSize = 25, this.secondary = false});
  final String label;
  final Function onTap;
  final double fontSize;
  final bool secondary;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: secondary ? null : CustomColors.kAccentColor,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          border: secondary ? Border.all(color: CustomColors.kAccentColor, width: 2) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: secondary ? CustomColors.kAccentColor : Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
