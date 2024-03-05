import 'dart:math';
import 'package:flutter/material.dart';
import 'package:com/pages/general_trading/SalePur/SalePurc1UI.dart';
import 'package:com/pages/general_trading/SalePur/sale_pur1_SQL.dart';
import 'package:com/pages/material/datepickerstyle2.dart';
import 'package:com/pages/material/drop_down_style1.dart';
import 'package:intl/intl.dart';
import '../../../main/tab_bar_pages/home/home_page.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import 'SalePur2AddItemUISingle.dart';

////////////////////////////////////////////////////////////////////////////////
///////////       SalePur1 List UI Code    ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class SalesPur1 extends StatefulWidget {
  final Map dropDownMap;
  final String menuName;
   final ItemSelectedCallback? onItemSelected;

  const SalesPur1({Key? key, this.onItemSelected, required this.dropDownMap, required this.menuName})
      : super(key: key);

  @override
  _SalesPur1State createState() => _SalesPur1State();
}

class _SalesPur1State extends State<SalesPur1> {
  TextEditingController _searchController = TextEditingController();
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
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  Map dropDownAccountNameMap = {
    "ID": null,
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /////////////////////// Searching Row //////////////////////////////
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
                            controller: _searchController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                labelText: "Search",
                                hintText: "Search",
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.green,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
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

                  ///  //////////////////   From and To   Date  ////////////////////////////////////
                  hideFromAndToDate
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () async {
                              var dateTime = await Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                var date = DatePickerStyle2();
                                return date;
                              }));
                              print('.....datetime $dateTime..');
                              setState(() {});
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          child: Text(
                            dropDownAccountNameMap['Title'],
                            overflow: TextOverflow.fade,
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

                  ///  //////////////////   filter Icon  ////////////////////////////////////
                  FutureBuilder(
                    future: _salePurSQLDataBase.dropDownData1(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return PopupMenuButton<int>(
                          icon: Icon(
                            Icons.filter_alt_outlined,
                          ),
                          onSelected: (int value) async {
                            filterList.clear();
                            if (value == 0) {
                              hideAccountName = true;
                                dropDownAccountNameMap = await showDialog(
                                context: context,
                                builder: (_) => DropDownStyle1(
                                  acc1TypeList: snapshot.data,
                                  dropdown_title:
                                      dropDownAccountNameMap['Title'],
                                  map: dropDownAccountNameMap,
                                ),
                              );

                              for (int count = 0;
                                  count < list.length;
                                  count++) {
                                if (list[count]['Account Name'].toString() ==
                                    dropDownAccountNameMap['Title']
                                        .toString()) {
                                  filterList.add(list[count]);
                                }
                              }
                            }

                            if (value == 2) {
                              dropDownAccountNameMap = {
                                "ID": null,
                                'Title': "",
                                'SubTitle': null,
                                "Value": null
                              };
                              hideFromAndToDate = false;
                            }
                            if (value == 1) {
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
                                  value: 0,
                                  child: Text('Filter by Account Name')),
                              PopupMenuItem(
                                  value: 1, child: Text('Filter by Date')),
                              PopupMenuItem(
                                  value: 2,
                                  child: Text(
                                    'clear all Filter',
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ];
                          },
                        );
                      } else {
                        return SizedBox();
                      }
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
                        });
                      }
                      if (value == 1) {
                        setState(() {
                          viewStatus = 'ListView';
                        });
                      }

                      if (value == 2) {
                        setState(() {
                          viewStatus = 'TableView';
                        });
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                            value: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.account_tree),
                                Text('DateTreeView'),
                              ],
                            )),
                        PopupMenuItem(
                            value: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.list),
                                Text('ListView'),
                              ],
                            )),
                        PopupMenuItem(
                            value: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        AsyncSnapshot<dynamic> snapshot) {
                      return PopupMenuButton<int>(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onSelected: (int value) async {
                          if (value == 0) {
                            print(
                                '..........................click...............');
                            print(
                                '.....................${dropDownAccountNameMap.toString()}.............');
                            dropDownAccountNameMap = await showDialog(
                              context: context,
                              builder: (_) => DropDownStyle1(
                                acc1TypeList: snapshot.data,
                                dropdown_title: dropDownAccountNameMap['Title'],
                                map: dropDownAccountNameMap,
                              ),
                            );

                            print(
                                '.....................${dropDownAccountNameMap.toString()}.............');

                            SharedPreferencesKeys.prefs!.setInt(
                                SharedPreferencesKeys.defaultSaleTwoAccount,
                                int.parse(dropDownAccountNameMap['ID']));
                            SharedPreferencesKeys.prefs!.setString(
                                SharedPreferencesKeys.defaultSaleTwoAccountName,
                                dropDownAccountNameMap['Title']);

                            print(
                                '.....................${dropDownAccountNameMap.toString()}.............');
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                                value: 0, child: Text('Default Account')),
                          ];
                        },
                      );
                    },
                  ),

                  ///  //////////////////   Add invoice button ////////////////////////////////////
                  FutureBuilder(
                    future:
                        _salePurSQLDataBase.userRightsChecking(widget.menuName),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                          onPressed: () async {
                            print(
                                '${snapshot.data!}..............................');
                            if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                'Custom Right') {
                              if (snapshot.data![0]['Inserting'].toString() ==
                                  'true') {
                                print(
                                    '.......current date.......${currentDate.toString().substring(0, 10)}...........');

                                var salePur1ID =
                                    await _salePurSQLDataBase.insertSalePur1(
                                        currentDate.toString().substring(0, 10),
                                        SharedPreferencesKeys.prefs!.getInt(
                                            SharedPreferencesKeys
                                                .defaultSaleTwoAccount),
                                        'remarks',
                                        'person',
                                        'paymentAfterDate',
                                        'contactNo',
                                        widget.dropDownMap);

                                print(
                                    '...........${widget.dropDownMap['SubTitle']}.............salePur1 ID..............$salePur1ID');
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
                                        duration:
                                            const Duration(milliseconds: 300),
                                        alignment: Alignment.center,
                                        child: SalesPur2Dialog(
                                          accountID: SharedPreferencesKeys
                                              .prefs!
                                              .getInt(SharedPreferencesKeys
                                                  .defaultSaleTwoAccount)!,
                                          id: salePur1ID,
                                          contactNo: 'contactNo',
                                          NameOfPerson: 'NameOfPerson',
                                          PaymentAfterDate: 'PayAfterDay',
                                          remarks: 'Remarks',
                                          date: currentDate
                                              .toString()
                                              .substring(0, 10),
                                          accountName: SharedPreferencesKeys
                                              .prefs!
                                              .getString(SharedPreferencesKeys
                                                  .defaultSaleTwoAccountName),
                                          EntryType:
                                              widget.dropDownMap['SubTitle'],
                                          salePur1Id: salePur1ID,
                                          map: {},
                                          action: 'ADD',
                                        ),
                                      );
                                    });

                                print(
                                    '.....................setSate////////////////////////');

                                setState(() {});
                              }
                            } else if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                'Admin') {
                              print(
                                  '.......current date.......${currentDate.toString().substring(0, 10)}...........');

                              var salePur1ID =
                                  await _salePurSQLDataBase.insertSalePur1(
                                      currentDate.toString().substring(0, 10),
                                      SharedPreferencesKeys.prefs!.getInt(
                                          SharedPreferencesKeys
                                              .defaultSaleTwoAccount),
                                      'remarks',
                                      'person',
                                      'paymentAfterDate',
                                      'contactNo',
                                      widget.dropDownMap);

                              print(
                                  '...........${widget.dropDownMap['SubTitle']}.............salePur1 ID..............$salePur1ID');
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
                                      duration:
                                          const Duration(milliseconds: 300),
                                      alignment: Alignment.center,
                                      child: SalesPur2Dialog(
                                        accountID: SharedPreferencesKeys.prefs!
                                            .getInt(SharedPreferencesKeys
                                                .defaultSaleTwoAccount)!,
                                        id: salePur1ID,
                                        contactNo: 'contactNo',
                                        NameOfPerson: 'NameOfPerson',
                                        PaymentAfterDate: 'PayAfterDay',
                                        remarks: 'Remarks',
                                        date: currentDate
                                            .toString()
                                            .substring(0, 10),
                                        accountName: SharedPreferencesKeys
                                            .prefs!
                                            .getString(SharedPreferencesKeys
                                                .defaultSaleTwoAccountName),
                                        EntryType:
                                            widget.dropDownMap['SubTitle'],
                                        salePur1Id: salePur1ID,
                                        map: {},
                                        action: 'ADD',
                                      ),
                                    );
                                  });

                              print(
                                  '.....................setSate////////////////////////');

                              setState(() {});
                            }
                          },
                          child: Icon(
                            Icons.add,
                            color: snapshot.data!.length != 0
                                ? !snapshot.data![0]['Edting']
                                        .toString()
                                        .contains('false')
                                    ? Colors.black
                                    : Colors.grey
                                : Colors.grey,
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),

        /// //////////////////// Data List //////////////////////////////
        Container(
            alignment: Alignment.center,
            child: FutureBuilder(
                future: _salePurSQLDataBase.getDefaultQueryData(
                    menuName: widget.menuName),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    newEntriesRecord.clear();
                    modifiedRecord.clear();

                    list = snapshot.data as List;

                    for (int count = 0; count < list.length; count++) {
                      if (list[count]['UpdatedDate'].toString().length == 0 &&
                          list[count]['Entry ID'] < 0) {
                        newEntriesRecord.add(list[count]);
                      }
                      if (list[count]['UpdatedDate'].toString().length == 0 &&
                          list[count]['Entry ID'] > 0) {
                        modifiedRecord.add(list[count]);
                      }
                    }
                    print('.................${list.length}');
                    myColor = (dropDownMap!['SubTitle'] == "SL")
                        ? colorsList[0]
                        : (dropDownMap!['SubTitle'] == "PU")
                            ? colorsList[1]
                            : (dropDownMap!['SubTitle'] == "SR")
                                ? colorsList[2]
                                : (dropDownMap!['SubTitle'] == "PR")
                                    ? colorsList[3]
                                    : colorsList[4];
                    return SalePur1UI(
                        viewStatus: viewStatus,
                        modifiedRecord: modifiedRecord,
                        newEntriesRecord: newEntriesRecord,
                        menuName: widget.menuName,
                        list: dropDownAccountNameMap['Title'] == ""
                            ? list
                            : filterList,
                        color: myColor,
                        dropDownMap: widget.dropDownMap);
                  } else {
                    return CircularProgressIndicator();
                  }
                })),
      ],
    );
  }

  void getSearchList(String value) async {
    originalList = await _salePurSQLDataBase.getDefaultQueryData(
        menuName: widget.menuName);
    List<Map<dynamic, dynamic>> tempList = [];
    for (Map<dynamic, dynamic> element in originalList) {
      if (element['Account Name']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['Entry ID']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['Date']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['NameOfPerson']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['BillAmount']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())) {
        print(element);
        tempList.add(element);
      }
    }
    list = tempList;
  }

  TextSpan searchMatch(String match, String searchText) {
    TextStyle style = TextStyle(color: Colors.red);
    if (searchText == "") return TextSpan(text: match, style: style);
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
          style: style,
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
      return TextSpan(text: match, style: style);
    }
    return TextSpan(
        text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
        //style: negRes,
        children: [
          searchMatch(
              match.substring(refinedMatch.indexOf(refinedSearch)), searchText)
        ],
        style: style);
  }
}
