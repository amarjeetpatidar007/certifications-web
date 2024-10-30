import 'package:flutter/material.dart';

class SignInState extends ChangeNotifier {
  bool _isSigningIn = false;
  String? _error;

  bool get isSigningIn => _isSigningIn;

  String? get error => _error;

  void startSignIn() {
    _isSigningIn = true;
    _error = null;
    notifyListeners();
  }

  void stopSignIn() {
    _isSigningIn = false;
    notifyListeners();
  }

  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
