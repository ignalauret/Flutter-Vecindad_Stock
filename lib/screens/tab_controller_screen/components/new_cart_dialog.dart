import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/components/products_cart_list.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class NewCartDialog extends StatefulWidget {
  @override
  _NewCartDialogState createState() => _NewCartDialogState();
}

class _NewCartDialogState extends State<NewCartDialog> {
  final List<Product> products = [];
  final List<int> amounts = [];

  final codeController = TextEditingController();
  final amountController = TextEditingController(text: "1");

  double get totalSum {
    double total = 0.0;
    for (int i = 0; i < products.length; i++) {
      total += products[i].price * amounts[i];
    }
    return total;
  }

  void submit() {
    final product =
        context.read<ProductsProvider>().getProductByCode(codeController.text);
    setState(() {
      products.add(product);
      amounts.add(int.parse(amountController.text));
      codeController.clear();
      amountController.text = "1";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Nueva Venta",
            style: CustomStyles.kTitleStyle,
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: 700,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 200,
                  alignment: Alignment.center,
                  child: TextField(
                    style: CustomStyles.kNormalStyle,
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: "Código",
                    ),
                    onEditingComplete: submit,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Container(
                  height: 50,
                  width: 200,
                  alignment: Alignment.center,
                  child: TextField(
                    style: CustomStyles.kNormalStyle,
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: "Cantidad",
                    ),
                    onEditingComplete: submit,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                InkWell(
                  onTap: () {
                    submit();
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      "Agregar",
                      style: TextStyle(
                        color: CustomColors.kAccentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: products.isNotEmpty
                  ? ProductsCartList(products, amounts)
                  : Center(
                      child: Text(
                        "Carrito vacío. Ingresa un código para agregar un producto.",
                        style: CustomStyles.kSubtitleStyle.copyWith(fontSize: 20),
                      ),
                    ),
            ),
            Container(
              child: Row(
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    "\$" + totalSum.toStringAsFixed(2),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 90,
                    width: 180,
                    child: ActionButton(
                      label: "Finalizar",
                      fontSize: 25,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
