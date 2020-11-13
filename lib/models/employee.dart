import 'package:flutter/foundation.dart';

class Employee {
  String id;
  final String name;
  final String imageUrl;

  Employee({this.id, @required this.name, @required this.imageUrl});

  factory Employee.fromJson(String id, Map<String, dynamic> json) {
    return Employee(
      id: id,
      name: json["name"],
      imageUrl: json["imageUrl"],
    );
  }
}
