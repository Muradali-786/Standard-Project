import 'dart:io';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../material/printer_conection.dart';
import '../material/token_size_print.dart';

Future<pw.Document> generatePDFFREEREC(
  List slipInfoOfREc,
) async {
  String feeRemarksController = '';
  Set<String> allGRNIDINLIST = {};
  List singleListOfStudent = [];
  List singleStudentINList = [];

  double grandTotal = 0;

  feeRemarksController = slipInfoOfREc[0]['FeeRecRemarks'];
  for (int i = 0; i < slipInfoOfREc.length; i++) {
    allGRNIDINLIST.add(slipInfoOfREc[i]['GRN'].toString());

    grandTotal += double.parse(slipInfoOfREc[i]['RecAmount'].toString());
  }
  for (int i = 0; i < allGRNIDINLIST.length; i++) {
    for (int j = 0; j < slipInfoOfREc.length; j++) {
      if (allGRNIDINLIST.elementAt(i) == slipInfoOfREc[j]['GRN']) {
        singleStudentINList.add(slipInfoOfREc[j]);
        break;
      }
    }
  }

  List grnListFOrSingleStudent(String grn) {
    singleListOfStudent.clear();
    for (int i = 0; i < slipInfoOfREc.length; i++) {
      if (slipInfoOfREc[i]['GRN'] == grn) {
        singleListOfStudent.add(slipInfoOfREc[i]);
      }
    }

    return singleListOfStudent;
  }

  final pdf = pw.Document();
  final netImage = await networkImage(
      'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}');

  pdf.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    build: (context) => [
      pw.Center(
        child: pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8.0, left: 12, right: 12),
          child: pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(netImage, height: 50),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 12.0),
                      child: pw.Align(
                        alignment: pw.Alignment.topCenter,
                        child: pw.Text(
                          '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyName)!}',
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 12.0),
                      child: pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyNumber)!}',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 12.0),
                      child: pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyAddress)!}',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 6.0, left: 8, right: 8),
        child: pw.Align(
          alignment: pw.Alignment.topCenter,
          child: pw.Text(
            'Fee Receipt',
            style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold),
          ),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 8.0, left: 16, right: 16),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                pw.Text(
                  'Receipt ID :',
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  slipInfoOfREc[0]['FeeRec1ID'].toString(),
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Text(
                  'Date :',
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(slipInfoOfREc[0]['FeeRecDate'].toString().substring(0, 4)), int.parse(slipInfoOfREc[0]['FeeRecDate'].toString().substring(
                        5,
                        7,
                      )), int.parse(slipInfoOfREc[0]['FeeRecDate'].toString().substring(8, 10)))).toString()}',
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 4.0),
        child: pw.Text(feeRemarksController.toString()),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 8.0),
        child: pw.ListView.builder(
          itemCount: allGRNIDINLIST.length,
          itemBuilder: (context, indexOFGRN) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Column(
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(4.0),
                      child: pw.Container(
                          //height: 50,

                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Text(
                                      'GRN : ',
                                      style: pw.TextStyle(
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                    pw.Text(
                                      allGRNIDINLIST.elementAt(indexOFGRN),
                                      style: pw.TextStyle(
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                    pw.Padding(
                                      padding:
                                          const pw.EdgeInsets.only(left: 8.0),
                                      child: pw.Text(
                                        'Family Code :',
                                        style: pw.TextStyle(
                                            fontSize: 15,
                                            fontWeight: pw.FontWeight.bold),
                                      ),
                                    ),
                                    pw.Text(
                                      singleStudentINList[indexOFGRN]
                                              ['FamilyGroupNo']
                                          .toString(),
                                      style: pw.TextStyle(
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold),
                                    )
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text(
                                      'Student Name : ',
                                      style: pw.TextStyle(
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                    pw.Text(
                                      singleStudentINList[indexOFGRN]
                                              ['StudentName']
                                          .toString(),
                                      style: pw.TextStyle(
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text('Father Name : '),
                                    pw.Text(singleStudentINList[indexOFGRN]
                                            ['FahterName']
                                        .toString()),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text('Mother Name : '),
                                    pw.Text(singleStudentINList[indexOFGRN]
                                            ['MotherName']
                                        .toString()),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  pw.ListView.builder(
                    itemCount: grnListFOrSingleStudent(
                            allGRNIDINLIST.elementAt(indexOFGRN))
                        .length,
                    itemBuilder: (context, index) => pw.Center(
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 8.0),
                        child: pw.Container(
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Text('Fee Narration : '),
                                    pw.Text(grnListFOrSingleStudent(
                                                allGRNIDINLIST.elementAt(
                                                    indexOFGRN))[index]
                                            ['FeeNarration']
                                        .toString())
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text('Section : '),
                                    pw.Text(grnListFOrSingleStudent(
                                                allGRNIDINLIST.elementAt(
                                                    indexOFGRN))[index]
                                            ['SectionName']
                                        .toString())
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text('Class : '),
                                    pw.Text(grnListFOrSingleStudent(
                                            allGRNIDINLIST.elementAt(
                                                indexOFGRN))[index]['ClassName']
                                        .toString())
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text('Year : '),
                                    pw.Text(grnListFOrSingleStudent(
                                                allGRNIDINLIST.elementAt(
                                                    indexOFGRN))[index]
                                            ['EducationalYear']
                                        .toString())
                                  ],
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 8.0),
                                  child: pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Due Amount : ',
                                            style: pw.TextStyle(
                                                fontSize: 15,
                                                fontWeight: pw.FontWeight.bold),
                                          ),
                                          pw.Text(
                                            grnListFOrSingleStudent(
                                                        allGRNIDINLIST
                                                            .elementAt(
                                                                indexOFGRN))[
                                                    index]['FeeDueAmount']
                                                .toString(),
                                            style: pw.TextStyle(
                                                fontSize: 15,
                                                fontWeight: pw.FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Received : ',
                                            style: pw.TextStyle(
                                                fontSize: 15,
                                                fontWeight: pw.FontWeight.bold),
                                          ),
                                          pw.Text(
                                            grnListFOrSingleStudent(
                                                        allGRNIDINLIST
                                                            .elementAt(
                                                                indexOFGRN))[
                                                    index]['RecAmount']
                                                .toString(),
                                            style: pw.TextStyle(
                                                fontSize: 15,
                                                fontWeight: pw.FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8.0),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              'Total Received: ',
              style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              grandTotal.toString(),
              style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold),
            )
          ],
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(left: 8.0, right: 8),
        child: pw.Divider(),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(left: 8.0, right: 8),
        child: pw.Row(
          children: [
            pw.Text('Print Time : '),
            pw.Text(DateTime.now().toString().substring(0, 19)),
          ],
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(left: 8.0, right: 8),
        child: pw.Row(
          children: [
            pw.Text('Powered By : '),
            pw.Text('https//:esaysoftapp.com'),
          ],
        ),
      ),
    ],
  ));

  return pdf;
}

feeRecShare({
  required List list,
  required String number,
}) async {
  String numberWithOutPLus;
  var pdf = await generatePDFFREEREC(list);
  final directory = await getExternalStorageDirectory();
  final path = await File(
      '${directory!.path}/${DateTime.now().microsecondsSinceEpoch}.pdf');
  await path.writeAsBytes(await pdf.save());

  if (number.characters.first == "+") {
    numberWithOutPLus = number.substring(1, number.length);
  } else {
    numberWithOutPLus = number;
  }

  await WhatsappShare.shareFile(
    filePath: [path.path],
    phone: numberWithOutPLus,
  );
}

BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

feeRecPrint({
  required BuildContext context,
  required List slipInfoOfREc,
}) async {
  String feeRemarksController = '';
  Set<String> allGRNIDINLIST = {};
  List singleListOfStudent = [];
  List singleStudentINList = [];

  double grandTotal = 0;

  feeRemarksController = slipInfoOfREc[0]['FeeRecRemarks'];
  for (int i = 0; i < slipInfoOfREc.length; i++) {
    allGRNIDINLIST.add(slipInfoOfREc[i]['GRN'].toString());

    grandTotal += double.parse(slipInfoOfREc[i]['RecAmount'].toString());
  }
  for (int i = 0; i < allGRNIDINLIST.length; i++) {
    for (int j = 0; j < slipInfoOfREc.length; j++) {
      if (allGRNIDINLIST.elementAt(i) == slipInfoOfREc[j]['GRN']) {
        singleStudentINList.add(slipInfoOfREc[j]);
        break;
      }
    }
  }

  List grnListFOrSingleStudent(String grn) {
    singleListOfStudent.clear();
    for (int i = 0; i < slipInfoOfREc.length; i++) {
      if (slipInfoOfREc[i]['GRN'] == grn) {
        singleListOfStudent.add(slipInfoOfREc[i]);
      }
    }

    return singleListOfStudent;
  }

  bool? isConnected = await bluetooth.isConnected;

  if (isConnected!) {
    bluetooth.printCustom(
        '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyName)!}',
        SizeToken.medium.val,
        AlignToken.left.val);
    bluetooth.printCustom(
        '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyNumber)!}',
        SizeToken.medium.val,
        AlignToken.left.val);
    bluetooth.printCustom(
        '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyAddress)!}',
        SizeToken.medium.val,
        AlignToken.left.val);

    bluetooth.printCustom(
        '-------------------',
        SizeToken.medium.val,
        AlignToken.center.val);

    bluetooth.printCustom(
        'Fee Receipt',
        SizeToken.boldLarge.val,
        AlignToken.center.val);
    bluetooth.printCustom(
        'Receipt ID : ${slipInfoOfREc[0]['FeeRec1ID'].toString()}',
        SizeToken.medium.val,
        AlignToken.right.val);
    bluetooth.printCustom(
        'Date : ${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(slipInfoOfREc[0]['FeeRecDate'].toString().substring(0, 4)), int.parse(slipInfoOfREc[0]['FeeRecDate'].toString().substring(
          5,
          7,
        )), int.parse(slipInfoOfREc[0]['FeeRecDate'].toString().substring(8, 10)))).toString()}',
        SizeToken.medium.val,
        AlignToken.right.val);
    bluetooth.printCustom(
        '${feeRemarksController.toString()}',
        SizeToken.medium.val,
        AlignToken.center.val);

    bluetooth.printCustom(
        '-------------------',
        SizeToken.medium.val,
        AlignToken.center.val);

    for(int indexOFGRN = 0 ; indexOFGRN < allGRNIDINLIST.length ; indexOFGRN++){
      bluetooth.printCustom(
          'GRN : ${allGRNIDINLIST.elementAt(indexOFGRN)}',
          SizeToken.medium.val,
          AlignToken.left.val);
      bluetooth.printCustom(
          'Family Code : ${singleStudentINList[indexOFGRN]
          ['FamilyGroupNo']}',
          SizeToken.medium.val,
          AlignToken.left.val);
      bluetooth.printCustom(
          'Student Name : ${ singleStudentINList[indexOFGRN]
          ['StudentName']}',
          SizeToken.medium.val,
          AlignToken.left.val);
      bluetooth.printCustom(
          'Father Name : ${singleStudentINList[indexOFGRN]
          ['FahterName']}',
          SizeToken.medium.val,
          AlignToken.left.val);
      bluetooth.printCustom(
          'Mother Name : ${singleStudentINList[indexOFGRN]
          ['MotherName']}',
          SizeToken.medium.val,
          AlignToken.left.val);

      bluetooth.printCustom(
          '-------------------',
          SizeToken.medium.val,
          AlignToken.center.val);


      for(int index = 0 ; index < grnListFOrSingleStudent(
          allGRNIDINLIST.elementAt(indexOFGRN))
          .length ; index++){
        bluetooth.printCustom(
            'Fee Narration : ${grnListFOrSingleStudent(
                allGRNIDINLIST.elementAt(
                    indexOFGRN))[index]
            ['FeeNarration']
                .toString()}',
            SizeToken.medium.val,
            AlignToken.left.val);
        bluetooth.printCustom(
            'Section : ${grnListFOrSingleStudent(
                allGRNIDINLIST.elementAt(
                    indexOFGRN))[index]
            ['SectionName']
                .toString()}',
            SizeToken.medium.val,
            AlignToken.left.val);
        bluetooth.printCustom(
            'Class : ${grnListFOrSingleStudent(
                allGRNIDINLIST.elementAt(
                    indexOFGRN))[index]['ClassName']
                .toString()}',
            SizeToken.medium.val,
            AlignToken.left.val);
        bluetooth.printCustom(
            'Year : ${grnListFOrSingleStudent(
                allGRNIDINLIST.elementAt(
                    indexOFGRN))[index]
            ['EducationalYear']
                .toString()}',
            SizeToken.medium.val,
            AlignToken.left.val);
        bluetooth.printCustom(
            'Due Amount : ${grnListFOrSingleStudent(
                allGRNIDINLIST
                    .elementAt(
                    indexOFGRN))[
            index]['FeeDueAmount']
                .toString()}',
            SizeToken.boldLarge.val,
            AlignToken.right.val);
        bluetooth.printCustom(
            'Received : ${grnListFOrSingleStudent(
                allGRNIDINLIST
                    .elementAt(
                    indexOFGRN))[
            index]['RecAmount']
                .toString()}',
            SizeToken.boldLarge.val,
            AlignToken.right.val);


        bluetooth.printCustom(
            '-------------------',
            SizeToken.medium.val,
            AlignToken.center.val);

      }
    }


    bluetooth.printCustom(
        'Total Received : ${grandTotal.toString()}',
        SizeToken.boldLarge.val,
        AlignToken.right.val);

    bluetooth.printCustom(
        '-------------------',
        SizeToken.medium.val,
        AlignToken.center.val);

    bluetooth.printCustom(
        'Print Time : ${DateTime.now().toString().substring(0, 19)}',
        SizeToken.medium.val,
        AlignToken.left.val);
    bluetooth.printCustom(
        'Powered By : https//:esaysoftapp.com',
        SizeToken.medium.val,
        AlignToken.left.val);

    bluetooth.printNewLine();
    bluetooth.printNewLine();
  } else {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              width: MediaQuery.of(context).size.width,
              child: PrinterConnection(),
            ),
          ),
        ),
      ),
    );
  }
}



