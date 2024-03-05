import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../Server/mysql_provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../../widgets/constants.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

class RefreshingBeautySalon {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);

  getAllUpdatedDataFromServer(
    BuildContext context,
  ) async {
    String refreshingTitle = 'Data is refreshing';

    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Constants.onLoading(context, refreshingTitle);

      // BeautySalon1PriceList///////////

      await getTableDataFromServeToInSqlitePriceList(context);
      await updateBeautySalon1PriceListDataToServer(context);
      await BeautySalon1PriceListInsertDataToServer(context);

      // BeautySalon2Beautician///////////

      await getTableDataFromServeToInSqliteBeautySalon2Beautician(context);
      await updateBeautySalon2BeauticianListDataToServer(context);
      await BeautyBeautySalon2BeauticianInsertDataToServer(context);

      // BeautySalon3Bill///////////

      await getTableDataFromServeToInSqliteBeautySalon3Bill(context);
      await updateBeautySalon3BillListDataToServer(context);
      await BeautySalon3BillInsertDataToServer(context);
    }

    await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
    Constants.hideDialog(context);

    print("all data is updated");
  }

  ///       update date to server BeautySalon1PriceList //////////////////////////////////
  updateBeautySalon1PriceListDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'BeautySalon1PriceList');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db = await DatabaseProvider().init();

    print(' ...........................................         $clientID');
    try {
      String query = '';

      query = '''
      Select * from BeautySalon1PriceList where UpdatedDate='' AND PriceID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `BeautySalon1PriceList` SET `PriceID`='${map['PriceID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `ServiceName`='${map['ServiceName']}',`ServiceDescriptions`='${map['ServiceDescriptions']}',`Price`='${map['Price']}',`ServiceDuration`='${map['ServiceDuration']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	PriceID= '${map['PriceID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "BeautySalon1PriceList", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in BeautySalon1PriceList update ......$e.............................');
          }
        }
      } else {
        print("No record in BeautySalon1PriceList for update");
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
  }

  ///   insert date to server BeautySalon1PriceList //////////////////////////////////
  BeautySalon1PriceListInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'BeautySalon1PriceList');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from BeautySalon1PriceList where UpdatedDate = '' AND PriceID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(PriceID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from BeautySalon1PriceList 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];

          String query = '''
            INSERT INTO `BeautySalon1PriceList`(`PriceID`, `ServiceName`,
             `ServiceDescriptions`, `Price`, `ServiceDuration`,
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`) VALUES
                ('$maxID','${map['ServiceName']}',
                '${map['ServiceDescriptions']}','${map['Price']}','${map['ServiceDuration']}',
                '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE BeautySalon1PriceList SET PriceID = ?,UpdatedDate=? where ID=? ',
                [maxID, serverDateTime, map['ID']]);
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

  /// get Data From server   BeautySalon1PriceList   ///////////////////////////
  getTableDataFromServeToInSqlitePriceList(
    BuildContext context,
  ) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'BeautySalon1PriceList');

    var db = await DatabaseProvider().init();
    try {
      String queryForMaxDate = '''
      Select max(UpdatedDate) as MaxDate  FROM BeautySalon1PriceList where ClientID='${clientID.toString()}'
          ''';

      List maxDate = await db.rawQuery(queryForMaxDate);

      var priceListMaxDate = maxDate[0]['MaxDate'];
      priceListMaxDate ??= 0;

      print(priceListMaxDate);

      String query = '''
        SELECT * FROM BeautySalon1PriceList WHERE ClientID = $clientID AND UpdatedDate > '$priceListMaxDate'
        ''';
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
          .totalNumberOfTableRow(totalNumberOfRow: results.length);

      if (results.length > 0) {
        for (var row in results) {
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          print(row.fields);

          try {
            String query = '''
            insert into BeautySalon1PriceList
           (PriceID,ServiceName,ServiceDescriptions,Price,ServiceDuration,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('${row.fields['PriceID']}'  , '${row.fields['ServiceName']}' , '${row.fields['ServiceDescriptions']}','${row.fields['Price']}','${row.fields['ServiceDuration']}',
              '${row.fields['ClientID']}' , '${row.fields['ClientUserID']}' , '${row.fields['UpdatedDate']}', '${row.fields['NetCode']}', '${row.fields['SysCode']}'  ) 
    ''';

            await db.rawInsert(query);
          } catch (e) {
            if (e is DatabaseException && e.isUniqueConstraintError()) {
              print('UNIQUE constraint violation error: ${e.toString()}');

              /////////////////////////////////////////////////////////////////////////////////////
              ////////  Update query according to unique constraint////////////////////////////////
              ////////////////////////////////////////////////////////////////////////////////////////

              if (e.toString().contains(
                  'UNIQUE constraint failed: BeautySalon1PriceList.ClientID, BeautySalon1PriceList.ServiceName')) {
                String query = """
      update BeautySalon1PriceList set  PriceID = '${row.fields['PriceID']}', ServiceDescriptions = '${row.fields['ServiceDescriptions']}' ,
      ServiceDuration = '${row.fields['ServiceDuration']}', Price = '${row.fields['Price']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where ServiceName = '${row.fields['ServiceName']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              } else if (e.toString().contains(
                  'UNIQUE constraint failed: BeautySalon1PriceList.ClientID, BeautySalon1PriceList.PriceID')) {
                String query = """
      update BeautySalon1PriceList set  ServiceName = '${row.fields['ServiceName']}', ServiceDescriptions = '${row.fields['ServiceDescriptions']}' ,
      ServiceDuration = '${row.fields['ServiceDuration']}', Price = '${row.fields['Price']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where PriceID = '${row.fields['PriceID']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              }
            }
          }
        }
      } else {
        print("No data in BeautySalon1PriceList");
      }
      db.close();
    } catch (e) {
      print(e.toString());
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
  }

  ///       update date to server BeautySalon2Beautician //////////////////////////////////
  updateBeautySalon2BeauticianListDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'BeautySalon2Beautician');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db = await DatabaseProvider().init();

    print(' ...........................................         $clientID');
    try {
      String query = '';

      query = '''
      Select * from BeautySalon2Beautician where UpdatedDate='' AND BeauticianID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `BeautySalon2Beautician` SET `BeauticianID`='${map['BeauticianID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `ChairNo`='${map['ChairNo']}',`BeauticianName`='${map['BeauticianName']}',`BeauticianDescription`='${map['BeauticianDescription']}',`MobileNo`='${map['MobileNo']}',
              `Gender`='${map['Gender']}',`Age`='${map['Age']}',`Status`='${map['Status']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	BeauticianID= '${map['BeauticianID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "BeautySalon2Beautician", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");


            }
          } catch (e) {
            print(
                'error in BeautySalon2Beautician update ......$e.............................');
          }
        }
      } else {
        print("No record in BeautySalon2Beautician for update");
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
  }

  ///   insert date to server BeautySalon2Beautician //////////////////////////////////
  BeautyBeautySalon2BeauticianInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'BeautySalon2Beautician');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from BeautySalon2Beautician where UpdatedDate = '' AND BeauticianID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(BeauticianID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from BeautySalon2Beautician 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];

          String query = '''
            INSERT INTO `BeautySalon2Beautician`(`BeauticianID`, `ChairNo`,
             `BeauticianName`, `BeauticianDescription`, `MobileNo`,
             `Gender`, `Age`, `Status`,
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`) VALUES
                ('$maxID','${map['ChairNo']}',
                '${map['BeauticianName']}','${map['BeauticianDescription']}','${map['MobileNo']}',
                '${map['Gender']}','${map['Age']}','${map['Status']}',
                '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE BeautySalon2Beautician SET BeauticianID = ?,UpdatedDate=? where ID=? ',
                [maxID, serverDateTime, map['ID']]);

            await db.rawUpdate(
                'update BeautySalon3Bill set  BeauticianID = $maxID where ClientID = $clientID And  BeauticianID = ${map['BeauticianID']}');

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

  /// get Data From server   BeautySalon2Beautician   ///////////////////////////
  getTableDataFromServeToInSqliteBeautySalon2Beautician(
    BuildContext context,
  ) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'BeautySalon2Beautician');

    var db = await DatabaseProvider().init();
    try {
      String queryForMaxDate = '''
      Select max(UpdatedDate) as MaxDate  FROM BeautySalon2Beautician where ClientID='${clientID.toString()}'
          ''';

      List maxDate = await db.rawQuery(queryForMaxDate);

      var priceListMaxDate = maxDate[0]['MaxDate'];
      priceListMaxDate ??= 0;

      print(priceListMaxDate);

      String query = '''
        SELECT * FROM BeautySalon2Beautician WHERE   ClientID = $clientID AND UpdatedDate > '$priceListMaxDate'
        ''';
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
          .totalNumberOfTableRow(totalNumberOfRow: results.length);

      if (results.length > 0) {
        for (var row in results) {
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          print(row.fields);

          try {
            String query = '''
            insert into BeautySalon2Beautician
           (BeauticianID,ChairNo,BeauticianName,BeauticianDescription,MobileNo,Gender,Age,Status,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            (
            '${row.fields['BeauticianID']}'  , '${row.fields['ChairNo']}' , '${row.fields['BeauticianName']}','${row.fields['BeauticianDescription']}','${row.fields['MobileNo']}',
            '${row.fields['Gender']}'  , '${row.fields['Age']}' , '${row.fields['Status']}',
              '${row.fields['ClientID']}' , '${row.fields['ClientUserID']}' , '${row.fields['UpdatedDate']}', '${row.fields['NetCode']}', '${row.fields['SysCode']}'  ) 
    ''';

            await db.rawInsert(query);
          } catch (e) {
            if (e is DatabaseException && e.isUniqueConstraintError()) {
              print('UNIQUE constraint violation error: ${e.toString()}');

              /////////////////////////////////////////////////////////////////////////////////////
              ////////  Update query according to unique constraint////////////////////////////////
              ////////////////////////////////////////////////////////////////////////////////////////

              if (e.toString().contains(
                  'UNIQUE constraint failed: BeautySalon2Beautician.ClientID, BeautySalon2Beautician.BeauticianName')) {
                String query = """
      update BeautySalon2Beautician set  BeauticianID = '${row.fields['BeauticianID']}', ChairNo = '${row.fields['ChairNo']}' ,
       BeauticianDescription = '${row.fields['BeauticianDescription']}' ,
      MobileNo = '${row.fields['MobileNo']}', Gender = '${row.fields['Gender']}' ,
      Age = '${row.fields['Age']}', Status = '${row.fields['Status']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where BeauticianName = '${row.fields['BeauticianName']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              } else if (e.toString().contains(
                  'UNIQUE constraint failed: BeautySalon2Beautician.ClientID, BeautySalon2Beautician.BeauticianID')) {
                String query = """
      update BeautySalon2Beautician set  BeauticianName = '${row.fields['BeauticianName']}', ChairNo = '${row.fields['ChairNo']}' ,
      BeauticianName = '${row.fields['BeauticianName']}', BeauticianDescription = '${row.fields['BeauticianDescription']}' ,
      MobileNo = '${row.fields['MobileNo']}', Gender = '${row.fields['Gender']}' ,
      Age = '${row.fields['Age']}', Status = '${row.fields['Status']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where BeauticianID = '${row.fields['BeauticianID']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              }
            }
          }
        }
      } else {
        print("No data in BeautySalon2Beautician");
      }
      db.close();
    } catch (e) {
      print(e.toString());
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
  }

  ///       update date to server BeautySalon3Bill //////////////////////////////////
  updateBeautySalon3BillListDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'BeautySalon3Bill');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db = await DatabaseProvider().init();

    print(' ...........................................         $clientID');
    try {
      String query = '';

      query = '''
      Select * from BeautySalon3Bill where UpdatedDate='' AND BillID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `BeautySalon3Bill` SET `BillID`='${map['BillID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `CustomerName`='${map['CustomerName']}',`CustomerMobileNo`='${map['CustomerMobileNo']}',`ServicesDetail`='${map['ServicesDetail']}',`BillAmount`='${map['BillAmount']}',
              `TokenNo`='${map['TokenNo']}',`BillDate`='${map['BillDate']}',`BookingTime`='${map['BookingTime']}',
              `BookForTime`='${map['BookForTime']}',`ServiceStartTime`='${map['ServiceStartTime']}',`ServiceEndTime`='${map['ServiceEndTime']}',`BeauticianID`='${map['BeauticianID']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	BillID= '${map['BillID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "BeautySalon3Bill", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in BeautySalon3Bill update ......$e.............................');
          }
        }
      } else {
        print("No record in BeautySalon3Bill for update");
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
  }

  ///   insert date to server BeautySalon3Bill //////////////////////////////////
  BeautySalon3BillInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'BeautySalon3Bill');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from BeautySalon3Bill where UpdatedDate = '' AND BillID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(BillID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from BeautySalon3Bill 
                where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];

          String query = '''
            INSERT INTO `BeautySalon3Bill`(`BillID`, `CustomerName`,
             `CustomerMobileNo`, `ServicesDetail`, `BillAmount`,
             `TokenNo`, `BillDate`, `BookingTime`,BeauticianID,
             `BookForTime`, `ServiceStartTime`, `ServiceEndTime`,
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`) VALUES
                ('$maxID','${map['CustomerName']}',
                '${map['CustomerMobileNo']}','${map['ServicesDetail']}','${map['BillAmount']}',
                '${map['TokenNo']}','${map['BillDate']}','${map['BookingTime']}',
                '${map['BeauticianID']}','${map['BookForTime']}','${map['ServiceStartTime']}','${map['ServiceEndTime']}',
                '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE BeautySalon3Bill SET BillID = ?,UpdatedDate=? where ID=? ',
                [maxID, serverDateTime, map['ID']]);

            await db.rawUpdate(
                'update CashBook set  TableID = $maxID where ClientID = $clientID And  TableID = ${map['TableID']}');
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

  /// get Data From server   BeautySalon3Bill   ///////////////////////////
  getTableDataFromServeToInSqliteBeautySalon3Bill(
    BuildContext context,
  ) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'BeautySalon3Bill');

    var db = await DatabaseProvider().init();
    try {
      String queryForMaxDate = '''
      Select max(UpdatedDate) as MaxDate  FROM BeautySalon3Bill where ClientID='${clientID.toString()}'
          ''';

      List maxDate = await db.rawQuery(queryForMaxDate);

      var priceListMaxDate = maxDate[0]['MaxDate'];
      priceListMaxDate ??= 0;

      print(priceListMaxDate);

      String query = '''
        SELECT * FROM BeautySalon3Bill WHERE   ClientID = $clientID AND UpdatedDate > '$priceListMaxDate'
        ''';
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
          .totalNumberOfTableRow(totalNumberOfRow: results.length);

      if (results.length > 0) {
        for (var row in results) {
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          print(row.fields);

          try {
            String query = '''
            insert into BeautySalon3Bill
           (BillID,BeauticianID,CustomerName,CustomerMobileNo,ServicesDetail,BillAmount,TokenNo,BillDate,BookingTime,BookForTime,ServiceStartTime,ServiceEndTime,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            (
          '${row.fields['BillID']}'  ,  '${row.fields['BeauticianID']}'  , '${row.fields['CustomerName']}' , '${row.fields['CustomerMobileNo']}','${row.fields['ServicesDetail']}','${row.fields['BillAmount']}',
            '${row.fields['TokenNo']}'  , '${row.fields['BillDate']}' , '${row.fields['BookingTime']}',
            '${row.fields['BookForTime']}'  , '${row.fields['ServiceStartTime']}' , '${row.fields['ServiceEndTime']}',
              '${row.fields['ClientID']}' , '${row.fields['ClientUserID']}' , '${row.fields['UpdatedDate']}', '${row.fields['NetCode']}', '${row.fields['SysCode']}'  ) 
    ''';

            await db.rawInsert(query);
          } catch (e) {
            if (e is DatabaseException && e.isUniqueConstraintError()) {
              print('UNIQUE constraint violation error: ${e.toString()}');

              /////////////////////////////////////////////////////////////////////////////////////
              ////////  Update query according to unique constraint////////////////////////////////
              ////////////////////////////////////////////////////////////////////////////////////////

              if (e.toString().contains(
                  'UNIQUE constraint failed: BeautySalon3Bill.ClientID, BeautySalon3Bill.BillID')) {
                String query = """
      update BeautySalon3Bill set  BeauticianID = '${row.fields['BeauticianID']}', CustomerName = '${row.fields['CustomerName']}' ,
      CustomerMobileNo = '${row.fields['CustomerMobileNo']}', ServicesDetail = '${row.fields['ServicesDetail']}' ,
      BillAmount = '${row.fields['BillAmount']}', TokenNo = '${row.fields['TokenNo']}' ,
      BillDate = '${row.fields['BillDate']}', BookingTime = '${row.fields['BookingTime']}' ,
      BookForTime = '${row.fields['BookForTime']}', ServiceStartTime = '${row.fields['ServiceStartTime']}' , ServiceEndTime = '${row.fields['ServiceEndTime']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where BillID = '${row.fields['BillID']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              }
            }
          }
        }
      } else {
        print("No data in BeautySalon3Bill");
      }
      db.close();
    } catch (e) {
      print(e.toString());
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
  }
}
