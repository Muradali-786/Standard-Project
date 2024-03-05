import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../main/tab_bar_pages/home/themedataclass.dart';
import '../pages/sqlite_data_views/sqlite_database_code_provider.dart';
import '../shared_preferences/shared_preference_keys.dart';
import '../utils/show_inserting_table_row_server.dart';
import '../widgets/constants.dart';
import 'mysql_provider.dart';



class RefreshDataProvider extends ChangeNotifier {
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
  var account4UserRightsMaxDate;
  var account2GroupMaxDate;
  var account3NameMaxDate;
  var item2GroupMaxDate;
  var item3NameMaxDate;
  var salePur1MaxDate;
  var salePur2MaxDate;
  var cashbookMaxDate;
  var settingMaxDate;


  getAllUpdatedDataFromServer(
      BuildContext context, bool isFromCreateClientTable) async {
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
    if (
        await Provider.of<MySqlProvider>(context, listen: false)
            .connectToServerDb()) {
      Constants.onLoading(context, 'Data is refreshing to server');


      /// school refreshing
      /// ...............
      if(Provider.of<ThemeDataHomePage>(context, listen: false)
          .projectName == 'School Management System' ) {

        ///    Account2Group   //////// sc
        await updateAccount2GroupDataToServer(context);
        await insertAccount2GroupDataToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'Account2Group', account2GroupMaxDate);

        ///    Account3Name   //////// sc
        await updateAccount3NameDataToServer(context);
        await account3NameDataInsertToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'Account3Name', account3NameMaxDate);

        ///    CashBook   //////// sc
        await updateCashbookDataToServer(context);
        await cashBookInsertDataToServer(context);
        // await cashBookInsertDataToServerAndDeleteFromSqliteAndChargesEntry(
        //     context);
        await getClientDataFromServerToSqlite(context,
            isFromCreateClient: isFromCreateClientTable);

        await getTableDataFromServeToInSqlite(
            context, 'CashBook', cashbookMaxDate);

        ///    Account4UserRights   //////// sc
        await updateAccount4UserRightsDataToServer(context);
        await account4UserRightsInsertDataToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'Account4UserRights', account4UserRightsMaxDate);

