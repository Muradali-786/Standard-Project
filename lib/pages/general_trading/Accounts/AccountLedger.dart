import 'package:com/pages/general_trading/Accounts/AccountSQL.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import '../../material/dateGrouping.dart';
import '../../material/datepickerstyle2.dart';
import 'accountLedgerWidgetUI.dart';

class AccountLedger extends StatefulWidget {
  final accountId;

  const AccountLedger({Key? key, required this.accountId}) : super(key: key);

  @override
  _AccountLedgerState createState() => _AccountLedgerState();
}

class _AccountLedgerState extends State<AccountLedger> {
  String menuName = '';
  bool hideSearch = false;
  IconData iconData = Icons.list;
  TextEditingController _searchController = TextEditingController();
  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  late Color myColor;
  List<Color> colorsList = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.grey.shade600
  ];
  AccountSQL _accountSQL = AccountSQL();

  int run = 0;
  int debitCurrent = 0;
  int creditCurrent = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List>(
          future: _accountSQL.getAccountLedgerData(widget.accountId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List list = snapshot.data!;
              int debitTotal = 0;
              int creditTotal = 0;
              for (Map<String, dynamic> element in list) {
                debitTotal += element['Debit'] as int;
                creditTotal += element['Credit'] as int;
              }

              int balance = debitTotal - creditTotal;
              if (list.length > 0 && list[0]['EntryNo'] == 0) {
                debitCurrent = debitTotal - list[0]['Debit'] as int;
                creditCurrent = creditTotal - list[0]['Credit'] as int;
              }
              return Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 10),
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.blue)),
                    child: Column(
                      children: [
                        ///   header//////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Ledger",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Icon(Icons.more_vert)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Balance:",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(
                                    "${NumberFormat("###,###", "en_US").format(balance)}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: (balance < 0)
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ///   tool bar //////////////////////////
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ///                      Date     ///
                                Padding(
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
                                            )), int.parse(date1.substring(8, 10),),),).toString()}'),
                                        Text('To     :${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(date2.substring(0, 4)), int.parse(date2.substring(
                                              5,
                                              7,
                                            )), int.parse(date2.substring(8, 10)))).toString()}'),
                                      ],
                                    ),
                                  ),
                                ),

                                ///                      search     ///

                                hideSearch
                                    ? Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
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
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 20,
                                                  style: BorderStyle.solid),
                                            ),
                                          ),
                                          controller: _searchController,
                                          onChanged: (value) {
                                            // getSearchList(searchValue: value);

                                            if (value.length == 0) {
                                              print("value is zero");
                                            }
                                            setState(() {});
                                          },
                                        ),
                                      )
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

                                ///                      filter     ///
                                IconButton(
                                  onPressed: () {
                                    showMenu<String>(
                                      context: context,
                                      position: RelativeRect.fromLTRB(
                                          40.0, 100.0, 50.0, 0.0),
                                      //position where you want to show the menu on screen
                                      items: [
                                        PopupMenuItem<String>(
                                            child: const Text(
                                                'Filter By Account Group'),
                                            value: '1'),
                                        PopupMenuItem<String>(
                                            child: const Text(
                                                'Filter By Account Type'),
                                            value: '2'),
                                        PopupMenuItem<String>(
                                            child: const Text(
                                                'Filter By User Rights'),
                                            value: '3'),
                                        PopupMenuItem<String>(
                                            child: const Text(
                                              'Clear All Filteration',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            value: '4'),
                                      ],
                                      elevation: 8.0,
                                    ).then(
                                      (value) async {
                                        if (value == null) {}
                                        if (value == '1') {
                                          // print('Filter By Account Group');
                                          // accTypeList = await _accountSQL
                                          //     .dropDownDataForAccount3Group();
                                          // //debugPrint(accTypeList.toString());
                                          // dropDownMap = await showDialog(
                                          //   context: context,
                                          //   builder: (_) => DropDownStyle1(
                                          //     acc1TypeList: accTypeList,
                                          //     dropdown_title: dropDownMap['Title'],
                                          //     map: dropDownMap,
                                          //   ),
                                          // );
                                          // setState(() {
                                          //   filterByAccountGroupName =
                                          //   dropDownMap['Title'];
                                          //   // _searchController.text = filterByAccountGroupName;
                                          //   //print(filterByAccountGroupName);
                                          // });
                                          // getSearchList(
                                          //     searchValue: filterByAccountGroupName);
                                        }
                                        if (value == '2') {
                                          // print('Filter By Account Type');
                                          // accTypeList =
                                          // await _accountSQL.dropDownData();
                                          // dropDownMap = await showDialog(
                                          //   context: context,
                                          //   builder: (_) => DropDownStyle1(
                                          //     acc1TypeList: accTypeList,
                                          //     dropdown_title: dropDownMap['Title'],
                                          //     map: dropDownMap,
                                          //   ),
                                          // );
                                          // setState(() {
                                          //   filterByAccountTypeName =
                                          //   dropDownMap['Title'];
                                          //   //_searchController.text = filterByAccountTypeName;
                                          //   //print(filterByAccountTypeName);
                                          // });
                                          // getSearchList(
                                          //     searchValue: filterByAccountTypeName);
                                        }
                                        if (value == '3') {
                                          // accTypeList = [
                                          //   {
                                          //     'ID': 1,
                                          //     'Title': 'Admin',
                                          //     'SubTitle': 'subtitle',
                                          //     'value': ''
                                          //   },
                                          //   {
                                          //     'ID': 1,
                                          //     'Title': 'Statement View Only',
                                          //     'SubTitle': 'subtitle',
                                          //     'value': ''
                                          //   },
                                          //   {
                                          //     'ID': 3,
                                          //     'Title': 'Custom Right',
                                          //     'SubTitle': 'subtitle',
                                          //     'value': ''
                                          //   }
                                          // ];
                                          // dropDownMap = await showDialog(
                                          //   context: context,
                                          //   builder: (_) => DropDownStyle1(
                                          //     acc1TypeList: accTypeList,
                                          //     dropdown_title: dropDownMap['Title'],
                                          //     map: dropDownMap,
                                          //   ),
                                          // );
                                          // setState(() {
                                          //   filterByUserCustomRight =
                                          //   dropDownMap['Title'];
                                          //   //_searchController.text = filterByAccountTypeName;
                                          //   //print(filterByAccountTypeName);
                                          // });
                                          // getSearchList(
                                          //     searchValue: filterByUserCustomRight);
                                        }
                                        if (value == '4') {
                                          // getDefaultQueryRef =
                                          //     _accountSQL.getAllAccountData();
                                        }
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.filter_alt_outlined),
                                ),

                                ///                      views to show as list , grid , tree     ///
                                IconButton(
                                  onPressed: () {
                                    showMenu<IconData>(
                                      context: context,
                                      position: RelativeRect.fromLTRB(
                                          70.0, 100.0, 40.0, 0.0),
                                      //position where you want to show the menu on screen
                                      items: [
                                        PopupMenuItem<IconData>(
                                          child: const Icon(Icons.list),
                                          value: Icons.list,
                                        ),
                                        PopupMenuItem<IconData>(
                                          child: const Icon(Icons.grid_on),
                                          value: Icons.grid_on,
                                        ),
                                        PopupMenuItem<IconData>(
                                          child: const Icon(Icons.account_tree),
                                          value: Icons.account_tree,
                                        ),
                                      ],
                                      elevation: 8.0,
                                    ).then((value) async {
                                      if (value == null) {}
                                      if (value == Icons.list) {
                                        setState(() {
                                          iconData = Icons.list;
                                        });
                                      }
                                      if (value == Icons.grid_on) {
                                        setState(() {
                                          iconData = Icons.grid_on;
                                        });
                                      }
                                      if (value == Icons.account_tree) {
                                        setState(() {
                                          iconData = Icons.account_tree;
                                        });
                                      }
                                    });
                                  },
                                  icon: Icon(iconData),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.settings,
                                      size: 20,
                                      color: Colors.grey,
                                    )),

                                ElevatedButton(onPressed: (){
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) {
                                  //     return AlertDialog(
                                  //       title: Text('Select'),
                                  //       content: Column(
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //         children: [
                                  //           InkWell(
                                  //             onTap: () async {
                                  //               // List list = [];
                                  //               // list.add(Map());
                                  //               // list.add({"action": "ADD"});
                                  //               // list.add(
                                  //               //     {"menuName": widget.menuName});
                                  //               // await showDialog(
                                  //               //     context: context,
                                  //               //     builder:
                                  //               //         (BuildContext context) {
                                  //               //       return Account3Name(list);
                                  //               //     });
                                  //               // setState(() {});
                                  //               // Navigator.pop(context);
                                  //             },
                                  //             child: Text('Add New Account'),
                                  //           ),
                                  //           SizedBox(height: 15),
                                  //           InkWell(
                                  //             onTap: () async {
                                  //               // showGeneralDialog(
                                  //               //   context: context,
                                  //               //   pageBuilder: (BuildContext
                                  //               //   context,
                                  //               //       Animation<double> animation,
                                  //               //       Animation<double>
                                  //               //       secondaryAnimation) {
                                  //               //     return AnimatedContainer(
                                  //               //       padding: EdgeInsets.only(
                                  //               //           bottom:
                                  //               //           MediaQuery.of(context)
                                  //               //               .viewInsets
                                  //               //               .bottom),
                                  //               //       duration: const Duration(
                                  //               //           milliseconds: 300),
                                  //               //       alignment: Alignment.center,
                                  //               //       child: Center(
                                  //               //           child: SizedBox(
                                  //               //               height: 300,
                                  //               //               child: Padding(
                                  //               //                   padding:
                                  //               //                   const EdgeInsets
                                  //               //                       .all(8.0),
                                  //               //                   child:
                                  //               //                   Account2GroupDesign(
                                  //               //                     action: 'Add',
                                  //               //                   )))),
                                  //               //     );
                                  //               //   },
                                  //               // );
                                  //
                                  //               // await showDialog(
                                  //               //     context: context,
                                  //               //     builder: (_) => Account2GroupDesign(
                                  //               //       action: 'Add',
                                  //               //     ));
                                  //               // setState(() {});
                                  //               // Navigator.pop(context);
                                  //             },
                                  //             child: Text('Add New Account Group'),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     );
                                  //   },
                                  // );
                                }, child: Icon(Icons.add))

                              ],
                            ),
                          ),
                        ),

                        /// particular ////////////////////////
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 5, right: 8, left: 8),
                          child: Container(
                            height: 50,
                            color: Colors.blue[500],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Particulars",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Dr/Cr",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Balance",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        iconData == Icons.list
                            ?AccountLedgerListUI(list: snapshot.data!)
                            : Container(
                                child:
                                    FutureBuilder<List>(
                                  future:
                                      _accountSQL.getAccountLedgerDataForTree(
                                          widget.accountId),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      print(
                                          '......................data   ==== ${snapshot.data!}');
                                      return DateGrouping(
                                        color: Colors.blue,
                                        childWidget: 'Ledger',
                                        list: snapshot.data!,
                                        date: 'Date',
                                        updatedDate: '00',
                                        amount: 'Balance',
                                      );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 8),
                          child: Container(
                            height: 50,
                            color: Colors.red[100],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("Total Debit: "),
                                            Text(
                                                NumberFormat("###,###", "en_US")
                                                    .format(debitTotal)
                                                    .toString()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Total Credit: "),
                                            Text(
                                                NumberFormat("###,###", "en_US")
                                                    .format(creditTotal)
                                                    .toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("Current Debit: "),
                                            Text("$debitCurrent"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Current Credit: "),
                                            Text("$creditCurrent"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
