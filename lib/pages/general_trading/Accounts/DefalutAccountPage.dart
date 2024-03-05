
import 'dart:io';
import 'package:com/pages/general_trading/Accounts/AccontTreeview.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main/tab_bar_pages/home/home_page.dart';
import '../../../main/tab_bar_pages/home/themedataclass.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import '../../material/datepickerstyle2.dart';
import '../../material/drop_down_style1.dart';
import 'Account2Group.dart';
import 'Account3Name.dart';
import 'AccountListView.dart';
import 'AccountSQL.dart';

class DefaultPageAccounts extends StatefulWidget {
  final ItemSelectedCallback? onItemSelected;
  final String menuName;

  const DefaultPageAccounts({Key? key, this.onItemSelected ,required this.menuName})
      : super(key: key);

  @override
  DefaultPageAccountsState createState() => DefaultPageAccountsState();
}

class DefaultPageAccountsState extends State<DefaultPageAccounts> {
  bool isExpand = false;
  int? AcTypeID, ClientID;
  int? AcGroupID;
  int maxID = 0;
  List secondStepList = [];
  List thirdStepList = [];
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  String toDate =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String fromDate =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  List<Map> accTypeList = [];
  Map dropDownMap = {
    "ID": null,
    'Title': "Account Group",
    'SubTitle': null,
    "Value": null
  };
  List originalList = [];
  List list = [];
  Future<List>? getDefaultQueryRef;
  TextEditingController _searchController = TextEditingController();
  IconData iconData = Icons.list;
  AccountSQL _accountSQL = AccountSQL();
  String filterByAccountGroupName = '';
  String filterByAccountTypeName = '';
  String filterByUserCustomRight = '';
  int creditTotal = 0;
  int debitTotal = 0;
  int creditTotalCopy = 0;
  int debitTotalCopy = 0;
  int count = 0;
  bool isDecending = false;
  SharedPreferences? sharedPreferences;
  bool isDecendingDebit = false;
  bool isDecendingCredit = false;
  int selected = -1;
  String AcTypeIDName = '';
  bool hideSearch = false;
  List newEntriesRecord = [];
  List modifiedRecord = [];
  bool check = true;
  List wholeListOFData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, state) => Material(
          child: FutureBuilder(
            future: _accountSQL.getAllAccountData(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);

                newEntriesRecord.clear();
                modifiedRecord.clear();
                wholeListOFData.clear();

                for (int count = 0; count < snapshot.data!.length; count++) {
                  if (snapshot.data![count]['UpdatedDate'].toString().length ==
                          0 &&
                      snapshot.data![count]['AccountId'] < 0) {
                    newEntriesRecord.add(snapshot.data![count]);
                  }
                  if (snapshot.data![count]['UpdatedDate'].toString().length ==
                          0 &&
                      snapshot.data![count]['AccountId'] > 0) {
                    modifiedRecord.add(snapshot.data![count]);
                  }
                  if (snapshot.data![count]['UpdatedDate'] != '') {
                    wholeListOFData.add(snapshot.data![count]);
                  }
                }
                return Container(
                  height: MediaQuery.of(context).size.height * .8,
                  color: Provider.of<ThemeDataHomePage>(context, listen: false)
                      .backGroundColor,
                  child: ListView(
                    children: [
                      ///   search view   filter and   views///////////////////////////////////
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
                                      Text('From: ${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(fromDate.toString().substring(0, 4)), int.parse(fromDate.substring(
                                            5,
                                            7,
                                          )), int.parse(fromDate.substring(8, 10)))).toString()}'),
                                      Text('To     :${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(toDate.toString().substring(0, 4)), int.parse(toDate.toString().substring(
                                            5,
                                            7,
                                          )), int.parse(toDate.toString().substring(8, 10)))).toString()}'),
                                    ],
                                  ),
                                ),
                              ),

                              ///                      search     ///

                              hideSearch
                                  ? Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: TextFormField(
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
                                          getSearchList(searchValue: value);

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
                                        40.0, 235.0, 50.0, 0.0),
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
                                        print('Filter By Account Group');
                                        accTypeList = await _accountSQL
                                            .dropDownDataForAccount3Group();
                                        //debugPrint(accTypeList.toString());
                                        dropDownMap = await showDialog(
                                          context: context,
                                          builder: (_) => DropDownStyle1(
                                            acc1TypeList: accTypeList,
                                            dropdown_title:
                                                dropDownMap['Title'],
                                            map: dropDownMap,
                                          ),
                                        );
                                        setState(() {
                                          filterByAccountGroupName =
                                              dropDownMap['Title'];
                                          // _searchController.text = filterByAccountGroupName;
                                          //print(filterByAccountGroupName);
                                        });
                                        getSearchList(
                                            searchValue:
                                                filterByAccountGroupName);
                                      }
                                      if (value == '2') {
                                        print('Filter By Account Type');
                                        accTypeList =
                                            await _accountSQL.dropDownData();
                                        dropDownMap = await showDialog(
                                          context: context,
                                          builder: (_) => DropDownStyle1(
                                            acc1TypeList: accTypeList,
                                            dropdown_title:
                                                dropDownMap['Title'],
                                            map: dropDownMap,
                                          ),
                                        );
                                        setState(() {
                                          filterByAccountTypeName =
                                              dropDownMap['Title'];
                                          //_searchController.text = filterByAccountTypeName;
                                          //print(filterByAccountTypeName);
                                        });
                                        getSearchList(
                                            searchValue:
                                                filterByAccountTypeName);
                                      }
                                      if (value == '3') {
                                        accTypeList = [
                                          {
                                            'ID': 1,
                                            'Title': 'Admin',
                                            'SubTitle': 'subtitle',
                                            'value': ''
                                          },
                                          {
                                            'ID': 1,
                                            'Title': 'Statement View Only',
                                            'SubTitle': 'subtitle',
                                            'value': ''
                                          },
                                          {
                                            'ID': 3,
                                            'Title': 'Custom Right',
                                            'SubTitle': 'subtitle',
                                            'value': ''
                                          }
                                        ];
                                        dropDownMap = await showDialog(
                                          context: context,
                                          builder: (_) => DropDownStyle1(
                                            acc1TypeList: accTypeList,
                                            dropdown_title:
                                                dropDownMap['Title'],
                                            map: dropDownMap,
                                          ),
                                        );
                                        setState(() {
                                          filterByUserCustomRight =
                                              dropDownMap['Title'];
                                          //_searchController.text = filterByAccountTypeName;
                                          //print(filterByAccountTypeName);
                                        });
                                        getSearchList(
                                            searchValue:
                                                filterByUserCustomRight);
                                      }
                                      if (value == '4') {
                                        getDefaultQueryRef =
                                            _accountSQL.getAllAccountData();
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
                                        70.0, 235.0, 40.0, 0.0),
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

                              ElevatedButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Select'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                List list = [];
                                                list.add(Map());
                                                list.add({"action": "ADD"});
                                                list.add({
                                                  "menuName": widget.menuName
                                                });
                                                if(!Platform.isWindows){
                                                  await showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext context) {
                                                        return Account3Name(
                                                          list,
                                                          state: state,
                                                        );
                                                      });
                                                }else{
                                                  widget.onItemSelected!(Account3Name(
                                                    list,
                                                    state: state,
                                                  ));
                                                }

                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              child: Text('Add New Account'),
                                            ),
                                            SizedBox(height: 15),
                                            InkWell(
                                              onTap: () async {
                                                await showGeneralDialog(
                                                  context: context,
                                                  pageBuilder: (BuildContext
                                                          context,
                                                      Animation<double>
                                                          animation,
                                                      Animation<double>
                                                          secondaryAnimation) {
                                                    return AnimatedContainer(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Center(
                                                          child: SizedBox(
                                                              height: 300,
                                                              width: Platform
                                                                      .isWindows
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .5
                                                                  : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Account2GroupDesign(
                                                                    action:
                                                                        'Add',
                                                                  )))),
                                                    );
                                                  },
                                                );
                                                check = true;

                                                setState(() {});
                                              },
                                              child:
                                                  Text('Add New Account Group'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.add,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      newEntriesRecord.length == 0
                          ? SizedBox()
                          : ExpansionTile(
                              initiallyExpanded: true,
                              title: Text(
                                'New Entries',
                                style: TextStyle(color: Colors.green),
                              ),
                              children: [
                                  AccountListView(
                                    onItemSelected: widget.onItemSelected,
                                    menuName: widget.menuName,
                                    list: newEntriesRecord,
                                    state: state,
                                  )
                                ]),
                      modifiedRecord.length == 0
                          ? SizedBox()
                          : ExpansionTile(
                              initiallyExpanded: true,
                              title: Text('Modified Record',
                                  style: TextStyle(color: Colors.orange)),
                              children: [
                                  AccountListView(
                                    onItemSelected: widget.onItemSelected,
                                    menuName: widget.menuName,
                                    list: modifiedRecord,
                                    state: state,
                                  )
                                ]),
                      iconData == Icons.list
                          ? AccountListView(
                        onItemSelected: widget.onItemSelected,
                              list: list.length == 0 ? wholeListOFData : list,
                              menuName: widget.menuName,
                              state: state,
                            )
                          : Center(
                              child: AccountTreeView(
                                list: wholeListOFData,
                              ),
                            ),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  getSearchList({required String searchValue}) async {
    List<Map<dynamic, dynamic>> tempList = [];
    for (Map<dynamic, dynamic> element in wholeListOFData) {
      if (element['AccountType']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      } else if (element['GroupName']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      } else if (element['AccountName']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      }
    }
    list = tempList;
  }
}
