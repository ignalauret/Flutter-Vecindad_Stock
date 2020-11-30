import 'package:flutter/material.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(this.label, this.controller);

  final TextEditingController controller;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            style: CustomStyles.kNormalStyle,
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        ],
      ),
    );
  }
}
