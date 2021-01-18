import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/summary_page/components/summary_card.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';
import 'package:vecindad_stock/utils/utils.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  String summaryRange = "Diario";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(
              "Resúmen",
              style: CustomStyles.kTitleStyle,
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              _buildSummaryRangeSelector("Diario", summaryRange == "Diario",
                  () {
                setState(() {
                  summaryRange = "Diario";
                });
              }),
              _buildSummaryRangeSelector("Mensual", summaryRange == "Mensual",
                  () {
                setState(() {
                  summaryRange = "Mensual";
                });
              }),
            ],
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Container(
                height: 380,
                width: double.infinity,
                child: _buildSummaryCard(summaryRange, index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<Map<String, double>> _buildSummaryCard(
      String range, int index) {
    if (range == "Diario") {
      return FutureBuilder<Map<String, double>>(
        future: context
            .read<TransactionsProvider>()
            .getDateSummary(DateTime.now().subtract(Duration(days: index))),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildDailySummaryCard(
                DateTime.now().subtract(Duration(days: index)), snapshot.data);
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      );
    } else if (range == "Mensual") {
      final month = (DateTime.now().month - index - 1) % 12 + 1;
      final year = month == 1 ? 2021 : 2020;
      return FutureBuilder<Map<String, double>>(
        future:
            context.read<TransactionsProvider>().getMonthSummary(month, year),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildMonthlySummaryCard(month, year, snapshot.data);
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      );
    }
  }

  SummaryCard _buildMonthlySummaryCard(
      int month, int year, Map<String, double> summary) {
    return SummaryCard(
      date: Utils.kMonths[month] + " $year",
      sells: summary["sells"],
      cardSells: summary["cardSells"],
      cashSells: summary["cashSells"],
      tips: summary["tips"],
      payments: summary["payments"],
      salaries: summary["salaries"],
      services: summary["services"],
      providers: summary["providers"],
      others: summary["others"],
    );
  }

  SummaryCard _buildDailySummaryCard(
      DateTime date, Map<String, double> summary) {
    return SummaryCard(
      date: Utils.parseLargeDate(date),
      sells: summary["sells"],
      cardSells: summary["cardSells"],
      cashSells: summary["cashSells"],
      tips: summary["tips"],
      payments: summary["payments"],
      salaries: summary["salaries"],
      services: summary["services"],
      providers: summary["providers"],
      others: summary["others"],
    );
  }

  InkWell _buildSummaryRangeSelector(
      String range, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 90,
        alignment: Alignment.center,
        child: Text(
          range,
          style: selected
              ? CustomStyles.kAccentTextStyle
              : CustomStyles.kNormalStyle,
        ),
      ),
    );
  }
}
