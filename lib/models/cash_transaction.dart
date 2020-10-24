import 'package:flutter/material.dart';

enum TransactionType { Sell, Extraction, Payment, Deposit }

class CashTransaction {
  String id;
  final DateTime date;
  final TransactionType type;
  final int employeeId;
  final double amount;

  CashTransaction({
    this.id,
    @required this.date,
    @required this.type,
    @required this.employeeId,
    @required this.amount,
  });

  /* Json coding */

  factory CashTransaction.fromJson(String id, Map<String, dynamic> json) {
    TransactionType type;
    switch (json["type"]) {
      case "s":
        type = TransactionType.Sell;
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
      date: DateTime.parse(json["date"]),
      type: type,
      employeeId: json["eid"],
      amount: json["amount"],
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
      "date": this.date.toString(),
      "type": stringType,
      "eid": employeeId,
      "amount": amount
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

  String getType() {
    switch (this.type) {
      case TransactionType.Sell:
        return "Venta";
        break;
      case TransactionType.Extraction:
        return "Extracción";
        break;
      case TransactionType.Payment:
        return "Pago";
        break;
      case TransactionType.Deposit:
        return "Depósito";
        break;
    }
    return null;
  }
}
