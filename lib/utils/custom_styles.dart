import 'package:flutter/material.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';

class CustomStyles {
  static const kTitleStyle = TextStyle(
    color: CustomColors.kMainColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const kIncomeStyle = TextStyle(
    color: CustomColors.kGreenColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const kExpenseStyle = TextStyle(
    color: CustomColors.kRedColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const kSubtitleStyle = TextStyle(
    color: CustomColors.kGreyColor,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const kNormalStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
