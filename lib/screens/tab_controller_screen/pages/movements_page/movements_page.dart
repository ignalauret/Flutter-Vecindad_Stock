import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/home_page/components/transactions_list.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class MovementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 80,
                  width: 230,
                  child: ActionButton(
                    label: "Agregar Movimiento",
                    fontSize: 20,
                    onTap: () {
                      Provider.of<TransactionsProvider>(context, listen: false)
                          .createTransaction();
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Todos los movimientos",
              style: CustomStyles.kTitleStyle,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              child: TransactionsList(),
            ),
          ),
        ],
      ),
    );
  }
}
