import 'package:com/pages/patient_care_system/image_operation_care_system.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../Server/mysql_provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../../widgets/constants.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

class RefreshingPatientCareSystem {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);

  getAllUpdatedDataFromServer(
    BuildContext context,
  ) async {
    String refreshingTitle = 'Data is refreshing';

    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Constants.onLoading(context, refreshingTitle);

      // Clanic1PriceList///////////

      await getTableDataFromServeToInSqliteClanic1PriceList(context);
      await updateClanic1PriceListDataToServer(context);
      await Clanic1PriceListInsertDataToServer(context);

      // // Clanic2Doctor///////////
      //
      await getTableDataFromServeToInSqliteClanic2Doctor(context);
      await updateClanic2DoctorDataToServer(context);
      await Clanic2DoctorInsertDataToServer(context);
      //
      // // Clanic3Case///////////
      //
      await getTableDataFromServeToInSqliteClanic3Case(context);
      await updateClanic3CaseDataToServer(context);
      await Clanic3CaseInsertDataToServer(context);


      ////  image refreshing//////////////////
     await dialogToUploadDoctorImageToServer(context);
      await  UploadCaseImagesToServer(context);
    }

    await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
    Constants.hideDialog(context);

    print("all data is updated");
  }

  /// get Data From server   Clanic1PriceList   ///////////////////////////
  getTableDataFromServeToInSqliteClanic1PriceList(
    BuildContext context,
  ) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Clanic1PriceList');

    var db = await DatabaseProvider().init();
    try {
      String queryForMaxDate = '''
      Select max(UpdatedDate) as MaxDate  FROM Clanic1PriceList where ClientID='${clientID.toString()}'
          ''';

      List maxDate = await db.rawQuery(queryForMaxDate);

      var priceListMaxDate = maxDate[0]['MaxDate'];
      priceListMaxDate ??= 0;

      print(priceListMaxDate);

      String query = '''
        SELECT * FROM Clanic1PriceList WHERE ClientID = $clientID AND UpdatedDate > '$priceListMaxDate'
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
            insert into Clanic1PriceList
           (PriceID,PriceDetail,Prce,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('${row.fields['PriceID']}'  , '${row.fields['PriceDetail']}' , '${row.fields['Prce']}','
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
                  'UNIQUE constraint failed: Clanic1PriceList.ClientID, Clanic1PriceList.PriceDetail')) {
                String query = """
      update Clanic1PriceList set  PriceID = '${row.fields['PriceID']}', Prce = '${row.fields['Prce']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where PriceDetail = '${row.fields['PriceDetail']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              } else if (e.toString().contains(
                  'UNIQUE constraint failed: Clanic1PriceList.ClientID, Clanic1PriceList.PriceID')) {
                String query = """
      update Clanic1PriceList set  PriceDetail = '${row.fields['PriceDetail']}', Prce = '${row.fields['Prce']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where PriceID = '${row.fields['PriceID']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              }
            }
          }
        }
      } else {
        print("No data in Clanic1PriceList");
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

  ///       update date to server Clanic1PriceList //////////////////////////////////
  updateClanic1PriceListDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Clanic1PriceList');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db = await DatabaseProvider().init();

    print(' ...........................................         $clientID');
    try {
      String query = '';

      query = '''
      Select * from Clanic1PriceList where UpdatedDate='' AND PriceID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `Clanic1PriceList` SET `PriceID`='${map['PriceID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `PriceDetail`='${map['PriceDetail']}',`Prce`='${map['Prce']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	PriceID= '${map['PriceID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "Clanic1PriceList", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in Clanic1PriceList update ......$e.............................');
          }
        }
      } else {
        print("No record in Clanic1PriceList for update");
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

  ///   insert date to server Clanic1PriceList //////////////////////////////////
  Clanic1PriceListInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Clanic1PriceList');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Clanic1PriceList where UpdatedDate = '' AND PriceID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(PriceID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Clanic1PriceList 
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
            INSERT INTO `Clanic1PriceList`(`PriceID`, `PriceDetail`,
             `Prce`, 
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`) VALUES
                ('$maxID','${map['PriceDetail']}',
                '${map['Prce']}',
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
                'UPDATE Clanic1PriceList SET PriceID = ?,UpdatedDate=? where ID=? ',
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

  /// get Data From server   Clanic2Doctor   ///////////////////////////
  getTableDataFromServeToInSqliteClanic2Doctor(
    BuildContext context,
  ) async {
    print('..............................  getting   ......................................');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Clanic2Doctor');

    var db = await DatabaseProvider().init();
    try {
      String queryForMaxDate = '''
      Select max(UpdatedDate) as MaxDate  FROM Clanic2Doctor where ClientID='${clientID.toString()}'
          ''';

      List maxDate = await db.rawQuery(queryForMaxDate);

      var priceListMaxDate = maxDate[0]['MaxDate'];
      priceListMaxDate ??= 0;

      print(priceListMaxDate);

      String query = '''
        SELECT * FROM Clanic2Doctor WHERE   ClientID = $clientID AND UpdatedDate > '$priceListMaxDate'
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
            insert into Clanic2Doctor
           (DoctorID,DoctorName,SubTitle,MobileNo,SeatingRoom,CheckupCharges,OtherChargesDetail,Status,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            (
            '${row.fields['DoctorID']}'  , '${row.fields['DoctorName']}' , '${row.fields['SubTitle']}','${row.fields['MobileNo']}','${row.fields['SeatingRoom']}',
            '${row.fields['CheckupCharges']}'  , '${row.fields['OtherChargesDetail']}' , '${row.fields['Status']}',
              '${row.fields['ClientID']}' , '${row.fields['ClientUserID']}' , '${row.fields['UpdatedDate']}', '${row.fields['NetCode']}', '${row.fields['SysCode']}'  ) 
    ''';

            await db.rawInsert(query);
          } catch (e) {
            if (e is DatabaseException && e.isUniqueConstraintError()) {
              print('UNIQUE constraint violation error: ${e.toString()}');

              /////////////////////////////////////////////////////////////////////////////////////
              ////////  Update query according to unique constraint////////////////////////////////
              ////////////////////////////////////////////////////////////////////////////////////////


              print('fhjsdhfkjshfkjshfkjshkj updae................................................');

              if (e.toString().contains(
                  'UNIQUE constraint failed: Clanic2Doctor.ClientID, Clanic2Doctor.DoctorName')) {
                String query = """
      update Clanic2Doctor set  DoctorID = '${row.fields['DoctorID']}'
      SubTitle = '${row.fields['SubTitle']}', MobileNo = '${row.fields['MobileNo']}' ,
      SeatingRoom = '${row.fields['SeatingRoom']}', CheckupCharges = '${row.fields['CheckupCharges']}' ,
      OtherChargesDetail = '${row.fields['OtherChargesDetail']}', Status = '${row.fields['Status']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where DoctorName = '${row.fields['DoctorName']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              } else if (e.toString().contains(
                  'UNIQUE constraint failed: Clanic2Doctor.ClientID, Clanic2Doctor.DoctorID')) {
                String query = """
      update Clanic2Doctor set  DoctorName = '${row.fields['DoctorName']}', SubTitle = '${row.fields['SubTitle']}' ,
      MobileNo = '${row.fields['MobileNo']}', SeatingRoom = '${row.fields['SeatingRoom']}' ,
      CheckupCharges = '${row.fields['CheckupCharges']}', OtherChargesDetail = '${row.fields['OtherChargesDetail']}' ,
       Status = '${row.fields['Status']}' ,
     UpdatedDate = '${row.fields['UpdatedDate']}' where DoctorID = '${row.fields['DoctorID']}' AND ClientID = '${row.fields['ClientID']}'
  """;

                db.rawUpdate(query);
              }
            }
          }
        }
      } else {
        print("No data in Clanic2Doctor");
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

  ///       update date to server Clanic2Doctor //////////////////////////////////
  updateClanic2DoctorDataToServer(BuildContext context) async {

    print('..............................  Updating   ......................................');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Clanic2Doctor');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db = await DatabaseProvider().init();

    print(' ...........................................         $clientID');
    try {
      String query = '';

      query = '''
      Select * from Clanic2Doctor where UpdatedDate='' AND DoctorID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `Clanic2Doctor` SET `DoctorID`='${map['DoctorID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `DoctorName`='${map['DoctorName']}',`SubTitle`='${map['SubTitle']}',`MobileNo`='${map['MobileNo']}',`SeatingRoom`='${map['SeatingRoom']}',
              `CheckupCharges`='${map['CheckupCharges']}',`OtherChargesDetail`='${map['OtherChargesDetail']}',`Status`='${map['Status']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	DoctorID= '${map['DoctorID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "Clanic2Doctor", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in Clanic2Doctor update ......$e.............................');
          }
        }
      } else {
        print("No record in Clanic2Doctor for update");
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

  ///   insert date to server Clanic2Doctor //////////////////////////////////
  Clanic2DoctorInsertDataToServer(BuildContext context) async {

    print('..............................  Inserting   ......................................');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Clanic2Doctor');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Clanic2Doctor where UpdatedDate = '' AND DoctorID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(DoctorID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Clanic2Doctor 
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
            INSERT INTO `Clanic2Doctor`(`DoctorID`, `DoctorName`,
             `SubTitle`, `MobileNo`, `SeatingRoom`,
             `CheckupCharges`, `OtherChargesDetail`, `Status`,
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`) VALUES
                ('$maxID','${map['DoctorName']}',
                '${map['SubTitle']}','${map['MobileNo']}','${map['SeatingRoom']}',
                '${map['CheckupCharges']}','${map['OtherChargesDetail']}','${map['Status']}',
                '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {

            renameDoctorImagesToLocal(
                localID: map['DoctorID'].toString(),
                severID: maxID.toString());

            await db.rawUpdate(
                'UPDATE Clanic2Doctor SET DoctorID = ?,UpdatedDate=? where ID=? ',
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

  /// get Data From server   Clanic3Case   ///////////////////////////
  getTableDataFromServeToInSqliteClanic3Case(
    BuildContext context,
  ) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Clanic3Case');

    var db = await DatabaseProvider().init();
    try {
      String queryForMaxDate = '''
      Select max(UpdatedDate) as MaxDate  FROM Clanic3Case where ClientID='${clientID.toString()}'
          ''';

      List maxDate = await db.rawQuery(queryForMaxDate);

      var priceListMaxDate = maxDate[0]['MaxDate'];
      priceListMaxDate ??= 0;

      print(priceListMaxDate);

      String query = '''
        SELECT * FROM Clanic3Case WHERE   ClientID = $clientID AND UpdatedDate > '$priceListMaxDate'
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
            insert into Clanic3Case
           (CaseID,CaseDate,CaseTime,PatientName,PatientMobileNo,Gender,OldCaseID,CheckupToDoctorID,OtherDetail,BillAmount,TokenNo,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            (
          '${row.fields['CaseID']}'  ,  '${row.fields['CaseDate']}'  , '${row.fields['CaseTime']}' , '${row.fields['PatientName']}','${row.fields['PatientMobileNo']}','${row.fields['Gender']}',
            '${row.fields['OldCaseID']}'  , '${row.fields['CheckupToDoctorID']}' , '${row.fields['OtherDetail']}',
            '${row.fields['BillAmount']}'  , '${row.fields['TokenNo']}' , 
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
                  'UNIQUE constraint failed: Clanic3Case.ClientID, Clanic3Case.CaseID')) {
                String query = """
      update Clanic3Case set  CaseDate = '${row.fields['CaseDate']}', CaseTime = '${row.fields['CaseTime']}' ,
      PatientName = '${row.fields['PatientName']}', PatientMobileNo = '${row.fields['PatientMobileNo']}' ,
      Gender = '${row.fields['Gender']}', OldCaseID = '${row.fields['OldCaseID']}' ,
      CheckupToDoctorID = '${row.fields['CheckupToDoctorID']}', OtherDetail = '${row.fields['OtherDetail']}' ,
      BillAmount = '${row.fields['BillAmount']}', TokenNo = '${row.fields['TokenNo']}' , 
     UpdatedDate = '${row.fields['UpdatedDate']}' where CaseID = '${row.fields['CaseID']}' AND ClientID = '${row.fields['ClientID']}'
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

  ///       update date to server Clanic3Case //////////////////////////////////
  updateClanic3CaseDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Clanic3Case');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db = await DatabaseProvider().init();

    print(' ...........................................         $clientID');
    try {
      String query = '';

      query = '''
      Select * from Clanic3Case where UpdatedDate='' AND CaseID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `Clanic3Case` SET `CaseID`='${map['CaseID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `CaseDate`='${map['CaseDate']}',`CaseTime`='${map['CaseTime']}',`PatientName`='${map['PatientName']}',`PatientMobileNo`='${map['PatientMobileNo']}',
              `Gender`='${map['Gender']}',`OldCaseID`='${map['OldCaseID']}',`CheckupToDoctorID`='${map['CheckupToDoctorID']}',
              `OtherDetail`='${map['OtherDetail']}',`BillAmount`='${map['BillAmount']}',`TokenNo`='${map['TokenNo']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	CaseID= '${map['CaseID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update("Clanic3Case", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in Clanic3Case update ......$e.............................');
          }
        }
      } else {
        print("No record in Clanic3Case for update");
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

  ///   insert date to server Clanic3Case //////////////////////////////////
  Clanic3CaseInsertDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Clanic3Case');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Clanic3Case where UpdatedDate = '' AND CaseID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(CaseID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Clanic3Case 
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
            INSERT INTO `Clanic3Case`(`CaseID`, `CaseDate`,
             `CaseTime`, `PatientName`, `PatientMobileNo`,
             `Gender`, `OldCaseID`, `CheckupToDoctorID`, `OtherDetail`,
             `BillAmount`, `TokenNo`, 
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`) VALUES
                ('$maxID','${map['CaseDate']}',
                '${map['CaseTime']}','${map['PatientName']}','${map['PatientMobileNo']}',
                '${map['Gender']}','${map['OldCaseID']}','${map['CheckupToDoctorID']}',
                '${map['OtherDetail']}','${map['BillAmount']}','${map['TokenNo']}',
                '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime')
            ''';

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {

            renameCaseFolderToLocal(
                localID: map['CaseID'].toString(),
                severID: maxID.toString());

            await db.rawUpdate(
                'UPDATE Clanic3Case SET CaseID = ?,UpdatedDate=? where ID=? ',
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
