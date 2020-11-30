import 'package:flutter/material.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class ConfirmationDialog extends StatelessWidget {
  ConfirmationDialog({this.message, this.onConfirmed});
  final String message;
  final VoidCallback onConfirmed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      title: Text(
        message,
        style: CustomStyles.kNormalStyle,
      ),
      actions: [
        FlatButton(
          child: Text(
            "Cancelar",
            style: CustomStyles.kSubtitleStyle,
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text(
            "Confirmar",
            style: CustomStyles.kAccentTextStyle,
          ),
          onPressed: onConfirmed,
        ),
      ],
    );
  }
}
