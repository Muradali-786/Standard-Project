import 'dart:math';

import 'package:com/pages/general_trading/SalePur/sale_pur1_SQL.dart';
import 'package:com/pages/general_trading/SalePurNewDesign/ui/ui2.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/material.dart';

import '../../../main/tab_bar_pages/home/home_page.dart';
import 'ui/ui1.dart';

class DefaultSalePurchase2 extends StatefulWidget {
  final Map dropDownMap;
  final String menuName;
  final ItemSelectedCallback? onItemSelected;

  const DefaultSalePurchase2({
    super.key,
    this.onItemSelected,
    required this.dropDownMap,
    required this.menuName,
  });

  @override
  State<DefaultSalePurchase2> createState() => _DefaultSalePurchase2State();
}

class _DefaultSalePurchase2State extends State<DefaultSalePurchase2> {
  SalePurSQLDataBase _purSQLDataBase = SalePurSQLDataBase();

  List filterList = [];
  Future<List>? getDefaultQueryRef;
  bool hideFromAndToDate = false;
  bool hideAccountName = false;
  bool hideSearch = false;
  final TextStyle posRes =
      TextStyle(color: Colors.black, backgroundColor: Colors.yellow);
  List<Color> colorsList = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.grey.shade600
  ];
  List<String> type = ["SL", "PU", "SR", "PR", "CB"];
  String viewStatus = 'DateTreeView';

  DateTime currentDate = DateTime.now();
  Color myColor = Color(Random().nextInt(0xffffffff));
  Map? dropDownMap;
  List list = [];
  List newEntriesRecord = [];
  List modifiedRecord = [];

  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  List originalList = [];
  List registerList = [];
  Map dropDownAccountNameMap = {
    "ID": 2,
    'Title': '',
    'SubTitle': null,
    "Value": null
  };

  @override
  void initState() {
    dropDownMap = widget.dropDownMap;
    if (SharedPreferencesKeys.prefs!
            .getString(SharedPreferencesKeys.defaultSaleTwoAccountName) ==
        null) {
      SharedPreferencesKeys.prefs!
          .setInt(SharedPreferencesKeys.defaultSaleTwoAccount, 2);
      SharedPreferencesKeys.prefs!
          .setString(SharedPreferencesKeys.defaultSaleTwoAccountName, 'Cash');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UI2(
                                dropDown: widget.dropDownMap,
                                menuName: widget.menuName,
                                appbarTitle: 'Add',
                              )));
                },
                child: Icon(Icons.add, color: Colors.white),
              ),
              Text('New Records'),
              UI1(dropDown: widget.dropDownMap),
              Text('Update Records'),
              UI1(dropDown: widget.dropDownMap),
            ],
          ),
        ),
      ),
    );
  }
}
