


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../general_trading/CashBook/cashBookSql.dart';
import '../material/datepickerstyle1.dart';
import '../material/drop_down_style1.dart';
import '../tailor_shop_systom/sql_file.dart';
import '../tailor_shop_systom/widgets.dart';

class CashBookDialogForMarriageBooking extends StatefulWidget {
  final String? ID;
  final String? tableName;
  final String mode;
  final Map? data;

  const CashBookDialogForMarriageBooking(
      {super.key, this.ID, this.data, required this.mode, this.tableName});

  @override
  State<CashBookDialogForMarriageBooking> createState() => _CashBookDialogForMarriageBookingState();
}

class _CashBookDialogForMarriageBookingState extends State<CashBookDialogForMarriageBooking> {
  DateTime selectedDate = DateTime.now();

  CashBookSQL _cashBookSQL = CashBookSQL();

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
                                      selectedDate.toString(),
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
                                    selectedDate.toString(),
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