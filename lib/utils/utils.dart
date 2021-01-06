import 'dart:math';

import 'package:printing/printing.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';

import 'custom_styles.dart';

class Utils {
  static List<String> kDays = ["", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"];
  static List<String> kMonths = ["", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];

  static String parseLargeDate(DateTime date) {
    final day = kDays[date.weekday];
    final month = kMonths[date.month];
    return "$day ${date.day} de $month, ${date.year}";
  }
  static bool isSameDay(DateTime d1, DateTime d2) {
    return d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;
  }

  static bool isNumber(String value) {
    try {
      int.parse(value);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Text formattedAmount(double amount) {
    return Text(
      amount >= 0
          ? "+\$" + amount.toStringAsFixed(2)
          : "-\$" + amount.toStringAsFixed(2),
      textAlign: TextAlign.center,
      style:
          amount >= 0 ? CustomStyles.kIncomeStyle : CustomStyles.kExpenseStyle,
    );
  }

  static DateTime get openDate {
    final now = DateTime.now().subtract(Duration(hours: 7));
    return DateTime(now.year, now.month, now.day, 7);
  }

  static DateTime get closeDate {
    final tomorrow = DateTime.now().add(Duration(hours: 17));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7);
  }

  static DateTime getOpenDate(DateTime date) {
    final openDate = date.subtract(Duration(hours: 7));
    return DateTime(openDate.year, openDate.month, openDate.day, 7);
  }

  static DateTime getCloseDate(DateTime date) {
    final closeDate = date.add(Duration(hours: 17));
    return DateTime(closeDate.year, closeDate.month, closeDate.day, 7);
  }

  static void generatePdf(List<Product> products, List<int> amounts,
      List<int> prices, double totalSum) {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat(4 * PdfPageFormat.cm, 10 * PdfPageFormat.cm,
            marginAll: 0.3 * PdfPageFormat.cm),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text("La Vecindad",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("Kiosco - Bar", style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 0.2 * PdfPageFormat.cm),
                pw.Text("Ticket no válido como factura",
                    style: pw.TextStyle(fontSize: 6)),
                pw.SizedBox(height: 0.2 * PdfPageFormat.cm),
                pw.ListView(
                  children: List.generate(
                    products.length,
                    (index) => pw.Row(
                      children: [
                        pw.Text(
                          amounts[index].toString(),
                          style: pw.TextStyle(fontSize: 6),
                        ),
                        pw.SizedBox(width: 0.2 * PdfPageFormat.cm),
                        pw.Text(
                          products[index].name.substring(
                              0, min(15, products[index].name.length)),
                          style: pw.TextStyle(fontSize: 6),
                        ),
                        pw.Spacer(),
                        pw.SizedBox(width: 0.2 * PdfPageFormat.cm),
                        pw.Text(
                          "\$" + (amounts[index] * prices[index]).toString(),
                          style: pw.TextStyle(fontSize: 6),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text("TOTAL: \$${totalSum.toStringAsFixed(2)}",
                        style: pw.TextStyle(
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold,
                        )),
                  ],
                ),
                pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                pw.Text("Gracias por su compra!",
                    style: pw.TextStyle(fontSize: 6)),
                pw.SizedBox(
                    height:
                        max(1, (4 - products.length)) * 0.2 * PdfPageFormat.cm),
                pw.Text("------------"),
              ],
            ),
          );
        }));
    final bytes = pdf.save();
    Printing.layoutPdf(onLayout: (_) => bytes);
    // final blob = html.Blob([bytes], 'application/pdf');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // html.window.open(url, "_blank");
    // html.Url.revokeObjectUrl(url);
  }
}
