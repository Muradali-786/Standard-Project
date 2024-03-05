import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../Server/mysql_provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../../widgets/constants.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';
import 'image_processing_tailor.dart';

class RefreshingTailorShop {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);

  getAllUpdatedDataFromServer(
    BuildContext context,
  ) async {
    String refreshingTitle = 'Data is refreshing';

    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Constants.onLoading(context, refreshingTitle);

      // TailorBooking1///////////

      await getTableDataFromServeToInSqliteTailorBooking1(context);
      await TailorBooking1DataToServer(context);
      await TailorBooking1InsertDataToServer(context);


     await  UploadTailorImagesToServer(context);
    }

    await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
    Constants.hideDialog(context);

    print("all data is updated");
  }

  /// get Data From server   TailorBooking1   ///////////////////////////
  getTableDataFromServeToInSqliteTailorBooking1(
    BuildContext context,
  ) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'TailorBooking1');

    var db = await DatabaseProvider().init();
    try {
      String queryForMaxDate = '''
      Select max(UpdatedDate) as MaxDate  FROM TailorBooking1 where ClientID='${clientID.toString()}'
          ''';

      List maxDate = await db.rawQuery(queryForMaxDate);

      var priceListMaxDate = maxDate[0]['MaxDate'];
      priceListMaxDate ??= 0;

      print(priceListMaxDate);

      String query = '''
        SELECT * FROM TailorBooking1 WHERE   ClientID = $clientID AND UpdatedDate > '$priceListMaxDate'
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
            insert into TailorBooking1
           (TailorBooking1ID,CustomerMobileNo,OBRemarks,OrderStatus,DeliveryDate,DeliveredDate,
           CuttingDate,SewingDate,FinishedDat,CuttingAccount3ID,SweingAccount3ID,FinshedAccunt3ID,
           OrderTitle,BillAmount,TotalReceived,BillBalance,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            (
          '${row.fields['TailorBooking1ID']}'  ,  '${row.fields['CustomerMobileNo']}'  , '${row.fields['OBRemarks']}' , '${row.fields['OrderStatus']}','${row.fields['DeliveryDate']}',
          '${row.fields['DeliveredDate']}',
            '${row.fields['CuttingDate']}'  , '${row.fields['SewingDate']}' , '${row.fields['FinishedDat']}',
            '${row.fields['CuttingAccount3ID']}'  , '${row.fields['SweingAccount3ID']}' , '${row.fields['FinshedAccunt3ID']}',
            '${row.fields['OrderTitle']}'  , '${row.fields['BillAmount']}' , '${row.fields['TotalReceived']}','${row.fields['BillBalance']}',
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
                  'UNIQUE constraint failed: TailorBooking1.ClientID, TailorBooking1.TailorBooking1ID')) {
                String query = """
      update TailorBooking1 set  CustomerMobileNo = '${row.fields['CustomerMobileNo']}', OBRemarks = '${row.fields['OBRemarks']}' ,
      OrderStatus = '${row.fields['OrderStatus']}', DeliveryDate = '${row.fields['DeliveryDate']}' ,
      DeliveredDate = '${row.fields['DeliveredDate']}', CuttingDate = '${row.fields['CuttingDate']}' ,
      SewingDate = '${row.fields['SewingDate']}', FinishedDat = '${row.fields['FinishedDat']}' ,
      CuttingAccount3ID = '${row.fields['CuttingAccount3ID']}', SweingAccount3ID = '${row.fields['SweingAccount3ID']}' , FinshedAccunt3ID = '${row.fields['FinshedAccunt3ID']}' ,
      OrderTitle = '${row.fields['OrderTitle']}', BillAmount = '${row.fields['BillAmount']}' , TotalReceived = '${row.fields['TotalReceived']}' ,BillBalance = '${row.fields['BillBalance']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where TailorBooking1ID = '${row.fields['TailorBooking1ID']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              }
            }
          }
        }
      } else {
        print("No data in TailorBooking1");
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

  ///       update date to server TailorBooking1 //////////////////////////////////
  TailorBooking1DataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'TailorBooking1');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db = await DatabaseProvider().init();

    print(' ...........................................         $clientID');
    try {
      String query = '';

      query = '''
      Select * from TailorBooking1 where UpdatedDate='' AND TailorBooking1ID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `TailorBooking1` SET `TailorBooking1ID`='${map['TailorBooking1ID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `CustomerMobileNo`='${map['CustomerMobileNo']}',`OBRemarks`='${map['OBRemarks']}',`OrderStatus`='${map['OrderStatus']}',`DeliveryDate`='${map['DeliveryDate']}',
              `DeliveredDate`='${map['DeliveredDate']}',`CuttingDate`='${map['CuttingDate']}',`SewingDate`='${map['SewingDate']}',
              `FinishedDat`='${map['FinishedDat']}',`CuttingAccount3ID`='${map['CuttingAccount3ID']}',`SweingAccount3ID`='${map['SweingAccount3ID']}',`FinshedAccunt3ID`='${map['FinshedAccunt3ID']}',
              `OrderTitle`='${map['OrderTitle']}',`BillAmount`='${map['BillAmount']}',`TotalReceived`='${map['TotalReceived']}',`BillBalance`='${map['BillBalance']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	TailorBooking1ID= '${map['TailorBooking1ID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "TailorBooking1", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in TailorBooking1 update ......$e.............................');
          }
        }
      } else {
        print("No record in TailorBooking1 for update");
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

  ///   insert date to server TailorBooking1 //////////////////////////////////
  TailorBooking1InsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'TailorBooking1');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from TailorBooking1 where UpdatedDate = '' AND TailorBooking1ID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(TailorBooking1ID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from TailorBooking1 
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
            INSERT INTO `TailorBooking1`(`TailorBooking1ID`, `CustomerMobileNo`,
             `OBRemarks`, `OrderStatus`, `DeliveryDate`,
             `DeliveredDate`, `CuttingDate`, `SewingDate`,FinishedDat,
             `CuttingAccount3ID`, `SweingAccount3ID`, `FinshedAccunt3ID`,
             `OrderTitle`, `BillAmount`, `TotalReceived`,`BillBalance`,
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`) VALUES
                ('$maxID','${map['CustomerMobileNo']}',
                '${map['OBRemarks']}','${map['OrderStatus']}','${map['DeliveryDate']}',
                '${map['DeliveredDate']}','${map['CuttingDate']}','${map['SewingDate']}',
                '${map['FinishedDat']}','${map['CuttingAccount3ID']}','${map['SweingAccount3ID']}','${map['FinshedAccunt3ID']}',
                '${map['OrderTitle']}','${map['BillAmount']}','${map['TotalReceived']}','${map['BillBalance']}',
                '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {

            renameTailorFolderToLocal(
                localID: map['TailorBooking1ID'].toString(),
                severID: maxID.toString()
            );


            await db.rawUpdate(
                'UPDATE TailorBooking1 SET TailorBooking1ID = ?,UpdatedDate=? where ID=? ',
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
}
