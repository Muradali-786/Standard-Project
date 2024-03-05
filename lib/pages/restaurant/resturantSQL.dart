import 'package:flutter/foundation.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../utils/api_query_for_web.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

class RestaurantDatabaseProvider extends ChangeNotifier {
  List listOfPortion = [];
  List listOfTable = [];
  List listOfItem3Name = [];
  List listOfItemGroup = [];
  int? maxIdOfRestaurant1Portion;
  int? maxIdOfSalePur2;
  int? maxIdOfRestaurant2Table;
  int? maxIdOfItemGroup;
  int? clientID =
  SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
  SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);

  String? netCode =
  SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
  SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);
  DatabaseProvider db = DatabaseProvider();

  int? maxIdOfItem3Name;

  void updateListOfPortion(List portionList) {
    this.listOfPortion = portionList;
    notifyListeners();
  }

  void updateListOfTable(List tableList) {
    this.listOfTable = tableList;
    notifyListeners();
  }

  void updateListOfItem3Name(List item3NameList) {
    this.listOfItem3Name = item3NameList;
    notifyListeners();
  }

  void updateListOfItemGroup(List itemGroupList) {
    this.listOfItemGroup = itemGroupList;
    notifyListeners();
  }

  void updateMaxIdOfRestaurant1Portion(int maxId) {
    this.maxIdOfRestaurant1Portion = maxId;
    notifyListeners();
  }

  void updateMaxIdOfSalePur2(int maxId) {
    this.maxIdOfSalePur2 = maxId;
    notifyListeners();
  }

  void updateMaxIdOfRestaurant2Table(int maxId) {
    this.maxIdOfRestaurant2Table = maxId;
    notifyListeners();
  }

  void updateMaxIdOfItemGroup(int maxId) {
    this.maxIdOfItemGroup = maxId;
    notifyListeners();
  }

  void updateMaxIdOfItem3Name(int maxId) {
    this.maxIdOfItem3Name = maxId;
    notifyListeners();
  }
  Future<Database>  getDatabase() async {
    return  await   db.init();
  }
  Future<List> getPortion() async {
    var db = await DatabaseProvider().init();
    List list = await db.rawQuery('SELECT * FROM Restaurant1Portion');
    return list;
  }

  addSalePur1() async {
   await DatabaseProvider().init();
     '''
    select -(IfNull(Max(Abs(SalePur1ID)),0)+1) as MaxId from RestaurantSalePur1"+" where ClientID=$clientID
    ''';
  }

  Future<List> getTable(int portingID) async {

    String query = '';
    List list = [];
    query = "SELECT * FROM Restaurant2Table where PortionID = '$portingID'";
    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }

    updateListOfTable(list);
    return list;
  }

  Future<void> getItem3Name() async {

    String query = '';
    List list = [];

    query = 'SELECT * FROM RestaurantItem3Name';
    if(!kIsWeb) {
    var db = await getDatabase();
    list = await db.rawQuery(query);
    }else{
    list = await apiFetchForWeb(query: query);
    }
    updateListOfItem3Name(list);
  }

  Future<void> getItemGroup() async {

    String query = '';
    List list = [];

    query = 'SELECT * FROM RestaurantItem2Group';
    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    updateListOfItemGroup(list);
  }

  Future<void> getMaxValuePortionRestaurant1Portion() async {

    String query = '';
    List list = [];

   query  = "select -(IfNull(Max(Abs(PortionID)),0)+1) as MaxId from Restaurant1Portion";

    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    updateMaxIdOfRestaurant1Portion(list[0]['MaxId']);
  }

  Future<void> getMaxValueSalePur2() async {
    String query = '';
    List list = [];

     query  = "select -(IfNull(Max(Abs(SalePur2ID)),0)+1) as MaxId from RestaurantSalePur2";

    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    updateMaxIdOfSalePur2(list[0]['MaxId']);
  }



  void addPortion({required int portionID, required String portionName}) async {
    var db = await DatabaseProvider().init();
    await db.rawInsert(
      "INSERT INTO Restaurant1Portion(PortionID, PortionName,portionDescriptions,clientID,clientUserID,netCode,sysCode,updatedDate) VALUES($portionID, '$portionName','','$clientID','$clientUserID','$netCode','$sysCode','')",
    );

    await getPortion();
  }

  void updatePortion({required String newName, required int portionID}) async {
    var db = await DatabaseProvider().init();
    await db.rawUpdate(
        'UPDATE Restaurant1Portion SET PortionName = ? WHERE PortionID = ?',
        [newName, portionID]);

    await getPortion();
  }

  void deletePortion({required int portionID}) async {
    var db = await DatabaseProvider().init();
    await db.rawDelete(
        'DELETE FROM Restaurant1Portion WHERE PortionID = ?', [portionID]);
    await getPortion();
  }

  void addTable(
      {required int portionID,
      required int tableID,
      required String tableName}) async {
    var db = await DatabaseProvider().init();
    await db.rawInsert(
      "INSERT INTO Restaurant2Table(TableID, PortionID, TableName,TableDescription,TableStatus,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate,SalPur1ID) VALUES($tableID, $portionID, '$tableName','','Empty','$clientID','$clientUserID','$netCode','$sysCode','',0)",
    );
  }

  void updateTable({
    required String tableName,
    required int tableID,
    required int portionID,
  }) async {
    var db = await DatabaseProvider().init();
     await db.rawUpdate(
        'UPDATE Restaurant2Table SET TableName = ? WHERE TableID = ? AND PortionID = ?',
        [tableName, tableID, portionID]);
    await getTable(portionID);
  }

  void deleteTable({required int tableID, required int portionID}) async {
    var db = await DatabaseProvider().init();
    await db.rawDelete(
        'DELETE FROM Restaurant2Table WHERE TableID = ? AND PortionID = ?',
        [tableID, portionID]);
    await getTable(portionID);
  }

  Future<void> getMaxValueRestaurant2TableTable() async {
    String query = '';
    List list = [];

  query  = "select -(IfNull(Max(Abs(TableID)),0)+1) as MaxId from Restaurant2Table";
    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }


    updateMaxIdOfRestaurant2Table(list[0]['MaxId']);
  }

  Future<void> getMaxValueItemGroup() async {

    String query = '';
    List list = [];

    query = "select -(IfNull(Max(Abs(Item2GroupID)),0)+1) as MaxId from RestaurantItem2Group";

    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    updateMaxIdOfItemGroup(list[0]['MaxId']);
  }

  Future<void> getMaxValueItem3Name() async {

    String query = '';
    List list = [];

    query = "select -(IfNull(Max(Abs(Item3NameID)),0)+1) as MaxId from RestaurantItem3Name";
    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    updateMaxIdOfItem3Name(list[0]['MaxId']);
  }

  void addItemGroup(
      {required int itemGroupID, required String itemGroupName}) async {
    var db = await DatabaseProvider().init();
    var res = await db.rawInsert(
      "INSERT INTO RestaurantItem2Group(Item2GroupID,Item1TypeID,Item2GroupName,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate) VALUES($itemGroupID,0 ,'$itemGroupName',0,0,'','','')",
    );
    print(res);
    await getItemGroup();
  }

  void updateItemGroup(
      {required String newName, required int itemGroupID}) async {
    var db = await DatabaseProvider().init();
    await db.rawUpdate(
        'UPDATE RestaurantItem2Group SET Item2GroupName = ? WHERE Item2GroupID = ?',
        [newName, itemGroupID]);
    await getItemGroup();
  }

  void addItem3Name({
    required int itemNameID,
    required String itemName,
    required int gID,
    required double itemSale,
  }) async {
    var db = await DatabaseProvider().init();
    await db.rawInsert(
      "INSERT INTO RestaurantItem3Name(Item3NameID,Item2GroupID,ItemName,ClientID,ClientUserID,NetCode,SysCode,SalePrice,ItemCode,Stock,UpdatedDate,ItemStatus,WebUrl,MinimumStock,ItemDescription) VALUES($itemNameID, $gID, ${itemName.length == 0 ? null : '\'$itemName\''},0,0,'','',$itemSale,${'' == '' ? null : '\'' '\''},0,'','Empty','',0,'')",
    );
    //print(res);

    await getItem3Name();
  }

  void deleteItem3Name(
      {required int itemNameID, required int itemGroupID}) async {
    var db = await DatabaseProvider().init();
    await db.rawDelete(
        'DELETE FROM RestaurantItem3Name WHERE Item3NameID = ? AND Item2GroupID = ?',
        [itemNameID, itemGroupID]);

    await getItem3Name();
  }

  void updateItem3Name(
      {required String newName,
      required int itemGroupID,
      required int itemNameID}) async {
    var db = await DatabaseProvider().init();
    await db.rawUpdate(
        'UPDATE RestaurantItem3Name SET ItemName = ? WHERE Item2GroupID = ? AND Item3NameID = ?',
        [newName, itemGroupID, itemNameID]);
    await getItem3Name();
  }
}

class DatabaseHelper {

  static updateTableSalePur1({
    required int tableID,
    required int salePur,
  }) async {
    var db = await DatabaseProvider().init();
    await db.rawUpdate(
        'UPDATE Restaurant2Table SET SalPur1ID = ? WHERE TableID = ? ', [
      salePur,
      tableID,
    ]);
  }



  static Future<List> fetchBillAmount({
    required int salPurID,
  }) async {

    String query = '';
    List list = [];
    query= "Select BillAmount FROM RestaurantSalePur1  WHERE SalePur1ID = '$salPurID'";
    if(!kIsWeb) {
      var db = await DatabaseProvider().init();;
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }


    return list;
  }
}
