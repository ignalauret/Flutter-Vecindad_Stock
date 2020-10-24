import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/pages/products_page/components/products_list.dart';
import 'package:vecindad_stock/utils/custom_styles.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 80,
                  width: 230,
                  child: ActionButton(
                    label: "Agregar Producto",
                    fontSize: 20,
                    onTap: () {
                      Provider.of<ProductsProvider>(context, listen: false)
                          .createProduct();
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Todos los productos",
              style: CustomStyles.kTitleStyle,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              child: ProductsList(),
            ),
          ),
        ],
      ),
    );
  }
}
