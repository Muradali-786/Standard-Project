import 'dart:convert';
import 'dart:io';

import 'package:com/pages/place_finder_from_map/status_search.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:saver_gallery/saver_gallery.dart';

import 'loading.dart';
import 'sql_finder.dart';

class SchoolInfo {
  final String name;
  final String phoneNumber;
  final double latitude;
  final double longitude;

  SchoolInfo(
      {required this.name,
      required this.phoneNumber,
      required this.latitude,
      required this.longitude});
}

class PlacesApiResponse {
  final List<SchoolInfo> schools;
  final String? nextPageToken;

  PlacesApiResponse({required this.schools, this.nextPageToken});
}

Future fetchSchoolInfo(List<String> location, String type, context) async {
  const String apiKey = 'AIzaSyD6kvACjVr2KhaiTxJFafxi2k-H2poMAYc';
  const String apiUrl =
      'https://maps.googleapis.com/maps/api/place/textsearch/json';

  int radius = 100000;

  for (var element in location) {
    String? pagetoken = null;

    print(
        '..........................................................outer loop..........${element}');
    Provider.of<statusSearchForSchoolFinder>(context, listen: false)
        .setLocationName(tableName: element);

    int count = 0;
    String wholeLocation = '$type $element';
    String requestUrl =
        "$apiUrl?query=$wholeLocation&radius=$radius&key=$apiKey";

    Set<String> seenSchools = {}; // Use a Set to store unique schools

    while (true) {
      await Future.delayed(Duration(seconds: 3));
      Provider.of<statusSearchForSchoolFinder>(context, listen: false)
          .insertingRow();

      if (pagetoken != null) {
        requestUrl += '&pagetoken=$pagetoken';
      }

      print(requestUrl);

      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'] is List) {
          for (var schoolData in data['results']) {
            String name = schoolData['name'] ?? '';
            double latitude = schoolData['geometry']['location']['lat'] ?? 0.0;
            double longitude = schoolData['geometry']['location']['lng'] ?? 0.0;

            // Create a unique identifier for the school using latitude, longitude, and name
            String schoolIdentifier = schoolData['place_id'];

            // Check if the school is already seen (duplicate)
            if (!seenSchools.contains(schoolIdentifier)) {
              seenSchools.add(schoolIdentifier);
              print(
                  '....................................................................${++count}');
              await insetIntoContact(
                context: context,
                BusinessAddress: schoolData['formatted_address'],
                BusinessName: name,
                BusinessType: type,
                City: element,
                ContactNo: 'Not Updated',
                ContectGetFrom: '',
                Country: element,
                RefranceKey: schoolData['place_id'],
                SaveInContact: 0,
              );
            }
          }
        }

        pagetoken = data['next_page_token'];
        if (pagetoken == null) {
          break;
        }
      } else {
        break;
      }
    }
  }

  Provider.of<statusSearchForSchoolFinder>(context, listen: false).resetName();
  Provider.of<statusSearchForSchoolFinder>(context, listen: false).resetRow();
}

// Future fetchSchoolInfo(
//    List<String> location,String type, context) async {
//   const String apiKey = 'AIzaSyD6kvACjVr2KhaiTxJFafxi2k-H2poMAYc';
//
//  // https://maps.googleapis.com/maps/api/place/textsearch/json?query=School&key=AIzaSyD6kvACjVr2KhaiTxJFafxi2k-at
//   const String apiUrl =
//       'https://maps.googleapis.com/maps/api/place/textsearch/json';
//
//
//
//   String? pagetoken;
//
//   for (var element in location) {
//     pagetoken = null;
//
//     print(
//         '..........................................................outer loop..........${element}');
//     Provider.of<statusSearchForSchoolFinder>(context, listen: false)
//         .setLocationName(tableName: element);
//
//     // final String geocodingUrl =
//     //     'https://maps.googleapis.com/maps/api/geocode/json?address=$element&key=$apiKey';
//
//
//    // final geocodingResponse = await http.get(Uri.parse(geocodingUrl));
//     //if (geocodingResponse.statusCode == 200) {
//       // final geocodingData = json.decode(geocodingResponse.body);
//       // final coordinates = geocodingData['results'][0]['geometry']['location'];
//       // double latitude = coordinates['lat'];
//       // double longitude = coordinates['lng'];
//       // final String location = '$latitude,$longitude';
//       int count = 0;
//       String wholeLocation = '$type $element';
//       String requestUrl =
//           "$apiUrl?query=$wholeLocation&key=$apiKey";
//
//       while (true) {
//         print(
//             '....................................................................${++count}');
//         Provider.of<statusSearchForSchoolFinder>(context, listen: false)
//             .insertingRow();
//
//         print(pagetoken);
//         if (pagetoken != null) {
//           print('inside..................');
//           requestUrl += '&pagetoken=$pagetoken';
//         }
//
//         print(requestUrl);
//
//         final response = await http.get(Uri.parse(requestUrl));
//
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//
//           if (data['results'] != null && data['results'] is List) {
//             for (var schoolData in data['results']) {
//               String name = schoolData['name'] ?? '';
//               double latitude =
//                   schoolData['geometry']['location']['lat'] ?? 0.0;
//               double longitude =
//                   schoolData['geometry']['location']['lng'] ?? 0.0;
//
//
//             await  insetIntoContact(
//                 context: context,
//                 BusinessAddress: '$latitude $longitude',
//                 BusinessName: name,
//                 BusinessType: type,
//                 City: element,
//                 ContactNo: 'Not Updated',
//                 ContectGetFrom: '',
//                 Country: element,
//                 RefranceKey: schoolData['place_id'],
//                 SaveInContact: 0,
//               );
//             }
//           }
//
//           pagetoken = data['next_page_token'];
//           if (pagetoken == null) {
//             break;
//           }
//         } else {
//           break;
//         }
//       }
//  //   }
//   }
//
//   Provider.of<statusSearchForSchoolFinder>(context, listen: false)
//       .resetName();
//   Provider.of<statusSearchForSchoolFinder>(context, listen: false)
//       .resetRow();
//
// }

