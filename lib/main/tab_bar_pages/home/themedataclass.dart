import 'package:flutter/material.dart';

class ThemeDataHomePage extends ChangeNotifier {
  Color _backGroundColor = Colors.white;
  Color _borderTextAppBarColor = Colors.blue;
  String _projectName = 'EasySoft';
  String _projectIconURL = '';
  String _openWithProjectID = '';


  String get openWithProjectID => _openWithProjectID;

  set openWithProjectID(String value) {
    _openWithProjectID = value;
    notifyListeners();
  }

  String get projectIconURL => _projectIconURL;

  set projectIconURL(String value) {
    _projectIconURL = value;
    notifyListeners();
  }

  String get projectName => _projectName;

  set projectName(String value) {
    _projectName = value;
    notifyListeners();
  }

  Color get backGroundColor => _backGroundColor;

  set backGroundColor(Color value) {
    _backGroundColor = value;
    notifyListeners();
  }

  Color get borderTextAppBarColor => _borderTextAppBarColor;

  set borderTextAppBarColor(Color value) {
    _borderTextAppBarColor = value;
    notifyListeners();
  }
}
