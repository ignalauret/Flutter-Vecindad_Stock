import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/components/custom_text_field.dart';
import 'package:vecindad_stock/components/dialog_header.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class CreateProductDialog extends StatefulWidget {
  CreateProductDialog({this.editProduct});
  final Product editProduct;
  @override
  _CreateProductDialogState createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController(text: "0");

  bool codeError = false;
  bool isEdit = false;
  bool _tapped = true;

  @override
  void initState() {
    if (widget.editProduct != null) {
      isEdit = true;
      codeController.text = widget.editProduct.code;
      nameController.text = widget.editProduct.name;
      priceController.text = widget.editProduct.price.toStringAsFixed(2);
      stockController.text = widget.editProduct.stock.toString();
    }
    codeController.addListener(() {
      setState(() {});
    });
    nameController.addListener(() {
      setState(() {});
    });
    priceController.addListener(() {
      setState(() {});
    });
    stockController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void submit() {
    setState(() {
      _tapped = true;
    });
    if (isEdit) {
      context
          .read<ProductsProvider>()
          .editProduct(
            widget.editProduct.id,
            codeController.text,
            nameController.text,
            int.parse(priceController.text),
            int.parse(stockController.text),
          )
          .then((value) {
        Navigator.of(context).pop(true);
      });
    } else {
      final product = context
          .read<ProductsProvider>()
          .getProductByCode(codeController.text);
      // Check if product exists
      if (product != null) {
        setState(() {
          codeError = true;
          _tapped = false;
        });
      } else {
        context
            .read<ProductsProvider>()
            .createProduct(
              codeController.text,
              nameController.text,
              int.parse(priceController.text),
              int.parse(stockController.text),
            )
            .then((value) {
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogHeader(isEdit ? "Editar producto" : "Agregar Producto"),
      content: Container(
        height: 350,
        width: 700,
        child: Column(
          children: [
            Container(
              height: 100,
              width: 600,
              child: CustomTextField("Nombre", nameController),
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
                  child: CustomTextField("Precio", priceController),
                ),
                SizedBox(width: 75),
                Container(
                  height: 100,
                  width: 150,
                  child: CustomTextField(
                      isEdit ? "Stock actual" : "Stock Inicial",
                      stockController),
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
            label: isEdit ? "Guardar" : "Agregar",
            fontSize: 25,
            onTap: submit,
            enabled: !_tapped &&
                nameController.text.isNotEmpty &&
                codeController.text.isNotEmpty &&
                priceController.text.isNotEmpty &&
                stockController.text.isNotEmpty,
          ),
        ),
      ],
    );
  }
}
