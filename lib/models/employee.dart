import 'package:flutter/foundation.dart';

class Employee {
  String id;
  final String name;
  final String imageUrl;

  Employee({this.id, @required this.name, @required this.imageUrl});
}
