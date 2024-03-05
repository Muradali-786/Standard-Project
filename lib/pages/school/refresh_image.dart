import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../material/image_uploading.dart';


////  rename image s name after refresh to server.........................
/////////////////////////////////////////////////////////////

Future<void> renameImagesToLocal(
    {required String severID, required String localID}) async {


  Directory? appDocDir = await getExternalStorageDirectory();
  String appDocPath = appDocDir!.path;
  var dir = Directory(
      '$appDocPath/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/StudentImage');
  await dir.create(recursive: true);

  print(dir.path);
  List<FileSystemEntity> list =
      dir.listSync(followLinks: false, recursive: true);

  print(list);
  print(list.length);

  if (list.length != 0) {
    for (int i = 0; i < list.length; i++) {
      var file = File('${list[i].path}');
      // imageBase64 = base64Encode(file.readAsBytesSync());
      print(file.path);
      String fileName = file.path.split('/').last;
      var name = fileName.split('.').first;

      print(name);
      // int value = int.parse(name);
      //  int v2 = -(value);
      // print(v2);

      if (name == localID.toString()) {
        print(' value change to local ${severID}');
        await file.renameSync('${dir.path}/${severID}.jpg');
      }
    }
  }
}

Future<void> dialogToUploadImageToServer(BuildContext context) async {
  Directory? appDocDir = await getExternalStorageDirectory();
  String appDocPath = appDocDir!.path;
  var dir = Directory(
      '$appDocPath/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/StudentImage');
  await dir.create(recursive: true);
  String imageBase64;

  print(dir.path);
  List<FileSystemEntity> list =
      dir.listSync(followLinks: false, recursive: true);

  if(list.length != 0) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              child: SizedBox(
                height: 130,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text(list.length.toString()),
                              Text('  Student Image to Upload '),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Would you like to upload on server?'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12, top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 30,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20),
                                          ) // foreground
                                      ),
                                      onPressed: () async {
                                        print(list);
                                        for (int i = 0; i < list.length; i++) {
                                          var file = File('${list[i].path}');
                                          imageBase64 =
                                              base64Encode(
                                                  file.readAsBytesSync());
                                          print(file.path);
                                          String fileName = file.path
                                              .split('/')
                                              .last;
                                          print(fileName);
                                          var name = fileName
                                              .split('.')
                                              .first;
                                          int value = int.parse(name);
                                          print(name);
                                          await StudentImageUploadToServer(
                                              imageBase64, value);
                                          await file.delete();
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'UPLOAD',
                                      )),
                                ),
                                Container(
                                  height: 30,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20),
                                          ) // foreground
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'CLOSE',
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          );
        });
  }
}