        ///    Setting   ////////
        await updateSettingDataToServer(context);
        await insertSettingDataToServer(context);
        await getTableDataFromServeToInSqlite(context, 'Setting', settingMaxDate);


      } else {

        ///    Account2Group   //////// sc
        await updateAccount2GroupDataToServer(context);
        await insertAccount2GroupDataToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'Account2Group', account2GroupMaxDate);

        ///    Account3Name   //////// sc
        await updateAccount3NameDataToServer(context);
        await account3NameDataInsertToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'Account3Name', account3NameMaxDate);

        ///    CashBook   //////// sc
        await updateCashbookDataToServer(context);
        await cashBookInsertDataToServer(context);
        // await cashBookInsertDataToServerAndDeleteFromSqliteAndChargesEntry(
        //     context);
        await getClientDataFromServerToSqlite(context,
            isFromCreateClient: isFromCreateClientTable);

        await getTableDataFromServeToInSqlite(
            context, 'CashBook', cashbookMaxDate);

        ///    Account4UserRights   //////// sc
        await updateAccount4UserRightsDataToServer(context);
        await account4UserRightsInsertDataToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'Account4UserRights', account4UserRightsMaxDate);



        ///    Item2Group   ////////
        await updateItem2GroupDataToServer(context);
        await item2GroupDataInsertToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'Item2Group', item2GroupMaxDate);


        ///    Item3Name   ////////
        await updateItem3NameDataToServer(context);
        await item3NameDataInsertToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'Item3Name', item3NameMaxDate);


        ///    SalePur1   ////////
        await updateSalePur1DataToServer(context);
        await salePur1DataInsertToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'SalePur1', salePur1MaxDate);


        ///    SalePur2   ////////
        await updateSalePur2DataToServer(context);
        await salePur2DataInsertToServer(context);
        await getTableDataFromServeToInSqlite(
            context, 'SalePur2', salePur2MaxDate);

        ///    Setting   ////////
        await updateSettingDataToServer(context);
        await insertSettingDataToServer(context);
        await getTableDataFromServeToInSqlite(context, 'Setting', settingMaxDate);
      }

      await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
      Constants.hideDialog(context);
      print("all data is updated");
    } else {
      print("unable to connect to server");
    }
  }

  /// ///////////////////////////////////////////////////////////////
  ///                              update    ////////////////////////
  /// //////////////////          //////////////////////////////////

  updateAccount2GroupDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Account2Group');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');

    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Account2Group where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      account2GroupMaxDate = maxDate[0]['MaxDate'];
      account2GroupMaxDate ??= 0;
      query = '''
      Select * from Account2Group where UpdatedDate='' AND AcGroupID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `Account2Group` SET `AcTypeID`='${map['AcTypeID']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['ClientUserID']}',`NetCode`='${map['ClientUserID']}',
              `AcGruopName`='${map['AcTypeID']}',`SerialNo`='${map['AcTypeID']}',
              `UpdatedDate`='$serverDateTime' WHERE ClientID='$clientID'
              AND 	AcGroupID='$map['AcGroupID']'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();
            if (results.affectedRows! > 0) {
              await db.update(
                  "Account2Group", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in Account2Group update ......$e.............................');
          }

        }
      } else {
        print("No record in Account2group for update");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
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

    return account2GroupMaxDate;
  }

  Future<void> updateSettingDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Setting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Setting where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      settingMaxDate = maxDate[0]['MaxDate'];
      settingMaxDate ??= 0;
      query = '''
      Select * from Setting where UpdatedDate='' AND SettingID>0 AND ClientID='${clientID.toString()}'
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

          try{
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `Setting` SET `SettingID`='${map['SettingID']}',
              `layout`='${map['layout']}',
              `columnName`='${map['columnName']}',            
              `visibility`='${map['visibility']}',
              `ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',
              `SysCode`='${map['SysCode']}',
              `NetCode`='${map['NetCode']}',
              `SettingType`='${map['SettingType']}',              
              `UpdatedDate`='$serverDateTime'
               WHERE ClientID='$clientID'
              AND 	SettingID='${map['SettingID']}'
              ''');
          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.update("Setting", {"UpdatedDate": '$serverDateTime'},
                where: "id='${map['id']}'");
          }
          } catch (e) {
            print(
                'error in Setting update ......$e.............................');
          }

        }
      } else {
        print("No record in Setting for update");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();

    await db.close();
  }

  updateAccount3NameDataToServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Account3Name');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Account3Name where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      account3NameMaxDate = maxDate[0]['MaxDate'];
      account3NameMaxDate ??= 0;
      query = '''
      Select * from Account3Name where UpdatedDate='' AND AcNameID>0 AND ClientID='${clientID.toString()}'
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


          map['AcEmailAddress'] ??= '';
          map['AcMobileNo'] ??= '';

          try {
            results = await Provider
                .of<MySqlProvider>(context, listen: false)
                .conn!
                .query('''
              UPDATE `Account3Name` SET `AcName`='${map['AcName']}',`AcGroupID`='${map['AcGroupID']}',
              `AcAddress`='${map['AcAddress']}',`AcMobileNo`=${map['AcMobileNo']
                .length == 0
                ? null
                : '\'${map['AcMobileNo']}\''},`AcContactNo`='${map['AcContactNo']}',
              `AcEmailAddress`=${map['AcEmailAddress'].length == 0
                ? null
                : '\'${map['AcEmailAddress']}\''},`AcDebitBal`=${map['AcDebitBal']},`AcCreditBal`=${map['AcCreditBal']},`AcPassward`=${map['AcPassward']},
              `ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',`SysCode`='${map['SysCode']}',`NetCode`='${map['NetCode']}',
              `UpdatedDate`='$serverDateTime',`SerialNo`=${map['SerialNo']},
              `UserRights`='${map['UserRights']}',`Salary`='${map['Salary']}',`NameOfPerson`='${map['NameOfPerson']}',`Remarks`='${map['Remarks']}' 
              WHERE ClientID='$clientID'
              AND 	AcNameID='${map['AcNameID']}'
              ''');
            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();

            if (results.affectedRows! > 0) {
              await db.update(
                  "Account3Name", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
            } catch (e) {
      print(
          'error in Account3Name update ......$e.............................');
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

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();


    return account3NameMaxDate;
  }

  Future<void> updateItem2GroupDataToServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Item2Group');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Item2Group where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      item2GroupMaxDate = maxDate[0]['MaxDate'];
      item2GroupMaxDate ??= 0;
      query = '''
      Select * from Item2Group where UpdatedDate='' AND Item2GroupID>0 AND ClientID='${clientID.toString()}'
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
          map['AcEmailAddress'] ??= '';
          map['AcMobileNo'] ??= '';

          try{
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `Item2Group` SET `Item1TypeID`='${map['Item1TypeID']}',`Item2GroupName`='${map['Item2GroupName']}',
              `ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',`NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime'
               WHERE ClientID='$clientID'
                AND 	Item2GroupID='${map['Item2GroupID']}'
              ''');

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.update("Item2Group", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
          } catch (e) {
            print(
                'error in Item2Group update ......$e.............................');
          }

        }
      } else {
        print("unable to connect to server");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();

    await db.close();
  }

  Future<void> updateItem3NameDataToServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Item3Name');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Item3Name where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      item3NameMaxDate = maxDate[0]['MaxDate'];
      item3NameMaxDate ??= 0;
      query = '''
      Select * from Item3Name where UpdatedDate='' AND Item3NameID>0 AND ClientID='${clientID.toString()}'
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
          map['ItemCode'] ??= '';

          try {
            results = await Provider
                .of<MySqlProvider>(context, listen: false)
                .conn!
                .query('''
              UPDATE `Item3Name` SET `Item2GroupID`='${map['Item2GroupID']}',
              `ItemName`='${map['ItemName']}',`ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',
              `NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime',`SalePrice`='${map['SalePrice']}',
              `ItemCode`='${map['ItemCode'].length == 0
                ? null
                : '\'${map['ItemCode']}\''}',`Stock`='${map['Stock']}',
              `ItemStatus`='${map['ItemStatus']}' WHERE ClientID='$clientID'
              AND 	Item3NameID='${map['Item3NameID']}'
              ''');

            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();



            if (results.affectedRows! > 0) {
              await db.update("Item3Name", {"UpdatedDate": '$serverDateTime'},
                  where: "ID='${map['ID']}'");
            }
          } catch (e) {
            print(
                'error in Item3Name update ......$e.............................');
          }

        }
      } else {
        print("unable to connect to server");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();

    db.close();
  }

  Future<void> updateSalePur1DataToServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'SalePur1');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM SalePur1 where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      salePur1MaxDate = maxDate[0]['MaxDate'];
      salePur1MaxDate ??= 0;
      query = '''
      Select * from SalePur1 where UpdatedDate='' AND SalePur1ID>0 AND ClientID='${clientID.toString()}'
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
          map['ItemCode'] ??= '';
          try{
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `SalePur1` SET `EntryType`='${map['EntryType']}',`SP1EntryTypeID`='${map['SP1EntryTypeID']}',`SPDate`='${map['SPDate']}',
              `AcNameID`='${map['AcNameID']}',`Remarks`='${map['Remarks']}',`ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',`NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime',`NameOfPerson`='${map['NameOfPerson']}',`PayAfterDay`='${map['PayAfterDay']}',
              `BillAmount`='${map['BillAmount']}',`BillStatus`='${map['BillStatus']}',`ContactNo`='${map['ContactNo']}',
              `EntryTime`='${map['EntryTime']}',`ModifiedTime`='${map['ModifiedTime']}' WHERE 
              ClientID='$clientID'
              AND 	SalePur1ID='${map['SalePur1ID']}'
              ''');


          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();


          if (results.affectedRows! > 0) {
            await db.update("SalePur1", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
            db.close();
          }

          } catch (e) {
            print(
                'error in SalePur1 update ......$e.............................');
          }
        }
      } else {
        print("unable to connect to server");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
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

  Future<void> updateSalePur2DataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'SalePur2');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Updating');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM SalePur2 where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      salePur2MaxDate = maxDate[0]['MaxDate'];
      salePur2MaxDate ??= 0;
      query = '''
      Select * from SalePur2 where UpdatedDate='' AND SalePur2ID>0 AND ClientID='${clientID.toString()}'
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

          try{
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
              UPDATE `SalePur2` SET `Item3NameID`='${map['Item3NameID']}',`ItemDescription`='${map['ItemDescription']}',
              `QtyAdd`='${map['QtyAdd']}',`QtyLess`='${map['QtyLess']}',`Qty`='${map['Qty']}',`Price`='${map['Price']}',
              `Total`='${map['Total']}',`Location`='${map['Location']}',`ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',
              `NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
              `UpdatedDate`='$serverDateTime',`ModifiedTime`='${map['']}' WHERE 
              ClientID='$clientID'
              AND 	SalePur2ID='${map['SalePur2ID']}'
              ''');

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          if (results.affectedRows! > 0) {
            await db.update("SalePur2", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
          } catch (e) {
            print(
                'error in SalePur2 update ......$e.............................');
          }
        }
      } else {
        print("unable to connect to server");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();

    await db.close();
  }

   updateCashbookDataToServer(BuildContext context) async {

     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .setTableName(tableName: 'CashBook');

     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .setStatus(status: 'Updating');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM CashBook where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      cashbookMaxDate = maxDate[0]['MaxDate'];
      cashbookMaxDate ??= 0;
      query = '''
      Select * from CashBook where UpdatedDate='' AND CashBookID>0 AND ClientID='${clientID.toString()}'
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
          try{
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('''
             UPDATE `CashBook` SET `ClientID`='${map['ClientID']}',
             `ClientUserID`='${map['ClientUserID']}',`CBDate`='${map['CBDate']}',`CBTime`='${map['CBTime']}',`DebitAccount`='${map['DebitAccount']}',
             `CreditAccount`='${map['CreditAccount']}',`CBRemarks`='${map['CBRemarks']}',`Amount`='${map['Amount']}',
             `NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',`UpdatedDate`='$serverDateTime',
             `SerialNo`='${map['SerialNo']}',`TableName`='${map['TableName']}',`TableID`='${map['TableID']}',`EntryTime`='${map['EntryTime']}',
             `ModifiedTime`='${map['ModifiedTime']}' WHERE  
              ClientID='$clientID'
              AND 	CashBookID='${map['CashBookID']}'
              ''');

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          if (results.affectedRows! > 0) {
            await db.update("CashBook", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
            db.close();
          }
          } catch (e) {
            print(
                'error in CashBook update ......$e.............................');
          }
        }
      } else {
        print("No Account3Group records for update");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }

     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .resetRow();
     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .resetName();
     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .resetTotalNumber();
     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .resetStats();

     return cashbookMaxDate;
  }

   updateAccount4UserRightsDataToServer(
      BuildContext context) async {

     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .setTableName(tableName: 'Account4UserRights');

     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .setStatus(status: 'Updating');

    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Account4UserRights where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      account4UserRightsMaxDate = maxDate[0]['MaxDate'];
      account4UserRightsMaxDate ??= 0;

      query = '''
      Select * from Account4UserRights where UpdatedDate='' AND UserRightsID>0 AND ClientID='${clientID.toString()}'
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
          try{
          query = '''
            UPDATE `Account4UserRights` SET `UserRightsID`='${map['UserRightsID']}',`Account3ID`='${map['Account3ID']}',
            `MenuName`='${map['MenuName']}',`Inserting`='${map['Inserting']}',`Edting`='${map['Edting']}',`Viwe`='${map['Viwe']}',`Deleting`='${map['Deleting']}',
            `Reporting`='${map['Reporting']}',`ClientID`='${map['ClientID']}',`ClientUserID`='${map['ClientUserID']}',
            `NetCode`='${map['NetCode']}',`SysCode`='${map['SysCode']}',
            `UpdatedDate`='$serverDateTime',`SortBy`='${map['SortBy']}',`GroupSortBy`='${map['GroupSortBy']}' 
            WHERE `UserRightsID`='${map['UserRightsID']}' AND ClientID='${clientID.toString()}' AND `Account3ID`='${map['Account3ID']}'
              ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          if (results.affectedRows! > 0) {
            db.update("Account4UserRights", {"UpdatedDate": '$serverDateTime'},
                where: "ID='${map['ID']}'");
          }
          } catch (e) {
            print(
                'error in Account4UserRights update ......$e.............................');
          }
        }
      } else {
        print("No Account4UserRights records for update");
      }
      db.close();
    } catch (e, stk) {
      print(e);
      print(stk);
    }

     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .resetRow();
     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .resetName();
     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .resetTotalNumber();
     Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
         .resetStats();


     return account4UserRightsMaxDate;
  }

  /// ///////////////////////////////////////////////////////////////
  ///                       insert         ////////////////////////
  /// //////////////////          //////////////////////////////////

  Future<void> account4UserRightsInsertDataToServer(
      BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Account4UserRights');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');

    try {
      var db =  await DatabaseProvider().init();
      String query = '''
        Select * from Account4UserRights where UpdatedDate='' AND UserRightsID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(UserRightsID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerTime from Account4UserRights 
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
          try{
          String query = '''
            INSERT INTO `Account4UserRights`(`UserRightsID`, `Account3ID`,
             `MenuName`, `Inserting`, `Edting`,`Viwe`, `Deleting`, `Reporting`,
              `ClientID`, `ClientUserID`, `NetCode`, `SysCode`,
               `UpdatedDate`, `SortBy`, `GroupSortBy`) VALUES
                ('$userRightsID','${map['Account3ID']}','${map['MenuName']}',
                '${map['Inserting']}','${map['Edting']}','${map['Viwe']}','${map['Deleting']}','${map['Reporting']}',
                '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}',
                '$serverDateTime','${map['SortBy']}','${map['GroupSortBy']}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Account4UserRights SET UserRightsID = ?,UpdatedDate=? where ID=? ',
                [userRightsID, serverDateTime, map['ID']]);
             }
          } catch (e) {
            print(
                'error in Account4UserRights update ......$e.............................');
          }
        }
      } else {
        print("No record is available for inserting in Item2Group");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
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

  Future<void> cashBookInsertDataToServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'CashBook');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');

    try {
      var db =  await DatabaseProvider().init();
      String query = '''
        Select * from CashBook where UpdatedDate='' AND CashBookID < 0 AND ClientID='$clientID'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(CashBookID)),0)+1) as MaxId,  CAST(now(3) as VARCHAR(50)) as ServerTime from CashBook where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var cashBookID = results.toSet().elementAt(0).fields["MaxId"];
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];

          try {
          String query = '''
            INSERT INTO `CashBook`(`CashBookID`, `ClientID`, 
            `ClientUserID`, `CBDate`, `CBTime`, `DebitAccount`,
             `CreditAccount`, `CBRemarks`, `Amount`, `NetCode`, 
             `SysCode`, `UpdatedDate`, `SerialNo`, `TableName`,
              `TableID`, `EntryTime`, `ModifiedTime`) 
            VALUES ('$cashBookID','${map['ClientID']}','${map['ClientUserID']}','${map['CBDate']}',
            '${map['CBTime']}','${map['DebitAccount']}','${map['CreditAccount']}','${map['CBRemarks']}','${map['Amount']}',
            '${map['NetCode']}','${map['SysCode']}','$serverDateTime','${map['SerialNo']}','${map['TableName']}',
            '${map['TableID']}','${map['EntryTime']}','${map['ModifiedTime']}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE CashBook SET CashBookID = ?,UpdatedDate=? where ID=? ',
                [cashBookID, serverDateTime, map['ID']]);
               }

          } catch (e) {
            print(
                'error in CashBook update ......$e.............................');
          }
        }
      } else {
        print("No record is available for inserting in CashBook");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
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
  Future<void> salePur1DataInsertToServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'SalePur1');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
        Select * from SalePur1 where UpdatedDate='' AND SalePur1ID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());

        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);

          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(SalePur1ID)),0)+1) as MaxId, NOW() as ServerTime from SalePur1 where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(SP1EntryTypeID)),0)+1) as EntryTypeMaxId from SalePur1 where ClientID=$clientID AND 	EntryType='${map['EntryType']}'
              ''');
          var sp1EntryTypeMaxId =
              results.toSet().elementAt(0).fields["EntryTypeMaxId"];


          try {
          String query = '''
            INSERT INTO `SalePur1`(`SalePur1ID`, `EntryType`, `SP1EntryTypeID`, `SPDate`, `AcNameID`, `Remarks`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`, `NameOfPerson`, `PayAfterDay`, `BillAmount`, `BillStatus`, `ContactNo`, `EntryTime`, `ModifiedTime`)
             VALUES ('$maxID','${map['EntryType']}','$sp1EntryTypeMaxId','${map['SPDate']}','${map['AcNameID']}','${map['Remarks']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}','${DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime)}',
             '${map['NameOfPerson']}','${map['PayAfterDay']}','${map['BillAmount']}','${map['BillStatus']}','${map['ContactNo']}','${map['EntryTime']}','${map['ModifiedTime']}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE SalePur1 SET SalePur1ID = ?,SP1EntryTypeID=?,UpdatedDate=? where ID=? ',
                [
                  maxID,
                  sp1EntryTypeMaxId,
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                  map['ID']
                ]);
            await db.update("SalePur2", {"SalePur1ID": '$maxID'},
                where:
                    "SalePur1ID='${map['SalePur1ID'].toString()}' AND ClientID='${clientID.toString()}'");

              await db.rawUpdate(
                'UPDATE CashBook SET TableID = ? where TableID=? AND ClientID=?',
                [maxID, map['SalePur1ID'], clientID]);
          }
          } catch (e) {
            print(
                'error in SalePur1 inserting ......$e.............................');
          }
        }
      } else {
        print("No record is available for inserting in Item2Group");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
    await db.close();
  }

  Future<void> salePur2DataInsertToServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'SalePur2');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db =  await DatabaseProvider().init();
      String query = '''
        Select * from SalePur2 where UpdatedDate='' AND SalePur2ID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          String maxQuery = '''
                select (IfNull(Max(Abs(SalePur2ID)),0)+1) as MaxId, NOW() as ServerTime from SalePur2 where ClientID='$clientID'
              ''';

          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(maxQuery);
          var salePur2ID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          maxQuery = '''
                select (IfNull(Max(Abs(SP2EntryTypeID)),0)+1) as SP2EntryTypeID from SalePur2 where ClientID=$clientID AND 	EntryType='${map['EntryType']}'
              ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(maxQuery);
          var sp2EntryTypeMaxId =
              results.toSet().elementAt(0).fields["SP2EntryTypeID"];
          maxQuery = '''
            select (IfNull(Max(Abs(ItemSerial)),0)+1) as ItemSerial from SalePur2 where ClientID=$clientID AND	EntryType='${map['EntryType']}' AND	SalePur1ID='${map['SalePur1ID']}'
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(maxQuery);
          var itemSerial = results.toSet().elementAt(0).fields["ItemSerial"];

          try {
            String query = '''
            INSERT INTO `SalePur2`(`SalePur1ID`, `ItemSerial`, `EntryType`, `SP2EntryTypeID`, `Item3NameID`, `ItemDescription`, `QtyAdd`, `QtyLess`, `Qty`, `Price`, `Total`, `Location`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`, `SalePur2ID`, `EntryTime`, `ModifiedTime`) 
            VALUES ('${map['SalePur1ID']}','$itemSerial','${map['EntryType']}','$sp2EntryTypeMaxId','${map['Item3NameID']}','${map['ItemDescription']}','${map['QtyAdd']}','${map['QtyLess']}','${map['Qty']}','${map['Price']}','${map['Total']}','${map['Location']}',
            '${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}','${DateFormat(
                'yyyy-MM-dd HH:mm:ss').format(
                serverDateTime)}','$salePur2ID','${map['EntryTime']}','${map['ModifiedTime']}')
            ''';
            results = await Provider
                .of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);

            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();

            if (results.affectedRows! > 0) {
              await db.rawUpdate(
                  'UPDATE SalePur2 SET SalePur2ID = ?,SP2EntryTypeID=?,UpdatedDate=?,ItemSerial=? where ID=? ',
                  [
                    salePur2ID,
                    sp2EntryTypeMaxId,
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                    itemSerial,
                    map['ID']
                  ]);
              db.close();
            } } catch (e) {
            print(
                'error in SalePur2 inserting ......$e.............................');
          }
        }
      } else {
        print("No record is available for inserting in Item2Group");
      }
    } catch (e, stktrace) {
      print(e);
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

  Future<void> item3NameDataInsertToServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Item3Name');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
        Select * from Item3Name where UpdatedDate='' AND Item3NameID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);

          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(Item3NameID)),0)+1) as MaxId, NOW() as ServerTime from Item3Name where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];
          map['ItemCode'] = map['ItemCode'] ?? '';
          try {
            String query = '''
            INSERT INTO `Item3Name`(`Item3NameID`, `Item2GroupID`, `ItemName`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`, `SalePrice`, `ItemCode`, `Stock`, `ItemStatus`) 
            VALUES ($maxID,'${map['Item2GroupID']}','${map['ItemName']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}','${DateFormat(
                'yyyy-MM-dd HH:mm:ss').format(
                serverDateTime)}','${map['SalePrice']}',${map['ItemCode']
                .length == 0
                ? null
                : '\'${map['ItemCode']}\''},'${map['Stock']}','${map['ItemStatus']}')
            ''';
            results = await Provider
                .of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);

            Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                .insertingRow();

            if (results.affectedRows! > 0) {
              await db.rawUpdate(
                  'UPDATE Item3Name SET Item3NameID = ?,UpdatedDate=? where ID=? ',
                  [
                    maxID,
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                    map['ID']
                  ]);
              await db.update("SalePur2", {"Item3NameID": '$maxID'},
                  where:
                  "Item3NameID='${map['Item3NameID']
                      .toString()}' AND ClientID='${clientID.toString()}'");
            }
          } catch (e) {
            print(
                'error in Item3Name inserting ......$e.............................');
          }
        }
      } else {
        print("No record is available for inserting in Item3Name");
      }
    } catch (e, stktrace) {
      print(e);
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
    await db.close();
  }

  Future<void> item2GroupDataInsertToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Item2Group');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    try {
      var db =  await DatabaseProvider().init();
      String query = '''
        Select * from Item2Group where UpdatedDate='' AND Item2GroupID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {

        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());

        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);

          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(Item2GroupID)),0)+1) as MaxId, NOW(2) as ServerTime from Item2Group where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          DateTime serverDateTime =
              results.toSet().elementAt(0).fields['ServerTime'];

          try {
          String query = '''
            INSERT INTO `Item2Group`(`Item2GroupID`, `Item1TypeID`, `Item2GroupName`, `ClientID`, `ClientUserID`, `NetCode`, `SysCode`, `UpdatedDate`)
            VALUES ('$maxID','${map['Item1TypeID']}','${map['Item2GroupName']}','${map['ClientID']}','${map['ClientUserID']}','${map['NetCode']}','${map['SysCode']}','${DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime).toString()}')
            ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();
          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Item2Group SET Item2GroupID = ?,UpdatedDate=? where ID=? ',
                [
                  maxID,
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(serverDateTime),
                  map['ID']
                ]);
            await db.update("Item3Name", {"Item2GroupID": '$maxID'},
                where:
                    "Item2GroupID='${map['Item2GroupID'].toString()}' AND ClientID='${clientID.toString()}'");
          }
          } catch (e) {
            print(
                'error in Item2Group inserting ......$e.............................');
          }
        }
      } else {
        print("No record is available for inserting in Item2Group");
      }
    } catch (e, stktrace) {
      print(e);
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

  Future<void> insertAccount2GroupDataToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Account2Group');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
        Select * from Account2Group where UpdatedDate='' AND AcGroupID<0 AND ClientID='${clientID.toString()}'
        ''';
      List<Map<String, dynamic>> list = await db.rawQuery(query);
      //if record>0
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(AcGroupID)),0)+1) as MaxId from Account2Group where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
           results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');


          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          try {
          String query = '''
              INSERT INTO `Account2Group`(`AcGroupID`, `AcTypeID`, `ClientID`, `ClientUserID`, `SysCode`, `NetCode`, `AcGruopName`, `SerialNo`, `UpdatedDate`)
              VALUES ('$maxID','${map['AcTypeID']}','${map['ClientID']}','${map['ClientUserID']}','${map['SysCode']}','${map['NetCode']}','${map['AcGruopName']}','${map['SerialNo']}','$serverDateTime')
              ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          if (results.affectedRows! > 0) {
            db.rawUpdate(
                'UPDATE Account2Group SET AcGroupID = ?,UpdatedDate=? where ID=? ',
                [maxID, serverDateTime, map['ID']]);
            await db.update("Account3Name", {"AcGroupID": '$maxID'},
                where:
                    "AcGroupID='${map['AcGroupID'].toString()}' AND ClientID='${clientID.toString()}'");
          }
          } catch (e) {
            print(
                'error in Account2Group Inserting ......$e.............................');
          }
        }
      } else {
        print("No record in Account2Group For Inserting");
      }
      await db.close();
    } catch (e) {}
  }

  Future<void> insertSettingDataToServer(BuildContext context) async {

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Setting');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
        Select * from Setting where UpdatedDate='' AND SettingID<0 AND ClientID='${clientID.toString()}'
        ''';
      List<Map<String, dynamic>> list = await db.rawQuery(query);
      //if record>0
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(SettingID)),0)+1) as MaxId from Setting where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');

          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          try {
          String query = '''
              INSERT INTO `Setting`(`SettingID`, `layout`,`columnName`,`visibility`, `ClientID`, `ClientUserID`, `SysCode`, `NetCode`, `SettingType`, `UpdatedDate`)
              VALUES ('$maxID','${map['layout']}','${map['columnName']}','${map['visibility']}','${map['ClientID']}','${map['ClientUserID']}','${map['SysCode']}','${map['NetCode']}','${map['SettingType']}','$serverDateTime')
              ''';

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          if (results.affectedRows! > 0) {
            db.rawUpdate(
                'UPDATE Setting SET SettingID = ?,UpdatedDate=? where id=? ',
                [maxID, serverDateTime, map['id']]);
          }
          } catch (e) {
            print(
                'error in Setting Inserting ......$e.............................');
          }
        }
      } else {
        print("No record in Setting For Inserting");
      }
      await db.close();
    } catch (e) {}

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetName();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .resetStats();
  }

  Future<void> account3NameDataInsertToServer(BuildContext context) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: 'Account3Name');

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Inserting');
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
        Select * from Account3Name where UpdatedDate='' AND AcNameID < 0 AND ClientID='${clientID.toString()}'
        ''';
      List list = await db.rawQuery(query);
      if (list.length > 0) {
        Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
            .totalNumberOfTableRow(totalNumberOfRow: list.length.toInt());
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(AcNameID)),0)+1) as MaxId from Account3Name where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];

          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate');

          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];

          if (map['AcMobileNo'] == null) {
            map['AcMobileNo'] = '';
          }
          if (map['AcName'] == null) {
            map['AcName'] = '';
          }
          if (map['AcEmailAddress'] == null) {
            map['AcEmailAddress'] = '';
          }

          try {
          String query = '''
            INSERT INTO `Account3Name`(`AcNameID`, `AcName`, `AcGroupID`, `AcAddress`, `AcMobileNo`, `AcContactNo`, `AcEmailAddress`, `AcDebitBal`, `AcCreditBal`, `AcPassward`, `ClientID`, `ClientUserID`, `SysCode`, `NetCode`, `UpdatedDate`, `SerialNo`, `UserRights`, `Salary`, `NameOfPerson`, `Remarks`) 
            VALUES ('$maxID',${map['AcName'].length == 0 ? null : '\'${map['AcName']}\''},'${map['AcGroupID']}','${map['AcAddress']}',${map['AcMobileNo'].length == 0 ? "NULL" : '\'${map['AcMobileNo']}\''},'${map['AcContactNo']}',${map['AcEmailAddress'].length == 0 ? null : '\'${map['AcEmailAddress']}\''},'${map['AcDebitBal']}','${map['AcCreditBal']}','${map['AcPassward']}','${map['ClientID']}','${map['ClientUserID']}','${map['SysCode']}','${map['NetCode']}','$serverDateTime','${map['SerialNo']}','${map['UserRights']}',${map['Salary']},'${map['NameOfPerson']}','${map['Remarks']}')
              ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query);

          Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
              .insertingRow();

          if (results.affectedRows! > 0) {
            await db.rawUpdate(
                'UPDATE Account3Name SET AcNameID = ?,UpdatedDate=? where ID=? ',
                [maxID, '$serverDateTime', map['ID']]);
            await db.update("CashBook",
                {"CreditAccount": '${map['CreditAccount'].toString()}'},
                where:
                    "CreditAccount='${map['AcNameID'].toString()}' AND ClientID='${clientID.toString()}'");
            await db.update("CashBook",
                {"DebitAccount": '${map['DebitAccount'].toString()}'},
                where:
                    "DebitAccount='${map['AcNameID'].toString()}' AND ClientID='${clientID.toString()}'");
            print(await db.update(
                "SalePur1", {"AcNameID": '${map['AcNameID'].toString()}'},
                where:
                    "AcNameID='${map['AcNameID'].toString()}' AND ClientID='${clientID.toString()}'"));
            await db.update("Account3Name", {"AcGroupID": '$maxID'},
                where:
                    "AcGroupID='${map['AcGroupID'].toString()}' AND ClientID='${clientID.toString()}'");
            await db.update("Account4UserRights", {"Account3ID": '$maxID'},
                where:
                    "ClientID='$clientID' AND Account3ID='${map['AcNameID']}'");
          }
          } catch (e) {
            print(
                'error in Account3Name update ......$e.............................');
          }
        }
      }
    } on Exception catch (e, stktrace) {
      print(e);
      print(stktrace);
    }
    await db.close();
  }





  /// no use ////
  Future<bool> userAuthentication(BuildContext context) async {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      //Step 3
      //country user account activation check
      String query = '''
      SELECT UserRights FROM Account3Name WHERE ClientID ='${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}'  AND AcEmailAddress='${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.email)}' ;
      ''';
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      if (results.length > 0) {
        Set<ResultRow> resultRow = results.toSet();
        for (int i = 0; i < resultRow.length; i++) {
          Map<String, dynamic> map = resultRow.elementAt(i).fields;
          if (map['UserRights'] == 'ACTIVE' || map['UserRights'] == 'Admin') {
            //Step 4
            //client ka admin account activation checking
            query = '''
                SELECT UserRights FROM Account3Name WHERE ClientID ='${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientID2)}' 
                AND 	AcNameID='${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId2)}'
      ''';
            results = await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);
            if (results.length > 0) {
              Set<ResultRow> resultRow = results.toSet();
              for (int i = 0; i < resultRow.length; i++) {
                Map<String, dynamic> map = resultRow.elementAt(i).fields;
                print(map);
                if (map['UserRights'] == 'ACTIVE' ||
                    map['UserRights'] == 'Admin') {
                  //Step 5
                  //client ka user account activation check
                  query = '''
                          SELECT UserRights FROM Account3Name WHERE ClientID ='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}'  AND AcNameID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}' ;
                          ''';
                  Results results =
                  await Provider.of<MySqlProvider>(context, listen: false)
                      .conn!
                      .query(query);
                  if (results.length > 0) {
                    Set<ResultRow> resultRow = results.toSet();
                    for (int i = 0; i < resultRow.length; i++) {
                      Map<String, dynamic> map = resultRow.elementAt(i).fields;
                      switch (map['UserRights']) {
                        case 'Admin':
                          return true;
                        case 'Custom Right':
                          return true;
                        case 'Not Allow Login':
                          await removeClientData();
                          break;
                        case 'Statement View Only':
                          return false;
                        case 'ACTIVE':
                          return false;
                      }
                    }
                  } else {
                    return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Message"),
                            content: Text(
                                'No Data in query Client  user activation \n Step 5'),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              )
                            ],
                          );
                        });
                  }
                } else {
                  return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Message"),
                          content: Text('Owner Admin Activation Failed'),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            )
                          ],
                        );
                      });
                }
              }
            } else {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Message"),
                    content: Text(
                        'No Data in query client admin account activation check \n Step 4'),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      )
                    ],
                  );
                },
              );
            }
          } else {
            //Country user activation checking
            return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Message"),
                    content: Text(map['UserRights']),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          SharedPreferencesKeys.prefs!.clear();
                          Navigator.pop(context, false);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login_selection_page',
                                  (Route<dynamic> route) => false);
                        },
                      )
                    ],
                  );
                });
          }
        }
      } else {
        return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Message"),
                content:
                Text('No Data in query country user activation \n Step 3'),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  )
                ],
              );
            });
      }
      await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
    } else {
      print("unable to connect to server");
    }
    return false;
  }

  getClientDataFromServerToSqlite(BuildContext context,
      {bool? isFromCreateClient}) async {
    String tableName = 'Client';
    var db =  await DatabaseProvider().init();
    try {
      //////////////////////////
      //max date pick from give table
      ///////////////////////////

      //getting the last updated date from table because we can get data from server greater than this date
      // Account3Name.AcEmailAddress,
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM $tableName
          ''';
      List maxDate = await db.rawQuery(query);
      query = '''
      Select
    Account3Name.AcNameID As ClientUserID,
    Account3Name.AcName As UserName,
    
    Account3Name.UserRights,
    Client.Email,
    Client.UpdatedDate,
    Client.ClientParentID,
    Client.EntryType,
    Client.LoginMobileNo,
    Client.CompanyName,
    Client.CompanyAddress,
    Client.CompanyNumber,
    Client.NameOfPerson,
    Client.WebSite,
    Client.Password,
    Client.ActiveClient,
    Client.Country,
    Client.City,
    Client.SubCity,
    Client.CapacityOfPersons,
    Client.ClientID,
    Client.SysCode,
    Client.NetCode,
    Client.Lat,
    Client.Lng,
    Client.BookingTermsAndCondition,
    Client.CountryUserID,
    Client.ProjectID,
    Client.BusinessDescriptions,
    Client.FinancialYear,
    Client.CountryClientID,
    `Theme`, `Background` 
From
    Client Left Join
    Account3Name On Client.ClientID = Account3Name.ClientID
 Where
  Account3Name.AcEmailAddress ='${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.email)}'
 and(Account3Name.UserRights = 'Admin' or Account3Name.UserRights = 'Custom Right'
 or Account3Name.UserRights = 'Statement View Only')
 AND
      Client.UpdatedDate > '${maxDate[0]['MaxDate'] == null ? 0 : maxDate[0]['MaxDate']}'  
        ''';

      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      ///****************
      ///user rights not allowed login ayein tauh server se client ko delete karna hain
      Set<ResultRow> resultRow = results.toSet();
      for (int i = 0; i < resultRow.length; i++) {
        if (isFromCreateClient != null && isFromCreateClient == true) {
        }

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
      await db.close();
    } catch (e, stktrace) {
      print(e.toString());
      print(stktrace);
    }
  }


  /// get Data From server      ///////////////////////////
  getTableDataFromServeToInSqlite(
      BuildContext context, String tableName, var maxDate) async {
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setStatus(status: 'Getting');
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
        .setTableName(tableName: tableName);

    var db =  await DatabaseProvider().init();
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
          });
        }
      } else {
        print("No data in $tableName");
      }
      db.close();

      // Map map = jsonDecode(response.body);
      // List list = map["Account2Group"];
      // for (Map<String, dynamic> item in list) {
      //   query = '''
      //   Select AcGroupID from Account2Group where AcGroupID='${item['AcGroupID']}' AND ClientID='${clientID.toString()}'
      //   ''';
      //   List list = await db.rawQuery(query);
      //   if (list.length > 0) {
      //     print(await db.update('Account2Group', item,
      //         where:
      //         "AcGroupID='${item['AcGroupID']}' AND ClientID='${clientID.toString()}'"));
      //   } else {
      //     db.insert('Account2Group', item);
      //   }
      // }
    } catch (e) {
      print(e.toString());
    }

    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetTotalNumber();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetRow();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetStats();
    Provider.of<ShowInsertingTableRowTOServer>(context, listen: false).resetName();
  }




  Future<void> removeClientData() async {
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Delete From Client where ClientID=$clientID;
      Delete From Account2Group where ClientID=$clientID;
      Delete From Account3Name where ClientID=$clientID;
      Delete From Item2Group where ClientID=$clientID;
      Delete From Cashbook where ClientID=$clientID;
      Delete From SalePur1 where ClientID=$clientID;
      Delete From SalePur2 where ClientID=$clientID;
      Delete From SalePurLocation where ClientID=$clientID;
      ''';
      db.rawQuery(query);
      db.close();
      SharedPreferencesKeys.prefs!
        ..setString(SharedPreferencesKeys.countryClientID2, '0')
        ..setString(SharedPreferencesKeys.countryUserId2, '0')
        ..setInt(SharedPreferencesKeys.clinetId, 0)
        ..setInt(SharedPreferencesKeys.clientUserId, 0)
        ..setString(SharedPreferencesKeys.companyName, '')
        ..setString(SharedPreferencesKeys.companyAddress, '')
        ..setString(SharedPreferencesKeys.companyNumber, '')
        ..setString(SharedPreferencesKeys.website, '')
        ..setString(SharedPreferencesKeys.emailClient, '')
        ..setString(SharedPreferencesKeys.nameOfPersonOwner, '')
        ..setString(SharedPreferencesKeys.bussinessDescription, '')
        ..setString(SharedPreferencesKeys.userRightsClient, '')
        ..setString(SharedPreferencesKeys.netcode, '')
        ..setString(SharedPreferencesKeys.sysCode, '')
        ..setInt(SharedPreferencesKeys.projectId, 0);
      //client
      //account2group
      //account3Name
      //item2Group
      //cashbook
      //salePur1
      //SalePur2
      //itemLocation
    } catch (e, stk) {
      print(e);
      print(stk);
    }
  }

  account4UserRightsRefreshing(BuildContext context) async {
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
      await updateAccount4UserRightsDataToServer(context);
      await account4UserRightsInsertDataToServer(context);
      await getTableDataFromServeToInSqlite(
          context, 'Account4UserRights', account4UserRightsMaxDate);
      Provider.of<MySqlProvider>(context, listen: false).conn!.close();
    } else {
      print('unable to connect to server');
    }
  }


  Future<void> updateContactDataToServer(BuildContext context) async {
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM Setting where ClientID='${clientID.toString()}'
          ''';
      List maxDate = await db.rawQuery(query);
      settingMaxDate = maxDate[0]['MaxDate'];
      settingMaxDate ??= 0;
      query = '''
      Select * from Setting where UpdatedDate='' AND SettingID>0 AND ClientID='${clientID.toString()}'
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
              UPDATE `Setting` SET `SettingID`='${map['SettingID']}',
              `layout`='${map['layout']}',
              `columnName`='${map['columnName']}',            
              `visibility`='${map['visibility']}',
              `ClientID`='${map['ClientID']}',
              `ClientUserID`='${map['ClientUserID']}',
              `SysCode`='${map['SysCode']}',
              `NetCode`='${map['NetCode']}',
              `SettingType`='${map['SettingType']}',              
              `UpdatedDate`='$serverDateTime'
               WHERE ClientID='$clientID'
              AND 	SettingID='${map['SettingID']}'
              ''').catchError((e, stk) {
            print(e);
            print(stk);
          });
          if (results.affectedRows! > 0) {
            await db.update("Setting", {"UpdatedDate": '$serverDateTime'},
                where: "id='${map['id']}'");
          }
        }
      } else {
        print("No record in Setting for update");
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
    await db.close();
  }

  Future<void> insertContactDataToServer(BuildContext context) async {
    var db =  await DatabaseProvider().init();
    try {
      String query = '''
        Select * from Contact where UpdatedDate='' AND SettingID<0 AND ClientID='${clientID.toString()}'
        ''';
      List<Map<String, dynamic>> list = await db.rawQuery(query);
      //if record>0
      if (list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> map = Map.from(list[i]);
          Results results = await Provider.of<MySqlProvider>(context,
                  listen: false)
              .conn!
              .query(
                  '''select (IfNull(Max(Abs(SettingID)),0)+1) as MaxId from Setting where ClientID=$clientID
              ''');
          var maxID = results.toSet().elementAt(0).fields["MaxId"];
          //map.update('AcGroupID', (value) => maxID);
          // //print(map.keys.toSet().toList());
          // print("ahmed");
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate')
              .catchError((e, stk) {
            print(e);
            print(stk);
          });
          String serverDateTime =
              results.toSet().elementAt(0).fields['ServerDate'];
          String query = '''
              INSERT INTO `Setting`(`SettingID`, `layout`,`columnName`,`visibility`, `ClientID`, `ClientUserID`, `SysCode`, `NetCode`, `SettingType`, `UpdatedDate`)
              VALUES ('$maxID','${map['layout']}','${map['columnName']}','${map['visibility']}','${map['ClientID']}','${map['ClientUserID']}','${map['SysCode']}','${map['NetCode']}','${map['SettingType']}','$serverDateTime')
              ''';
          results = await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .query(query)
              .catchError((e, stk) {
            print(e);
          });
          if (results.affectedRows! > 0) {
            db.rawUpdate(
                'UPDATE Setting SET SettingID = ?,UpdatedDate=? where id=? ',
                [maxID, serverDateTime, map['id']]);
          }
        }
      } else {
        print("No record in Setting For Inserting");
      }
      await db.close();
    } catch (e) {}
  }
}
