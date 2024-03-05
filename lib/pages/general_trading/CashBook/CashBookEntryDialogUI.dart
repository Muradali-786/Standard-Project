import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Server/RefreshDataProvider.dart';
import '../../../main/tab_bar_pages/home/themedataclass.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import '../../material/datepickerstyle1.dart';
import '../../material/drop_down_style1.dart';
import '../../restaurant/resturantSQL.dart';
import 'cashBookSql.dart';

class CashBook extends StatefulWidget {
  final String? menuName;
  final BuildContext context;
  final List list;
  final int? tableID;

  const CashBook({Key? key,required this.context, this.tableID = 0,required this.list, this.menuName})
      : super(key: key);

  @override
  _CashBookState createState() => _CashBookState();
}

class _CashBookState extends State<CashBook> {
  DateTime selectedDate = DateTime.now();
  TextEditingController remark_controller = TextEditingController();
  TextEditingController amount_controller = TextEditingController();
  TextEditingController date_controller = TextEditingController();
  RefreshDataProvider refreshing = RefreshDataProvider();
  Map? data;
  Map<String, int> DataForAdd = {};
  CashBookSQL _cashBookSQL = CashBookSQL();
  String cashBookID = '';
  Map dropDownDebitMap = {
    "ID": null,
    'Title': "Debit Account",
    'SubTitle': null,
    "Value": null
  };
  String entryType = '';
  String entryID = '';
  Map dropDownCredit = {
    "ID": null,
    'Title': "Credit Account",
    'SubTitle': null,
    "Value": null
  };
  Map map = {};