Future<void> updateNumber(context) async {
  const String apiKey = 'AIzaSyD6kvACjVr2KhaiTxJFafxi2k-H2poMAYc';
  List list = await selectDataWithOutContact();
  Provider.of<statusSearchForSchoolFinder>(context, listen: false)
      .totalNumberOfTableRow(totalNumberOfRow: list.length);

  for (var element in list) {
    Provider.of<statusSearchForSchoolFinder>(context, listen: false)
        .insertingRow();
    String placeID = element['RefranceKey'];
    final placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&fields=name,formatted_phone_number&key=$apiKey';
    final placeDetailsResponse = await http.get(Uri.parse(placeDetailsUrl));

    if (placeDetailsResponse.statusCode == 200) {
      final placeDetailsData = json.decode(placeDetailsResponse.body);

      String phoneNumber = placeDetailsData['result']
              ['formatted_phone_number'] ??
          'Phone number not available';

      print(element['AutoID'].toString());

      await updateContactNumber(id: element['AutoID'], contactNO: phoneNumber);
    }
  }
  Provider.of<statusSearchForSchoolFinder>(context, listen: false).resetName();
  Provider.of<statusSearchForSchoolFinder>(context, listen: false).resetRow();
  Provider.of<statusSearchForSchoolFinder>(context, listen: false)
      .resetTotalNumber();
}

void exportToExcel(List schools, context) async {
  LoadingViewForInsertingContact.onLoading(context);
  // Create a new Excel workbook and sheet
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['School Information'];

  // Add headers to the sheet
  // sheet.appendRow(['Name', 'Phone Number', 'Latitude', 'Location']);
  sheet.appendRow([
    TextCellValue('Name'),
    TextCellValue('Phone Number'),
    TextCellValue('Latitude'),
    TextCellValue('Location')
  ]);

  Provider.of<statusSearchForSchoolFinder>(context, listen: false)
      .totalNumberOfTableRow(totalNumberOfRow: schools.length);

  // Add data for each school to the sheet
  for (var school in schools) {
    sheet.appendRow([
      school['BusinessName'],
      school['ContactNo'],
      school['BusinessAddress'],
      school['City']
    ]);
    Provider.of<statusSearchForSchoolFinder>(context, listen: false)
        .insertingRow();
  }

  // Save the Excel file
  var dir = await getTemporaryDirectory();
  String newDir = '${dir.path}/${DateTime.now().microsecondsSinceEpoch}.xlsx';
  File outPut = File(newDir);
  await outPut.writeAsBytes(excel.encode()!);

  await savePdfToGallery(path: outPut.path, context: context);

  LoadingViewForInsertingContact.hideDialog(context);

  Provider.of<statusSearchForSchoolFinder>(context, listen: false).resetName();
  Provider.of<statusSearchForSchoolFinder>(context, listen: false).resetRow();
  Provider.of<statusSearchForSchoolFinder>(context, listen: false)
      .resetTotalNumber();
}

Future<void> insertIntoBook(context) async {
  List list = await selectDataWithContact();

  Provider.of<statusSearchForSchoolFinder>(context, listen: false)
      .totalNumberOfTableRow(totalNumberOfRow: list.length);

  // Add data for each school to the sheet
  for (var school in list) {
// Insert new contact
    if (school['ContactNo'] != 'Phone number not available') {
      final newContact = Contact()
        ..name.first = school['BusinessName']
        ..phones = [Phone(school['ContactNo'])];
      await newContact.insert();
      Provider.of<statusSearchForSchoolFinder>(context, listen: false)
          .insertingRow();
    }

    await updateSaveINBook(
      id: school['AutoID'],
    );
  }

  Provider.of<statusSearchForSchoolFinder>(context, listen: false).resetName();
  Provider.of<statusSearchForSchoolFinder>(context, listen: false).resetRow();
  Provider.of<statusSearchForSchoolFinder>(context, listen: false)
      .resetTotalNumber();
}

savePdfToGallery({
  required String path,
  required BuildContext context,
}) async {
  String picturesPath = basename(path);

  final result = await SaverGallery.saveFile(
      name: picturesPath, androidExistNotSave: false, file: path);
  () {
    if (result.isSuccess) {
      showToast(context: context, title: 'Save Successfully');
    } else {
      showToast(context: context, title: 'Not Save');
    }
  }();
}

void showToast({
  required BuildContext context,
  required String title,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green,
  ));
}
