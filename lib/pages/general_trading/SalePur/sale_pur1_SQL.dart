import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import '../../../utils/api_query_for_web.dart';
import '../../sqlite_data_views/sqlite_database_code_provider.dart';

class SalePurSQLDataBase {
  int debitAccount = 0;
  int creditAccount = 0;
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
  String? countryUserId2 = SharedPreferencesKeys.prefs!
      .getString(SharedPreferencesKeys.countryUserId2);
  String? countUserId2 = SharedPreferencesKeys.prefs!
      .getString(SharedPreferencesKeys.countryUserId2);
  String? countClientId2 = SharedPreferencesKeys.prefs!
      .getString(SharedPreferencesKeys.countryClientID2);
  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  String BillStatus = "Active";
  String EntryTime = DateTime.now().toString();
  String ModifiedTime = DateTime.now().toString();

  DatabaseProvider db = DatabaseProvider();

  ////////////////////init database//////////////////////////////////////////////////////////

  Future<Database> getDatabase() async {
    return await db.init();
  }

  /////////////////////////////////update sale pur 1 //////////////////////////////////////////

  UpdateSalePur1({
    int? id,
    int? ACNameID,
    String? remarks,
    String? NameOfPerson,
    String? ContactNo,
    String? PaymentAfterDate,
    String? EntryType,
    String? SPDate,
    BuildContext? context,
  }) async {
    var db = await DatabaseProvider().init();
    try {
      var update_account = await db.rawUpdate('''
          update SalePur1 set SPDate='$SPDate',ACNameID='$ACNameID',Remarks='$remarks',NameOfPerson='$NameOfPerson',ContactNo='$ContactNo',PayAfterDay='$PaymentAfterDate',BillStatus='$BillStatus',ModifiedTime='$ModifiedTime',ClientUserID='$clientUserID',NetCode='$netCode',SysCode='$sysCode',UpdatedDate='' where ID=$id
          ''');
    } catch (e) {
      print(e.toString());
    }
  }

  ///  for edit dialog salePur1...............................

