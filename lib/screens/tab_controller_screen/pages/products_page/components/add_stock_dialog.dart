import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/components/products_cart_list.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class AddStockDialog extends StatefulWidget {
  @override
  _AddStockDialogState createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<AddStockDialog> {
  final List<Product> products = [];
  final List<int> amounts = [];
  bool codeError = false;

  final codeController = TextEditingController();
  final amountController = TextEditingController(text: "1");

  void submit() {
    final product =
        context.read<ProductsProvider>().getProductByCode(codeController.text);
    setState(() {
      // Check if product exists
      if (product == null) {
        codeError = true;
      } else {
        if (products.contains(product)) {
          final index = products.indexOf(product);
          amounts[index] = amounts[index] + int.parse(amountController.text);
        } else {
          products.add(product);
          amounts.add(int.parse(amountController.text));
        }
        codeController.clear();
        amountController.text = "1";
      }
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
            "Cargar Stock",
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
                  width: 200,
                  alignment: Alignment.center,
                  child: TextField(
                    style: CustomStyles.kNormalStyle,
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: "Código",
                      errorText: codeError ? "Código inválido" : null,
                    ),
                    onEditingComplete: submit,
                    onChanged: (_) {
                      setState(() {
                        codeError = false;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Container(
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
                        "No se cargó stock de ningún producto aún.",
                        style:
                            CustomStyles.kSubtitleStyle.copyWith(fontSize: 20),
                      ),
                    ),
            ),
            Container(
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    height: 90,
                    width: 180,
                    child: ActionButton(
                      label: "Finalizar",
                      fontSize: 25,
                      onTap: () {
                        final productsData = context.read<ProductsProvider>();
                        productsData
                            .addStocks(products.map((prod) => prod.id).toList(),
                                amounts)
                            .then(
                          (success) {
                            Navigator.of(context).pop();
                          },
                        );
                      },
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
