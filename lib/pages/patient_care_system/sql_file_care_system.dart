import 'dart:io';

import 'package:com/pages/patient_care_system/image_operation_care_system.dart';
import 'package:flutter/material.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

int? clientID =
    SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);

Future<bool> addNewCase({
  required BuildContext context,
  required String CaseDate,
  required String CaseTime,
  required String OldCaseID,
  required String PatientName,
  required String PatientMobileNo,
  required String Gender,
  required String CheckupToDoctorID,
  required String OtherDetail,
  required String BillAmount,
  required String TokenNo,
  required List<File> docImage,
}) async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select -(IfNull(Max(Abs(CaseID)),0)+1) as MaxId from Clanic3Case where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  String query = '''
            insert into Clanic3Case
            (CaseID,CaseDate,CaseTime,PatientName,PatientMobileNo,Gender,OldCaseID,CheckupToDoctorID,OtherDetail,BillAmount,TokenNo,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('$maxID'  , '$CaseDate' , '$CaseTime', '$PatientName'  , '$PatientMobileNo' ,'$Gender' , '$OldCaseID' ,'$CheckupToDoctorID' , '$OtherDetail' , '$BillAmount' , '$TokenNo' , 
              '$clientID' , '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}' , '' , '' , ''  ) 
    ''';

  for (int i = 0; i < docImage.length; i++) {

      await caseImageSaveToLocal(
          path: docImage[i].path,
          caseID: maxID.toString(),
          ext: '.jpg',
          name: '${i + 1}');

  }

  try {
    await database.rawInsert(query);

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}

Future<List> getAllNewCases() async {
  String query = '';
  List list = [];
  query = "Select * from Clanic3Case where  ClientID = '$clientID'";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<int> NewCaseID() async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select (IfNull(Max(Abs(CaseID)),0)+1) as MaxId from Clanic3Case where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  return maxID;
}

Future<String> updateCasePatient(
    {required String CaseDate,
    required String CaseTime,
    required String OldCaseID,
    required String PatientName,
    required String PatientMobileNo,
    required String Gender,
    required String CheckupToDoctorID,
    required String OtherDetail,
    required String BillAmount,
    required String TokenNo,
    required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update Clanic3Case set  CaseDate = '$CaseDate', CaseTime = '$CaseTime' , OldCaseID = '$OldCaseID' , PatientName = '$PatientName' 
      , PatientMobileNo = '$PatientMobileNo' , Gender = '$Gender' , CheckupToDoctorID = '$CheckupToDoctorID' , OtherDetail = '$OtherDetail' ,
      BillAmount = '$BillAmount' ,TokenNo = '$TokenNo' , UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<bool> addNewDoctor({
  required String DoctorName,
  required String SubTitle,
  required String MobileNo,
  required String SeatingRoom,
  required String CheckupCharges,
  required String OtherChargesDetail,
  required File? imagePAth,
  // required List<File> docImage,
  required String Status,
}) async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select -(IfNull(Max(Abs(DoctorID)),0)+1) as MaxId from Clanic2Doctor where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  String query = '''
            insert into Clanic2Doctor
            (DoctorID,DoctorName,SubTitle,MobileNo,SeatingRoom,CheckupCharges,OtherChargesDetail,Status,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('$maxID'  , '$DoctorName' , '$SubTitle', '$MobileNo'  , '$SeatingRoom' ,'$CheckupCharges' , '$OtherChargesDetail' ,'$Status'  , 
              '$clientID' , '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}' , '' , '' , ''  ) 
    ''';
  if (imagePAth != null) {
    doctorProfileImageSaveToLocal(
        imagePath: imagePAth.path, doctorID: maxID.toString());
  }

  // for (int i = 0; i < docImage.length; i++) {
  //   if (docImage[i].path.contains('.pdf')) {
  //     await doctorDocsImageSaveToLocal(
  //         path: docImage[i].path,
  //         doctorID: maxID.toString(),
  //         ext: '.pdf',
  //         name: '${i + 1}');
  //   } else {
  //     await doctorDocsImageSaveToLocal(
  //         path: docImage[i].path,
  //         doctorID: maxID.toString(),
  //         ext: '.jpg',
  //         name: '${i + 1}');
  //   }
  // }

  // docPDF.forEach((element)  async {
  //   await  doctorDocsImageSaveToLocal(path: element.path, doctorID: maxID.toString(), ext: '.pdf');
  // });

  try {
    await database.rawInsert(query);

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}

Future<String> updateDoctor(
    {required String DoctorName,
    required String SubTitle,
    required String MobileNo,
    required String SeatingRoom,
    required String CheckupCharges,
    required String OtherChargesDetail,
    required String Status,
    required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update Clanic2Doctor set  DoctorName = '$DoctorName', SubTitle = '$SubTitle' , MobileNo = '$MobileNo' , SeatingRoom = '$SeatingRoom' 
      , CheckupCharges = '$CheckupCharges' , OtherChargesDetail = '$OtherChargesDetail' , Status = '$Status' , 
     UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}

Future<List> getAllDoctor() async {
  String query = '';
  List list = [];
  query = "Select * from Clanic2Doctor where  ClientID = '$clientID'";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<bool> addNewPriceList({
  required String PriceDetail,
  required String Price,
}) async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select -(IfNull(Max(Abs(PriceID)),0)+1) as MaxId from Clanic1PriceList where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  String query = '''
            insert into Clanic1PriceList
            (PriceID,PriceDetail,Prce,
            ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('$maxID'  , '$PriceDetail' , '$Price',
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

Future<List> getAllPriceList() async {
  String query = '';
  List list = [];
  query = "Select * from Clanic1PriceList where  ClientID = '$clientID'";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<String> updatePriceList(
    {required String PriceDetail,
    required String Price,
    required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update Clanic1PriceList set  PriceDetail = '$PriceDetail', Prce = '$Price' ,
     UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}
