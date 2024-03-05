import 'package:com/pages/school/refreshing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Server/mysql_provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../general_trading/SalePur/sale_pur1_SQL.dart';
import 'FeeCollectionSQL.dart';

class FeeDetailsComplete extends StatefulWidget {
  final List list;
  final String titleName;

  const FeeDetailsComplete(
      {required this.titleName, required this.list, Key? key})
      : super(key: key);

  @override
  State<FeeDetailsComplete> createState() => _FeeDetailsCompleteState();
}

class _FeeDetailsCompleteState extends State<FeeDetailsComplete> {
  double groundTotal = 0;

  String toDate =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String fromDate =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  TextEditingController _searchController = TextEditingController();
  IconData iconData = Icons.list;

  @override
  void initState() {
    super.initState();
    print('...............................${widget.list.length}');

    for (int i = 0; i < widget.list.length; i++) {
      groundTotal += widget.list[i]['RecAmount'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Fee Rec Details',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.titleName}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    groundTotal.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                  ),
                )
              ],
            ),
          ),

          ///    tool bar //////////////////////////////////////
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ///                      Date     ///

                ///                      search     ///
                Flexible(
                  flex: 8,
                  child: TextFormField(
                    //initialValue: args.dropdown_title,
                    //controller: passwordController,
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
                            style: BorderStyle.solid),
                      ),
                    ),
                    controller: _searchController,
                    onChanged: (value) {
                      //  getSearchList(searchValue: value);

                      if (value.length == 0) {
                        print("value is zero");
                      }
                      setState(() {});
                    },
                  ),
                ),

                ///                      filter     ///
                Flexible(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {
                      showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(40.0, 50.0, 50.0, 0.0),
                        //position where you want to show the menu on screen
                        items: [
                          PopupMenuItem<String>(
                              child: const Text('All Records'), value: '1'),
                          PopupMenuItem<String>(
                              child: const Text('Greater Then Zero'),
                              value: '2'),
                          PopupMenuItem<String>(
                              child: const Text('Less then Zero'), value: '3'),
                        ],
                        elevation: 8.0,
                      ).then(
                        (value) async {
                          if (value == '1') {}
                          if (value == '2') {}
                          if (value == '3') {}
                        },
                      );
                    },
                    icon: Icon(Icons.filter_alt_outlined),
                  ),
                ),
              ],
            ),
          ),

          uIListViewFeeDetails(widget.list, '', null)
        ],
      )),
    );
  }
}

Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
  return PopupMenuButton<int>(
    padding: EdgeInsets.only(left: 8, bottom: 5),
    icon: Icon(
      Icons.more_horiz,
      size: 20,
      color: Colors.grey,
    ),
    onSelected: onSelected,
    itemBuilder: (context) {
      return [
        PopupMenuItem(value: 0, child: Text('Edit Amount')),
        PopupMenuItem(value: 1, child: Text('Edit All')),
      ];
    },
  );
}

