import 'dart:io';

import 'package:com/main/tab_bar_pages/home/themedataclass.dart';
import 'package:com/pages/school/SchoolSql.dart';
import 'package:com/pages/school/importexportstudentinfo.dart';
import 'package:com/pages/school/refreshing.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../../main/tab_bar_pages/home/home_page.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../general_trading/SalePur/sale_pur1_SQL.dart';
import '../login/create_account_and_login_code_provider.dart';
import '../material/countrypicker.dart';
import 'StudentLedger.dart';

class DefaultStudentPage extends StatefulWidget {
  final String menuName;
  final ItemSelectedCallback? onItemSelected;

  const DefaultStudentPage(
      {Key? key, this.onItemSelected, required this.menuName})
      : super(key: key);

  @override
  State<DefaultStudentPage> createState() => _DefaultStudentPageState();
}

class _DefaultStudentPageState extends State<DefaultStudentPage> {
  TextEditingController _grnController = TextEditingController();
  TextEditingController _studentNameController = TextEditingController();
  TextEditingController _fatherNameController = TextEditingController();
  TextEditingController _fatherNoController = TextEditingController();
  TextEditingController _fatherCNICController = TextEditingController();
  TextEditingController _matherNameController = TextEditingController();
  TextEditingController _matherNoController = TextEditingController();
  TextEditingController _matherCNICController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _addressNoController = TextEditingController();
  TextEditingController _otherDetailsController = TextEditingController();
  TextEditingController _admissionDateController = TextEditingController();
  TextEditingController _leavingDateController = TextEditingController();
  TextEditingController _admissionRemarksController = TextEditingController();
  TextEditingController _leavingRemarksController = TextEditingController();
  TextEditingController _familyGroupNoController = TextEditingController();
  TextEditingController _studentMobileNOController = TextEditingController();
  TextEditingController _studentDateOFBirthController = TextEditingController();
  TextEditingController _fatherProfessionController = TextEditingController();
  TextEditingController _motherProfessionController = TextEditingController();
  TextEditingController _guardianNameController = TextEditingController();
  TextEditingController _guardianMobileNoController = TextEditingController();
  TextEditingController _guardianNICController = TextEditingController();
  TextEditingController _guardianProfessionController = TextEditingController();
  TextEditingController _guardianRelationController = TextEditingController();
  TextEditingController newRecordSearchController = TextEditingController();
  TextEditingController presentSearchController = TextEditingController();
  TextEditingController modifySearchController = TextEditingController();
  TextEditingController closedSearchController = TextEditingController();

  String checkValueForGroupName = '.xlsx';
  String checkValueForCSV = '.csv';
  String checkValueForXLS = '.xls';
  String checkValueForXLSX = '.xlsx';

  bool checkStudent = true;
  bool checkFather = true;
  bool checkMother = true;
  bool checkG = true;

