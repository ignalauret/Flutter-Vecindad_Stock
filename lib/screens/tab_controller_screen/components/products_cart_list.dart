import 'package:flutter/material.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class ProductsCartList extends StatelessWidget {
  ProductsCartList(this.products, this.amounts, this.removeProduct);

  final List<Product> products;
  final List<int> amounts;
  final Function(int) removeProduct;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 120,
                child: Text(
                  "Código",
                  textAlign: TextAlign.left,
                  style: CustomStyles.kSubtitleStyle,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  "Nombre",
                  textAlign: TextAlign.left,
                  style: CustomStyles.kSubtitleStyle,
                ),
              ),
              Container(
                width: 100,
                child: Text(
                  "Precio",
                  textAlign: TextAlign.center,
                  style: CustomStyles.kSubtitleStyle,
                ),
              ),
              Container(
                width: 90,
                child: Text(
                  "Cantidad",
                  textAlign: TextAlign.center,
                  style: CustomStyles.kSubtitleStyle,
                ),
              ),
              SizedBox(
                width: 35,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => ProductsCartListItem(
              products[index],
              amounts[index],
              remove: () {
                removeProduct(index);
              },
            ),
            itemCount: products.length,
          ),
        ),
      ],
    );
  }
}

class ProductsCartListItem extends StatelessWidget {
  ProductsCartListItem(this.product, this.amount, {this.remove});
  final Product product;
  final int amount;
  final VoidCallback remove;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 120,
              child: Text(
                product.code,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                product.name,
                textAlign: TextAlign.left,
                style: CustomStyles.kNormalStyle,
              ),
            ),
            Container(
              width: 100,
              child: Text(
                "\$" + product.price.toString(),
                textAlign: TextAlign.center,
                style: CustomStyles.kNormalStyle,
              ),
            ),
            Container(
              width: 90,
              child: Text(
                amount.toString(),
                textAlign: TextAlign.center,
                style: CustomStyles.kNormalStyle,
              ),
            ),
            if (remove != null)
              InkWell(
                onTap: remove,
                child: Container(
                  width: 30,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
