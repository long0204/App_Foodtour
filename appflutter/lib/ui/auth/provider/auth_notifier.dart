import 'package:flutter/material.dart';

class AuthNotifier extends ChangeNotifier {
  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  void login() {
    _loggedIn = true;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }

  void setLogin(bool value) {
    _loggedIn = value;
    notifyListeners();
  }
}
final AuthNotifier authNotifier = AuthNotifier();