
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

class CustomDialogForFeeRec {
  static Widget customFeeRecDueDialog(
      {required String title,
      required String currentDate,
      required String remarksTitle,
        String OpenForEditOrSave = '',
      required String maxID,
        required void Function()? onPressedClose,
      required TextEditingController controller,
      required TextEditingController remarksController,
      required void Function()? onPressed,
      onTap,
      required BuildContext context}) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Material(
        color: Colors.transparent,
        elevation: 30,
        child: StatefulBuilder(
          builder: (context, state) => Container(
            color: Provider.of<ThemeDataHomePage>(context,
                listen: false)
                .backGroundColor,
            height: MediaQuery.of(context).size.height * .47,
            width:  Platform.isWindows ?  MediaQuery.of(context).size.width * .45 : MediaQuery.of(context).size.width * .80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Provider.of<ThemeDataHomePage>(context,
                listen: false)
                .borderTextAppBarColor,
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Fee Received',style: TextStyle(color: Colors.white),),
                        Text(maxID.toString(),style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
                Consumer<ShowInsertingTableRowTOServer>(
                  builder: (context, value, child) => value.count != 0 ?  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.green,),
                        Text(
                          '${value.count} Fee Received',
                          style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ) :  SizedBox(),
                ),
                // InkWell(
                //   onTap: onTap,
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text(
                //           '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(currentDate.toString().substring(0, 4)), int.parse(currentDate.toString().substring(
                //                 5,
                //                 7,
                //               )), int.parse(currentDate.toString().substring(8, 10)))).toString()}'),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onTap: onTap,
                    readOnly: true,
                    controller: TextEditingController(text: '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(currentDate.toString().substring(0, 4)), int.parse(currentDate.toString().substring(
                      5,
                      7,
                    )), int.parse(currentDate.toString().substring(8, 10)))).toString()}'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      label: Text('Date',style: TextStyle(color: Colors.black),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: remarksController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      label: Text(remarksTitle,style: TextStyle(color: Colors.black),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      label: Text(title,style: TextStyle(color: Colors.black),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom :12, top: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ) // foreground
                            ),
                            onPressed: (){
                              Provider.of<ShowInsertingTableRowTOServer>(context, listen: false)
                                  .resetRow();
                              Navigator.pop(context);

                            },
                            child: Text(
                              'CLOSE',
                            )),
                      ),
                      Container(
                        height: 30,
                        width:Platform.isWindows ? 150 : MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ) // foreground
                            ),
                            onPressed: onPressed,
                            child: Text(
                              OpenForEditOrSave == 'Edit' ? 'Update'
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
}

class StudentFeeRec {
  late int ID;
  late int FeeRec2ID;
  late int FeeRec1ID;
  late int FeeDueID;
  late double RecAmount;
  late int ClientID;
  late int ClientUserId;
  late String NetCode;
  late String SysCode;
  late String UpdatedData;

  StudentFeeRec();

  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);

  DatabaseProvider db = DatabaseProvider();

  StudentFeeRec.fromMap(Map<String, dynamic> map) {
    ID = map['ID'];
    FeeRec2ID = map['FeeRec2ID'];
    FeeRec1ID = map['FeeRec1ID'];
    FeeDueID = map['FeeDueID'];
    RecAmount = map['RecAmount'];
    ClientID = map['ClientID'];
    ClientUserId = map['ClientUserID'];
    netCode = map['NetCode'];
    sysCode = map['SysCode'];
    UpdatedData = map['UpdatedDate'];
  }

  getDatabase() async {
    await db.init();
  }

  Future<int> maxIDForFeeRec() async {
    var db =  await DatabaseProvider().init();
    var feeRec1id;

    String maxFeeRec1Id = '''
    select -(IfNull(Max(Abs(FeeRec1ID)),0)+1) as MaxId from Sch7FeeRec1"+" where ClientID=$clientID
    ''';
    List listForRec1 = await db.rawQuery(maxFeeRec1Id);
    feeRec1id = listForRec1[0]['MaxId'].round();

    return feeRec1id;
  }

  insertStudentFeeRec({
    required double feeRecAmount,
    required String feeRecDate,
    required String feeRecRemarks,
    required int feeDueID,
  }) async {
    var db =  await DatabaseProvider().init();
    var feeRec1id;
    try {
      String maxFeeRec1Id = '''
    select -(IfNull(Max(Abs(FeeRec1ID)),0)+1) as MaxId from Sch7FeeRec1"+" where ClientID=$clientID
    ''';
      List listForRec1 = await db.rawQuery(maxFeeRec1Id);
      feeRec1id = listForRec1[0]['MaxId'].round();

  await db.rawInsert(
          'INSERT INTO Sch7FeeRec1 (FeeRec1ID,FeeRecDate,FeeRecRemarks,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate)'
          ' VALUES (?,?,?,?,?,?,?,?)',
          [
            feeRec1id,
            feeRecDate.substring(0, 10),
            feeRecRemarks,
            clientID,
            clientUserID,
            0,
            0,
            ''
          ]);



      String maxFeeRec2Id = '''
    select -(IfNull(Max(Abs(FeeRec2ID)),0)+1) as MaxId from Sch7FeeRec2"+" where ClientID=$clientID
    ''';
      List listForRec2 = await db.rawQuery(maxFeeRec2Id);
      var feeRec2id = listForRec2[0]['MaxId'].round();

 await db.rawInsert(
          'INSERT INTO Sch7FeeRec2 (FeeRec2ID,FeeRec1ID,FeeDueID,RecAmount,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate)'
          ' VALUES (?,?,?,?,?,?,?,?,?)',
          [
            feeRec2id,
            feeRec1id,
            feeDueID,
            feeRecAmount,
            clientID,
            clientUserID,
            0,
            0,
            ''
          ]);
      db.close();
   return feeRec1id;

    } catch (e) {
      print(' ${e.toString()}');
    }
  }

  updateStudentFeeRec(
      {required int id,
      required String feeRecRemarks,
      required String feeRecDate,
      required String recAmount,
      required BuildContext context}) async {
    var db =  await DatabaseProvider().init();
    try {
      var updateRec1SchoolBranch = await db.rawUpdate('''
          update Sch7FeeRec1 set FeeRecDate='$feeRecDate',FeeRecRemarks='$feeRecRemarks',ClientUserID='$clientUserID',NetCode='$netCode',SysCode='$sysCode', UpdatedDate = '' where ID=$id
          ''');

      var updateRec2SchoolBranch = await db.rawUpdate('''
          update Sch7FeeRec2 set RecAmount='$recAmount',ClientUserID='$clientUserID',NetCode='$netCode',SysCode='$sysCode' , UpdatedDate = '' where ID=$id
          ''');

      print('inserted  $updateRec2SchoolBranch $updateRec1SchoolBranch ');
      db.close();
    } catch (e) {
      print(e.toString());
    }
  }
}
