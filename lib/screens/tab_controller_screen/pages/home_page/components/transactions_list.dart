import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/models/employee.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(
      builder: (context, transactionData, _) {
        return FutureBuilder<List<CashTransaction>>(
          future: transactionData.transactions,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 90,
                        child: Text(
                          "Hora",
                          textAlign: TextAlign.center,
                          style: CustomStyles.kSubtitleStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Tipo",
                          textAlign: TextAlign.center,
                          style: CustomStyles.kSubtitleStyle,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "Empleado",
                        textAlign: TextAlign.center,
                        style: CustomStyles.kSubtitleStyle,
                      )),
                      Container(
                        width: 120,
                        child: Text(
                          "Monto",
                          textAlign: TextAlign.center,
                          style: CustomStyles.kSubtitleStyle,
                        ),
                      ),
                      SizedBox(
                        width: 150,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        TransactionListItem(snapshot.data[index]),
                    itemCount: snapshot.data.length,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TransactionListItem extends StatelessWidget {
  TransactionListItem(this.transaction);
  final CashTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final employee = context.select<TransactionsProvider, Employee>(
        (data) => data.getEmployeeById(transaction.employeeId));
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 90,
              child: Text(
                DateFormat("hh:mm").format(transaction.date),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(
                transaction.getType(),
                textAlign: TextAlign.center,
                style: CustomStyles.kNormalStyle,
              ),
            ),
            Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(employee.imageUrl))),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  employee.name,
                  style: CustomStyles.kNormalStyle,
                )
              ],
            )),
            Container(
              width: 120,
              child: Text(
                transaction.isIncome()
                    ? "+\$" + transaction.amount.toStringAsFixed(2)
                    : "-\$" + transaction.amount.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: transaction.isIncome()
                    ? CustomStyles.kIncomeStyle
                    : CustomStyles.kExpenseStyle,
              ),
            ),
            SizedBox(
              width: 50,
            ),
            Container(
              width: 100,
              child: Text(
                "Ver Detalle",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.kAccentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
