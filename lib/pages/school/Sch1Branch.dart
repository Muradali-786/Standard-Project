import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../utils/api_query_for_web.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

final formKey = GlobalKey<FormState>();

Widget branchDialog(
    {required TextEditingController name,
       String OpenForEditOrSave = '',
    required TextEditingController Address,
    required TextEditingController ContactNumber,
    required TextEditingController LongLat,
    required void Function()? onPressed,
    required void Function()? onPressedClose,
    required BuildContext context}) {
  return WillPopScope(
    onWillPop: () async {
      return false;
    },
    child: Material(
      elevation: 20,
      color: Colors.transparent,
      child: Form(
        key: formKey,
        child: Container(
          color: Provider.of<ThemeDataHomePage>(context, listen: false)
              .backGroundColor,
          height: MediaQuery.of(context).size.height * .50,
          width: kIsWeb ? MediaQuery.of(context).size.width * .45 : Platform.isWindows ? MediaQuery.of(context).size.width * .45 : MediaQuery.of(context).size.width * .80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: Provider.of<ThemeDataHomePage>(context, listen: false)
                      .borderTextAppBarColor,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    'Campus Entry',
                    style: TextStyle(color: Colors.white),
                  )),
              Consumer<ShowInsertingTableRowTOServer>(
                builder: (context, value, child) => value.count != 0 ?  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.green,),
                      Text(
                        '${value.count} Campus inserted',
                        style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ) :  SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 6, right: 6),
                child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    label: Text(
                      'Campus Name',
                      style: TextStyle(color: Colors.black),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'required';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 6, right: 6),
                child: TextFormField(
                    controller: Address,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'Address',
                        style: TextStyle(color: Colors.black),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 6, right: 6),
                child: TextFormField(
                  controller: ContactNumber,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    label: Text(
                      'ContactNumber',
                      style: TextStyle(color: Colors.black),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 6, right: 6),
                child: TextFormField(
                  controller: LongLat,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    label: Text(
                      'LongLat',
                      style: TextStyle(color: Colors.black),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Container(
                      height: 30,
                      width:kIsWeb ? 150 : Platform.isWindows ? 150 :MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ) // foreground
                          ),
                          onPressed: onPressedClose,
                          child: Text(
                            'CLOSE',
                          )),
                    ),
                    Container(
                      height: 30,
                      width:kIsWeb ? 150 :  Platform.isWindows ? 150 :MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ) // foreground
                              ),
                          onPressed: onPressed,
                          child: Text(  OpenForEditOrSave == 'Edit' ? 'Update'
                           : 'SAVE',
                          )),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

class SchoolBranches {
  late int ID;
  late int branchId;
  late String branchName;
  late String address;
  late String contactNumber;
  late String longLat;
  late int ClientID;
  late int ClientUserId;
  late String NetCode;
  late String SysCode;
  late String UpdatedData;

  SchoolBranches();

  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);

  DatabaseProvider db = DatabaseProvider();

  SchoolBranches.fromMap(Map<String, dynamic> map) {
    ID = map['ID'];
    branchId = map['BranchID'];
    branchName = map['BranchName'];
    address = map['Address'];
    contactNumber = map['ContactNo'];
    longLat = map['LongLat'];
    ClientID = map['ClientID'];
    ClientUserId = map['ClientUserID'];
    netCode = map['NetCode'];
    sysCode = map['SysCode'];
    UpdatedData = map['UpdatedDate'];
  }

  getDatabase() async {
  return  await db.init();
  }

  Future<void> insertSchoolBranches(
      {required BuildContext context,
      required String branchName,
      required String address,
      required String contactNumber}) async {

    List list = [];
    var branchID;
    String query = kIsWeb ?  "select (IfNull(Max(Abs(BranchID)),0)) as MaxId from Sch1Branches where ClientID='$clientID'": "select -(IfNull(Max(Abs(BranchID)),0)+1) as MaxId from Sch1Branches where ClientID='$clientID'";
    if(!kIsWeb) {
      var db = await getDatabase();
      list = await db.rawQuery(query);
      branchID = list[0]['MaxId'].round();
      try {
        var q = await db.rawInsert(
            'INSERT INTO Sch1Branches (BranchID,BranchName,Address,ContactNo,LongLat,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate) VALUES (?,?,?,?,?,?,?,?,?,?)',
            [
              branchID,
              branchName,
              address,
              contactNumber,
              0,
              clientID,
              clientUserID,
              0,
              0,
              ''
            ]);
        db.close();
        print(q.toString());
      } catch (e) {
        print('${e.toString()}');
      }
    }else{
      list = await apiFetchForWeb(query: query);
      branchID = list[0]['MaxId'];
      int id = int.parse(branchID.toString()) +1;
      var query2 = "insert into Sch1Branches (BranchID,BranchName,Address,ContactNo,LongLat,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate) VALUES ('${id}','$branchName','$address','$contactNumber','0','${clientID.toString()}','${clientUserID.toString()}','0','0','${DateTime.now().toString()}')";
      await apiPostForWeb(query: query2);

    }

    print('.......................................$branchID');


  }

  Future<int> updateSchoolBranches(
      {required int id,
      required String name,
      required BuildContext context,
      required String address,
      required String contactNumber,
      required int longLat}) async {
    var db = await DatabaseProvider().init();
    try {
      print(',,,,,,,,,,,,,,,,,,,update,,,,,,,,$id,,,,,,,');
      int updateSchoolBranch = await db.rawUpdate('''
          update Sch1Branches set BranchName='$name',Address='$address',ContactNo='$contactNumber',LongLat='$longLat',ClientID=$clientID,ClientUserID=$clientUserID,NetCode='$netCode',SysCode='$sysCode',UpdatedDate='' where ID =$id  
          ''');
      return updateSchoolBranch;
    } catch (e) {
      return 0;
    }
  }
}
