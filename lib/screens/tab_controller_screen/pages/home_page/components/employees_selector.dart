import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vecindad_stock/models/employee.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class EmployeeSelector extends StatefulWidget {
  @override
  _EmployeeSelectorState createState() => _EmployeeSelectorState();
}

class _EmployeeSelectorState extends State<EmployeeSelector> {
  final List<Employee> employers = [
    Employee(id: 0, name: "Bruno", imageUrl: "assets/img/profile.jpeg"),
    Employee(id: 1, name: "Emi", imageUrl: "assets/img/profile.jpeg"),
    Employee(id: 2, name: "Mati", imageUrl: "assets/img/profile.jpeg"),
  ];

  int selectedId = 0;

  void selectEmployer(int id) {
    setState(() {
      selectedId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => EmployeeItem(
        employee: employers[index],
        selected: employers[index].id == selectedId,
        select: selectEmployer,
      ),
      itemCount: employers.length,
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
