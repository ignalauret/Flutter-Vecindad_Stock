import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindad_stock/components/action_button.dart';
import 'package:vecindad_stock/components/custom_text_field.dart';
import 'package:vecindad_stock/providers/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void tryLogin() {
    context.read<Auth>().login(
          usernameController.text,
          passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 448,
          width: 400,
          child: Card(
            elevation: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 60),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: Image.asset("assets/img/logo.png"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField("Usuario", usernameController),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    "Contraseña",
                    passwordController,
                    obscure: true,
                    onSubmit: (_) => tryLogin(),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    height: 70,
                    width: 150,
                    child: ActionButton(
                      label: "Ingresar",
                      onTap: tryLogin,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
