import 'dart:io';
import 'package:com/api/api_constants.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../../Server/mysql_provider.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

class SplashDataProvider extends ChangeNotifier {
  String _zipPath = '${ApiConstants.baseUrl}PhpApi1/ProjectImages.zip';
  String _localZipFileName = 'ProjectImages.zip';
  String? dir;

//downloading zip folder project images
  /////////////////////////////////
  //calling default data from server to sqlite on installation
  //////////////////////////////////
  Future<bool> callSplashApis(BuildContext context) async {
    bool checkCon = false;
    if (Platform.isAndroid || Platform.isWindows) {
      // SharedPreferencesKeys.prefs!
      //     .setString(SharedPreferencesKeys.isDefaultApisCall, "true");

      print('-------------splash screen enter-----------------------------');
      if (SharedPreferencesKeys.prefs!
              .getString(SharedPreferencesKeys.isDefaultApisCall) ==
          null) {

        await _initDir();
        if (await Provider.of<MySqlProvider>(context, listen: false)
            .connectToServerDb()) {


          checkCon = true;
         // await deleteTableFrom(context);


          await getProjectDataFromServer(context);

          await getCountryCodeFromServer(context);

          await getProjectMenuFromServer(context);

          await getProjectMenuSubFromServer(context);

          await getAccount1TypeFromServer(context);

          await getClientFromServer(context);

          await getItem1TypeFromServer(context);



          Provider.of<MySqlProvider>(context, listen: false).conn!.close();
          SharedPreferencesKeys.prefs!
              .setString(SharedPreferencesKeys.isDefaultApisCall, "true");
        } else {
          print("Connection with remote server is not made............................................................");

        }

      }


    }
    return checkCon;
  }

