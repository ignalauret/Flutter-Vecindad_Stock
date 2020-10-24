import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vecindad_stock/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products;

  Future<List<Product>> get transactions async {
    if (_products != null) return [..._products];
    _products = await fetchProducts();
    return _products;
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http
        .get("https://la-vecindad-c834d.firebaseio.com/products.json");
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<Product> temp = data.entries.map((entry) => Product.fromJson(entry.key, entry.value)).toList();
    return temp;
  }

  Future<bool> createProduct() async {
    final product = Product(
      code: "003",
      name: "Doritos",
      price: 150,
      stock: 8,
    );
    final response = await http.post(
      "https://la-vecindad-c834d.firebaseio.com/products.json",
      body: jsonEncode(
        product.toJson(),
      ),
    );
    if(response.statusCode == 200) {
      product.id = jsonDecode(response.body)["name"];
      _products.add(product);
      notifyListeners();
      return true;
    } else {
      return false;
    }

  }
}