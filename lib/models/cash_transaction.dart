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
  final String description;
  final DateTime date;
  final TransactionType type;
  final String employeeId;
  final double amount;
  final Map<String, int> products;

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
    Map<String, int> products;
    switch (json["type"]) {
      case "s":
        type = TransactionType.Sell;
        products = Map<String, int>.from(json["products"]);
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

  Map<String, dynamic> toJson() {
    String stringType;
    switch (type) {
      case TransactionType.Sell:
        stringType = "s";
        break;
      case TransactionType.Extraction:
        stringType = "e";
        break;
      case TransactionType.Payment:
        stringType = "p";
        break;
      case TransactionType.Deposit:
        stringType = "d";
        break;
    }
    return {
      "id": this.id,
      "description": this.description,
      "date": this.date.toString(),
      "type": stringType,
      "eid": this.employeeId,
      "amount": this.amount,
      "products": this.products,
    };
  }

  /* Methods */

  bool isIncome() {
    switch (this.type) {
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

  double getRealAmount() {
    if(isIncome()) return amount;
    return -1 * amount;
  }

  String get typeName {
    return kTransactionTypesNames[this.type];
  }
}
