import 'package:flutter/material.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class CreateTransactionDialog extends StatefulWidget {
  @override
  _CreateTransactionDialogState createState() => _CreateTransactionDialogState();
}

class _CreateTransactionDialogState extends State<CreateTransactionDialog> {
  final priceController = TextEditingController();

  TransactionType selectedType = TransactionType.Extraction;

  Widget _buildFieldInput(String label, TextEditingController controller) {
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

  Widget _buildTypeSelector(TransactionType type) {
    if (type == TransactionType.Sell) return Container();
    return InkWell(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        height: 80,
        width: 150,
        margin: const EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: type == selectedType ? CustomColors.kAccentColor : Colors.white,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          border: Border.all(color: CustomColors.kAccentColor, width: 2),
        ),
        child: Text(
          type.toString().split(".").last,
          style: CustomStyles.kTitleStyle.copyWith(
            color: type == selectedType ? Colors.white : CustomColors.kAccentColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Agregar Movimiento",
            style: CustomStyles.kTitleStyle,
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: Container(
        height: 350,
        width: 700,
        child: Column(
          children: [
            Container(
              child: Row(
                children: TransactionType.values
                    .map((type) => _buildTypeSelector(type))
                    .toList(),
              ),
            ),
            Container(
              height: 100,
              width: 300,
              child: _buildFieldInput("Monto", priceController),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          height: 90,
          width: 180,
          margin: const EdgeInsets.all(20),
          child: ActionButton(
            label: "Agregar",
            fontSize: 25,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