  @override
  void initState() {

    map = widget.list[0];
    if (map['action'] == "EDIT") {
      data = widget.list[1];


      selectedDate = DateTime(
          int.parse(data!['CBDate'].toString().substring(0, 4)),
          int.parse(data!['CBDate'].toString().substring(5, 7)),
          int.parse(data!['CBDate'].toString().substring(8, 10)));
      cashBookID = data!['CashBookID'].toString();
      dropDownDebitMap = {
        "ID": data!['DebitAccount'],
        'Title': data!['DebitAccountName'],
        'SubTitle': null,
        "Value": null
      };
      dropDownCredit = {
        "ID": data!['CreditAccount'],
        'Title': data!['CreditAccountName'],
        'SubTitle': null,
        "Value": null
      };
      remark_controller.text = data!['CBRemarks'].toString();
      amount_controller.text = data!['Amount'].toString();
    }
    if (map['action'] == "ADD") {

      DataForAdd = widget.list[1];

      cashBookID = DataForAdd['maxID'].toString();
    }
    if (map['action'] == "Receiving") {
      data = widget.list[1];
      dropDownCredit = {
        "ID": data!['Account ID'],
        'Title': data!['Account Name'],
        'SubTitle': null,
        "Value": null
      };
      amount_controller.text = data!['BillAmount'].toString();
      remark_controller.text = data!['Remarks'];
      entryType = data!['EntryType'];
      entryID = data!['Entry ID'].toString();

      cashBookID = widget.list[2].toString();
    }
    if (map['action'] == "Payment") {
      data = widget.list[1];
      dropDownDebitMap = {
        "ID": data!['Account ID'],
        'Title': data!['Account Name'],
        'SubTitle': null,
        "Value": null
      };
      amount_controller.text = data!['BillAmount'].toString();
      remark_controller.text = data!['Remarks'];
      entryType = data!['EntryType'];
      entryID = data!['Entry ID'].toString();

      cashBookID = widget.list[2].toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(child: () {
        if (widget.list[1]['action'] == 'EDIT') {
          if (int.parse(cashBookID) < 0) {
            return CashBookEntryDialog(context);
          }
        }
        if (SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.userRightsClient) ==
            'Custom Right') {
          if (widget.list[1]['action'] == 'ADD') {
            return Center(
              child: FutureBuilder<bool>(
                future: _cashBookSQL.userRightsChecking(
                    columnName: 'Inserting', menuName: widget.menuName!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == false) {
                      return AlertDialog(
                        title: Text("Message"),
                        content:
                            Text('You have no inserting rights by the admin'),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          )
                        ],
                      );
                    } else {
                      return CashBookEntryDialog(context);
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            );
          } else {
            return Center(
              child: FutureBuilder<bool>(
                future: _cashBookSQL.userRightsChecking(
                    columnName: 'Edting', menuName: widget.menuName!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == false) {
                      return AlertDialog(
                        title: Text("Message"),
                        content:
                            Text('You have no Editing rights by the admin'),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          )
                        ],
                      );
                    } else {
                      return CashBookEntryDialog(context);
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            );
          }
        } else {
          return CashBookEntryDialog(context);
        }
      }()),
    );
  }

  Widget CashBookEntryDialog(BuildContext context) {
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
        width : Platform.isWindows ?   MediaQuery.of(context).size.width * .5  :MediaQuery.of(context).size.width,
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
                    map['action'] == "Receiving"
                        ? Text(
                            'CB ${cashBookID.toString()} ${entryType.toString()}_Rec $entryID',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : map['action'] == "Payment"
                            ? Text(
                                'CB ${cashBookID.toString()} ${entryType.toString()}_Pay $entryID',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            : Text(
                                'CB ${cashBookID.toString()}',
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top : 8),
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
                Padding(
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
                Padding(
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
                  padding: const EdgeInsets.only(left: 8.0, right:  8),
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

                                if(dropDownDebitMap['ID'] != null && dropDownCredit['ID'] != null && amount_controller.text.isNotEmpty  ){
                                if ((widget.list[0]["action"] == "EDIT")) {

                                  await _cashBookSQL.UpdateCashBook(
                                      data!['CashBookID'],
                                      date_controller.text,
                                      dropDownDebitMap['ID'].toString(),
                                      dropDownCredit['ID'].toString(),
                                      remark_controller.text,
                                      amount_controller.text,
                                      DateFormat('yyyy-MM-dd kk:mm:ss')
                                          .format(DateTime.now())
                                          .toString());
                                } else if ((widget.list[0]["action"] ==
                                    "Receiving")) {

                                  await _cashBookSQL.insertCashBook(
                                      selectedDate.toString(),
                                      dropDownDebitMap['ID'].toString(),
                                      dropDownCredit['ID'].toString(),
                                      remark_controller.text,
                                      amount_controller.text,
                                      '${entryType.toString()}_Rec',
                                      entryID.toString(),
                                      "0",
                                      DateFormat('yyyy-MM-dd kk:mm:ss')
                                          .format(DateTime.now())
                                          .toString(),
                                      "");

                                  remark_controller.text = "";
                                  amount_controller.text = '';
                                  dropDownDebitMap = {
                                    "ID": null,
                                    'Title': "Debit Account",
                                    'SubTitle': null,
                                    "Value": null
                                  };
                                  dropDownCredit = {
                                    "ID": null,
                                    'Title': "Credit Account",
                                    'SubTitle': null,
                                    "Value": null
                                  };
                                } else if ((widget.list[0]["action"] ==
                                    "Payment")) {

                                  await _cashBookSQL.insertCashBook(
                                      selectedDate.toString(),
                                      dropDownDebitMap['ID'].toString(),
                                      dropDownCredit['ID'].toString(),
                                      remark_controller.text,
                                      amount_controller.text,
                                      '${entryType.toString()}_Pay',
                                      entryID.toString(),
                                      "0",
                                      DateFormat('yyyy-MM-dd kk:mm:ss')
                                          .format(DateTime.now())
                                          .toString(),
                                      "");

                                  remark_controller.text = "";
                                  amount_controller.text = '';
                                  dropDownDebitMap = {
                                    "ID": null,
                                    'Title': "Debit Account",
                                    'SubTitle': null,
                                    "Value": null
                                  };
                                  dropDownCredit = {
                                    "ID": null,
                                    'Title': "Credit Account",
                                    'SubTitle': null,
                                    "Value": null
                                  };
                                  setState(() {});
                                } else {
                                  await _cashBookSQL.insertCashBook(
                                      selectedDate.toString(),
                                      dropDownDebitMap['ID'].toString(),
                                      dropDownCredit['ID'].toString(),
                                      remark_controller.text,
                                      amount_controller.text,
                                      "",
                                      "",
                                      "0",
                                      DateFormat('yyyy-MM-dd kk:mm:ss')
                                          .format(DateTime.now())
                                          .toString(),
                                      "");
                                  remark_controller.text = "";
                                  amount_controller.text = '';
                                  dropDownDebitMap = {
                                    "ID": null,
                                    'Title': "Debit Account",
                                    'SubTitle': null,
                                    "Value": null
                                  };
                                  dropDownCredit = {
                                    "ID": null,
                                    'Title': "Credit Account",
                                    'SubTitle': null,
                                    "Value": null
                                  };
                                }

                                if(widget.tableID != 0) {
                                  await DatabaseHelper.updateTableSalePur1(
                                      tableID: widget.tableID!,
                                      salePur: 0);
                                }


                                  Navigator.pop(context);
                                setState(() {});
                              }else{
                                  await  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {

                                        return   AlertDialog(
                                          content:
                                          Text('All Field  Must Be Filled' ),
                                          actions: [TextButton(onPressed: (){

                                            Navigator.pop(context);
                                          }, child: Text( 'OK'  ))]);

                                      },
                                    );
                                }
                                },

                              child: Text((widget.list[0]["action"] != "EDIT")
                                  ? "Save"
                                  : "Edit")),
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
}
