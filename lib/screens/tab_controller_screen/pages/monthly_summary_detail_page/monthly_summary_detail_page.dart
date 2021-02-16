import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

import 'components/summary_transactions_list.dart';

class MonthlySummaryDetailPage extends StatefulWidget {
  MonthlySummaryDetailPage(this.month, this.year, this.goBack);
  final int month;
  final int year;
  final VoidCallback goBack;

  @override
  _MonthlySummaryDetailPageState createState() =>
      _MonthlySummaryDetailPageState();
}

class _MonthlySummaryDetailPageState extends State<MonthlySummaryDetailPage> {
  TransactionType selectedType = TransactionType.Extraction;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: CustomColors.kGreyColor,
              ),
              onPressed: widget.goBack,
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Text(
                "Categoría:",
                style: CustomStyles.kAccentTextStyle,
              ),
              SizedBox(width: 15),
              _buildTypeSelector(),
            ],
          ),
          Expanded(
            child: SummaryTransactionsList(
              widget.month,
              widget.year,
              selectedType,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTypeSelector() {
    return Container(
      child: DropdownButton<TransactionType>(
        items: TransactionType.values
            .sublist(1)
            .map(
              (type) => DropdownMenuItem<TransactionType>(
                child: Text(
                  kTransactionTypesNames[type],
                  style: CustomStyles.kNormalStyle,
                ),
                value: type,
              ),
            )
            .toList(),
        value: selectedType,
        onChanged: (type) {
          setState(() {
            selectedType = type;
          });
        },
      ),
    );
  }
}
