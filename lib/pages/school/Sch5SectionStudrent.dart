
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../material/image_uploading.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';
import 'Sch1Branch.dart';

class CustomDialogForSectionStudent {
  static Widget customSectionStudentDialog(
      {required String GRNTitle,
      required String titleMonthlyFee,
      required String titleHeight,
      required String titleWeight,
      required String status,
      int? id,
      String? pathOfDir,
      int? sectionStudentID,
      required int sectionID,
      required void Function()? onPressedClose,
       void Function()? onPickImage,
      required TextEditingController grnController,
      required TextEditingController controllerMonthlyFee,
      required TextEditingController controllerHeight,
      required TextEditingController controllerWeight,
      required BuildContext context}) {
    SectionStudent sectionStudent = SectionStudent();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StatefulBuilder(
        builder: (context, setState) => Material(
          color: Colors.transparent,
          elevation: 30,
          child: Form(
            key: formKey,
            child: Container(
              color: Provider.of<ThemeDataHomePage>(context, listen: false)
                  .backGroundColor,
              height: MediaQuery.of(context).size.height * .58,
              width: Platform.isWindows
                  ? MediaQuery.of(context).size.width * .45
                  : MediaQuery.of(context).size.width * .80,
              child: Consumer<StudentImageManagement>(
                builder: (context, value, child) =>  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        color:
                            Provider.of<ThemeDataHomePage>(context, listen: false)
                                .borderTextAppBarColor,
                        height: 35,
                        alignment: Alignment.center,
                        child: Text(
                          'Students',
                          style: TextStyle(color: Colors.white),
                        )),
                    Consumer<ShowInsertingTableRowTOServer>(
                      builder: (context, value, child) => value.count != 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    '${value.count} Student inserted',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: onPickImage,
                            child: Container(
                              width: 50,
                              height: 50,
                              child: status == 'SAVE'
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: (value.image == '')
                                          ? Container(
                                              color: Colors.blue,
                                              child: Icon(
                                                Icons.add_a_photo,
                                                size: 30,
                                              ))
                                          : Image.file(
                                              File(value.image),
                                              fit: BoxFit.fill,
                                            ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl:'${value.imageURL}?timestamp=${DateTime.now().millisecondsSinceEpoch}' ,
                                        alignment: Alignment.center,
                                        imageBuilder: (context, imageProvider) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            (value.image == '')
                                                ? Container(
                                                    color: Colors.blue,
                                                    child: Icon(
                                                      Icons.add_a_photo,
                                                      size: 30,
                                                    ))
                                                : Image.file(
                                                    File(value.image),
                                                    fit: BoxFit.fill,
                                                  ),
                                      ),
                                      //Image(image: NetworkImage(),)
                                      //Image.network()
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0, left: 6, right: 6),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'required';
                          } else {
                            return null;
                          }
                        },
                        controller: grnController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          label: Text(
                            GRNTitle,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0, left: 6, right: 6),
                      child: TextField(
                        controller: controllerMonthlyFee,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          label: Text(
                            titleMonthlyFee,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 6.0, left: 6, right: 6),
                            child: TextField(
                              controller: controllerHeight,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                label: Text(
                                  titleHeight,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6.0, right: 6),
                            child: TextField(
                              controller: controllerWeight,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                label: Text(
                                  titleWeight,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 30,
                            width: Platform.isWindows
                                ? 150
                                : MediaQuery.of(context).size.width / 3,
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
                            width: Platform.isWindows
                                ? 150
                                : MediaQuery.of(context).size.width / 3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ) // foreground
                                    ),
                                onPressed: () async {
                                  if (status == 'SAVE') {
                                    if (value.image != '') {
                                      int sectionStudentID =
                                          await sectionStudent.maxID();

                                      Directory? appDocDir =
                                          await getExternalStorageDirectory();
                                      String appDocPath = appDocDir!.path;
                                      var dir = Directory(
                                          '$appDocPath/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/StudentImage');
                                      await dir.create(recursive: true);

                                      print(dir.path);
                                      var file = File(
                                          '${dir.path}/${sectionStudentID}.jpg');

                                      file
                                        ..create(recursive: true)
                                        ..writeAsBytes(File(value.image).readAsBytesSync());
                                    }

                                    if (formKey.currentState!.validate()) {
                                      await sectionStudent.insertSectionStudent(
                                          height:
                                              controllerHeight.text.toString(),
                                          weight:
                                              controllerWeight.text.toString(),
                                          monthlyFee: controllerMonthlyFee.text
                                              .toString(),
                                          context: context,
                                          GRN: grnController.text.toString(),
                                          sectionID: sectionID);

                                      Provider.of<ShowInsertingTableRowTOServer>(
                                              context,
                                              listen: false)
                                          .insertingRow();
                                      grnController.clear();
                                      controllerMonthlyFee.clear();
                                      controllerWeight.clear();
                                      controllerHeight.clear();
                                    }
                                  } else {
                                    if (sectionStudentID! < 0) {
                                      Directory? appDocDir =
                                          await getExternalStorageDirectory();
                                      String appDocPath = appDocDir!.path;
                                      var dir = Directory(
                                          '$appDocPath/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/StudentImage');
                                      await dir.create(recursive: true);

                                      print(dir.path);
                                      var file = File(
                                          '${dir.path}/${sectionStudentID}.jpg');

                                      file
                                        ..create(recursive: true)
                                        ..writeAsBytes(File(value.image).readAsBytesSync());
                                    } else {
                                      print(',,,,,,,,,,,,,,,,,,,,,upload image,,,,,,,,,,,,,,,,,,,,,,,,,');
                                      StudentImageUploadToServer(
                                          value.imageBase64, sectionStudentID);
                                    }

                                        await sectionStudent.updateSectionStudent(
                                      monthlyFee: controllerMonthlyFee.text
                                          .toString()
                                          .trim(),
                                      height: controllerHeight.text.toString(),
                                      weight: controllerWeight.text.toString(),
                                      id: id!,
                                      grnName:
                                          grnController.text.toString().trim(),
                                      context: context,
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  status,
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
        ),
      ),
    );
  }
}

class SectionStudent {
  late int ID;
  late int sectionStudentID;
  late int sectionID;
  late String GRN;
  late int ClientID;
  late int ClientUserId;
  late String NetCode;
  late String SysCode;
  late String UpdatedData;

  SectionStudent();

  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);

  DatabaseProvider db = DatabaseProvider();

  SectionStudent.fromMap(Map<String, dynamic> map) {
    ID = map['ID'];
    sectionStudentID = map['SectionStudentID'];
    sectionID = map['SectionID'];
    GRN = map['GRN'];
    ClientID = map['ClientID'];
    ClientUserId = map['ClientUserID'];
    netCode = map['NetCode'];
    sysCode = map['SysCode'];
    UpdatedData = map['UpdatedDate'];
  }

  getDatabase() async {
    await db.init();
  }

  Future<int> maxID() async {
    var db = await DatabaseProvider().init();

    String sectionId = '''
    select -(IfNull(Max(Abs(SectionStudenID)),0)+1) as MaxId from Sch5SectionStudent"+" where ClientID=$clientID
    ''';
    List list = await db.rawQuery(sectionId);
    var sectionStudentId = list[0]['MaxId'].round();

    return sectionStudentId;
  }

  insertSectionStudent({
    required BuildContext context,
    required String GRN,
    required String height,
    required String weight,
    required String monthlyFee,
    required int sectionID,
  }) async {
    var db = await DatabaseProvider().init();

    String sectionId = '''
    select -(IfNull(Max(Abs(SectionStudenID)),0)+1) as MaxId from Sch5SectionStudent"+" where ClientID=$clientID
    ''';
    List list = await db.rawQuery(sectionId);
    var sectionStudentId = list[0]['MaxId'].round();
    print('q.................fefeef.......................feefe.............................');
    try {
      var q = await db.rawInsert(
          'INSERT INTO Sch5SectionStudent (SectionStudenID,Weight,Height,MonthlyFee,SectionID,GRN,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate) VALUES (?,?,?,?,?,?,?,?,?,?,?)',
          [
            sectionStudentId,
            weight,
            height,
            monthlyFee,
            sectionID,
            GRN,
            clientID,
            clientUserID,
            0,
            0,
            ''
          ]);
      db.close();
      print('q.................fefeef.......................feefe.............................$q');
    } catch (e) {
      print('${e.toString()}');
      if (e is DatabaseException) {
        if (e.isUniqueConstraintError()) {
          // Handle the UNIQUE constraint violation here
          print('UNIQUE constraint violated');
          showDialog(context: context, builder: (context) => AlertDialog(content: Text('This GRN $GRN already exist'), actions: [TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Ok'))],),);
        } else {
          // Handle other database exceptions
          print('Database exception: $e');
        }
      } else {
        // Handle other exceptions
        print('Exception: $e');
      }

    }
  }

  updateSectionStudent(
      {required int id,
      required String grnName,
      required String height,
      required String monthlyFee,
      required String weight,
      required BuildContext context}) async {
    var db = await DatabaseProvider().init();
    try {
      var updateSchoolBranch = await db.rawUpdate('''
          update Sch5SectionStudent set GRN='$grnName',Height='$height',MonthlyFee='$monthlyFee',Weight='$weight',ClientUserID='$clientUserID',NetCode='$netCode',SysCode='$sysCode' ,UpdatedDate= '' where ID=$id 
          ''');
      db.close();
      print('   updated data of student$updateSchoolBranch');
      return updateSchoolBranch;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
}



class StudentImageManagement with ChangeNotifier {

  String _image = '';
  String _imageBase64 = '';
  String _imageURl = '';

  String get image => _image;

  String get imageBase64 => _imageBase64;

  String get imageURL => _imageURl;

  void setImage({required String image}) {
    _image = image;
    notifyListeners();
  }

  void setImageBase64({required String imageBase64}) {
    _imageBase64 = imageBase64;
    notifyListeners();
  }

  void setImageURL({required String imageURL}) {
    _imageURl = imageURL;
    notifyListeners();
  }

  void resetImage() {
    _image = '';
    notifyListeners();
  }

  void resetImageBase64() {
    _imageBase64 = '';
    notifyListeners();
  }

  void resetImageURL() {
    _imageURl = '';
    notifyListeners();
  }

}
