import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/providers/auth.dart';
import 'package:vecindad_stock/providers/products_provider.dart';
import 'package:vecindad_stock/providers/transactions_provider.dart';
import 'package:vecindad_stock/screens/login_screen/login_screen.dart';
import 'package:vecindad_stock/screens/tab_controller_screen/tab_controller_screen.dart';
import 'package:vecindad_stock/utils/custom_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TransactionsProvider>(
          create: (context) => TransactionsProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<ProductsProvider>(
          create: (context) => ProductsProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'La Vecindad',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: CustomColors.kAccentColor,
          ),
          home: authData.isAuth ? TabControllerScreen() : LoginScreen(),
        ),
      ),
    );
  }
}
