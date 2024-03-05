import 'dart:io';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:com/pages/general_trading/SalePur/print/generate_pdf.dart';
import 'package:com/pages/general_trading/SalePur/print/print-invoice-page.dart';
import 'package:com/pages/material/printer_conection.dart';
import 'package:flutter/material.dart';
import 'package:com/pages/general_trading/CashBook/CashBookListUI.dart';
import 'package:com/pages/general_trading/SalePur/sale_pur1_SQL.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import '../../material/datepickerstyle1.dart';
import '../../material/drop_down_style1.dart';
import '../CashBook/CashBookEntryDialogUI.dart';
import '../CashBook/cashBookSql.dart';
import 'SalePur2AddItemBySelection.dart';
import 'SalePur2AddItemUISingle.dart';



class SalePurItemUI extends StatefulWidget {
  final List itemData;
  final String status;
  final String menuName;
  final String entryType;
  final List? list;
  final  int? tableID;
  final Color color;

  const SalePurItemUI(
      {Key? key, this.list, required this.menuName, this.tableID,required this.entryType, required this.color, required this.itemData, required this.status})
      : super(key: key);

  @override
  State<SalePurItemUI> createState() => _SalePurItemUIState();
}

class _SalePurItemUIState extends State<SalePurItemUI> {

  SalePurSQLDataBase _salePurDb = SalePurSQLDataBase();
  final PdfServices _pdfServices = PdfServices();

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;


  TextEditingController remarksController = TextEditingController();
  TextEditingController nameOfPersonController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController paymentAfterDayController = TextEditingController();
  int sliderValue = 2;
  int? valueToShowItem = 0;
  List newEntriesRecord = [];
  List modifiedRecord = [];
  bool checkForSearch = true;
  double opacity = 0;
  List listItemSalePur = [];
  List<bool> listCheckForEdit = [];
  List<double> lisOpacityForEdit = [];
  List<double> lisOpacityForCancel = [];
  List<double> lisOpacityForUpdateCheck = [];
  List<bool> listCheckForEditNewEntries = [];
  List<double> lisOpacityForEditNewEntries = [];
  List<double> lisOpacityForCancelNewEntries = [];
  List<double> lisOpacityForUpdateCheckNewEntries = [];
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  List<bool> listCheckForEditModified = [];
  List<double> lisOpacityForEditModified = [];
  List<double> lisOpacityForCancelModified = [];
  List<double> lisOpacityForUpdateCheckModified = [];
  CashBookSQL _cashBookSQL = CashBookSQL();
  Map dropDownAccountNameMap = {
    "ID": null,
    "Index": -1,
    'Title': "Account Name",
    'SubTitle': null,
    "Value": null
  };

  void initState() {
    super.initState();

    for (int count = 0; count < widget.list!.length; count++) {
      if (widget.list![count]['UpdatedDate']
          .toString()
          .length == 0 &&
          widget.list![count]['Entry ID'] < 0) {
        newEntriesRecord.add(widget.list![count]);
      }
      if (widget.list![count]['UpdatedDate']
          .toString()
          .length == 0 &&
          widget.list![count]['Entry ID'] < 0) {
        modifiedRecord.add(widget.list![count]);
      }
    }

    for (int count = 0; count < newEntriesRecord.length; count++) {
      lisOpacityForEditNewEntries.add(0.0);
      lisOpacityForCancelNewEntries.add(0.0);
      lisOpacityForUpdateCheckNewEntries.add(0.0);
      listCheckForEditNewEntries.add(true);
    }

    for (int count = 0; count < modifiedRecord.length; count++) {
      lisOpacityForEditModified.add(0.0);
      lisOpacityForCancelModified.add(0.0);
      lisOpacityForUpdateCheckModified.add(0.0);
      listCheckForEditModified.add(true);
    }

    for (int count = 0; count < widget.list!.length; count++) {
      if (widget.list![count]['UpdatedDate'] != null) {
        print('..........................opacity .............update');
        lisOpacityForEdit.add(0.0);
        lisOpacityForCancel.add(0.0);
        lisOpacityForUpdateCheck.add(0.0);
        listCheckForEdit.add(true);
      }
    }
  }

