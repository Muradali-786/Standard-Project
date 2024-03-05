import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import '../../../utils/api_query_for_web.dart';
import '../../material/Toast.dart';
import '../../school/treeView.dart';
import '../../sqlite_data_views/sqlite_database_code_provider.dart';
import 'Account4UserRightsModel.dart';

class AccountSQL {
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);
  String? dir;
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;

  DatabaseProvider db = DatabaseProvider();


  Future<Database> getDatabase() async {
    return await db.init();
  }
  ///     data from account1 type///////////////////////////////////////
  selectDataFromAccount1Type() async {

    String query = '';
    List list = [];

    query = 'SELECT * from Account1Type';
    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    acc1TypeList = list.cast<Map>();
  }

  dropDownData() async {
    String query = '';
    List list = [];

    query = 'Select Account1Type.AcTypeID As ID, Account1Type.AcTypeName As Title, '' As SubTitle, '' As Value From Account1Type';

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

  Future<List> getAllAccountData() async {

    String query = '';
    List list = [];
    List list2 = [];
    var db;

     query = "Select FlutterQuery from ProjectMenuSub WHERE SabMenuName='All Accounts'";

    if(!kIsWeb) {
       db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }

    String flutterQuery = list[0]['FlutterQuery'];
    flutterQuery = flutterQuery.replaceAll('@ClientID', clientId);
    flutterQuery = flutterQuery.replaceAll('@Date2', date2);
    flutterQuery = flutterQuery.replaceAll('@Date1', date1);


    if(!kIsWeb) {
      db = await getDatabase();
      list2 = await db.rawQuery(flutterQuery);
    }else{
      list2 = await apiFetchForWeb(query: flutterQuery);
    }


    List listCopy = List.from(list2);
    listCopy.sort((a, b) => a["AccountName"]
        .toString()
        .toLowerCase()
        .compareTo(b["AccountName"].toString().toLowerCase()));

    //db.close();
    return listCopy;
  }

  ///  using in account3Name inserting///////////////////
  dropDownDataForAccount3Group() async {

    String query = '';
    List list = [];

    query = "Select Account2Group.AcGroupID As ID, Account2Group.AcGruopName As Title, Account1Type.AcTypeName As SubTitle, '' As Value From Account2Group Left Join Account1Type On Account1Type.AcTypeID = Account2Group.AcTypeID where ClientID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId).toString()}'";

    try {

      if(!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      }else{
        list = await apiFetchForWeb(query: query);
      }

      //db.close();
      return list;
    } catch (e) {
      print(e.toString());
    }
  }



  ///   max ID ///////////////////////////////////
  Future<int> maxIdForAccount2Group() async {
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(AcGroupID)),0)+1) as MaxId from Account2Group"+" where ClientID=$clientID
    ''';
    List list = await db.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();

    print(maxID);
    //  db.close();
    return maxID;
  }

  /// iserting in account 2 group /////////////
  insertAccount2Group(
      int AcTypeID, String AcGroupName, BuildContext context) async {
    // AcTypeID=-1;
    // AcGroupName="Pakistan";
    var db = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(AcGroupID)),0)+1) as MaxId from Account2Group"+" where ClientID=$clientID
    ''';
    List list = await db.rawQuery(maxId);
    var maxID = list[0]['MaxId'].round();
    String query = '''
            insert into Account2Group
            (AcGroupID,AcTypeID,AcGruopName,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate) 
            values
            ($maxID,$AcTypeID,'$AcGroupName',$clientID,$clientUserID,'$netCode','$sysCode','') 
    ''';

    try {
      var q = await db.rawInsert(query);

      var maxid = await maxIdForAccount2Group();
      maxid = maxid - 1;

      // db.close();
      print(q);
    } catch (e) {
      var maxid = await maxIdForAccount2Group();

      maxid = maxid;

      // if(e.isUniqueConstraintError()){
      //   Toast.buildErrorSnackBar("$AcGroupName is already exist");
      // }

      AlertDialog alert = AlertDialog(
        title: Text("$AcGroupName"),
        content: Text("Is Already Exist"),
        actions: [
          // ignore: deprecated_member_use
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

  /// updating in account 2 group /////////////
  UpdateAccount2Group(int id, BuildContext context, int AcTypeID) async {
    var db = await DatabaseProvider().init();
    try {
      var updata_account = await db.rawUpdate('''
          update Account2Group set AcTypeID=$AcTypeID!,AcGroupName=$clientUserID,NetCode='$netCode!',SysCode='$sysCode!' where ID=$id
          ''');
      // db.close();
      print(updata_account);
    } catch (e) {
      print(e.toString());
    }
  }

  ///     Account3Name.dart file sql ////////

  /// Max ID and Inserting Data.....///////////////////
  Future<int> MaxIdForAccount3Name() async {

    String query = '';
    List list = [];

     query = "select -(IfNull(Max(Abs(AcNameID)),0)+1) as MaxId from Account3Name where ClientID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}'";

    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }


    var maxID = list[0]['MaxId'].round();
    //print(maxID);
    // db.close();
    return maxID;
  }

  ///  get all data from ledger account //////////////////////////////////////

  Future<List> getAccountLedgerData(int accountID) async {
    try {
      String query = '';
      List list = [];

       query = "SELECT FlutterQuery FROM `ProjectMenuSub` WHERE SabMenuName= 'Account Ledger' ";

      if(!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      }else{
        list = await apiFetchForWeb(query: query);
      }

      query = list[0]['FlutterQuery'];
      query = query.replaceAll('@ClientID',
          '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}');
      query = query.replaceAll('@Date2',
          '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!}');
      query = query.replaceAll(
          '@Date1',
          SharedPreferencesKeys.prefs!
              .getString(SharedPreferencesKeys.fromDate)
              .toString());
      query = query.replaceAll('@AccountID', accountID.toString());
      // print(query);
      if(!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      }else{
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } on Exception catch (e, stk) {
      print(e);
      print(stk);
      return [];
    }
  }
  Future<bool> insertAccount3Name(
      String nameOfPerson,
      String accountGroup,
      String? accountName,
      String address,
      String phoneNo,
      String? email,
      String countryCode,
      String? mobileNo,
      String userRights,
      String remarks,
      String? path) async {
    await _initDir();
    var database = await DatabaseProvider().init();
    String maxId = '''
    select -(IfNull(Max(Abs(AcNameID)),0)+1) as MaxId from Account3Name where ClientID=$clientID
    ''';

    List list = await database.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();

    String query = '''
            insert into Account3Name
            (AcNameID,AcName,NameOfPerson,AcGroupID,AcAddress,AcMobileNo,AcContactNo,AcEmailAddress,ClientID,ClientUserID,SysCode,NetCode,UpdatedDate,UserRights,Remarks) 
            values
            ($maxID,${accountName!.length == 0 ? null : '\'$accountName\''},'$nameOfPerson','$accountGroup','$address',${mobileNo!.length == 0 ? null : '\'$mobileNo\''},
            '$phoneNo',${email!.length == 0 ? null : '\'$email\''},$clientID,$clientUserID,'$sysCode','$netCode','','$userRights','$remarks') 
    ''';

    try {
      var q = await database.rawInsert(query);
      print('22');
      if (path != null) {
        File image = File(path);
        var file = File('$dir/ClientImages/$clientID/AccountImages/$maxID.jpg');
        file = await file.create(recursive: true);
        await file.writeAsBytes(image.readAsBytesSync());
      }
      Toast.buildErrorSnackBar("Record is inserted");
      // database.close();
      print(q);
      return true;
    } catch (e, stk) {
      print(e.toString());
      print(stk);
      Toast.buildErrorSnackBar(e.toString());
      return false;
    }
  }

  Future<void> _initDir() async {
    if (null == dir) {
      if (Platform.isWindows) {
        Directory directory = await getApplicationDocumentsDirectory();
        dir = directory.path;
      } else {
        List<Directory>? list = (await getExternalStorageDirectories());
        dir = list![0].path;
      }
    }
  }

  ///  get all data from ledger account only for tree view//////////////////////////////////////
  Future<List> getAccountLedgerDataForTree(
      int accountID) async {
    try {
      String query = '';
      List list = [];

       query = "SELECT FlutterQuery FROM `ProjectMenuSub` WHERE SabMenuName=Account Ledger Complete";


      if(!kIsWeb) {
     var  db = await getDatabase();
        list = await db.rawQuery(query);
      }else{
        list = await apiFetchForWeb(query: query);
      }
      query = list[0]['FlutterQuery'];
      query = query.replaceAll('@ClientID',
          '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}');
      query = query.replaceAll('@Date2',
          '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!}');
      query = query.replaceAll(
          '@Date1',
          SharedPreferencesKeys.prefs!
              .getString(SharedPreferencesKeys.fromDate)
              .toString());
      query = query.replaceAll('@AccountID', accountID.toString());
      // print(query);

      if(!kIsWeb) {
       var db = await getDatabase();
        list = await db.rawQuery(query);
      }else{
        list = await apiFetchForWeb(query: query);
      }

      return list;
    } on Exception catch (e, stk) {
      print(e);
      print(stk);
      return [];
    }
  }

  ///v      update account 3 name
  Future<bool> UpdateAccount3Name(
      int id,
      int accountGroupID,
      String accountName,
      String address,
      String phoneNo,
      String email,
      String mobileNo,
      String userRights,
      String remarks,
      BuildContext context) async {
    var db = await DatabaseProvider().init();

    try {
      var updata_account = await db.rawUpdate(
          "update Account3Name set AcName='$accountName',AcGroupID='$accountGroupID',AcAddress='$address',AcMobileNo=${mobileNo.length == 0 ? null : '\'$mobileNo\''},AcContactNo='$phoneNo',AcEmailAddress=${email.length == 0 ? null : '\'$email\''},ClientID=$clientID,ClientUserID=$clientUserID,NetCode='$netCode',SysCode='$sysCode',UpdatedDate='',UserRights='$userRights',Remarks='$remarks' where ID=$id AND ClientID=$clientID");
      print(updata_account);
      Toast.buildErrorSnackBar("Updated Successfully");
      return true;

    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<bool> UpdateAccount3NameUserRight(
      int id,
      String email,
      String mobileNo,
      String userRights,
      BuildContext context) async {
    var db = await DatabaseProvider().init();

    try {
      var updata_account = await db.rawUpdate(
          "update Account3Name set AcMobileNo=${mobileNo.length == 0 ? null : '\'$mobileNo\''},AcEmailAddress=${email.length == 0 ? null : '\'$email\''},ClientUserID=$clientUserID,NetCode='$netCode',SysCode='$sysCode',UpdatedDate='',UserRights='$userRights' where ID='$id' AND ClientID='$clientID'");
      print(updata_account);
      Toast.buildErrorSnackBar("Updated Successfully");
      return true;

    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  ///  account ledger data ///////////////////////////////////

//user rights checking for inserting
  Future<bool> userRightsChecking(String columnName, String menuName) async {
    try {
      var db = await DatabaseProvider().init();

      String query = '''
      select * from Account4UserRights where ClientID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}' AND
      Account3ID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}' AND MenuName='$menuName' 
       AND $columnName='true'
       ''';
      //widget.list![2]['menuName']
      //print(query);
      List list = await db.rawQuery(query);
      // print("user rights checking $columnName");
      // print(list);
      if (list.length > 0) {
        //list has data do nothing and allow inserting
        return true;
      } else {
        //list has data show alert dailog and go back
        return false;
      }
    } catch (e, stk) {
      print(e);
      print(stk);
      return false;
    }
  }

  ///                custom user  right    ...//////////////////////

  Future<List> getProjectTable() async {

    String query = '';
    List list = [];

     query = "Select * from ProjectMenu WHERE ProjectID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.projectId)}' Order By ProjectMenu.GroupSortBy, ProjectMenu.SortBy";


    if(!kIsWeb) {
     var db = await getDatabase();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }


    return list;
  }

  Future<List<Account4UserRightsModel>> getAccount4UserRightsData(
      int account3Id) async {
    var db = await DatabaseProvider().init();
    String query = '''
      select * from Account4UserRights where ClientID='$clientID' AND Account3ID='$account3Id' Order By
    Account4UserRights.GroupSortBy,
    Account4UserRights.SortBy 
      ''';

    List<Account4UserRightsModel> listAccount4UserRights = [];
    List list = await db.rawQuery(query);

    List listCopy = List.from(list);
    listCopy.sort((a, b) => a["SortBy"]
        .toString()
        .toLowerCase()
        .compareTo(b["SortBy"].toString().toLowerCase()));
    listAccount4UserRights = account4UserRightsModelFromJson(jsonEncode(listCopy));
    return listAccount4UserRights;
  }

  insertIntoCustonUserRight({
    required int account3Id,
    required String menuaname,
    required String custonRightInserting,
    required String customRightEiditing,
    required String customRightDeleting,
    required String customRightReporting,
    required String sortBy,
    required String view,
    required String groupSortBy,
  }) async {
    var db = await DatabaseProvider().init();

    String query = '''
                select -(IfNull(Max(Abs(UserRightsID)),0)+1) as MaxId from Account4UserRights where ClientID='$clientID'
                ''';
    List<Map<String, dynamic>> list = await db.rawQuery(query);
    int maxUserRightsId = list[0]['MaxId'];

    query = '''
                INSERT INTO Account4UserRights
                (UserRightsID,Account3ID,Viwe,MenuName,Inserting,Edting,Deleting,Reporting,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate,SortBy,GroupSortBy)
                     VALUES ('$maxUserRightsId','$account3Id','$view',
                     '$menuaname','$custonRightInserting','$customRightEiditing','$customRightDeleting',
                     '$customRightReporting','$clientID','$clientUserID','0',
                     '0','','$sortBy','$groupSortBy')
                ''';
    await db.rawQuery(query);

    // db.close();
  }

  updateIntoCustonUserRight(dynamic jason, int id) async {
    var db = await DatabaseProvider().init();

    await db.update('Account4UserRights', jason, where: 'ID=$id');
    //  db.close();
  }
}