// class FeeREcSlip extends StatefulWidget {
//   final List slipInfoOfREc;
//
//   const FeeREcSlip({Key? key, required this.slipInfoOfREc}) : super(key: key);
//
//   @override
//   State<FeeREcSlip> createState() => _FeeREcSlipState();
// }
//
// class _FeeREcSlipState extends State<FeeREcSlip> {
//   ScreenshotController screenshotController = ScreenshotController();
//   String feeRemarksController = '';
//   Set<String> allGRNIDINLIST = {};
//   List singleListOfStudent = [];
//   List singleStudentINList = [];
//
//   double grandTotal = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     print(widget.slipInfoOfREc);
//
//     feeRemarksController = widget.slipInfoOfREc[0]['FeeRecRemarks'];
//     for (int i = 0; i < widget.slipInfoOfREc.length; i++) {
//       allGRNIDINLIST.add(widget.slipInfoOfREc[i]['GRN'].toString());
//
//       grandTotal +=
//           double.parse(widget.slipInfoOfREc[i]['RecAmount'].toString());
//     }
//     for (int i = 0; i < allGRNIDINLIST.length; i++) {
//       for (int j = 0; j < widget.slipInfoOfREc.length; j++) {
//         if (allGRNIDINLIST.elementAt(i) == widget.slipInfoOfREc[j]['GRN']) {
//           singleStudentINList.add(widget.slipInfoOfREc[j]);
//           break;
//         }
//       }
//     }
//   }
//
//   List grnListFOrSingleStudent(String grn) {
//     singleListOfStudent.clear();
//     for (int i = 0; i < widget.slipInfoOfREc.length; i++) {
//       if (widget.slipInfoOfREc[i]['GRN'] == grn) {
//         singleListOfStudent.add(widget.slipInfoOfREc[i]);
//       }
//     }
//
//     return singleListOfStudent;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: SafeArea(
//         child: Screenshot(
//           controller: screenshotController,
//           child: Container(
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.only(top: 8.0, left: 12, right: 12),
//                     child: Container(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           InkWell(
//                             onTap: () async {
//                               // Uint8List? image =
//                               //     await screenshotController.capture();
//                               //
//                               // screenshotController
//                               //     .captureFromWidget(Container(
//                               //   color: Colors.white,
//                               //   child: Padding(
//                               //     padding:
//                               //     const EdgeInsets.all(16.0),
//                               //     child:
//                               //   ),
//                               // ))
//                               //     .then((Uint8List
//                               // capturedImage) async {
//                               //   final directory =
//                               //   await getExternalStorageDirectory();
//                               //   final imagePath = await File(
//                               //       '${directory!.path}/${DateTime.now().microsecondsSinceEpoch}image.png');
//                               //   await imagePath
//                               //       .writeAsBytes(capturedImage);
//                               //
//                               //   await WhatsappShare.shareFile(
//                               //     filePath: [imagePath.path],
//                               //     phone: '923041810687',
//                               //   );
//                               //
//                               //   // Handle captured image
//                               // });
//
//                               // bluetooth.
//                               //
//                               //
//                               //
//                               //
//                               // final directory =
//                               //     await getExternalStorageDirectory();
//                               // final path = await File(
//                               //     '${directory!.path}/${DateTime.now().microsecondsSinceEpoch}.jpg');
//                               // await path.writeAsBytes(await image!);
//                               //
//                               // bluetooth.printImage(path.path);
//                               // //
//                               // // await WhatsappShare.shareFile(
//                               // //   filePath: [path.path],
//                               // //   phone: '03041810687',
//                               // // );
//                             },
//                             child: CachedNetworkImage(
//                               imageUrl:
//                                   'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}',
//                               height: 60,
//                               width: 60,
//                               alignment: Alignment.center,
//                               imageBuilder: (context, imageProvider) =>
//                                   Container(
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     image: imageProvider,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                               ),
//                               placeholder: (context, url) => Center(
//                                 child: CircularProgressIndicator(),
//                               ),
//                               errorWidget: (context, url, error) => Image.asset(
//                                 'assets/images/easysoft_logo.jpg',
//                                 alignment: Alignment.center,
//                                 height: 50,
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 12.0),
//                                 child: Align(
//                                   alignment: Alignment.topCenter,
//                                   child: Text(
//                                     '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyName)!}',
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 12.0),
//                                 child: Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(
//                                     '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyNumber)!}',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 12.0),
//                                 child: Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(
//                                     '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyAddress)!}',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8),
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: Text(
//                       'Fee Receipt',
//                       style:
//                           TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'Receipt ID :',
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             widget.slipInfoOfREc[0]['FeeRec1ID'].toString(),
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Date :',
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.slipInfoOfREc[0]['FeeRecDate'].toString().substring(0, 4)), int.parse(widget.slipInfoOfREc[0]['FeeRecDate'].toString().substring(
//                                   5,
//                                   7,
//                                 )), int.parse(widget.slipInfoOfREc[0]['FeeRecDate'].toString().substring(8, 10)))).toString()}',
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4.0),
//                   child: Text(feeRemarksController.toString()),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: allGRNIDINLIST.length,
//                     itemBuilder: (context, indexOFGRN) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(border: Border.all()),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Container(
//                                     //height: 50,
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration:
//                                         BoxDecoration(border: Border.all()),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 'GRN : ',
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               Text(
//                                                 allGRNIDINLIST
//                                                     .elementAt(indexOFGRN),
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 8.0),
//                                                 child: Text(
//                                                   'Family Code :',
//                                                   style: TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ),
//                                               Text(
//                                                 singleStudentINList[indexOFGRN]
//                                                         ['FamilyGroupNo']
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 'Student Name : ',
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               Text(
//                                                 singleStudentINList[indexOFGRN]
//                                                         ['StudentName']
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text('Father Name : '),
//                                               Text(singleStudentINList[
//                                                       indexOFGRN]['FahterName']
//                                                   .toString()),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text('Mother Name : '),
//                                               Text(singleStudentINList[
//                                                       indexOFGRN]['MotherName']
//                                                   .toString()),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     )),
//                               ),
//                             ),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: grnListFOrSingleStudent(
//                                       allGRNIDINLIST.elementAt(indexOFGRN))
//                                   .length,
//                               itemBuilder: (context, index) => Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration:
//                                         BoxDecoration(border: Border.all()),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text('Fee Narration : '),
//                                               Text(grnListFOrSingleStudent(
//                                                           allGRNIDINLIST
//                                                               .elementAt(
//                                                                   indexOFGRN))[
//                                                       index]['FeeNarration']
//                                                   .toString())
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text('Section : '),
//                                               Text(grnListFOrSingleStudent(
//                                                           allGRNIDINLIST
//                                                               .elementAt(
//                                                                   indexOFGRN))[
//                                                       index]['SectionName']
//                                                   .toString())
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text('Class : '),
//                                               Text(grnListFOrSingleStudent(
//                                                           allGRNIDINLIST
//                                                               .elementAt(
//                                                                   indexOFGRN))[
//                                                       index]['ClassName']
//                                                   .toString())
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text('Year : '),
//                                               Text(grnListFOrSingleStudent(
//                                                           allGRNIDINLIST
//                                                               .elementAt(
//                                                                   indexOFGRN))[
//                                                       index]['EducationalYear']
//                                                   .toString())
//                                             ],
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(top: 8.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       'Due Amount : ',
//                                                       style: TextStyle(
//                                                           fontSize: 15,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     Text(
//                                                       grnListFOrSingleStudent(
//                                                                   allGRNIDINLIST
//                                                                       .elementAt(
//                                                                           indexOFGRN))[
//                                                               index]['FeeDueAmount']
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                           fontSize: 15,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     )
//                                                   ],
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       'Received : ',
//                                                       style: TextStyle(
//                                                           fontSize: 15,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     Text(
//                                                       grnListFOrSingleStudent(
//                                                                   allGRNIDINLIST
//                                                                       .elementAt(
//                                                                           indexOFGRN))[
//                                                               index]['RecAmount']
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                           fontSize: 15,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         'Total Received: ',
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         grandTotal.toString(),
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0, right: 8),
//                   child: Divider(
//                     color: Colors.black,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0, right: 8),
//                   child: Row(
//                     children: [
//                       Text('Print Time : '),
//                       Text(DateTime.now().toString().substring(0, 19)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0, right: 8),
//                   child: Row(
//                     children: [
//                       Text('Powered By : '),
//                       Text('https//:esaysoftapp.com'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
