import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../../Server/mysql_provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

int? clientID =
    SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);

Future<bool> addNewServicePriceList({
  required String ServiceName,
  required String ServiceDescriptions,
  required String Price,
  required String ServiceDuration,
}) async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select -(IfNull(Max(Abs(PriceID)),0)+1) as MaxId from BeautySalon1PriceList where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  String query = '''
            insert into BeautySalon1PriceList
           (PriceID,ServiceName,ServiceDescriptions,Price,ServiceDuration,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('$maxID'  , '$ServiceName' , '$ServiceDescriptions','$Price','$ServiceDuration',
              '$clientID' , '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}' , '' , '' , ''  ) 
    ''';

  try {
    await database.rawInsert(query);

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}

Future<List> getAllServicePriceList() async {
  String query = '';
  List list = [];
  query =  "Select * from BeautySalon1PriceList where  ClientID = '$clientID'" ;

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List> getAllServicePriceListFromServer({int? clientId, required BuildContext context}) async {
  String query = '';
  List list = [];
  query = "Select * from BeautySalon1PriceList where  ClientID = '$clientId'";



  try {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Results results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      for (var row in results) {

        list.add(row.fields);

      }
    }

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<String> updateServicePriceList(
    {required String ServiceName,
    required String ServiceDescriptions,
    required String ServiceDuration,
    required String Price,
    required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update BeautySalon1PriceList set  ServiceName = '$ServiceName', ServiceDescriptions = '$ServiceDescriptions' , ServiceDuration = '$ServiceDuration',Price = '$Price' ,
     UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<bool> addNewBeautician({
  required String ChairNo,
  required String BeauticianName,
  required String BeauticianDescription,
  required String MobileNo,
  required String Gender,
  required String Age,
  required String Status,
}) async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select -(IfNull(Max(Abs(BeauticianID)),0)+1) as MaxId from BeautySalon2Beautician where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  String query = '''
            insert into BeautySalon2Beautician
           (BeauticianID,ChairNo,BeauticianName,BeauticianDescription,MobileNo,Gender,Age,Status,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('$maxID'  , '$ChairNo' , '$BeauticianName','$BeauticianDescription','$MobileNo','$Gender','$Age','$Status',
              '$clientID' , '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}' , '' , '' , ''  ) 
    ''';

  try {
    await database.rawInsert(query);

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}

Future<List> getAllBeautician({int?  clientId}) async {
  String query = '';
  List list = [];
  query = clientId == null ? "Select * from BeautySalon2Beautician where  ClientID = '$clientID' " : "Select * from BeautySalon2Beautician where  ClientID = '$clientId' ";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<String> updateBeautician(
    {required String ChairNo,
    required String BeauticianName,
    required String BeauticianDescription,
    required String MobileNo,
    required String Gender,
    required String Age,
    required String Status,
    required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update BeautySalon2Beautician set  ChairNo = '$ChairNo', BeauticianName = '$BeauticianName' ,BeauticianDescription = '$BeauticianDescription' ,MobileNo = '$MobileNo' ,
      Gender = '$Gender' ,Age = '$Age' ,Status = '$Status' ,
     UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}




Future<int> addNewBill({
  required String BeauticianID,
  required String CustomerName,
  required String CustomerMobileNo,
  required String ServicesDetail,
  required String BillAmount,
  required String BillStatus,
  required String TokenNo,
  required String BillDate,
  required String BookingTime,
  required String BookForTime,

  required String ServiceStartTime,
  required String ServiceEndTime,
}) async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select -(IfNull(Max(Abs(BillID)),0)+1) as MaxId from BeautySalon3Bill where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  String query = '''
            insert into BeautySalon3Bill
           (BillID,BeauticianID,CustomerName,CustomerMobileNo,ServicesDetail,BillAmount,BillStatus,TokenNo,BillDate,BookingTime,BookForTime,ServiceStartTime,ServiceEndTime,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('$maxID'  ,'$BeauticianID' , '$CustomerName' , '$CustomerMobileNo','$ServicesDetail','$BillAmount','$BillStatus','$TokenNo','$BillDate','$BookingTime','$BookForTime','$ServiceStartTime','$ServiceEndTime',
              '$clientID' , '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}' , '' , '' , ''  ) 
    ''';

  try {
    await database.rawInsert(query);

    database.close();

    return maxID;
  } catch (e) {
    return 0;
  }
}


Future<bool> addNewBillToServer({
  required  BuildContext context,
  required String BeauticianID,
  required String CustomerName,
  required String CustomerMobileNo,
  required String ServicesDetail,
  required String BillAmount,
  required String BillStatus,
  required String TokenNo,
  required String BillDate,
  required String BookingTime,
  required String BookForTime,

  required String ServiceStartTime,
  required String ServiceEndTime,
}) async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select -(IfNull(Max(Abs(BillID)),0)+1) as MaxId from BeautySalon3Bill where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  String query = '''
            insert into BeautySalon3Bill
           (BillID,BeauticianID,CustomerName,CustomerMobileNo,ServicesDetail,BillAmount,BillStatus,TokenNo,BillDate,BookingTime,BookForTime,ServiceStartTime,ServiceEndTime,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('$maxID'  ,'$BeauticianID' , '$CustomerName' , '$CustomerMobileNo','$ServicesDetail','$BillAmount','$BillStatus','$TokenNo','$BillDate','$BookingTime','$BookForTime','$ServiceStartTime','$ServiceEndTime',
              '$clientID' , '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}' , '' , '' , ''  ) 
    ''';

  try {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Results results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
    }

    return true;
  } catch (e) {
    return false;
  }
}
Future<int> orderNewIDBIll() async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select (IfNull(Max(Abs(BillID)),0)+1) as MaxId from BeautySalon3Bill where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  return maxID;
}
Future<String> updateNewBill(
    { required String CustomerName,
      required String CustomerMobileNo,
      required String ServicesDetail,
      required String BillAmount,

      required String BillStatus,

      required String TokenNo,

      required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update BeautySalon3Bill set  CustomerName = '$CustomerName', CustomerMobileNo = '$CustomerMobileNo' ,BillStatus = '$BillStatus' ,ServicesDetail = '$ServicesDetail' ,BillAmount = '$BillAmount' ,
      TokenNo = '$TokenNo' ,
     UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<List> getAllBill() async {
  String query = '';
  List list = [];
  query = "Select * from BeautySalon3Bill where  ClientID = '$clientID'";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future deleteBill({
 required  String id,

}) async {
  String query = '';

  query = "DELETE  from BeautySalon3Bill where  ClientID = '$clientID' And  BillID = '$id' ,  ";

  var database = await DatabaseProvider().init();

  try {
    await database.rawDelete(query);


  } catch (e) {
    print(e);
    return '';
  }
}

Future<List> getRECAmountCashBook({
  required String tableName,
  required String tableID,
}) async {
  String query = '';
  List list = [];
  query = '''
  Select * FROM CashBook
   
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