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
                width: 90,
                alignment: Alignment.center,
                child: Text(
                  "Código",
                  textAlign: TextAlign.center,
                  style: CustomStyles.kSubtitleStyle,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Nombre",
                    textAlign: TextAlign.center,
                    style: CustomStyles.kSubtitleStyle,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Precio",
                    textAlign: TextAlign.center,
                    style: CustomStyles.kSubtitleStyle,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Cantidad",
                    textAlign: TextAlign.center,
                    style: CustomStyles.kSubtitleStyle,
                  ),
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
              width: 90,
              alignment: Alignment.center,
              child: Text(
                product.code,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: CustomStyles.kNormalStyle,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "\$" + product.price.toString(),
                  textAlign: TextAlign.center,
                  style: CustomStyles.kNormalStyle,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  amount.toString(),
                  textAlign: TextAlign.center,
                  style: CustomStyles.kNormalStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
