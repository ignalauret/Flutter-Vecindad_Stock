import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/models/employee.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/time_utils.dart';

class TransactionsProvider extends ChangeNotifier {
  TransactionsProvider() {
    getTransactions();
    getCash();
    getEmployees();
  }
  List<CashTransaction> _transactions;

  Future<List<CashTransaction>> get transactions async {
    if (_transactions == null) await getTransactions();
    return [..._transactions];
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
      double amount, Map<String, int> products) async {
    final transaction = CashTransaction(
      date: date,
      type: type,
      employeeId: selectedEmployee,
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

  Future<double> get todayCash async {
    if (_transactions == null) await getTransactions();
    return _transactions.fold<double>(
        0.0,
        (prev, tran) => TimeUtils.isSameDay(DateTime.now(), tran.date)
            ? prev + tran.getRealAmount()
            : prev);
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

  /* Employees */
  String selectedEmployee = "A";

  List<Employee> _employees;

  Future<List<Employee>> get employees async {
    if (_employees == null) await getEmployees();
    return [..._employees];
  }

  Future<void> getEmployees() async {
    _employees = await fetchEmployees();
  }

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Constants.kApiPath + "/employees.json");
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data == null) return [];
    final List<Employee> temp = data.entries
        .map((entry) => Employee.fromJson(entry.key, entry.value))
        .toList();
    return temp;
  }

  void selectEmployee(String id) {
    selectedEmployee = id;
    notifyListeners();
  }

  Employee getEmployeeById(String id) {
    return _employees.firstWhere((employee) => employee.id == id);
  }
}
