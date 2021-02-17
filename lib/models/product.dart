class Product {
  String id;
  String code;
  String name;
  int price;
  int onBarPrice;
  int stock;

  Product({
    this.id,
    this.code,
    this.name,
    this.price,
    this.onBarPrice,
    this.stock,
  });

  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      code: json["code"],
      name: json["name"],
      price: json["price"],
      onBarPrice:
          json["onBarPrice"] == null ? json["price"] : json["onBarPrice"],
      stock: json["stock"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": this.code,
      "name": this.name,
      "price": this.price,
      "onBarPrice": this.price,
      "stock": this.stock,
    };
  }
}
