

import 'package:flutter/material.dart';

class statusSearchForSchoolFinder with ChangeNotifier {


  int _insertingRow = 0;
  String _locationName = '';
  int _totalNumberOfRow = 0;

  int get count => _insertingRow;



  String get locationName => _locationName;

  int get totalNumberOfRow => _totalNumberOfRow;


  void setLocationName({required String tableName}) {
    _locationName = tableName;
    notifyListeners();
  }


  void insertingRow() {
    _insertingRow++;
    notifyListeners();
  }

  void resetName() {
    _locationName = '';
    notifyListeners();
  }


  void resetRow() {
    _insertingRow = 0;
    notifyListeners();
  }

  void resetTotalNumber() {
    _totalNumberOfRow = 0;
    notifyListeners();
  }
  void totalNumberOfTableRow({required int totalNumberOfRow}) {
    _totalNumberOfRow = totalNumberOfRow;
    notifyListeners();
  }

}
