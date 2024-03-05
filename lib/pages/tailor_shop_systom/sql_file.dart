import 'dart:io';

import 'package:flutter/material.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';
import 'image_processing_tailor.dart';

int? clientID =
    SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);

Future<bool> addTailorBooking({
  required BuildContext context,
  required String CustomerMobileNo,
  required String OBRemarks,
  required String OrderStatus,
  required String DeliveryDate,
  required String DeliveredDate,
  required String OrderDate,
  required String CuttingDate,
  required String SewingDate,
  required String FinishedDat,
  required int CuttingAccount3ID,
  required int SweingAccount3ID,
  required int FinshedAccunt3ID,
  required String OrderTitle,
  required String BillAmount,
  required List<File> docImage,


  required String CustomerName,

}) async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select -(IfNull(Max(Abs(TailorBooking1ID)),0)+1) as MaxId from TailorBooking1 where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  String query = '''
            insert into TailorBooking1
            (TailorBooking1ID,CustomerMobileNo,OBRemarks,OrderStatus,DeliveryDate,DeliveredDate,OrderDate,CuttingDate,SewingDate,FinishedDat,CuttingAccount3ID,SweingAccount3ID,FinshedAccunt3ID,
            OrderTitle,BillAmount,ClientID,ClientUserID,UpdatedDate,NetCode,SysCode,SerialNo,CustomerName) 
            values
            ('$maxID'  , '$CustomerMobileNo' , '$OBRemarks', '$OrderStatus' , '$DeliveryDate' ,'$DeliveredDate' ,'$OrderDate' , '$CuttingDate' , '$SewingDate' , '$FinishedDat' , '$CuttingAccount3ID' ,
            '$SweingAccount3ID' , '$FinshedAccunt3ID' , '$OrderTitle' , '$BillAmount' ,  '$clientID' , '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}' , '' , '' , '' , '0', '$CustomerName' ) 
    ''';

  print(
      '...........................................................................');

  for (int i = 0; i < docImage.length; i++) {

    await tailorImageSaveToLocal(
        path: docImage[i].path,
        tailorID: maxID.toString(),
        ext: '.jpg',
        name: '${i + 1}');

  }

  try {
    await database.rawInsert(query);

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}

