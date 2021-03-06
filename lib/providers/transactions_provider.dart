import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/models/employee.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/utils.dart';

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

  CashTransaction getTransactionById(String tid) {
    return _transactions.firstWhere((tran) => tran.id == tid);
  }

  void addLocalTransaction(CashTransaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void removeLocalTransaction(String tid) {
    _transactions.removeWhere((tran) => tran.id == tid);
    notifyListeners();
  }

  void editLocalTransaction({
    String tid,
    String description,
    DateTime date,
    TransactionType type,
    double amount,
    Map<String, Map<String, int>> products,
    String employee,
    PaymentMethod method,
    int cashPayment,
  }) {
    final CashTransaction transaction = getTransactionById(tid);
    transaction.description = description;
    transaction.date = date;
    transaction.type = type;
    transaction.amount = amount;
    transaction.products = products;
    transaction.employeeId = employee;
    transaction.paymentMethod = method;
    transaction.cashPaymentAmount = cashPayment;
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

  Future<bool> createTransaction(
    BuildContext context, {
    String description,
    DateTime date,
    TransactionType type,
    double amount,
    int cashPayment,
    Map<String, Map<String, int>> products,
    String employee,
    PaymentMethod method,
  }) async {
    final transaction = CashTransaction(
      description: description,
      date: date,
      type: type,
      paymentMethod: method,
      cashPaymentAmount: cashPayment,
      employeeId: employee ?? selectedEmployee,
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
      // Update products stocks
      if (type == TransactionType.Sell) {
        await context.read<ProductsProvider>().sellProducts(
              products.keys.toList(),
              products.values.map((map) => map["amount"]).toList(),
            );
      }
      transaction.id = jsonDecode(response.body)["name"];
      addLocalTransaction(transaction);
      // Update cash
      if (type == TransactionType.Sell) {
        if (method == PaymentMethod.Cash) {
          await updateCash(_cash + transaction.amount);
        } else if (method == PaymentMethod.Mixed) {
          await updateCash(_cash + transaction.cashPaymentAmount);
        }
      } else if (transaction.isIncome()) {
        await updateCash(_cash + transaction.amount);
      } else {
        await updateCash(_cash - transaction.amount);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteTransaction(
      BuildContext context, CashTransaction transaction) async {
    final response = await http
        .delete(Constants.kApiPath + "/transactions/${transaction.id}.json");
    if (response.statusCode == 200) {
      if (transaction.type == TransactionType.Sell) {
        if (transaction.paymentMethod == PaymentMethod.Cash) {
          await updateCash(_cash - transaction.amount);
        } else if (transaction.paymentMethod == PaymentMethod.Mixed) {
          await updateCash(_cash - transaction.cashPaymentAmount);
        }
      } else if (transaction.isIncome()) {
        await updateCash(_cash - transaction.amount);
      } else {
        await updateCash(_cash + transaction.amount);
      }
      if (transaction.type == TransactionType.Sell) {
        await context.read<ProductsProvider>().sellProducts(
            transaction.products.keys.toList(),
            transaction.products.values
                .map((map) => map["amount"] * -1)
                .toList());
      }
      removeLocalTransaction(transaction.id);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editTransaction(
    BuildContext context, {
    String id,
    String description,
    DateTime date,
    TransactionType type,
    double amount,
    Map<String, Map<String, int>> products,
    String employee,
    PaymentMethod method,
    int cashPayment,
  }) async {
    final response = await http.patch(
      Constants.kApiPath + "/transactions/$id.json",
      body: jsonEncode(
        {
          "description": description,
          "date": date.toString(),
          "type": CashTransaction.getParsedType(type),
          "amount": amount,
          "products": products,
          "eid": employee,
          "paymentMethod": CashTransaction.getParsedPaymentMethod(method),
          "cashPaymentAmount": cashPayment,
        },
      ),
    );
    if (response.statusCode == 200) {
      final transaction = getTransactionById(id);
      if (amount != transaction.amount || type != transaction.type) {
        if (CashTransaction.typeIsIncome(type)) {
          await addToCash(amount - transaction.getRealAmount());
        } else {
          await addToCash(amount * -1 - transaction.getRealAmount());
        }
      }
      if (transaction.type == TransactionType.Sell) {
        // Sell new products and old products for an amount of (newProductAmount - oldProductAmount).
        final Map<String, int> productsBalance =
            products.map((key, value) => MapEntry(key, value["amount"]));
        transaction.products.forEach((key, value) {
          productsBalance[key] = (productsBalance[key] ?? 0) - value["amount"];
        });
        await context.read<ProductsProvider>().sellProducts(
            productsBalance.keys.toList(),
            products.values.map((map) => map["amount"]).toList());
      }
      editLocalTransaction(
        tid: id,
        description: description,
        employee: employee,
        products: products,
        date: date,
        amount: amount,
        type: type,
        method: method,
        cashPayment: cashPayment,
      );
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

  Future<double> get todaySells async {
    if (_transactions == null) await getTransactions();
    return _transactions.fold<double>(
        0.0,
        (prev, tran) => tran.date.isAfter(Utils.openDate) &&
                tran.date.isBefore(Utils.closeDate) &&
                tran.type == TransactionType.Sell
            ? prev + tran.getRealAmount()
            : prev);
  }

  Future<double> get todayCardSells async {
    if (_transactions == null) await getTransactions();
    return _transactions.fold<double>(
        0.0,
        (prev, tran) => tran.date.isAfter(Utils.openDate) &&
                tran.date.isBefore(Utils.closeDate) &&
                tran.type == TransactionType.Sell &&
                tran.paymentMethod != PaymentMethod.Cash
            ? prev + tran.getCardAmount()
            : prev);
  }

  Future<double> get todayTips async {
    if (_transactions == null) await getTransactions();
    return _transactions.fold<double>(
        0.0,
        (prev, tran) => tran.date.isAfter(Utils.openDate) &&
                tran.date.isBefore(Utils.closeDate) &&
                tran.type == TransactionType.PositiveTip
            ? prev + tran.getRealAmount()
            : prev);
  }

  Future<Map<String, double>> getDateSummary(DateTime date) async {
    if (_transactions == null) await getTransactions();
    double sells = 0.0;
    double cardSells = 0.0;
    double cashSells = 0.0;
    double tips = 0.0;
    double salaries = 0.0;
    double payments = 0.0;
    double services = 0.0;
    double providers = 0.0;
    double others = 0.0;
    for (CashTransaction transaction in _transactions) {
      // Check if it is from the date.
      if (transaction.date.isAfter(Utils.getOpenDate(date)) &&
          transaction.date.isBefore(Utils.getCloseDate(date))) {
        switch (transaction.type) {
          case TransactionType.Sell:
            sells += transaction.amount;
            // Add to cash or card sells.
            if (transaction.paymentMethod == PaymentMethod.Cash)
              cashSells += transaction.amount;
            else
              cardSells += transaction.amount;
            break;
          case TransactionType.Extraction:
            // TODO: Handle this case.
            break;
          case TransactionType.Payment:
            payments -= transaction.amount;
            break;
          case TransactionType.Deposit:
            // TODO: Handle this case.
            break;
          case TransactionType.Salary:
            salaries -= transaction.amount;
            break;
          case TransactionType.PositiveCash:
            // TODO: Handle this case.
            break;
          case TransactionType.NegativeCash:
            // TODO: Handle this case.
            break;
          case TransactionType.PositiveTip:
            tips += transaction.amount;
            break;
          case TransactionType.NegativeTip:
            // TODO: Handle this case.
            break;
          case TransactionType.Provider:
            providers -= transaction.amount;
            break;
          case TransactionType.Service:
            services -= transaction.amount;
            break;
          case TransactionType.Other:
            others -= transaction.amount;
            break;
        }
      }
    }
    return {
      "sells": sells,
      "cardSells": cardSells,
      "cashSells": cashSells,
      "tips": tips,
      "salaries": salaries,
      "payments": payments,
      "services": services,
      "providers": providers,
      "others": others,
    };
  }

  Future<Map<String, double>> getMonthSummary(int month, int year) async {
    if (_transactions == null) await getTransactions();
    double sells = 0.0;
    double cardSells = 0.0;
    double cashSells = 0.0;
    double tips = 0.0;
    double salaries = 0.0;
    double payments = 0.0;
    double services = 0.0;
    double providers = 0.0;
    double others = 0.0;
    for (CashTransaction transaction in _transactions) {
      // Check if it is from the date.
      if (transaction.date
              .isAfter(Utils.getOpenDate(DateTime(year, month, 1, 10))) &&
          transaction.date.isBefore(Utils.getCloseDate(
              DateTime(month == 12 ? year + 1 : year, month % 12 + 1, 1)))) {
        switch (transaction.type) {
          case TransactionType.Sell:
            sells += transaction.amount;
            // Add to cash or card sells.
            if (transaction.paymentMethod == PaymentMethod.Cash)
              cashSells += transaction.amount;
            else
              cardSells += transaction.amount;
            break;
          case TransactionType.Extraction:
            // TODO: Handle this case.
            break;
          case TransactionType.Payment:
            payments -= transaction.amount;
            break;
          case TransactionType.Deposit:
            // TODO: Handle this case.
            break;
          case TransactionType.Salary:
            salaries -= transaction.amount;
            break;
          case TransactionType.PositiveCash:
            // TODO: Handle this case.
            break;
          case TransactionType.NegativeCash:
            // TODO: Handle this case.
            break;
          case TransactionType.PositiveTip:
            tips += transaction.amount;
            break;
          case TransactionType.NegativeTip:
            // TODO: Handle this case.
            break;
          case TransactionType.Provider:
            providers -= transaction.amount;
            break;
          case TransactionType.Service:
            services -= transaction.amount;
            break;
          case TransactionType.Other:
            others -= transaction.amount;
            break;
        }
      }
    }
    return {
      "sells": sells,
      "cardSells": cardSells,
      "cashSells": cashSells,
      "tips": tips,
      "salaries": salaries,
      "payments": payments,
      "services": services,
      "providers": providers,
      "others": others,
    };
  }

  Future<List<CashTransaction>> getSummaryTransactionsOfType(
      TransactionType type, int month, int year) async {
    final transactionList = await transactions;
    return transactionList
        .where((transaction) =>
            transaction.date.month == month &&
            transaction.date.year == year &&
            transaction.type == type)
        .toList();
  }

  Future<void> getCash() async {
    _cash = await fetchCash();
  }

  Future<double> fetchCash() async {
    final response = await http.get(Constants.kApiPath + "/cash.json");
    final double data = jsonDecode(response.body) * 1.0;
    return data;
  }

  Future<bool> addToCash(double amount) async {
    return await updateCash(await cash + amount);
  }

  Future<bool> updateCash(double newAmount) async {
    final response = await http.put(
      Constants.kApiPath + "/cash.json",
      body: "$newAmount",
    );
    if (response.statusCode == 200) {
      _cash = newAmount;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  /* Employees */
  String selectedEmployee = "Bruno";

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

  /* Debug */

  void printGiftedProducts() {
    final Map<String, int> products = {};
    _transactions.forEach((tran) {
      if (tran.type == TransactionType.Sell) {
        for (int i = 0; i < tran.products.length; i++) {
          if (tran.products.values.elementAt(i)["price"] == 0) {
            final prev = products[tran.products.keys.elementAt(i)];
            if (prev == null)
              products[tran.products.keys.elementAt(i)] =
                  tran.products.values.elementAt(i)["amount"];
            else
              products[tran.products.keys.elementAt(i)] =
                  prev + tran.products.values.elementAt(i)["amount"];
          }
        }
      }
    });
    print(products);
  }
}
