import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/components/search_bar.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/components/new_cart_dialog.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class RightBar extends StatefulWidget {
  @override
  _RightBarState createState() => _RightBarState();
}

class _RightBarState extends State<RightBar> {
  String search = "";

  void searchFor(String value) {
    setState(() {
      search = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Consumer<TransactionsProvider>(
            builder: (context, transactionsData, _) {
              return Container(
                height: 100,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: transactionsData.cash,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AccountAmountCard(
                              label: "Caja:",
                              amount: snapshot.data,
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: transactionsData.todayCash,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AccountAmountCard(
                              label: "Hoy:",
                              amount: snapshot.data,
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Productos",
              style: CustomStyles.kTitleStyle,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 60,
            width: double.infinity,
            child: SearchBar(searchFor),
          ),
          Expanded(
            child: SearchedProductsList(
              context.select<ProductsProvider, List<Product>>(
                (data) => data.getSearchedProducts(search),
              ),
            ),
          ),
          Container(
            height: 120,
            width: 300,
            child: ActionButton(
              label: "Nueva Venta",
              onTap: () {
                showDialog(
                    context: context, builder: (context) => NewCartDialog());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountAmountCard extends StatelessWidget {
  AccountAmountCard({this.label, this.amount});

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "\$" + amount.toStringAsFixed(2),
                style: amount >= 0.0
                    ? CustomStyles.kIncomeStyle
                    : CustomStyles.kExpenseStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchedProductsList extends StatelessWidget {
  SearchedProductsList(this.products);
  final List<Product> products;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ProductCard(products[index]),
      itemCount: products.length,
    );
  }
}

class ProductCard extends StatelessWidget {
  ProductCard(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius / 2)),
      child: ListTile(
        title: Text(
          product.name,
          style: CustomStyles.kNormalStyle,
        ),
        subtitle: Text(
          "#" + product.code,
          style: CustomStyles.kSubtitleStyle,
        ),
        trailing: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "\$" + product.price.toString(),
                style: CustomStyles.kNormalStyle,
              ),
              Text(
                product.stock.toString(),
                style: CustomStyles.kSubtitleStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
