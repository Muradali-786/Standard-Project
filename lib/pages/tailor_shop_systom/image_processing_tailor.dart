import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';

Future<void> tailorImageSaveToLocal({
  required String path,
  required String tailorID,
  required String name,
  required String ext,
}) async {
  Directory? appDocDir = await getExternalStorageDirectory();
  String appDocPath = appDocDir!.path;
  var dir = Directory(
      '$appDocPath/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/TailorImages/$tailorID');
  await dir.create(recursive: true);

  print(dir.path);
  var file = File('${dir.path}/${name}$ext');

  file
    ..create(recursive: true)
    ..writeAsBytes(File(path).readAsBytesSync());
}

Future<void> renameTailorFolderToLocal(
    {required String severID, required String localID}) async {
  Directory? appDocDir = await getExternalStorageDirectory();
  String appDocPath = appDocDir!.path;
  List listOfFolder = [];
  var dir = Directory(
      '$appDocPath/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/TailorImages');
  await dir.create(recursive: true);
  List<FileSystemEntity> listDIR =
      dir.listSync(followLinks: false, recursive: true);

  for (int i = 0; i < listDIR.length; i++) {
    if (listDIR[i] is Directory) {
      print(listDIR.length.toString());

      listOfFolder.add(listDIR[i]);
    }
  }
  if (listOfFolder.length != 0) {
    for (int i = 0; i < listOfFolder.length; i++) {
      var directory = Directory('${listOfFolder[i].path}');
      String fileName = directory.path.split('/').last;
      var name = fileName.split('.').first;
      if (name == localID.toString()) {
        await directory.renameSync('${dir.path}/${severID}');
      }
    }
  }
}

Future<void> UploadTailorImagesToServer(BuildContext context) async {
  Directory? appDocDir = await getExternalStorageDirectory();
  String appDocPath = appDocDir!.path;
  List listOfFolder = [];
  var dir = Directory(
      '$appDocPath/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/TailorImages');
  await dir.create(recursive: true);
  String imageBase64;
  print(dir.path);
  List<FileSystemEntity> listDIR =
      dir.listSync(followLinks: false, recursive: true);

  for (int i = 0; i < listDIR.length; i++) {
    if (listDIR[i] is Directory) {
      print(listDIR.length.toString());

      listOfFolder.add(listDIR[i]);
    }
  }

  print(listOfFolder);

  if (listOfFolder.length != 0) {
    await showDialog(
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
                          Text(listOfFolder.length.toString()),
                          Text('   Tailor Image to Upload '),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Would you like to upload on server?'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width / 3,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ) // foreground
                                      ),
                                  onPressed: () async {
                                    print(listDIR);
                                    for (int i = 0;
                                        i < listOfFolder.length;
                                        i++) {
                                      List<FileSystemEntity> list =
                                          listOfFolder[i].listSync(
                                              followLinks: false,
                                              recursive: true);

                                      String FolderName = listOfFolder[i]
                                          .path
                                          .split('/')
                                          .last
                                          .split('.')
                                          .first;

                                      for (int i = 0; i < list.length; i++) {
                                        var file = File('${list[i].path}');
                                        imageBase64 = base64Encode(
                                            file.readAsBytesSync());
                                        print(file.path);
                                        String fileName =
                                            file.path.split('/').last;
                                        print(fileName);
                                        var name = fileName.split('.').first;

                                        print(name);
                                        await TailorUpdateToServer(
                                          imageBase64,
                                          FolderName,
                                          name,
                                        );
                                        await file.delete();
                                      }
                                    }
                                    for (int i = 0;
                                        i < listOfFolder.length;
                                        i++) {
                                      final contents =
                                          listOfFolder[i].listSync();
                                      if (contents.isEmpty) {
                                        listOfFolder[i].delete(recursive: true);
                                      }
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'UPLOAD',
                                  )),
                            ),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width / 3,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
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

Future<void> TailorUpdateToServer(
    String image, String tailorID, String fileName) async {
  Uri url = Uri.parse(
      'https://www.api.easysoftapp.com/PhpApi1/ImageUploadWithPath.php');
  try {
    var response = await http.post(url, body: {
      'DisplayImage': image,
      'ImagePath':
          'ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/TailorImages/$tailorID',
      'ImageName': '${fileName}.jpg',
      // 'ClientID': countryClientId.toString(),
    });
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
      print(map);
    } else {
      print(
          '...........${response.statusCode}.........not reponding ........................');
    }
  } on Exception catch (e) {
    print(e.toString());
  }
}

Future<List<File>> TailorFileImages(String ID) async {
  List uint8List = await allImages(ID);
  List<File> files = [];

  for (var value in uint8List) {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${DateTime.now().microsecond}');
    await tempFile.writeAsBytes(value);
    files.add(tempFile);
  }
  return files;
}

Future<List> allImages(String ID) async {
  int i = 0;
  List list = [];

  while (true) {
    Uint8List? images =
        await tailorImagesFetching(fileName: '${i + 1}', tailorID: ID);

    print(i);

    if (images == null) {
      break;
    } else {
      list.add(images);
      i++;
    }
  }
  return list;
}

Future<Uint8List?> tailorImagesFetching({
  required String tailorID,
  required String fileName,
}) async {
  String imageUrl =
      'http://api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/TailorImages/$tailorID/$fileName.jpg';

  var response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    return null;
  }
}