  Future<List> getDataFromSalePur({required int salePur1ID}) async {
    String query = '';
    List list = [];

    query =
        "Select SalePur1.*, Account3Name.AcName As Account Name, Account3Name1.AcName As UserName, SalePur1.SalePur1ID As Entry ID, SalePur1.SPDate As Date, SalePur1.AcNameID As Account ID From SalePur1 Left Join Account3Name On Account3Name.ClientID = SalePur1.ClientID And Account3Name.AcNameID = SalePur1.AcNameID Left Join Account3Name Account3Name1 On Account3Name1.ID = SalePur1.ClientUserID And Account3Name1.ClientID = SalePur1.ClientID Where SalePur1.SalePur1ID = '$salePur1ID' And SalePur1.ClientID = '$clientID'";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

//SalePur1.EntryType = $entryType And
  ///////////////////select from  account3name ////////////////////////////////
  Future<List> dropDownData1() async {
    String query = '';
    List list = [];

    query =
        "Select Account3Name.AcNameID As ID, Account3Name.AcName As Title, Account2Group.AcGruopName As SubTitle, IfNull(Account3Name.AcDebitBal, 0) + IfNull(Account3Name.AcCreditBal, 0) As Value, Account3Name.ClientID From Account3Name Left Join Account2Group On Account2Group.AcGroupID = Account3Name.AcGroupID And Account2Group.ClientID = Account3Name.ClientID";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //////////////////sale pur1 data///////////////////////////////////////////////
  SalePur1Data({required String entryType}) async {
    String query = '';
    List list = [];

    query =
        "SELECT SalePur1.ID, SalePur1.EntryType, SalePur1.SalePur1ID AS 'Entry ID', SalePur1.SPDate AS Date, SalePur1.AcNameID AS 'Account ID', Account3Name.AcName AS 'Account Name', SalePur1.Remarks, SalePur1.NameOfPerson, SalePur1.ContactNo, SalePur1.PayAfterDay, SalePur1.BillAmount, SalePur1.BillStatus, SalePur1.ClientID, SalePur1.ClientUserID AS UserID, SalePur1.NetCode, SalePur1.SysCode, SalePur1.UpdatedDate, Account3Name1.AcName AS UserName, SalePur1.EntryTime, SalePur1.ModifiedTime, SalePur1.SP1EntryTypeID FROM SalePur1 LEFT JOIN Account3Name ON Account3Name.AcNameID = SalePur1.AcNameID AND Account3Name.ClientID = SalePur1.ClientID LEFT JOIN Account3Name Account3Name1 ON Account3Name1.AcNameID = SalePur1.ClientUserID AND Account3Name1.ClientID = SalePur1.ClientID WHERE SalePur1.ClientID = '$clientID' AND SalePur1.EntryType = '$entryType'";

    if (!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    } else {
      list = await apiFetchForWeb(query: query);
    }

    return list;
  }

  //////////////////sale pur1 data///////////////////////////////////////////////
  getSalePur1DataForInvoice(
      {required String salPur1ID, required String entryType}) async {
    String query = '';
    List list = [];

    query =
        "SELECT SalePur1.ID, SalePur1.EntryType, SalePur1.SalePur1ID AS 'Entry ID', SalePur1.SPDate AS Date, SalePur1.AcNameID AS 'Account ID', Account3Name.AcName AS 'Account Name', SalePur1.Remarks, SalePur1.NameOfPerson, SalePur1.ContactNo, SalePur1.PayAfterDay, SalePur1.BillAmount, SalePur1.BillStatus, SalePur1.ClientID, SalePur1.ClientUserID AS UserID, SalePur1.NetCode, SalePur1.SysCode, SalePur1.UpdatedDate, Account3Name1.AcName AS UserName, SalePur1.EntryTime, SalePur1.ModifiedTime, SalePur1.SP1EntryTypeID FROM SalePur1 LEFT JOIN Account3Name ON Account3Name.AcNameID = SalePur1.AcNameID AND Account3Name.ClientID = SalePur1.ClientID LEFT JOIN Account3Name Account3Name1 ON Account3Name1.AcNameID = SalePur1.ClientUserID AND Account3Name1.ClientID = SalePur1.ClientID WHERE SalePur1.ClientID = '$clientID' AND SalePur1.EntryType = '$entryType' AND SalePur1.SalePur1ID = '$salPur1ID'";

    if (!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    } else {
      list = await apiFetchForWeb(query: query);
    }

    return list;
  }

  //////////////////sale pur2 data///////////////////////////////////////////////
  SalePur2Data({required String salePur1Id1, required String entryType}) async {
    String query = '';
    List list = [];

    query =
        "Select SalePur2.ItemSerial, Item3Name.ItemName, Item3Name.Item3NameID, Item3Name.Stock, Item2Group.Item2GroupName, SalePur2.ID, SalePur2.Qty, SalePur2.Price, SalePur2.Total, SalePur2.ClientID, SalePur2.ItemDescription From SalePur2 Left Join Item3Name On Item3Name.Item3NameID = SalePur2.Item3NameID And Item3Name.ClientID = SalePur2.ClientID Left Join Item2Group On Item2Group.Item2GroupID = Item3Name.Item2GroupID And Item2Group.ClientID = Item3Name.ClientID Where SalePur2.SalePur1ID = '$salePur1Id1' And SalePur2.EntryType = '$entryType' And SalePur2.ClientID = '$clientID'";

    if (!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    } else {
      list = await apiFetchForWeb(query: query);
    }

    return list;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////SalePur1UI completed///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

  insertSalePur1(
      String spDate,
      int? acNameid,
      String remarks,
      String nameOfPerson,
      String paymentAfterDay,
      String contactNo,
      Map dropDownMap) async {
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(SalePur1ID)),0)+1) as MaxId from SalePur1"+" where ClientID=$clientID
    ''';

    List list = await db.rawQuery(maxId);
    var salepur1ID = list[0]['MaxId'].round();

    //////////  Sale Pur1 Id    ////////////
    String sp1EntryTypeID = '''
    select -(IfNull(Max(Abs(SP1EntryTypeID)),0)+1) as MaxId from SalePur1"+" where ClientID=$clientID And EntryType = '${dropDownMap['SubTitle']}'
    ''';

    List Sp1EntryTypeIdlist = await db.rawQuery(sp1EntryTypeID);
    var Sp1EntryTypeId = Sp1EntryTypeIdlist[0]['MaxId'].round();

    //////////  CashBook Entry No    ////////////
    String cbmaxId = '''
    select -(IfNull(Max(Abs(CashBook.CashBookID)),0)+1) as MaxId from CashBook where ClientID=$clientID
    ''';
    List list1 = await db.rawQuery(cbmaxId);
    var cbmaxID = list1[0]['MaxId'].round();

    //////////  Bill Entry Charges No   ////////////
    String cbmaxId1 = '''
    select -(IfNull(Max(Abs(CashBook.CashBookID)),0)+1) as MaxId from CashBook where ClientID='$countryClientId2'  
    ''';
    List list2 = await db.rawQuery(cbmaxId1);
    var cbmaxIDBillCharges = list2[0]['MaxId'].round();

    /// if entryType=sl{
    /// debitAccount = dropdownid;
    /// creditAccount = 3;
    /// }
    /// if(entryType = pu){
    /// debitAccount = 5
    /// creditAccount = dropdownid
    /// }
    /// if(entryType = sr){
    /// debitAccount = 4
    /// creditAccount = dropdownid
    /// }
    /// if(entryType = pr){
    /// debitAccount = dropdownid
    /// creditAccount = 6
    switch (dropDownMap['SubTitle']) {
      case 'SL':
        debitAccount = acNameid!;
        creditAccount = 3;
        break;
      case 'PU':
        debitAccount = 5;
        creditAccount = acNameid!;
        break;
      case 'SR':
        debitAccount = 4;
        creditAccount = acNameid!;
        break;
      case 'PR':
        debitAccount = acNameid!;
        creditAccount = 6;
        break;
      default:
        break;
    }

    String query = '''
            insert into SalePur1
            (SalePur1ID,SP1EntryTypeID,EntryType,SPDate,AcNameID,Remarks,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate,
             NameOfperson,PayAfterDay,BillAmount,BillStatus,ContactNo,EntryTime,ModifiedTime
            ) 
            values
            ($salepur1ID,$Sp1EntryTypeId,'${dropDownMap['SubTitle']}','$spDate',$acNameid,'$remarks',$clientID,$clientUserID,'$netCode','$sysCode','',
              '$nameOfPerson','$paymentAfterDay',0,'Active','$contactNo','${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}',''
            ) 
    ''';

    String query1 = '''
            insert into CashBook
            (CashBookID,CBDate,DebitAccount,CreditAccount,CBRemarks,Amount,
            ClientID,ClientUserID,NetCode,SysCode,UpdatedDate,TableName,TableID,
            SerialNo,EntryTime,ModifiedTime)
            values
            ('$cbmaxID','$spDate','$debitAccount',$creditAccount,'${nameOfPerson + ' ' + ' ' + remarks}','0',
            '$clientID',$clientUserID,'$netCode','$sysCode','','${dropDownMap['SubTitle']}',$salepur1ID,
            '0','${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}','0')
    ''';

    //////////  charges entry   ////////////////
    String query2 = '''
            insert into CashBook
            (CashBookID,CBDate,DebitAccount,CreditAccount,CBRemarks,Amount,
            ClientID,ClientUserID,NetCode,SysCode,UpdatedDate,TableName,TableID,
            SerialNo,EntryTime,ModifiedTime)
            values
            ('$cbmaxIDBillCharges','$spDate',$acNameid,3,'${'${dropDownMap['SubTitle']} + Entry Charges ' + salepur1ID.toString()}','0',
            '$countryClientId2','$countryUserId2','$netCode','$sysCode','','${dropDownMap['SubTitle']}',$salepur1ID,
            '0','${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}','0')
    ''';

    try {
      await db.rawInsert(query);
      await db.rawInsert(query1);
      await db.rawInsert(query2);
      db.close();

      return salepur1ID;
    } catch (e) {
      print(e.toString());
    }
  }

  /////////////////drop down data  account2 group////////////////////////////

  ////////////////////sale pur 1 all data////////////////////
  Future<List> getDefaultQueryData({required String menuName}) async {
    String query = '';
    List queryResult = [];

    query =
        "Select FlutterQuery from ProjectMenuSub WHERE SabMenuName='All $menuName'";

    if (!kIsWeb) {
      var db = await getDatabase();
      queryResult = await db.rawQuery(query);
    } else {
      queryResult = await apiFetchForWeb(query: query);
    }

    String flutterQuery = queryResult[0]['FlutterQuery'];
    flutterQuery = flutterQuery.replaceAll('@ClientID', clientID.toString());
    flutterQuery = flutterQuery.replaceAll('@Date2', date2);
    flutterQuery = flutterQuery.replaceAll('@Date1', date1);
    List list = [];

    if (!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(flutterQuery);
    } else {
      list = await apiFetchForWeb(query: flutterQuery);
    }
    return list;
  }

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////DefaultSalePur1 completed///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

  Future<List> userRightsChecking(String menuName) async {
    try {
      String query = '';
      List list = [];
      query =
          "select * from Account4UserRights where ClientID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}' AND Account3ID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}' AND MenuName='$menuName'";

      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }

      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List> receivedAgainstBill(
      {required String entryType, required String entryID}) async {
    String query = '';
    List list = [];

    query =
        "Select CashBook.*, Account3Name.AcName As DebitAccountName, Account3Name1.AcName As CreditAccountName, CashBook.TableName As EntryType, CashBook.TableID As EntryTypeID From CashBook Left Join Account3Name On Account3Name.ClientID = CashBook.ClientID And Account3Name.AcNameID = CashBook.DebitAccount Left Join Account3Name Account3Name1 On Account3Name1.AcNameID = CashBook.CreditAccount And Account3Name1.ClientID = CashBook.ClientID Where CashBook.TableName = '${entryType.toString()}'_Rec And CashBook.TableID = '$entryID' And CashBook.ClientID = '$clientID'";
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }

      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List> paymentAgainstBill(
      {required String entryType, required String entryID}) async {
    String query = '';
    List list = [];

    query =
        "Select CashBook.*, Account3Name.AcName As DebitAccountName, Account3Name1.AcName As CreditAccountName, CashBook.TableName As EntryType, CashBook.TableID As EntryTypeID From CashBook Left Join Account3Name On Account3Name.ClientID = CashBook.ClientID And Account3Name.AcNameID = CashBook.DebitAccount Left Join Account3Name Account3Name1 On Account3Name1.AcNameID = CashBook.CreditAccount And Account3Name1.ClientID = CashBook.ClientID Where CashBook.TableName = '${entryType.toString()}'_Pay And CashBook.TableID = '$entryID' And CashBook.ClientID = '$clientID'";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }

      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List> getDataForSalePurchaseRecordToPrintInvoice(
      {required String salesInvoiceId}) async {
    String query = '';
    List list = [];

    query =
        "Select SalePur1.SalePur1ID, SalePur1.EntryType, SalePur1.SP1EntryTypeID As InvNo, SalePur1.SPDate, SalePur1.AcNameID, Account3Name.AcName As AccountName,  SalePur1.Remarks, Account3Name1.AcName As UserName, Account3Name.AcContactNo, Account3Name.AcMobileNo, Account3Name.AcAddress, Account3Name.AcEmailAddress, Item3Name.ItemName, SalePur2.ItemDescription, Item3Name.ItemName + "
        " + SalePur2.ItemDescription As ItemNameAndDescription,SalePur2.Qty,SalePur2.Price,SalePur2.Qty + "
        " + SalePur2.Price As QtyAndPrice,SalePur2.Total, SalePur1.ClientID From SalePur1 Left Join SalePur2 On SalePur2.ClientID = SalePur1.ClientID And SalePur2.EntryType = SalePur1.EntryType And SalePur2.SalePur1ID = SalePur1.SalePur1ID Left Join Account3Name On Account3Name.AcNameID = SalePur1.AcNameID And Account3Name.ClientID = SalePur1.ClientID Left Join Account3Name Account3Name1 On Account3Name1.AcNameID = SalePur1.ClientUserID And Account3Name1.ClientID = SalePur1.ClientID Left Join Item3Name On Item3Name.Item3NameID = SalePur2.Item3NameID And Item3Name.ClientID = SalePur2.ClientID  Where SalePur1.SalePur1ID = '$salesInvoiceId' And SalePur1.ClientID = '$clientID'";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }

      return list;
    } catch (e) {
      return [];
    }
  }
}
