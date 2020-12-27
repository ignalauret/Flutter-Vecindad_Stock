import 'package:flutter/material.dart';

enum TransactionType {
  Sell,
  Extraction,
  Payment,
  Deposit,
  Salary,
  PositiveCash,
  NegativeCash,
  Provider,
  Service,
  Other
}
enum PaymentMethod { Cash, Card }

const Map<TransactionType, String> kTransactionTypesNames = {
  TransactionType.Deposit: "Depósito",
  TransactionType.Extraction: "Extracción",
  TransactionType.Payment: "Pago",
  TransactionType.Sell: "Venta",
  TransactionType.Salary: "Salario",
  TransactionType.PositiveCash: "Sumar Caja",
  TransactionType.NegativeCash: "Restar Caja",
  TransactionType.Provider: "Proveedor",
  TransactionType.Service: "Servicio",
  TransactionType.Other: "Gastos Varios",
};

const Map<PaymentMethod, String> kPaymentMethodsNames = {
  PaymentMethod.Cash: "Efectivo",
  PaymentMethod.Card: "Tarjeta",
};

class CashTransaction {
  String id;
  String description;
  DateTime date;
  TransactionType type;
  PaymentMethod paymentMethod;
  String employeeId;
  double amount;
  Map<String, Map<String, int>> products;

  CashTransaction({
    this.id,
    this.description,
    @required this.paymentMethod,
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
        products = temp.map((key, value) => MapEntry<String, Map<String, int>>(
            key, Map<String, int>.from(value)));
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
      case "sa":
        type = TransactionType.Salary;
        break;
      case "pc":
        type = TransactionType.PositiveCash;
        break;
      case "nc":
        type = TransactionType.NegativeCash;
        break;
      case "provider":
        type = TransactionType.Provider;
        break;
      case "service":
        type = TransactionType.Service;
        break;
      case "other":
        type = TransactionType.Other;
        break;
    }
    PaymentMethod method;
    if (json["paymentMethod"] == null) {
      method = PaymentMethod.Cash;
    } else {
      switch (json["paymentMethod"]) {
        case "cash":
          method = PaymentMethod.Cash;
          break;
        case "card":
          method = PaymentMethod.Card;
          break;
        default:
          method = PaymentMethod.Cash;
      }
    }
    return CashTransaction(
      id: id,
      description: json["description"],
      date: DateTime.parse(json["date"]),
      type: type,
      paymentMethod: method,
      employeeId: json["eid"],
      amount: json["amount"] * 1.0,
      products: products,
    );
  }

  static String getParsedType(TransactionType type) {
    switch (type) {
      case TransactionType.Sell:
        return "s";
      case TransactionType.Extraction:
        return "e";
      case TransactionType.Payment:
        return "p";
      case TransactionType.Deposit:
        return "d";
      case TransactionType.Salary:
        return "sa";
        break;
      case TransactionType.PositiveCash:
        return "pc";
        break;
      case TransactionType.NegativeCash:
        return "nc";
        break;
      case TransactionType.Provider:
        return "provider";
        break;
      case TransactionType.Service:
        return "service";
        break;
      case TransactionType.Other:
        return "other";
        break;
    }
    return null;
  }

  static String getParsedPaymentMethod(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.Cash:
        return "cash";
        break;
      case PaymentMethod.Card:
        return "card";
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
      "paymentMethod": getParsedPaymentMethod(this.paymentMethod),
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
      case TransactionType.Extraction:
        return false;
      case TransactionType.Payment:
        return false;
      case TransactionType.Deposit:
        return true;
      case TransactionType.Salary:
        return false;
      case TransactionType.PositiveCash:
        return true;
      case TransactionType.NegativeCash:
        return false;
      case TransactionType.Provider:
        return false;
        break;
      case TransactionType.Service:
        return false;
        break;
      case TransactionType.Other:
        return false;
        break;
    }
    return null;
  }

  bool isIncome() {
    return typeIsIncome(this.type);
  }

  double getRealAmount() {
    if (this.isIncome()) return this.amount;
    return -1 * this.amount;
  }

  String get typeName {
    return kTransactionTypesNames[this.type];
  }
}
