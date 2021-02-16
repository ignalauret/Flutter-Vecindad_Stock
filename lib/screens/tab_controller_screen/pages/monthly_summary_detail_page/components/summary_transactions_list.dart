import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/models/employee.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/movements_page/components/transaction_detail_dialog.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class SummaryTransactionsList extends StatelessWidget {
  SummaryTransactionsList(this.month, this.year, this.type);
  final int month;
  final int year;
  final TransactionType type;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CashTransaction>>(
      future: context
          .watch<TransactionsProvider>()
          .getSummaryTransactionsOfType(type, month, year),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) =>
                SummaryTransactionsListItem(snapshot.data[index]),
            itemCount: snapshot.data.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class SummaryTransactionsListItem extends StatelessWidget {
  SummaryTransactionsListItem(this.transaction);
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 100,
              child: Text(
                DateFormat("dd/MM HH:mm").format(transaction.date),
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
                transaction.description,
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
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(employee.imageUrl))),
                ),
                SizedBox(width: 10),
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
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => TransactionDetailDialog(transaction),
                );
              },
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