  Map dropDownMapStudent = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
    'Code2': '',
  };
  Map dropDownMapFather = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
    'Code2': '',
  };
  Map dropDownMapMother = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
    'Code2': '',
  };
  Map dropDownMapG = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
    'Code2': '',
  };

  String countryCodeStudent = '+92';
  String countryCodeFather = '+92';
  String countryCodeMother = '+92';
  String countryCodeG = '+92';

  int? countryClientId;
  double opacity = 0;
  int sliderValue = 1;
  SchoolSQL _schoolSQL = SchoolSQL();
  String showViewForTab = 'Student';
  ImportExportStudentInfo _importExportStudentInfo = ImportExportStudentInfo();
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  Color studentBTNColor = Colors.green;
  SchServerRefreshing schRefreshing = SchServerRefreshing();
  Color fatherBTNColor = Colors.blue.shade100;
  Color motherBTNColor = Colors.blue.shade100;
  Color guardianBTNColor = Colors.blue.shade100;
  Color leavingBTNColor = Colors.blue.shade100;
  Color studentBTNTextColor = Colors.white;
  Color fatherBTNTextColor = Colors.black54;
  Color motherBTNTextColor = Colors.black54;
  Color guardianBTNTextColor = Colors.black54;
  Color leavingBTNTextColor = Colors.black54;

  List wholeListOFDataForNewRecord = [];
  List filterListForNewRecord = [];
  List wholeListOFDataForModify = [];
  List filterListForModify = [];
  List wholeListOFDataForPresent = [];
  List filterListForPresent = [];
  List wholeListOFDataForClosed = [];
  List filterListForClosed = [];

  List sortedListGRNA = [];
  ExpansionTileController expansionTileController = ExpansionTileController();

  bool _isNumeric(String value) {
    if (value.isEmpty) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
        backgroundColor:
            Provider.of<ThemeDataHomePage>(mainContext, listen: false)
                .backGroundColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: popUpButtonForItemEditForExportAndImport(
                        onSelected: (value) async {
                      if (value == 0) {
                        await _importExportStudentInfo
                            .importFromExcel(mainContext);
                        setState(() {});
                      }

                      ///   export final in //////////////////////////////////////
                      if (value == 1) {
                        _importExportStudentInfo.exportINExcel(mainContext);
                      }
                    }),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: FutureBuilder(
                      future: _salePurSQLDataBase
                          .userRightsChecking(widget.menuName),
                      builder: (context, AsyncSnapshot<List> snapshot) {
                        if (snapshot.hasData) {
                          return ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                            onPressed: () {
                              checkFather = true;
                              checkStudent = true;
                              checkMother = true;
                              checkG = true;

                              if (SharedPreferencesKeys.prefs!.getString(
                                      SharedPreferencesKeys.userRightsClient) ==
                                  'Custom Right') {
                                if (snapshot.data![0]['Inserting'].toString() ==
                                    'true') {
                                  _addressController.clear();
                                  _addressNoController.clear();
                                  _grnController.clear();
                                  _admissionDateController.clear();
                                  _admissionRemarksController.clear();
                                  _familyGroupNoController.clear();
                                  _fatherNameController.clear();
                                  _fatherNoController.clear();
                                  _fatherCNICController.clear();
                                  _leavingDateController.clear();
                                  _matherNoController.clear();
                                  _leavingRemarksController.clear();
                                  _matherNameController.clear();
                                  _matherCNICController.clear();
                                  _otherDetailsController.clear();
                                  _studentNameController.clear();
                                  _studentMobileNOController.clear();
                                  _guardianRelationController.clear();
                                  _guardianNameController.clear();
                                  _guardianProfessionController.clear();
                                  _guardianNICController.clear();
                                  _guardianMobileNoController.clear();
                                  _fatherProfessionController.clear();
                                  _motherProfessionController.clear();
                                  _studentDateOFBirthController.clear();
                                  if (!Platform.isWindows) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .9,
                                              child: studentAdmissionDialog([
                                                {'action': 'SAVE'}
                                              ], mainContext));
                                        });
                                  } else {
                                    widget.onItemSelected!(
                                        studentAdmissionDialog([
                                      {'action': 'SAVE'}
                                    ], mainContext));
                                  }
                                }
                              } else if (SharedPreferencesKeys.prefs!.getString(
                                      SharedPreferencesKeys.userRightsClient) ==
                                  'Admin') {
                                _addressController.clear();
                                _addressNoController.clear();
                                _grnController.clear();
                                _admissionDateController.clear();
                                _admissionRemarksController.clear();
                                _familyGroupNoController.clear();
                                _fatherNoController.clear();
                                _fatherCNICController.clear();
                                _fatherNameController.clear();
                                _leavingDateController.clear();
                                _matherNoController.clear();
                                _leavingRemarksController.clear();
                                _matherNameController.clear();
                                _matherCNICController.clear();
                                _otherDetailsController.clear();
                                _studentNameController.clear();
                                _studentMobileNOController.clear();
                                _guardianRelationController.clear();
                                _guardianNameController.clear();
                                _guardianProfessionController.clear();
                                _guardianNICController.clear();
                                _guardianMobileNoController.clear();
                                _fatherProfessionController.clear();
                                _motherProfessionController.clear();
                                _studentDateOFBirthController.clear();
                                if (!Platform.isWindows) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .9,
                                            child: studentAdmissionDialog([
                                              {'action': 'SAVE'}
                                            ], mainContext));
                                      });
                                } else {
                                  widget
                                      .onItemSelected!(studentAdmissionDialog([
                                    {'action': 'SAVE'}
                                  ], mainContext));
                                }
                              }
                            },
                            child: Icon(Icons.add),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ),

              ///   new record //////////////////////////////////////////////////
              FutureBuilder(
                  future: _schoolSQL.dataForAllStudentForNEW(context),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        wholeListOFDataForNewRecord = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Provider.of<ThemeDataHomePage>(mainContext,
                                      listen: false)
                                  .borderTextAppBarColor,
                            )),
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'New  Record (${snapshot.data!.length})',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: Text(
                                                'Do you really want to delete all new records'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Cancel')),
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _schoolSQL
                                                          .AllStudentDeleteFromNEWRecord();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Delete'))
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: newRecordSearchController,
                                    onChanged: (value) {
                                      setState(() {
                                        getSearchListFOrNewRecord(
                                            searchValue: value);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Search by name and GRN',
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                filterListForNewRecord.length == 0 &&
                                        newRecordSearchController.text
                                            .toString()
                                            .isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('No Data Found'),
                                      )
                                    : listOfStudent(
                                        openFor: 'NewRecord',
                                        listOfStudent:
                                            filterListForNewRecord.length == 0
                                                ? snapshot.data!
                                                : filterListForNewRecord)
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),

              ///   modified record //////////////////////////////////////////////////
              FutureBuilder(
                  future: _schoolSQL.dataForAllStudentForMOD(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        wholeListOFDataForModify = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Provider.of<ThemeDataHomePage>(mainContext,
                                      listen: false)
                                  .borderTextAppBarColor,
                            )),
                            child: ExpansionTile(
                              title: Text(
                                'Modified  Record (${snapshot.data!.length})',
                                style: TextStyle(color: Colors.orange),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: modifySearchController,
                                    onChanged: (value) {
                                      setState(() {
                                        getSearchListFOrModify(
                                            searchValue: value);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Search by name and GRN',
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                filterListForModify.length == 0 &&
                                        modifySearchController.text
                                            .toString()
                                            .isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('No Data Found'),
                                      )
                                    : listOfStudent(
                                        openFor: 'ModifiedRecord',
                                        listOfStudent:
                                            filterListForModify.length == 0
                                                ? snapshot.data!
                                                : filterListForModify),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),

              ///   present student //////////////////////////////////////////////////

              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color:
                      Provider.of<ThemeDataHomePage>(mainContext, listen: false)
                          .borderTextAppBarColor,
                )),
                child: FutureBuilder(
                  future: _schoolSQL.dataForAllPresentStudent(),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      wholeListOFDataForPresent = List.from(snapshot.data!);
                      return ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Present Student (${snapshot.data!.length})',
                              style: TextStyle(color: Colors.green),
                            ),
                            popBTNSorting(onSelected: (value) {
                              sortedListGRNA.clear();

                              if (value == 0) {
                                wholeListOFDataForPresent.sort((a, b) {
                                  if (_isNumeric(a["GRN"]) &&
                                      _isNumeric(b["GRN"])) {
                                    return int.parse(a["GRN"]).compareTo(
                                        int.parse(b[
                                            "GRN"])); // Sort numbers in ascending order
                                  } else if (_isNumeric(a["GRN"])) {
                                    return -1; // Place numbers before alphabets
                                  } else if (_isNumeric(b["GRN"])) {
                                    return 1; // Place alphabets after numbers
                                  } else {
                                    if (a["GRN"].toLowerCase() ==
                                        b["GRN"].toLowerCase()) {
                                      return a["GRN"].compareTo(b[
                                          "GRN"]); // Sort alphabets in case-insensitive ascending order
                                    } else {
                                      if (a["GRN"]
                                          .toLowerCase()
                                          .contains(b["GRN"].toLowerCase())) {
                                        return -1; // Place a before b if a contains b
                                      } else if (b["GRN"]
                                          .toLowerCase()
                                          .contains(a["GRN"].toLowerCase())) {
                                        return 1; // Place b before a if b contains a
                                      } else {
                                        return a["GRN"].compareTo(b[
                                            "GRN"]); // Sort alphabets in case-insensitive ascending order
                                      }
                                    }
                                  }
                                });

                                // wholeListOFDataForPresent.sort((a, b) => int.parse(a["GRN"].toString()).compareTo((int.parse(b["GRN"])) ));

                                sortedListGRNA
                                    .addAll(wholeListOFDataForPresent);

                                setState(() {});
                              }
                              if (value == 1) {
                                wholeListOFDataForPresent.sort((a, b) {
                                  if (_isNumeric(a["GRN"]) &&
                                      _isNumeric(b["GRN"])) {
                                    return int.parse(a["GRN"]).compareTo(
                                        int.parse(b[
                                            "GRN"])); // Sort numbers in ascending order
                                  } else if (_isNumeric(a["GRN"])) {
                                    return -1; // Place numbers before alphabets
                                  } else if (_isNumeric(b["GRN"])) {
                                    return 1; // Place alphabets after numbers
                                  } else {
                                    if (a["GRN"].toLowerCase() ==
                                        b["GRN"].toLowerCase()) {
                                      return a["GRN"].compareTo(b[
                                          "GRN"]); // Sort alphabets in case-insensitive ascending order
                                    } else {
                                      if (a["GRN"]
                                          .toLowerCase()
                                          .contains(b["GRN"].toLowerCase())) {
                                        return -1; // Place a before b if a contains b
                                      } else if (b["GRN"]
                                          .toLowerCase()
                                          .contains(a["GRN"].toLowerCase())) {
                                        return 1; // Place b before a if b contains a
                                      } else {
                                        return a["GRN"].compareTo(b[
                                            "GRN"]); // Sort alphabets in case-insensitive ascending order
                                      }
                                    }
                                  }
                                });

                                //  wholeListOFDataForPresent.sort((a, b) => a["GRN"].compareTo((b["GRN"])));

                                sortedListGRNA
                                    .addAll(wholeListOFDataForPresent.reversed);

                                setState(() {});
                              }
                            })
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: presentSearchController,
                              onChanged: (value) {
                                setState(() {
                                  getSearchListFOrPresent(searchValue: value);
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Search by name and GRN',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          filterListForPresent.length == 0 &&
                                  presentSearchController.text
                                      .toString()
                                      .isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('No Data Found'),
                                )
                              : listOfStudent(
                                  openFor: 'PresentRecord',
                                  listOfStudent:
                                      filterListForPresent.length == 0
                                          ? sortedListGRNA.length == 0
                                              ? wholeListOFDataForPresent
                                              : sortedListGRNA
                                          : filterListForPresent)
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),

              ///   closed admission //////////////////////////////////////////////////
              FutureBuilder(
                future: _schoolSQL.dataForAllStudentClosedAdmission(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    wholeListOFDataForClosed = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Provider.of<ThemeDataHomePage>(mainContext,
                                    listen: false)
                                .borderTextAppBarColor,
                          ),
                        ),
                        child: ExpansionTile(
                            title: Text(
                              'Closed Admission (${snapshot.data!.length})',
                              style: TextStyle(color: Colors.orange),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: closedSearchController,
                                  onChanged: (value) {
                                    setState(() {
                                      getSearchListFOrClosed(
                                          searchValue: value);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Search by name and GRN',
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              filterListForClosed.length == 0 &&
                                      closedSearchController.text
                                          .toString()
                                          .isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('No Data Found'),
                                    )
                                  : listOfStudent(
                                      openFor: 'CLoseRecord',
                                      listOfStudent:
                                          filterListForClosed.length == 0
                                              ? snapshot.data!
                                              : filterListForClosed),
                            ]),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ));
  }

  Widget listOfStudent({required List listOfStudent, required String openFor}) {
    return ListView.builder(
      itemCount: listOfStudent.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            title: openFor != 'NewRecord'
                ? Text(
                    '   ${listOfStudent[index]['GRN']}',
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '   ${listOfStudent[index]['GRN']}',
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text(
                                    'Do you really want to delete this Student'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _schoolSQL.StudentDeleteFromNEWRecord(
                                              GRN: listOfStudent[index]['GRN']);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Delete'))
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ))
                    ],
                  ),
            subtitle: Text(
              '   ${listOfStudent[index]['StudentName']} ${listOfStudent[index]['FahterName']} ',
            ),
            children: [showDataOFStudentTableView(listOfStudent[index])]),
      ),
    );
  }

  /// table view to show student details //////////////////////////////////////////
  Widget showDataOFStudentTableView(Map mapOfData) {
    return Container(
      color: Provider.of<ThemeDataHomePage>(context, listen: false)
          .backGroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 20,
            child: Align(
              alignment: Alignment.centerRight,
              child: FutureBuilder(
                  future:
                      _salePurSQLDataBase.userRightsChecking(widget.menuName),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      return popUpButtonForItemEdit(onSelected: (value) async {
                        checkStudent = true;
                        checkFather = true;
                        checkMother = true;
                        checkG = true;

                        if (value == 0) {
                          if (SharedPreferencesKeys.prefs!.getString(
                                  SharedPreferencesKeys.userRightsClient) ==
                              'Custom Right') {
                            if (snapshot.data![0]['Editing'].toString() ==
                                'true') {
                              _addressController.text =
                                  mapOfData['Address'].toString();
                              _addressNoController.text =
                                  mapOfData['AddressPhoneNo'].toString();
                              _grnController.text = mapOfData['GRN'].toString();
                              _admissionDateController.text =
                                  mapOfData['AdmissionDate'].toString();
                              _admissionRemarksController.text =
                                  mapOfData['AdmissionRemarks'].toString();
                              _familyGroupNoController.text =
                                  mapOfData['FamilyGroupNo'].toString();
                              _fatherNoController.text =
                                  mapOfData['FatherMobileNo'].toString();
                              _fatherCNICController.text =
                                  mapOfData['FatherNIC'].toString();
                              _leavingDateController.text =
                                  mapOfData['LeavingDate'].toString();
                              _matherNoController.text =
                                  mapOfData['MotherMobileNo'].toString();
                              _leavingRemarksController.text =
                                  mapOfData['LeavingRemarks'].toString();
                              _matherNameController.text =
                                  mapOfData['MotherName'].toString();
                              _matherCNICController.text =
                                  mapOfData['MotherNIC'].toString();
                              _otherDetailsController.text =
                                  mapOfData['OtherDetail'].toString();
                              _studentNameController.text =
                                  mapOfData['StudentName'].toString();
                              _studentMobileNOController.text =
                                  mapOfData['StudentMobileNo'].toString();
                              _studentDateOFBirthController.text =
                                  mapOfData['DateOfBirth'].toString();
                              _fatherProfessionController.text =
                                  mapOfData['FatherProfession'].toString();
                              _motherProfessionController.text =
                                  mapOfData['MotherProfession'].toString();
                              _guardianNameController.text =
                                  mapOfData['GuardianName'].toString();
                              _guardianMobileNoController.text =
                                  mapOfData['GuardianMobileNo'].toString();
                              _guardianNICController.text =
                                  mapOfData['GuardianNIC'].toString();
                              _guardianProfessionController.text =
                                  mapOfData['GuardianProfession'].toString();
                              _guardianRelationController.text =
                                  mapOfData['GuardianRelatiion'].toString();

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .9,
                                        child: studentAdmissionDialog([
                                          {'action': 'Update'},
                                          mapOfData
                                        ], context));
                                  });
                            }
                          } else if (SharedPreferencesKeys.prefs!.getString(
                                  SharedPreferencesKeys.userRightsClient) ==
                              'Admin') {
                            print(
                                '....................................................');
                            _addressController.text =
                                mapOfData['Address'].toString();
                            _addressNoController.text =
                                mapOfData['AddressPhoneNo'].toString();
                            _grnController.text = mapOfData['GRN'].toString();
                            _admissionDateController.text =
                                mapOfData['AdmissionDate'].toString();
                            _admissionRemarksController.text =
                                mapOfData['AdmissionRemarks'].toString();
                            _familyGroupNoController.text =
                                mapOfData['FamilyGroupNo'].toString();
                            _fatherNoController.text =
                                mapOfData['FatherMobileNo'].toString();
                            _fatherCNICController.text =
                                mapOfData['FatherNIC'].toString();
                            _leavingDateController.text =
                                mapOfData['LeavingDate'].toString();
                            _matherNoController.text =
                                mapOfData['MotherMobileNo'].toString();
                            _leavingRemarksController.text =
                                mapOfData['LeavingRemarks'].toString();
                            _matherNameController.text =
                                mapOfData['MotherName'].toString();
                            _matherCNICController.text =
                                mapOfData['MotherNIC'].toString();
                            _otherDetailsController.text =
                                mapOfData['OtherDetail'].toString();
                            _studentNameController.text =
                                mapOfData['StudentName'].toString();
                            _studentMobileNOController.text =
                                mapOfData['StudentMobileNo'].toString();
                            _studentDateOFBirthController.text =
                                mapOfData['DateOfBirth'].toString();
                            _fatherProfessionController.text =
                                mapOfData['FatherProfession'].toString();
                            _motherProfessionController.text =
                                mapOfData['MotherProfession'].toString();
                            _guardianNameController.text =
                                mapOfData['GuardianName'].toString();
                            _guardianMobileNoController.text =
                                mapOfData['GuardianMobileNo'].toString();
                            _guardianNICController.text =
                                mapOfData['GuardianNIC'].toString();
                            _guardianProfessionController.text =
                                mapOfData['GuardianProfession'].toString();
                            _guardianRelationController.text =
                                mapOfData['GuardianRelatiion'].toString();

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .9,
                                      child: studentAdmissionDialog([
                                        {'action': 'Update'},
                                        mapOfData
                                      ], context));
                                });
                          }
                        }

                        if (value == 1) {
                          List studentLedgerList =
                              await _schoolSQL.dataForAllStudentLedgerFeeDue(
                                  mapOfData['GRN'].toString());

                          if (studentLedgerList.length > 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentLedger(
                                    list: studentLedgerList,
                                  ),
                                ));
                          }
                        }
                      });
                    } else {
                      return SizedBox();
                    }
                  }),
            ),
          ),
          Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
            },
            children: <TableRow>[
              TableRow(
                decoration: BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('GRN : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['GRN'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Family Group No : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['FamilyGroupNo'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Student Name : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['StudentName'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Date Of Birth : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['DateOfBirth'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Student Mobile No : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['StudentMobileNo'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Father Name : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['FahterName'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Father Mobile No : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['FatherMobileNo'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Father NIC : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['FatherNIC'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('FatherProfession : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['FatherProfession'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Mother Name : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['MotherName'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Mother Mobile No : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['MotherMobileNo'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Mother NIC : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['MotherNIC'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('MotherProfession : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['MotherProfession'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Guardian Name : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['GuardianName'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Guardian Mobile NO : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['GuardianMobileNo'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Guardian NIC : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['GuardianNIC'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Guardian Profession : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['GuardianProfession'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('GuardianRelatiion : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['GuardianRelatiion'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Address : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['Address'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Address PhoneNo : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['AddressPhoneNo'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Other Detail : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['OtherDetail'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Admission Date : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['AdmissionDate'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Admission Remarks : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['AdmissionRemarks'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Leaving Date : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['LeavingDate'].toString()),
                    ),
                  )
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('Leaving Remarks : '),
                  ),
                  Container(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(mapOfData['LeavingRemarks'].toString()),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///  pop button for edit student details ////////////////////////////////////
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
          PopupMenuItem(value: 0, child: Text('Edit')),
          PopupMenuItem(value: 1, child: Text('Student GL')),
        ];
      },
    );
  }

  Widget popBTNSorting({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      icon: Icon(
        Icons.more_vert,
        size: 20,
        color: Colors.grey,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('Sort By GRN A')),
          PopupMenuItem(value: 1, child: Text('Sort By GRN D')),
        ];
      },
    );
  }

  ///  Student admission Dialog ///////////////////////////////////////////////////////////

  Widget studentAdmissionDialog(List map, BuildContext mainContext) {
    return Material(
      child: StatefulBuilder(
        builder: (context, state) {
          if (map[0]['action'] != 'SAVE') {
            String phoneNumberS = _studentMobileNOController.text;
            print(
                '.......................................;;.;.;.;   ${_studentMobileNOController.text}');
            if (phoneNumberS.isEmpty) {
              countryCodeStudent = '92';
              _studentMobileNOController.text = '+92';
            } else {
              PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberS)
                  .then((value) {
                countryCodeStudent = value.dialCode.toString();
                state(() {});
              });
            }

            String phoneNumberF = _fatherNoController.text;

            if (phoneNumberF.isEmpty) {
              countryCodeFather = '92';
              _fatherNoController.text = '+92';
            } else {
              PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberF)
                  .then((value) {
                countryCodeFather = value.dialCode.toString();
                state(() {});
              });
            }

            String phoneNumberM = _matherNoController.text;
            if (phoneNumberM.isEmpty) {
              countryCodeMother = '92';
              _matherNoController.text = '+92';
            } else {
              PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberM)
                  .then((value) {
                countryCodeMother = value.dialCode.toString();
                state(() {});
              });
            }

            String phoneNumberG = _guardianMobileNoController.text;
            if (phoneNumberG.isEmpty) {
              countryCodeG = '92';
              _guardianMobileNoController.text = '+92';
            } else {
              PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberG)
                  .then((value) {
                countryCodeG = value.dialCode.toString();
                state(() {});
              });
            }
          }
          return Column(
            children: [
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () async {
                      bool check = false;
                      if (_grnController.text.isNotEmpty &&
                          _studentNameController.text.isNotEmpty) {
                        if (map[0]['action'] == 'SAVE') {
                          check = await _schoolSQL.insertSch9Admission(
                              context: mainContext,
                              Address: _addressController.text.toString(),
                              AddressPhoneNo:
                                  _addressNoController.text.toString(),
                              GRN: _grnController.text.toString(),
                              AdmissionDate:
                                  _admissionDateController.text.toString(),
                              AdmissionRemarks:
                                  _admissionRemarksController.text.toString(),
                              FahterName: _fatherNameController.text.toString(),
                              FamilyGroupNo:
                                  _familyGroupNoController.text.toString(),
                              FatherMobileNo:
                                  _fatherNoController.text.toString(),
                              FatherNIC: _fatherCNICController.text.toString(),
                              LeavingDate:
                                  _leavingDateController.text.toString(),
                              LeavingRemarks:
                                  _leavingRemarksController.text.toString(),
                              MotherMobileNo:
                                  _matherNoController.text.toString(),
                              MotherName: _matherNameController.text.toString(),
                              MotherNIC: _matherCNICController.text.toString(),
                              OtherDetail:
                                  _otherDetailsController.text.toString(),
                              StudentName:
                                  _studentNameController.text.toString(),
                              DateOfBirth:
                                  _studentDateOFBirthController.text.toString(),
                              FatherProfession:
                                  _fatherProfessionController.text.toString(),
                              GuardianMobileNo:
                                  _guardianMobileNoController.text.toString(),
                              GuardianName:
                                  _guardianNameController.text.toString(),
                              GuardianNIC:
                                  _guardianNICController.text.toString(),
                              GuardianProfession:
                                  _guardianProfessionController.text.toString(),
                              GuardianRelatiion:
                                  _guardianRelationController.text.toString(),
                              MotherProfession:
                                  _motherProfessionController.text.toString(),
                              StudentMobileNo:
                                  _studentMobileNOController.text.toString());
                        }

                        if (map[0]['action'] == 'Update') {
                          check = await _schoolSQL.updateSch9Admission(
                              id: map[1]['ID'].toString(),
                              Address: _addressController.text.toString(),
                              AddressPhoneNo:
                                  _addressNoController.text.toString(),
                              GRN: _grnController.text.toString(),
                              AdmissionDate:
                                  _admissionDateController.text.toString(),
                              AdmissionRemarks:
                                  _admissionRemarksController.text.toString(),
                              FahterName: _fatherNameController.text.toString(),
                              FamilyGroupNo:
                                  _familyGroupNoController.text.toString(),
                              FatherMobileNo:
                                  _fatherNoController.text.toString(),
                              FatherNIC: _fatherCNICController.text.toString(),
                              LeavingDate:
                                  _leavingDateController.text.toString(),
                              LeavingRemarks:
                                  _leavingRemarksController.text.toString(),
                              MotherMobileNo:
                                  _matherNoController.text.toString(),
                              MotherName: _matherNameController.text.toString(),
                              MotherNIC: _matherCNICController.text.toString(),
                              OtherDetail:
                                  _otherDetailsController.text.toString(),
                              StudentName:
                                  _studentNameController.text.toString(),
                              DateOfBirth:
                                  _studentDateOFBirthController.text.toString(),
                              FatherProfession:
                                  _fatherProfessionController.text.toString(),
                              GuardianMobileNo:
                                  _guardianMobileNoController.text.toString(),
                              GuardianName:
                                  _guardianNameController.text.toString(),
                              GuardianNIC:
                                  _guardianNICController.text.toString(),
                              GuardianProfession:
                                  _guardianProfessionController.text.toString(),
                              GuardianRelatiion:
                                  _guardianRelationController.text.toString(),
                              MotherProfession:
                                  _motherProfessionController.text.toString(),
                              StudentMobileNo:
                                  _studentMobileNOController.text.toString());
                        }

                        if (check) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                      'The operation was successfully completed'),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(mainContext);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Go Back')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Add new Student')),
                                  ],
                                );
                              });

                          _addressController.clear();
                          _addressNoController.clear();
                          _grnController.clear();
                          _admissionDateController.clear();
                          _admissionRemarksController.clear();
                          _familyGroupNoController.clear();
                          _fatherNoController.clear();
                          _fatherCNICController.clear();
                          _leavingDateController.clear();
                          _matherNoController.clear();
                          _leavingRemarksController.clear();
                          _matherNameController.clear();
                          _matherCNICController.clear();
                          _fatherNameController.clear();
                          _otherDetailsController.clear();
                          _studentNameController.clear();
                          _studentMobileNOController.clear();
                          _guardianRelationController.clear();
                          _guardianNameController.clear();
                          _guardianProfessionController.clear();
                          _guardianNICController.clear();
                          _guardianMobileNoController.clear();
                          _fatherProfessionController.clear();
                          _motherProfessionController.clear();
                          _studentDateOFBirthController.clear();
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text('Please Fill GRN And Student Name'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'))
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(map[0]['action'].toString()),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0, right: 3),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(studentBTNColor),
                        ),
                        onPressed: () {
                          state(() {
                            showViewForTab = 'Student';
                            studentBTNColor = Colors.green;
                            fatherBTNColor = Colors.blue.shade100;
                            motherBTNColor = Colors.blue.shade100;
                            guardianBTNColor = Colors.blue.shade100;
                            leavingBTNColor = Colors.blue.shade100;

                            studentBTNTextColor = Colors.white;
                            fatherBTNTextColor = Colors.black54;
                            motherBTNTextColor = Colors.black54;
                            guardianBTNTextColor = Colors.black54;
                            leavingBTNTextColor = Colors.black54;
                          });
                        },
                        child: FittedBox(
                          child: Text(
                            'Student',
                            style: TextStyle(color: studentBTNTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(fatherBTNColor),
                        ),
                        onPressed: () {
                          state(() {
                            showViewForTab = 'Father';

                            studentBTNColor = Colors.blue.shade100;
                            fatherBTNColor = Colors.green;
                            motherBTNColor = Colors.blue.shade100;
                            guardianBTNColor = Colors.blue.shade100;
                            leavingBTNColor = Colors.blue.shade100;

                            studentBTNTextColor = Colors.black54;
                            fatherBTNTextColor = Colors.white;
                            motherBTNTextColor = Colors.black54;
                            guardianBTNTextColor = Colors.black54;
                            leavingBTNTextColor = Colors.black54;
                          });
                        },
                        child: FittedBox(
                          child: Text(
                            'Father',
                            style: TextStyle(color: fatherBTNTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(motherBTNColor),
                        ),
                        onPressed: () {
                          state(() {
                            showViewForTab = 'Mother';
                            studentBTNColor = Colors.blue.shade100;
                            fatherBTNColor = Colors.blue.shade100;
                            motherBTNColor = Colors.green;
                            guardianBTNColor = Colors.blue.shade100;
                            leavingBTNColor = Colors.blue.shade100;

                            studentBTNTextColor = Colors.black54;
                            fatherBTNTextColor = Colors.black54;
                            motherBTNTextColor = Colors.white;
                            guardianBTNTextColor = Colors.black54;
                            leavingBTNTextColor = Colors.black54;
                          });
                        },
                        child: FittedBox(
                          child: Text(
                            'Mother',
                            style: TextStyle(color: motherBTNTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(guardianBTNColor),
                        ),
                        onPressed: () {
                          state(() {
                            showViewForTab = 'Guardian';
                            studentBTNColor = Colors.blue.shade100;
                            fatherBTNColor = Colors.blue.shade100;
                            motherBTNColor = Colors.blue.shade100;
                            guardianBTNColor = Colors.green;
                            leavingBTNColor = Colors.blue.shade100;

                            studentBTNTextColor = Colors.black54;
                            fatherBTNTextColor = Colors.black54;
                            motherBTNTextColor = Colors.black54;
                            guardianBTNTextColor = Colors.white;
                            leavingBTNTextColor = Colors.black54;
                          });
                        },
                        child: FittedBox(
                          child: Text(
                            'Guardian',
                            style: TextStyle(color: guardianBTNTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(leavingBTNColor),
                        ),
                        onPressed: () {
                          state(() {
                            showViewForTab = 'Leaving';

                            studentBTNColor = Colors.blue.shade100;
                            fatherBTNColor = Colors.blue.shade100;
                            motherBTNColor = Colors.blue.shade100;
                            guardianBTNColor = Colors.blue.shade100;
                            leavingBTNColor = Colors.green;

                            studentBTNTextColor = Colors.black54;
                            fatherBTNTextColor = Colors.black54;
                            motherBTNTextColor = Colors.black54;
                            guardianBTNTextColor = Colors.black54;
                            leavingBTNTextColor = Colors.white;
                          });
                        },
                        child: FittedBox(
                            child: Text(
                          'Leaving',
                          style: TextStyle(color: leavingBTNTextColor),
                        )),
                      ),
                    ),
                  ),
                ],
              ),

              showViewForTab == 'Student'
                  ? Flexible(
                      flex: 8,
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: sliderValue, mainAxisExtent: 60),
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, right: 3),
                                  child: TextFormField(
                                    controller: _grnController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text('GRN'),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: TextFormField(
                                    controller: _familyGroupNoController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label:
                                          FittedBox(child: Text('FamilyCode')),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: TextFormField(
                                    controller: _admissionDateController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: FittedBox(
                                          child: Text('AdmissionDate')),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                            ),
                            child: TextFormField(
                              controller: _studentNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Student Name'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              controller: _studentDateOFBirthController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Date OF Birth'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: FutureBuilder(
                              future: Provider.of<AuthenticationProvider>(
                                      context,
                                      listen: false)
                                  .getAllDataFromCountryCodeTable(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  if (map[0]['action'] == 'SAVE') {
                                    Future.delayed(
                                      Duration.zero,
                                      () {
                                        if (checkStudent) {
                                          print(
                                              '..................................................feefe...............................................');
                                          for (int i = 0;
                                              i < snapshot.data!.length;
                                              i++) {
                                            if (DateTime.now().timeZoneName ==
                                                snapshot.data![i]['SName']) {
                                              dropDownMapStudent['ID'] =
                                                  snapshot.data[i]['ID']
                                                      .toString();
                                              dropDownMapStudent[
                                                      'CountryName'] =
                                                  snapshot.data[i]
                                                          ['CountryName']
                                                      .toString();
                                              dropDownMapStudent['Image'] =
                                                  'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                              dropDownMapStudent[
                                                      'CountryCode'] =
                                                  snapshot.data[i]
                                                          ['CountryCode']
                                                      .toString();
                                              dropDownMapStudent['DateFormat'] =
                                                  snapshot.data[i]['DateFormat']
                                                      .toString();
                                              dropDownMapStudent[
                                                      'CurrencySign'] =
                                                  snapshot.data[i]
                                                          ['CurrencySigne']
                                                      .toString();
                                              dropDownMapStudent['Code2'] =
                                                  snapshot.data[i]['Code2']
                                                      .toString();
                                              countryClientId = int.parse(
                                                  snapshot.data[i]['ClientID']
                                                      .toString());
                                              _studentMobileNOController.text =
                                                  snapshot.data[i]
                                                          ['CountryCode']
                                                      .toString();
                                              state(() {});
                                            }
                                          }
                                          checkStudent = false;
                                        }
                                      },
                                    );
                                  } else {
                                    Future.delayed(
                                      Duration.zero,
                                      () {
                                        if (checkStudent) {
                                          for (int i = 0;
                                              i < snapshot.data!.length;
                                              i++) {
                                            if (snapshot.data![i]['CountryCode']
                                                    .toString() ==
                                                '+$countryCodeStudent') {
                                              dropDownMapStudent['Image'] =
                                                  'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';

                                              state(() {});
                                            }
                                          }
                                          checkStudent = false;
                                        }
                                      },
                                    );
                                  }
                                  return SizedBox(
                                    height: 60,
                                    child: TextField(
                                      controller: _studentMobileNOController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  Map data = await showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            DropDownStyle1Image(
                                                          acc1TypeList:
                                                              snapshot.data,
                                                          map:
                                                              dropDownMapStudent,
                                                        ),
                                                      ) ??
                                                      {};

                                                  print(data);

                                                  if (data.isNotEmpty) {
                                                    state(
                                                      () {
                                                        dropDownMapStudent =
                                                            data;
                                                        countryCodeStudent =
                                                            dropDownMapStudent[
                                                                    'CountryCode']
                                                                .toString();
                                                        String obj =
                                                            dropDownMapStudent[
                                                                    'ClientID']
                                                                .toString();
                                                        // ignore: unnecessary_null_comparison
                                                        if (obj != null) {
                                                          countryClientId =
                                                              int.parse(obj
                                                                  .toString());
                                                        }
                                                        print(
                                                            countryCodeStudent);
                                                        print(countryClientId);
                                                        _studentMobileNOController
                                                                .text =
                                                            countryCodeStudent
                                                                .toString();
                                                      },
                                                    );
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.arrow_downward,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                                child: Image.asset(
                                                  dropDownMapStudent['Image']
                                                      .toString(),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(),
                                        label: Text(
                                          'Mobile No',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Address'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              controller: _addressNoController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('AddressPhoneNo'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              controller: _admissionRemarksController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('AdmissionRemarks'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : showViewForTab == 'Father'
                      ? Flexible(
                          flex: 8,
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: sliderValue,
                                    mainAxisExtent: 60),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextFormField(
                                  controller: _fatherNameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Father Name'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: FutureBuilder(
                                  future: Provider.of<AuthenticationProvider>(
                                          context,
                                          listen: false)
                                      .getAllDataFromCountryCodeTable(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasData) {
                                      if (map[0]['action'] == 'SAVE') {
                                        Future.delayed(
                                          Duration.zero,
                                          () {
                                            if (checkFather) {
                                              print(
                                                  '..................................................feefe...............................................');
                                              for (int i = 0;
                                                  i < snapshot.data!.length;
                                                  i++) {
                                                if (DateTime.now()
                                                        .timeZoneName ==
                                                    snapshot.data![i]
                                                        ['SName']) {
                                                  dropDownMapFather['ID'] =
                                                      snapshot.data[i]['ID']
                                                          .toString();
                                                  dropDownMapFather[
                                                          'CountryName'] =
                                                      snapshot.data[i]
                                                              ['CountryName']
                                                          .toString();
                                                  dropDownMapFather['Image'] =
                                                      'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                                  dropDownMapFather[
                                                          'CountryCode'] =
                                                      snapshot.data[i]
                                                              ['CountryCode']
                                                          .toString();
                                                  dropDownMapFather[
                                                          'DateFormat'] =
                                                      snapshot.data[i]
                                                              ['DateFormat']
                                                          .toString();
                                                  dropDownMapFather[
                                                          'CurrencySign'] =
                                                      snapshot.data[i]
                                                              ['CurrencySigne']
                                                          .toString();
                                                  dropDownMapFather['Code2'] =
                                                      snapshot.data[i]['Code2']
                                                          .toString();
                                                  countryClientId = int.parse(
                                                      snapshot.data[i]
                                                              ['ClientID']
                                                          .toString());
                                                  _fatherNoController.text =
                                                      snapshot.data[i]
                                                              ['CountryCode']
                                                          .toString();
                                                  state(() {});
                                                }
                                              }
                                              checkFather = false;
                                            }
                                          },
                                        );
                                      } else {
                                        Future.delayed(
                                          Duration.zero,
                                          () {
                                            if (checkFather) {
                                              for (int i = 0;
                                                  i < snapshot.data!.length;
                                                  i++) {
                                                if (snapshot.data![i]
                                                            ['CountryCode']
                                                        .toString() ==
                                                    '+$countryCodeFather') {
                                                  dropDownMapFather['Image'] =
                                                      'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';

                                                  state(() {});
                                                }
                                              }
                                              checkFather = false;
                                            }
                                          },
                                        );
                                      }
                                      return SizedBox(
                                        height: 60,
                                        child: TextField(
                                          controller: _fatherNoController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      Map data =
                                                          await showDialog(
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    DropDownStyle1Image(
                                                                  acc1TypeList:
                                                                      snapshot
                                                                          .data,
                                                                  map:
                                                                      dropDownMapFather,
                                                                ),
                                                              ) ??
                                                              {};

                                                      print(data);

                                                      if (data.isNotEmpty) {
                                                        state(
                                                          () {
                                                            dropDownMapFather =
                                                                data;
                                                            countryCodeFather =
                                                                dropDownMapFather[
                                                                        'CountryCode']
                                                                    .toString();
                                                            String obj =
                                                                dropDownMapFather[
                                                                        'ClientID']
                                                                    .toString();
                                                            // ignore: unnecessary_null_comparison
                                                            if (obj != null) {
                                                              countryClientId =
                                                                  int.parse(obj
                                                                      .toString());
                                                            }
                                                            print(
                                                                countryCodeFather);
                                                            print(
                                                                countryClientId);
                                                            _fatherNoController
                                                                    .text =
                                                                countryCodeFather
                                                                    .toString();
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.arrow_downward,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    child: Image.asset(
                                                      dropDownMapFather['Image']
                                                          .toString(),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(),
                                            label: Text(
                                              'Mobile No',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextFormField(
                                  controller: _fatherCNICController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Father NIC'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextFormField(
                                  controller: _fatherProfessionController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Father Profession'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : showViewForTab == 'Mother'
                          ? Flexible(
                              flex: 8,
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: sliderValue,
                                        mainAxisExtent: 60),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextFormField(
                                      controller: _matherNameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text('Mother Name'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: FutureBuilder(
                                      future:
                                          Provider.of<AuthenticationProvider>(
                                                  context,
                                                  listen: false)
                                              .getAllDataFromCountryCodeTable(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          if (map[0]['action'] == 'SAVE') {
                                            Future.delayed(
                                              Duration.zero,
                                              () {
                                                if (checkMother) {
                                                  print(
                                                      '..................................................feefe...............................................');
                                                  for (int i = 0;
                                                      i < snapshot.data!.length;
                                                      i++) {
                                                    if (DateTime.now()
                                                            .timeZoneName ==
                                                        snapshot.data![i]
                                                            ['SName']) {
                                                      dropDownMapMother['ID'] =
                                                          snapshot.data[i]['ID']
                                                              .toString();
                                                      dropDownMapMother[
                                                              'CountryName'] =
                                                          snapshot.data[i][
                                                                  'CountryName']
                                                              .toString();
                                                      dropDownMapMother[
                                                              'Image'] =
                                                          'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                                      dropDownMapMother[
                                                              'CountryCode'] =
                                                          snapshot.data[i][
                                                                  'CountryCode']
                                                              .toString();
                                                      dropDownMapMother[
                                                              'DateFormat'] =
                                                          snapshot.data[i]
                                                                  ['DateFormat']
                                                              .toString();
                                                      dropDownMapMother[
                                                              'CurrencySign'] =
                                                          snapshot.data[i][
                                                                  'CurrencySigne']
                                                              .toString();
                                                      dropDownMapMother[
                                                              'Code2'] =
                                                          snapshot.data[i]
                                                                  ['Code2']
                                                              .toString();
                                                      countryClientId =
                                                          int.parse(snapshot
                                                              .data[i]
                                                                  ['ClientID']
                                                              .toString());
                                                      _matherNoController.text =
                                                          snapshot.data[i][
                                                                  'CountryCode']
                                                              .toString();
                                                      state(() {});
                                                    }
                                                  }
                                                  checkMother = false;
                                                }
                                              },
                                            );
                                          } else {
                                            Future.delayed(
                                              Duration.zero,
                                              () {
                                                if (checkMother) {
                                                  for (int i = 0;
                                                      i < snapshot.data!.length;
                                                      i++) {
                                                    if (snapshot.data![i]
                                                                ['CountryCode']
                                                            .toString() ==
                                                        '+$countryCodeMother') {
                                                      dropDownMapMother[
                                                              'Image'] =
                                                          'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';

                                                      state(() {});
                                                    }
                                                  }
                                                  checkMother = false;
                                                }
                                              },
                                            );
                                          }
                                          return SizedBox(
                                            height: 60,
                                            child: TextField(
                                              controller: _matherNoController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          Map data =
                                                              await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (_) =>
                                                                        DropDownStyle1Image(
                                                                      acc1TypeList:
                                                                          snapshot
                                                                              .data,
                                                                      map:
                                                                          dropDownMapMother,
                                                                    ),
                                                                  ) ??
                                                                  {};

                                                          print(data);

                                                          if (data.isNotEmpty) {
                                                            state(
                                                              () {
                                                                dropDownMapMother =
                                                                    data;
                                                                countryCodeMother =
                                                                    dropDownMapMother[
                                                                            'CountryCode']
                                                                        .toString();
                                                                String obj =
                                                                    dropDownMapMother[
                                                                            'ClientID']
                                                                        .toString();
                                                                // ignore: unnecessary_null_comparison
                                                                if (obj !=
                                                                    null) {
                                                                  countryClientId =
                                                                      int.parse(
                                                                          obj.toString());
                                                                }

                                                                _matherNoController
                                                                        .text =
                                                                    countryCodeMother
                                                                        .toString();
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.arrow_downward,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        child: Image.asset(
                                                          dropDownMapMother[
                                                                  'Image']
                                                              .toString(),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(),
                                                label: Text(
                                                  'Mobile No',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return SizedBox();
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextFormField(
                                      controller: _matherCNICController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text('Mother NIC'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextFormField(
                                      controller: _motherProfessionController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text('Mother Profession'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : showViewForTab == 'Guardian'
                              ? Flexible(
                                  flex: 8,
                                  child: GridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: sliderValue,
                                            mainAxisExtent: 60),
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: TextFormField(
                                          controller: _guardianNameController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text('Guardian Name'),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: FutureBuilder(
                                          future: Provider.of<
                                                      AuthenticationProvider>(
                                                  context,
                                                  listen: false)
                                              .getAllDataFromCountryCodeTable(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            if (snapshot.hasData) {
                                              if (map[0]['action'] == 'SAVE') {
                                                Future.delayed(
                                                  Duration.zero,
                                                  () {
                                                    if (checkG) {
                                                      print(
                                                          '..................................................feefe...............................................');
                                                      for (int i = 0;
                                                          i <
                                                              snapshot
                                                                  .data!.length;
                                                          i++) {
                                                        if (DateTime.now()
                                                                .timeZoneName ==
                                                            snapshot.data![i]
                                                                ['SName']) {
                                                          dropDownMapG['ID'] =
                                                              snapshot.data[i]
                                                                      ['ID']
                                                                  .toString();
                                                          dropDownMapG[
                                                                  'CountryName'] =
                                                              snapshot.data[i][
                                                                      'CountryName']
                                                                  .toString();
                                                          dropDownMapG[
                                                                  'Image'] =
                                                              'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                                          dropDownMapG[
                                                                  'CountryCode'] =
                                                              snapshot.data[i][
                                                                      'CountryCode']
                                                                  .toString();
                                                          dropDownMapG[
                                                                  'DateFormat'] =
                                                              snapshot.data[i][
                                                                      'DateFormat']
                                                                  .toString();
                                                          dropDownMapG[
                                                                  'CurrencySign'] =
                                                              snapshot.data[i][
                                                                      'CurrencySigne']
                                                                  .toString();
                                                          dropDownMapG[
                                                                  'Code2'] =
                                                              snapshot.data[i]
                                                                      ['Code2']
                                                                  .toString();
                                                          countryClientId =
                                                              int.parse(snapshot
                                                                  .data[i][
                                                                      'ClientID']
                                                                  .toString());
                                                          _guardianMobileNoController
                                                                  .text =
                                                              snapshot.data[i][
                                                                      'CountryCode']
                                                                  .toString();
                                                          state(() {});
                                                        }
                                                      }
                                                      checkG = false;
                                                    }
                                                  },
                                                );
                                              } else {
                                                Future.delayed(
                                                  Duration.zero,
                                                  () {
                                                    if (checkG) {
                                                      for (int i = 0;
                                                          i <
                                                              snapshot
                                                                  .data!.length;
                                                          i++) {
                                                        if (snapshot.data![i][
                                                                    'CountryCode']
                                                                .toString() ==
                                                            '+$countryCodeG') {
                                                          dropDownMapG[
                                                                  'Image'] =
                                                              'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';

                                                          state(() {});
                                                        }
                                                      }
                                                      checkG = false;
                                                    }
                                                  },
                                                );
                                              }
                                              return SizedBox(
                                                height: 60,
                                                child: TextField(
                                                  controller:
                                                      _guardianMobileNoController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    prefixIcon: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              Map data =
                                                                  await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (_) =>
                                                                                DropDownStyle1Image(
                                                                          acc1TypeList:
                                                                              snapshot.data,
                                                                          map:
                                                                              dropDownMapG,
                                                                        ),
                                                                      ) ??
                                                                      {};

                                                              print(data);

                                                              if (data
                                                                  .isNotEmpty) {
                                                                state(
                                                                  () {
                                                                    dropDownMapG =
                                                                        data;
                                                                    countryCodeG =
                                                                        dropDownMapG['CountryCode']
                                                                            .toString();
                                                                    String obj =
                                                                        dropDownMapG['ClientID']
                                                                            .toString();
                                                                    // ignore: unnecessary_null_comparison
                                                                    if (obj !=
                                                                        null) {
                                                                      countryClientId =
                                                                          int.parse(
                                                                              obj.toString());
                                                                    }

                                                                    _guardianMobileNoController
                                                                            .text =
                                                                        countryCodeG
                                                                            .toString();
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 30,
                                                            child: Image.asset(
                                                              dropDownMapG[
                                                                      'Image']
                                                                  .toString(),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(),
                                                    label: Text(
                                                      'Mobile No',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return SizedBox();
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: TextFormField(
                                          controller: _guardianNICController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text('Guardian NIC'),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: TextFormField(
                                          controller:
                                              _guardianProfessionController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text('Guardian Profession'),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: TextFormField(
                                          controller:
                                              _guardianRelationController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text('Guardian Relation'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Flexible(
                                  flex: 8,
                                  child: GridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: sliderValue,
                                            mainAxisExtent: 60),
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: TextFormField(
                                          controller: _leavingDateController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text('LeavingDate'),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: TextFormField(
                                          controller: _leavingRemarksController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text('LeavingRemarks'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

              ///    setting gor change grid view ///////////////////////////////////
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          state(() {
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
                            state(() {
                              sliderValue = value.toInt();
                            });
                          }),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget popUpButtonForItemEditForExportAndImport({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      icon: Icon(
        Icons.more_vert_rounded,
        size: 25,
        color: Colors.black,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('Import')),
          PopupMenuItem(value: 1, child: Text('Export')),
          // PopupMenuItem(value: 1, child: Text('Delete')),
        ];
      },
    );
  }

  getSearchListFOrNewRecord({required String searchValue}) {
    List<Map<dynamic, dynamic>> tempList = [];
    for (Map<dynamic, dynamic> element in wholeListOFDataForNewRecord) {
      if (element['GRN']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      } else if (element['StudentName']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      }
    }
    filterListForNewRecord = tempList;
  }

  getSearchListFOrModify({required String searchValue}) {
    List<Map<dynamic, dynamic>> tempList = [];
    for (Map<dynamic, dynamic> element in wholeListOFDataForModify) {
      if (element['GRN']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      } else if (element['StudentName']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      }
    }
    filterListForModify = tempList;
  }

  getSearchListFOrPresent({required String searchValue}) {
    List<Map<dynamic, dynamic>> tempList = [];
    for (Map<dynamic, dynamic> element in wholeListOFDataForPresent) {
      if (element['GRN']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      } else if (element['StudentName']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      }
    }
    filterListForPresent = tempList;
  }

  getSearchListFOrClosed({required String searchValue}) {
    List<Map<dynamic, dynamic>> tempList = [];
    for (Map<dynamic, dynamic> element in wholeListOFDataForClosed) {
      if (element['GRN']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      } else if (element['StudentName']
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      }
    }
    filterListForClosed = tempList;
  }
}
