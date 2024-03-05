import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../school/send_whatapp_student.dart';

class PrintPage extends StatefulWidget {
  final Map data;
  final bool captureScreenShot;

  PrintPage({
    super.key,
    required this.data,
    this.captureScreenShot=false
  });

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {


  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      _executeFunctionIfTrue(widget.captureScreenShot);

    });

  }

  void _executeFunctionIfTrue(bool shouldExecute) {
    if (shouldExecute) {
      _captureScreenShotAndShareToWhatsApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: _builtUI(),
        ),
      ),
    );
  }

  Widget _builtUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      // await screenshotController
                      //     .capture()
                      //     .then((value) {
                      //   _imageFile = value!;
                      // });
                      //
                      // print(_imageFile);
                      //
                      // final image = pw.MemoryImage(_imageFile!);
                      //
                      // final pdf = pw.Document();
                      //
                      // pdf.addPage(pw.Page(
                      //     pageFormat: PdfPageFormat.a4,
                      //     build: (pw.Context context) {
                      //       return pw.Center(child: pw.Image(image));
                      //     })); // P
                      //
                      // Navigator.pushNamed(context, '/pdf_preview_page',
                      //     arguments: pdf);
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}',
                      height: 60,
                      width: 60,
                      alignment: Alignment.center,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/easysoft_logo.jpg',
                        alignment: Alignment.center,
                        height: 50,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyName)!}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyNumber)!}',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyAddress)!}',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
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
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )),
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'Print date : ${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(DateTime.now().toString().substring(0, 4)), int.parse(DateTime.now().toString().substring(
                      5,
                      7,
                    )), int.parse(DateTime.now().toString().substring(8, 10)))).toString()}',
                style: TextStyle(fontSize: 16),
              ),
            )),
        Text(
          'Order',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          'Order Date : ${widget.data['OrderDate'].toString() == "" ? '' : DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['OrderDate'].toString().substring(0, 4)), int.parse(widget.data['OrderDate'].toString().substring(
                5,
                7,
              )), int.parse(widget.data['OrderDate'].toString().substring(8, 10)))).toString()}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Delivery Date : ${widget.data['DeliveryDate'].toString() == "" ? '' : DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['DeliveryDate'].toString().substring(0, 4)), int.parse(widget.data['DeliveryDate'].toString().substring(
                5,
                7,
              )), int.parse(widget.data['DeliveryDate'].toString().substring(8, 10)))).toString()}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Delivered Date : ${widget.data['DeliveredDate'].toString() == "" ? '' : DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['DeliveredDate'].toString().substring(0, 4)), int.parse(widget.data['DeliveredDate'].toString().substring(
                5,
                7,
              )), int.parse(widget.data['DeliveredDate'].toString().substring(8, 10)))).toString()}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Name Of Person : ',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Mobile Number : ${widget.data['CustomerMobileNo']}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Job Title : ${widget.data['OrderTitle']}',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Details : ${widget.data['OBRemarks']}',
          style: TextStyle(fontSize: 14),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bill Amount',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '${widget.data['BillAmount']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Received',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '${widget.data['TotalReceived']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Balance',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '${widget.data['BillBalance']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        const Spacer(),
        Center(
            child: Text(
          'Printed by EasySoft App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ))
      ],
    );
  }

  void _captureScreenShotAndShareToWhatsApp() async {
    return await screenshotController
        .captureFromWidget(
      Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _builtUI(),
        ),
      ),
    )
        .then((Uint8List capturedImage) async {
      final directory = await getExternalStorageDirectory();
      final imagePath = await File(
        '${directory!.path}/${DateTime.now().microsecondsSinceEpoch}image.png',
      );
      await imagePath.writeAsBytes(capturedImage);

      await WhatsappShare.shareFile(
        filePath: [imagePath.path],
        phone: '923138934156',
      );
    });
  }
}