Widget uIListViewFeeDetails(List list, String menuName, var setState) {
  TextEditingController _totalAmountController = TextEditingController();
  FeeCollectionSQL _feeCollectionSql = FeeCollectionSQL();
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  SchServerRefreshing schRefreshing = SchServerRefreshing();
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: list.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        list[index]['FeeRecDate'] != null
                            ? Text(
                                '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(list[index]['FeeRecDate'].toString().substring(0, 4)), int.parse(list[index]['FeeRecDate'].toString().substring(
                                      5,
                                      7,
                                    )), int.parse(list[index]['FeeRecDate'].toString().substring(8, 10)))).toString()} ',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            : SizedBox(),
                        Text(' (${list[index]['FeeRec1ID'].toString()}) '),
                        Text('${list[index]['GRN'].toString()} ,'),
                        Text(
                          '${list[index]['FamilyGroupNo'].toString()}',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FutureBuilder(
                          future:
                              _salePurSQLDataBase.userRightsChecking(menuName),
                          builder: (context, AsyncSnapshot<List> snapshot) {
                            if (snapshot.hasData) {
                              return popUpButtonForItemEdit(
                                  onSelected: (value) async {
                                if (value == 0) {
                                  print(
                                      '${snapshot.data!}..............................');
                                  if (list[index]['FeeRec2ID'] < 0) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          _totalAmountController.clear();
                                          return Align(
                                            alignment: Alignment.center,
                                            child: Material(
                                              child: SizedBox(
                                                height: 140,
                                                width: 300,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: TextField(
                                                            controller:
                                                                _totalAmountController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              label: Text(
                                                                  'Total Amount'),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          25.0),
                                                              child: TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    print(
                                                                        '..................$list....................');
                                                                    await _feeCollectionSql.updateStudentFeeRec(
                                                                        id: list[index]
                                                                            [
                                                                            'FeeRec2ID'],
                                                                        recAmount: _totalAmountController
                                                                            .text
                                                                            .toString());

                                                                    Navigator.pop(
                                                                        context);

                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                    'ok',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  )),
                                                            ),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (
                                                                      // await userAuthentication(context) &&
                                                                      await Provider.of<MySqlProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .connectToServerDb()) {
                                                                    ///    Sch7FeeRec2   ////////
                                                                    var maxDate2 =
                                                                        await schRefreshing
                                                                            .updateSch7FeeRec2DataToServer(context);
                                                                    await schRefreshing
                                                                        .sch7FeeRec2InsertDataToServer(
                                                                            context);
                                                                    await schRefreshing.getTableDataFromServeToInSqlite(
                                                                        context,
                                                                        'Sch7FeeRec2',
                                                                        maxDate2);
                                                                  }

                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Text(
                                                                    'Cancel')),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  } else if (SharedPreferencesKeys.prefs!
                                          .getString(SharedPreferencesKeys
                                              .userRightsClient) ==
                                      'Custom Right') {
                                    // print('................${snapshot.data![0]['Inserting']
                                    //     .toString()}.........................');
                                    if (snapshot.data![0]['Inserting']
                                            .toString() ==
                                        'true') {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            _totalAmountController.clear();
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Material(
                                                child: SizedBox(
                                                  height: 140,
                                                  width: 300,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: TextField(
                                                              controller:
                                                                  _totalAmountController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                label: Text(
                                                                    'Total Amount'),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            25.0),
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          print(
                                                                              '..................$list....................');
                                                                          await _feeCollectionSql.updateStudentFeeRec(
                                                                              id: list[index]['FeeRec2ID'],
                                                                              recAmount: _totalAmountController.text.toString());

                                                                          Navigator.pop(
                                                                              context);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'ok',
                                                                          style:
                                                                              TextStyle(fontSize: 20),
                                                                        )),
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (
                                                                        // await userAuthentication(context) &&
                                                                        await Provider.of<MySqlProvider>(context,
                                                                                listen: false)
                                                                            .connectToServerDb()) {
                                                                      ///    Sch7FeeRec2   ////////
                                                                      var maxDate2 =
                                                                          await schRefreshing
                                                                              .updateSch7FeeRec2DataToServer(context);
                                                                      await schRefreshing
                                                                          .sch7FeeRec2InsertDataToServer(
                                                                              context);
                                                                      await schRefreshing.getTableDataFromServeToInSqlite(
                                                                          context,
                                                                          'Sch7FeeRec2',
                                                                          maxDate2);
                                                                    }

                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                      'Cancel')),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  } else if (SharedPreferencesKeys.prefs!
                                          .getString(SharedPreferencesKeys
                                              .userRightsClient) ==
                                      'Admin') {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          _totalAmountController.clear();
                                          return Align(
                                            alignment: Alignment.center,
                                            child: Material(
                                              child: SizedBox(
                                                height: 140,
                                                width: 300,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: TextField(
                                                            controller:
                                                                _totalAmountController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              label: Text(
                                                                  'Total Amount'),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          25.0),
                                                              child: TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    print(
                                                                        '..................$list....................');
                                                                    await _feeCollectionSql.updateStudentFeeRec(
                                                                        id: list[index]
                                                                            [
                                                                            'FeeRec2ID'],
                                                                        recAmount: _totalAmountController
                                                                            .text
                                                                            .toString());

                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                    'ok',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  )),
                                                            ),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (
                                                                      // await userAuthentication(context) &&
                                                                      await Provider.of<MySqlProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .connectToServerDb()) {
                                                                    ///    Sch7FeeRec2   ////////
                                                                    var maxDate2 =
                                                                        await schRefreshing
                                                                            .updateSch7FeeRec2DataToServer(context);
                                                                    await schRefreshing
                                                                        .sch7FeeRec2InsertDataToServer(
                                                                            context);
                                                                    await schRefreshing.getTableDataFromServeToInSqlite(
                                                                        context,
                                                                        'Sch7FeeRec2',
                                                                        maxDate2);
                                                                  }

                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Text(
                                                                    'Cancel')),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                }

                                if (value == 1) {
                                  //         print('.........................................value == 1.......................');
                                  //
                                  //         print(list);
                                  //
                                  // List lsit   =   await    _feeCollectionSql.dataForFeeRec(list[index]['FeeRec1ID'].toString());
                                  //
                                  // print(lsit);
                                }
                              });
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('${list[index]['StudentName'].toString()}  ,'),
                        Text('${list[index]['FahterName'].toString()}')
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(
                        '${list[index]['RecAmount'].toString()}',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
// ID: 4, FeeRec1ID: -1, FeeRecDate: 2022-04-19 00:00:00.000, FeeRecRemarks: fee of may,FamilyGroupNo
// ClientID: 16, ClientUserID: 1, NetCode: 0, SysCode: 0, UpdatedDate: , ID1: 4, RecAmount: 100,
// FeeDueID: -1, FeeNarration: fee of may test , SectionStudenID: -4, GRN: grn4, SectionID: -2,
// SectionName: section2, ClassID: -1, ClassName: class1, EducationalYearID: -1, EducationalYear: 2022,
// BranchID: -1, BranchName: b1, StudentName: st4, FahterName: }
