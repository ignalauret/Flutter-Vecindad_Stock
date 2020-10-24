import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vecindad_stock/models/cash_transaction.dart';

class TransactionsProvider extends ChangeNotifier {
  List<CashTransaction> _transactions;

  Future<List<CashTransaction>> get transactions async {
    if (_transactions != null) return [..._transactions];
    _transactions = await fetchTransactions();
    return _transactions;
  }

  Future<List<CashTransaction>> fetchTransactions() async {
    final response = await http
        .get("https://la-vecindad-c834d.firebaseio.com/transactions.json");
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<CashTransaction> temp = data.entries.map((entry) => CashTransaction.fromJson(entry.key, entry.value)).toList();
    return temp;
  }

  Future<bool> createTransaction() async {
    final transaction = CashTransaction(
      date: DateTime.now(),
      type: TransactionType.Sell,
      employeeId: 0,
      amount: 1200,
    );
    final response = await http.post(
      "https://la-vecindad-c834d.firebaseio.com/transactions.json",
      body: jsonEncode(
        transaction.toJson(),
      ),
    );
    if(response.statusCode == 200) {
      transaction.id = jsonDecode(response.body)["name"];
      _transactions.add(transaction);
      notifyListeners();
      return true;
    } else {
      return false;
    }

  }
}
