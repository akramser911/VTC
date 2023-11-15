import 'package:flutter/cupertino.dart';

class AuthModel extends ChangeNotifier {
  late String _phoneNumber;
  bool _isAuthenticated = false;
  late String _accessToken;

  bool get isAuthenticated => _isAuthenticated;
  String get phoneNumber => _phoneNumber;
  String get accessToken => _accessToken;

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  void setAuth(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }
}
