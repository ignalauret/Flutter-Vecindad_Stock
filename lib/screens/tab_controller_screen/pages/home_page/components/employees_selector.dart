import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vecindad_stock/models/employee.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class EmployeeSelector extends StatelessWidget {
  final List<Employee> employers = [
    Employee(name: "Bruno", imageUrl: "assets/img/profile.jpeg"),
    Employee(name: "Emi", imageUrl: "assets/img/profile.jpeg"),
    Employee(name: "Mati", imageUrl: "assets/img/profile.jpeg"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => EmployeeItem(employers[index]),
      itemCount: employers.length,
    );
  }
}

class EmployeeItem extends StatelessWidget {
  EmployeeItem(this.employee);
  final Employee employee;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(employee.imageUrl),
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
              style: CustomStyles.kNormalStyle,
            ),
          ),
        ],
      ),
    );
  }
}
