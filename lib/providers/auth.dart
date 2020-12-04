import 'package:flutter/cupertino.dart';

class Auth extends ChangeNotifier {

  String _token;

  String get token {
    return _token;
  }

  bool get isAuth {
    return _token != null;
  }

  Future<bool> login(String username, String password) async {
    if(username == "usuario" && password == "1234") {
      _token = "token";
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}