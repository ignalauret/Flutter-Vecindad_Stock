import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/components/dialog_header.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';

class ProductDetailDialog extends StatelessWidget {
  ProductDetailDialog(this.product);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogHeader(product.name),
      content: Column(
        children: [
          Container(
            height: 150,
            width: 200,
            child: ActionButton(
              label: "Eliminar",
              onTap: () {
                context
                    .read<ProductsProvider>()
                    .deleteProduct(product.id)
                    .then((value) => Navigator.of(context).pop());
              },
            ),
          ),
        ],
      ),
    );
  }
}
