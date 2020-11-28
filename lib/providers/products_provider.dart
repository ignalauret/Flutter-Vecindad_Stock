import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/utils/constants.dart';

class ProductsProvider extends ChangeNotifier {
  ProductsProvider() {
    getProducts();
  }
  List<Product> _products;

  Future<void> getProducts() async {
    _products = await fetchProducts();
  }

  Future<List<Product>> get products async {
    if (_products != null) return [..._products];
    getProducts();
    return _products;
  }

  List<Product> getSearchedProducts(String search) {
    if (search.isEmpty) return [];
    return _products.where((prod) => prod.name.contains(search)).toList();
  }

  void addLocalProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeLocalProduct(String id) {
    _products.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Constants.kApiPath + "/products.json");
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data == null) return [];
    final List<Product> temp = data.entries
        .map((entry) => Product.fromJson(entry.key, entry.value))
        .toList();
    return temp;
  }

  Future<bool> createProduct(
      String code, String name, double price, int stock) async {
    final product = Product(
      code: code,
      name: name,
      price: price,
      stock: stock,
    );
    final response = await http.post(
      Constants.kApiPath + "/products.json",
      body: jsonEncode(
        product.toJson(),
      ),
    );
    if (response.statusCode == 200) {
      product.id = jsonDecode(response.body)["name"];
      addLocalProduct(product);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    final response =
        await http.delete(Constants.kApiPath + "/products/$id.json");
    if (response.statusCode == 200) {
      removeLocalProduct(id);
      return true;
    } else {
      return false;
    }
  }

  Product getProductByCode(String code) {
    if (code == null) return null;
    return _products.firstWhere(
      (prod) => prod.code == code,
      orElse: () => null,
    );
  }

  Product getProductById(String id) {
    if (id == null) return null;
    return _products.firstWhere((prod) => prod.id == id);
  }

  void updateLocalStock(String id, int stock) {
    getProductById(id).stock = stock;
    notifyListeners();
  }

  Future<bool> updateStock(String pid, int amount) async {
    final int newStock = getProductById(pid).stock + amount;
    final response = await http.patch(
      Constants.kApiPath + "/products/$pid.json",
      body: jsonEncode(
        {"stock": newStock},
      ),
    );
    if (response.statusCode == 200) {
      updateLocalStock(pid, newStock);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sellProduct(String pid, int amount) async {
    return updateStock(pid, -1 * amount);
  }

  Future<bool> sellProducts(List<String> productIds, List<int> amounts) async {
    for (int i = 0; i < productIds.length; i++) {
      if (!await sellProduct(productIds[i], amounts[i])) return false;
    }
    return true;
  }

  Future<bool> addStock(String pid, int amount) async {
    return await updateStock(pid, amount);
  }

  Future<bool> addStocks(List<String> pids, List<int> newStocks) async {
    for (int i = 0; i < pids.length; i++) {
      if (!await addStock(pids[i], newStocks[i])) return false;
    }
    return true;
  }
}
