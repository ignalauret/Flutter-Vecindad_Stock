import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/summary_page/components/summary_card.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
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
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Container(
                height: 330,
                width: double.infinity,
                child: FutureBuilder<Map<String, double>>(
                  future: context.watch<TransactionsProvider>().getDateSummary(
                      DateTime.now().subtract(Duration(days: index))),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _buildSummaryCard(
                          DateTime.now().subtract(Duration(days: index)),
                          snapshot.data);
                    } else
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SummaryCard _buildSummaryCard(DateTime date, Map<String, double> summary) {
    return SummaryCard(
      date: date,
      sells: summary["sells"],
      cardSells: summary["cardSells"],
      cashSells: summary["cashSells"],
      tips: summary["tips"],
      payments: summary["payments"],
      salaries: summary["salaries"],
      services: summary["services"],
    );
  }
}
