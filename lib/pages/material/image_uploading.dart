import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../shared_preferences/shared_preference_keys.dart';

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
                          String? base64Image;

                          _image = await pickImageFromMedia(
                            ImageSource.camera,
                          );

                          if (status == 'Update') {
                            base64Image =
                                base64Encode(_image!.readAsBytesSync());

                            await dialogForUpdateImageTOServer(
                                fileImage: _image!,
                                base64Image: base64Image,
                                context: context);
                          }
                          Navigator.pop(context);
                        },
                        child: Text('Take Picture from camera')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                        onTap: () async {
                          String? base64Image;

                          _image =
                              await pickImageFromMedia(ImageSource.gallery);

                          if (status == 'Update') {
                            base64Image =
                                base64Encode(_image!.readAsBytesSync());

                            await dialogForUpdateImageTOServer(
                                fileImage: _image!,
                                base64Image: base64Image,
                                context: context);
                          }
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

Future<void> dialogForUpdateImageTOServer(
    {required File fileImage,
    required String base64Image,
    required BuildContext context}) async {
  await showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 170,
            width: 250,
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      minRadius: 45,
                      backgroundImage: FileImage(fileImage),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          onPressedUploadToServer(base64Image);
                        },
                        child: Text('Update'))
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

Future<File> pickImageFromMedia(ImageSource imageSource,
    {String? imageFor}) async {
  File? _image;

  final ImagePicker _picker = ImagePicker();

  final XFile? photo = await _picker.pickImage(source: imageSource);

  _image = File(photo!.path);

  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: _image.path,
    cropStyle: CropStyle.rectangle,
    maxHeight: imageFor == null ? 150 : 250,
    maxWidth: imageFor == null ? 150 : 250,
    compressQuality: imageFor == null ? 50 : 80,
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

void onPressedUploadToServer(
  String image,
) async {
  Uri url = Uri.parse(
      'https://www.api.easysoftapp.com/PhpApi1/ImageUploadWithPath.php');
  try {
    var response = await http.post(url, body: {
      'DisplayImage': image,
      'ImagePath':
          'ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/UserLogo',
      'ImageName':
          '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId)}',
      // 'ClientID': countryClientId.toString(),
    });
    if (response.statusCode == 200) {
    json.decode(response.body);
    } else {
      print(
          '...........${response.statusCode}.........not reponding ........................');
    }
  } on Exception catch (e) {
    print(e.toString());
  }
}

Future<void> StudentImageUploadToServer(
    String image, int sectionStudentID) async {
  Uri url = Uri.parse(
      'https://www.api.easysoftapp.com/PhpApi1/ImageUploadWithPath.php');
  try {
    var response = await http.post(url, body: {
      'DisplayImage': image,
      'ImagePath':
          'ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/StudentImage',
      'ImageName': '${sectionStudentID}.jpg',
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
