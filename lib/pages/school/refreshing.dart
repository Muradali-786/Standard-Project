import 'package:com/pages/school/refresh_image.dart';
import 'package:flutter/material.dart';
import 'package:com/Server/mysql_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:com/widgets/constants.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

class SchServerRefreshing {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);
  String? countryClientId2 = SharedPreferencesKeys.prefs!
      .getString(SharedPreferencesKeys.countryClientID2);

  var sch1BranchMaxDate;
  var sch2YearMaxDate;
  var classMaxDate;
  var classSectionMaxDate;
  var classSectionStudentMaxDate;
  var feeDueMaxDate;
  var feeRec1MaxDate;
  var feeRec2MaxDate;
  var sch9StudentsInfoMaxDate;
  bool connecction = true;


  Future checkConnection(context ) async{
    while (Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).connection){
      if (
      await Provider.of<MySqlProvider>(context, listen: false)
          .connectToServerDb()) {
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .setConnection(connection: false);
        }
    }
  }

  getAllUpdatedDataFromServer(
    BuildContext context,
  ) async {
    String refreshingTitle = 'Data is refreshing';
    clientID =
        SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
    clientUserID =
        SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
    netCode =
        SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
    sysCode =
        SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);
    countryClientId2 = SharedPreferencesKeys.prefs!
        .getString(SharedPreferencesKeys.countryClientID2);

      //1. Check internet connectivity
      //2. handle server response
      //3. country user activation check if activation failed logout
      //4. client admin ka country user account activation check
      //5. client ka user account activation check
      /////////////////////////
    if (
    await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Constants.onLoading(context, refreshingTitle);


      // branch///////////
      await updateSch1BranchesDataToServer(context);
      await sch1BranchesInsertDataToServer(context);

      print(sch1BranchMaxDate);
      await getTableDataFromServeToInSqlite(
          context, 'Sch1Branches', sch1BranchMaxDate);

      ///    Sch2Year   ////////
      await updateSch2YearDataToServer(context);
      await sch2YearInsertDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Sch2Year', sch2YearMaxDate);

      ///    Sch3Classes   ////////
      await updateSch3ClassesDataToServer(context);
      await sch3ClassesInsertDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Sch3Classes', classMaxDate);

      ///    Sch4ClassesSection   ////////
      await updateSch4ClassesSectionDataToServer(context);
      await sch4ClassesSectionInsertDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Sch4ClassesSection', classSectionMaxDate);

      ///    Sch5SectionStudent   ////////
      await updateSch5SectionStudentDataToServer(context);
      await sch5SectionStudentInsertDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Sch5SectionStudent', classSectionStudentMaxDate);

      ///    Sch6StudentFeeDue   ////////
      await updateSch6StudentFeeDueDataToServer(context);
      await sch6StudentFeeDueInsertDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Sch6StudentFeeDue', feeDueMaxDate.toString());

      ///    Sch7FeeRec1   ////////
      await updateSch7FeeRec1DataToServer(context);
      await sch7FeeRec1InsertDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Sch7FeeRec1', feeRec1MaxDate);

      ///    Sch7FeeRec2   ////////
      await updateSch7FeeRec2DataToServer(context);
      await sch7FeeRec2InsertDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Sch7FeeRec2', feeRec2MaxDate);

      //   Sch9StudentsInfo   ////////
      await updateSch9StudentsInfoDataToServer(context);
      await sch9StudentsInfoInsertDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Sch9StudentsInfo', sch9StudentsInfoMaxDate);

      await dialogToUploadImageToServer(context);
      print("all data is updated");
    }

      await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
      Constants.hideDialog(context);



  }

  ///       update date to server Sch1Branches //////////////////////////////////
  updateSch1BranchesDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch1Branches');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db = await DatabaseProvider().init();

    print( ' ...........................................         $clientID');
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Sch1Branches where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      sch1BranchMaxDate = maxDate[0]['MaxDate'];
      sch1BranchMaxDate ??= 0;
      query = '''
      Select * from Sch1Branches where UpdatedDate='' AND BranchID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {


          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');

          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];

          try {

              results = await Provider
                  .of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('''
              UPDATE `Sch1Branches` SET `BranchID`='${map['BranchID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `BranchName`='${map['BranchName']}',`Address`='${map['Address']}',`ContactNo`='${map['ContactNo']}',`LongLat`='${map['LongLat']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	BranchID= '${map['BranchID']}'
              ''');
              Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                  .insertingRow();
              if (results.affectedRows! > 0) {
                await db.update(
                    "Sch1Branches", {"UpdatedDate": '$serverDateTime'},
                    where: "ID='${map['ID']}'");
              }

          } catch (e) {
            print(
                'error in branch update ......$e.............................');
          }

        }
      } else {
        print("No record in Branch for update");
      }
    } catch (e) {
      print('ex in update $e');
    }
    await db.close();

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();

    return sch1BranchMaxDate;
  }

  ///       update date to server Sch2Year //////////////////////////////////
  updateSch2YearDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch2Year');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Sch2Year where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      sch2YearMaxDate = maxDate[0]['MaxDate'];
      sch2YearMaxDate ??= 0;
      query = '''
      Select * from Sch2Year where UpdatedDate='' AND EducationalYearID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          try {
            results = await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query('''
              UPDATE `Sch2Year` SET `EducationalYearID`='${map['EducationalYearID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `BranchID`='${map['BranchID']}',`EducationalYear`='${map['EducationalYear']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	EducationalYearID='${map['EducationalYearID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update("Sch2Year", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print('error in year update ......$e.............................');
          }
        }
      } else {
        print("No record in year for update");
      }
    } catch (e) {
      print('ex in update $e');
    }
    await db.close();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();

    return sch2YearMaxDate;
  }

  ///       update date to server Sch3Classes //////////////////////////////////
  updateSch3ClassesDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch3Classes');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Sch3Classes where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      classMaxDate = maxDate[0]['MaxDate'];
      classMaxDate ??= 0;
      query = '''
      Select * from Sch3Classes where UpdatedDate='' AND ClassID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];

          try {
            results = await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query('''
              UPDATE `Sch3Classes` SET `ClassID`='${map['ClassID']}',`EducationalYearID`='${map['EducationalYearID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `ClassName`='${map['ClassName']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	ClassID='${map['ClassID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update("Sch3Classes", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print('update error of class...............  $e');
          }
        }
      } else {
        print("No record in year for update");
      }
    } catch (e) {
      print('ex in update $e');
    }
    await db.close();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();

    return classMaxDate;
  }

  ///       update date to server Sch4ClassesSection //////////////////////////////////
  updateSch4ClassesSectionDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch4ClassesSection');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Sch4ClassesSection where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      classSectionMaxDate = maxDate[0]['MaxDate'];
      classSectionMaxDate ??= 0;
      query = '''
      Select * from Sch4ClassesSection where UpdatedDate='' AND SectionID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          try {
            results = await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query('''
              UPDATE `Sch4ClassesSection` SET `ClassID`='${map['ClassID']}',`SectionID`='${map['SectionID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `SectionName`='${map['SectionName']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	SectionID='${map['SectionID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "Sch4ClassesSection", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in update Sch4ClassesSection.............................');
          }
        }
      } else {
        print("No record in year for update");
      }
    } catch (e) {
      print('ex in update $e');
    }
    await db.close();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    return classSectionMaxDate;
  }

  ///       update date to server Sch5SectionStudent //////////////////////////////////
  updateSch5SectionStudentDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch5SectionStudent');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Sch5SectionStudent where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      classSectionStudentMaxDate = maxDate[0]['MaxDate'];
      classSectionStudentMaxDate ??= 0;
      query = '''
      Select * from Sch5SectionStudent where UpdatedDate='' AND SectionStudenID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          try {
            results = await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query('''
              UPDATE `Sch5SectionStudent` SET `SectionStudenID`='${map['SectionStudenID']}',`SectionID`='${map['SectionID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `GRN`='${map['GRN']}', `MonthlyFee`='${map['MonthlyFee']}', `OtherFee`='${map['OtherFee']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	SectionStudenID='${map['SectionStudenID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "Sch5SectionStudent", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in update Sch5SectionStudent..............................');
          }
        }
      } else {
        print("No record in year for update");
      }
    } catch (e) {
      print('ex in update $e');
    }
    await db.close();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    return classSectionStudentMaxDate;
  }

  ///       update date to server Sch6StudentFeeDue //////////////////////////////////
  updateSch6StudentFeeDueDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch6StudentFeeDue');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Sch6StudentFeeDue where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      feeDueMaxDate = maxDate[0]['MaxDate'];
      feeDueMaxDate ??= 0;
      query = '''
      Select * from Sch6StudentFeeDue where UpdatedDate='' AND FeeDueID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `Sch6StudentFeeDue` SET `FeeDueID`='${map['FeeDueID']}',`SectionStudentID`='${map['SectionStudentID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `GRN`='${map['GRN']}', `DueDate`='${map['DueDate']}', `FeeNarration`='${map['FeeNarration']}', `FeeDueAmount`='${map['FeeDueAmount']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	FeeDueID='${map['FeeDueID']}'
              ''');
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.update(
                "Sch5SectionStudent", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
        }
      } else {
        print("No record in year for update");
      }
    } catch (e) {
      print('ex in update $e');
    }
    await db.close();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    return feeDueMaxDate;
  }

  ///       update date to server Sch7FeeRec1 //////////////////////////////////
  updateSch7FeeRec1DataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch7FeeRec1');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Sch7FeeRec1 where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      feeRec1MaxDate = maxDate[0]['MaxDate'];
      feeRec1MaxDate ??= 0;
      query = '''
      Select * from Sch7FeeRec1 where UpdatedDate='' AND FeeRec1ID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `Sch7FeeRec1` SET `FeeRec1ID`='${map['FeeRec1ID']}',`FeeRecDate`='${map['FeeRecDate']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `FeeRecRemarks`='${map['FeeRecRemarks']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	FeeRec1ID='${map['FeeRec1ID']}'
              ''');
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.update("Sch7FeeRec1", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
        }
      } else {
        print("No record in year for update");
      }
    } catch (e) {
      print('ex in update $e');
    }
    await db.close();

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    return feeRec1MaxDate;
  }

  ///       update date to server Sch7FeeRec2 //////////////////////////////////
  updateSch7FeeRec2DataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch7FeeRec2');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Sch7FeeRec2 where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      feeRec2MaxDate = maxDate[0]['MaxDate'];
      feeRec2MaxDate ??= 0;
      query = '''
      Select * from Sch7FeeRec2 where UpdatedDate='' AND FeeRec2ID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `Sch7FeeRec2` SET `FeeRec1ID`='${map['FeeRec1ID']}',`FeeRec2ID`='${map['FeeRec2ID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `FeeDueID`='${map['FeeDueID']}',`RecAmount`='${map['RecAmount']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	FeeDueID='${map['FeeDueID']}'
              ''');
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.update("Sch7FeeRec2", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
        }
      } else {
        print("No record in year for update");
      }
    } catch (e) {
      print('ex in update $e');
    }
    await db.close();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    return feeRec2MaxDate;
  }

  ///       update date to server Sch9StudentsInfo //////////////////////////////////
  updateSch9StudentsInfoDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch9StudentsInfo');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Sch9StudentsInfo where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      sch9StudentsInfoMaxDate = maxDate[0]['MaxDate'];
      sch9StudentsInfoMaxDate ??= 0;
      query = '''
      Select * from Sch9StudentsInfo where UpdatedDate='' AND StudentID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');

          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `Sch9StudentsInfo` SET `StudentID`='${map['StudentID']}',`AdmissionDate`='${map['AdmissionDate']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `GRN`='${map['GRN']}',`FamilyGroupNo`='${map['FamilyGroupNo']}',`StudentName`='${map['StudentName']}',`DateOfBirth`='${map['DateOfBirth']}',`StudentMobileNo`='${map['StudentMobileNo']}',
              `Address`='${map['Address']}',`AddressPhoneNo`='${map['AddressPhoneNo']}',`FahterName`='${map['FahterName']}',`FatherMobileNo`='${map['FatherMobileNo']}',
              `FatherNIC`='${map['FatherNIC']}',`FatherProfession`='${map['FatherProfession']}',`MotherName`='${map['MotherName']}',
              `MotherMobileNo`='${map['MotherMobileNo']}',`MotherNIC`='${map['MotherNIC']}',`MotherProfession`='${map['MotherProfession']}',
              `OtherDetail`='${map['OtherDetail']}',`AdmissionRemarks`='${map['AdmissionRemarks']}',`GuardianName`='${map['GuardianName']}',`GuardianMobileNo`='${map['GuardianMobileNo']}',
              `GuardianNIC`='${map['GuardianNIC']}',`GuardianProfession`='${map['GuardianProfession']}',`GuardianRelatiion`='${map['GuardianRelatiion']}',
              `LeavingDate`='${map['LeavingDate']}',`LeavingRemarks`='${map['LeavingRemarks']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	StudentID='${map['StudentID']}'
              ''');
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.update(
                "Sch9StudentsInfo", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
        }
      } else {
        print("No record in year for update");
      }
    } catch (e) {
      print('ex in update $e');
    }
    await db.close();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    return sch9StudentsInfoMaxDate;
  }

  ///   insert date to server Sch1Branches //////////////////////////////////
  sch1BranchesInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch1Branches');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Sch1Branches where UpdatedDate='' AND BranchID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {



          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(BranchID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Sch1Branches 
                where ClientID='$clientID'
              ''';

          Results results =
          await Provider
              .of<MySqlProvider>(context, listen: false)
              .conn!
              .query(maxQuery);
          var maxID = results
              .toSet()
              .elementAt(0)
              .fields["MaxId"];
          String serverDateTime =
          results
              .toSet()
              .elementAt(0)
              .fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';
          String query = '''
            INSERT INTO `Sch1Branches`(`BranchID`, `BranchName`,
             `Address`, `ContactNo`, `LongLat`,
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`) VALUES
                ('$maxID','${map['BranchName']}',
                '${map['Address']}','${map['ContactNo']}','${map['LongLat']}',
                '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';

          results = await Provider
              .of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Sch1Branches SET BranchID = ?,UpdatedDate=? where ID=? ',
                [maxID, serverDateTime, map['ID']]);

            await db.update("Sch2Year", {"BranchID": '$maxID'},
                where:
                "BranchID='${map['BranchID']
                    .toString()}' AND ClientID='${clientID.toString()}'");
          } else {
            print("NO  Data is updated to server");
          }



        }
      } else {
        print("No record is available for inserting ");
      }
    } catch (e, stktrace) {
      print('error $e');
      print(stktrace);
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  ///   insert date to server Sch2Year //////////////////////////////////
  sch2YearInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'EducationalYearID');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Sch2Year where UpdatedDate='' AND EducationalYearID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(EducationalYearID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Sch2Year 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var userRightsID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';
          String query = '''
            INSERT INTO `Sch2Year`(`EducationalYearID`,`BranchID`,
             `EducationalYear`,`ClientID`,`ClientUserID`,`NetCode`,`SysCode`,`UpdatedDate`) VALUES
                ('$userRightsID','${map['BranchID']}',
                '${map['EducationalYear']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Sch2Year SET EducationalYearID = ?,UpdatedDate=? where ID=? ',
                [userRightsID, serverDateTime, map['ID']]);

            await db.update(
                "Sch3Classes", {"EducationalYearID": '$userRightsID'},
                where:
                    "EducationalYearID='${map['EducationalYearID'].toString()}' AND ClientID='${clientID.toString()}'");
          } else {
            print("NO  Data is updated to server");
          }
        }
      } else {
        print("No record is available for inserting ");
      }
    } catch (e, stktrace) {
      print('error $e');
      print(stktrace);
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  ///   insert date to server Sch3Classes //////////////////////////////////
  sch3ClassesInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch3Classes');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Sch3Classes where UpdatedDate='' AND ClassID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(ClassID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Sch3Classes 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var userRightsID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';

          print('.........mpa.........$map');
          String query = '''
            INSERT INTO `Sch3Classes` (`ClassID`,`EducationalYearID`,
             `ClassName`,`ClientID`,`ClientUserID`,`NetCode`,`SysCode`,`UpdatedDate`) VALUES
                ('$userRightsID','${map['EducationalYearID']}',
                '${map['ClassName']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Sch3Classes SET ClassID = ?,UpdatedDate=? where ID=? ',
                [userRightsID, serverDateTime, map['ID']]);

            await db.update("Sch4ClassesSection", {"ClassID": '$userRightsID'},
                where:
                    "ClassID='${map['ClassID'].toString()}' AND ClientID='${clientID.toString()}'");
          } else {
            print("NO  Data is updated to server");
          }
        }
      } else {
        print("No record is available for inserting ");
      }
    } catch (e, stktrace) {
      print('error $e');
      print(stktrace);
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  ///   insert date to server Sch4ClassesSection //////////////////////////////////
  sch4ClassesSectionInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch4ClassesSection');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Sch4ClassesSection where UpdatedDate='' AND SectionID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(SectionID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Sch4ClassesSection 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var maxID = results.toSet().elementAt(0).fields["MaxId"];

          print('......................$maxID......................');
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';

          print('.........mpa.........$map');
          String query = '''
            INSERT INTO `Sch4ClassesSection` (`SectionID`,`ClassID`,
             `SectionName`,`ClientID`,`ClientUserID`,`NetCode`,`SysCode`,`UpdatedDate`) VALUES
                ('$maxID','${map['ClassID']}',
                '${map['SectionName']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Sch4ClassesSection SET SectionID =?,UpdatedDate=? where ID=? ',
                [maxID, serverDateTime, map['ID']]);

            await db.update("Sch5SectionStudent", {"SectionID": '$maxID'},
                where:
                    "SectionID='${map['SectionID'].toString()}' AND ClientID='${clientID.toString()}'");
          } else {
            print("NO  Data is updated to server");
          }
        }
      } else {
        print("No record is available for inserting ");
      }
    } catch (e, stktrace) {
      print('error $e');
      print(stktrace);
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  ///   insert date to server Sch5SectionStudent //////////////////////////////////
  sch5SectionStudentInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch5SectionStudent');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    print('............insert');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Sch5SectionStudent where UpdatedDate='' AND SectionStudenID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);

          String maxQuery = '''
                select (IfNull(Max(Abs(SectionStudenID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Sch5SectionStudent 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);

          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';

          print('........wefefefsdfes.mpa.........$map');
          String query = '''
            INSERT INTO `Sch5SectionStudent` (`SectionStudenID`,`SectionID`,
             `GRN`,`MonthlyFee`,`OtherFee`,`ClientID`,`ClientUserID`,`NetCode`,`SysCode`,`UpdatedDate`) VALUES
                ('$maxID','${map['SectionID']}',
                '${map['GRN']}','${map['MonthlyFee']}','${map['OtherFee']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            renameImagesToLocal(
                localID: map['SectionStudenID'].toString(),
                severID: maxID.toString());

            await db.rawUpdate(
                'UPDATE Sch5SectionStudent SET SectionStudenID = ?,UpdatedDate=? where ID=? ',
                [maxID, serverDateTime, map['ID']]);

            await db.update("Sch6StudentFeeDue", {"SectionStudentID": '$maxID'},
                where:
                    "SectionStudentID='${map['SectionStudenID'].toString()}' AND ClientID='${clientID.toString()}'");
          } else {
            print("NO  Data is updated to server");
          }
        }
      } else {
        print("No record is available for inserting ");
      }
    } catch (e, stktrace) {
      print('error $e');
      print(stktrace);
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  ///   insert date to server Sch6StudentFeeDue //////////////////////////////////
  sch6StudentFeeDueInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch6StudentFeeDue');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Sch6StudentFeeDue where UpdatedDate='' AND FeeDueID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(FeeDueID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Sch6StudentFeeDue 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var maxId = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';

          print('.........mpa.........$map');
          String query = '''
            INSERT INTO `Sch6StudentFeeDue` (`FeeDueID`,`SectionStudentID`,
             `GRN`,`DueDate`,`FeeNarration`,`FeeDueAmount`,`ClientID`,`ClientUserID`,`NetCode`,`SysCode`,`UpdatedDate`) VALUES
                ('$maxId','${map['SectionStudentID']}',
                '${map['GRN']}','${map['DueDate']}','${map['FeeNarration']}','${map['FeeDueAmount']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Sch6StudentFeeDue SET FeeDueID = ?,UpdatedDate=? where ID=? ',
                [maxId, serverDateTime, map['ID']]);

            await db.update("Sch7FeeRec2", {"FeeDueID": '$maxId'},
                where:
                    "FeeDueID='${map['FeeDueID'].toString()}' AND ClientID='${clientID.toString()}'");
          } else {
            print("NO  Data is updated to server");
          }
        }
      } else {
        print("No record is available for inserting ");
      }
    } catch (e, stktrace) {
      print('error $e');
      print(stktrace);
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  ///   insert date to server Sch7FeeRec1 //////////////////////////////////
  sch7FeeRec1InsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch7FeeRec1');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    print('............insert');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Sch7FeeRec1 where UpdatedDate='' AND FeeRec1ID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(FeeRec1ID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Sch7FeeRec1 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';

          print('.........mpa.........$map');
          String query = '''
            INSERT INTO `Sch7FeeRec1` (`FeeRec1ID`,`FeeRecDate`,
             `FeeRecRemarks`,`ClientID`,`ClientUserID`,`NetCode`,`SysCode`,`UpdatedDate`) VALUES
                ('$maxID','${map['FeeRecDate']}',
                '${map['FeeRecRemarks']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Sch7FeeRec1 SET FeeRec1ID = ?,UpdatedDate=? where ID=? ',
                [maxID, serverDateTime, map['ID']]);

            await db.update("Sch7FeeRec2", {"FeeRec1ID": '$maxID'},
                where:
                    "FeeRec1ID='${map['FeeRec1ID'].toString()}' AND ClientID='${clientID.toString()}'");
          } else {
            print("NO  Data is updated to server");
          }
        }
      } else {
        print("No record is available for inserting ");
      }
    } catch (e, stktrace) {
      print('error $e');
      print(stktrace);
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  ///   insert date to server Sch7FeeRec2 //////////////////////////////////
  sch7FeeRec2InsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch7FeeRec2');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    print('............insert');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Sch7FeeRec2 where UpdatedDate='' AND FeeRec2ID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(FeeRec2ID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Sch7FeeRec2 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var userRightsID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';

          print('.........mpa.........$map');
          String query = '''
            INSERT INTO `Sch7FeeRec2` (`FeeRec2ID`,`FeeRec1ID`,
             `FeeDueID`,`RecAmount`,`ClientID`,`ClientUserID`,`NetCode`,`SysCode`,`UpdatedDate`) VALUES
                ('$userRightsID','${map['FeeRec1ID']}',
                '${map['FeeDueID']}','${map['RecAmount']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Sch7FeeRec2 SET FeeRec2ID = ?,UpdatedDate=? where ID=? ',
                [userRightsID, serverDateTime, map['ID']]);
          } else {
            print("NO  Data is updated to server");
          }
        }
      } else {
        print("No record is available for inserting ");
      }
    } catch (e, stktrace) {
      print('error $e');
      print(stktrace);
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  ///   insert date to server Sch9StudentsInfo //////////////////////////////////
  sch9StudentsInfoInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Sch9StudentsInfo');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Sch9StudentsInfo where UpdatedDate='' AND StudentID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());

        for (int i = 0; i < list.length; i++) {
          print('.............row number .....................$i');

          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(StudentID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Sch9StudentsInfo
                where ClientID='$clientID'
              ''';
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var userRightsID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';
          String query = '''
            INSERT INTO `Sch9StudentsInfo` (`StudentID`,`AdmissionDate`,
             `GRN`,`FamilyGroupNo`,`ClientID`,`ClientUserID`,`NetCode`,`SysCode`,
              `UpdatedDate`,`StudentName`,`DateOfBirth`,`StudentMobileNo`,`Address`,`AddressPhoneNo`,
              `FahterName`,`FatherMobileNo`,`FatherNIC`,`FatherProfession`,`MotherName`,`MotherMobileNo`,
              `MotherNIC`,`MotherProfession`,`OtherDetail`,`AdmissionRemarks`,`GuardianName`,`GuardianMobileNo`,
              `GuardianNIC`,`GuardianProfession`,`GuardianRelatiion`,`LeavingDate`,`LeavingRemarks`) VALUES
                ('$userRightsID','${map['AdmissionDate']}',
                '${map['GRN']}','${map['FamilyGroupNo']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime','${map['StudentName']}','${map['DateOfBirth']}','${map['StudentMobileNo']}','${map['Address']}',
                '${map['AddressPhoneNo']}','${map['FahterName']}','${map['FatherMobileNo']}','${map['FatherNIC']}',
                '${map['FatherProfession']}','${map['MotherName']}','${map['MotherMobileNo']}','${map['MotherNIC']}',
                '${map['MotherProfession']}','${map['OtherDetail']}','${map['AdmissionRemarks']}','${map['GuardianName']}',
                '${map['GuardianMobileNo']}','${map['GuardianNIC']}','${map['GuardianProfession']}','${map['GuardianRelatiion']}',
                '${map['LeavingDate']}','${map['LeavingRemarks']}' )
            ''';
          try {
            results = await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            print('..... $results');
            if (results.affectedRows! > 0) {
              await db.rawUpdate(
                  'UPDATE Sch9StudentsInfo SET StudentID =?,UpdatedDate=? where ID=? ',
                  [userRightsID, serverDateTime, map['ID']]);
            } else {
              print("NO  Data is updated to server");
            }
          } catch (e) {
            print(e);
          }
        }
      } else {
        print("No record is available for inserting ");
      }
    } catch (e, stktrace) {
      print('error $e');
      print(stktrace);
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  /// get Data From server   ///////////////////////////
  getTableDataFromServeToInSqlite(
      BuildContext context, String tableName, var maxDate) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: tableName);

    var db = await DatabaseProvider().init();
    try {
      String query = '''
        SELECT * FROM $tableName WHERE ClientID = $clientID AND UpdatedDate > '$maxDate'
        ''';
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
      Set<ResultRow> resultRow = results.toSet();
      Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).totalNumberOfTableRow(totalNumberOfRow: resultRow.length);

      if (resultRow.length > 0) {
        for (int i = 0; i < resultRow.length; i++) {
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).insertingRow();
          await db
              .insert(
            tableName,
            resultRow.elementAt(i).fields,
            conflictAlgorithm: ConflictAlgorithm.replace,
          )
              .catchError((e, stk) {
            print(e);

            print(stk);
            return 0;
          });
        }
      } else {
        print("No data in $tableName");
      }
      db.close();
    } catch (e) {

      print(e.toString());
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }
}
