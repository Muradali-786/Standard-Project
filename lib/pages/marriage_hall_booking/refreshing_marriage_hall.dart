import 'package:com/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../Server/mysql_provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';
import 'image_processing_merriage.dart';

class RefreshingMarriageHall {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);

  getAllUpdatedDataFromServer(
    BuildContext context,
  ) async {
    String refreshingTitle = 'Data is refreshing';

    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Constants.onLoading(context, refreshingTitle);

      await getTableDataFromServeToInSqliteMarriageHallBooking(context);
      await updateBeautySalon3BillListDataToServer(context);
      await MarriageHallBookingInsertDataToServer(context);
    }


  await  UploadMarriageImagesToServer(context);



    await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
    Constants.hideDialog(context);

    print("all data is updated");
  }

  /// get Data From server   MarriageHallBooking   ///////////////////////////
  getTableDataFromServeToInSqliteMarriageHallBooking(
    BuildContext context,
  ) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'MarriageHallBooking');

    var db = await DatabaseProvider().init();
    try {
      String queryForMaxDate = '''
      Select max(UpdatedDate) as MaxDate  FROM MarriageHallBooking where ClientID='${clientID.toString()}'
          ''';

      List maxDate = await db.rawQuery(queryForMaxDate);

      var priceListMaxDate = maxDate[0]['MaxDate'];
      priceListMaxDate ??= 0;

      print(priceListMaxDate);

      String query = '''
        SELECT * FROM MarriageHallBooking WHERE  ClientID = $clientID AND UpdatedDate > '$priceListMaxDate'
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
            insert into MarriageHallBooking
           (BookingID,ClientName,ClientMobile,ClientAddress,ClientNIC,EventName,BookingDate,EventDate,PersonsQty,TotalCharges,Description,TotalReceived,Shift,
           BillBalance,ChargesDetail,EventTiming,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            (
          '${row.fields['BookingID']}'  ,  '${row.fields['ClientName']}'  , '${row.fields['ClientMobile']}' , '${row.fields['ClientAddress']}','${row.fields['ClientNIC']}','${row.fields['EventName']}',
            '${row.fields['BookingDate']}'  , '${row.fields['EventDate']}' , '${row.fields['PersonsQty']}',
            '${row.fields['TotalCharges']}'  , '${row.fields['Description']}' , '${row.fields['TotalReceived']}',
            '${row.fields['Shift']}'  , '${row.fields['BillBalance']}' , '${row.fields['ChargesDetail']}','${row.fields['EventTiming']}',
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
                  'UNIQUE constraint failed: MarriageHallBooking.ClientID, MarriageHallBooking.BookingID')) {
                String query = """
      update MarriageHallBooking set  ClientName = '${row.fields['ClientName']}', ClientMobile = '${row.fields['ClientMobile']}' ,
      ClientAddress = '${row.fields['ClientAddress']}', ClientNIC = '${row.fields['ClientNIC']}' ,
      EventName = '${row.fields['EventName']}', BookingDate = '${row.fields['BookingDate']}' ,
      EventDate = '${row.fields['EventDate']}', PersonsQty = '${row.fields['PersonsQty']}' ,
      TotalCharges = '${row.fields['TotalCharges']}', Description = '${row.fields['Description']}' , TotalReceived = '${row.fields['TotalReceived']}' ,
      Shift = '${row.fields['Shift']}', BillBalance = '${row.fields['BillBalance']}' , ChargesDetail = '${row.fields['ChargesDetail']}' , EventTiming = '${row.fields['EventTiming']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where BookingID = '${row.fields['BookingID']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              }
            }
          }
        }
      } else {
        print("No data in MarriageHallBooking");
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

  ///       update date to server MarriageHallBooking //////////////////////////////////
  updateBeautySalon3BillListDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'MarriageHallBooking');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db = await DatabaseProvider().init();

    print(' ...........................................         $clientID');
    try {
      String query = '';

      query = '''
      Select * from MarriageHallBooking where UpdatedDate='' AND BookingID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `MarriageHallBooking` SET `BookingID`='${map['BookingID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `ClientName`='${map['ClientName']}',`ClientMobile`='${map['ClientMobile']}',`ClientAddress`='${map['ClientAddress']}',`ClientNIC`='${map['ClientNIC']}',
              `EventName`='${map['EventName']}',`BookingDate`='${map['BookingDate']}',`EventDate`='${map['EventDate']}',
              `PersonsQty`='${map['PersonsQty']}',`TotalCharges`='${map['TotalCharges']}',`Description`='${map['Description']}',`TotalReceived`='${map['TotalReceived']}',
              `Shift`='${map['Shift']}',`BillBalance`='${map['BillBalance']}',`ChargesDetail`='${map['ChargesDetail']}',`EventTiming`='${map['EventTiming']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	BookingID= '${map['BookingID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "MarriageHallBooking", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in MarriageHallBooking update ......$e.............................');
          }
        }
      } else {
        print("No record in MarriageHallBooking for update");
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

  ///   insert date to server MarriageHallBooking //////////////////////////////////
  MarriageHallBookingInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'MarriageHallBooking');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from MarriageHallBooking where UpdatedDate = '' AND BookingID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(BookingID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from MarriageHallBooking 
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
            INSERT INTO `MarriageHallBooking`(`BookingID`, `ClientName`,
             `ClientMobile`, `ClientAddress`, `ClientNIC`,
             `EventName`, `BookingDate`, `EventDate`,PersonsQty,
             `TotalCharges`, `Description`, `TotalReceived`,
             `Shift`, `BillBalance`, `ChargesDetail`,
             `EventTiming`, 
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`) VALUES
                ('$maxID','${map['ClientName']}',
                '${map['ClientMobile']}','${map['ClientAddress']}','${map['ClientNIC']}',
                '${map['EventName']}','${map['BookingDate']}','${map['EventDate']}',
                '${map['PersonsQty']}','${map['TotalCharges']}','${map['Description']}','${map['TotalReceived']}',
                '${map['Shift']}','${map['BillBalance']}','${map['ChargesDetail']}','${map['EventTiming']}',
                '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {

            renameMarriageFolderToLocal(
                localID: map['BookingID'].toString(),
                severID: maxID.toString()
            );

            await db.rawUpdate(
                'UPDATE MarriageHallBooking SET BookingID = ?,UpdatedDate=? where ID=? ',
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
