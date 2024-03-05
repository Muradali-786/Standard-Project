import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../Server/mysql_provider.dart';
import 'package:http/http.dart' as http;
import '../../shared_preferences/shared_preference_keys.dart';

Future<String> addVehicle({
  required BuildContext context,
  required String VehicleName,
  required String Brand,
  required String Model,
  required String Colour,
  required int Account3ID,
  required int VehicleGroupID,
  required String Status,
  required String LiveLocation,
  required String PermanentLocation,
  required String ContactNo,
  required int SerialNo,
  required String CountryClientID,
  required String CountryUserID,
  required String UpdatedDate,
  required String ChargesPerKM,
  required String Remarks,
}) async {

  try {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      List list = [];
      String ID = "select (IfNull(Max(Abs(VehicleID)),0)+1) as MaxId from Vehicle2Name" + "";

      Results resultsID = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(ID);

      for (var row in resultsID) {
        list.add(row.fields);
      }
      var maxID = list[0]['MaxId'];


      String query = """
   INSERT INTO Vehicle2Name (VehicleID,VehicleGroupID,VehicleNo,Brand,Model,Colour,Account3ID,Status,LiveLocation,
   PermanentLocation,ContactNo,SerialNo,ChargesPerKM,Remarks,CountryClientID,CountryUserID,UpdatedDate, NetCode,SysCode) VALUES
        (
          '${maxID}',
          '${VehicleGroupID}',
          '${VehicleName}',
          '${Brand}',
          '${Model}',
          '${Colour}',
          '${Account3ID}',
          '${Status}',
          '${LiveLocation}',
          '${PermanentLocation}',
          '${ContactNo}',
          '${SerialNo}',
          '${ChargesPerKM}',
          '${Remarks}',
          '${CountryClientID}',
          '${CountryUserID}',
          '${UpdatedDate}',
          '0',
          '0'
        )
  """;

      await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);


    }

    // db.close();

    return 'Insert';
  } catch (e) {
    //  print('${e.toString()}');
    return e.toString();
  }
}


Future<String> editVehicle({
  required BuildContext context,

  required String VehicleName,
  required int VehicleID,
  required String Brand,
  required String Model,
  required String Colour,
  required int VehicleGroupID,
  required String Status,
  required String LiveLocation,
  required String PermanentLocation,
  required String ContactNo,
  required String UpdatedDate,
  required String ChargesPerKM,
  required String Remarks,
}) async {

  try {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {

      String query = """
      Update  Vehicle2Name set VehicleGroupID = '$VehicleGroupID' , VehicleNo = '$VehicleName' , Brand = '$Brand' ,
       Model = '$Model' , Colour = '$Colour' , Status = '$Status' , LiveLocation = '$LiveLocation' , PermanentLocation = '$PermanentLocation'
       , ContactNo = '$ContactNo' , UpdatedDate = '$UpdatedDate' , ChargesPerKM = '$ChargesPerKM' , Remarks = '$Remarks' where  VehicleID = '$VehicleID'
  """;

      await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);


    }

    // db.close();

    return 'Insert';
  } catch (e) {
    //  print('${e.toString()}');
    return e.toString();
  }
}

Future<List> getVehicle2Name({required BuildContext context}) async {
  String query = '';
  List list = [];
  query = "Select * from Vehicle2Name";

  try {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
      for (var row in results) {
        list.add(row.fields);
      }
      return list;
    }
  } catch (e) {
    print(e);
    return [];
  }
  return [];
}


Future<List> getVehicle2NameForEdit({required BuildContext context}) async {
  String query = '';
  List list = [];
  query = "Select * from Vehicle2Name where CountryClientID = '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId).toString()}' AND CountryUserID = '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}'";

  try {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
      for (var row in results) {
        list.add(row.fields);
      }
      return list;
    }
  } catch (e) {
    print(e);
    return [];
  }
  return [];
}
Future<List> getVehicleGroupName({required BuildContext context}) async {
  String query = '';
  List list = [];
  query = "Select * from Vehicle1Group";

  try {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
      for (var row in results) {
        list.add(row.fields);
      }
      return list;
    }
  } catch (e) {
    print(e);
    return [];
  }
  return [];
}

Future<Map> vehicleImageUploadToServer(String image, String imageName, BuildContext context) async {

  Uri url = Uri.parse(
      'https://www.api.easysoftapp.com/PhpApi1/ImageUploadWithPath.php');
  try {
    var response = await http.post(url, body: {
      'DisplayImage': image,
      'ImagePath': 'ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/VehicleImages/${SharedPreferencesKeys.prefs!
          .getString(SharedPreferencesKeys
          .countryUserId)
          .toString()}',
      'ImageName': '${imageName}.jpg',
      // 'ClientID': countryClientId.toString(),
    });
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);

      return map;
    } else {
      return {};
    }
  } on Exception catch (e) {
    print(e.toString());
  }
  return {};
}

Future<Uint8List?> vehicleFetchImage(int imageIndex,String clientID) async {
  String imageUrl = 'http://api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/VehicleImages/$clientID/$imageIndex.jpg';

  var response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    return null;
  }
}

Future<List>  allImages(String ID) async{
  int i = 0;
  List list = [];

  while (true){

    Uint8List?   images =    await  vehicleFetchImage( i, ID);

    print(i);

    if(images == null){
      break;
    }else{
      list.add(images);
      i++;
    }
  }
  return list;
}

Future<List<File>> uint8ListToFileImages(String ID) async {

  List uint8List = await allImages(ID) ;
  List<File>  files = [];

  for (var value in uint8List) {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${DateTime.now().microsecond}');
    await tempFile.writeAsBytes(value);
    files.add(tempFile);
  }
  return files;
}

Future<String> deleteFolderFromServer(String clientID, String imageIndex) async {
  try {
    final response = await http.delete(
      Uri.parse("https://api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/VehicleImages/$clientID/$imageIndex.jpg"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,');
     return 'deleted';
    }
    return '';
  } catch (error) {
    return '';
  }
}