  ///    sale pur item Ui .................//////////
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.itemData.length,
      itemBuilder: (context, indexOFWholeListView) =>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: widget.color.withOpacity(.3),
                  border: Border.all(color: widget.color)),
              child: ExpansionTile(
                childrenPadding: EdgeInsets.all(0),
                tilePadding: EdgeInsets.all(0),
                trailing: Container(
                  // color: Colors.red,
                  width: 27,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          // color: Colors.green,
                          height: 20,
                          alignment: Alignment.centerRight,
                          child: FutureBuilder(
                            future: _salePurSQLDataBase
                                .userRightsChecking(widget.menuName),
                            builder: (context,
                                AsyncSnapshot<List> snapshot) {
                              if (snapshot.hasData) {
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: PopupMenuButton<int>(
                                    padding: EdgeInsets.only(left: 4),
                                    icon: IconButton(onPressed: ()async{


                                      String invoiceId=widget
                                          .itemData[indexOFWholeListView]['Entry ID'].toString();
                                      String BillAmount=widget
                                          .itemData[indexOFWholeListView]['BillAmount']
                                          .toString();

                                      List<dynamic> data1 =await _salePurDb.getDataForSalePurchaseRecordToPrintInvoice(
                                          salesInvoiceId: invoiceId);
                                      final data2 = await _pdfServices.generatePdf(
                                          data: data1, billAmount: BillAmount);
                                      if(invoiceId.isNotEmpty){
                                        ShowPrintPreviewAndWhatsAppShareDialog(
                                            onPrintPreviewPress: (){
                                              Navigator.pop(context);

                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>PrintInvoicePage(invoiceId:invoiceId ,billAmount: BillAmount,),),);


                                            },
                                            onPrintPress: (){

                                              _printInvoice(context, data2);
                                              // Navigator.pop(context);
                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>PrintInvoicePage(invoiceId:invoiceId ,billAmount: BillAmount,printInvoice: true,),),);
                                            },
                                            onWhatsAppPress: (){

                                              sharePdf(data2);



                                              // Navigator.pop(context);
                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>PrintInvoicePage(invoiceId:invoiceId ,billAmount: BillAmount,captureSs: true,),),);
                                            }
                                        );

                                      }



                                    }, icon: Icon(
                                      Icons.more_horiz,
                                      size: 20,
                                    ),),
                                    onSelected: (int value) async {
                                      if (value == 0) {
                                        if (!snapshot.data![0]['Edting']
                                            .toString()
                                            .contains('false')) {
                                          setState(() {
                                            if (widget.status
                                                .contains(
                                                'newEntriesRecord')) {
                                              lisOpacityForEditNewEntries[
                                              indexOFWholeListView] = 1;
                                              lisOpacityForCancelNewEntries[
                                              indexOFWholeListView] = 1;
                                              listCheckForEditNewEntries[
                                              indexOFWholeListView] = false;
                                            } else if (widget.status
                                                .contains(
                                                'modifiedRecord')) {
                                              lisOpacityForEditModified[
                                              indexOFWholeListView] = 1;
                                              lisOpacityForCancelModified[
                                              indexOFWholeListView] = 1;
                                              listCheckForEditModified[
                                              indexOFWholeListView] = false;
                                            } else {
                                              lisOpacityForEdit[
                                              indexOFWholeListView] = 1;
                                              lisOpacityForCancel[
                                              indexOFWholeListView] = 1;
                                              listCheckForEdit[
                                              indexOFWholeListView] = false;
                                            }
                                          });
                                        }
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                            value: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text('Edit'),
                                                !snapshot.data![0]['Edting']
                                                    .toString()
                                                    .contains('false')
                                                    ? Icon(
                                                  Icons
                                                      .check_circle_rounded,
                                                  color: Colors.green,
                                                )
                                                    : Icon(
                                                  Icons.block,
                                                  color: Colors.red,
                                                )
                                              ],
                                            )),
                                        PopupMenuItem(
                                            value: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text('Delete'),
                                                !snapshot.data![0]['Edting']
                                                    .toString()
                                                    .contains('false')
                                                    ? Icon(
                                                  Icons
                                                      .check_circle_rounded,
                                                  color: Colors.green,
                                                )
                                                    : Icon(
                                                  Icons.block,
                                                  color: Colors.red,
                                                )
                                              ],
                                            )),
                                        PopupMenuItem(
                                            value: 2, child: Text('Print')),
                                        PopupMenuItem(
                                            value: 3, child: Text('Share')),
                                        PopupMenuItem(
                                            value: 4,
                                            child: Text('Export to Pdf')),
                                        PopupMenuItem(
                                            value: 5,
                                            child: Text('Export to Excel')),
                                      ];
                                    },
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                        ),
                      ),
                      Flexible(child: Align(alignment: Alignment.bottomRight,
                          child: Icon(Icons.arrow_drop_down, size: 25,))),
                    ],
                  ),
                ),
                initiallyExpanded: widget.status == 'Ledger' ? true : false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                            '${widget
                                .itemData[indexOFWholeListView]['EntryType']} ${widget
                                .itemData[indexOFWholeListView]['Entry ID']}  ${widget
                                .itemData[indexOFWholeListView]['Entry ID']}'),

                        Row(
                          children: [

                            Opacity(
                              opacity: widget.status.contains(
                                  'newEntriesRecord')
                                  ? lisOpacityForCancelNewEntries[
                              indexOFWholeListView]
                                  : widget.status.contains('modifiedRecord')
                                  ? lisOpacityForCancelModified[
                              indexOFWholeListView]
                                  : lisOpacityForCancel[indexOFWholeListView],
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (widget.status.contains(
                                        'newEntriesRecord')) {
                                      print(
                                          '......................................new entry record');
                                      lisOpacityForCancelNewEntries[
                                      indexOFWholeListView] = 0.0;
                                      lisOpacityForEditNewEntries[
                                      indexOFWholeListView] = 0.0;
                                      lisOpacityForUpdateCheckNewEntries[
                                      indexOFWholeListView] = 0.0;
                                      listCheckForEditNewEntries[
                                      indexOFWholeListView] = true;
                                    } else if (widget.status.contains(
                                        'modifiedRecord')) {
                                      lisOpacityForCancelModified[
                                      indexOFWholeListView] = 0.0;
                                      lisOpacityForEditModified[
                                      indexOFWholeListView] = 0.0;
                                      lisOpacityForUpdateCheckModified[
                                      indexOFWholeListView] = 0.0;
                                      listCheckForEditModified[
                                      indexOFWholeListView] = true;
                                    } else {
                                      lisOpacityForCancel[indexOFWholeListView] =
                                      0.0;
                                      lisOpacityForEdit[indexOFWholeListView] =
                                      0.0;
                                      lisOpacityForUpdateCheck[
                                      indexOFWholeListView] = 0.0;
                                      listCheckForEdit[indexOFWholeListView] =
                                      true;
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 17,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [

                        Text('${DateFormat(SharedPreferencesKeys.prefs!
                            .getString(SharedPreferencesKeys.dateFormat))
                            .format(DateTime(int.parse(
                            widget.itemData[indexOFWholeListView]['Date']
                                .substring(
                                0, 4)), int.parse(
                            widget.itemData[indexOFWholeListView]['Date']
                                .substring(
                              5,
                              7,
                            )), int.parse(
                            widget.itemData[indexOFWholeListView]['Date']
                                .substring(
                                8, 10))))
                            .toString()}'),
                        Opacity(
                          opacity: widget.status.contains('newEntriesRecord')
                              ? lisOpacityForEditNewEntries[indexOFWholeListView]
                              : widget.status.contains('modifiedRecord')
                              ? lisOpacityForEditModified[indexOFWholeListView]
                              : lisOpacityForEdit[indexOFWholeListView],
                          child: InkWell(
                            onTap: () async {
                              var dateTime = await Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                    var date = DatePickerStyle1();
                                    return date;
                                  }));
                              print(
                                  '.....datetime ${dateTime.toString()
                                      .substring(0, 10)}..');
                              _salePurSQLDataBase.UpdateSalePur1(
                                  SPDate: dateTime.toString().substring(0, 10),
                                  context: context,
                                  ACNameID: widget
                                      .itemData[indexOFWholeListView]
                                  ['Account ID'],
                                  ContactNo: widget
                                      .itemData[indexOFWholeListView]
                                  ['ContactNo']
                                      .toString(),
                                  EntryType: widget
                                      .itemData[indexOFWholeListView]
                                  ['EntryType'],
                                  NameOfPerson: widget
                                      .itemData[indexOFWholeListView]
                                  ['NameOfPerson'],
                                  PaymentAfterDate: widget
                                      .itemData[indexOFWholeListView]
                                  ['PayAfterDay']
                                      .toString(),
                                  id: widget
                                      .itemData[indexOFWholeListView]['ID'],
                                  remarks: widget
                                      .itemData[indexOFWholeListView]['Remarks']
                                      .toString());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FutureBuilder(
                              future: _salePurSQLDataBase.dropDownData1(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return Row(
                                  children: [
                                    Flexible(
                                      child: FittedBox(
                                        child: Text(
                                            widget
                                                .itemData[indexOFWholeListView]
                                            ['Account Name'].toString()),
                                      ),
                                    ),

                                    Opacity(
                                      opacity: widget.status.contains(
                                          'newEntriesRecord')
                                          ? lisOpacityForEditNewEntries[
                                      indexOFWholeListView]
                                          : widget.status.contains(
                                          'modifiedRecord')
                                          ? lisOpacityForEditModified[
                                      indexOFWholeListView]
                                          : lisOpacityForEdit[
                                      indexOFWholeListView],
                                      child: InkWell(
                                        onTap: () async {
                                          print(
                                              '...............${dropDownAccountNameMap
                                                  .toString()}....................');

                                          dropDownAccountNameMap =
                                          await showDialog(
                                            context: context,
                                            builder: (_) =>
                                                DropDownStyle1(
                                                  index: indexOFWholeListView,
                                                  acc1TypeList: snapshot.data,
                                                  dropdown_title:
                                                  dropDownAccountNameMap['Title'],
                                                  map: dropDownAccountNameMap,
                                                ),
                                          );

                                          print(
                                              '...............${dropDownAccountNameMap
                                                  .toString()}....................');

                                          setState(() {
                                            _salePurSQLDataBase.UpdateSalePur1(
                                                SPDate: widget
                                                    .itemData[indexOFWholeListView]['Date']
                                                    .toString(),
                                                context: context,
                                                ACNameID: int.parse(
                                                    dropDownAccountNameMap['ID']
                                                        .toString()),
                                                ContactNo: widget
                                                    .itemData[indexOFWholeListView]
                                                ['ContactNo'],
                                                EntryType: widget
                                                    .itemData[indexOFWholeListView]
                                                ['EntryType'],
                                                NameOfPerson:
                                                widget
                                                    .itemData[indexOFWholeListView]
                                                ['NameOfPerson'],
                                                PaymentAfterDate:
                                                widget
                                                    .itemData[indexOFWholeListView]
                                                ['PayAfterDay']
                                                    .toString(),
                                                id: widget
                                                    .itemData[indexOFWholeListView]
                                                ['ID'],
                                                remarks: widget
                                                    .itemData[indexOFWholeListView]
                                                ['Remarks']
                                                    .toString());
                                          });
                                        },
                                        child: Icon(
                                          Icons.edit_outlined,
                                          // color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                        Flexible(
                          child: FittedBox(
                            child: Text(
                                widget
                                    .itemData[indexOFWholeListView]['BillAmount']
                                    .toString()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                children: [
                  ///   optional field.............................................................
                  ExpansionTile(
                    initiallyExpanded: widget.status == 'Ledger' ? true : false,
                    onExpansionChanged: (value) {
                      print(
                          '...................expention chage........................');
                      setState(() {
                        contactNoController.text =
                            widget.itemData[indexOFWholeListView]['ContactNo']
                                .toString();
                        paymentAfterDayController.text =
                            widget.itemData[indexOFWholeListView]['PayAfterDay']
                                .toString();
                        remarksController.text =
                            widget.itemData[indexOFWholeListView]['Remarks']
                                .toString();
                        nameOfPersonController.text =
                            widget.itemData[indexOFWholeListView]
                            ['NameOfPerson']
                                .toString();
                      });
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Optional Fields'),
                        Row(
                          children: [
                            Opacity(
                              opacity: widget.status.contains(
                                  'newEntriesRecord')
                                  ? lisOpacityForCancelNewEntries[
                              indexOFWholeListView]
                                  : widget.status.contains('modifiedRecord')
                                  ? lisOpacityForCancelModified[
                              indexOFWholeListView]
                                  : lisOpacityForCancel[indexOFWholeListView],
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (widget.status.contains(
                                          'newEntriesRecord')) {
                                        lisOpacityForCancelNewEntries[
                                        indexOFWholeListView] = 0.0;
                                        lisOpacityForEditNewEntries[
                                        indexOFWholeListView] = 0.0;
                                        lisOpacityForUpdateCheckNewEntries[
                                        indexOFWholeListView] = 0.0;
                                        listCheckForEditNewEntries[
                                        indexOFWholeListView] = true;
                                      } else if (widget.status
                                          .contains('modifiedRecord')) {
                                        lisOpacityForCancelModified[
                                        indexOFWholeListView] = 0.0;
                                        lisOpacityForEditModified[
                                        indexOFWholeListView] = 0.0;
                                        lisOpacityForUpdateCheckModified[
                                        indexOFWholeListView] = 0.0;
                                        listCheckForEditModified[
                                        indexOFWholeListView] = true;
                                      } else {
                                        lisOpacityForCancel[indexOFWholeListView] =
                                        0.0;
                                        lisOpacityForEdit[indexOFWholeListView] =
                                        0.0;
                                        lisOpacityForUpdateCheck[
                                        indexOFWholeListView] = 0.0;
                                        listCheckForEdit[indexOFWholeListView] =
                                        true;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  )),
                            ),
                            Opacity(
                              opacity: widget.status.contains(
                                  'newEntriesRecord')
                                  ? lisOpacityForUpdateCheckNewEntries[
                              indexOFWholeListView]
                                  : widget.status.contains('modifiedRecord')
                                  ? lisOpacityForUpdateCheckModified[
                              indexOFWholeListView]
                                  : lisOpacityForUpdateCheck[
                              indexOFWholeListView],
                              child: IconButton(
                                  onPressed: () {
                                    print(
                                        '................click........................');

                                    _salePurSQLDataBase.UpdateSalePur1(
                                        SPDate: widget
                                            .itemData[indexOFWholeListView]
                                        ['Date']
                                            .toString(),
                                        context: context,
                                        ACNameID: widget
                                            .itemData[indexOFWholeListView]
                                        ['Account ID'],
                                        ContactNo:
                                        contactNoController.text.toString(),
                                        EntryType: widget
                                            .itemData[indexOFWholeListView]
                                        ['EntryType'],
                                        NameOfPerson:
                                        nameOfPersonController.text.toString(),
                                        PaymentAfterDate: paymentAfterDayController
                                            .text
                                            .toString(),
                                        id: widget
                                            .itemData[indexOFWholeListView]['ID'],
                                        remarks: remarksController.text
                                            .toString());
                                    setState(() {
                                      if (widget.status.contains(
                                          'newEntriesRecord')) {
                                        lisOpacityForCancelNewEntries[
                                        indexOFWholeListView] = 0.0;
                                        lisOpacityForEditNewEntries[
                                        indexOFWholeListView] = 0.0;
                                        lisOpacityForUpdateCheckNewEntries[
                                        indexOFWholeListView] = 0.0;
                                        listCheckForEditNewEntries[
                                        indexOFWholeListView] = true;
                                      } else if (widget.status
                                          .contains('modifiedRecord')) {
                                        lisOpacityForCancelModified[
                                        indexOFWholeListView] = 0.0;
                                        lisOpacityForEditModified[
                                        indexOFWholeListView] = 0.0;
                                        lisOpacityForUpdateCheckModified[
                                        indexOFWholeListView] = 0.0;
                                        listCheckForEditModified[
                                        indexOFWholeListView] = true;
                                      } else {
                                        lisOpacityForCancel[indexOFWholeListView] =
                                        0.0;
                                        lisOpacityForEdit[indexOFWholeListView] =
                                        0.0;
                                        lisOpacityForUpdateCheck[
                                        indexOFWholeListView] = 0.0;
                                        listCheckForEdit[indexOFWholeListView] =
                                        true;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                    children: [
                      GridView.builder(
                        itemCount: 4,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: sliderValue, mainAxisExtent: 50),
                        itemBuilder: (context, indexOfTextViewGrid) =>
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    if (widget.status.contains(
                                        'newEntriesRecord')) {
                                      lisOpacityForUpdateCheckNewEntries[
                                      indexOFWholeListView] = 1.0;
                                    } else if (widget.status.contains(
                                        'modifiedRecord')) {
                                      lisOpacityForUpdateCheckModified[
                                      indexOFWholeListView] = 1.0;
                                    } else {
                                      lisOpacityForUpdateCheck[indexOFWholeListView] =
                                      1.0;
                                    }
                                  });
                                },
                                readOnly: widget.status.contains(
                                    'newEntriesRecord')
                                    ? listCheckForEditNewEntries[indexOFWholeListView]
                                    : widget.status.contains('modifiedRecord')
                                    ? listCheckForEditModified[indexOFWholeListView]
                                    : listCheckForEdit[indexOFWholeListView],
                                controller: indexOfTextViewGrid == 0
                                    ? remarksController
                                    : indexOfTextViewGrid == 1
                                    ? nameOfPersonController
                                    : indexOfTextViewGrid == 2
                                    ? contactNoController
                                    : paymentAfterDayController,
                                decoration: InputDecoration(
                                    filled: true,
                                    label: FittedBox(
                                      child: Text(
                                        indexOfTextViewGrid == 0
                                            ? 'Remarks'
                                            : indexOfTextViewGrid == 1
                                            ? 'Name Of Person'
                                            : indexOfTextViewGrid == 2
                                            ? 'Contact NO'
                                            : 'Payment After Day',
                                      ),
                                    ),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  opacity = 1;
                                });
                              },
                              icon: Icon(
                                Icons.settings,
                                color: Colors.grey,
                                size: 12,
                              )),
                          Opacity(
                            opacity: opacity,
                            child: Slider(
                                value: sliderValue.toDouble(),
                                min: 1.0,
                                max: 4.0,
                                onChanged: (double value) {
                                  setState(() {
                                    sliderValue = value.toInt();
                                  });
                                }),
                          )
                        ],
                      )
                    ],
                  ),

                  ///   items .............................................................
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24, top: 8),
                    child: Container(
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                      child: FutureBuilder(
                          future: SharedPreferences.getInstance(),
                          builder:
                              (context,
                              AsyncSnapshot<SharedPreferences> snapshot) {
                            if (snapshot.hasData) {
                              return ExpansionTile(
                                onExpansionChanged: (bool) async {
                                  listItemSalePur =
                                  await _salePurSQLDataBase.SalePur2Data(
                                      entryType: widget.entryType
                                          .toString(),
                                      salePur1Id1:
                                      widget.itemData[indexOFWholeListView]
                                      ['Entry ID']
                                          .toString());

                                  if (bool) {
                                    setState(() {
                                      valueToShowItem =
                                          snapshot.data!.getInt('value');
                                    });
                                  }
                                },
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    checkForSearch
                                        ? Text('Items')
                                        : Flexible(
                                        child: SizedBox(
                                          height: 30,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                label: Text('Search'),
                                                prefixIcon: Icon(Icons.search),
                                                border: OutlineInputBorder()),
                                          ),
                                        )),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        PopupMenuButton<int>(
                                          icon: Icon(Icons.more_horiz),
                                          onSelected: (int value) {
                                            snapshot.data!.setInt(
                                                'value', value);
                                            print(
                                                '...........................$value...............................');
                                            print(
                                                '...........................${snapshot
                                                    .data!.getInt(
                                                    'value')}...............................');

                                            if (value != 2) {
                                              valueToShowItem = value;
                                            } else {
                                              valueToShowItem = 0;
                                              checkForSearch = false;
                                            }
                                            setState(() {});
                                          },
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                  value: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text('List'),
                                                      Icon(Icons.list),
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  value: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text('Table'),
                                                      Icon(Icons.grid_on),
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  value: 3,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text('Grid'),
                                                      Icon(Icons.grid_view),
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  value: 2,
                                                  child: Icon(Icons.search))
                                            ];
                                          },
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (SharedPreferencesKeys.prefs!
                                                .getString('CheckStateItem') ==
                                                '') {
                                              print(
                                                  '....................if...............');
                                              showGeneralDialog(
                                                context: context,
                                                pageBuilder: (
                                                    BuildContext context,
                                                    Animation<double> animation,
                                                    Animation<double>
                                                    secondaryAnimation) {
                                                  return AnimatedContainer(
                                                    padding: EdgeInsets.only(
                                                        bottom:
                                                        MediaQuery
                                                            .of(context)
                                                            .viewInsets
                                                            .bottom),
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    alignment: Alignment.center,
                                                    child: SalesPur2Dialog(
                                                      accountID: widget
                                                          .itemData[indexOFWholeListView]['Account ID'],
                                                      id: widget
                                                          .itemData[indexOFWholeListView]['ID'],
                                                      contactNo: widget
                                                          .itemData[indexOFWholeListView]['ContactNo']
                                                          .toString(),
                                                      NameOfPerson: widget
                                                          .itemData[indexOFWholeListView]['NameOfPerson']
                                                          .toString(),
                                                      PaymentAfterDate: widget
                                                          .itemData[indexOFWholeListView]['PayAfterDay']
                                                          .toString(),
                                                      remarks: widget
                                                          .itemData[indexOFWholeListView]['Remarks']
                                                          .toString(),
                                                      EntryType: widget
                                                          .itemData[
                                                      indexOFWholeListView]
                                                      ['EntryType']
                                                          .toString(),
                                                      accountName: widget
                                                          .itemData[
                                                      indexOFWholeListView]
                                                      ['Account Name']
                                                          .toString(),
                                                      date: widget.itemData[
                                                      indexOFWholeListView]
                                                      ['Date']
                                                          .toString(),
                                                      salePur1Id: widget
                                                          .itemData[
                                                      indexOFWholeListView]
                                                      ['Entry ID'],
                                                      map: {},
                                                      action: 'ADD',
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              print(
                                                  '....................else...............');
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddItemBySelection
                                                            (
                                                              openFor: 'Sale',
                                                              date: widget
                                                                  .itemData[
                                                              indexOFWholeListView]
                                                              ['Date']
                                                                  .toString(),
                                                              accountName: widget
                                                                  .itemData[
                                                              indexOFWholeListView]
                                                              ['Account Name']
                                                                  .toString(),
                                                              accountID: widget
                                                                  .itemData[indexOFWholeListView]['Account ID'],
                                                              id: widget
                                                                  .itemData[indexOFWholeListView]['ID'],
                                                              contactNo: widget
                                                                  .itemData[indexOFWholeListView]['ContactNo']
                                                                  .toString(),
                                                              nameOfPerson: widget
                                                                  .itemData[indexOFWholeListView]['NameOfPerson']
                                                                  .toString(),
                                                              paymentAfterDate: widget
                                                                  .itemData[indexOFWholeListView]['PayAfterDay']
                                                                  .toString(),
                                                              remarks: widget
                                                                  .itemData[indexOFWholeListView]['Remarks']
                                                                  .toString(),
                                                              entryType: widget
                                                                  .itemData[
                                                              indexOFWholeListView]
                                                              ['EntryType'],
                                                              salePurId1: widget
                                                                  .itemData[
                                                              indexOFWholeListView]
                                                              ['Entry ID'])));
                                            }
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),

                                /// ///////////////////////view///////////////////////////////////views list grid and table  of item .............///
                                children: [
                                  valueToShowItem == 0
                                      ? ListView.builder(

                                      itemCount: listItemSalePur.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                  child: Align(
                                                      alignment:
                                                      Alignment.topRight,
                                                      child: FutureBuilder(
                                                        future: _salePurSQLDataBase
                                                            .userRightsChecking(
                                                            widget
                                                                .menuName),
                                                        builder: (context,
                                                            AsyncSnapshot<List>
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            if (SharedPreferencesKeys
                                                                .prefs!
                                                                .getString(
                                                                SharedPreferencesKeys
                                                                    .userRightsClient) ==
                                                                'Admin') {
                                                              return popUpButtonForItemEdit(
                                                                  checkEditForUserItem: 'true',
                                                                  onSelected: (
                                                                      value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      List argumentList = [
                                                                      ];
                                                                      if (widget
                                                                          .itemData[indexOFWholeListView]['EntryType']
                                                                          .toString()
                                                                          .length ==
                                                                          0) {
                                                                        print(
                                                                            '......................if.......................');
                                                                        List listOFDataLedgerFromCashBook =
                                                                        await _cashBookSQL
                                                                            .getDataForLedgerFromCashBook(
                                                                            widget
                                                                                .itemData[indexOFWholeListView]['Entry ID']);
                                                                        argumentList =
                                                                        [
                                                                          {
                                                                            "action": "EDIT"
                                                                          },
                                                                          listOFDataLedgerFromCashBook[0]
                                                                        ];
                                                                      }
                                                                      showGeneralDialog(
                                                                        context:
                                                                        context,
                                                                        pageBuilder: (
                                                                            BuildContext context,
                                                                            Animation<
                                                                                double>
                                                                            animation,
                                                                            Animation<
                                                                                double>
                                                                            secondaryAnimation) {
                                                                          return AnimatedContainer(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  bottom: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .viewInsets
                                                                                      .bottom),
                                                                              duration: const Duration(
                                                                                  milliseconds: 300),
                                                                              alignment: Alignment
                                                                                  .center,
                                                                              child: widget
                                                                                  .itemData[indexOFWholeListView]['EntryType']
                                                                                  .toString()
                                                                                  .length ==
                                                                                  0
                                                                                  ? CashBook(
                                                                                  context: context,
                                                                                  list:
                                                                                  argumentList,
                                                                                  menuName:
                                                                                  'Cash Book')
                                                                                  : SalesPur2Dialog(
                                                                                accountID: widget
                                                                                    .itemData[indexOFWholeListView]['Account ID'],
                                                                                id: widget
                                                                                    .itemData[indexOFWholeListView]['ID'],
                                                                                contactNo: widget
                                                                                    .itemData[indexOFWholeListView]['ContactNo'],
                                                                                NameOfPerson: widget
                                                                                    .itemData[indexOFWholeListView]['NameOfPerson'],
                                                                                PaymentAfterDate: widget
                                                                                    .itemData[indexOFWholeListView]['PayAfterDay'],
                                                                                remarks: widget
                                                                                    .itemData[indexOFWholeListView]['Remarks'],

                                                                                EntryType: widget
                                                                                    .itemData[indexOFWholeListView]['EntryType']
                                                                                    .toString(),
                                                                                accountName: widget
                                                                                    .itemData[
                                                                                indexOFWholeListView]
                                                                                ['Account Name']
                                                                                    .toString(),
                                                                                date: widget
                                                                                    .itemData[
                                                                                indexOFWholeListView]
                                                                                ['Date']
                                                                                    .toString(),
                                                                                salePur1Id: widget
                                                                                    .itemData[indexOFWholeListView]['Entry ID'],
                                                                                map: listItemSalePur[index],
                                                                                action: 'EDIT',
                                                                              ));
                                                                        },
                                                                      );
                                                                    }
                                                                  });
                                                            } else {
                                                              return popUpButtonForItemEdit(
                                                                  checkEditForUserItem:
                                                                  snapshot
                                                                      .data![0]['Edting']
                                                                      .toString(),
                                                                  onSelected: (
                                                                      value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      if (!snapshot
                                                                          .data![0]['Edting']
                                                                          .toString()
                                                                          .contains(
                                                                          'false')) {
                                                                        List argumentList = [
                                                                        ];
                                                                        if (widget
                                                                            .itemData[indexOFWholeListView]['EntryType']
                                                                            .toString()
                                                                            .length ==
                                                                            0) {
                                                                          print(
                                                                              '......................if.......................');
                                                                          List listOFDataLedgerFromCashBook =
                                                                          await _cashBookSQL
                                                                              .getDataForLedgerFromCashBook(
                                                                              widget
                                                                                  .itemData[indexOFWholeListView]['Entry ID']);
                                                                          argumentList =
                                                                          [
                                                                            {
                                                                              "action": "EDIT"
                                                                            },
                                                                            listOFDataLedgerFromCashBook[0]
                                                                          ];
                                                                        }
                                                                        showGeneralDialog(
                                                                          context:
                                                                          context,
                                                                          pageBuilder: (
                                                                              BuildContext context,
                                                                              Animation<
                                                                                  double>
                                                                              animation,
                                                                              Animation<
                                                                                  double>
                                                                              secondaryAnimation) {
                                                                            return AnimatedContainer(
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    bottom: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .viewInsets
                                                                                        .bottom),
                                                                                duration: const Duration(
                                                                                    milliseconds: 300),
                                                                                alignment: Alignment
                                                                                    .center,
                                                                                child: widget
                                                                                    .itemData[indexOFWholeListView]['EntryType']
                                                                                    .toString()
                                                                                    .length ==
                                                                                    0
                                                                                    ? CashBook(
                                                                                    context: context,
                                                                                    list:
                                                                                    argumentList,
                                                                                    menuName:
                                                                                    'Cash Book')
                                                                                    : SalesPur2Dialog(
                                                                                  accountID: widget
                                                                                      .itemData[indexOFWholeListView]['Account ID'],
                                                                                  id: widget
                                                                                      .itemData[indexOFWholeListView]['ID'],
                                                                                  contactNo: widget
                                                                                      .itemData[indexOFWholeListView]['ContactNo'],
                                                                                  NameOfPerson: widget
                                                                                      .itemData[indexOFWholeListView]['NameOfPerson'],
                                                                                  PaymentAfterDate: widget
                                                                                      .itemData[indexOFWholeListView]['PayAfterDay'],
                                                                                  remarks: widget
                                                                                      .itemData[indexOFWholeListView]['Remarks'],

                                                                                  EntryType: widget
                                                                                      .itemData[indexOFWholeListView]['EntryType']
                                                                                      .toString(),
                                                                                  accountName: widget
                                                                                      .itemData[
                                                                                  indexOFWholeListView]
                                                                                  ['Account Name']
                                                                                      .toString(),
                                                                                  date: widget
                                                                                      .itemData[
                                                                                  indexOFWholeListView]
                                                                                  ['Date']
                                                                                      .toString(),
                                                                                  salePur1Id: widget
                                                                                      .itemData[indexOFWholeListView]['Entry ID'],
                                                                                  map: listItemSalePur[index],
                                                                                  action: 'EDIT',
                                                                                ));
                                                                          },
                                                                        );
                                                                      }
                                                                    }
                                                                  });
                                                            }
                                                          } else {
                                                            return SizedBox();
                                                          }
                                                        },
                                                      )),
                                                ),
                                                customListView(
                                                    itemName:
                                                    listItemSalePur[index]
                                                    ['ItemName']
                                                        .toString(),
                                                    quantity:
                                                    listItemSalePur[index]
                                                    ['Qty']
                                                        .toString(),
                                                    price:
                                                    listItemSalePur[index]
                                                    ['Price']
                                                        .toString(),
                                                    total:
                                                    listItemSalePur[index]
                                                    ['Total']
                                                        .toString(),
                                                    itemGroupName:
                                                    listItemSalePur[index][
                                                    'Item2GroupName']
                                                        .toString()),
                                              ],
                                            ),
                                          ))
                                      : valueToShowItem == 1
                                      ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Table(
                                      columnWidths: const <int,
                                          TableColumnWidth>{
                                        0: FixedColumnWidth(100),
                                        4: FixedColumnWidth(35),
                                      },
                                      border: TableBorder.all(),
                                      children: List.generate(
                                        listItemSalePur.length + 2,
                                            (index) =>
                                            TableRow(
                                              children: [
                                                Container(
                                                  height:
                                                  index == 0 ? 25 : 18,
                                                  color: index == 0 ||
                                                      index ==
                                                          listItemSalePur
                                                              .length +
                                                              1
                                                      ? Colors.grey.shade200
                                                      : Colors.white,
                                                  alignment: Alignment.center,
                                                  child: index == 0
                                                      ? Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                        'Item Name ',
                                                        style: TextStyle(
                                                            fontSize:
                                                            12,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_downward,
                                                        size: 10,
                                                      )
                                                    ],
                                                  )
                                                      : index ==
                                                      listItemSalePur
                                                          .length +
                                                          1
                                                      ? Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        fontSize:
                                                        12,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  )
                                                      : Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            left:
                                                            3.0),
                                                        child: Text(
                                                            listItemSalePur[(listItemSalePur
                                                                .length) -
                                                                index]
                                                            [
                                                            'ItemName'],
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis),
                                                      )),
                                                ),
                                                Container(
                                                  height:
                                                  index == 0 ? 25 : 18,
                                                  color: index == 0 ||
                                                      index ==
                                                          listItemSalePur
                                                              .length +
                                                              1
                                                      ? Colors.grey.shade200
                                                      : Colors.white,
                                                  alignment: Alignment.center,
                                                  child: index == 0
                                                      ? Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                        'QTY',
                                                        style: TextStyle(
                                                            fontSize:
                                                            12,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_downward,
                                                        size: 10,
                                                      )
                                                    ],
                                                  )
                                                      : index ==
                                                      listItemSalePur
                                                          .length +
                                                          1
                                                      ? Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        fontSize:
                                                        12,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  )
                                                      : Text(listItemSalePur[
                                                  (listItemSalePur
                                                      .length) -
                                                      index]['Qty']
                                                      .toString()),
                                                ),
                                                Container(
                                                  height:
                                                  index == 0 ? 25 : 18,
                                                  color: index == 0 ||
                                                      index ==
                                                          listItemSalePur
                                                              .length +
                                                              1
                                                      ? Colors.grey.shade200
                                                      : Colors.white,
                                                  alignment: Alignment.center,
                                                  child: index == 0
                                                      ? Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Flexible(
                                                        child:
                                                        FittedBox(
                                                          child: Text(
                                                            'Price',
                                                            style: TextStyle(
                                                                fontSize:
                                                                12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Icon(
                                                          Icons
                                                              .arrow_downward,
                                                          size: 10,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                      : index ==
                                                      listItemSalePur
                                                          .length +
                                                          1
                                                      ? Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        fontSize:
                                                        12,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  )
                                                      : Text(listItemSalePur[
                                                  (listItemSalePur
                                                      .length) -
                                                      index]['Price']
                                                      .toString()),
                                                ),
                                                Container(
                                                  height:
                                                  index == 0 ? 25 : 18,
                                                  color: index == 0 ||
                                                      index ==
                                                          listItemSalePur
                                                              .length +
                                                              1
                                                      ? Colors.grey.shade200
                                                      : Colors.white,
                                                  alignment: Alignment.center,
                                                  child: index == 0
                                                      ? Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Flexible(
                                                        child:
                                                        FittedBox(
                                                          child: Text(
                                                            'Total',
                                                            style: TextStyle(
                                                                fontSize:
                                                                12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Icon(
                                                          Icons
                                                              .arrow_downward,
                                                          size: 10,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                      : index ==
                                                      listItemSalePur
                                                          .length +
                                                          1
                                                      ? Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        fontSize:
                                                        12,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  )
                                                      : Text(listItemSalePur[
                                                  (listItemSalePur
                                                      .length) -
                                                      index]['Total']
                                                      .toString()),
                                                ),
                                                Container(
                                                    height:
                                                    index == 0 ? 25 : 18,
                                                    color: index == 0 ||
                                                        index ==
                                                            listItemSalePur
                                                                .length +
                                                                1
                                                        ? Colors.grey.shade200
                                                        : Colors.white,
                                                    alignment:
                                                    Alignment.center,
                                                    child: index == 0
                                                        ? Text(
                                                      '',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    )
                                                        : index ==
                                                        listItemSalePur
                                                            .length +
                                                            1
                                                        ? Text(
                                                      '',
                                                      style: TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    )
                                                        : FutureBuilder(
                                                        future: _salePurSQLDataBase
                                                            .userRightsChecking(
                                                            widget
                                                                .menuName),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                List>
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            if (SharedPreferencesKeys
                                                                .prefs!
                                                                .getString(
                                                                SharedPreferencesKeys
                                                                    .userRightsClient) ==
                                                                'Admin') {
                                                              return popUpButtonForItemEdit(
                                                                  checkEditForUserItem: 'true',
                                                                  onSelected: (
                                                                      value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      List argumentList = [
                                                                      ];
                                                                      if (widget
                                                                          .itemData[indexOFWholeListView]['EntryType']
                                                                          .toString()
                                                                          .length ==
                                                                          0) {
                                                                        print(
                                                                            '......................if.......................');
                                                                        List listOFDataLedgerFromCashBook =
                                                                        await _cashBookSQL
                                                                            .getDataForLedgerFromCashBook(
                                                                            widget
                                                                                .itemData[indexOFWholeListView]['Entry ID']);
                                                                        argumentList =
                                                                        [
                                                                          {
                                                                            "action": "EDIT"
                                                                          },
                                                                          listOFDataLedgerFromCashBook[0]
                                                                        ];
                                                                      }
                                                                      showGeneralDialog(
                                                                        context:
                                                                        context,
                                                                        pageBuilder: (
                                                                            BuildContext context,
                                                                            Animation<
                                                                                double>
                                                                            animation,
                                                                            Animation<
                                                                                double>
                                                                            secondaryAnimation) {
                                                                          return AnimatedContainer(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  bottom: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .viewInsets
                                                                                      .bottom),
                                                                              duration: const Duration(
                                                                                  milliseconds: 300),
                                                                              alignment: Alignment
                                                                                  .center,
                                                                              child: widget
                                                                                  .itemData[indexOFWholeListView]['EntryType']
                                                                                  .toString()
                                                                                  .length ==
                                                                                  0
                                                                                  ? CashBook(
                                                                                  context: context,
                                                                                  list:
                                                                                  argumentList,
                                                                                  menuName:
                                                                                  'Cash Book')
                                                                                  : SalesPur2Dialog(
                                                                                accountID: widget
                                                                                    .itemData[indexOFWholeListView]['Account ID'],
                                                                                id: widget
                                                                                    .itemData[indexOFWholeListView]['ID'],
                                                                                contactNo: widget
                                                                                    .itemData[indexOFWholeListView]['ContactNo'],
                                                                                NameOfPerson: widget
                                                                                    .itemData[indexOFWholeListView]['NameOfPerson'],
                                                                                PaymentAfterDate: widget
                                                                                    .itemData[indexOFWholeListView]['PayAfterDay'],
                                                                                remarks: widget
                                                                                    .itemData[indexOFWholeListView]['Remarks'],

                                                                                EntryType: widget
                                                                                    .itemData[indexOFWholeListView]['EntryType']
                                                                                    .toString(),
                                                                                accountName: widget
                                                                                    .itemData[
                                                                                indexOFWholeListView]
                                                                                ['Account Name']
                                                                                    .toString(),
                                                                                date: widget
                                                                                    .itemData[
                                                                                indexOFWholeListView]
                                                                                ['Date']
                                                                                    .toString(),
                                                                                salePur1Id: widget
                                                                                    .itemData[indexOFWholeListView]['Entry ID'],
                                                                                map: listItemSalePur[index],
                                                                                action: 'EDIT',
                                                                              ));
                                                                        },
                                                                      );
                                                                    }
                                                                  });
                                                            } else {
                                                              return popUpButtonForItemEdit(
                                                                  checkEditForUserItem: snapshot
                                                                      .data![0]['Edting']
                                                                      .toString(),
                                                                  onSelected:
                                                                      (value) {
                                                                    if (value ==
                                                                        0) {
                                                                      if (!snapshot
                                                                          .data![0]['Edting']
                                                                          .toString()
                                                                          .contains(
                                                                          'false')) {
                                                                        showGeneralDialog(
                                                                          context: context,
                                                                          pageBuilder: (
                                                                              BuildContext context,
                                                                              Animation<
                                                                                  double> animation,
                                                                              Animation<
                                                                                  double> secondaryAnimation) {
                                                                            return AnimatedContainer(
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    bottom: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .viewInsets
                                                                                        .bottom),
                                                                                duration: const Duration(
                                                                                    milliseconds: 300),
                                                                                alignment: Alignment
                                                                                    .center,
                                                                                child: SalesPur2Dialog(
                                                                                  accountID: widget
                                                                                      .itemData[indexOFWholeListView]['Account ID'],
                                                                                  id: widget
                                                                                      .itemData[indexOFWholeListView]['ID'],
                                                                                  contactNo: widget
                                                                                      .itemData[indexOFWholeListView]['ContactNo'],
                                                                                  NameOfPerson: widget
                                                                                      .itemData[indexOFWholeListView]['NameOfPerson'],
                                                                                  PaymentAfterDate: widget
                                                                                      .itemData[indexOFWholeListView]['PayAfterDay'],
                                                                                  remarks: widget
                                                                                      .itemData[indexOFWholeListView]['Remarks'],

                                                                                  accountName: widget
                                                                                      .itemData[
                                                                                  indexOFWholeListView]
                                                                                  ['Account Name']
                                                                                      .toString(),
                                                                                  date: widget
                                                                                      .itemData[
                                                                                  indexOFWholeListView]
                                                                                  ['Date']
                                                                                      .toString(),
                                                                                  EntryType: widget
                                                                                      .itemData[indexOFWholeListView]['EntryType']
                                                                                      .toString(),
                                                                                  salePur1Id: widget
                                                                                      .itemData[indexOFWholeListView]['Entry ID'],
                                                                                  map: listItemSalePur[index],
                                                                                  action: 'EDIT',
                                                                                ));
                                                                          },
                                                                        );
                                                                      }
                                                                    }
                                                                  });
                                                            }
                                                          } else {
                                                            return SizedBox();
                                                          }
                                                        })),
                                              ],
                                            ),
                                      ),
                                    ),
                                  )
                                      : Column(
                                    children: [
                                      GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: listItemSalePur.length,
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                            sliderValue),
                                        itemBuilder: (context, index) =>
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    child: Align(
                                                        alignment: Alignment
                                                            .topRight,
                                                        child: FutureBuilder(
                                                          future: _salePurSQLDataBase
                                                              .userRightsChecking(
                                                              widget
                                                                  .menuName),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                  List>
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              if (SharedPreferencesKeys
                                                                  .prefs!
                                                                  .getString(
                                                                  SharedPreferencesKeys
                                                                      .userRightsClient) ==
                                                                  'Admin') {
                                                                return popUpButtonForItemEdit(
                                                                    checkEditForUserItem: 'true',
                                                                    onSelected: (
                                                                        value) async {
                                                                      if (value ==
                                                                          0) {
                                                                        List argumentList = [
                                                                        ];
                                                                        if (widget
                                                                            .itemData[indexOFWholeListView]['EntryType']
                                                                            .toString()
                                                                            .length ==
                                                                            0) {
                                                                          print(
                                                                              '......................if.......................');
                                                                          List listOFDataLedgerFromCashBook =
                                                                          await _cashBookSQL
                                                                              .getDataForLedgerFromCashBook(
                                                                              widget
                                                                                  .itemData[indexOFWholeListView]['Entry ID']);
                                                                          argumentList =
                                                                          [
                                                                            {
                                                                              "action": "EDIT"
                                                                            },
                                                                            listOFDataLedgerFromCashBook[0]
                                                                          ];
                                                                        }
                                                                        showGeneralDialog(
                                                                          context:
                                                                          context,
                                                                          pageBuilder: (
                                                                              BuildContext context,
                                                                              Animation<
                                                                                  double>
                                                                              animation,
                                                                              Animation<
                                                                                  double>
                                                                              secondaryAnimation) {
                                                                            return AnimatedContainer(
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    bottom: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .viewInsets
                                                                                        .bottom),
                                                                                duration: const Duration(
                                                                                    milliseconds: 300),
                                                                                alignment: Alignment
                                                                                    .center,
                                                                                child: widget
                                                                                    .itemData[indexOFWholeListView]['EntryType']
                                                                                    .toString()
                                                                                    .length ==
                                                                                    0
                                                                                    ? CashBook(
                                                                                    context: context,
                                                                                    list:
                                                                                    argumentList,
                                                                                    menuName:
                                                                                    'Cash Book')
                                                                                    : SalesPur2Dialog(
                                                                                  accountID: widget
                                                                                      .itemData[indexOFWholeListView]['Account ID'],
                                                                                  id: widget
                                                                                      .itemData[indexOFWholeListView]['ID'],
                                                                                  contactNo: widget
                                                                                      .itemData[indexOFWholeListView]['ContactNo'],
                                                                                  NameOfPerson: widget
                                                                                      .itemData[indexOFWholeListView]['NameOfPerson'],
                                                                                  PaymentAfterDate: widget
                                                                                      .itemData[indexOFWholeListView]['PayAfterDay'],
                                                                                  remarks: widget
                                                                                      .itemData[indexOFWholeListView]['Remarks'],

                                                                                  EntryType: widget
                                                                                      .itemData[indexOFWholeListView]['EntryType']
                                                                                      .toString(),
                                                                                  accountName: widget
                                                                                      .itemData[
                                                                                  indexOFWholeListView]
                                                                                  ['Account Name']
                                                                                      .toString(),
                                                                                  date: widget
                                                                                      .itemData[
                                                                                  indexOFWholeListView]
                                                                                  ['Date']
                                                                                      .toString(),
                                                                                  salePur1Id: widget
                                                                                      .itemData[indexOFWholeListView]['Entry ID'],
                                                                                  map: listItemSalePur[index],
                                                                                  action: 'EDIT',
                                                                                ));
                                                                          },
                                                                        );
                                                                      }
                                                                    });
                                                              } else {
                                                                return popUpButtonForItemEdit(
                                                                    checkEditForUserItem: snapshot
                                                                        .data![0]['Edting']
                                                                        .toString(),
                                                                    onSelected:
                                                                        (
                                                                        value) {
                                                                      if (value ==
                                                                          0) {
                                                                        if (!snapshot
                                                                            .data![0]['Edting']
                                                                            .toString()
                                                                            .contains(
                                                                            'false')) {
                                                                          showGeneralDialog(
                                                                            context:
                                                                            context,
                                                                            pageBuilder: (
                                                                                BuildContext context,
                                                                                Animation<
                                                                                    double> animation,
                                                                                Animation<
                                                                                    double> secondaryAnimation) {
                                                                              return AnimatedContainer(
                                                                                  padding: EdgeInsets
                                                                                      .only(
                                                                                      bottom: MediaQuery
                                                                                          .of(
                                                                                          context)
                                                                                          .viewInsets
                                                                                          .bottom),
                                                                                  duration: const Duration(
                                                                                      milliseconds: 300),
                                                                                  alignment: Alignment
                                                                                      .center,
                                                                                  child: SalesPur2Dialog(
                                                                                    accountID: widget
                                                                                        .itemData[indexOFWholeListView]['Account ID'],
                                                                                    id: widget
                                                                                        .itemData[indexOFWholeListView]['ID'],
                                                                                    contactNo: widget
                                                                                        .itemData[indexOFWholeListView]['ContactNo'],
                                                                                    NameOfPerson: widget
                                                                                        .itemData[indexOFWholeListView]['NameOfPerson'],
                                                                                    PaymentAfterDate: widget
                                                                                        .itemData[indexOFWholeListView]['PayAfterDay'],
                                                                                    remarks: widget
                                                                                        .itemData[indexOFWholeListView]['Remarks'],

                                                                                    accountName: widget
                                                                                        .itemData[
                                                                                    indexOFWholeListView]
                                                                                    ['Account Name']
                                                                                        .toString(),
                                                                                    date: widget
                                                                                        .itemData[
                                                                                    indexOFWholeListView]
                                                                                    ['Date']
                                                                                        .toString(),
                                                                                    EntryType: widget
                                                                                        .itemData[indexOFWholeListView]['EntryType']
                                                                                        .toString(),
                                                                                    salePur1Id: widget
                                                                                        .itemData[indexOFWholeListView]['Entry ID'],
                                                                                    map: listItemSalePur[index],
                                                                                    action: 'EDIT',
                                                                                  ));
                                                                            },
                                                                          );
                                                                        }
                                                                      }
                                                                    });
                                                              }
                                                            } else {
                                                              return SizedBox();
                                                            }
                                                          },
                                                        )),
                                                  ),
                                                  Flexible(
                                                    child: customGridView(
                                                        itemName: listItemSalePur[
                                                        index]
                                                        ['ItemName']
                                                            .toString(),
                                                        price:
                                                        listItemSalePur[
                                                        index]
                                                        ['Price']
                                                            .toString(),
                                                        quantity:
                                                        listItemSalePur[
                                                        index]
                                                        ['Qty']
                                                            .toString(),
                                                        total:
                                                        listItemSalePur[
                                                        index]
                                                        ['Total']
                                                            .toString()),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  opacity = 1;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.settings,
                                                color: Colors.grey,
                                                size: 12,
                                              )),
                                          Opacity(
                                            opacity: opacity,
                                            child: Slider(
                                                value: sliderValue
                                                    .toDouble(),
                                                min: 1.0,
                                                max: 4.0,
                                                onChanged:
                                                    (double value) {
                                                  setState(() {
                                                    sliderValue =
                                                        value.toInt();
                                                  });
                                                }),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                    ),
                  ),

                  ///   received.............................................................
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24, top: 8, bottom: 8),
                    child: Container(
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                      child: ExpansionTile(
                        initiallyExpanded: widget.status == 'Ledger'
                            ? true
                            : false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Receiving'),
                            IconButton(onPressed: () async {
                              int maxID = await _cashBookSQL.maxID();
                              List argumentList = [
                                {"action": "Receiving"},
                                widget.itemData[indexOFWholeListView],
                                maxID
                              ];

                              showGeneralDialog(
                                context: context,
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double>
                                    secondaryAnimation) {
                                  return AnimatedContainer(
                                    padding: EdgeInsets.only(
                                        bottom:
                                        MediaQuery
                                            .of(context)
                                            .viewInsets
                                            .bottom),
                                    duration: const Duration(
                                        milliseconds: 300),
                                    alignment: Alignment.center,
                                    child: Center(child: SizedBox(
                                        height: 410, child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CashBook(list: argumentList,
                                          context: context,
                                          tableID: widget.tableID  ?? 0,
                                          menuName: widget.menuName),
                                    ))),
                                  );
                                },
                              );
                            }, icon: Icon(
                              Icons.add, color: Colors.grey, size: 20,))
                          ],
                        ),
                        children: [
                          FutureBuilder<List>(
                            future: _salePurSQLDataBase.receivedAgainstBill(
                                entryType: widget
                                    .itemData[indexOFWholeListView]['EntryType'],
                                entryID: widget
                                    .itemData[indexOFWholeListView]['Entry ID']
                                    .toString()),
                            builder: (BuildContext context, AsyncSnapshot<
                                List> snapshot) {
                              if (snapshot.hasData) {
                                return CashItemUI(showStatus: 'Receiving',
                                    list: snapshot.data!,
                                    menuName: widget.menuName);
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  ///   payment.............................................................
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24, top: 8, bottom: 8),
                    child: Container(
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                      child: ExpansionTile(
                        initiallyExpanded: widget.status == 'Ledger'
                            ? true
                            : false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text('Payment'),
                            IconButton(onPressed: () async {
                              int maxID = await _cashBookSQL.maxID();
                              List argumentList = [
                                {"action": "Payment"},
                                widget.itemData[indexOFWholeListView],
                                maxID
                              ];

                              showGeneralDialog(
                                context: context,
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double>
                                    secondaryAnimation) {
                                  return AnimatedContainer(
                                    padding: EdgeInsets.only(
                                        bottom:
                                        MediaQuery
                                            .of(context)
                                            .viewInsets
                                            .bottom),
                                    duration: const Duration(
                                        milliseconds: 300),
                                    alignment: Alignment.center,
                                    child: Center(child: SizedBox(
                                        height: 410, child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CashBook(list: argumentList,
                                          context: context,
                                          menuName: widget.menuName),
                                    ))),
                                  );
                                },
                              );
                            }, icon: Icon(
                              Icons.add, color: Colors.grey, size: 20,))
                          ],
                        ),
                        children: [
                          FutureBuilder<List>(
                            future: _salePurSQLDataBase.paymentAgainstBill(
                                entryType: widget
                                    .itemData[indexOFWholeListView]['EntryType']
                                    .toString(),
                                entryID: widget
                                    .itemData[indexOFWholeListView]['Entry ID']
                                    .toString()),
                            builder: (BuildContext context, AsyncSnapshot<
                                List> snapshot) {
                              if (snapshot.hasData) {
                                return CashItemUI(showStatus: 'Payment',
                                    list: snapshot.data!,
                                    menuName: widget.menuName);
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          )

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
    );
  }


  Widget popUpButtonForItemEdit(
      {Function(int)? onSelected, required String checkEditForUserItem}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(bottom: 5),
      icon: Icon(
        Icons.more_horiz,
        size: 20,
        color: Colors.grey,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              value: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit'),
                  !checkEditForUserItem.toString().contains('false')
                      ? Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  )
                      : Icon(
                    Icons.block,
                    color: Colors.red,
                  )
                ],
              )),
          PopupMenuItem(value: 1, child: Text('Delete')),
        ];
      },
    );
  }

  Widget customGridView({required String itemName,
    required String quantity,
    required String price,
    required String total}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue.shade200,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 7,
                offset: Offset(5, 5),
                spreadRadius: 2)
          ],
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Flexible(
            flex: 70,
            child: Image(
                image: AssetImage('assets/images/easysoft_logo.jpg'),
                fit: BoxFit.fill,
                width: double.infinity),
          ),
          Flexible(
            flex: 30,
            child: Column(
              children: [
                Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: .4))),
                      alignment: Alignment.center,
                      child: Text(
                        itemName,
                        style: TextStyle(fontSize: 10),
                      ),
                    )),
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                          flex: 5,
                          child: Center(
                            child: Column(
                              children: [
                                Flexible(
                                    flex: 5,
                                    child: Center(
                                      child: Text(
                                        quantity,
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    )),
                                Flexible(
                                    flex: 5,
                                    child: Center(
                                      child: Text(
                                        price,
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    ))
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(left: BorderSide(width: .4))),
                            alignment: Alignment.center,
                            child: Text(
                              total,
                              style: TextStyle(fontSize: 12),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget customListView({
    required String itemName,
    required String quantity,
    required String price,
    required String total,
    required String itemGroupName,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: .5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 5,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(itemName),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        itemGroupName,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(fontSize: 12),
                          )),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            price.toString(),
                            style: TextStyle(fontSize: 12),
                          )),
                    ],
                  ),
                  Flexible(
                      child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(total.toString()),
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> ShowPrintPreviewAndWhatsAppShareDialog({
  required VoidCallback? onPrintPreviewPress(),
  required VoidCallback? onPrintPress(),
  required VoidCallback? onWhatsAppPress(),
})async{
return showDialog(context: context, builder: (BuildContext context){
return Dialog(
backgroundColor:Colors.white,

child: Container(
height: MediaQuery.of(context).size.height*0.3,
width: MediaQuery.of(context).size.width*0.3,

child: Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
crossAxisAlignment: CrossAxisAlignment.center,
children: [

ElevatedButton(

onPressed: onPrintPreviewPress, child: Text('Print Preview')),
ElevatedButton(onPressed: onPrintPress, child: Text('Print')),
ElevatedButton(onPressed: onWhatsAppPress, child: Text('WhatsApp')),
ElevatedButton(onPressed: (){
Navigator.pop(context);
}, child: Text('Go Back')),

],
),

),
);
});
}

void sharePdf(dynamic data) async {
  final directory = await getExternalStorageDirectory();
  final pdfPath = await File(
    '${directory!.path}/${DateTime.now().microsecondsSinceEpoch}.pdf',
  );
  await pdfPath.writeAsBytes(data);
  await WhatsappShare.shareFile(
    filePath: [pdfPath.path],
    phone: '923185583779',
  );
}

void _printInvoice(BuildContext context,dynamic data) async {
  bool? isConnected = await bluetooth.isConnected;
  if (isConnected!) {
    final directory = await getExternalStorageDirectory();
    final pdfPath = await File(
      '${directory!.path}/${DateTime.now().microsecondsSinceEpoch}.pdf',
    );
    await pdfPath.writeAsBytes(data);
    bluetooth.printImage(pdfPath.path).then((value) {
      print('printing wait');
    }).onError((error, stackTrace) {
      print('error during print');
    });
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
