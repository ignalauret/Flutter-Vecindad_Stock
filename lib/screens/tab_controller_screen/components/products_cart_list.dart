import 'package:flutter/material.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class ProductsCartList extends StatelessWidget {
  ProductsCartList(this.products, this.amounts);

  final List<Product> products;
  final List<int> amounts;

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
                width: 110,
                child: Text(
                  "Código",
                  textAlign: TextAlign.left,
                  style: CustomStyles.kSubtitleStyle,
                ),
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
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => ProductsCartListItem(products[index], amounts[index]),
            itemCount: products.length,
          ),
        ),
      ],
    );
  }
}

class ProductsCartListItem extends StatelessWidget {
  ProductsCartListItem(this.product, this.amount);
  final Product product;
  final int amount;
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
              width: 110,
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
          ],
        ),
      ),
    );
  }
}
