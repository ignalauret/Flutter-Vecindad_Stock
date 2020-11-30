import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';

class ActionButton extends StatelessWidget {
  ActionButton(
      {this.label,
      this.onTap,
      this.fontSize = 25,
      this.secondary = false,
      this.color = CustomColors.kAccentColor});
  final String label;
  final Function onTap;
  final double fontSize;
  final bool secondary;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: secondary ? null : color,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          border: secondary ? Border.all(color: color, width: 2) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: secondary ? color : Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
