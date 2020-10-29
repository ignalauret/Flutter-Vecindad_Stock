import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/utils/constants.dart';

class TransactionsProvider extends ChangeNotifier {
  TransactionsProvider() {
    getTransactions();
    getCash();
  }
  List<CashTransaction> _transactions;

  Future<List<CashTransaction>> get transactions async {
    if (_transactions == null) await getTransactions();
    return _transactions;
  }

  Future<void> getTransactions() async {
    _transactions = await fetchTransactions();
  }

  void addLocalTransaction(CashTransaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  Future<List<CashTransaction>> fetchTransactions() async {
    final response = await http.get(Constants.kApiPath + "/transactions.json");
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data == null) return [];
    final List<CashTransaction> temp = data.entries
        .map((entry) => CashTransaction.fromJson(entry.key, entry.value))
        .toList();
    return temp;
  }

  Future<bool> createTransaction(DateTime date, TransactionType type,
      String eid, double amount, Map<String, int> products) async {
    final transaction = CashTransaction(
      date: date,
      type: type,
      employeeId: eid,
      amount: amount,
      products: products,
    );
    final response = await http.post(
      Constants.kApiPath + "/transactions.json",
      body: jsonEncode(
        transaction.toJson(),
      ),
    );
    if (response.statusCode == 200) {
      transaction.id = jsonDecode(response.body)["name"];
      addLocalTransaction(transaction);
      if (transaction.isIncome()) {
        await updateCash(_cash + transaction.amount);
      } else {
        await updateCash(_cash - transaction.amount);
      }
      return true;
    } else {
      return false;
    }
  }

  /* Cash */
  double _cash;

  Future<double> get cash async {
    if (_cash == null) await getCash();
    return _cash;
  }

  Future<void> getCash() async {
    _cash = await fetchCash();
  }

  Future<double> fetchCash() async {
    final response = await http.get(Constants.kApiPath + "/cash.json");
    final double data = jsonDecode(response.body);
    return data;
  }

  Future<bool> updateCash(double newAmount) async {
    final response = await http.put(
      Constants.kApiPath + "/cash.json",
      body: "$newAmount",
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      _cash = newAmount;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
