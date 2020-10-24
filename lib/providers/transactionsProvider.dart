import 'package:flutter/material.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';

class TransactionsProvider extends ChangeNotifier {
  List<CashTransaction> _transactions;

  Future<List<CashTransaction>> get transactions async {
    if (_transactions != null) return [..._transactions];
    _transactions = await fetchTransactions();
    return _transactions;
  }

  Future<List<CashTransaction>> fetchTransactions() async {
    await Future.delayed(Duration(seconds: 2));
    final temp = [
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
    return temp;
  }

  Future<bool> createTransaction() async {
    final transaction = CashTransaction(
      date: DateTime.now(),
      type: TransactionType.Sell,
      employeeId: "0",
      amount: 1200,
    );
    _transactions.add(transaction);
    notifyListeners();
    return true;
  }
}
