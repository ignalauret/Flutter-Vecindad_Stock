import 'package:flutter/material.dart';

enum TransactionType { Sell, Extraction, Payment, Deposit }

class CashTransaction {
  String id;
  final DateTime date;
  final TransactionType type;
  final String employeeId;
  final double amount;

  CashTransaction({
    this.id,
    @required this.date,
    @required this.type,
    @required this.employeeId,
    @required this.amount,
  });

  bool isIncome() {
    switch(this.type) {
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
    switch(this.type) {
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
