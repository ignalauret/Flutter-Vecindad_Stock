import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/components/products_cart_list.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class NewCartDialog extends StatefulWidget {
  NewCartDialog({this.editTransaction});
  final CashTransaction editTransaction;
  @override
  _NewCartDialogState createState() => _NewCartDialogState();
}

class _NewCartDialogState extends State<NewCartDialog> {
  List<Product> products = [];
  List<int> amounts = [];
  List<int> prices = [];
  bool codeError = false;
  bool isEdit = false;

  final codeController = TextEditingController();
  final amountController = TextEditingController(text: "1");

  double get totalSum {
    double total = 0.0;
    for (int i = 0; i < products.length; i++) {
      total += prices[i] * amounts[i];
    }
    return total;
  }

  @override
  void didChangeDependencies() {
    if (widget.editTransaction != null) {
      final productsData =
          Provider.of<ProductsProvider>(context, listen: false);
      isEdit = true;
      products = widget.editTransaction.products.keys
          .map((pid) => productsData.getProductById(pid))
          .toList();
      amounts = widget.editTransaction.products.values.map((map) => map["amount"]).toList();
      prices = widget.editTransaction.products.values.map((map) => map["price"]).toList();
    }

    super.didChangeDependencies();
  }

  void submit() {
    if (codeController.text.isEmpty)
      setState(() {
        codeError = true;
        return;
      });
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
          prices.add(product.price.floor());
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
            isEdit ? "Editar venta" : "Nueva Venta",
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
                  ? ProductsCartList(
                      products: products,
                      amounts: amounts,
                      prices: prices,
                      removeProduct: (index) {
                        setState(() {
                          products.removeAt(index);
                          amounts.removeAt(index);
                          prices.removeAt(index);
                        });
                      },
                      changePrice: (index, price) {
                        setState(() {
                          prices[index] = price;
                        });
                      },
                    )
                  : Center(
                      child: Text(
                        "Carrito vacío. Ingresa un código para agregar un producto.",
                        style:
                            CustomStyles.kSubtitleStyle.copyWith(fontSize: 20),
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
                      label: isEdit ? "Guardar" : "Finalizar",
                      fontSize: 25,
                      enabled: products.length > 0,
                      onTap: () {
                        final transactionsData =
                            context.read<TransactionsProvider>();
                        final List<MapEntry<String, Map<String, int>>> cartProducts = [];
                        for (int i = 0; i < products.length; i++) {
                          cartProducts
                              .add(MapEntry(products[i].id, {"amount": amounts[i], "price": prices[i]}));
                        }
                        if (isEdit) {
                          transactionsData
                              .editTransaction(
                            context,
                            id: widget.editTransaction.id,
                            description: widget.editTransaction.description,
                            type: widget.editTransaction.type,
                            amount: totalSum,
                            date: widget.editTransaction.date,
                            employee: widget.editTransaction.employeeId,
                            products: Map<String, Map<String, int>>.fromEntries(cartProducts),
                          )
                              .then((success) {
                            Navigator.of(context).pop(true);
                          });
                        } else {
                          transactionsData
                              .createTransaction(
                            context,
                            date: DateTime.now(),
                            type: TransactionType.Sell,
                            amount: totalSum,
                            products:
                                Map<String, Map<String, int>>.fromEntries(cartProducts),
                          )
                              .then((success) {
                            Navigator.of(context).pop();
                          });
                        }
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
