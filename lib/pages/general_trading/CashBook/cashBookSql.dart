import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../shared_preferences/shared_preference_keys.dart';
import '../../../utils/api_query_for_web.dart';
import '../../sqlite_data_views/sqlite_database_code_provider.dart';

class CashBookSQL {
  DatabaseProvider db = DatabaseProvider();

  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  String countryClientId2 = SharedPreferencesKeys.prefs!
      .getString(SharedPreferencesKeys.countryClientID2)!;
  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);
  String? countClientId2 = SharedPreferencesKeys.prefs!
      .getString(SharedPreferencesKeys.countryClientID2);
  String? countUserId2 = SharedPreferencesKeys.prefs!
      .getString(SharedPreferencesKeys.countryUserId2);


  Future<Database> getDatabase() async {
    return await db.init();
  }

  ///     Main Data For Cash Book /////////////////////////////////////
  Future<List> getDefaultCashBookQueryData() async {


    print('...................list of cash book ......................');

    String query = '';
    List queryResult = [];

    query = "Select FlutterQuery from ProjectMenuSub WHERE SabMenuName = 'All Entries'";

    if(kIsWeb) {
      queryResult = await apiFetchForWeb(query: query);

    }else{

      var db = await getDatabase();

      queryResult = await db.rawQuery(query);

      print('$queryResult');

    }

    String flutterQuery = queryResult[0]['FlutterQuery'];
    flutterQuery = flutterQuery.replaceAll('@ClientID', clientId);
    flutterQuery = flutterQuery.replaceAll('@Date2', date2);
    flutterQuery = flutterQuery.replaceAll('@Date1', date1);


    List list = [];
    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(flutterQuery);
    }else{
      list = await apiFetchForWeb(query: flutterQuery);
    }

    print(list);
    //originalList=list;
    return list;
  }

  /// user rights checking for inserting //////// //////
  Future<bool> userRightsChecking(
      {required String columnName, required String menuName}) async {
    try {
      var db = await DatabaseProvider().init();
      String query = '''
      select * from Account4UserRights where ClientID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}' AND
      Account3ID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}' AND MenuName='$menuName' 
       AND $columnName='true'
       ''';
      print(query);
      List list = await db.rawQuery(query);
      print("user rights checking $columnName");
      print(list);
      if (list.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //////////////////////////////////////////////////////////////
  //////////  CashBook Inserting //////////////////////////////
  ////////////////////////////////////////////////////////////
  Future<int> maxID() async {
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(CashBook.CashBookID)),0)+1) as MaxId from CashBook where ClientID=$clientID
    ''';

    List list = await db.rawQuery(maxId);

    int maxID = list[0]['MaxId'].round();
   // db.close();
    return maxID;
  }

  insertCashBook(
    String cbDate,
    String debitAccount,
    String creditAccount,
    String cbRemarks,
    String amount,
    String tableName,
    String tableID,
    String serialNo,
    String entryTime,
    String modifiedTime,
  ) async {
    var database = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(CashBook.CashBookID)),0)+1) as MaxId from CashBook where ClientID=$clientID
    ''';

    List list = await database.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();

    String query = '''
            insert into CashBook
            (CashBookID,CBDate,DebitAccount,CreditAccount,CBRemarks,Amount,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate,TableName,TableID,SerialNo,EntryTime,ModifiedTime)
            values
            ('$maxID','${cbDate.substring(0, 10)}','$debitAccount','$creditAccount','$cbRemarks','$amount','$clientID','$clientUserID','$netCode','$sysCode','','$tableName','$tableID','0','$entryTime','$modifiedTime')
    ''';

    try {
      database = await DatabaseProvider().init();

      var q = await database.rawInsert(query);
      maxId = '''
    select -(IfNull(Max(Abs(CashBook.CashBookID)),0)+1) as MaxId from CashBook where ClientID=$countClientId2
    ''';
      list = await database.rawQuery(maxId);
    list[0]['MaxId'].round();
      print(q);
    } catch (e) {
      print(e.toString());
    }
  }

  //////////////////////////////////////////////////////////////
  //////////  CashBook update //////////////////////////////
  ////////////////////////////////////////////////////////////

  UpdateCashBook(
    int cashBookId,
    String cbDate,
    String debitAccount,
    String creditAccount,
    String cbRemarks,
    String amount,
    String currentTime,
  ) async {
    var db = await DatabaseProvider().init();
    try {
      var updata_account = await db.rawUpdate(
          "update CashBook set CashBookID=$cashBookId,CBDate='${cbDate.substring(0, 10)}',DebitAccount=$debitAccount,CreditAccount=$creditAccount,CBRemarks='$cbRemarks',Amount=$amount,ClientUserID=$clientUserID,NetCode='$netCode',SysCode='$sysCode',UpdatedDate='',ModifiedTime='$currentTime' where CashBookID=$cashBookId AND ClientID=$clientID");
      String maxIdQuery = '''
    select -(IfNull(Max(Abs(CashBook.CashBookID)),0)+1) as MaxId from CashBook where ClientID=$countClientId2
    ''';
      List list = await db.rawQuery(maxIdQuery);
      var maxID = list[0]['MaxId'].round();
      //////////////////////
      //Edit Charges Query
      /////////////////////

      String query = '''
            insert into CashBook
            (CashBookID,CBDate,DebitAccount,CreditAccount,CBRemarks,Amount,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate,TableName,TableID,SerialNo,EntryTime,ModifiedTime)
            values
            ('$maxID','${cbDate.substring(0, 10)}','$countUserId2','3','CB Edit Charges+$cashBookId','0','$countClientId2',$countUserId2,'$netCode','$sysCode','','CB','0','','$currentTime','')
    ''';
      await db.rawInsert(query);
     // db.close();
      print(updata_account);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //////////////////////////////////////////////////////////////
  ////////// drop down account name//////////////////////////////
  ////////////////////////////////////////////////////////////

  dropDownData() async {
    String query = '';
    List list = [];

    query = "Select Account3Name.AcNameID As ID, Account3Name.AcName As Title, Account2Group.AcGruopName As SubTitle, IfNull(Account3Name.AcDebitBal, 0) + IfNull(Account3Name.AcCreditBal, 0) As Value, Account3Name.ClientID From Account3Name Left Join Account2Group On Account2Group.AcGroupID = Account3Name.AcGroupID And Account2Group.ClientID = Account3Name.ClientID Where Account3Name.ClientID = '$clientID'";

    try {
      if(!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      }else{
        list = await apiFetchForWeb(query: query);
      }

      return list;
    } catch (e) {
      print(e.toString());
    }
  }

  getReceivable(String accountID) async {

    String query = '';
    List list = [];
    query = "Select CashBookID,Amount,CBDate,EntryTime,CBRemarks From CashBook where DebitAccount='$accountID' AND CreditAccount=7 AND ClientID='$clientID'";
    try {
      if(!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      }else{
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
    }
  }

  getPayable(String accountID) async {

    String query = '';
    List list = [];

    query = "Select CashBookID,Amount,CBDate,EntryTime,CBRemarks From CashBook where DebitAccount=8 AND CreditAccount='$accountID' AND ClientID='$clientID'";

    try {
      if(!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      }else{
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
    }
  }

  /// get data for cash book dialog from account ladger////////
  Future<List> getDataForLedgerFromCashBook(int cashBookID) async {

    String query = '';
    List list = [];

     query = "Select CashBook.*, Account3Name.AcName As DebitAccountName, Account3Name1.AcName As CreditAccountName, Account3Name2.AcName As UserName From CashBook Left Join Account3Name On Account3Name.ClientID = CashBook.ClientID And Account3Name.AcNameID = CashBook.DebitAccount Left Join Account3Name Account3Name1 On Account3Name1.ClientID = CashBook.ClientID And Account3Name1.AcNameID = CashBook.CreditAccount Left Join Account3Name Account3Name2 On Account3Name2.ClientID = CashBook.ClientID And Account3Name2.AcNameID = CashBook.ClientUserID Where CashBook.CashBookID = '$cashBookID' And CashBook.ClientID = '$clientId'";


    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }

    return list;
  }
}
