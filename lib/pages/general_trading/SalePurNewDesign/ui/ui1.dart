import 'package:com/pages/general_trading/SalePur/sale_pur1_SQL.dart';
import 'package:com/pages/general_trading/SalePurNewDesign/ui/pdf_services.dart';
import 'package:com/pages/general_trading/SalePurNewDesign/ui/ui2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared_preferences/shared_preference_keys.dart';
import '../components/custom_text.dart';
import '../components/item_table.dart';
import '../components/print_and_whats_app_dialog_box.dart';

class UI1 extends StatefulWidget {
  final Map dropDown;
  const UI1({super.key, required this.dropDown});

  @override
  State<UI1> createState() => _UI1State();
}

class _UI1State extends State<UI1> {
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  PdfServicesNewDesign _pdfServicesNewDesign = PdfServicesNewDesign();

  Future<List<dynamic>> getSalePurchase2Data(String entryTypeId) async {
    final data = await _salePurSQLDataBase.SalePur2Data(
        salePur1Id1: entryTypeId, entryType: widget.dropDown['SubTitle']);
    return data;
  }

  late double h;
  late double w;

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    final entryType = widget.dropDown['SubTitle'];
    return FutureBuilder<dynamic>(
        future: _salePurSQLDataBase.SalePur1Data(
            entryType: widget.dropDown['SubTitle']),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var snap = snapshot.data;
            return ListView.builder(
                itemCount: snap.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  //passing the the coming data to data variable data
                  var data = snapshot.data[index];


                  //////////////////////////////////////////////////////////
                  //// here calling the funtion to get item data /////
                  /////////////////////////////////////////////////
                  Future<List<dynamic>> tableData =
                      getSalePurchase2Data(data['Entry ID'].toString());

                  ///////////////showing the invoice data//////////////////
                  /////////////////////////////////////////////////////////////////////////
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.symmetric(horizontal: 8),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              data['BillAmount'].toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: w * 0.03,
                            ),
                            Icon(
                              Icons.expand_more,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ],
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _customText('${entryType} ${data['Entry ID']}'),
                                _customText('Cash'),
                              ],
                            ),
                            Spacer(),
                            _customText('${DateFormat(SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.dateFormat))
                                .format(DateTime(int.parse(
                                data['Date']
                                    .substring(
                                    0, 4)), int.parse(
                                data['Date']
                                    .substring(
                                  5,
                                  7,
                                )), int.parse(
                                data['Date']
                                    .substring(
                                    8, 10))))
                                .toString()}'),
                            Spacer(),
                          ],
                        ),
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () async {
                                        String invoiceId =
                                            data['Entry ID'].toString();
                                        String BillAmount =
                                            data['BillAmount'].toString();
                                        // here first i am calling a funtion to get data for sales purchase and then pass that
                                        // data to pdf services to show value in pdf

                                        List<dynamic> data1 =
                                            await _salePurSQLDataBase
                                                .getDataForSalePurchaseRecordToPrintInvoice(
                                                    salesInvoiceId: invoiceId);
                                        final data2 =
                                            await _pdfServicesNewDesign
                                                .generatePdf(
                                                    data: data1,
                                                    billAmount: BillAmount);
                                        ShowPrintPreviewAndWhatsAppShareDialog(
                                          context,
                                          onEditPress: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => UI2(
                                                          appbarTitle: 'Edit',
                                                          dropDown:
                                                              widget.dropDown,
                                                          salPur1ID:
                                                              data['Entry ID']
                                                                  .toString(),
                                                      accountID: data['Account ID'].toString(),
                                                      accountName: data['Account Name'].toString(),

                                                        )));
                                          },
                                          onPrintPreview: () {


                                            
                                          },
                                          onPrintPress: () {},
                                          onWhatsAppPress: () {
                                            _pdfServicesNewDesign
                                                .sharePdf(data2);
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.more_vert),
                                    ),
                                  ),
                                  CustomText(
                                      title: 'Invoice ID',
                                      value:
                                          '${entryType} ${data['ID'].toString()}'),
                                  CustomText(
                                      title: 'Invoice Date',
                                      value: '${DateFormat(SharedPreferencesKeys.prefs!
                                          .getString(SharedPreferencesKeys.dateFormat))
                                          .format(DateTime(int.parse(
                                          data['Date']
                                              .substring(
                                              0, 4)), int.parse(
                                          data['Date']
                                              .substring(
                                            5,
                                            7,
                                          )), int.parse(
                                          data['Date']
                                              .substring(
                                              8, 10))))
                                          .toString()}'),
                                  CustomText(
                                      title: 'Account Name',
                                      value: data['Account Name'].toString()),
                                  CustomText(
                                      title: 'Remarks',
                                      value: data['Remarks'].toString()),
                                  CustomText(
                                      title: 'Name Of Person',
                                      value: data['NameOfPerson'].toString()),
                                  CustomText(
                                      title: 'Contact No',
                                      value: data['ContactNo'].toString()),
                                  CustomText(
                                      title: 'Payment Due Date',
                                      value: data['PayAfterDay'].toString()),
                                  SizedBox(height: h * 0.01),
                                  ItemTable1(tableData: tableData),
                                  SizedBox(height: h * 0.01),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.014),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cash Received',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        CustomText2(
                                                            title: 'CB ID',
                                                            value: '1234'),
                                                        CustomText2(
                                                            title: 'Date',
                                                            value: '1234'),
                                                        CustomText2(
                                                            title: 'Debit',
                                                            value: '1234'),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child:
                                                          Icon(Icons.more_vert),
                                                    )
                                                  ],
                                                ),
                                                CustomText2(
                                                    title: 'Credits',
                                                    value: '1234'),
                                                CustomText2(
                                                    title: 'Remarks',
                                                    value: '1234'),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    'Amount : 5000',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        CustomText2(
                                                            title: 'CB ID',
                                                            value: '1234'),
                                                        CustomText2(
                                                            title: 'CB ID',
                                                            value: '1234'),
                                                        CustomText2(
                                                            title: 'CB ID',
                                                            value: '1234'),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {},
                                                        child: Icon(
                                                            Icons.more_vert))
                                                  ],
                                                ),
                                                CustomText2(
                                                    title: 'CB ID',
                                                    value: '1234'),
                                                CustomText2(
                                                    title: 'CB ID',
                                                    value: '1234'),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    'Amount : 9000',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        });
  }

  Widget _customText(dynamic title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
      ),
    );
  }
}
