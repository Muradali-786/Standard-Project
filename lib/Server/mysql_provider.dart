
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class MySqlProvider extends ChangeNotifier {
  ConnectionSettings settings = ConnectionSettings(
      host: '15.204.0.108',
      port: 3306,
      user: 'easysoft_amir2',
      password: '%?pyC=[s~&Gl',
      db: 'easysoft_easysoft2');
  MySqlConnection? conn;

  Future<bool> connectToServerDb() async {
    try {
      conn = await MySqlConnection.connect(settings);
      return true;
    } catch (e, stk) {
      print('Error connecting to MySQL server: $e');
      print('Stack Trace: $stk');
      return false;
    }
  }
}
