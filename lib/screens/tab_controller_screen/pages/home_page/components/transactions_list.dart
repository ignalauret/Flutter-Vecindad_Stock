import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class TransactionsList extends StatelessWidget {
  final List<CashTransaction> transactions = [
    CashTransaction(
        date: DateTime.now(),
        type: TransactionType.Sell,
        employeeId: "0",
        amount: 350),
    CashTransaction(
        date: DateTime.now(),
        type: TransactionType.Extraction,
        employeeId: "0",
        amount: 5000),
    CashTransaction(
        date: DateTime.now(),
        type: TransactionType.Sell,
        employeeId: "0",
        amount: 30),
    CashTransaction(
        date: DateTime.now(),
        type: TransactionType.Deposit,
        employeeId: "0",
        amount: 500),
    CashTransaction(
        date: DateTime.now(),
        type: TransactionType.Sell,
        employeeId: "0",
        amount: 1200),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => TransactionListItem(transactions[index]),
      itemCount: transactions.length,
    );
  }
}

class TransactionListItem extends StatelessWidget {
  TransactionListItem(this.transaction);
  final CashTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius)
      ),
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
                        image: AssetImage("assets/img/profile.jpeg")
                      )
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("Bruno", style: CustomStyles.kNormalStyle,)
                ],
              )
            ),
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
