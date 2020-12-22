class Product {
  String id;
  String code;
  String name;
  double price;
  int stock;

  Product({
    this.id,
    this.code,
    this.name,
    this.price,
    this.stock,
  });

  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      code: json["code"],
      name: json["name"],
      price: json["price"] * 1.0,
      stock: json["stock"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": this.code,
      "name": this.name,
      "price": this.price,
      "stock": this.stock,
    };
  }
}
