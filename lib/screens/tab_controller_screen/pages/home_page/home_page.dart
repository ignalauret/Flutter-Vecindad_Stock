import 'package:flutter/material.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/home_page/components/transactions_list.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

import 'components/employees_selector.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            child: EmployeeSelector(),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Movimientos del día",
              style: CustomStyles.kTitleStyle,
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Container(
              child: TransactionsList(sortDate: DateTime.now(),),
            ),
          ),
        ],
      ),
    );
  }
}
