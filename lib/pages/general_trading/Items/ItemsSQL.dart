import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../utils/api_query_for_web.dart';

class ItemSql {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;

  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);
  DatabaseProvider db = DatabaseProvider();

  Future<Database> getDatabase() async {
    return await db.init();
  }

  //SalePur1.EntryType = $entryType And
  ///////////////////select from  account3name ////////////////////////////////
  dropDownDataForItemName() async {

    String query = '';
    List list = [];

    query = "Select Item3Name.Item3NameID As ID, Item3Name.ItemName As Title, Item2Group.Item2GroupName As SubTitle, Item3Name.Stock As Value From Item3Name Left Join Item2Group On Item2Group.Item2GroupID = Item3Name.Item2GroupID And Item2Group.ClientID = Item3Name.ClientID Where Item3Name.ClientID = '$clientID' Order By Title";

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

  /// all item data  //////////////////////////////////////

  Future<List> getDefaultQueryData() async {

    String query = '';
    List queryResult = [];

     query = "Select FlutterQuery from ProjectMenuSub WHERE SabMenuName='All Items'";

    if(!kIsWeb) {
      var db = await getDatabase();
      queryResult = await db.rawQuery(query);
    }else{
      queryResult = await apiFetchForWeb(query: query);
    }
    print('..................$queryResult......................');
    String flutterQuery = queryResult[0]['FlutterQuery'];
    print('..................$flutterQuery......................');
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

    return list;
  }

  ///   data    item type //////////////////////////
  dropDownDataForItemType() async {

    String query = '';
    List list = [];

    query ="Select Item1Type.Item1TypeID As ID, Item1Type.ItemType As Title, '' As SubTitle, '' As Value From Item1Type";

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
  //
  // ///   data    item group ////////s//////////////////
  // dropDownDataForItemGroup() async {
  //   var db = await DatabaseProvider().init();
  //
  //   try {
  //     List<Map<String, dynamic>> dropDownData = await db.rawQuery('''
  //        Select
  //   Item3Name.Item3NameID As ID,
  //   Item3Name.ItemName As Title,
  //   Item2Group.Item2GroupName As SubTitle,
  //   Item3Name.Stock As Value,
  //   Item3Name.ClientID
  //   From
  //   Item3Name Left Join
  //   Item2Group On Item2Group.Item2GroupID = Item3Name.Item2GroupID
  //           And Item2Group.ClientID = Item3Name.ClientID
  //   Where
  //   Item3Name.ClientID = '$clientID'
  //   Order By
  //   Title
  //         ''');
  //     return dropDownData;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  MaxIdForItem2Group() async {
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(Item2Group.Item2GroupID)),0)+1) as MaxId from Item2Group where ClientID=$clientID
    ''';
    List list = await db.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();
    return maxID;
  }

  ///    raw Material insertion/////////////////
  insertRawMaterial(
    String item3NameID,
    String rawItemID,
    String rawUseQty,
  ) async {
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(Item4Production.ItemPro1ID)),0)+1) as MaxId from Item4Production where ClientID=$clientID
    ''';
    List list = await db.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();

    String query = '''
            insert into Item4Production
            (ItemPro1ID,Item3NameID,RawItemID,RawUseQty,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate)
            values
            ('$maxID',$item3NameID,'$rawItemID','$rawUseQty','$clientID',$clientUserID,'$netCode','$sysCode','')
    ''';

    try {
      var q = await db.rawInsert(query);

      db.close();
      print(q);
    } catch (e) {
      print(e.toString());
    }
  }

  updateRawMaterial(int? id, String RawItemID, String RawUseQty) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      update Item4Production set RawItemID=$RawItemID,RawUseQty='$RawUseQty',ClientID=$clientID,
          ClientUserID=$clientUserID,NetCode='$netCode',SysCode='$sysCode',UpdatedDate=''
           where ID=$id 
      ''';
      var update_Account = await db.rawUpdate(query);
      db.close();
      print('Update ' + update_Account.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  // CREATE TABLE "Item4Production" (
  // "ID"	INTEGER,
  // "ItemPro1ID"	INTEGER,
  // "Item3NameID"	INTEGER,
  // "RawItemID"	INTEGER,
  // "RawUseQty"	NUMERIC,
  // "ClientID"	INTEGER,
  // "ClientUserID"	INTEGER,
  // "NetCode"	TEXT,
  // "SysCode"	TEXT,
  // "UpdatedDate"	INTEGER,
  // PRIMARY KEY("ID" AUTOINCREMENT),
  // UNIQUE("ClientID","Item3NameID","RawItemID")
  // )

  ///   insert int    item2 group ////////s//////////////////
  insertItem2Group(
    int Item1TypeId,
    String ItemGroupName,
    BuildContext context,
  ) async {
    //ItemGroupName = "Pakistan";
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(Item2Group.Item2GroupID)),0)+1) as MaxId from Item2Group where ClientID=$clientID
    ''';
    List list = await db.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();

    String query = '''
            insert into Item2Group
            (Item2GroupID,Item1TypeID,Item2GroupName,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate)
            values
            ('$maxID',$Item1TypeId,'$ItemGroupName','$clientID',$clientUserID,'$netCode','$sysCode','')
    ''';

    try {
      var q = await db.rawInsert(query);

      db.close();
      print(q);
    } catch (e) {
      AlertDialog alert = AlertDialog(
        title: Text("$ItemGroupName"),
        content: Text("Is Already Exist"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok')),
        ],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });

      print(e.toString());
    }
  }

  ///   update int    item2 group ////////s//////////////////
  UpdateItem2Group(int? id, int Item1TypeId, String Item2GroupName) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      update Item2Group set Item1TypeID=$Item1TypeId,Item2GroupName='$Item2GroupName',
          ClientUserID=$clientUserID,NetCode='$netCode',SysCode='$sysCode',UpdatedDate=''
           where Item2GroupID=$Item1TypeId And ClientID=$clientID
      ''';
      var update_account = await db.rawUpdate(query);
      db.close();
      print('Update ' + update_account.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  /// max iD For item 3 name
  maxIdForItem3Name() async {


    String query = '';
    List list = [];

     query = "select -(IfNull(Max(Abs(Item3Name.Item3NameID)),0)+1) as MaxId from Item3Name where ClientID='$clientID'";


    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    var maxID = list[0]['MaxId'].round();

    print(maxID);
    return maxID;
  }

  ///  insert into item 3 name//////////////////////
  insertItem3Name(
      int item2GroupId,
      String ItemName,
      int salePrice,
      String itemCode,
      String webUrl,
      int minStock,
      String itemDescription,
      String? path) async {
    //ItemGroupName = "Pakistan";
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(Item3Name.Item3NameID)),0)+1) as MaxId from Item3Name where ClientID=$clientID
    ''';
    List list = await db.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();

    String query = '''
            insert into Item3Name
            (Item3NameID,Item2GroupID,ItemName,ClientID,ClientUserID,NetCode,SysCode,SalePrice,ItemCode,Stock,UpdatedDate,ItemStatus,WebUrl,MinimumStock,ItemDescription)
            values
            ('$maxID',$item2GroupId,${ItemName.length == 0 ? null : '\'$ItemName\''},'$clientID',$clientUserID,'$netCode','$sysCode',$salePrice,${itemCode.length == 0 ? null : '\'$itemCode\''},0,'','','$webUrl',$minStock,'$itemDescription')
    ''';

    try {
      var q = await db.rawInsert(query);
      // if(path!=null){
      //   File image=File(path);
      //   var file = File('$dir/ClientImages/$clientID/ItemImages/$maxID.jpg');
      //   file=await file.create(recursive: true);
      //   await file.writeAsBytes(image.readAsBytesSync());
      // }
      db.close();
      print(q);
    } catch (e) {
      // AlertDialog alert = AlertDialog(
      //   title: Text("ItemName/ItemCode"),
      //   content: Text('Already Exist'),
      //   actions: [
      //     FlatButton(
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //         child: Text('Ok')),
      //   ],
      // );
      //
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return alert;
      //     });

      print(e.toString());
    }
  }

  //////////////////////////////////////////////////////////////
  //////////  Item3Name Editing //////////////////////////////
  ////////////////////////////////////////////////////////////

  UpdateItem3Name(
      int id,
      int Item2GroupId,
      String ItemName,
      int SalePrice,
      String itemCode,
      String itemID,
      String WebUrl,
      int MinimumStock,
      String ItemDescription) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      update Item3Name set Item2GroupID='$Item2GroupId',ItemName=${ItemName.length == 0 ? null : '\'$ItemName\''},
              ClientID='$clientID',ClientUserID='$clientUserID',NetCode='$netCode',SysCode='$sysCode',SalePrice=$SalePrice,
              ItemCode=${itemCode.length == 0 ? null : '\'$itemCode\''},UpdatedDate='',WebUrl='$WebUrl',
              MinimumStock='$MinimumStock',ItemDescription='$ItemDescription' where Item3NameID='$itemID' AND ClientID='$clientID'
      ''';
      await db.rawUpdate(query);
      db.close();
    } catch (e) {
      print(e.toString());
    }
  }

  dropDownData1() async {

    String query = '';
    List list = [];
    query = "Select Item2Group.Item2GroupID As ID, Item2Group.Item2GroupName As Title, Item1Type.ItemType As SubTitle, '' As Value From Item2Group Left Join Item1Type On Item1Type.Item1TypeID = Item2Group.Item1TypeID Where Item2Group.ClientID = '$clientID' Order By SubTitle";

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

  ///     item2 group ...........................
  dropDownDataItem2() async {

    String query = '';
    List list = [];

    query  = "Select Item2Group.Item2GroupID As ID, Item2Group.Item2GroupName As Title, Item1Type.ItemType As SubTitle, '' As Value From Item2Group Left Join Item1Type On Item1Type.Item1TypeID = Item2Group.Item1TypeID Where Item2Group.ClientID = $clientID Order By SubTitle";

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

  /// maxID For SalePurLocation/////////////////

  Future<int> maxIdForSalePurLocation() async {

    String query = '';
    List list = [];

    query = 'select -(IfNull(Max(Abs(Item5Location.LocationID)),0)+1) as MaxId from Item5Location where ClientID=$clientID';

    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    var maxID = list[0]['MaxId'].round();

    print(maxID);

    return maxID;
  }

  /// insert into sale pur location/////////////////////

  insertSalePurLocation(String? locationName,
      {required BuildContext context}) async {
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(LocationID)),0)+1) as MaxId from Item5Location where ClientID=$clientID 
    ''';
    List list = await db.rawQuery(maxId);
    var maxID = list[0]['MaxId'].round();
    String query = '''
            insert into Item5Location
            (LocationID,LocationName,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate) 
            values
            ($maxID,'${locationName}','$clientID','$clientUserID','$netCode','$sysCode','') 
    ''';

    try {
      var q = await db.rawInsert(query);
      db.close();

      print(q);
    } catch (e) {
      print(e.toString());
    }
  }

  /// update  for sale pur location/////////////////////

  UpdateSalePurLocation(String id, String locationName) async {
    var db = await DatabaseProvider().init();
    try {
      var update_account = await db.rawUpdate(
          "update Item5Location set LocationName='$locationName', ClientUserID=$clientUserID,NetCode='$netCode',SysCode='$sysCode',UpdatedDate = '' where ID=$id");
      db.close();
      print(update_account);
    } catch (e) {
      print(e.toString());
    }
  }

  /// select location name ..........................

  DropDownValue() async {


    String query = '';
    List list = [];

     query = "Select LocationName As Title, ID from Item5Location where ClientID = '$clientID'";

    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    return list;
  }

  /// data for raw Material
  Future<List> dataRawMaterial(String item3NameID) async {

    String query = '';
    List list = [];

    query  = "Select Item4Production.*, Item3Name.ItemName, Item2Group.Item2GroupName From Item4Production Left Join Item3Name On Item3Name.Item3NameID = Item4Production.RawItemID And Item3Name.ClientID = Item4Production.ClientID Left Join Item2Group On Item2Group.Item2GroupID = Item3Name.Item2GroupID And Item2Group.ClientID = Item3Name.ClientID Where Item4Production.ClientID = '$clientID' And Item4Production.Item3NameID = '$item3NameID'";
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
      return [];
    }
  }

  ///  For Item opening Stock edit   //////////////////
  Future<List> itemStockEdit(int item3NameID) async {



    String query = '';
    List list = [];

     query ="Select SalePur2.QtyAdd, SalePur2.Price, SalePur2.Total, SalePur2.Location, SalePur2.EntryType, SalePur2.ID, SalePur1.SalePur1ID, SalePur2.Item3NameID From SalePur2 Left Join SalePur1 On SalePur1.EntryType = SalePur2.EntryType And SalePur1.SalePur1ID = SalePur2.SalePur1ID And SalePur1.ClientID = SalePur2.ClientID Where SalePur2.EntryType = SL And SalePur1.SalePur1ID = 1 And SalePur2.Item3NameID = '$item3NameID' AND SalePur2.ClientID = 4";

    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }


    return list;
  }

  Future<bool> userRightsChecking(String columnName, String menuName) async {
    try {
      var db = await DatabaseProvider().init();

      String query = '''
      select * from Account4UserRights where ClientID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}' AND
      Account3ID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}' AND MenuName='$menuName' 
       AND $columnName='true'
       ''';
      //print(query);
      List list = await db.rawQuery(query);
      print("user rights checking $columnName");
      print(list);
      if (list.length > 0) {
        print('access');
        return true;
      } else {
        return false;
      }
    } catch (e, stk) {
      print(e);
      print(stk);
      return false;
    }
  }
}
