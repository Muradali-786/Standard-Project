import 'dart:io';
import 'package:com/pages/tailor_shop_systom/order_details_page.dart';
import 'package:com/pages/tailor_shop_systom/print_page.dart';
import 'package:com/pages/tailor_shop_systom/sql_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../general_trading/CashBook/cashBookSql.dart';
import '../material/datepickerstyle1.dart';
import '../material/drop_down_style1.dart';
import 'add_new_order_tailor.dart';

Widget menuBtnForOrderDetails({
  Function(int)? onSelected,
  void Function()? onTapCutting,
  void Function()? onTapSewing,
  void Function()? onTapFinished,
  void Function()? onTapDelivered,
}) {
  return PopupMenuButton<int>(
    padding: EdgeInsets.only(left: 8, bottom: 5),
    icon: Icon(
      Icons.more_vert_rounded,
      size: 20,
      color: Colors.black,
    ),
    onSelected: onSelected,
    itemBuilder: (context) {
      return [
        PopupMenuItem(
            value: 0,
            child: ExpansionTile(
              title: Text('Change Status'),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onTapCutting,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft, child: Text('Cutting')),
                  ),
                ),
                InkWell(
                  onTap: onTapSewing,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft, child: Text('Sewing')),
                  ),
                ),
                InkWell(
                  onTap: onTapFinished,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft, child: Text('Finished')),
                  ),
                ),
                InkWell(
                  onTap: onTapDelivered,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft, child: Text('Delivered')),
                  ),
                ),
              ],
            )),
        PopupMenuDivider(),
        PopupMenuItem(value: 1, child: Text('Details')),
        PopupMenuItem(value: 2, child: Text('Edit')),
        PopupMenuItem(value: 3, child: Text('Print/Cash Rec')),
      ];
    },
  );
}

Widget DropDownButton(
    {String? title, String? id, String? subtitle, int? value}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5)),
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 5,
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft, child: Text(title!)),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(id.toString()))
                ],
              )),
          Flexible(
            flex: 5,
            child: Icon(
              Icons.arrow_downward,
              color: Colors.grey,
              size: 17,
            ),
          )
        ],
      ),
    ),
  );
}