  Future<void> getProjectMenuFromServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'ProjectMenu');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');
    String tableName = 'ProjectMenu';
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      try {
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query('SELECT * FROM  $tableName');
        Set<ResultRow> resultRow = results.toSet();
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).totalNumberOfTableRow(totalNumberOfRow: resultRow.length);
        if (resultRow.length > 0) {
         // await deleteTable(tableName);
        await insertTable(tableName, resultRow, context);
        }
      } on Exception catch (e, stk) {
        print(e);
        print(stk);
      }
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }
  Future<void> getClientFromServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Client');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');
    String tableName = 'Client';
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      try {
        Results results =
        await Provider.of<MySqlProvider>(context, listen: false)
            .conn!
            .query('SELECT * FROM  $tableName');
        Set<ResultRow> resultRow = results.toSet();
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).totalNumberOfTableRow(totalNumberOfRow: resultRow.length);
        if (resultRow.length > 0) {
         await deleteTable(tableName);
        // await insertTable(tableName, resultRow);
        }
      } on Exception catch (e, stk) {
        print(e);
        print(stk);
      }
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }

  Future<void> deleteTableFrom(BuildContext context) async {
    List list =   await Provider.of<DatabaseProvider>(context,listen: false).readTableName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).totalNumberOfTableRow(totalNumberOfRow: list.length);

    for(int i = 0; i < list.length ; i++){

      Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).insertingRow();
      Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
          .setStatus(status: 'Deleting');
      Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
          .setTableName(tableName: '${list[i]['name']}');

      await deleteTable(list[i]['name']);
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }
  Future<void> getCountryCodeFromServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'CountryCode');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');
    String tableName = 'CountryCode';
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      try {
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query('SELECT * FROM  $tableName');
        Set<ResultRow> resultRow = results.toSet();

        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).totalNumberOfTableRow(totalNumberOfRow: resultRow.length);

        if (resultRow.length > 0) {
         // await deleteTable(tableName);
         await insertTable(tableName, resultRow, context);
        }
      } on Exception catch (e, stk) {
        print(e);
        print(stk);
      }
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }

  Future<void> getItem1TypeFromServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Item1Type');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');
    String tableName = "Item1Type";
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      try {
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query('SELECT * FROM  $tableName');
        Set<ResultRow> resultRow = results.toSet();
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).totalNumberOfTableRow(totalNumberOfRow: resultRow.length);
        if (resultRow.length > 0) {
      //  await deleteTable(tableName);
         await insertTable(tableName, resultRow, context);
        }
      } on Exception catch (e, stk) {
        print(e);
        print(stk);
      }
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }

  Future<void> getAccount1TypeFromServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Account1Type');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');
    String tableName = "Account1Type";
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      try {
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query('SELECT * FROM  $tableName');
        Set<ResultRow> resultRow = results.toSet();
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).totalNumberOfTableRow(totalNumberOfRow: resultRow.length);
        if (resultRow.length > 0) {
        //  await deleteTable(tableName);
         await insertTable(tableName, resultRow, context);
        }
      } on Exception catch (e, stk) {
        print(e);
        print(stk);
      }
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }

  Future<void> getProjectMenuSubFromServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'ProjectMenuSub');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');
    String tableName = "ProjectMenuSub";
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      try {
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query('SELECT * FROM  $tableName');
        Set<ResultRow> resultRow = results.toSet();
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).totalNumberOfTableRow(totalNumberOfRow: resultRow.length);
        if (resultRow.length > 0) {
        // await deleteTable(tableName);
          await insertTable(tableName, resultRow, context);
        }
      } on Exception catch (e, stk) {
        print(e);
        print(stk);
      }
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }

  Future<void> getProjectDataFromServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Project');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');
    try {
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query('SELECT * FROM  Project');
      //print(results);
      Set<ResultRow> resultRow = results.toSet();
      Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).totalNumberOfTableRow(totalNumberOfRow: resultRow.length);
      //print(resultRow);
      if (resultRow.length > 0) {
      // await deleteTable('Project');
       await insertTable('Project', resultRow, context);
      }
    } catch (e, stk) {
  //   await showDialog(barrierDismissible: false, context: context, builder: (context) => AlertDialog(content: Text('Connection lost Please restart application and check your network thanks!!')),);
      print(e);
      print(stk);
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }

  //These are repeating functionsa
  Future<void> deleteTable(String tableName) async {
    var db =  await DatabaseProvider().init();
    // String query = '''
    //   DELETE from $tableName;
    //   ''';
    await db.delete(tableName);
    db.close();
    print("table deleted");
  }

  Future<void> insertTable(String tableName, Set<ResultRow> resultRow, context) async {
    print("inserting start");
    try {
      var db =  await DatabaseProvider().init();



      for (int i = 0; i < resultRow.length; i++) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).insertingRow();
        await db.insert(
          tableName,
          Map.from(resultRow.elementAt(i).fields),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
     // db.close();
      //
    } catch (e, stk) {
      print(e);
      print(stk);
    }
  }

  Future<bool> checkImageFileExistOrNot() async {
    if (null == dir) {
      List<Directory>? list = (await getExternalStorageDirectories());
      dir = list![0].path;
    }
    String savePath = "$dir/ProjectImages";
    print(savePath);
    if (Directory(savePath).existsSync()) {
      print('File exists');
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveImageFolderInExternalDirectory() async {
    var zippedFile = await _downloadFile(_zipPath, _localZipFileName);
    await unarchiveAndSave(zippedFile);
  }

  Future<void> _initDir() async {
    if (null == dir) {
      if (Platform.isWindows) {
        Directory directory = await getApplicationDocumentsDirectory();
        dir = directory.path;
      } else {
        List<Directory>? list = (await getExternalStorageDirectories());
        dir = list![0].path;
      }
    }
  }

  Future<File> _downloadFile(String url, String fileName) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$dir/$fileName');
    return file.writeAsBytes(req.bodyBytes);
  }

  Future<void> unarchiveAndSave(var zippedFile) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$dir/${file.name}';
      if (file.isFile) {
        var outFile = File(fileName);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
  }
}
