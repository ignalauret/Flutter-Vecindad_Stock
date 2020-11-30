import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/components/confirmation_dialog.dart';
import 'package:vecindad_stock/components/dialog_header.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/components/products_cart_list.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class TransactionDetailDialog extends StatelessWidget {
  TransactionDetailDialog(this.transaction);
  final CashTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      title: DialogHeader(transaction.typeName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStat(
              "Fecha", DateFormat("dd/MM HH:mm").format(transaction.date)),
          _buildStat("Monto", "\$${transaction.amount.toStringAsFixed(2)}"),
          _buildStat("Empleado", transaction.employeeId),
          SizedBox(
            height: 20,
          ),
          if (transaction.type == TransactionType.Sell)
            Consumer<ProductsProvider>(
              builder: (context, productsData, _) => Container(
                height: 300,
                width: 700,
                child: ListView.builder(
                  itemBuilder: (context, index) => ProductsCartListItem(
                    productsData.getProductById(
                        transaction.products.keys.toList()[index]),
                    transaction.products.values.toList()[index],
                  ),
                  itemCount: transaction.products.length,
                ),
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 70,
                width: 140,
                child: ActionButton(
                  label: "Eliminar",
                  secondary: true,
                  color: Colors.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        message:
                            "Está seguro que quiere eliminar este movimiento de ${transaction.typeName}?",
                        onConfirmed: () => context
                            .read<TransactionsProvider>()
                            .deleteTransaction(transaction)
                            .then((value) => Navigator.of(context).pop(true)),
                      ),
                    ).then((deleted) {
                      if (deleted ?? false) Navigator.of(context).pop();
                    });
                  },
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                height: 70,
                width: 140,
                child: ActionButton(
                  label: "Editar",
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildStat(String label, String value) {
    return Container(
      child: Row(
        children: [
          Text(
            label + ":",
            style: CustomStyles.kAccentTextStyle,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            value,
            style: CustomStyles.kNormalStyle,
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
