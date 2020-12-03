import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/products_page/components/product_detail_dialog.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class ProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, productsData, _) {
        return FutureBuilder<List<Product>>(
          future: productsData.products,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data.isEmpty
                ? Center(
                    child: Text("No hay productos"),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 30,
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
                              width: 10,
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
                                )),
                            Container(
                              width: 90,
                              child: Text(
                                "Stock",
                                textAlign: TextAlign.center,
                                style: CustomStyles.kSubtitleStyle,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) =>
                              ProductsListItem(snapshot.data[index]),
                          itemCount: snapshot.data.length,
                        ),
                      ),
                    ],
                  );
          },
        );
      },
    );
  }
}

class ProductsListItem extends StatelessWidget {
  ProductsListItem(this.product);
  final Product product;

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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  product.code,
                  style: CustomStyles.kNormalStyle,
                ),
              ),
            ),
            SizedBox(
              width: 10,
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
                product.stock.toString(),
                textAlign: TextAlign.center,
                style: CustomStyles.kNormalStyle.copyWith(
                    color: product.stock < 5 ? Colors.red : Colors.black),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ProductDetailDialog(product),
                );
              },
              child: Container(
                width: 100,
                child: Text(
                  "Ver Detalle",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.kAccentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