Future<String> updateOrderTailorShop(
    {required String CustomerMobileNo,
    required String OBRemarks,
    required String OrderStatus,
    required String DeliveryDate,
    required String OrderDate,
    required String OrderTitle,
    required String BillAmount,
    required String CustomerName,

    required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update TailorBooking1 set  CustomerMobileNo = '$CustomerMobileNo', OBRemarks = '$OBRemarks' , OrderStatus = '$OrderStatus' , DeliveryDate = '$DeliveryDate' 
      , OrderDate = '$OrderDate' , OrderTitle = '$OrderTitle' , BillAmount = '$BillAmount' , CustomerName = '$CustomerName' , UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<int> orderNewID() async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select (IfNull(Max(Abs(TailorBooking1ID)),0)+1) as MaxId from TailorBooking1 where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  return maxID;
}

Future<List> getTailorOrder(
    {required BuildContext context, required String status}) async {
  String query = '';
  List list = [];
  query =
      "Select * from TailorBooking1 where OrderStatus = '$status' And ClientID = '$clientID'";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<String> updateStatusCutting(
    {required String cuttingAccount3ID,
    required String cuttingDate,
    required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update TailorBooking1 set OrderStatus = 'Cutting' , CuttingAccount3ID = '$cuttingAccount3ID' , CuttingDate = '${cuttingDate}' ,UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<String> updateStatusSewing(
    {required String sewingAccount3ID,
    required String sewingDate,
    required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update TailorBooking1 set OrderStatus = 'Sewing' , SweingAccount3ID = '$sewingAccount3ID' , SewingDate = '${sewingDate}' ,UpdatedDate = ''where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<String> updateStatusFinished(
    {required String FinishedAccount3ID,
    required String FinishedDate,
    required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update TailorBooking1 set OrderStatus = 'Finished' , FinshedAccunt3ID = '$FinishedAccount3ID' , FinishedDat = '${FinishedDate}' ,UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<List> getSearchByNumber(
    {required BuildContext context, required String number}) async {
  String query = '';
  List list = [];
  query = "Select * from TailorBooking1 where CustomerMobileNo = '$number'";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List> getAllTailorData() async {
  String query = '';
  List list = [];
  query = "Select * from TailorBooking1 where OrderStatus = 'Delivered'";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List> getSingleTailorData({
  required String id,
}) async {
  String query = '';
  List list = [];
  query =
      '''Select
    TailorBooking1.*,
    IfNull(OtheJobExp.OtheJobExp, 0) As OtherJobExpense,
    IfNull(TailorBooking1.BillAmount, 0) + IfNull(OtheJobExp.OtheJobExp, 0) As TotalBillAmount,
    IfNull(CashRec.CashRec, 0) As TotalReceived,
    IfNull(TailorBooking1.BillAmount, 0) + IfNull(OtheJobExp.OtheJobExp, 0) - IfNull(CashRec.CashRec,
    0) As BillBalance,
    Account3Name.AcName As CuttingAccount3Name,
    Account3Name1.AcName As SweingAccount3Name,
    Account3Name2.AcName As FinishedAccount3Name
From
    TailorBooking1 Left Join
    (Select
         Sum(CashBook.Amount) As CashRec,
         CashBook.TableName,
         CashBook.TableID,
         CashBook.ClientID
     From
         CashBook
     Where
         CashBook.TableName = 'TS_Rec'
     Group By
         CashBook.TableName,
         CashBook.TableID,
         CashBook.ClientID) CashRec On CashRec.TableID = TailorBooking1.TailorBooking1ID
            And CashRec.ClientID = TailorBooking1.ClientID Left Join
    (Select
         Sum(CashBook.Amount) As OtheJobExp,
         CashBook.TableName,
         CashBook.TableID,
         CashBook.ClientID
     From
         CashBook
     Where
         CashBook.TableName = 'TS_Exp'
     Group By
         CashBook.TableName,
         CashBook.TableID,
         CashBook.ClientID) OtheJobExp On OtheJobExp.TableID = TailorBooking1.TailorBooking1ID
            And OtheJobExp.ClientID = TailorBooking1.ClientID Left Join
    Account3Name On Account3Name.AcNameID = TailorBooking1.CuttingAccount3ID
            And Account3Name.ClientID = TailorBooking1.ClientID Left Join
    Account3Name Account3Name1 On Account3Name1.ClientID = TailorBooking1.ClientID
            And Account3Name1.AcNameID = TailorBooking1.SweingAccount3ID Left Join
    Account3Name Account3Name2 On Account3Name2.AcNameID = TailorBooking1.FinshedAccunt3ID
            And Account3Name2.ClientID = TailorBooking1.ClientID
      
      where TailorBooking1.TailorBooking1ID = '$id' AND  TailorBooking1.ClientID = '$clientID' ''';

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List> getAllAmounts({
  required bookingID,
}) async {
  String query = '';
  List list = [];
  query =
      "Select TotalReceived,OtherJobExpense,BillAmount from TailorBooking1 where TailorBooking1ID = '$bookingID' AND ClientID = '$clientID'";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<String> updateRecAmount(
    {required String recAmount, required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update TailorBooking1 set TotalReceived = '$recAmount'  where TailorBooking1ID = '$ID' AND ClientID = '$clientID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<String> updateExpanseAmount(
    {required String recAmount, required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update TailorBooking1 set OtherJobExpense = '$recAmount'  where TailorBooking1ID = '$ID' AND ClientID = '$clientID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<String> updateTotalBalance(
    {required String recAmount, required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update TailorBooking1 set BillBalance = '$recAmount'  where TailorBooking1ID = '$ID' AND ClientID = '$clientID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<List> getCashBookDetailsData({
  required String tableName,
  required String tableID,
}) async {
  String query = '';
  List list = [];
  query = '''
  Select
    CashBook.CashBookID,
    CashBook.CBDate,
    CashBook.DebitAccount As DebitAccountID,
    Account3Name.AcName As DebitAccountName,
    CashBook.CreditAccount As CreditAccountID,
    Account3Name1.AcName As CreditAccountName,
    CashBook.ClientUserID As UserID,
    Account3Name2.AcName As UserName,
    CashBook.CBRemarks,
    CashBook.Amount,
    CashBook.ClientID,
    CashBook.NetCode,
    CashBook.SysCode,
    CashBook.UpdatedDate,
    CashBook.TableID As EntryTypeID,
    CashBook.TableName As EntryType
From
    CashBook Left Join
    Account3Name On Account3Name.AcNameID = CashBook.DebitAccount
            And Account3Name.ClientID = CashBook.ClientID Left Join
    Account3Name Account3Name1 On Account3Name1.AcNameID = CashBook.CreditAccount
            And Account3Name1.ClientID = CashBook.ClientID Left Join
    Account3Name Account3Name2 On Account3Name2.AcNameID = CashBook.ClientUserID
            And Account3Name2.ClientID = CashBook.ClientUserID
Where
    CashBook.ClientID= '$clientID' AND
    CashBook.TableName = '$tableName' AND
    CashBook.TableID = '$tableID' 
    
     ''';

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

UpdateCashBookForTailor(
  int cashBookId,
  String cbDate,
  String debitAccount,
  String creditAccount,
  String cbRemarks,
  String amount,
) async {
  var db = await DatabaseProvider().init();
  try {
    var updata_account = await db.rawUpdate(
        "update CashBook set CBDate='${cbDate.substring(0, 10)}',DebitAccount=$debitAccount,CreditAccount=$creditAccount,CBRemarks='$cbRemarks',Amount=$amount,UpdatedDate='' where CashBookID=$cashBookId AND ClientID=$clientID");

    print(updata_account);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<List> getAmountForEditRexExp({
  required String bookingID,
  required String tableName,
  required String tableID,
}) async {
  String query = '';
  List list = [];
  query = '''Select
    Sum(CashBook.Amount) As TotalReceived
From
    CashBook
Where
    CashBook.ClientID = '$clientID' And
    CashBook.TableName = '$tableName' And
    CashBook.TableID = '$tableID' 
Group By
    CashBook.ClientID,
    CashBook.TableName,
    CashBook.TableID,
    CashBook.CreditAccount''';

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List> getAllData({required String status}) async {
  String query = '';
  List list = [];
  query = '''Select
    TailorBooking1.*,
    IfNull(OtheJobExp.OtheJobExp, 0) As OtherJobExpense,
    IfNull(TailorBooking1.BillAmount, 0) + IfNull(OtheJobExp.OtheJobExp, 0) As TotalBillAmount,
    IfNull(CashRec.CashRec, 0) As TotalReceived,
    IfNull(TailorBooking1.BillAmount, 0) + IfNull(OtheJobExp.OtheJobExp, 0) - IfNull(CashRec.CashRec,
    0) As BillBalance,
    Account3Name.AcName As CuttingAccount3Name,
    Account3Name1.AcName As SweingAccount3Name,
    Account3Name2.AcName As FinishedAccount3Name
From
    TailorBooking1 Left Join
    (Select
         Sum(CashBook.Amount) As CashRec,
         CashBook.TableName,
         CashBook.TableID,
         CashBook.ClientID
     From
         CashBook
     Where
         CashBook.TableName = 'TS_Rec'
     Group By
         CashBook.TableName,
         CashBook.TableID,
         CashBook.ClientID) CashRec On CashRec.TableID = TailorBooking1.TailorBooking1ID
            And CashRec.ClientID = TailorBooking1.ClientID Left Join
    (Select
         Sum(CashBook.Amount) As OtheJobExp,
         CashBook.TableName,
         CashBook.TableID,
         CashBook.ClientID
     From
         CashBook
     Where
         CashBook.TableName = 'TS_Exp'
     Group By
         CashBook.TableName,
         CashBook.TableID,
         CashBook.ClientID) OtheJobExp On OtheJobExp.TableID = TailorBooking1.TailorBooking1ID
            And OtheJobExp.ClientID = TailorBooking1.ClientID Left Join
    Account3Name On Account3Name.AcNameID = TailorBooking1.CuttingAccount3ID
            And Account3Name.ClientID = TailorBooking1.ClientID Left Join
    Account3Name Account3Name1 On Account3Name1.ClientID = TailorBooking1.ClientID
            And Account3Name1.AcNameID = TailorBooking1.SweingAccount3ID Left Join
    Account3Name Account3Name2 On Account3Name2.AcNameID = TailorBooking1.FinshedAccunt3ID
            And Account3Name2.ClientID = TailorBooking1.ClientID
Where
    TailorBooking1.ClientID = '$clientID' AND OrderStatus = '$status' ''';

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);
    print(list);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}