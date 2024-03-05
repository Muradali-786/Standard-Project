import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:com/pages/general_trading/SalePur/sale_pur1_SQL.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
import '../../../material/printer_conection.dart';
import 'generate_pdf.dart';

class PrintInvoicePage extends StatefulWidget {
  final String invoiceId, billAmount;
  final bool captureSs;
  final bool printInvoice;
  const PrintInvoicePage({
    super.key,
    required this.invoiceId,
    this.billAmount = '',
    this.captureSs = false,
    this.printInvoice = false,
  });

  @override
  State<PrintInvoicePage> createState() => _PrintInvoicePageState();
}

class _PrintInvoicePageState extends State<PrintInvoicePage> {
  SalePurSQLDataBase _salePurDb = SalePurSQLDataBase();
  final PdfServices _pdfServices = PdfServices();
  ScreenshotController screenshotController = ScreenshotController();



  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  late double h;
  late double w;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (widget.printInvoice) {
        _printInvoice(context);
      } else if (widget.captureSs) {
        _captureScreenShotAndShareToWhatsApp(context);
        // sharePdf();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _builtUI(),
      ),
    );
  }

  void sharePdf() async {
    List<dynamic> data1 =
        await _salePurDb.getDataForSalePurchaseRecordToPrintInvoice(
            salesInvoiceId: widget.invoiceId);

    final data = await _pdfServices.generatePdf(
        data: data1, billAmount: widget.billAmount);
    final directory = await getExternalStorageDirectory();
    final pdfPath = await File(
      '${directory!.path}/${DateTime.now().microsecondsSinceEpoch}document.pdf',
    );
    await pdfPath.writeAsBytes(data);

    await WhatsappShare.shareFile(
      filePath: [pdfPath.path],
      phone: '923185583779',
    );
  }

  Widget _builtUI() {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return FutureBuilder<List<dynamic>>(
        future: _salePurDb.getDataForSalePurchaseRecordToPrintInvoice(
            salesInvoiceId: widget.invoiceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('loading');
          } else if (snapshot.hasError) {
            return Text('error');
          } else {
            final data = snapshot.data!;
            print(data);
            return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  final resp = data[index];
                  final subData = data;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _logoAndCompanyName(
                          resp['AcMobileNo'].toString(),
                          resp['AcAddress'].toString(),
                        ),
                        SizedBox(height: h * 0.02),
                        _saleInvoiceAndPrint(
                          resp['SPDate'].toString(),
                        ),
                        SizedBox(height: h * 0.02),
                        _accountCashAndRemark(
                          resp['AccountName'],
                          resp['Remarks'],
                        ),
                        SizedBox(height: h * 0.02),
                        _itemAndTotal(),
                        SizedBox(height: h * 0.02),
                        _itemTable(
                          data.length, //this for item table length
                          subData,
                        ),
                        SizedBox(height: h * 0.02),
                        _total(widget.billAmount),
                        SizedBox(height: h * 0.01),
                        Text(
                          'Terms And Condition',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        _termAndConditionDescription(
                            '1', 'Shop policies: please read'),
                        _termAndConditionDescription(
                            '2', 'Customer satisfaction is our priority.'),
                        _termAndConditionDescription(
                            '3', 'Easy exchanges, no hassles'),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        _easySoftStamp(),
                      ],
                    ),
                  );
                });
          }
        });
  }

  Widget _logoAndCompanyName(
    String phNo,
    String address,
  ) {
    return Container(
      height: h * 0.1,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(
        children: [
          SizedBox(width: 10),
          Row(
            children: [
              Text(
                'Logo',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
          SizedBox(width: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Name',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              Text(address),
              Text(phNo),
            ],
          )
        ],
      ),
    );
  }

  Widget _saleInvoiceAndPrint(String date) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Sales Invoice',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Print Date : $date",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _accountCashAndRemark(String cash, String remarks) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account:$cash', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        Text('Remarks: $remarks',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _itemAndTotal() {
    return Container(
      height: h * 0.05,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Items',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
          Text(
            'Total',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _itemTable(int length, data) {
    return ListView.builder(
      itemCount: length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Table(
          border: TableBorder.all(color: Colors.black, width: 1),
          columnWidths: {
            0: FlexColumnWidth(3), // First cell occupies 75% of space
            1: FlexColumnWidth(1), // Second cell occupies 25% of space
          },
          children: [
            TableRow(children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: w * 0.04,
                    right: w * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${data[index]['ItemName'].toString()}\t\t${data[index]['ItemDescription'].toString()}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${data[index]['Qty'].toString()} \t x \t${data[index]['Price'].toString()}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(right: w * 0.04),
                  child: Text(
                    data[index]['Total'].toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ]),
          ],
        );
      },
    );
  }

  Widget _total(String billTotal) {
    return Container(
      height: h * 0.06,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
          Text(
            billTotal,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _termAndConditionDescription(String no, String text) {
    return Row(
      children: [
        Text(
          '$no.',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _easySoftStamp() {
    return Container(
      height: h * 0.06,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      child: Center(
        child: Text(
          'Printed By EasySoft',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }

  void _captureScreenShotAndShareToWhatsApp(BuildContext context) async {
    return await screenshotController
        .captureFromWidget(
            Material(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _builtUI(),
              ),
            ),
            context: context)
        .then((Uint8List capturedImage) async {
      final directory = await getExternalStorageDirectory();
      final imagePath = await File(
        '${directory!.path}/${DateTime.now().microsecondsSinceEpoch}image.png',
      );
      await imagePath.writeAsBytes(capturedImage);

      await WhatsappShare.shareFile(
        filePath: [imagePath.path],
        phone: '923185583779',
      );
    });
  }

  void _printInvoice(BuildContext context) async {
    bool? isConnected = await bluetooth.isConnected;
    if (isConnected!) {
      await screenshotController
          .captureFromWidget(
              Material(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: _builtUI(),
                ),
              ),
              context: context)
          .then((Uint8List capturedImage) async {


        bluetooth.printImageBytes(capturedImage).then((value) {
          print('printing wait');
        }).onError((error, stackTrace) {
          print('error during print');
        });
      });
      print('Printer is connected');
    } else {
      print('Printer is  not connected');

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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                width: MediaQuery.of(context).size.width,
                child: PrinterConnection(),
              ),
            ),
          ),
        ),
      );
    }
  }
}
