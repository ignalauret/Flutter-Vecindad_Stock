import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/components/custom_text_field.dart';
import 'package:vecindad_stock/components/search_bar.dart';
import 'package:vecindad_stock/models/cash_transaction.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/components/products_cart_list.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/components/right_bar.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';
import 'package:vecindad_stock/utils/utils.dart';

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
  bool _tapped = false;
  bool _barPriceSelected = true;

  final codeController = TextEditingController();
  final amountController = TextEditingController(text: "1");
  final cashPaymentController = TextEditingController(text: "0");

  PaymentMethod selectedMethod = PaymentMethod.Cash;

  String search = "";

  void searchFor(String value) {
    setState(() {
      search = value;
    });
  }

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
      amounts = widget.editTransaction.products.values
          .map((map) => map["amount"])
          .toList();
      prices = widget.editTransaction.products.values
          .map((map) => map["price"])
          .toList();
      selectedMethod = widget.editTransaction.paymentMethod;
      cashPaymentController.text =
          widget.editTransaction.cashPaymentAmount.toString();
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
          prices.add(_barPriceSelected ? product.onBarPrice : product.price);
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
        width: min(MediaQuery.of(context).size.width * 0.85, 900),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: min(MediaQuery.of(context).size.width * 0.60, 600),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCodeInput(),
                            SizedBox(width: 20),
                            _buildAmountInput(),
                            Spacer(),
                            _buildPriceSelectorsSwitch(),
                            Spacer(),
                            _buildSubmitButton(),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildProductsList(),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black12,
                    height: double.infinity,
                    margin: const EdgeInsets.all(10),
                    width: 2,
                  ),
                  _buildSearchProductBar(),
                ],
              ),
            ),
            Row(
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
                if (!isEdit) _buildPaymentOptionSelector(),
                SizedBox(width: 30),
                if (selectedMethod == PaymentMethod.Mixed && !isEdit)
                  _buildCashPaymentInput(),
                Spacer(),
                Column(
                  children: [
                    _buildShowTicketButton(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildFinalizeButton(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildSearchProductBar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
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
          ],
        ),
      ),
    );
  }

  Container _buildCodeInput() {
    return Container(
      width: 250,
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
    );
  }

  Container _buildAmountInput() {
    return Container(
      width: 70,
      alignment: Alignment.center,
      child: TextField(
        style: CustomStyles.kNormalStyle,
        controller: amountController,
        decoration: InputDecoration(
          labelText: "Cantidad",
        ),
        onEditingComplete: submit,
      ),
    );
  }

  Container _buildPaymentOptionSelector() {
    return Container(
      height: 60,
      width: 120,
      alignment: Alignment.center,
      child: DropdownButton<PaymentMethod>(
        isExpanded: true,
        value: selectedMethod,
        onChanged: (value) {
          setState(() {
            selectedMethod = value;
          });
        },
        items: PaymentMethod.values
            .map(
              (method) => DropdownMenuItem(
                child: Text(
                  kPaymentMethodsNames[method],
                  style: CustomStyles.kNormalStyle,
                ),
                value: method,
              ),
            )
            .toList(),
      ),
    );
  }

  Container _buildCashPaymentInput() {
    return Container(
      width: 100,
      height: 60,
      child: CustomTextField("Efectivo", cashPaymentController),
    );
  }

  Container _buildPriceSelectorsSwitch() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _barPriceSelected = true;
              });
            },
            child: Text(
              "Bar",
              style: _barPriceSelected
                  ? CustomStyles.kAccentTextStyle
                  : CustomStyles.kNormalStyle,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _barPriceSelected = false;
              });
            },
            child: Text(
              "Kiosko",
              style: _barPriceSelected
                  ? CustomStyles.kNormalStyle
                  : CustomStyles.kAccentTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  InkWell _buildSubmitButton() {
    return InkWell(
      onTap: () {
        submit();
      },
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Icon(
          Icons.check_circle,
          size: 50,
          color: CustomColors.kAccentColor,
        ),
      ),
    );
  }

  Expanded _buildProductsList() {
    return Expanded(
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
                style: CustomStyles.kSubtitleStyle.copyWith(fontSize: 20),
              ),
            ),
    );
  }

  Container _buildShowTicketButton() {
    return Container(
      height: 60,
      width: 180,
      child: ActionButton(
        secondary: true,
        color: Colors.grey,
        label: "Imprimir",
        onTap: () {
          Utils.generatePdf(products, amounts, prices, totalSum);
        },
      ),
    );
  }

  Container _buildFinalizeButton() {
    return Container(
      height: 60,
      width: 180,
      child: ActionButton(
        label: isEdit ? "Guardar" : "Finalizar",
        fontSize: 25,
        enabled: products.length > 0 &&
            !_tapped &&
            cashPaymentController.text.isNotEmpty,
        onTap: () {
          setState(() {
            _tapped = true;
          });
          final transactionsData = context.read<TransactionsProvider>();
          final List<MapEntry<String, Map<String, int>>> cartProducts = [];
          for (int i = 0; i < products.length; i++) {
            cartProducts.add(MapEntry(
                products[i].id, {"amount": amounts[i], "price": prices[i]}));
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
              method: selectedMethod,
              cashPayment: int.parse(cashPaymentController.text),
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
              products: Map<String, Map<String, int>>.fromEntries(cartProducts),
              method: selectedMethod,
              cashPayment: int.parse(cashPaymentController.text),
            )
                .then((success) {
              //Utils.generatePdf(products, amounts, prices, totalSum);
              Navigator.of(context).pop();
            });
          }
        },
      ),
    );
  }
}
