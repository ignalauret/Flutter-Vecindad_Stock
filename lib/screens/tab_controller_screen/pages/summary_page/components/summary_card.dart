import 'package:flutter/material.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';
import 'package:vecindad_stock/utils/utils.dart';

class SummaryCard extends StatelessWidget {
  SummaryCard({
    this.date,
    this.sells,
    this.cardSells,
    this.cashSells,
    this.tips,
    this.payments,
    this.services,
    this.salaries,
    this.providers,
    this.others,
  });
  final String date;
  final double sells;
  final double cardSells;
  final double cashSells;
  final double tips;
  final double payments;
  final double salaries;
  final double services;
  final double providers;
  final double others;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                date,
                style: CustomStyles.kSubtitleStyle,
              ),
            ),
            SizedBox(height: 10),
            _buildSummaryStat("Ventas Totales:", sells),
            _buildSummaryStat("Ventas Efectivo:", cashSells),
            _buildSummaryStat("Ventas Tarjeta:", cardSells),
            _buildSummaryStat("Propina:", tips),
            _buildSummaryStat("Pagos:", payments),
            _buildSummaryStat("Servicios:", services),
            _buildSummaryStat("Salarios:", salaries),
            _buildSummaryStat("Proveedores:", providers),
            _buildSummaryStat("Gastos Varios:", others),
          ],
        ),
      ),
    );
  }

  Container _buildSummaryStat(String label, double value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(label, style: CustomStyles.kAccentTextStyle),
          Spacer(),
          Utils.formattedAmount(value),
        ],
      ),
    );
  }
}
