import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../main/tab_bar_pages/home/themedataclass.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import '../../material/dateGrouping.dart';
import '../../material/datepickerstyle2.dart';
import '../SalePur/sale_pur1_SQL.dart';
import 'CashBookEntryDialogUI.dart';
import 'CashBookListUI.dart';
import 'cashBookSql.dart';

class DefaultCashBookUI extends StatefulWidget {
  final String? menuName;

  const DefaultCashBookUI({Key? key, this.menuName}) : super(key: key);

  @override
  _DefaultCashBookUIState createState() => _DefaultCashBookUIState();
}

class _DefaultCashBookUIState extends State<DefaultCashBookUI> {
  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  String viewStatus = 'DateTreeView';
  String countryClientId2 = SharedPreferencesKeys.prefs!
      .getString(SharedPreferencesKeys.countryClientID2)!;
  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  CashBookSQL _cashBookSQL = CashBookSQL();
  bool check = true;
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  bool hideFromAndToDate = false;
  bool hideAccountName = false;
  bool hideSearch = false;

  List<Color> colorsList = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.grey.shade600
  ];
  List<String> type = ["SL", "PU", "SR", "PR", "CB"];
  Color myColor = Color(Random().nextInt(0xffffffff));

  List list = [];
  List originalList = [];
  Future<List>? getDefaultQueryRef;
  List newEntriesRecord = [];
  List modifiedRecord = [];
  List allDataFromServer = [];
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  final TextStyle posRes =
      TextStyle(color: Colors.black, backgroundColor: Colors.yellow);

  @override
  void initState() {
    SharedPreferencesKeys.prefs!.setString(SharedPreferencesKeys.toDate,
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
    date2 =
        SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) => FutureBuilder(
          future: _cashBookSQL.getDefaultCashBookQueryData(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              list = snapshot.data!;
              print('.......cashbook data...................${list.length}');

              newEntriesRecord.clear();
              modifiedRecord.clear();
              allDataFromServer.clear();
              for (int count = 0; count < list.length; count++) {
                myColor = (list[count]['EntryType'] == "SL")
                    ? colorsList[0]
                    : (list[count]['EntryType'] == "PU")
                        ? colorsList[1]
                        : (list[count]['EntryType'] == "SR")
                            ? colorsList[2]
                            : (list[count]['EntryType'] == "PR")
                                ? colorsList[3]
                                : colorsList[4];
                if (list[count]['UpdatedDate'].toString().length == 0 &&
                    list[count]['CashBookID'] < 0) {
                  newEntriesRecord.add(list[count]);
                }
                if (list[count]['UpdatedDate'].toString().length == 0 &&
                    list[count]['CashBookID'] > 0) {
                  modifiedRecord.add(list[count]);
                }

                if (list[count]['UpdatedDate'].toString().length > 0) {
                  allDataFromServer.add(list[count]);
                }
              }

              return Container(
                color: Provider.of<ThemeDataHomePage>(context, listen: false)
                    .backGroundColor,
                child: ListView(
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ///  //////////////////   Search TextView ////////////////////////////////////
                            hideSearch
                                ? SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                      // controller: _searchController,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.search),
                                          labelText: "Search",
                                          hintText: "Search",
                                          filled: true,
                                          fillColor: Colors.white,
                                          focusColor: Colors.green,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 20,
                                                  style: BorderStyle.solid))),
                                      //controller: _searchController,
                                      onChanged: (value) {
                                        getSearchList(value);

                                        if (value.length == 0) {
                                          print("value is zero");
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  )
                                : SizedBox(),
                            hideFromAndToDate
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        var dateTime =
                                            await Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                          var date = DatePickerStyle2();
                                          return date;
                                        }));
                                        print('.....datetime $dateTime..');
                                        setState(() {});
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('From: ${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(date1.substring(0, 4)), int.parse(date1.substring(
                                                5,
                                                7,
                                              )), int.parse(date1.substring(8, 10)))).toString()}'),
                                          Text('To     :${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(date2.substring(0, 4)), int.parse(date2.substring(
                                                5,
                                                7,
                                              )), int.parse(date2.substring(8, 10)))).toString()}'),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),

                            ///  //////////////////   account name  ////////////////////////////////////
                            hideAccountName
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Text(''
                                        // dropDownAccountNameMap['Title'],
                                        // overflow: TextOverflow.fade,
                                        ))
                                : SizedBox(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (hideSearch) {
                                      hideSearch = false;
                                    } else {
                                      hideSearch = true;
                                    }
                                  });
                                },
                                icon: Icon(Icons.search)),

                            ///  //////////////////   From and To   Date  ////////////////////////////////////

                            ///  //////////////////   filter Icon  ////////////////////////////////////
                            PopupMenuButton<int>(
                              icon: Icon(
                                Icons.filter_alt_outlined,
                              ),
                              onSelected: (int value) async {
                                if (value == 1) {
                                  hideFromAndToDate = false;
                                }
                                if (value == 0) {
                                  hideFromAndToDate = true;
                                  var dateTime = await Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    var date = DatePickerStyle2();
                                    return date;
                                  }));
                                  print('.....datetime $dateTime..');
                                  setState(() {});
                                }
                                setState(() {});
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                      value: 0, child: Text('Filter by Date')),
                                  PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        'clear all Filter',
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ];
                              },
                            ),

                            ///  //////////////////  Views List And Grid  ////////////////////////////////////
                            PopupMenuButton<int>(
                              icon: Icon(
                                Icons.list,
                              ),
                              onSelected: (int value) {
                                if (value == 0) {
                                  setState(() {
                                    viewStatus = 'DateTreeView';

                                    SharedPreferencesKeys.prefs!
                                        .setString('ViewStatus', viewStatus);
                                  });
                                }
                                if (value == 1) {
                                  setState(() {
                                    viewStatus = 'ListView';
                                    SharedPreferencesKeys.prefs!
                                        .setString('ViewStatus', viewStatus);
                                  });
                                }

                                if (value == 2) {
                                  setState(() {
                                    viewStatus = 'TableView';
                                    SharedPreferencesKeys.prefs!
                                        .setString('ViewStatus', viewStatus);
                                  });
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                      value: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.account_tree),
                                          Text('DateTreeView'),
                                        ],
                                      )),
                                  PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.list),
                                          Text('ListView'),
                                        ],
                                      )),
                                  PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.grid_on),
                                          Text('TableView'),
                                        ],
                                      )),
                                ];
                              },
                            ),

                            ///  //////////////////  select account Name  ////////////////////////////////////
                            FutureBuilder(
                              future: _salePurSQLDataBase.dropDownData1(),
                              builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) =>
                                  PopupMenuButton<int>(
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onSelected: (int value) async {
                                  setState(() {});
                                },
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                        value: 0, child: Text('Default Account')),
                                  ];
                                },
                              ),
                            ),

                            ///  //////////////////   Add invoice button ////////////////////////////////////

                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              ),
                              onPressed: () async {
                                int maxID = await _cashBookSQL.maxID();
                                print('...................max     $maxID');

                                List list = [
                                  {"action": "ADD"},
                                  {'maxID': maxID}
                                ];
                                await showGeneralDialog(
                                  context: context,
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return AnimatedContainer(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      duration: const Duration(milliseconds: 300),
                                      alignment: Alignment.center,
                                      child: Center(
                                          child: SizedBox(
                                              height: 410,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CashBook(
                                                    context: context,
                                                    list: list,
                                                    menuName: widget.menuName),
                                              ))),
                                    );
                                  },
                                );
                                print(
                                    '................setSate..................');
                                setState(() {});
                              },
                              child: Icon(
                                Icons.add,
                                color: snapshot.data!.length != 0
                                    ? !snapshot.data![0]['Edting']
                                            .toString()
                                            .contains('false')
                                        ? Colors.white
                                        : Colors.white
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    newEntriesRecord.length == 0
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Provider.of<ThemeDataHomePage>(context,
                                            listen: false)
                                        .borderTextAppBarColor,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: ExpansionTile(
                                  initiallyExpanded: true,
                                  title: Text(
                                    'New Entries',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  children: [
                                    CashItemUI(
                                      setState: setState,
                                      list: newEntriesRecord,
                                      menuName: widget.menuName,
                                      showStatus: 'NewEntries',
                                    )
                                  ]),
                            ),
                          ),
                    modifiedRecord.length == 0
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Provider.of<ThemeDataHomePage>(context,
                                          listen: false)
                                      .borderTextAppBarColor,
                                ),
                              ),
                              child: ExpansionTile(
                                  initiallyExpanded: true,
                                  title: Text('Modified Record',
                                      style: TextStyle(color: Colors.orange)),
                                  children: [
                                    CashItemUI(
                                      setState: setState,
                                      list: modifiedRecord,
                                      menuName: widget.menuName,
                                      showStatus: 'modifiedRecord',
                                    )
                                  ]),
                            ),
                          ),
                    SharedPreferencesKeys.prefs!.getString('ViewStatus') ==
                            'DateTreeView'
                        ? DateGrouping(
                            date: 'CBDate',
                            childWidget: 'CashBook',
                            amount: 'Amount',
                            updatedDate: 'UpdatedDate',
                            list: allDataFromServer,
                            menuName: widget.menuName,
                            color: myColor)
                        : Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Provider.of<ThemeDataHomePage>(context,
                                          listen: false)
                                      .borderTextAppBarColor,
                                ),
                              ),
                              child: CashItemUI(
                                setState: setState,
                                list: allDataFromServer,
                                menuName: widget.menuName,
                                showStatus: 'ListView',
                              ),
                            ),
                          ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  ///     Searching ////////////////////////////////
  void getSearchList(String value) {
    List<Map<dynamic, dynamic>> tempList = [];

    for (Map<dynamic, dynamic> element in originalList) {
      if (element['Remars']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['CreditAccountName']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['Amount']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['CashBookID']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['CBDate']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['DebitAccountName']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())) {
        tempList.add(element);
      }
    }
    list = tempList;
  }

  TextSpan searchMatch(String match, String searchText) {
    if (searchText == "") return TextSpan(text: match);
    var refinedMatch = match.toLowerCase();
    var refinedSearch = searchText.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: posRes,
          text: match.substring(0, refinedSearch.length),
          children: [
            searchMatch(
                match.substring(
                  refinedSearch.length,
                ),
                searchText),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: match, style: posRes);
      } else {
        return TextSpan(
          //style: negRes,
          text: match.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
                match.substring(
                  refinedMatch.indexOf(refinedSearch),
                ),
                searchText),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(
        text: match,
      );
    }
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      children: [
        searchMatch(
            match.substring(refinedMatch.indexOf(refinedSearch)), searchText)
      ],
    );
  }
}
