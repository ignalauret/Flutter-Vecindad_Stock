import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class CreateProductDialog extends StatelessWidget {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  Widget _buildFieldInput(String label, TextEditingController controller) {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Agregar Producto",
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
                  child: _buildFieldInput("Código", codeController),
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
                  child: _buildFieldInput("Stock (opcional)", stockController),
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
            onTap: () {

              Provider.of<ProductsProvider>(context, listen: false)
                  .createProduct(
                codeController.text,
                nameController.text,
                double.parse(priceController.text),
                int.parse(stockController.text),
              ).then((value) {
                Navigator.of(context).pop();
              });
            },
          ),
        ),
      ],
    );
  }
}
