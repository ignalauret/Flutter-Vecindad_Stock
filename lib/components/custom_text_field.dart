import 'package:flutter/material.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(this.label, this.controller, {this.obscure = false, this.onSubmit});

  final TextEditingController controller;
  final String label;
  final bool obscure;
  final Function onSubmit;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            style: CustomStyles.kNormalStyle,
            controller: controller,
            obscureText: obscure,
            onSubmitted: onSubmit,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        ],
      ),
    );
  }
}
