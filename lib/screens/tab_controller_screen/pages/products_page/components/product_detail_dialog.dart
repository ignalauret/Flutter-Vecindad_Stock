import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/components/confirmation_dialog.dart';
import 'package:vecindad_stock/components/dialog_header.dart';
import 'package:vecindad_stock/models/product.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/products_page/components/create_product_dialog.dart';
import 'package:vecindad_stock/utils/constants.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class ProductDetailDialog extends StatelessWidget {
  ProductDetailDialog(this.product);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      title: DialogHeader(product.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStat("Código", product.code),
          _buildStat("Precio", "\$${product.price.toStringAsFixed(2)}"),
          _buildStat("Stock", product.stock.toString()),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: 70,
                width: 140,
                child: ActionButton(
                  label: "Eliminar",
                  secondary: true,
                  color: Colors.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        message:
                            "Está seguro que quiere eliminar el producto '${product.name}'?",
                        onConfirmed: () => context
                            .read<ProductsProvider>()
                            .deleteProduct(product.id)
                            .then((value) => Navigator.of(context).pop(true)),
                      ),
                    ).then((deleted) {
                      if (deleted ?? false) Navigator.of(context).pop();
                    });
                  },
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                height: 70,
                width: 140,
                child: ActionButton(
                  label: "Editar",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateProductDialog(
                        editProduct: product,
                      ),
                    ).then((value) {
                      if (value == true) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildStat(String label, String value) {
    return Container(
      child: Row(
        children: [
          Text(
            label + ":",
            style: CustomStyles.kAccentTextStyle,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            value,
            style: CustomStyles.kNormalStyle,
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
