import 'package:flutter/material.dart';

enum TransactionType { Sell, Extraction, Payment, Deposit }

const Map<TransactionType, String> kTransactionTypesNames = {
  TransactionType.Deposit: "Depósito",
  TransactionType.Extraction: "Extracción",
  TransactionType.Payment: "Pago",
  TransactionType.Sell: "Venta",
};

class CashTransaction {
  String id;
  String description;
  DateTime date;
  TransactionType type;
  String employeeId;
  double amount;
  Map<String, Map<String, int>> products;

  CashTransaction({
    this.id,
    this.description,
    @required this.date,
    @required this.type,
    @required this.employeeId,
    @required this.amount,
    this.products,
  });

  /* Parsers */

  factory CashTransaction.fromJson(String id, Map<String, dynamic> json) {
    TransactionType type;
    Map<String, Map<String, int>> products;
    switch (json["type"]) {
      case "s":
        type = TransactionType.Sell;
        final temp = Map<String, Map>.from(json["products"]);
        products = temp.map((key, value) => MapEntry<String, Map<String, int>>(key, Map<String, int>.from(value)));
        break;
      case "e":
        type = TransactionType.Extraction;
        break;
      case "p":
        type = TransactionType.Payment;
        break;
      case "d":
        type = TransactionType.Deposit;
        break;
    }
    return CashTransaction(
      id: id,
      description: json["description"],
      date: DateTime.parse(json["date"]),
      type: type,
      employeeId: json["eid"],
      amount: json["amount"],
      products: products,
    );
  }

  static String getParsedType(TransactionType type) {
    switch (type) {
      case TransactionType.Sell:
        return "s";
        break;
      case TransactionType.Extraction:
        return "e";
        break;
      case TransactionType.Payment:
        return "p";
        break;
      case TransactionType.Deposit:
        return "d";
        break;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "description": this.description,
      "date": this.date.toString(),
      "type": getParsedType(this.type),
      "eid": this.employeeId,
      "amount": this.amount,
      "products": this.products,
    };
  }

  /* Methods */

  static bool typeIsIncome(TransactionType type) {
    switch (type) {
      case TransactionType.Sell:
        return true;
        break;
      case TransactionType.Extraction:
        return false;
        break;
      case TransactionType.Payment:
        return false;
        break;
      case TransactionType.Deposit:
        return true;
        break;
    }
    return null;
  }

  bool isIncome() {
    return typeIsIncome(this.type);
  }

  double getRealAmount() {
    if (isIncome()) return amount;
    return -1 * amount;
  }

  String get typeName {
    return kTransactionTypesNames[this.type];
  }
}
