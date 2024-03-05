import 'dart:io';
import 'dart:typed_data';

import 'package:com/pages/school/SchoolSql.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/constants.dart';

class ImportExportStudentInfo {
  TextEditingController _excelFileNameController =
      TextEditingController(text: 'StudentInfo');
  SchoolSQL _schoolSQL = SchoolSQL();
  String checkValueForGroupName = '.xlsx';
  String checkValueForCSV = '.csv';
  String checkValueForXLS = '.xls';
  String checkValueForXLSX = '.xlsx';

  Future<void> importFromExcel(BuildContext context) async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      Constants.onLoading(context, 'Data is Importing');
      var path = pickedFile.paths[0].toString();
      Uint8List bytes = File(path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        print(table); //sheet Name
        List listOfAllDataFromExcel = [];
        for (var row in excel[table].rows) {
          listOfAllDataFromExcel.add(row);
        }
        // print(listOfAllDataFromExcel.length);
        // print('listOfAllDataFromExcel 4 is equal to ......................................  ${listOfAllDataFromExcel[4]}');
        //
        // // print(listOfAllDataFromExcel[4].length);

        List listFromExcelOnlyValue = [];
        List listOF =
            List.generate(listOfAllDataFromExcel.length, (index) => []);
        for (int i = 0; i < listOfAllDataFromExcel.length; i++) {
          for (int j = 0; j < listOfAllDataFromExcel[i].length; j++) {
            if (listOfAllDataFromExcel[i][j] == null) {
              listOF[i].add('');
            } else {
              Data data = listOfAllDataFromExcel[i][j];
              listOF[i]
                  .add(data.value.toString().trim().trimRight().trimLeft());
            }
          }
          listFromExcelOnlyValue.add(listOF[i]);
        }

        print(
            '.... ${listFromExcelOnlyValue.length} ...$listFromExcelOnlyValue');
        //
        List listOFKeyName = listFromExcelOnlyValue[0];

        List listOfFinalDataOfStudent =
            List.generate(listFromExcelOnlyValue.length - 1, (index) => []);
        for (int i = 1; i < listFromExcelOnlyValue.length; i++) {
          for (int j = 0; j < listOFKeyName.length; j++) {
            listOfFinalDataOfStudent[i - 1].add({
              listOFKeyName[j]: listFromExcelOnlyValue[i][j].toString().trim()
            });
          }
        }
        // print(listOfFinalDataOfStudent.length);
        print(listOfFinalDataOfStudent);
        int recordUpdate = 0;
        int recordInsert = 0;
        int recordReject = 0;

        /// insert into dataBase in sql ///////////////////////////
        for (int i = 0; i < listOfFinalDataOfStudent.length; i++) {
          // print(
          //     '..${dataOFAllStudent.length}......${listOfFinalDataOfStudent[i][3]['GRN']}');

          if (listOfFinalDataOfStudent[i][3]['GRN'].toString().length > 0) {
            List dataOFAllStudent = await _schoolSQL.dataForAllStudentForImport(
                listOfFinalDataOfStudent[i][3]['GRN']);
            if (dataOFAllStudent.length > 0) {
              recordUpdate = recordUpdate + 1;
              // statusOfInsertingIntoDatabase.add(
              //   'row  ${i + 2} is Update  grn =${listOfFinalDataOfStudent[i][3]['GRN']}');
              print(
                  '.........................update........${listOfFinalDataOfStudent[i][5]['StudentName']}.......................');
              await _schoolSQL.updateSch9AdmissionByImportFromExcel(
                AdmissionDate: listOfFinalDataOfStudent[i][2]['AdmissionDate'],
                GRN: listOfFinalDataOfStudent[i][3]['GRN'],
                FamilyGroupNo: listOfFinalDataOfStudent[i][4]['FamilyGroupNo'],
                StudentName: listOfFinalDataOfStudent[i][5]['StudentName'],
                DateOfBirth: listOfFinalDataOfStudent[i][6]['DateOfBirth'],
                StudentMobileNo: listOfFinalDataOfStudent[i][7]
                    ['StudentMobileNo'],
                Address: listOfFinalDataOfStudent[i][8]['Address'],
                AddressPhoneNo: listOfFinalDataOfStudent[i][9]
                    ['AddressPhoneNo'],
                FahterName: listOfFinalDataOfStudent[i][10]['FahterName'],
                FatherMobileNo: listOfFinalDataOfStudent[i][11]
                    ['FatherMobileNo'],
                FatherNIC: listOfFinalDataOfStudent[i][12]['FatherNIC'],
                FatherProfession: listOfFinalDataOfStudent[i][13]
                    ['FatherProfession'],
                MotherName: listOfFinalDataOfStudent[i][14]['MotherName'],
                MotherMobileNo: listOfFinalDataOfStudent[i][15]
                    ['MotherMobileNo'],
                MotherNIC: listOfFinalDataOfStudent[i][16]['MotherNIC'],
                MotherProfession: listOfFinalDataOfStudent[i][17]
                    ['MotherProfession'],
                OtherDetail: listOfFinalDataOfStudent[i][18]['OtherDetail'],
                AdmissionRemarks: listOfFinalDataOfStudent[i][19]
                    ['AdmissionRemarks'],
                GuardianName: listOfFinalDataOfStudent[i][20]['GuardianName'],
                GuardianMobileNo: listOfFinalDataOfStudent[i][21]
                    ['GuardianMobileNo'],
                GuardianNIC: listOfFinalDataOfStudent[i][22]['GuardianNIC'],
                GuardianProfession: listOfFinalDataOfStudent[i][23]
                    ['GuardianProfession'],
                GuardianRelatiion: listOfFinalDataOfStudent[i][24]
                    ['GuardianRelatiion'],
                LeavingDate: listOfFinalDataOfStudent[i][25]['LeavingDate'],
                LeavingRemarks: listOfFinalDataOfStudent[i][26]
                    ['LeavingRemarks'],
              );
            } else {
              // statusOfInsertingIntoDatabase.add(
              //     'row   ${i + 2} is insert  grn =${listOfFinalDataOfStudent[i][3]['GRN']}');

              recordInsert = recordInsert + 1;
              print(
                  '.........................insert...............................');
              await _schoolSQL.insertSch9Admission(
                context: context,
                AdmissionDate: listOfFinalDataOfStudent[i][2]['AdmissionDate'],
                GRN: listOfFinalDataOfStudent[i][3]['GRN'],
                FamilyGroupNo: listOfFinalDataOfStudent[i][4]['FamilyGroupNo'],
                StudentName: listOfFinalDataOfStudent[i][5]['StudentName'],
                DateOfBirth: listOfFinalDataOfStudent[i][6]['DateOfBirth'],
                StudentMobileNo: listOfFinalDataOfStudent[i][7]
                    ['StudentMobileNo'],
                Address: listOfFinalDataOfStudent[i][8]['Address'],
                AddressPhoneNo: listOfFinalDataOfStudent[i][9]
                    ['AddressPhoneNo'],
                FahterName: listOfFinalDataOfStudent[i][10]['FahterName'],
                FatherMobileNo: listOfFinalDataOfStudent[i][11]
                    ['FatherMobileNo'],
                FatherNIC: listOfFinalDataOfStudent[i][12]['FatherNIC'],
                FatherProfession: listOfFinalDataOfStudent[i][13]
                    ['FatherProfession'],
                MotherName: listOfFinalDataOfStudent[i][14]['MotherName'],
                MotherMobileNo: listOfFinalDataOfStudent[i][15]
                    ['MotherMobileNo'],
                MotherNIC: listOfFinalDataOfStudent[i][16]['MotherNIC'],
                MotherProfession: listOfFinalDataOfStudent[i][17]
                    ['MotherProfession'],
                OtherDetail: listOfFinalDataOfStudent[i][18]['OtherDetail'],
                AdmissionRemarks: listOfFinalDataOfStudent[i][19]
                    ['AdmissionRemarks'],
                GuardianName: listOfFinalDataOfStudent[i][20]['GuardianName'],
                GuardianMobileNo: listOfFinalDataOfStudent[i][21]
                    ['GuardianMobileNo'],
                GuardianNIC: listOfFinalDataOfStudent[i][22]['GuardianNIC'],
                GuardianProfession: listOfFinalDataOfStudent[i][23]
                    ['GuardianProfession'],
                GuardianRelatiion: listOfFinalDataOfStudent[i][24]
                    ['GuardianRelatiion'],
                LeavingDate: listOfFinalDataOfStudent[i][25]['LeavingDate'],
                LeavingRemarks: listOfFinalDataOfStudent[i][26]
                    ['LeavingRemarks'],
              );
            }
          } else {
            recordReject = recordReject + 1;
            //  statusOfInsertingIntoDatabase.add(
            //      'row   ${i + 2}  is rejected Due to Grn is Empty');
          }
        }
        Constants.hideDialog(context);
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: SizedBox(
                  height: 150,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Total Record Inserted   $recordInsert'),
                        Text('Total Record Updated   $recordUpdate'),
                        Text('Total Record Rejected   $recordReject'),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Ok')))
                      ],
                    )),
                  ),
                ),
              );
            });
      }
    }
  }

  void exportINExcel(BuildContext MainContext) async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    } else {
      _excelFileNameController.text = 'StudentInfo';
      checkValueForGroupName = '.xlsx';

      showDialog(
          context: MainContext,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, state) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SizedBox(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: _excelFileNameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Name of file')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Radio<String>(
                                          groupValue: checkValueForGroupName,
                                          value: checkValueForXLS,
                                          onChanged: (value) {
                                            state(() {
                                              checkValueForGroupName = value!;
                                            });
                                          }),
                                      Text('XLS')
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Radio<String>(
                                          groupValue: checkValueForGroupName,
                                          value: checkValueForXLSX,
                                          onChanged: (value) {
                                            state(() {
                                              checkValueForGroupName = value!;
                                            });
                                          }),
                                      FittedBox(child: Text('XLSX'))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Radio<String>(
                                          groupValue: checkValueForGroupName,
                                          value: checkValueForCSV,
                                          onChanged: (value) {
                                            state(() {
                                              checkValueForGroupName = value!;
                                            });
                                          }),
                                      FittedBox(child: Text('CSV'))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          var excel = Excel.createExcel();
                                          List<List> allDataInRow = [];
                                          List dataOFAllStudent =
                                              await _schoolSQL
                                                  .dataForAllStudentForExport();

                                          if (dataOFAllStudent.isNotEmpty) {
                                            Map allCOlName =
                                                dataOFAllStudent[0];

                                            List<String> data =
                                                allCOlName.keys as List<String>;
                                            allDataInRow.add(data);
                                            for (int i = 0;
                                                i < dataOFAllStudent.length;
                                                i++) {
                                              List<String> singleValue = [];
                                              Map allCOlvalue =
                                                  dataOFAllStudent[i];

                                              allCOlvalue.values
                                                  .forEach((element) {
                                                singleValue
                                                    .add(element.toString());
                                              });

                                              allDataInRow.add(singleValue);
                                            }
                                            Sheet sheetObject = excel["Sheet1"];
                                            for (int i = 0;
                                                i < allDataInRow.length;
                                                i++) {
                                              // sheetObject
                                              //     .appendRow(allDataInRow[i]);
                                            }
                                            String? selectedDirectory =
                                                await FilePicker.platform
                                                    .getDirectoryPath();
                                            final path =
                                                "$selectedDirectory/${_excelFileNameController.text.toString().trim()}$checkValueForGroupName";

                                            final File file = File(path);

                                            var list = excel.encode();
                                            file
                                              ..createSync(recursive: true)
                                              ..writeAsBytesSync(list!);

                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(MainContext)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text('NO Data available'),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        },
                                        child: Text('Export All Student')),
                                    TextButton(
                                        onPressed: () async {
                                          var excel = Excel.createExcel();
                                          List<List> allDataInRow = [];
                                          List dataOFAllStudent =
                                              await _schoolSQL
                                                  .dataForAllPresentStudent();

                                          if (dataOFAllStudent.isNotEmpty) {
                                            Map allCOlName =
                                                dataOFAllStudent[0];

                                            List<String> data =
                                                allCOlName.keys as List<String>;
                                            allDataInRow.add(data);
                                            for (int i = 0;
                                                i < dataOFAllStudent.length;
                                                i++) {
                                              List<String> singleValue = [];
                                              Map allCOlvalue =
                                                  dataOFAllStudent[i];

                                              allCOlvalue.values
                                                  .forEach((element) {
                                                singleValue
                                                    .add(element.toString());
                                              });

                                              allDataInRow.add(singleValue);
                                            }
                                            Sheet sheetObject = excel["Sheet1"];
                                            for (int i = 0;
                                                i < allDataInRow.length;
                                                i++) {
                                              // sheetObject
                                              //     .appendRow(allDataInRow[i]);
                                            }
                                            String? selectedDirectory =
                                                await FilePicker.platform
                                                    .getDirectoryPath();
                                            final path =
                                                "$selectedDirectory/${_excelFileNameController.text.toString().trim()}$checkValueForGroupName";

                                            final File file = File(path);

                                            var list = excel.encode();
                                            file
                                              ..createSync(recursive: true)
                                              ..writeAsBytesSync(list!);

                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(MainContext)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text('NO Data available'),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        },
                                        child: Text('Export Present Student')),
                                    TextButton(
                                        onPressed: () async {
                                          var excel = Excel.createExcel();
                                          List<List> allDataInRow = [];
                                          List dataOFAllStudent = await _schoolSQL
                                              .dataForAllStudentClosedAdmission();

                                          if (dataOFAllStudent.isNotEmpty) {
                                            Map allCOlName =
                                                dataOFAllStudent[0];

                                            List<String> data =
                                                allCOlName.keys as List<String>;
                                            allDataInRow.add(data);
                                            for (int i = 0;
                                                i < dataOFAllStudent.length;
                                                i++) {
                                              List<String> singleValue = [];
                                              Map allCOlvalue =
                                                  dataOFAllStudent[i];

                                              allCOlvalue.values
                                                  .forEach((element) {
                                                singleValue
                                                    .add(element.toString());
                                              });

                                              allDataInRow.add(singleValue);
                                            }
                                            Sheet sheetObject = excel["Sheet1"];
                                            for (int i = 0;
                                                i < allDataInRow.length;
                                                i++) {
                                              // sheetObject
                                              //     .appendRow(allDataInRow[i]);
                                            }
                                            String? selectedDirectory =
                                                await FilePicker.platform
                                                    .getDirectoryPath();
                                            final path =
                                                "$selectedDirectory/${_excelFileNameController.text.toString().trim()}$checkValueForGroupName";

                                            final File file = File(path);

                                            var list = excel.encode();
                                            file
                                              ..createSync(recursive: true)
                                              ..writeAsBytesSync(list!);

                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(MainContext)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text('NO Data available'),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        },
                                        child: Text('Export Closed Student')),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
    }
  }
}
