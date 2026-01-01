import 'package:demo_app/data/secure_storage.dart';
import 'package:flutter/material.dart';

class AuthenticationViewModel extends ChangeNotifier {
  SecureStorage storage = SecureStorage();
  bool _isAuthenticated = false;

  Future<void> getToken() async {
    _isAuthenticated = await storage.getTokenBool();
    // final token = await storage.readToken();
    //   if (token != null) {
    //     _isAuthenticated = true;
    //   } else {
    //     _isAuthenticated = false;
    //   }

    notifyListeners();
  }
}