Future<void> showDialogForPrintCash({
  required BuildContext context,
  required void Function()? onPressedPrint,
  required void Function()? onPressedPrintPreview,
  required void Function()? onPressedCashRec,
  required void Function()? onPressedOtherExp,
  required void Function()? onPressedWhatsApp,
  required void Function()? onPressedBack,
}) async {
  await showDialog(
    context: context,
    builder: (context) => Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          child: Container(
            height: 320,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: onPressedPrint, child: Text('Print')),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: onPressedPrintPreview,
                        child: Text('Print Preview')),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: onPressedCashRec,
                        child: Text('Cash Receive')),
                  ),
                  SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: onPressedOtherExp,
                        child: Text('Other Expanse'),
                      )),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: onPressedWhatsApp,
                      child: Text('WhatsApp'),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: onPressedBack, child: Text('Go Back')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customListTile({
  required String title,
  required BuildContext context,
  required void Function(void Function()) state,
  required List data,
  required DateTime orderDate,
  required Map dropDownDebitMap,
}) {
  return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: ExpansionTile(
          title: Text(
            '$title (${data.length})',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  '10000',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  '10000',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              Text(
                '10000',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
          trailing: SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title == 'New Order'
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNewOrderTailor(),
                              ));
                        },
                        icon: Icon(
                          Icons.add,
                          size: 35,
                          color: Colors.green,
                        ),
                      )
                    : const SizedBox(),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailsPage(data: data[index]),
                        ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                        'Order No: ${data[index]['TailorBooking1ID']}'),
                                  ),
                                  Text('${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(data[index]['OrderDate'].toString().substring(0, 4)), int.parse(data[index]['OrderDate'].toString().substring(
                                        5,
                                        7,
                                      )), int.parse(data[index]['OrderDate'].toString().substring(8, 10)))).toString()}'),
                                ],
                              ),
                              Text(data[index]['CustomerName'].toString()),
                              Text(data[index]['OrderTitle'].toString()),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      data[index]['BillAmount'].toString(),
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      data[index]['TotalReceived'].toString(),
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    data[index]['BillBalance'].toString(),
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                          menuBtnForOrderDetails(
                            onSelected: (value) {
                              if (value == 1) {}
                              if (value == 2) {
                                ////////  edit/////////////////////////////////

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddNewOrderTailor(data: data[index]),
                                    ));
                              }
                              if (value == 3) {
                                showDialogForPrintCash(
                                    context: context,
                                    onPressedOtherExp: () {
                                      showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return AnimatedContainer(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: SizedBox(
                                                height: 410,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Material(
                                                    child: CashBookDialog(
                                                        mode: 'ADD',
                                                        ID: data[index][
                                                                'TailorBooking1ID']
                                                            .toString(),
                                                        tableName: 'TS_Exp'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    onPressedBack: () {
                                      Navigator.pop(context);
                                    },
                                    onPressedCashRec: () async {
                                      showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return AnimatedContainer(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: SizedBox(
                                                height: 410,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Material(
                                                    child: CashBookDialog(
                                                        mode: 'ADD',
                                                        ID: data[index][
                                                                'TailorBooking1ID']
                                                            .toString(),
                                                        tableName: 'TS_Rec'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    onPressedPrintPreview: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PrintPage(
                                              data: data[index],
                                            ),
                                          ));
                                    },
                                    onPressedPrint: () async {
                                      //
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           PrintPage(data: data[index],),
                                      //     ));
                                    },
                                    onPressedWhatsApp: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PrintPage(
                                                    data: data[index],
                                                    captureScreenShot: true,
                                                  )));
                                    });
                              }
                            },
                            onTapCutting: () async {
                              Navigator.pop(context);
                              await dialogForChangeStatus(
                                  context: context,
                                  parentState: state,
                                  selectedStatus: 'Cutting',
                                  orderDate: orderDate,
                                  dropDownDebitMap: dropDownDebitMap,
                                  ID: data[index]['ID'].toString());
                            },
                            onTapDelivered: () async {
                              Navigator.pop(context);
                              await dialogForChangeStatus(
                                  context: context,
                                  parentState: state,
                                  selectedStatus: 'Delivered',
                                  orderDate: orderDate,
                                  dropDownDebitMap: dropDownDebitMap,
                                  ID: data[index]['ID'].toString());
                            },
                            onTapFinished: () async {
                              Navigator.pop(context);
                              await dialogForChangeStatus(
                                context: context,
                                parentState: state,
                                selectedStatus: 'Finished',
                                ID: data[index]['ID'].toString(),
                                orderDate: orderDate,
                                dropDownDebitMap: dropDownDebitMap,
                              );
                            },
                            onTapSewing: () async {
                              Navigator.pop(context);
                              await dialogForChangeStatus(
                                context: context,
                                selectedStatus: 'Sewing',
                                parentState: state,
                                orderDate: orderDate,
                                ID: data[index]['ID'].toString(),
                                dropDownDebitMap: dropDownDebitMap,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ));
}

CashBookSQL _cashBookSQL = CashBookSQL();

Future dialogForChangeStatus({
  required BuildContext context,
  required String selectedStatus,
  required void Function(void Function()) parentState,
  required DateTime orderDate,
  required Map dropDownDebitMap,
  required String ID,
}) async {
  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, state) => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            child: Container(
              height: 270,
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: Text(
                        selectedStatus,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        onTap: () async {
                          orderDate = await showDialog(
                              context: context,
                              builder: (context) {
                                return DatePickerStyle1();
                              });
                          state(() {});
                        },
                        readOnly: true,
                        controller: TextEditingController(
                            text: '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(orderDate.toString().substring(0, 4)), int.parse(orderDate.toString().substring(
                                  5,
                                  7,
                                )), int.parse(orderDate.toString().substring(8, 10)))).toString()}'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          label: Text(
                            '${selectedStatus} Date',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: FutureBuilder(
                        future: _cashBookSQL.dropDownData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                              child: InkWell(
                                  onTap: () async {
                                    dropDownDebitMap = await showDialog(
                                      context: context,
                                      builder: (_) => DropDownStyle1(
                                        acc1TypeList: snapshot.data,
                                        dropdown_title:
                                            dropDownDebitMap['Title'],
                                        map: dropDownDebitMap,
                                        titleFor: 'Debit',
                                      ),
                                    );
                                    state(() {});
                                  },
                                  child: DropDownButton(
                                    title: dropDownDebitMap['Title'].toString(),
                                    id: dropDownDebitMap['ID'].toString(),
                                  )),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (selectedStatus == 'Cutting') {
                            String update = await updateStatusCutting(
                                cuttingAccount3ID:
                                    dropDownDebitMap['ID'].toString(),
                                cuttingDate: orderDate.toString(),
                                ID: ID);

                            if (update == 'Update') {
                              Navigator.pop(context);
                            }
                          }

                          if (selectedStatus == 'Sewing') {
                            String update = await updateStatusSewing(
                                sewingAccount3ID:
                                    dropDownDebitMap['ID'].toString(),
                                sewingDate: orderDate.toString(),
                                ID: ID);

                            if (update == 'Update') {
                              Navigator.pop(context);
                            }
                          }

                          if (selectedStatus == 'Finished') {
                            String update = await updateStatusFinished(
                                FinishedAccount3ID:
                                    dropDownDebitMap['ID'].toString(),
                                FinishedDate: orderDate.toString(),
                                ID: ID);

                            if (update == 'Update') {
                              Navigator.pop(context);
                            }
                          }

                          parentState(() {});
                        },
                        child: Text('SAVE'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget menuForCB({
  Function(int)? onSelected,
}) {
  return PopupMenuButton<int>(
    padding: EdgeInsets.only(left: 8, bottom: 5),
    icon: Icon(
      Icons.more_horiz,
      size: 20,
      color: Colors.black,
    ),
    onSelected: onSelected,
    itemBuilder: (context) {
      return [
        PopupMenuItem(value: 1, child: Text('Edit')),
        PopupMenuItem(value: 2, child: Text('Print Voucher')),
      ];
    },
  );
}

class CashBookDialog extends StatefulWidget {
  final String? ID;
  final String? tableName;
  final String mode;
  final Map? data;

  const CashBookDialog(
      {super.key, this.ID, this.data, required this.mode, this.tableName});

  @override
  State<CashBookDialog> createState() => _CashBookDialogState();
}

class _CashBookDialogState extends State<CashBookDialog> {
  DateTime selectedDate = DateTime.now();

  TextEditingController date_controller = TextEditingController();
  TextEditingController amount_controller = TextEditingController();
  TextEditingController remark_controller = TextEditingController();

  Map dropDownDebitMap = {
    "ID": 2,
    'Title': "Cash",
    'SubTitle': null,
    "Value": null
  };

  Map dropDownCredit = {
    "ID": 19,
    'Title': "Sewing Services",
    'SubTitle': null,
    "Value": null
  };

  @override
  void initState() {
    super.initState();
    if (widget.mode == 'EDIT') {
      date_controller.text = DateFormat(SharedPreferencesKeys.prefs!
              .getString(SharedPreferencesKeys.dateFormat))
          .format(DateTime(
              int.parse(widget.data!['CBDate'].toString().substring(0, 4)),
              int.parse(widget.data!['CBDate'].toString().substring(
                    5,
                    7,
                  )),
              int.parse(widget.data!['CBDate'].toString().substring(8, 10))))
          .toString();

      amount_controller.text = widget.data!['Amount'].toString();
      remark_controller.text = widget.data!['CBRemarks'].toString();

      dropDownDebitMap = {
        "ID": widget.data!['DebitAccountID'].toString(),
        'Title': widget.data!['DebitAccountName'].toString(),
        'SubTitle': null,
        "Value": null
      };
      dropDownCredit = {
        "ID": widget.data!['CreditAccountID'].toString(),
        'Title': widget.data!['CreditAccountName'].toString(),
        'SubTitle': null,
        "Value": null
      };
    } else {
      date_controller.text = DateFormat(SharedPreferencesKeys.prefs!
              .getString(SharedPreferencesKeys.dateFormat))
          .format(DateTime(
              int.parse(selectedDate.toString().substring(0, 4)),
              int.parse(selectedDate.toString().substring(
                    5,
                    7,
                  )),
              int.parse(selectedDate.toString().substring(8, 10))))
          .toString();
      dropDownCredit = widget.tableName == 'TS_Rec'
          ? {
              "ID": 19,
              'Title': "Sewing Services",
              'SubTitle': null,
              "Value": null
            }
          : {"ID": 2, 'Title': "Cash", 'SubTitle': null, "Value": null};
      dropDownDebitMap = widget.tableName == 'TableShop_Rec'
          ? {"ID": 2, 'Title': "Cash", 'SubTitle': null, "Value": null}
          : {
              "ID": 18,
              'Title': "Other JOb Expense",
              'SubTitle': null,
              "Value": null
            };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Provider.of<ThemeDataHomePage>(context, listen: false)
              .backGroundColor,
          border: Border.all(
            width: 2,
            color: Provider.of<ThemeDataHomePage>(context, listen: false)
                .borderTextAppBarColor,
          ),
        ),
        width: Platform.isWindows
            ? MediaQuery.of(context).size.width * .5
            : MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              color: Provider.of<ThemeDataHomePage>(context, listen: false)
                  .borderTextAppBarColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cashbook Entry",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Text(
                      'CB ${widget.mode == 'EDIT' ? widget.data!['CashBookID'].toString() : widget.ID.toString()}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  child: SizedBox(
                    height: 35,
                    child: TextField(
                      controller: date_controller,
                      readOnly: true,
                      onTap: () async {
                        selectedDate = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DatePickerStyle1()));

                        date_controller.text = DateFormat(SharedPreferencesKeys
                                .prefs!
                                .getString(SharedPreferencesKeys.dateFormat))
                            .format(DateTime(
                                int.parse(
                                    selectedDate.toString().substring(0, 4)),
                                int.parse(selectedDate.toString().substring(
                                      5,
                                      7,
                                    )),
                                int.parse(
                                    selectedDate.toString().substring(8, 10))))
                            .toString();

                        setState(() {});
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          focusColor: Colors.black,
                          fillColor: Colors.white,
                          filled: true,
                          suffix: Icon(Icons.expand_more),
                          label: Text(
                            'Date',
                            style: TextStyle(color: Colors.black),
                          ),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Debit',
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey.shade700),
                          )),
                      Icon(
                        CupertinoIcons.add,
                        color: Colors.green,
                        size: 15,
                      )
                    ],
                  ),
                ),
                IgnorePointer(
                  ignoring: widget.tableName != 'TS_Rec' ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, bottom: 8, top: 1),
                    child: FutureBuilder(
                      future: _cashBookSQL.dropDownData(),
                      //getting the dropdown data from query
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                            child: InkWell(
                                onTap: () async {
                                  dropDownDebitMap = await showDialog(
                                    context: context,
                                    builder: (_) => DropDownStyle1(
                                      acc1TypeList: snapshot.data,
                                      dropdown_title: dropDownDebitMap['Title'],
                                      map: dropDownDebitMap,
                                      titleFor: 'Debit',
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: DropDownButton(
                                  title: dropDownDebitMap['Title'].toString(),
                                  id: dropDownDebitMap['ID'].toString(),
                                )),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Credit',
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey.shade700),
                          )),
                      Icon(
                        CupertinoIcons.minus,
                        color: Colors.red,
                        size: 15,
                      )
                    ],
                  ),
                ),
                IgnorePointer(
                  ignoring: widget.tableName == 'TS_Rec' ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, bottom: 8, top: 1),
                    child: FutureBuilder(
                      future: _cashBookSQL.dropDownData(),
                      //getting the dropdown data from query
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                            child: InkWell(
                                onTap: () async {
                                  dropDownCredit = await showDialog(
                                    context: context,
                                    builder: (_) => DropDownStyle1(
                                      acc1TypeList: snapshot.data,
                                      dropdown_title: dropDownCredit['Title'],
                                      map: dropDownCredit,
                                      titleFor: 'Credit',
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: DropDownButton(
                                  title: dropDownCredit['Title'].toString(),
                                  id: dropDownCredit['ID'].toString(),
                                )),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 35,
                    child: TextField(
                      controller: remark_controller,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          focusColor: Colors.black,
                          fillColor: Colors.white,
                          filled: true,
                          label: Text(
                            'Remarks',
                            style: TextStyle(color: Colors.black),
                          ),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 37,
                    child: TextField(
                      controller: amount_controller,
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          focusColor: Colors.black,
                          fillColor: Colors.white,
                          filled: true,
                          label: Text(
                            'Amount',
                            style: TextStyle(color: Colors.black),
                          ),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width / 3,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ) // foreground
                                  ),
                              onPressed: () async {
                                if (widget.mode == 'ADD') {
                                  await _cashBookSQL.insertCashBook(
                                      selectedDate.toString().substring(0, 10),
                                      dropDownDebitMap['ID'].toString(),
                                      dropDownCredit['ID'].toString(),
                                      remark_controller.text,
                                      amount_controller.text.toString(),
                                      '${widget.tableName.toString()}',
                                      widget.ID.toString(),
                                      "0",
                                      DateFormat('yyyy-MM-dd kk:mm:ss')
                                          .format(DateTime.now())
                                          .toString(),
                                      "");
                                } else {
                                  await UpdateCashBookForTailor(
                                    widget.data!['CashBookID'],
                                    selectedDate.toString().substring(0, 10),
                                    dropDownDebitMap['ID'].toString(),
                                    dropDownCredit['ID'].toString(),
                                    remark_controller.text,
                                    amount_controller.text.toString(),
                                  );
                                }
                                Navigator.pop(context);
                              },
                              child: Text('SAVE')),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
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
                              Navigator.pop(context);

                              setState(() {});
                            },
                            child: Text('close'),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
