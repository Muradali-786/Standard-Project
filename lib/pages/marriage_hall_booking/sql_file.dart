


import 'dart:io';

import 'package:com/pages/marriage_hall_booking/image_processing_merriage.dart';
import 'package:flutter/material.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

int? clientID =
SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);


Future<bool> addMarriageBooking({
  required BuildContext context,
  required String ClientName,
  required String ClientMobile,
  required String ClientAddress,
  required String ClientNIC,
  required String EventName,
  required String BookingDate,
  required String EventDate,
  required String PersonsQty,
  required String TotalCharges,
  required String Shift,
  required String Description,
  required int TotalReceived,
  required int BillBalance,
  required String EventTiming,
  required String ChargesDetail,
  required List<File> docImage,
}) async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select -(IfNull(Max(Abs(BookingID)),0)+1) as MaxId from MarriageHallBooking where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  String query = '''
            insert into MarriageHallBooking
            (BookingID,ClientName,ClientMobile,ClientAddress,ClientNIC,EventName,BookingDate,EventDate,PersonsQty,TotalCharges,Description,TotalReceived,Shift,
            BillBalance,ChargesDetail,EventTiming,ClientID,ClientUserID,UpdatedDate,NetCode,SysCode) 
            values
            ('$maxID'  , '$ClientName' , '$ClientMobile', '$ClientAddress' , '$ClientNIC' ,'$EventName' ,'$BookingDate' , '$EventDate' , '$PersonsQty' , '$TotalCharges' , '$Description' ,
            '$TotalReceived' , '$Shift' , '$BillBalance' , '$ChargesDetail' ,'$EventTiming',  '$clientID' , '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}' , '' , '' , ''  ) 
    ''';
  for (int i = 0; i < docImage.length; i++) {

    await marriageImageSaveToLocal(
        path: docImage[i].path,
        ID: maxID.toString(),
        ext: '.jpg',
        name: '${i + 1}');

  }

  print(
      '...........................................................................');

  try {
    await database.rawInsert(query);

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}

Future<List> getBookingOrder() async {
  String query = '';
  List list = [];
  query =
  "Select * from MarriageHallBooking ";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}



Future<int> bookingNewID() async {
  var database = await DatabaseProvider().init();

  String maxId = '''
    select (IfNull(Max(Abs(BookingID)),0)+1) as MaxId from MarriageHallBooking where ClientID=$clientID
    ''';

  List list = await database.rawQuery(maxId);

  var maxID = list[0]['MaxId'].round();

  return maxID;
}

Future<String> updateMarriageBooking(
    {required String BookingDate,
      required String ClientName,
      required String ClientMobile,
      required String ClientNIC,
      required String ClientAddress,
      required String EventName,
      required String EventDate,
      required String Shift,
      required String EventTiming,
      required String PersonsQty,
      required String Description,
      required String TotalCharges,

      required String ID}) async {
  String query = '';

  var database = await DatabaseProvider().init();

  try {
    query = """
      update MarriageHallBooking set  BookingDate = '$BookingDate', ClientName = '$ClientName' , ClientMobile = '$ClientMobile' , ClientNIC = '$ClientNIC' 
      , ClientAddress = '$ClientAddress' , EventName = '$EventName' , EventDate = '$EventDate' , Shift = '$Shift' , EventTiming = '$EventTiming' ,PersonsQty = '$PersonsQty' 
      ,Description = '$Description' , TotalCharges = '$TotalCharges' , UpdatedDate = '' where ID = '$ID'
  """;

    database.rawUpdate(query);

    return 'Update';
  } catch (e) {
    return e.toString();
  }
}



Future<List> getOrderShiftStatus({
  required String Shift,
}) async {
  String query = '';
  List list = [];
  query =
  "Select * from MarriageHallBooking where Shift = '$Shift' AND  ClientID = '$clientID' ";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List> getBookingDate({
  required String Shift,
  required String eventDate,
}) async {
  String query = '';
  List list = [];
  query =
  "Select * from MarriageHallBooking where Shift = '$Shift' AND EventDate = '$eventDate' AND ClientID = '$clientID' ";

  var database = await DatabaseProvider().init();

  try {
    list = await database.rawQuery(query);

    return list;
  } catch (e) {
    print(e);
    return [];
  }
}