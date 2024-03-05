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

    query  = "Select RestaurantItem3Name.Item3NameID As ID, RestaurantItem3Name.ItemName As Title, RestaurantItem2Group.Item2GroupName As SubTitle, RestaurantItem3Name.Stock As Value From RestaurantItem3Name Left Join RestaurantItem2Group On RestaurantItem2Group.Item2GroupID = RestaurantItem3Name.Item2GroupID And RestaurantItem2Group.ClientID = RestaurantItem3Name.ClientID Where RestaurantItem3Name.ClientID = '$clientID' Order By Title";

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
    List list = [];

  query = "Select RestaurantItem1Type.ItemType, RestaurantItem3Name.Item2GroupID As GroupID, RestaurantItem2Group.Item2GroupName As GroupName, RestaurantItem3Name.Item3NameID As ItemID, RestaurantItem3Name.ItemName, RestaurantItem3Name.ItemCode, RestaurantItem3Name.SalePrice, RestaurantItem3Name.Stock, Account3Name.AcName As UserName, RestaurantItem3Name.ClientID From RestaurantItem3Name Left Join RestaurantItem2Group On RestaurantItem2Group.Item2GroupID = RestaurantItem3Name.Item2GroupID And RestaurantItem2Group.ClientID = RestaurantItem3Name.ClientID Left Join RestaurantItem1Type On RestaurantItem1Type.Item1TypeID = RestaurantItem2Group.Item1TypeID Left Join Account3Name On Account3Name.AcNameID = RestaurantItem3Name.ClientUserID And Account3Name.ClientID = RestaurantItem3Name.ClientID Where RestaurantItem3Name.ClientID = '$clientId'";
    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }


    return list;
  }

  ///   data    item type //////////////////////////
  dropDownDataForItemType() async {

    String query = '';
    List list = [];

query = "Select RestaurantItem1Type.Item1TypeID As ID, RestaurantItem1Type.ItemType As Title, '' As SubTitle, '' As Value From RestaurantItem1Type";
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

  ///   data    item group ////////s//////////////////
  dropDownDataForItemGroup() async {

    String query = '';
    List list = [];

    query = "Select RestaurantItem3Name.Item3NameID As ID, RestaurantItem3Name.ItemName As Title, RestaurantItem2Group.Item2GroupName As SubTitle, RestaurantItem3Name.Stock As Value, RestaurantItem3Name.ClientID From RestaurantItem3Name Left Join RestaurantItem2Group On RestaurantItem2Group.Item2GroupID = RestaurantItem3Name.Item2GroupID And RestaurantItem2Group.ClientID = RestaurantItem3Name.ClientID Where RestaurantItem3Name.ClientID = '$clientID' Order By Title";

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

  ///   insert int    item2 group ////////s//////////////////
  insertItem2Group(
    int Item1TypeId,
    String ItemGroupName,
    BuildContext context,
  ) async {
    //ItemGroupName = "Pakistan";
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(RestaurantItem2Group.Item2GroupID)),0)+1) as MaxId from RestaurantItem2Group where ClientID=$clientID
    ''';
    List list = await db.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();

    String query = '''
            insert into RestaurantItem2Group
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
      update RestaurantItem2Group set Item1TypeID=$Item1TypeId,Item2GroupName='$Item2GroupName',
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



     query = "select -(IfNull(Max(Abs(RestaurantItem3Name.Item3NameID)),0)+1) as MaxId from RestaurantItem3Name where ClientID='$clientID'";

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
    select -(IfNull(Max(Abs(RestaurantItem3Name.Item3NameID)),0)+1) as MaxId from RestaurantItem3Name where ClientID=$clientID
    ''';
    List list = await db.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();

    String query = '''
            insert into RestaurantItem3Name
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
      update RestaurantItem3Name set Item2GroupID='$Item2GroupId',ItemName=${ItemName.length == 0 ? null : '\'$ItemName\''},
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

    query ="Select RestaurantItem2Group.Item2GroupID As ID, RestaurantItem2Group.Item2GroupName As Title, RestaurantItem1Type.ItemType As SubTitle, '' As Value From RestaurantItem2Group Left Join RestaurantItem1Type On RestaurantItem1Type.Item1TypeID = RestaurantItem2Group.Item1TypeID Where RestaurantItem2Group.ClientID = '$clientID' Order By SubTitle";

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

    query = "Select RestaurantItem2Group.Item2GroupID As ID, RestaurantItem2Group.Item2GroupName As Title, RestaurantItem1Type.ItemType As SubTitle, '' As Value From RestaurantItem2Group Left Join RestaurantItem1Type On RestaurantItem1Type.Item1TypeID = RestaurantItem2Group.Item1TypeID Where RestaurantItem2Group.ClientID = '$clientID' Order By SubTitle";

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

  query  = "select -(IfNull(Max(Abs(Item5Location.LocationID)),0)+1) as MaxId from Item5Location where ClientID='$clientID'";

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


 query  ="Select LocationName As Title, ID from Item5Location where ClientID = '$clientID'";

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

    query = "Select Item4Production.*, RestaurantItem3Name.ItemName, RestaurantItem2Group.Item2GroupName From Item4Production Left Join RestaurantItem3Name On RestaurantItem3Name.Item3NameID = Item4Production.RawItemID And RestaurantItem3Name.ClientID = Item4Production.ClientID Left Join RestaurantItem2Group On RestaurantItem2Group.Item2GroupID = RestaurantItem3Name.Item2GroupID And RestaurantItem2Group.ClientID = RestaurantItem3Name.ClientID Where Item4Production.ClientID = '$clientID' And Item4Production.Item3NameID = '$item3NameID'";
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


     query = "Select RestaurantSalePur2.QtyAdd, RestaurantSalePur2.Price, RestaurantSalePur2.Total, RestaurantSalePur2.Location, RestaurantSalePur2.EntryType, RestaurantSalePur2.ID, RestaurantRestaurantSalePur1.SalePur1ID, RestaurantSalePur2.Item3NameID From RestaurantSalePur2 Left Join RestaurantSalePur1 On RestaurantSalePur1.EntryType = RestaurantSalePur2.EntryType And RestaurantSalePur1.SalePur1ID = RestaurantSalePur2.SalePur1ID And RestaurantSalePur1.ClientID = RestaurantSalePur2.ClientID Where RestaurantSalePur2.EntryType = SL And RestaurantSalePur1.SalePur1ID = 1 And RestaurantSalePur2.Item3NameID = '$item3NameID' AND RestaurantSalePur2.ClientID = 4";

    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }

    print('.........list............$list');
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
