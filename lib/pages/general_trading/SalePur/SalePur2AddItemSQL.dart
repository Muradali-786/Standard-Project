import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../utils/api_query_for_web.dart';
import '../../sqlite_data_views/sqlite_database_code_provider.dart';

class SalePur2AddItemSQl {
  String ModifiedTime = DateTime.now().toString();
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
  DatabaseProvider db = DatabaseProvider();


  Future<Database> getDatabase() async {
    return await db.init();
  }

  insertSalePur2({
    required double total,
    int TotalAmount = 0,
    String? EntryTime,
    String? Location,
    String? Price,
    int? SalePur1ID,
    String? EntryType,
    String? Qty,
    String? Qtyless,
    int? Item3NameId,
    String? ItemDescription = ' ',
    String? QtyAdd,
  }) async {
    print('.......................$total  ');
    var db = await DatabaseProvider().init();

    /////////////////         SalePur1 Id        //////////////////
    String maxId = '''
                                select -(IfNull(Max(Abs(SalePur2.SalePur2ID)),0)+1) as MaxId from SalePur2 where ClientID=$clientID
                                ''';
    List list = await db.rawQuery(maxId);
    var salePur2Id = list[0]['MaxId'].round();

    ////////////////         Sp2EntryType Id        /////////////////
    String maxId2 = '''
                                         select -(IfNull(Max(Abs(SP2EntryTypeID)),0)+1) as MaxId from SalePur2"+" where ClientID=$clientID And EntryType='$EntryType'
                                          ''';
    List list2 = await db.rawQuery(maxId2);
    var Sp2EntryTypeId = list2[0]['MaxId'].round();

    ////////////////         itemSerial        /////////////////
    String maxId1 = '''
                                select -(IfNull(Max(Abs(SalePur2.ItemSerial)),0)+1) as MaxId from SalePur2 where ClientID=$clientID And EntryType='$EntryType' And SalePur1ID=$SalePur1ID
                                ''';
    List list1 = await db.rawQuery(maxId1);
    var itemSerial = list1[0]['MaxId'].round();

    /// if(EntryType = PU){
    /// QtyAdd = quantity_controller.text
    /// QtyLess = 0
    /// }else
    /// if(EntryType = SR){
    /// QtyAdd = quantity_controller.text
    /// QtyLess = 0
    /// }else
    /// if(EntryType = SL){
    /// QtyLess = quantity_controller.text
    /// QtyAdd = 0
    /// }else
    /// if(EntryType = PR){
    ///  QtyLess = quantity_controller.text
    ///  QtyAdd = 0
    ///  }
    ///  Total = quantity_controller.text * price_controller.text

    String query = '''
                                                insert into SalePur2
                                                (SalePur2ID,SP2EntryTypeID,ItemSerial,SalePur1ID,EntryType,
                                                Item3NameId,ItemDescription,QtyAdd,Qtyless,Qty,Price,Total,
                                                Location,OrderStatus,EntryTime,ModifiedTime,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate) 
                                                values
                                                ($salePur2Id,$Sp2EntryTypeId,$itemSerial,$SalePur1ID,'$EntryType',
                                                 $Item3NameId,'$ItemDescription',$QtyAdd,$Qtyless,'$Qty','$Price',$total,
                                                 $Location,'Active','$EntryTime','','$clientID','$clientUserID','$netCode','$sysCode','') 
                                           ''';

    try {
      var q = await db.rawInsert(query);

      print('insert $q');

      await updateAmount(SalePur1ID!, db, TotalAmount, EntryType);

    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateAmount(
      int SalePur1ID, var db, int totalAmount, String? entryType) async {
    print('...............Sale amount $SalePur1ID');
    String query1 = '''
                                              Select
                                              Sum(SalePur2.Total) As BillAmount
                                              From
                                              SalePur1 Left Join
                                              SalePur2 On SalePur2.SalePur1ID = SalePur1.SalePur1ID
                                              And SalePur2.ClientID = SalePur1.ClientID
                                              Where
                                                  SalePur1.ClientID = $clientID And
                                                  SalePur1.SalePur1ID = $SalePur1ID
                                              Group By
                                                  SalePur1.ClientID,
                                                  SalePur1.SalePur1ID
                                        
                                      ''';

    var q1 = await db.rawQuery(query1);

    print('////$q1');

    double value = double.parse(q1[0]['BillAmount'].toString());
    totalAmount = value.toInt();

    print('Total Amount' + totalAmount.toString());

    await db
        .rawUpdate("update SalePur1 set BillAmount=$totalAmount,UpdatedDate='' "
            "where SalePur1ID=$SalePur1ID AND ClientID=$clientID");

    await db.rawUpdate("update CashBook set Amount=$totalAmount "
        "where TableID=$SalePur1ID AND ClientID=$clientID");
  }

  UpdateSalePur2(
      {int id = 0,
      int? Item3NameId,
      int totalAmount = 0,
      required int SalePur1ID,
      String? EntryType,
      String? ItemDescription,
      String? QtyAdd,
      String? Qtyless,
      String? Qty,
      String? Price,
      String? Total,
      String? Location,
      String? OrderStatus,
      BuildContext? context}) async {
    var db = await DatabaseProvider().init();
    try {
      String query = '''
      update SalePur2 set Item3NameId='$Item3NameId',ItemDescription='$ItemDescription',QtyAdd='$QtyAdd',Qtyless='$Qtyless',
              Qty='$Qty',Price='$Price',Total='$Total',Location='$Location',ModifiedTime='$ModifiedTime',
              ClientUserID='$clientUserID',NetCode='$netCode',SysCode='$sysCode',UpdatedDate='' where ID=$id
      ''';
      var updata_account = await db.rawUpdate(query);


      await updateAmount(SalePur1ID, db, totalAmount, EntryType);

      // db.close();
      print(updata_account);
    } catch (e) {
      print(e.toString());
    }
  }

  dropDownData() async {

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

  void salePur2SaveEditMode({
    required String entryType,
    required int salePur1ID,
    required String Qty,
    required int selectedLocation,
    required Map map,
    required BuildContext context,
    required double QtyAdd,
    required String QtyValue,
    required String priceValue,
    required double Total,
    required double price,
    required double QtyLess,
  }) {
    switch (entryType) {
      case 'PU':
        QtyAdd = double.parse(QtyValue);
        price = double.parse(priceValue);
        QtyLess = 0;
        //Total = QtyAdd * price;
        UpdateSalePur2(
            id: map['ID'],
            Item3NameId: map['Item3NameID'],
            EntryType: entryType,
            SalePur1ID: salePur1ID,
            ItemDescription: ' ',
            QtyAdd: QtyAdd.toString(),
            Qtyless: QtyLess.toString(),
            Qty: Qty,
            Price: price.toString(),
            Total: Total.toString(),
            Location: selectedLocation.toString(),
            context: context);
        break;
      case 'SR':
        QtyAdd = double.parse(QtyValue);
        QtyLess = 0;
        price = double.parse(priceValue);
        //  Total = QtyAdd * price;
        UpdateSalePur2(
            id: map['ID'],
            Item3NameId: map['Item3NameID'],
            SalePur1ID: salePur1ID,
            EntryType: entryType,
            ItemDescription: ' ',
            QtyAdd: QtyAdd.toString(),
            Qtyless: QtyLess.toString(),
            Qty: Qty,
            Price: price.toString(),
            Total: Total.toString(),
            Location: selectedLocation.toString(),
            context: context);
        break;
      case 'SL':
        QtyLess = double.parse(QtyValue);
        QtyAdd = 0;
        price = double.parse(priceValue);

        // Total = QtyLess * price;
        UpdateSalePur2(
            id: map['ID'],
            Item3NameId: map['Item3NameID'],
            SalePur1ID: salePur1ID,
            EntryType: entryType,
            ItemDescription: '',
            QtyAdd: QtyAdd.toString(),
            Qtyless: QtyLess.toString(),
            Qty: Qty,
            Price: price.toString(),
            Total: Total.toString(),
            Location: selectedLocation.toString(),
            context: context);
        break;
      case 'PR':
        QtyLess = double.parse(QtyValue);
        QtyAdd = 0;
        price = double.parse(priceValue);
        // Total = QtyLess * price;
        UpdateSalePur2(
            id: map['ID'],
            Item3NameId: map['Item3NameID'],
            SalePur1ID: salePur1ID,
            EntryType: entryType,
            ItemDescription: ' ',
            QtyAdd: QtyAdd.toString(),
            Qtyless: QtyLess.toString(),
            Qty: Qty,
            Price: price.toString(),
            Total: Total.toString(),
            Location: selectedLocation.toString(),
            context: context);

        break;
      default:
        break;
    }
  }
}
