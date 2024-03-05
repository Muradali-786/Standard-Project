import 'package:flutter/material.dart';

class TotalAmount extends ChangeNotifier {

  double _grandTotal = 0.0;

  double get grandTotal => _grandTotal;

  set grandTotal(double value) {
    _grandTotal = value;
     notifyListeners();
  }
}
