import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../Server/mysql_provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../../widgets/constants.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

class RestaurantRefreshing {
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

  var maxRestaurantTableDate;
  var maxTableDate;
  var salePur1MaxDate;
  var salePur2MaxDate;
  var item2GroupMaxDate;
  var item3NameMaxDate;

  getAllUpdatedDataFromServer(
    BuildContext context,
  ) async {
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
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {

      Constants.onLoading(context, 'Resturant refreshing');
      await  item1type(context);
      ///    Restaurant1Portion   //////// sc
      await updateRestaurant1PortionDataToServer(context);
      await insertRestaurant1PortionDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Restaurant1Portion', maxRestaurantTableDate);

      ///    Restaurant2Table   //////// sc
      await updateRestaurant2TableDataToServer(context);
      await insertRestaurant2TableDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Restaurant2Table', maxTableDate);

      ///    SalePur1   ////////
      await updateSalePur1DataToServer(context);
      await salePur1DataInsertToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'RestaurantSalePur1', salePur1MaxDate);

      ///    SalePur2   ////////
      await updateSalePur2DataToServer(context);
      await salePur2DataInsertToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'RestaurantSalePur2', salePur2MaxDate);

      ///    Item2Group   ////////
      await updateItem2GroupDataToServer(context);
      await item2GroupDataInsertToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'RestaurantItem2Group', item2GroupMaxDate);

      ///    Item3Name   ////////
      await updateItem3NameDataToServer(context);
      await item3NameDataInsertToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'RestaurantItem3Name', item3NameMaxDate);

      await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
      Constants.hideDialog(context);
      print("all data is updated");
    } else {
      print("unable to connect to server");
    }
  }

  ///     update and insert   Restaurant1Portion     ...................................

  Future<void> updateRestaurant1PortionDataToServer(
      BuildContext context) async {
    var db = await DatabaseProvider().init();
    print('............   update Restaurant1Portion ................');
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Restaurant1Portion where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      maxRestaurantTableDate = maxDate[0]['MaxDate'];
      maxRestaurantTableDate ??= 0;
      query = '''
      Select * from Restaurant1Portion where UpdatedDate='' AND PortionID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate')
                  .catchError((e, stk) {
            print(
                '....................error in server date ........................................');
            print(e);
            print(stk);
          });
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `Restaurant1Portion` SET `PortionID`='${map['PortionID']}',`PortionName`='${map['PortionName']}',`PortionDescriptions`='${map['PortionDescriptions']}',
              `ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',`NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime'
               WHERE ClientID='$clientID'
                AND 	PortionID='${map['PortionID']}'
              ''').catchError((e, stk) {
            print(
                '....................error in update ........................................');
            print(e);
            print(stk);
          });

          if (results.affectedRows! > 0) {
            await db.update(
                "Restaurant1Portion", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
        }
      } else {
        print(
            "........Restaurant1Portion......................No data to update.....................................");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
    await db.close();
  }

  Future<void> insertRestaurant1PortionDataToServer(
      BuildContext context) async {
    try {
      var db = await DatabaseProvider().init();
      print('............   insert Restaurant1Portion ................');
      String query = '''
        Select * from Restaurant1Portion where UpdatedDate='' AND PortionID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);

      print('list data $query ==== $list');

      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);

          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(PortionID)),0)+1) as MaxId, NOW(2) as ServerTime from Restaurant1Portion where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];

          String query = '''
            INSERT INTO `Restaurant1Portion`(`PortionID`, `PortionName`, `PortionDescriptions`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`)
            VALUES ('$maxID','${map['PortionName']}','${map['PortionDescriptions']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}','${DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime).toString()}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query)
              .catchError((e, stk) {
            print(
                '.......Restaurant1Portion..............error in insert ..................................');
            print(e);
          });
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Restaurant1Portion SET PortionID = ?,UpdatedDate=? where ID=? ',
                [
                  maxID,
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                  map['ID']
                ]);
            await db.update("Restaurant2Table", {"PortionID": '$maxID'},
                where:
                    "PortionID='${map['PortionID'].toString()}' AND ClientID='${clientID.toString()}'");
          } else {}
        }
      } else {
        print("No record is available for inserting in Restaurant2Table");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
  }

  ///   update and insert restaurant 2 table ///////////////////////////////////
  Future<void> updateRestaurant2TableDataToServer(BuildContext context) async {
    var db = await DatabaseProvider().init();
    print('............   update restaurant table ................');
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Restaurant2Table where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      maxTableDate = maxDate[0]['MaxDate'];
      maxTableDate ??= 0;
      query = '''
      Select * from Restaurant2Table where UpdatedDate='' AND TableID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate')
                  .catchError((e, stk) {
            print(e);
            print(stk);
          });
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `Restaurant2Table` SET `TableID`='${map['TableID']}',`PortionID`='${map['PortionID']}',`TableName`='${map['TableName']}',
              `TableDescription`='${map['TableDescription']}',`TableStatus`='${map['TableStatus']}',`SalPur1ID`='${map['SalPur1ID']}',
              `ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',`NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime'
               WHERE ClientID='$clientID'
                AND 	PortionID='${map['PortionID']}'
              ''').catchError((e, stk) {
            print(e);
            print(stk);
          });

          if (results.affectedRows! > 0) {
            await db.update(
                "Restaurant2Table", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
        }
      } else {
        print("no data in local database");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
    await db.close();
  }

  Future<void> insertRestaurant2TableDataToServer(BuildContext context) async {
    print('............   insert restaurant table ................');
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from Restaurant2Table where UpdatedDate='' AND TableID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        print(list);
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(TableID)),0)+1) as MaxId, NOW(2) as ServerTime from Restaurant2Table where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];

          String query = '''
            INSERT INTO `Restaurant2Table`(`TableID`,`PortionID`, `TableName`, `TableDescription`,`TableStatus`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`)
            VALUES ('$maxID','${map['PortionID']}','${map['TableName']}','${map['TableDescription']}','${map['TableStatus']}','${map['ClientID']}','${map['ClientUserID']}',
            '${map['NetCode']}','${map['SysCode']}','${DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime).toString()}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query)
              .catchError((e, stk) {
            print(
                '...................error in insert ...........................');
            print(e);
          });
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Restaurant2Table SET TableID = ?,UpdatedDate=? where ID=? ',
                [
                  maxID,
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                  map['ID']
                ]);
          } else {}
        }
      } else {
        print("No record is available for inserting in Restaurant2Table");
      }
    } catch (e, stktrace) {
      print(e);
      print(stktrace);
    }
  }

  ///   update and insert restaurant sale pur 1 ///////////////////////////////////
  Future<void> updateSalePur1DataToServer(BuildContext context) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM RestaurantSalePur1 where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      salePur1MaxDate = maxDate[0]['MaxDate'];
      salePur1MaxDate ??= 0;
      query = '''
      Select * from RestaurantSalePur1 where UpdatedDate='' AND SalePur1ID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate')
                  .catchError((e, stk) {
            print(e);
            print(stk);
          });
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          map['ItemCode'] ??= '';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `RestaurantSalePur1` SET `EntryType`='${map['EntryType']}',`SP1EntryTypeID`='${map['SP1EntryTypeID']}',`SPDate`='${map['SPDate']}',
              `AcNameID`='${map['AcNameID']}',`Remarks`='${map['Remarks']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime',`NameOfPerson`='${map['NameOfPerson']}',`PayAfterDay`='${map['PayAfterDay']}',
              `BillAmount`='${map['BillAmount']}',`BillStatus`='${map['BillStatus']}',`ContactNo`='${map['ContactNo']}',
              `EntryTime`='${map['EntryTime']}',`ModifiedTime`='${map['ModifiedTime']}' WHERE 
              ClientID='$clientID'
              AND 	SalePur1ID='${map['SalePur1ID']}'
              ''').catchError((e, stk) {
            print(e);
            print(stk);
          });

          print(results.affectedRows!);
          if (results.affectedRows! > 0) {
            await db.update(
                "RestaurantSalePur1", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
            db.close();
          }
        }
      } else {
        print("unable to connect to server");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
  }

  Future<void> salePur1DataInsertToServer(BuildContext context) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
        Select * from RestaurantSalePur1 where UpdatedDate='' AND SalePur1ID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        print(list);
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);

          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(SalePur1ID)),0)+1) as MaxId, NOW() as ServerTime from RestaurantSalePur1 where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(SP1EntryTypeID)),0)+1) as EntryTypeMaxId from RestaurantSalePur1 where ClientID=$clientID AND 	EntryType='${map['EntryType']}'
              ''');
          var sp1EntryTypeMaxId =
              results.toSet().elementAt(0).fields["EntryTypeMaxId"];
          // map['ItemCode']=map['ItemCode'] ??'';
          String query = '''
            INSERT INTO `RestaurantSalePur1`(`SalePur1ID`, `EntryType`, `SP1EntryTypeID`, `SPDate`, `AcNameID`, `Remarks`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`, `NameOfPerson`, `PayAfterDay`, `BillAmount`, `BillStatus`, `ContactNo`, `EntryTime`, `ModifiedTime`)
             VALUES ('$maxID','${map['EntryType']}','$sp1EntryTypeMaxId','${map['SPDate']}','${map['AcNameID']}','${map['Remarks']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}','${DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime)}',
             '${map['NameOfPerson']}','${map['PayAfterDay']}','${map['BillAmount']}','${map['BillStatus']}','${map['ContactNo']}','${map['EntryTime']}','${map['ModifiedTime']}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query)
              .catchError((e, stk) {
            print(e);
          });
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE RestaurantSalePur1 SET SalePur1ID = ?,SP1EntryTypeID=?,UpdatedDate=? where ID=? ',
                [
                  maxID,
                  sp1EntryTypeMaxId,
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                  map['ID']
                ]);
            await db.update("RestaurantSalePur2", {"SalePur1ID": '$maxID'},
                where:
                    "SalePur1ID='${map['SalePur1ID'].toString()}' AND ClientID='${clientID.toString()}'");
            print(map['ID']);
            await db.update("Restaurant2Table", {"SalPur1ID": '$maxID'},
                where:
                    "SalPur1ID='${map['SalePur1ID'].toString()}' AND ClientID='${clientID.toString()}'");
            await db.rawUpdate(
                'UPDATE CashBook SET TableID = ? where TableID=? AND ClientID=?',
                [maxID, map['SalePur1ID'], clientID]);
          } else {}
        }
      } else {
        print("No record is available for inserting in Item2Group");
      }
    } catch (e, stktrace) {
      print(e);
      print(stktrace);
    }
    await db.close();
  }

  ///   update and insert restaurant sale pur 2 ///////////////////////////////////
  Future<void> updateSalePur2DataToServer(BuildContext context) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM RestaurantSalePur2 where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      salePur2MaxDate = maxDate[0]['MaxDate'];
      salePur2MaxDate ??= 0;
      query = '''
      Select * from RestaurantSalePur2 where UpdatedDate='' AND SalePur2ID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate')
                  .catchError((e, stk) {
            print(e);
            print(stk);
          });
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `RestaurantSalePur2` SET `Item3NameID`='${map['Item3NameID']}',`ItemDescription`='${map['ItemDescription']}',
              `QtyAdd`='${map['QtyAdd']}',`QtyLess`='${map['QtyLess']}',`Qty`='${map['Qty']}',`Price`='${map['Price']}',
              `Total`='${map['Total']}',`Location`='${map['Location']}',`ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',
              `NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime',`ModifiedTime`='${map['']}' WHERE 
              ClientID='$clientID'
              AND 	SalePur2ID='${map['SalePur2ID']}'
              ''').catchError((e, stk) {
            print(e);
            print(stk);
          });
          print(results.affectedRows!);
          if (results.affectedRows! > 0) {
            await db.update(
                "RestaurantSalePur2", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
        }
      } else {
        print("unable to connect to server");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
    await db.close();
  }

  Future<void> salePur2DataInsertToServer(BuildContext context) async {
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from RestaurantSalePur2 where UpdatedDate='' AND SalePur2ID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(SalePur2ID)),0)+1) as MaxId, NOW() as ServerTime from RestaurantSalePur2 where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var salePur2ID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          maxQuery = '''
                select (IfNull(Max(Abs(SP2EntryTypeID)),0)+1) as SP2EntryTypeID from RestaurantSalePur2 where ClientID=$clientID AND 	EntryType='${map['EntryType']}'
              ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(maxQuery);
          var sp2EntryTypeMaxId =
              results.toSet().elementAt(0).fields["SP2EntryTypeID"];
          maxQuery = '''
            select (IfNull(Max(Abs(ItemSerial)),0)+1) as ItemSerial from RestaurantSalePur2 where ClientID=$clientID AND	EntryType='${map['EntryType']}' AND	SalePur1ID='${map['SalePur1ID']}'
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(maxQuery);
          var itemSerial = results.toSet().elementAt(0).fields["ItemSerial"];
          String query = '''
            INSERT INTO `RestaurantSalePur2`(`SalePur1ID`, `ItemSerial`, `EntryType`, `SP2EntryTypeID`, `Item3NameID`, `ItemDescription`, `QtyAdd`, `QtyLess`, `Qty`, `Price`, `Total`, `Location`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`, `SalePur2ID`, `EntryTime`, `ModifiedTime`) 
            VALUES ('${map['SalePur1ID']}','$itemSerial','${map['EntryType']}','$sp2EntryTypeMaxId','${map['Item3NameID']}','${map['ItemDescription']}','${map['QtyAdd']}','${map['QtyLess']}','${map['Qty']}','${map['Price']}','${map['Total']}','${map['Location']}',
            '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}','${DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime)}','$salePur2ID','${map['EntryTime']}','${map['ModifiedTime']}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query)
              .catchError((e, stk) {
            print(e);
          });
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE RestaurantSalePur2 SET SalePur2ID = ?,SP2EntryTypeID=?,UpdatedDate=?,ItemSerial=? where ID=? ',
                [
                  salePur2ID,
                  sp2EntryTypeMaxId,
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                  itemSerial,
                  map['ID']
                ]);
          } else {}
        }
      } else {
        print("No record is available for inserting in Item2Group");
      }
    } catch (e, stktrace) {
      print(e);
      print(stktrace);
    }
  }

  ///   update and insert restaurant item 2 group ///////////////////////////////////
  Future<void> updateItem2GroupDataToServer(BuildContext context) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM RestaurantItem2Group where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      item2GroupMaxDate = maxDate[0]['MaxDate'];
      item2GroupMaxDate ??= 0;
      query = '''
      Select * from RestaurantItem2Group where UpdatedDate='' AND Item2GroupID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate')
                  .catchError((e, stk) {
            print(e);
            print(stk);
          });
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          map['AcEmailAddress'] ??= '';
          map['AcMobileNo'] ??= '';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `RestaurantItem2Group` SET `Item1TypeID`='${map['Item1TypeID']}',`Item2GroupName`='${map['Item2GroupName']}',
              `ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',`NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime'
               WHERE ClientID='$clientID'
                AND 	Item2GroupID='${map['Item2GroupID']}'
              ''').catchError((e, stk) {
            print(e);
            print(stk);
          });

          if (results.affectedRows! > 0) {
            await db.update(
                "RestaurantItem2Group", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
        }
      } else {
        print("unable to connect to server");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
    await db.close();
  }

  Future<void> item2GroupDataInsertToServer(BuildContext context) async {
    try {
      var db = await DatabaseProvider().init();
      String query = '''
        Select * from RestaurantItem2Group where UpdatedDate='' AND Item2GroupID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        print(list);
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);

          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(Item2GroupID)),0)+1) as MaxId, NOW(2) as ServerTime from RestaurantItem2Group where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];

          String query = '''
            INSERT INTO `RestaurantItem2Group`(`Item2GroupID`, `Item1TypeID`, `Item2GroupName`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`)
            VALUES ('$maxID','${map['Item1TypeID']}','${map['Item2GroupName']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}','${DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime).toString()}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query)
              .catchError((e, stk) {
            print(e);
          });
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE RestaurantItem2Group SET Item2GroupID = ?,UpdatedDate=? where ID=? ',
                [
                  maxID,
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                  map['ID']
                ]);
            await db.update("RestaurantItem3Name", {"Item2GroupID": '$maxID'},
                where:
                    "Item2GroupID='${map['Item2GroupID'].toString()}' AND ClientID='${clientID.toString()}'");
          } else {}
        }
      } else {
        print("No record is available for inserting in Item2Group");
      }
    } catch (e, stktrace) {
      print(e);
      print(stktrace);
    }
  }

  Future<void> updateItem3NameDataToServer(BuildContext context) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM RestaurantItem3Name where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      item3NameMaxDate = maxDate[0]['MaxDate'];
      item3NameMaxDate ??= 0;
      query = '''
      Select * from RestaurantItem3Name where UpdatedDate='' AND Item3NameID>0 AND ClientID='${clientID.toString()}'
      ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate')
                  .catchError((e, stk) {
            print(e);
            print(stk);
          });
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          map['ItemCode'] ??= '';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `RestaurantItem3Name` SET `Item2GroupID`='${map['Item2GroupID']}',
              `ItemName`='${map['ItemName']}',`ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',
              `NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime',`SalePrice`='${map['SalePrice']}',
              `ItemCode`='${map['ItemCode'].length == 0 ? null : '\'${map['ItemCode']}\''}',`Stock`='${map['Stock']}',
              `ItemStatus`='${map['ItemStatus']}' WHERE ClientID='$clientID'
              AND 	Item3NameID='${map['Item3NameID']}'
              ''').catchError((e, stk) {
            print(e);
            print(stk);
          });

          print(results.affectedRows!);
          if (results.affectedRows! > 0) {
            await db.update(
                "RestaurantItem3Name", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
        }
      } else {
        print("unable to connect to server");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
    db.close();
  }

  Future<void> item3NameDataInsertToServer(BuildContext context) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
        Select * from RestaurantItem3Name where UpdatedDate='' AND Item3NameID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);

          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(Item3NameID)),0)+1) as MaxId, NOW() as ServerTime from RestaurantItem3Name where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';
          String query = '''
            INSERT INTO `RestaurantItem3Name`(`Item3NameID`, `Item2GroupID`, `ItemName`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`, `SalePrice`, `ItemCode`, `Stock`, `ItemStatus`) 
            VALUES ($maxID,'${map['Item2GroupID']}','${map['ItemName']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}','${DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime)}','${map['SalePrice']}',${map['ItemCode'].length == 0 ? null : '\'${map['ItemCode']}\''},'${map['Stock']}','${map['ItemStatus']}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query)
              .catchError((e, stk) {
            print(e);
          });
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE RestaurantItem3Name SET Item3NameID = ?,UpdatedDate=? where ID=? ',
                [
                  maxID,
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                  map['ID']
                ]);
            await db.update("RestaurantSalePur2", {"Item3NameID": '$maxID'},
                where:
                    "Item3NameID='${map['Item3NameID'].toString()}' AND ClientID='${clientID.toString()}'");
          } else {}
        }
      } else {
        print("No record is available for inserting in Item2Group");
      }
    } catch (e, stktrace) {
      print(e);
      print(stktrace);
    }
    await db.close();
  }



  Future<void> item1type(BuildContext context) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
        Select * from RestaurantItem1Type
        ''';
      List list = await db.rawQuery(query);
      if (list.length == 0) {

          Results results = await Provider.of<MySqlProvider>(context,
              listen: false)
              .conn!
              .query(
              '''select * from RestaurantItem1Type''');

          Set<ResultRow> resultRow = results.toSet();
          if (resultRow.length > 0) {
            for (int i = 0; i < resultRow.length; i++) {
              await db
                  .insert(
                'RestaurantItem1Type',
                resultRow.elementAt(i).fields,
                conflictAlgorithm: ConflictAlgorithm.replace,
              )
                  .catchError((e, stk) {
                print(e);
                print(stk);
              });
            }
          } else {
            print("No data in RestaurantItem1Type");
          }

      } else {
        print("data is already inserted");
      }
    } catch (e) {
      print(e);
    }
    await db.close();
  }






  /// get Data From server      ///////////////////////////
  getTableDataFromServeToInSqlite(
      BuildContext context, String tableName, var maxDate) async {
    var db = await DatabaseProvider().init();
    try {
      print(
          '...................inside server to sql..................................');
      //////////////////////////
      //max date pick from give table
      ///////////////////////////
      //getting the last updated date from table because we can get data from server greater than this date
      String query = '''
        SELECT * FROM $tableName WHERE ClientID = $clientID AND UpdatedDate > '$maxDate'
        ''';
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
      Set<ResultRow> resultRow = results.toSet();
      if (resultRow.length > 0) {
        for (int i = 0; i < resultRow.length; i++) {
          await db
              .insert(
            tableName,
            resultRow.elementAt(i).fields,
            conflictAlgorithm: ConflictAlgorithm.replace,
          )
              .catchError((e, stk) {
            print(e);
            print(stk);
          });
        }
      } else {
        print("No data in $tableName");
      }
      db.close();
    } catch (e) {
      print(e.toString());
    }
  }
}
