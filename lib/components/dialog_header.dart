import 'package:flutter/material.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class DialogHeader extends StatelessWidget {
  DialogHeader(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: CustomStyles.kTitleStyle,
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
