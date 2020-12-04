import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:vecindad_stock/models/employee.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class EmployeeSelector extends StatefulWidget {
  EmployeeSelector(this.selectedId, this.selectEmployee);
  final String selectedId;
  final Function(String) selectEmployee;
  @override
  _EmployeeSelectorState createState() => _EmployeeSelectorState();
}

class _EmployeeSelectorState extends State<EmployeeSelector> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Employee>>(
      future: context.watch<TransactionsProvider>().employees,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => EmployeeItem(
              employee: snapshot.data[index],
              selected: snapshot.data[index].id == widget.selectedId,
              select: widget.selectEmployee,
            ),
            itemCount: snapshot.data.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class EmployeeItem extends StatelessWidget {
  EmployeeItem({this.employee, this.select, this.selected});
  final Employee employee;
  final bool selected;
  final Function select;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              select(employee.id);
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(employee.imageUrl),
                ),
                border: selected
                    ? Border.all(color: CustomColors.kAccentColor, width: 3)
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 80,
            alignment: Alignment.center,
            child: Text(
              employee.name,
              style: CustomStyles.kNormalStyle.copyWith(
                color: selected ? CustomColors.kAccentColor : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
