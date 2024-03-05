import 'package:flutter/material.dart';

class ShowInsertingTableRowTOServer with ChangeNotifier {

  bool _connection = true;
  int _insertingRow = 0;
  String _tableName = '';
  String _status = '';
  int _totalNumberOfRow = 0;

  int get count => _insertingRow;

  int get totalNumberOfRow => _totalNumberOfRow;

  String get tableName => _tableName;

  String get status => _status;

  bool get connection => _connection;


  void setConnection({required bool connection}) {
    _connection = connection;
    notifyListeners();
  }

  void setTableName({required String tableName}) {
    _tableName = tableName;
    notifyListeners();
  }

  void setStatus({required String status}) {
    _status = status;
    notifyListeners();
  }

  void insertingRow() {
    _insertingRow++;
    notifyListeners();
  }

  void resetName() {
    _tableName = '';
    notifyListeners();
  }

  void resetStats() {
    _status = '';
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
