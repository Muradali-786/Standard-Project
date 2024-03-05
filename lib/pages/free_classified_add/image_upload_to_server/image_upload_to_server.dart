import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../Server/mysql_provider.dart';


Future<File?> imageUploadingToServer(
    {required BuildContext mainContext, required String status}) async {
  bool check;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  if (androidInfo.version.sdkInt >= 33) {
    check = await Permission.photos.isGranted;
  } else {
    check = await Permission.storage.isGranted;
  }
  File? _image;

  if (!check) {
    await showDialog(
      context: mainContext,
      builder: (context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        color: Colors.blue,
                        child: Center(
                          child: Icon(
                            Icons.photo,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                                'To add photo!\nPlease allow us to access Photos and media files'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('NOT NOW')),
                                TextButton(
                                    onPressed: () async {
                                      if (androidInfo.version.sdkInt >= 33) {
                                        check = await Permission.photos
                                            .request()
                                            .isGranted;
                                      } else {
                                        check = await Permission.storage
                                            .request()
                                            .isGranted;
                                      }

                                      print(check);
                                      if (check) {
                                        _image = await dialogForChooseMedia(
                                            mainContext, status);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('CONTINUE')),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  } else {
    _image = await dialogForChooseMedia(mainContext, status);
  }

  return _image;
}

Future<File?> dialogForChooseMedia(BuildContext context, String status) async {
  File? _image;
  await showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            color: Colors.white,
            height: 70,
            width: 250,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                        onTap: () async {
                          _image = await pickImageFromMedia(
                            ImageSource.camera,
                          );

                          Navigator.pop(context);
                        },
                        child: Text('Take Picture from camera')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                        onTap: () async {
                          _image =
                              await pickImageFromMedia(ImageSource.gallery);

                          Navigator.pop(context);
                        },
                        child: Text('Take Picture from gallery')),
                  ),
                ],
              ),
            ),
          ),
        );
      });
  return _image;
}

Future<File> pickImageFromMedia(ImageSource imageSource,
    {String? imageFor}) async {
  File? _image;

  final ImagePicker _picker = ImagePicker();

  final XFile? photo = await _picker.pickImage(source: imageSource ,);

  _image = File(photo!.path);

  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: _image.path,
    cropStyle: CropStyle.rectangle,
    // maxHeight: imageFor == null ? 500 : 500,
    // maxWidth: imageFor == null ? 500 : 500,
    compressQuality: imageFor == null ? 80 : 80,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true),
      IOSUiSettings(
        title: 'Cropper',
      ),
    ],
  );

  _image = File(croppedFile!.path);

  return _image;
}

Future<Map> ImageUploadToServer(String image, String imageName, BuildContext context) async {


  List list = [];
  String ID = "select (IfNull(Max(Abs(ID4)),0)+1) as MaxId from AddCategory4" + "";

  if (await Provider.of<MySqlProvider>(context, listen: false)
      .connectToServerDb()) {
    Results resultsID = await Provider
        .of<MySqlProvider>(context, listen: false)
        .conn!
        .query(ID);

    for (var row in resultsID) {
      list.add(row.fields);
    }
  }
  var ID4 = list[0]['MaxId'];

  Uri url = Uri.parse(
      'https://www.api.easysoftapp.com/PhpApi1/ImageUploadWithPath.php');
  try {
    var response = await http.post(url, body: {
      'DisplayImage': image,
      'ImagePath': 'ClassifiedAds/$ID4',
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


Future<Uint8List?> fetchImage(int imageIndex,String ID4) async {
  String imageUrl = 'https://www.api.easysoftapp.com/PhpApi1/ClassifiedAds/$ID4/$imageIndex.jpg';

  var response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    return null;
  }
}
