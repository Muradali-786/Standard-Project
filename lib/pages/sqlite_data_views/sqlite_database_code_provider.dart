// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:com/pages/material/Toast.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:com/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqlcipher;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseProvider extends ChangeNotifier {
  List tableDetailList = [];
  List<dynamic> tableColumnName = [];
  List groupSetList = [];
  String layoutName = "";

  Future<Database> init() async {
    Directory? documentsDirectory;
    String path = '';
    if (Platform.isWindows) {
      documentsDirectory = await getApplicationSupportDirectory();
      path = join(documentsDirectory.path, 'ESD_WINDOW.db');
    } else {
      documentsDirectory = await getExternalStorageDirectory();
      path = join(documentsDirectory!.path, 'ESD.db');
    }

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data;
      if (Platform.isWindows) {
        data = await rootBundle.load(join('assets/database/ESD_WINDOW.db'));
      } else {
        data = await rootBundle.load(join('assets/database/ESD.db'));
      }
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await new File(path).writeAsBytes(bytes);
    }
    var db;

    if (Platform.isWindows) {
      db = await databaseFactoryFfi.openDatabase(path);
    } else {
      db = await sqlcipher.openDatabase(path, password: '1122334455');
    }

    return db;
  }

  ///  no use for delete file ................................
  Future<void> delete() async {
    Directory? documentsDirectory;
    if (Platform.isWindows) {
      documentsDirectory = await getApplicationSupportDirectory();
    } else {
      documentsDirectory = await getExternalStorageDirectory();
    }
    String databasePath = join(documentsDirectory!.path, 'ESD.db');
    if (FileSystemEntity.typeSync(databasePath) ==
        FileSystemEntityType.notFound) {
      print("File not found");
      //ByteData data = await rootBundle.load(join('assets/database', 'test.db'));
      //ByteData data = await rootBundle.load(join('assets/database', 'test.db'));
      ByteData data = await rootBundle.load(join('assets/database/ESD.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(databasePath).writeAsBytes(bytes);
    } else {
      print('file delete fully .....................................');
      await new File(databasePath).delete();
    }
  }

  ////////////////////
  //Show table name query
  ///////////////////
  Future<List> readTableName() async {
    var db = await init();
    String query = '''
     SELECT name FROM sqlite_schema
     WHERE type='table'
       ORDER BY name
      ''';
    List<dynamic> list = await db.rawQuery(query);
    return list;
  }

  Future<void> removeColumn(String columnName) async {
    if (tableColumnName.isNotEmpty) tableColumnName..remove(columnName);
    for (int i = 0; i < tableDetailList.length; i++) {
      Map map = tableDetailList[i];
      map..remove(columnName);
    }
  }

  groupBy(String columnName) {
    Set groupSet = Set();
    groupSet.clear();
    for (int i = 0; i < tableDetailList.length; i++) {
      groupSet.add(tableDetailList[i][columnName]);
    }
    //Set sortSet=SplayTreeSet.from(groupSet,(a, b) => a.compareTo(b) );
    groupSetList = groupSet.toList();
    groupSetList.sort();
    print(groupSetList);
  }

  ////////////////////////////////////
  //Table name pass to table layout
  //////////////////////////////////////
  Future<void> getTable(String tableName) async {
    var db = await init();
    String query = '''
      SELECT * FROM $tableName;
      ''';
    tableDetailList.clear();
    List list = await db.rawQuery(query);

    print('$list.......................');

    if (list.length != 0) {
      List listCopy = List.from(list);
      for (int i = 0; i < listCopy.length; i++) {
        if (listCopy[i] != null) {
          tableDetailList.add(listCopy[i]);
        }
      }
    } else {
      String query = '''
      SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '$tableName';
      ''';
      List list = await db.rawQuery(query);
      List listCopy = List.from(list);
      for (int i = 0; i < listCopy.length; i++) {
        if (listCopy[i] != null) {
          tableDetailList.add(listCopy[i]);
        }
      }
    }

    print(tableDetailList);

    tableColumnName.clear();
    if (tableDetailList.isNotEmpty) {
      Map map = tableDetailList[0];
      map.forEach((key, value) {
        tableColumnName.add(key);
      });
    }
  }

  Future<void> checkTableColumnVisibility() async {
    try {
      var db = await init();
      String query = '''
      Select columnName,visibility from Setting where `layout`='$layoutName' AND `ClientUserID`='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}' AND
              "SettingType"='${Constants.visibility}'
      ''';
      List<Map<String, Object?>> list = await db.rawQuery(query);
      for (Map<String, dynamic> item in list) {
        if (item['visibility'] == 0) {
          removeColumn(item['columnName']);
        }
      }
    } on Exception catch (e, stk) {
      print(e);
      print(stk);
    }
  }

  Future<void> getTableByQuery(String? Query, BuildContext context) async {
    try {
      if (Query == null) {
        tableDetailList.clear();
        tableColumnName.clear();
        Toast.buildErrorSnackBar("No Query Available");
      } else {
        String clientId = SharedPreferencesKeys.prefs!
            .getInt(SharedPreferencesKeys.clinetId)!
            .toString();
        String date2 = SharedPreferencesKeys.prefs!
            .getString(SharedPreferencesKeys.toDate)!;
        String date1 = SharedPreferencesKeys.prefs!
            .getString(SharedPreferencesKeys.fromDate)!;
        Query = Query.replaceAll('@ClientID', clientId);
        Query = Query.replaceAll('@Date2', date2);
        Query = Query.replaceAll('@Date1', date1);
        print("getTableByQuery");
        var db = await init();
        String query = Query;
        tableDetailList.clear();
        List list = await db.rawQuery(query);
        List<Map<String, dynamic>> listCopy = List.from(list);
        print("DateFormating testing");
        for (int i = 0; i < listCopy.length; i++) {
          Map<String, dynamic> map = Map.from(listCopy[i]);
          map.forEach((key, value) {
            try {
              if (value.runtimeType == String &&
                  DateTime.tryParse(value) != null) {
                //Map<String,dynamic> map=Map.from(listCopy[i]);
                map[key] = DateFormat(SharedPreferencesKeys.prefs!
                        .getString(SharedPreferencesKeys.dateFormat))
                    .format(DateTime.tryParse(value)!);
              } else if (value.runtimeType == int) {
                print(key);
                map[key] = NumberFormat("###,###", "en_US").format(value);
              }
            } on FormatException catch (e, stk) {
              print(e);
              print(stk);
            }
          });
          listCopy[i] = map;
          tableDetailList.add(listCopy[i]);
        }
        tableColumnName.clear();
        Map map = tableDetailList[0];
        map.forEach((key, value) {
          tableColumnName.add(key);
        });
        for (var columnName in tableColumnName) {
          query = '''
         Select * from Setting where `layout`='$layoutName' AND
         `ClientID`='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}' AND
         `ClientUserID`='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}' AND
         `columnName`='$columnName'
         ''';
          List list = await db.rawQuery(query);
          if (list.length == 0) {
            query = '''
           select -(IfNull(Max(Abs(SettingID)),0)+1) as MaxId from Setting where ClientID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}'
                 ''';
            List list = await db.rawQuery(query);
            var maxID = list[0]['MaxId'].round();
            await db.insert('Setting', {
              'layout': '$layoutName',
              "ClientID":
                  '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}',
              "ClientUserID":
                  '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}',
              "columnName": "$columnName",
              "UpdatedDate": "",
              "SettingID": maxID,
              "visibility": "1",
              "SettingType": Constants.visibility,
            });
            //await db.
          }
        }
        if (tableDetailList.isNotEmpty) {
          await checkTableColumnVisibility();
        }
      }
    } on Exception catch (e, stk) {
      print(e);
      print(stk);
    }
  }

  Future<void> getProjectMenuTable() async {
    var db = await init();
    String query = '''
      SELECT * FROM ProjectMenu;
      ''';
    List list = await db.rawQuery(query);
    for (int i = 0; i < list.length; i++) {}
  }

  num getSumOfColumn(dynamic columnName, int columnPosition) {
    print(tableDetailList[0][columnName].runtimeType);
    if (tableDetailList[0][columnName].runtimeType == int ||
        int.tryParse(tableDetailList[0][columnName]) != null) {
      num sum = 0;
      for (int i = 0; i < tableDetailList.length; i++) {
        if (tableDetailList[i][columnName] != null &&
            tableDetailList[i][columnName].runtimeType == int)
          sum += tableDetailList[i][columnName];
        else if (tableDetailList[i][columnName].runtimeType == String &&
            tableDetailList[i][columnName] != null) {
          sum += int.parse(tableDetailList[i][columnName]);
        }
      }
      return sum;
    } else {
      print('column data is not in numbers');
      return 0;
    }
  }

  getMinValue(dynamic columnName) {
    if (tableDetailList[0][columnName].runtimeType == int) {
      print(columnName);
      List cList = [];
      for (int i = 0; i < tableDetailList.length; i++) {
        cList.add(tableDetailList[i][columnName]);
      }
      cList.sort();
      return cList[0];
    } else {
      print('column data is not in numbers');
    }
  }

  getMaxValue(dynamic columnName) {
    if (tableDetailList[0][columnName].runtimeType == int) {
      print(columnName);
      List cList = [];
      for (int i = 0; i < tableDetailList.length; i++) {
        cList.add(tableDetailList[i][columnName]);
      }
      cList.sort();
      return cList[cList.length - 1];
    } else {
      print('column data is not in numbers');
    }
  }

  getColumnCount(dynamic columnName) {
    if (tableDetailList[0][columnName].runtimeType == int) {
      print(columnName);
      List cList = [];
      for (int i = 0; i < tableDetailList.length; i++) {
        cList.add(tableDetailList[i][columnName]);
      }
      cList.sort();
      return cList.length;
    } else {
      print('column data is not in numbers');
    }
  }

  getSearchList(String searchValue, String columnName) {
    Set set = Set();
    List searchList = [];
    set.clear();
    searchList.clear();
    for (int i = 0; i < tableDetailList.length; i++) {
      set.add(tableDetailList[i][columnName]);
    }
    List cList = set.toList();
    cList.forEach((element) {
      if (element
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        searchList.add(element);
      }
    });
    return searchList;
    //print(cList.contains(int.parse(searchValue)));
    // cList.forEach((element) {
    //   if(element.toString().contains(element)){
    //     print("element is in list");
    //   }
    // });
  }

  getSearchTable(String columnName, int columnIndex, List searchList) {
    List tableDetailListCopy = tableDetailList;
    tableDetailList = [];
    tableDetailList.clear();
    for (int i = 0; i < tableDetailListCopy.length; i++) {
      Map map = tableDetailListCopy[i];
      if (searchList.contains(map[columnName])) {
        tableDetailList.add(map);
      }
    }
    print(tableDetailList);
  }

  runningSum(String columName) {
    tableDetailList = List.from(tableDetailList);
    List cList = [];
    List tableRunningDetailList = [];
    for (int i = 0; i < tableDetailList.length; i++) {
      cList.add(tableDetailList[i][columName].toString());
    }
    if (int.tryParse(cList[0]) != null) {
      int sum = 0;
      tableRunningDetailList.clear();
      Map map = Map.from(tableDetailList[0]);
      map["Running Average"] = int.parse(cList[0]);
      sum = int.parse(cList[0]);
      tableRunningDetailList.add(map);
      print(tableRunningDetailList);
      tableColumnName.add("Running Average");
      for (int j = 1; j < tableDetailList.length; j++) {
        Map map = Map.from(tableDetailList[j]);
        map["Running Average"] = sum + int.parse(cList[j]);
        sum = map["Running Average"];
        tableRunningDetailList.add(map);
      }
      print(tableRunningDetailList);
      tableDetailList = tableRunningDetailList;
    } else {
      print("column contains string");
    }
  }
}
