
import 'dart:io';

import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:flutter/material.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../utils/show_inserting_table_row_server.dart';
import 'Sch1Branch.dart';



class YearEducationalDialog {
  static Widget yearEducationalDialog(
      {required String title,
        required TextEditingController controller,
        String OpenForEditOrSave = '',
        required void Function()? onPressedClose,
        required void Function()? onPressed,required  BuildContext context}) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Material(
        color: Colors.transparent,
        elevation: 30,
        child: Form(
          key: formKey ,
          child: Container(
            color: Provider.of<ThemeDataHomePage>(context,
                listen: false)
                .backGroundColor,
            height: MediaQuery.of(context).size.height * .25 ,
            width:  Platform.isWindows ?  MediaQuery.of(context).size.width * .45 : MediaQuery.of(context).size.width * .80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    color: Provider.of<ThemeDataHomePage>(context, listen: false)
                        .borderTextAppBarColor,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text('Educational Year ',style: TextStyle(color: Colors.white),)),
                Consumer<ShowInsertingTableRowTOServer>(
                  builder: (context, value, child) => value.count != 0 ?  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.green,),
                        Text(
                          '${value.count} Year inserted',
                          style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ) :  SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return 'required';
                      }else{
                        return null;
                      }
                    },
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
                        width:Platform.isWindows ? 150 : MediaQuery.of(context).size.width / 3,
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
                        width: Platform.isWindows ? 150 :MediaQuery.of(context).size.width / 3,
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

class SchoolYear {
  late int ID;
  late int educationalYearID;
  late String branchId;
  late String educationalYear;
  late int ClientID;
  late int ClientUserId;
  late String NetCode;
  late String SysCode;
  late String UpdatedData;

  SchoolYear();

  int? clientID =
  SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
  SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
  SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
  SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);

  DatabaseProvider db = DatabaseProvider();

  SchoolYear.fromMap(Map<String, dynamic> map) {
    ID = map['ID'];
    educationalYearID = map['EducationalYearID'];
    branchId = map['BranchID'];
    educationalYear = map['EducationalYear'];
    ClientID = map['ClientID'];
    ClientUserId = map['ClientUserID'];
    netCode = map['NetCode'];
    sysCode = map['SysCode'];
    UpdatedData = map['UpdatedDate'];
  }

  getDatabase() async {
    await db.init();
  }

    Future<String>  insetYearEducation(
      {required BuildContext context,
        required String educationalYear,
        required int branchID
       }) async {
      var db =  await DatabaseProvider().init();

    String yearID = '''
    select -(IfNull(Max(Abs(EducationalYearID)),0)+1) as MaxId from Sch2Year"+" where ClientID=$clientID
    ''';
    List list = await db.rawQuery(yearID);
    var yearId = list[0]['MaxId'].round();
    try {
      var q = await db.rawInsert('INSERT INTO Sch2Year (EducationalYearID,BranchID,EducationalYear,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate) VALUES (?,?,?,?,?,?,?,?)',[yearId,branchID,educationalYear,clientID,clientUserID,0,0,'']);
     // db.close();
      print(q);

      return 'Insert';
    } catch (e) {

    //  print('${e.toString()}');
      return e.toString();

    }
  }

 Future<int>  updateSchoolYear({required int id,required String yearEducation ,required BuildContext context}) async {
   var db =  await DatabaseProvider().init();
    try {
      var updateSchoolBranch = await db.rawUpdate('''
          update Sch2Year set EducationalYear='$yearEducation',ClientUserID='$clientUserID',NetCode='$netCode',SysCode='$sysCode' , UpdatedDate='' where ID=$id
          ''');
      db.close();
      print(updateSchoolBranch);
      return updateSchoolBranch;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
}