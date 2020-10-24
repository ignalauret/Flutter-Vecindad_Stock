import 'package:flutter/material.dart';
import 'package:vecindad_stock/utils/constants.dart';

class SearchBar extends StatelessWidget {
  SearchBar(this.onChange);
  final Function onChange;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.search,
            size: 30,
            color: Colors.grey,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: "Buscar producto",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
