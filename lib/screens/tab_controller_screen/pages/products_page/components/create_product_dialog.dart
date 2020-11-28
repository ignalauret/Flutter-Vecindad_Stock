import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/components/dialog_header.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class CreateProductDialog extends StatefulWidget {
  @override
  _CreateProductDialogState createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController(text: "0");

  bool codeError = false;

  void submit() {
    final product =
        context.read<ProductsProvider>().getProductByCode(codeController.text);
    // Check if product exists
    if (product != null) {
      setState(() {
        codeError = true;
      });
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .createProduct(
        codeController.text,
        nameController.text,
        double.parse(priceController.text),
        int.parse(stockController.text),
      )
          .then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogHeader("Agregar Producto"),
      content: Container(
        height: 350,
        width: 700,
        child: Column(
          children: [
            Container(
              height: 100,
              width: 600,
              child: _buildFieldInput("Nombre", nameController),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 150,
                  child: TextField(
                    style: CustomStyles.kNormalStyle,
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: "Código",
                      errorText: codeError ? "Código ya existe" : null,
                    ),
                    onEditingComplete: submit,
                    onChanged: (_) {
                      setState(() {
                        codeError = false;
                      });
                    },
                  ),
                ),
                SizedBox(width: 75),
                Container(
                  height: 100,
                  width: 150,
                  child: _buildFieldInput("Precio", priceController),
                ),
                SizedBox(width: 75),
                Container(
                  height: 100,
                  width: 150,
                  child: _buildFieldInput("Stock Inicial", stockController),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Container(
          height: 90,
          width: 180,
          margin: const EdgeInsets.all(20),
          child: ActionButton(
            label: "Agregar",
            fontSize: 25,
            onTap: submit,
          ),
        ),
      ],
    );
  }

  Container _buildFieldInput(String label, TextEditingController controller) {
    return Container(
      child: Column(
        children: [
          TextField(
            style: CustomStyles.kNormalStyle,
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        ],
      ),
    );
  }
}
