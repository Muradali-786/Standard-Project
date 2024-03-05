import 'dart:convert';
import 'dart:io';
import 'package:com/pages/school/refreshing.dart';
import 'package:com/pages/school/send_whatapp_student.dart';
import 'package:flutter/material.dart';
import 'package:com/pages/school/DueFeeDetails.dart';
import 'package:com/pages/school/FeeCollection.dart';
import 'package:com/pages/school/FeeCollectionSQL.dart';
import 'package:com/pages/school/FeeDetailsComplete.dart';
import 'package:com/pages/school/Sch1Branch.dart';
import 'package:com/pages/school/Sch3Classes.dart';
import 'package:com/pages/school/SchoolSql.dart';
import 'package:com/pages/school/StudentLedger.dart';
import 'package:com/pages/school/modelschoolbranch.dart';
import 'package:com/pages/school/modelshowyearlistview.dart';
import 'package:com/pages/school/modelyeareducation.dart';
import 'package:com/pages/school/studentTotalBalance.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../../widgets/constants.dart';
import '../general_trading/SalePur/sale_pur1_SQL.dart';
import '../material/datepickerstyle1.dart';
import '../material/image_uploading.dart';
import 'Sch2Year.dart';
import 'Sch3ClassSection.dart';
import 'Sch5SectionStudrent.dart';
import 'Sch6StudentFeeDue.dart';
import 'Sch7FeeRec2.dart';
import 'feerecslip.dart';
import 'modelFeeDue.dart';
import 'modelclasseducation.dart';
import 'modelsection.dart';
import 'modelsectionstudent.dart';


class SchListView extends StatefulWidget {
  final List listSchSection;
  final List listSchBranches;
  final List listSchYear;
  final List listSchClasses;
  final String showStatusView;
  final bool isDecending;
  final bool isDecendingCredit;
  final bool isDecendingDebit;
  final String menuName;
  final String searchController;

  const SchListView({
    Key? key,
    required this.showStatusView,
    required this.listSchBranches,
    required this.listSchYear,
    required this.listSchClasses,
    required this.isDecending,
    required this.isDecendingCredit,
    required this.isDecendingDebit,
    required this.menuName,
    required this.searchController,
    required this.listSchSection,
  }) : super(key: key);

  @override
  State<SchListView> createState() => _SchListViewState();
}

class _SchListViewState extends State<SchListView> {
  TextEditingController yearEducationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController longLatController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController classSectionController = TextEditingController();
  TextEditingController sectionStudentController = TextEditingController();
  TextEditingController sectionMonthlyFeeController = TextEditingController();
  TextEditingController feeRecAmountController = TextEditingController();
  TextEditingController dueOnDateController = TextEditingController();
  TextEditingController feeNarrationController = TextEditingController();
  TextEditingController feeAmountController = TextEditingController();
  TextEditingController studentHeight = TextEditingController();
  TextEditingController studentWeight = TextEditingController();

  TextEditingController studentSearch = TextEditingController();


  bool checkValue = false;
  String checkValueTitle = 'Monthly Fee';
  ClassSection classSection = ClassSection();
  SchServerRefreshing schRefreshing = SchServerRefreshing();
  SectionStudent sectionStudent = SectionStudent();
  StudentFeeDue studentFeeDue = StudentFeeDue();
  StudentFeeRec studentFeeRec = StudentFeeRec();
  YearClasses yearClasses = YearClasses();
  SchoolYear schoolYear = SchoolYear();
  SchoolBranches schoolBranches = SchoolBranches();
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  SchoolSQL _schoolSQL = SchoolSQL();
  double fontSize = 40;
  FeeCollectionSQL _feeCollectionSQL = FeeCollectionSQL();
  var currentDate = DateTime.now();
  String grnOfStudent = '';


  List wholeListOFStudent = [];
  List filterListStudent = [];


  File? image;
  String? imageBase64 = '';
  String? imageURL = '';

  bool _isNumeric(String value) {
    if (value.isEmpty) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext mainBuildContext) {
    var modelSchoolBranchSystem =
    Provider.of<ModelSchoolBranchSystem>(mainBuildContext, listen: false);
    var modelYearEducation =
    Provider.of<ModelYearEducation>(mainBuildContext, listen: false);
    var modelClassEducation =
    Provider.of<ModelClassEducation>(mainBuildContext, listen: false);
    var modelShowYearListView =
    Provider.of<ModelShowYearListView>(mainBuildContext, listen: false);
    var modelShowSectionListView =
    Provider.of<ModelShowSectionListView>(mainBuildContext, listen: false);
    var modelsectionStudent =
    Provider.of<ModelSectionStudentList>(mainBuildContext, listen: false);
    var modelFeeDueList = Provider.of<ModelFeeDueList>(
        mainBuildContext, listen: false);

    return modelShowYearListView.status == 'Branch'
        ? ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        InkWell(
          onTap: () {
            _schoolSQL.dataForSch1Branch();
          },
          child: Align(alignment: Alignment.centerLeft, child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Campus PagePage',
              style: TextStyle(fontSize: 20, color: Colors.brown),),
          )),
        ),
        FutureBuilder(
          future: _schoolSQL.dataForSch1Branch(),
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List sortedList = [];
                    if (widget.isDecending == true) {
                      sortedList = snapshot.data!.reversed.toList();
                    } else if (widget.isDecendingCredit == true) {
                      sortedList = snapshot.data!.reversed.toList();
                    } else if (widget.isDecendingDebit == true) {
                      sortedList = snapshot.data!.reversed.toList();
                    } else {
                      sortedList = snapshot.data!;
                    }
                    Map map = {};
                    if (index < snapshot.data!.length) {
                      map = sortedList[index];
                    }

                    //.........................................................................
                    //// LIstTile ..........   And Edit Button here.......................................
                    /////////////////////////////////////////////////////////////////////////////////
                    return GestureDetector(
                        onTap: () async {
                          modelSchoolBranchSystem.setName(
                            map['BranchName'].toString(),
                          );
                          modelSchoolBranchSystem
                              .setID(map['BranchID']);
                          modelSchoolBranchSystem.opacity = 1.0;
                          modelShowYearListView.setStatus('Year');
                          setState(() {});
                        },
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: customListView(
                            studentQuantity: map['StudentQty'] == null
                                ? '0'
                                : map['StudentQty'].toString(),
                            statusRecord: map['BranchID'] == null
                                ? Text('')
                                : map['BranchID'] < 0 &&
                                map['UpdatedDate']
                                    .toString()
                                    .length == 0 ? Container(
                              width: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,

                                borderRadius: BorderRadius.circular(10),

                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'New',
                                  style: TextStyle(color: Colors.white),),
                              ),
                            ) : map['BranchID'] > 0 &&
                                map['UpdatedDate']
                                    .toString()
                                    .length == 0 ? Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Modified',
                                  style: TextStyle(color: Colors.white),),
                              ),
                            ) : SizedBox(),
                            backColor: Colors.white,
                            borderColor: Colors.brown,
                            name: map['BranchName'].toString(),
                            totalDue: map['TotalDue'] == null
                                ? '0'
                                : map['TotalDue'].toString(),
                            totalReceived: map['TotalReceived'] == null ? '0' :
                            map['TotalReceived'].toString(),
                            totalBalance: map['TotalBalance'] == null ? '0' :
                            map['TotalBalance'].toString(),
                            onSelected: (int value) async {
                              if (map['BranchID'] < 0) {
                                nameController.text =
                                    map['BranchName'].toString();
                                longLatController.text =
                                    map['LongLat'].toString();

                                contactNumberController.text =
                                    map['ContactNo'].toString();

                                addressController.text =
                                    map['Address'].toString();
                                showGeneralDialog(
                                    context: context,
                                    pageBuilder: (BuildContext context,
                                        animation, secondaryAnimation) {
                                      return Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: branchDialog(
                                              OpenForEditOrSave: 'Edit',
                                              onPressedClose: () async {
                                                Provider.of<
                                                    ShowInsertingTableRowTOServer>(
                                                    context, listen: false)
                                                    .resetRow();

                                                Navigator.pop(context);

                                                setState(() {});
                                              },
                                              onPressed: () async {
                                                SchoolBranches schoolBranch = SchoolBranches();

                                                int updateStatus = await schoolBranch
                                                    .updateSchoolBranches(
                                                    id:
                                                    int.parse(
                                                        map['ID'].toString()),
                                                    name: nameController
                                                        .text
                                                        .toString(),
                                                    context: context,
                                                    address:
                                                    addressController
                                                        .text
                                                        .toString(),
                                                    contactNumber:
                                                    contactNumberController
                                                        .text
                                                        .toString(),
                                                    longLat: int.parse(
                                                        longLatController
                                                            .text
                                                            .toString()));

                                                if (updateStatus ==
                                                    1) {
                                                  ScaffoldMessenger
                                                      .of(
                                                      mainBuildContext)
                                                      .showSnackBar(
                                                      SnackBar(
                                                          content:
                                                          Text(
                                                              'Update Successful')));
                                                } else {
                                                  ScaffoldMessenger
                                                      .of(
                                                      mainBuildContext)
                                                      .showSnackBar(
                                                      SnackBar(
                                                          content:
                                                          Text(
                                                              'Update Failed')));
                                                }


                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              ContactNumber:
                                              contactNumberController,
                                              Address: addressController,
                                              name: nameController,
                                              context: context,
                                              LongLat: longLatController,
                                            ),
                                          ));
                                    });

                                setState(() {});
                              } else {
                                List userRightList = await _salePurSQLDataBase
                                    .userRightsChecking(widget.menuName);
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Custom Right') {
                                  if (userRightList[0]['Editing']
                                      .toString()
                                      == 'true') {
                                    nameController.text =
                                        map['BranchName'].toString();
                                    longLatController.text =
                                        map['LongLat'].toString();

                                    contactNumberController.text =
                                        map['ContactNo'].toString();

                                    addressController.text =
                                        map['Address'].toString();
                                    showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext context,
                                            animation, secondaryAnimation) {
                                          return Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: MediaQuery
                                                        .of(context)
                                                        .viewInsets
                                                        .bottom),
                                                child: branchDialog(
                                                  OpenForEditOrSave: 'Edit',
                                                  onPressedClose: () async {
                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .resetRow();

                                                    Navigator.pop(context);

                                                    setState(() {});
                                                  },
                                                  onPressed: () async {
                                                    SchoolBranches schoolBranch = SchoolBranches();

                                                    int updateStatus = await schoolBranch
                                                        .updateSchoolBranches(
                                                        id:
                                                        map['ID'],
                                                        name: nameController
                                                            .text
                                                            .toString(),
                                                        context: context,
                                                        address:
                                                        addressController
                                                            .text
                                                            .toString(),
                                                        contactNumber:
                                                        contactNumberController
                                                            .text
                                                            .toString(),
                                                        longLat: int.parse(
                                                            longLatController
                                                                .text
                                                                .toString()));

                                                    if (updateStatus ==
                                                        1) {
                                                      ScaffoldMessenger
                                                          .of(
                                                          mainBuildContext)
                                                          .showSnackBar(
                                                          SnackBar(
                                                              content:
                                                              Text(
                                                                  'Update Successful')));
                                                    } else {
                                                      ScaffoldMessenger
                                                          .of(
                                                          mainBuildContext)
                                                          .showSnackBar(
                                                          SnackBar(
                                                              content:
                                                              Text(
                                                                  'Update Failed')));
                                                    }
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  ContactNumber:
                                                  contactNumberController,
                                                  Address: addressController,
                                                  name: nameController,
                                                  context: context,
                                                  LongLat: longLatController,
                                                ),
                                              ));
                                        });

                                    setState(() {});
                                  }
                                } else
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Admin') {
                                  nameController.text =
                                      map['BranchName'].toString();
                                  longLatController.text =
                                      map['LongLat'].toString();

                                  contactNumberController.text =
                                      map['ContactNo'].toString();

                                  addressController.text =
                                      map['Address'].toString();
                                  showGeneralDialog(
                                      context: context,
                                      pageBuilder: (BuildContext context,
                                          animation, secondaryAnimation) {
                                        return Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery
                                                      .of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: branchDialog(
                                                OpenForEditOrSave: 'Edit',
                                                onPressedClose: () async {
                                                  Provider.of<
                                                      ShowInsertingTableRowTOServer>(
                                                      context, listen: false)
                                                      .resetRow();


                                                  Navigator.pop(context);

                                                  setState(() {});
                                                },
                                                onPressed: () async {
                                                  SchoolBranches
                                                  schoolBranch =
                                                  SchoolBranches();

                                                  int updateStatus = await schoolBranch
                                                      .updateSchoolBranches(
                                                      id:
                                                      map['ID'],
                                                      name: nameController
                                                          .text
                                                          .toString(),
                                                      context: context,
                                                      address:
                                                      addressController
                                                          .text
                                                          .toString(),
                                                      contactNumber:
                                                      contactNumberController
                                                          .text
                                                          .toString(),
                                                      longLat: int.parse(
                                                          longLatController
                                                              .text
                                                              .toString()));

                                                  if (updateStatus ==
                                                      1) {
                                                    ScaffoldMessenger
                                                        .of(
                                                        mainBuildContext)
                                                        .showSnackBar(
                                                        SnackBar(
                                                            content:
                                                            Text(
                                                                'Update Successful')));
                                                  } else {
                                                    ScaffoldMessenger
                                                        .of(
                                                        mainBuildContext)
                                                        .showSnackBar(
                                                        SnackBar(
                                                            content:
                                                            Text(
                                                                'Update Failed')));
                                                  }
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                ContactNumber:
                                                contactNumberController,
                                                Address: addressController,
                                                name: nameController,
                                                context: context,
                                                LongLat: longLatController,
                                              ),
                                            ));
                                      });

                                  setState(() {});
                                }
                              }
                            },
                          ),
                        ));
                  });
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
////////////////////////////////////////////////////////////////
        /////   add new campus button ////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FutureBuilder(
                        future: _salePurSQLDataBase.userRightsChecking(
                            widget.menuName),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: () async {
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Custom Right') {
                                  if (snapshot.data![0]['Inserting']
                                      .toString()
                                      == 'true') {
                                    nameController.clear();
                                    addressController.clear();
                                    contactNumberController.clear();
                                    longLatController.clear();
                                    await showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext context,
                                            animation, secondaryAnimation) {
                                          return Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery
                                                      .of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: branchDialog(
                                                  OpenForEditOrSave: 'Save',
                                                  onPressedClose: () async {
                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .resetRow();


                                                    Navigator.pop(context);

                                                    // setState(() {});
                                                  },
                                                  name: nameController,
                                                  Address:
                                                  addressController,
                                                  ContactNumber:
                                                  contactNumberController,
                                                  LongLat:
                                                  longLatController,
                                                  onPressed: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      await schoolBranches
                                                          .insertSchoolBranches(
                                                          context: context,
                                                          branchName:
                                                          nameController
                                                              .text
                                                              .toString(),
                                                          address:
                                                          addressController
                                                              .text
                                                              .toString(),
                                                          contactNumber:
                                                          contactNumberController
                                                              .text
                                                              .toString());

                                                      Provider.of<
                                                          ShowInsertingTableRowTOServer>(
                                                          context,
                                                          listen: false)
                                                          .insertingRow();

                                                      // Navigator.pop(context);
                                                      nameController.clear();
                                                      addressController.clear();
                                                      contactNumberController
                                                          .clear();
                                                      longLatController.clear();

                                                      setState(() {});
                                                    }
                                                  },
                                                  context: context),
                                            ),
                                          );
                                        });

                                    setState(() {});
                                  }
                                } else
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Admin') {
                                  nameController.clear();
                                  addressController.clear();
                                  contactNumberController.clear();
                                  longLatController.clear();
                                  await showGeneralDialog(
                                      context: context,
                                      pageBuilder: (BuildContext context,
                                          animation, secondaryAnimation) {
                                        return Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: branchDialog(
                                                OpenForEditOrSave: 'Save',
                                                onPressedClose: () async {
                                                  Provider.of<
                                                      ShowInsertingTableRowTOServer>(
                                                      context, listen: false)
                                                      .resetRow();
                                                  Navigator.pop(context);

                                                  setState(() {});
                                                },
                                                name: nameController,
                                                Address:
                                                addressController,
                                                ContactNumber:
                                                contactNumberController,
                                                LongLat:
                                                longLatController,
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    await schoolBranches
                                                        .insertSchoolBranches(
                                                        context: context,
                                                        branchName:
                                                        nameController
                                                            .text
                                                            .toString(),
                                                        address:
                                                        addressController
                                                            .text
                                                            .toString(),
                                                        contactNumber:
                                                        contactNumberController
                                                            .text
                                                            .toString());

                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .insertingRow();

                                                    nameController.clear();
                                                    addressController.clear();
                                                    contactNumberController
                                                        .clear();
                                                    longLatController.clear();

                                                    setState(() {});
                                                  }
                                                },
                                                context: context),
                                          ),
                                        );
                                      });

                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all()
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(Icons.add, color: Colors.green,
                                      size: fontSize,),
                                    Text('ADD New Campus'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        )
      ],
    )
        : 'Year' == modelShowYearListView.getStatus()
        ? ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Align(alignment: Alignment.centerLeft, child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Educational Years',
            style: TextStyle(fontSize: 20, color: Colors.blue[900]),),
        )),
        FutureBuilder(
          future: _schoolSQL.dataForSch1EducationYear(
              branchID: modelSchoolBranchSystem.id.toString()),
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    List sortedList = [];
                    if (widget.isDecending == true) {
                      sortedList = snapshot.data!.reversed.toList();
                    } else if (widget.isDecendingCredit == true) {
                      sortedList = snapshot.data!.reversed.toList();
                    } else if (widget.isDecendingDebit == true) {
                      sortedList = snapshot.data!.reversed.toList();
                    } else {
                      sortedList = snapshot.data!;
                    }
                    Map map = {};
                    if (index < snapshot.data!.length) {
                      map = sortedList[index];
                    }
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          modelYearEducation.setName(
                            map['EducationalYear'].toString(),
                          );
                          modelYearEducation
                              .setID(map['EducationalYearID']);
                          modelYearEducation.opacity = 1.0;

                          modelShowYearListView
                              .setStatus('Classes');
                        });
                      },
                      child: customListView(
                        studentQuantity: map['StudentQTY'] == null
                            ? '0'
                            : map['StudentQTY'].toString(),
                        statusRecord: map['EducationalYearID'] == null
                            ? Text('')
                            : map['EducationalYearID'] < 0 &&
                            map['UpdatedDate']
                                .toString()
                                .length == 0 ? Container(
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'New',
                              style: TextStyle(color: Colors.white),),
                          ),
                        ) : map['EducationalYearID'] > 0 &&
                            map['UpdatedDate']
                                .toString()
                                .length == 0 ? Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Modified',
                              style: TextStyle(color: Colors.white),),
                          ),
                        ) : SizedBox(),
                        backColor: Colors.blue.shade100,
                        borderColor: Colors.blue[900]!,
                        name: map['EducationalYear'].toString(),
                        totalDue: map['TotalDue'] == null
                            ? '0'
                            : map['TotalDue'].toString(),
                        totalReceived: map['TotalReceived'] == null ? '0' :
                        map['TotalReceived'].toString(),
                        totalBalance: map['TotalBalance'] == null ? '0' :
                        map['TotalBalance'].toString(),
                        onSelected: (int value) async {
                          if (map['EducationalYearID'] < 0) {
                            yearEducationController.clear();
                            yearEducationController.text =
                                map['EducationalYear']
                                    .toString()
                                    .trim();
                            await showGeneralDialog(
                                context: context,
                                pageBuilder:
                                    (BuildContext context,
                                    animation,
                                    secondaryAnimation) {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery
                                              .of(context)
                                              .viewInsets
                                              .bottom),
                                      child: YearEducationalDialog
                                          .yearEducationalDialog(
                                          OpenForEditOrSave: 'Edit',
                                          onPressedClose: () async {
                                            Provider.of<
                                                ShowInsertingTableRowTOServer>(
                                                context, listen: false)
                                                .resetRow();
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          title:
                                          'Year Education',
                                          controller:
                                          yearEducationController,
                                          onPressed: () async {
                                            int updateStatus = await schoolYear
                                                .updateSchoolYear(
                                                id: map['ID'],
                                                yearEducation:
                                                yearEducationController
                                                    .text
                                                    .toString(),
                                                context:
                                                context);
                                            if (updateStatus ==
                                                1) {
                                              ScaffoldMessenger
                                                  .of(
                                                  mainBuildContext)
                                                  .showSnackBar(
                                                  SnackBar(
                                                      content:
                                                      Text(
                                                          'Update Successful')));
                                              Navigator.pop(
                                                  context);
                                              setState(() {});
                                            } else {
                                              ScaffoldMessenger
                                                  .of(
                                                  mainBuildContext)
                                                  .showSnackBar(
                                                  SnackBar(
                                                      content:
                                                      Text('Update Failed')));
                                            }
                                          },
                                          context: context),
                                    ),
                                  );
                                });
                            setState(() {});
                          } else {
                            List userRightList = await _salePurSQLDataBase
                                .userRightsChecking(widget.menuName);
                            if (SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.userRightsClient) ==
                                'Custom Right') {
                              if (userRightList[0]['Editing']
                                  .toString()
                                  == 'true') {
                                yearEducationController.clear();
                                yearEducationController.text =
                                    map['EducationalYear']
                                        .toString()
                                        .trim();
                                await showGeneralDialog(
                                    context: context,
                                    pageBuilder:
                                        (BuildContext context,
                                        animation,
                                        secondaryAnimation) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery
                                                  .of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: YearEducationalDialog
                                              .yearEducationalDialog(
                                              OpenForEditOrSave: 'Edit',
                                              onPressedClose: () async {
                                                Provider.of<
                                                    ShowInsertingTableRowTOServer>(
                                                    context, listen: false)
                                                    .resetRow();
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              title:
                                              'Year Education',
                                              controller:
                                              yearEducationController,
                                              onPressed: () async {
                                                int updateStatus = await schoolYear
                                                    .updateSchoolYear(
                                                    id: map['ID'],
                                                    yearEducation:
                                                    yearEducationController
                                                        .text
                                                        .toString(),
                                                    context:
                                                    context);
                                                if (updateStatus ==
                                                    1) {
                                                  ScaffoldMessenger
                                                      .of(
                                                      mainBuildContext)
                                                      .showSnackBar(
                                                      SnackBar(
                                                          content:
                                                          Text(
                                                              'Update Successful')));
                                                  Navigator.pop(
                                                      context);
                                                  setState(() {});
                                                } else {
                                                  ScaffoldMessenger
                                                      .of(
                                                      mainBuildContext)
                                                      .showSnackBar(
                                                      SnackBar(
                                                          content:
                                                          Text(
                                                              'Update Failed')));
                                                }
                                              },
                                              context: context),
                                        ),
                                      );
                                    });
                                setState(() {});
                              }
                            } else if (SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.userRightsClient) ==
                                'Admin') {
                              yearEducationController.clear();
                              yearEducationController.text =
                                  map['EducationalYear']
                                      .toString()
                                      .trim();
                              await showGeneralDialog(
                                  context: context,
                                  pageBuilder:
                                      (BuildContext context,
                                      animation,
                                      secondaryAnimation) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery
                                                .of(context)
                                                .viewInsets
                                                .bottom),
                                        child: YearEducationalDialog
                                            .yearEducationalDialog(
                                            OpenForEditOrSave: 'Edit',
                                            onPressedClose: () async {
                                              Provider.of<
                                                  ShowInsertingTableRowTOServer>(
                                                  context, listen: false)
                                                  .resetRow();
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            title:
                                            'Year Education',
                                            controller:
                                            yearEducationController,
                                            onPressed: () async {
                                              int updateStatus = await schoolYear
                                                  .updateSchoolYear(
                                                  id: map['ID'],
                                                  yearEducation:
                                                  yearEducationController
                                                      .text
                                                      .toString(),
                                                  context:
                                                  context);
                                              if (updateStatus ==
                                                  1) {
                                                ScaffoldMessenger
                                                    .of(
                                                    mainBuildContext)
                                                    .showSnackBar(
                                                    SnackBar(
                                                        content:
                                                        Text(
                                                            'Update Successful')));
                                                Navigator.pop(
                                                    context);
                                                setState(() {});
                                              } else {
                                                ScaffoldMessenger
                                                    .of(
                                                    mainBuildContext)
                                                    .showSnackBar(
                                                    SnackBar(
                                                        content:
                                                        Text('Update Failed')));
                                              }
                                            },
                                            context: context),
                                      ),
                                    );
                                  });
                              setState(() {});
                            }
                          }
                        },
                      ),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          },

        ),


        /// button .......................................
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FutureBuilder(
                        future: _salePurSQLDataBase.userRightsChecking(
                            widget.menuName),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: () async {
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Custom Right') {
                                  if (snapshot.data![0]['Inserting']
                                      .toString()
                                      == 'true') {
                                    yearEducationController.clear();
                                    await showGeneralDialog(
                                        context: context,
                                        pageBuilder:
                                            (BuildContext context,
                                            animation,
                                            secondaryAnimation) {
                                          return Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery
                                                      .of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: YearEducationalDialog
                                                  .yearEducationalDialog(
                                                  OpenForEditOrSave: 'Save',
                                                  onPressedClose: () async {
                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .resetRow();

                                                    Navigator.pop(context);


                                                    setState(() {});
                                                  },
                                                  title:
                                                  'ADD Year Education',
                                                  controller:
                                                  yearEducationController,
                                                  onPressed:
                                                      () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      await schoolYear
                                                          .insetYearEducation(
                                                          context:
                                                          context,
                                                          educationalYear:
                                                          yearEducationController
                                                              .text
                                                              .toString(),
                                                          branchID: modelSchoolBranchSystem
                                                              .id);

                                                      Provider.of<
                                                          ShowInsertingTableRowTOServer>(
                                                          context,
                                                          listen: false)
                                                          .insertingRow();


                                                      yearEducationController
                                                          .clear();
                                                    }
                                                  },
                                                  context: context),
                                            ),
                                          );
                                        });

                                    setState(() {});
                                  }
                                } else
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Admin') {
                                  yearEducationController.clear();
                                  await showGeneralDialog(
                                      context: context,
                                      pageBuilder:
                                          (BuildContext context,
                                          animation,
                                          secondaryAnimation) {
                                        return Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: YearEducationalDialog
                                                .yearEducationalDialog(
                                                OpenForEditOrSave: 'Save',
                                                onPressedClose: () async {
                                                  Provider.of<
                                                      ShowInsertingTableRowTOServer>(
                                                      context, listen: false)
                                                      .resetRow();
                                                  Navigator.pop(context);


                                                  setState(() {});
                                                },
                                                title:
                                                'ADD Year Education',
                                                controller:
                                                yearEducationController,
                                                onPressed:
                                                    () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    await schoolYear
                                                        .insetYearEducation(
                                                        context:
                                                        context,
                                                        educationalYear:
                                                        yearEducationController
                                                            .text
                                                            .toString(),
                                                        branchID: modelSchoolBranchSystem
                                                            .id);

                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .insertingRow();

                                                    yearEducationController
                                                        .clear();
                                                  }
                                                },
                                                context: context),
                                          ),
                                        );
                                      });

                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all()
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(Icons.add, color: Colors.green,
                                        size: fontSize),
                                    Text('ADD Year'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          // checkValue = false;
                          // feeAmountController.clear();
                          // int feeDueID =
                          // await studentFeeDue
                          //     .maxIdForStudentFeeDue();
                          //
                          // List listData = await _schoolSQL
                          //     .dataForBulkFeeAllStudentYear(whereCon: 'Sch1Branches.BranchID',
                          //     iD:
                          //     modelSchoolBranchSystem
                          //         .id.toString());
                          //
                          // showGeneralDialog(
                          //     context: mainBuildContext,
                          //     pageBuilder: (BuildContext context,
                          //         animation, secondaryAnimation) {
                          //       dueOnDateController.text =
                          //           currentDate.toString().substring(0, 10);
                          //       return Align(
                          //           alignment: Alignment.center,
                          //           child: bulkFeeAllStudentYear(
                          //             stateName: modelSchoolBranchSystem.getName(),
                          //               dialogTitle: 'Due Fee On All Students Of Campus',
                          //               maxID: feeDueID,
                          //               dueOnDate: dueOnDateController,
                          //               feeNarration:
                          //               feeNarrationController,
                          //               feeAmount: feeAmountController,
                          //               onPressed: () async {
                          //
                          //               if(formKey.currentState!.validate()) {
                          //                 for (int i = 0;
                          //                 i < listData.length;
                          //                 i++) {
                          //                   if (i > 0) {
                          //                     feeDueID += -1;
                          //                   }
                          //                   await studentFeeDue
                          //                       .insertStudentFeeDue(
                          //                       feeDueId: feeDueID,
                          //
                          //                       feeNarration:
                          //                       feeNarrationController
                          //                           .text
                          //                           .toString(),
                          //                       feeDueAmount: feeAmountController
                          //                           .text
                          //                           .isNotEmpty
                          //                           ? double.parse(
                          //                           feeAmountController
                          //                               .text
                          //                               .toString())
                          //                           : listData[i]['MonthlyFee'] ==
                          //                           null
                          //                           ? 0.0
                          //                           : double.parse(
                          //                           listData[i]['MonthlyFee']
                          //                               .toString()),
                          //                       dueDate:
                          //                       dueOnDateController
                          //                           .text
                          //                           .toString(),
                          //                       sectionStudentID: listData[i]
                          //                       ['SectionStudenID'],
                          //                       grn: listData[i]
                          //                       ['GRN']);
                          //                 }
                          //
                          //
                          //                 feeNarrationController.clear();
                          //                 feeAmountController.clear();
                          //                 dueOnDateController.clear();
                          //                 Navigator.pop(context);
                          //               }
                          //               },
                          //               context: context));
                          //     });
                          // setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.replay_30_rounded,
                                color: Colors.blue.shade900, size: fontSize,),
                              Text('Due Fee'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          //
                          // List list = await _feeCollectionSQL
                          //     .dataForAllStudentForNEWBYGRNANDFamilyGroupNo(
                          //     modelYearEducation.id.toString(),
                          //     'Sch2Year.EducationalYearID');

                          //
                          // Navigator.push(mainBuildContext,
                          //     MaterialPageRoute(builder: (context) =>
                          //         FeeCollection(menuName: widget.menuName,
                          //             list: list,
                          //             status: 'RecBulk'),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, color: Colors.grey,
                                size: fontSize,),
                              Text('Fee Rec'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForAllStudentByID(
                              modelSchoolBranchSystem.id.toString(),
                              'Sch1Branches.BranchID');


                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                StudentTotalBalance(
                                    listOFAllStudent: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(

                            children: [
                              Icon(Icons.contact_page_outlined,
                                color: Colors.yellow.shade900, size: fontSize,),
                              Text('Student Balance'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForDueFeeDetails(
                              modelSchoolBranchSystem.id.toString(),
                              'Sch1Branches.BranchID');

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                DueFeeDetails(
                                    list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restore_page_outlined,
                                color: Colors.brown,
                                size: fontSize,),
                              Text('Due Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForFeeRECCompleteDetailsByID(
                              modelSchoolBranchSystem.id.toString(),
                              'Sch1Branches.BranchID');


                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                FeeDetailsComplete(
                                    titleName: modelSchoolBranchSystem
                                        .getName(), list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.request_page_outlined, color: Colors.red,
                                size: fontSize,),
                              Text('Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        FutureBuilder(
          future: _schoolSQL.checkNewAllFeeDueForDeletion(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(content: Text(
                          'Do You Really Want TO delete New FeeDue Records'),
                        actions: [
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: Text('Cancel')),
                          TextButton(onPressed: () async {
                            await _schoolSQL.deleteNewAllFeeDue();
                            await _schoolSQL.deleteNewAllFeeREC1();
                            await _schoolSQL.deleteNewAllFeeREC2();

                            Navigator.pop(context);
                            setState(() {});
                          }, child: Text('delete'))
                        ],
                      );
                    },);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all()
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.delete,
                          color: Colors.red, size: 35,),
                        Text('Delete all new feeDue'),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    )
        : 'Classes' == modelShowYearListView.getStatus()
        ? ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Align(alignment: Alignment.centerLeft, child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Classes',
            style: TextStyle(fontSize: 20, color: Colors.green[900]),),
        )),
        FutureBuilder(
          future: _schoolSQL.dataForSch1EducationYearClass(
              educationalYearID:
              modelYearEducation.id.toString()),
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  List sortedList = [];
                  if (widget.isDecending == true) {
                    sortedList =
                        snapshot.data!.reversed.toList();
                  } else if (widget.isDecendingCredit ==
                      true) {
                    sortedList =
                        snapshot.data!.reversed.toList();
                  } else if (widget.isDecendingDebit ==
                      true) {
                    sortedList =
                        snapshot.data!.reversed.toList();
                  } else {
                    sortedList = snapshot.data!;
                  }
                  Map map = {};
                  if (index < snapshot.data!.length) {
                    map = sortedList[index];
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        modelClassEducation.setName(
                          map['ClassName'].toString(),
                        );
                        modelShowYearListView
                            .setStatus(
                            'ClassesSection');
                        modelClassEducation
                            .setID(map['ClassID']);

                        modelClassEducation.opacity =
                        1.0;
                      });
                    },
                    child: customListView(
                      studentQuantity: map['StudentQTY'] == null
                          ? '0'
                          : map['StudentQTY'].toString(),
                      statusRecord: map['ClassID'] == null
                          ? Text('')
                          : map['ClassID'] < 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'New',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : map['ClassID'] > 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Modified',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : SizedBox(),

                      backColor: Colors.green.shade100,
                      borderColor: Colors.green[900]!,
                      name:
                      map['ClassName'].toString(),
                      totalDue: map['TotalDue'] == null ? '0' :
                      map['TotalDue'].toString(),
                      totalReceived: map['TotalReceived'] == null ? '0' :
                      map['TotalReceived']
                          .toString(),
                      totalBalance: map['TotalBalance'] == null ? '0' :
                      map['TotalBalance']
                          .toString(),
                      onSelected: (int value) async {
                        if (map['ClassID'] < 0) {
                          yearEducationController
                              .clear();
                          yearEducationController.text =
                              map
                              ['ClassName']
                                  .trim();
                          showGeneralDialog(
                              context: context,
                              pageBuilder: (BuildContext
                              context,
                                  animation,
                                  secondaryAnimation) {
                                return Align(
                                  alignment:
                                  Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery
                                            .of(context)
                                            .viewInsets
                                            .bottom),
                                    child: CustomDialogForClasses
                                        .customDialog(
                                        OpenForEditOrSave: 'Edit',
                                        onPressedClose: () async {
                                          Provider.of<
                                              ShowInsertingTableRowTOServer>(
                                              context, listen: false)
                                              .resetRow();
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        title:
                                        'ADD Classes',
                                        controller:
                                        yearEducationController,
                                        onPressed:
                                            () async {
                                          int updateStatus = await yearClasses
                                              .updateClasses(
                                              id: map['ID'],
                                              classYearName: yearEducationController
                                                  .text
                                                  .toString()
                                                  .trim(),
                                              context:
                                              context);
                                          if (updateStatus ==
                                              1) {
                                            ScaffoldMessenger.of(
                                                mainBuildContext)
                                                .showSnackBar(
                                                SnackBar(content: Text(
                                                    'Update Successful')));
                                            Navigator.pop(
                                                context);
                                          } else {
                                            ScaffoldMessenger.of(
                                                mainBuildContext)
                                                .showSnackBar(
                                                SnackBar(content: Text(
                                                    'Update Failed')));
                                          }
                                        },
                                        context:
                                        context),
                                  ),
                                );
                              });
                          setState(() {

                          });
                        } else {
                          List userRightList = await _salePurSQLDataBase
                              .userRightsChecking(widget.menuName);
                          if (SharedPreferencesKeys.prefs!.getString(
                              SharedPreferencesKeys.userRightsClient) ==
                              'Custom Right') {
                            if (userRightList[0]['Editing']
                                .toString()
                                == 'true') {
                              yearEducationController
                                  .clear();
                              yearEducationController.text =
                                  map
                                  ['ClassName']
                                      .trim();
                              showGeneralDialog(
                                  context: context,
                                  pageBuilder: (BuildContext
                                  context,
                                      animation,
                                      secondaryAnimation) {
                                    return Align(
                                      alignment:
                                      Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery
                                                .of(context)
                                                .viewInsets
                                                .bottom),
                                        child: CustomDialogForClasses
                                            .customDialog(
                                            OpenForEditOrSave: 'Edit',
                                            onPressedClose: () async {
                                              Provider.of<
                                                  ShowInsertingTableRowTOServer>(
                                                  context, listen: false)
                                                  .resetRow();
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            title:
                                            'ADD Classes',
                                            controller:
                                            yearEducationController,
                                            onPressed:
                                                () async {
                                              int updateStatus = await yearClasses
                                                  .updateClasses(
                                                  id: map['ID'],
                                                  classYearName: yearEducationController
                                                      .text
                                                      .toString()
                                                      .trim(),
                                                  context:
                                                  context);
                                              if (updateStatus ==
                                                  1) {
                                                ScaffoldMessenger.of(
                                                    mainBuildContext)
                                                    .showSnackBar(
                                                    SnackBar(content: Text(
                                                        'Update Successful')));
                                                Navigator.pop(
                                                    context);
                                              } else {
                                                ScaffoldMessenger.of(
                                                    mainBuildContext)
                                                    .showSnackBar(
                                                    SnackBar(content: Text(
                                                        'Update Failed')));
                                              }
                                            },
                                            context:
                                            context),
                                      ),
                                    );
                                  });
                              setState(() {

                              });
                            }
                          } else if (SharedPreferencesKeys.prefs!.getString(
                              SharedPreferencesKeys.userRightsClient) ==
                              'Admin') {
                            yearEducationController
                                .clear();
                            yearEducationController.text =
                                map
                                ['ClassName']
                                    .trim();
                            showGeneralDialog(
                                context: context,
                                pageBuilder: (BuildContext
                                context,
                                    animation,
                                    secondaryAnimation) {
                                  return Align(
                                    alignment:
                                    Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery
                                              .of(context)
                                              .viewInsets
                                              .bottom),
                                      child: CustomDialogForClasses
                                          .customDialog(
                                          onPressedClose: () async {
                                            Provider.of<
                                                ShowInsertingTableRowTOServer>(
                                                context, listen: false)
                                                .resetRow();
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          title:
                                          'ADD Classes',
                                          OpenForEditOrSave: 'Edit',
                                          controller:
                                          yearEducationController,
                                          onPressed:
                                              () async {
                                            int updateStatus = await yearClasses
                                                .updateClasses(
                                                id: map['ID'],
                                                classYearName: yearEducationController
                                                    .text
                                                    .toString()
                                                    .trim(),
                                                context:
                                                context);
                                            if (updateStatus ==
                                                1) {
                                              ScaffoldMessenger.of(
                                                  mainBuildContext)
                                                  .showSnackBar(
                                                  SnackBar(content: Text(
                                                      'Update Successful')));
                                              Navigator.pop(
                                                  context);
                                            } else {
                                              ScaffoldMessenger.of(
                                                  mainBuildContext)
                                                  .showSnackBar(
                                                  SnackBar(content: Text(
                                                      'Update Failed')));
                                            }
                                          },
                                          context:
                                          context),
                                    ),
                                  );
                                });
                            setState(() {

                            });
                          }
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),


        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FutureBuilder(
                        future: _salePurSQLDataBase.userRightsChecking(
                            widget.menuName),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: () async {
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Custom Right') {
                                  if (snapshot.data![0]['Inserting']
                                      .toString()
                                      == 'true') {
                                    yearEducationController
                                        .clear();
                                    await showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext
                                        context,
                                            animation,
                                            secondaryAnimation) {
                                          return Align(
                                            alignment: Alignment
                                                .center,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery
                                                      .of(context)
                                                      .viewInsets
                                                      .bottom),

                                              child: CustomDialogForClasses
                                                  .customDialog(
                                                  OpenForEditOrSave: 'Save',
                                                  onPressedClose: () async {
                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .resetRow();
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  title:
                                                  'ADD Classes',
                                                  controller:
                                                  yearEducationController,
                                                  onPressed:
                                                      () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      await yearClasses
                                                          .insertCLasses(
                                                          context:
                                                          context,
                                                          educationalYearID: modelYearEducation
                                                              .id,
                                                          className: yearEducationController
                                                              .text
                                                              .toString());
                                                      Provider.of<
                                                          ShowInsertingTableRowTOServer>(
                                                          context,
                                                          listen: false)
                                                          .resetRow();
                                                    }
                                                    yearEducationController
                                                        .clear();
                                                  },
                                                  context:
                                                  context),
                                            ),
                                          );
                                        });

                                    setState(() {});
                                  }
                                } else
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Admin') {
                                  yearEducationController
                                      .clear();
                                  await showGeneralDialog(
                                      context: context,
                                      pageBuilder: (BuildContext
                                      context,
                                          animation,
                                          secondaryAnimation) {
                                        return Align(
                                          alignment: Alignment
                                              .center,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: CustomDialogForClasses
                                                .customDialog(
                                                OpenForEditOrSave: 'Save',
                                                onPressedClose: () async {
                                                  Provider.of<
                                                      ShowInsertingTableRowTOServer>(
                                                      context, listen: false)
                                                      .resetRow();

                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                title:
                                                'ADD Classes',
                                                controller:
                                                yearEducationController,
                                                onPressed:
                                                    () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    await yearClasses
                                                        .insertCLasses(
                                                        context:
                                                        context,
                                                        educationalYearID: modelYearEducation
                                                            .id,
                                                        className: yearEducationController
                                                            .text
                                                            .toString());

                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .insertingRow();
                                                  }

                                                  yearEducationController
                                                      .clear();
                                                },
                                                context:
                                                context),
                                          ),
                                        );
                                      });

                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all()
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(Icons.add, color: Colors.green,
                                      size: fontSize,),
                                    Text('ADD Class'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          int monthlyFee = 0;
                          checkValue = false;
                          feeAmountController.clear();
                          feeNarrationController.clear();
                          int feeDueID =
                          await studentFeeDue
                              .maxIdForStudentFeeDue();
                          List listData = await _schoolSQL
                              .dataForBulkFeeAllStudentYear(
                              whereCon: 'Sch3Classes.EducationalYearID',
                              iD:
                              modelYearEducation.id.toString());


                          for (int i = 0;
                          i < listData
                              .length;
                          i++) {
                            monthlyFee +=
                                int.parse(listData[i]['MonthlyFee'].toString());
                          }

                          showGeneralDialog(
                              context: mainBuildContext,
                              pageBuilder: (BuildContext contextDueFee,
                                  animation, secondaryAnimation) {
                                dueOnDateController.text =
                                    currentDate.toString().substring(0, 10);
                                return SafeArea(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery
                                                .of(contextDueFee)
                                                .viewInsets
                                                .bottom),
                                        duration: const Duration(
                                            milliseconds: 300),
                                        child: bulkFeeAllStudentYear(
                                            dialogTitle: 'Due Fee on All Student of Year',
                                            stateName: modelYearEducation
                                                .getName(),
                                            maxID: feeDueID,
                                            dueOnDate: dueOnDateController,
                                            feeNarration:
                                            feeNarrationController,
                                            feeAmount: feeAmountController,
                                            onPressed: () async {
                                              Provider.of<
                                                  ShowInsertingTableRowTOServer>(
                                                  context, listen: false)
                                                  .totalNumberOfTableRow(
                                                  totalNumberOfRow: listData
                                                      .length.toInt());

                                              if (formKey.currentState!
                                                  .validate()) {
                                                showDialog(
                                                    context: contextDueFee,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Confirmation'),
                                                        content: Text(
                                                            'Total Student : ${listData
                                                                .length}  \n Total Due Fee : ${feeAmountController
                                                                .text
                                                                .toString()
                                                                .length == 0
                                                                ? monthlyFee
                                                                : (int.parse(
                                                                feeAmountController
                                                                    .text
                                                                    .toString()) *
                                                                listData
                                                                    .length)}'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () async {
                                                                Constants
                                                                    .onLoading(
                                                                    context,
                                                                    'Due Fee Processing');
                                                                for (int i = 0;
                                                                i < listData
                                                                    .length;
                                                                i++) {
                                                                  if (i > 0) {
                                                                    feeDueID +=
                                                                    -1;
                                                                  }

                                                                  Provider.of<
                                                                      ShowInsertingTableRowTOServer>(
                                                                      context,
                                                                      listen: false)
                                                                      .insertingRow();
                                                                  await studentFeeDue
                                                                      .insertStudentFeeDue(
                                                                      feeDueId: feeDueID,

                                                                      feeNarration:
                                                                      feeNarrationController
                                                                          .text
                                                                          .toString(),
                                                                      feeDueAmount: feeAmountController
                                                                          .text
                                                                          .toString()
                                                                          .length >
                                                                          0
                                                                          ? double
                                                                          .parse(
                                                                          feeAmountController
                                                                              .text
                                                                              .toString())
                                                                          : listData[i]['MonthlyFee'] ==
                                                                          null
                                                                          ? 0.0
                                                                          : double
                                                                          .parse(
                                                                          listData[i]['MonthlyFee']
                                                                              .toString()),
                                                                      dueDate:
                                                                      dueOnDateController
                                                                          .text
                                                                          .toString(),
                                                                      sectionStudentID: listData[i]
                                                                      ['SectionStudenID'],
                                                                      grn: listData[i]
                                                                      ['GRN']);
                                                                }
                                                                feeNarrationController
                                                                    .clear();
                                                                feeAmountController
                                                                    .clear();
                                                                dueOnDateController
                                                                    .clear();

                                                                Provider.of<
                                                                    ShowInsertingTableRowTOServer>(
                                                                    context,
                                                                    listen: false)
                                                                    .resetRow();

                                                                Provider.of<
                                                                    ShowInsertingTableRowTOServer>(
                                                                    context,
                                                                    listen: false)
                                                                    .resetTotalNumber();
                                                                Constants
                                                                    .hideDialog(
                                                                    context);

                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    contextDueFee);
                                                              }, child: Text(
                                                              'Confirm')),
                                                        ],
                                                      );
                                                    });
                                              }
                                            },
                                            context: contextDueFee),
                                      )),
                                );
                              });

                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.replay_30_rounded,
                                color: Colors.blue.shade900, size: fontSize,),
                              Text('Due Fee'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List list = await _feeCollectionSQL
                              .dataForAllStudentForNEWBYGRNANDFamilyGroupNo(
                              modelYearEducation.id.toString(),
                              'Sch2Year.EducationalYearID');


                          Navigator.push(mainBuildContext,
                              MaterialPageRoute(builder: (context) =>
                                  FeeCollection(menuName: widget.menuName,
                                      list: list,
                                      status: 'RecBulk'),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, color: Colors.grey,
                                size: fontSize,),
                              Text('Fee Rec'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForAllStudentByID(
                              modelYearEducation.id.toString(),
                              'Sch2Year.EducationalYearID');

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                StudentTotalBalance(
                                    listOFAllStudent: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(

                            children: [
                              Icon(Icons.contact_page_outlined,
                                color: Colors.yellow.shade900, size: fontSize,),
                              Text('Student Balance'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForDueFeeDetails(
                              modelYearEducation.id.toString(),
                              'Sch2Year.EducationalYearID');

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                DueFeeDetails(
                                    list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restore_page_outlined,
                                color: Colors.brown,
                                size: fontSize,),
                              Text('Due Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForFeeRECCompleteDetailsByID(
                              modelYearEducation.id.toString(),
                              'Sch2Year.EducationalYearID');


                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                FeeDetailsComplete(
                                    titleName: modelYearEducation.getName(),
                                    list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.request_page_outlined, color: Colors.red,
                                size: fontSize,),
                              Text('Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        FutureBuilder(
          future: _schoolSQL.checkNewAllFeeDueForDeletion(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(content: Text(
                          'Do You Really Want TO delete New FeeDue Records'),
                        actions: [
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: Text('Cancel')),
                          TextButton(onPressed: () async {
                            await _schoolSQL.deleteNewAllFeeDue();
                            await _schoolSQL.deleteNewAllFeeREC1();
                            await _schoolSQL.deleteNewAllFeeREC2();

                            Navigator.pop(context);
                            setState(() {});
                          }, child: Text('delete'))
                        ],
                      );
                    },);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all()
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.delete,
                          color: Colors.red, size: 35,),
                        Text('Delete all new feeDue'),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    )
        : 'ClassesSection' == modelShowYearListView.getStatus()
        ? ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Align(alignment: Alignment.centerLeft, child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Section',
            style: TextStyle(fontSize: 20, color: Colors.orange[900]),),
        )),
        FutureBuilder(
          future: _schoolSQL.dataForSch1ClassSection(
              classID: modelClassEducation.id.toString()),
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  List sortedList = [];
                  if (widget.isDecending == true) {
                    sortedList =
                        snapshot.data!.reversed.toList();
                  } else if (widget.isDecendingCredit ==
                      true) {
                    sortedList =
                        snapshot.data!.reversed.toList();
                  } else if (widget.isDecendingDebit ==
                      true) {
                    sortedList =
                        snapshot.data!.reversed.toList();
                  } else {
                    sortedList = snapshot.data!;
                  }
                  Map map = {};
                  if (index < snapshot.data!.length) {
                    map = sortedList[index];
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        modelShowSectionListView
                            .setName(
                          map['SectionName'].toString(),
                        );
                        modelShowYearListView.setStatus(
                            'SectionStudent');

                        modelShowYearListView.setStudentQTY(
                          map['StudentQTY'] == null ? '0' : map['StudentQTY']
                              .toString(),);
                        modelShowSectionListView
                            .setID(map['SectionID']);
                        modelShowSectionListView
                            .opacity = 1.0;
                      });
                    },
                    child: customListView(
                      studentQuantity: map['StudentQTY'] == null
                          ? '0'
                          : map['StudentQTY'].toString(),
                      statusRecord: map['SectionID'] == null
                          ? Text('')
                          : map['SectionID'] < 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'New',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : map['SectionID'] > 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Modified',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : SizedBox(),

                      backColor: Colors.orange.shade50,
                      borderColor: Colors.orange[900]!,
                      name:
                      map['SectionName'].toString(),
                      totalDue: map['TotalDue'] == null ? '0' :
                      map['TotalDue'].toString(),
                      totalReceived: map['TotalReceived'] == null ? '0' :
                      map['TotalReceived']
                          .toString(),
                      totalBalance: map['TotalBalance'] == null ? '0' :
                      map['TotalBalance']
                          .toString(),
                      onSelected: (int value) async {
                        if (map['SectionID'] < 0) {
                          classSectionController.clear();
                          classSectionController.text =
                              map
                              ['SectionName']
                                  .trim();
                          await showGeneralDialog(
                              context: context,
                              pageBuilder: (BuildContext
                              context,
                                  animation,
                                  secondaryAnimation) {
                                return Align(
                                  alignment:
                                  Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery
                                            .of(context)
                                            .viewInsets
                                            .bottom),
                                    child: CustomDialogForClassSection
                                        .customClassSectionDialog(
                                        OpenForEditOrSave: 'Edit',
                                        onPressedClose: () async {
                                          Provider.of<
                                              ShowInsertingTableRowTOServer>(
                                              context, listen: false)
                                              .resetRow();

                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        title:
                                        'Class Section ',
                                        controller:
                                        classSectionController,
                                        onPressed:
                                            () async {
                                          int updateStatus =
                                          await classSection
                                              .updateClassesSection(
                                            id: map['ID'],
                                            classSectionName: classSectionController
                                                .text
                                                .toString()
                                                .trim(),
                                            context:
                                            context,
                                          );
                                          if (updateStatus ==
                                              1) {
                                            ScaffoldMessenger.of(
                                                mainBuildContext)
                                                .showSnackBar(SnackBar(
                                                content:
                                                Text('Update Successful')));
                                            Navigator.pop(
                                                context);
                                          } else {
                                            ScaffoldMessenger.of(
                                                mainBuildContext)
                                                .showSnackBar(SnackBar(
                                                content:
                                                Text('Update Failed')));
                                          }
                                        },
                                        context:
                                        context),
                                  ),
                                );
                              });

                          setState(() {});
                        } else {
                          List userRightList = await _salePurSQLDataBase
                              .userRightsChecking(widget.menuName);
                          if (SharedPreferencesKeys.prefs!.getString(
                              SharedPreferencesKeys.userRightsClient) ==
                              'Custom Right') {
                            if (userRightList[0]['Editing']
                                .toString()
                                == 'true') {
                              classSectionController.clear();
                              classSectionController.text =
                                  map
                                  ['SectionName']
                                      .trim();
                              await showGeneralDialog(
                                  context: context,
                                  pageBuilder: (BuildContext
                                  context,
                                      animation,
                                      secondaryAnimation) {
                                    return Align(
                                      alignment:
                                      Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery
                                                .of(context)
                                                .viewInsets
                                                .bottom),
                                        child: CustomDialogForClassSection
                                            .customClassSectionDialog(
                                            OpenForEditOrSave: 'Edit',
                                            onPressedClose: () async {
                                              Provider.of<
                                                  ShowInsertingTableRowTOServer>(
                                                  context, listen: false)
                                                  .resetRow();

                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            title:
                                            'Class Section ',
                                            controller:
                                            classSectionController,
                                            onPressed:
                                                () async {
                                              int updateStatus =
                                              await classSection
                                                  .updateClassesSection(
                                                id: map['ID'],
                                                classSectionName: classSectionController
                                                    .text
                                                    .toString()
                                                    .trim(),
                                                context:
                                                context,
                                              );
                                              if (updateStatus ==
                                                  1) {
                                                ScaffoldMessenger.of(
                                                    mainBuildContext)
                                                    .showSnackBar(SnackBar(
                                                    content:
                                                    Text('Update Successful')));
                                                Navigator.pop(
                                                    context);
                                              } else {
                                                ScaffoldMessenger.of(
                                                    mainBuildContext)
                                                    .showSnackBar(SnackBar(
                                                    content:
                                                    Text('Update Failed')));
                                              }
                                            },
                                            context:
                                            context),
                                      ),
                                    );
                                  });

                              setState(() {});
                            }
                          } else if (SharedPreferencesKeys.prefs!.getString(
                              SharedPreferencesKeys.userRightsClient) ==
                              'Admin') {
                            classSectionController.clear();
                            classSectionController.text =
                                map
                                ['SectionName']
                                    .trim();
                            await showGeneralDialog(
                                context: context,
                                pageBuilder: (BuildContext
                                context,
                                    animation,
                                    secondaryAnimation) {
                                  return Align(
                                    alignment:
                                    Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery
                                              .of(context)
                                              .viewInsets
                                              .bottom),

                                      child: CustomDialogForClassSection
                                          .customClassSectionDialog(
                                          OpenForEditOrSave: 'Edit',
                                          onPressedClose: () async {
                                            Provider.of<
                                                ShowInsertingTableRowTOServer>(
                                                context, listen: false)
                                                .resetRow();

                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          title:
                                          'Class Section ',
                                          controller:
                                          classSectionController,
                                          onPressed:
                                              () async {
                                            int updateStatus =
                                            await classSection
                                                .updateClassesSection(
                                              id: map['ID'],
                                              classSectionName: classSectionController
                                                  .text
                                                  .toString()
                                                  .trim(),
                                              context:
                                              context,
                                            );
                                            if (updateStatus ==
                                                1) {
                                              ScaffoldMessenger.of(
                                                  mainBuildContext)
                                                  .showSnackBar(SnackBar(
                                                  content:
                                                  Text('Update Successful')));
                                              Navigator.pop(
                                                  context);
                                            } else {
                                              ScaffoldMessenger.of(
                                                  mainBuildContext)
                                                  .showSnackBar(SnackBar(
                                                  content:
                                                  Text('Update Failed')));
                                            }
                                          },
                                          context:
                                          context),
                                    ),
                                  );
                                });

                            setState(() {});
                          }
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FutureBuilder(
                        future:
                        _salePurSQLDataBase.userRightsChecking(widget.menuName),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: () async {
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Custom Right') {
                                  if (snapshot.data![0]['Inserting']
                                      .toString()
                                      == 'true') {
                                    classSectionController
                                        .clear();
                                    await showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext
                                        context,
                                            animation,
                                            secondaryAnimation) {
                                          return Align(
                                            alignment:
                                            Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery
                                                      .of(context)
                                                      .viewInsets
                                                      .bottom),

                                              child: CustomDialogForClassSection
                                                  .customClassSectionDialog(
                                                  OpenForEditOrSave: 'Save',
                                                  onPressedClose: () async {
                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .resetRow();

                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  title:
                                                  'Class Section',
                                                  controller:
                                                  classSectionController,
                                                  onPressed:
                                                      () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      await classSection
                                                          .insertCLassesSection(
                                                          context:
                                                          context,
                                                          sectionName: classSectionController
                                                              .text
                                                              .toString(),
                                                          classid:
                                                          modelClassEducation
                                                              .id);

                                                      Provider.of<
                                                          ShowInsertingTableRowTOServer>(
                                                          context,
                                                          listen: false)
                                                          .insertingRow();
                                                    }
                                                    classSectionController
                                                        .clear();
                                                  },
                                                  context:
                                                  context),
                                            ),
                                          );
                                        });

                                    setState(() {});
                                  }
                                } else
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Admin') {
                                  classSectionController
                                      .clear();
                                  await showGeneralDialog(
                                      context: context,
                                      pageBuilder: (BuildContext
                                      context,
                                          animation,
                                          secondaryAnimation) {
                                        return Align(
                                          alignment:
                                          Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: CustomDialogForClassSection
                                                .customClassSectionDialog(
                                                OpenForEditOrSave: 'Save',
                                                onPressedClose: () async {
                                                  Provider.of<
                                                      ShowInsertingTableRowTOServer>(
                                                      context, listen: false)
                                                      .resetRow();
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                title:
                                                'Class Section',
                                                controller:
                                                classSectionController,
                                                onPressed:
                                                    () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    await classSection
                                                        .insertCLassesSection(
                                                        context:
                                                        context,
                                                        sectionName: classSectionController
                                                            .text
                                                            .toString(),
                                                        classid:
                                                        modelClassEducation.id);

                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .insertingRow();
                                                  }
                                                  classSectionController
                                                      .clear();
                                                },
                                                context:
                                                context),
                                          ),
                                        );
                                      });

                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all()
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(Icons.add, color: Colors.green,
                                      size: fontSize,),
                                    Text('ADD section'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          double monthlyFee = 0.0;
                          checkValue = false;
                          feeAmountController.clear();
                          feeNarrationController.clear();
                          int feeDueID =
                          await studentFeeDue
                              .maxIdForStudentFeeDue();

                          List listData = await _schoolSQL
                              .dataForBulkFeeAllStudentYear(
                              iD: modelClassEducation.id.toString(),
                              whereCon: 'Sch4ClassesSection.ClassID');


                          for (int i = 0;
                          i < listData
                              .length;
                          i++) {
                            monthlyFee += listData[i]['MonthlyFee'];
                          }

                          showGeneralDialog(
                              context: mainBuildContext,
                              pageBuilder: (BuildContext contextDueFee,
                                  animation, secondaryAnimation) {
                                dueOnDateController.text =
                                    currentDate.toString().substring(0, 10);
                                return SafeArea(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery
                                                .of(contextDueFee)
                                                .viewInsets
                                                .bottom),
                                        duration: const Duration(
                                            milliseconds: 300),
                                        child: bulkFeeAllStudentYear(
                                            dialogTitle: 'Due Fee On Section',
                                            stateName: modelClassEducation
                                                .getName(),
                                            maxID: feeDueID,
                                            dueOnDate: dueOnDateController,
                                            feeNarration:
                                            feeNarrationController,
                                            feeAmount: feeAmountController,
                                            onPressed: () async {
                                              Provider.of<
                                                  ShowInsertingTableRowTOServer>(
                                                  context, listen: false)
                                                  .totalNumberOfTableRow(
                                                  totalNumberOfRow: listData
                                                      .length.toInt());
                                              if (formKey.currentState!
                                                  .validate()) {
                                                showDialog(
                                                    context: contextDueFee,
                                                    builder: (context) {
                                                      return AlertDialog(

                                                        title: Text(
                                                            'Confirmation'),
                                                        content: Text(
                                                            'Total Student : ${listData
                                                                .length}  \n Total Due Fee : ${feeAmountController
                                                                .text
                                                                .toString()
                                                                .length == 0
                                                                ? monthlyFee
                                                                : (int.parse(
                                                                feeAmountController
                                                                    .text
                                                                    .toString()) *
                                                                listData
                                                                    .length)}'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () async {
                                                                Constants
                                                                    .onLoading(
                                                                    context,
                                                                    'Due Fee Processing');
                                                                for (int i = 0;
                                                                i < listData
                                                                    .length;
                                                                i++) {
                                                                  if (i > 0) {
                                                                    feeDueID +=
                                                                    -1;
                                                                  }
                                                                  Provider.of<
                                                                      ShowInsertingTableRowTOServer>(
                                                                      context,
                                                                      listen: false)
                                                                      .insertingRow();
                                                                  await studentFeeDue
                                                                      .insertStudentFeeDue(
                                                                      feeDueId: feeDueID,

                                                                      feeNarration:
                                                                      feeNarrationController
                                                                          .text
                                                                          .toString(),
                                                                      feeDueAmount: feeAmountController
                                                                          .text
                                                                          .toString()
                                                                          .length >
                                                                          0
                                                                          ? double
                                                                          .parse(
                                                                          feeAmountController
                                                                              .text
                                                                              .toString())
                                                                          : listData[i]['MonthlyFee'] ==
                                                                          null
                                                                          ? 0.0
                                                                          : double
                                                                          .parse(
                                                                          listData[i]['MonthlyFee']
                                                                              .toString()),
                                                                      dueDate:
                                                                      dueOnDateController
                                                                          .text
                                                                          .toString(),
                                                                      sectionStudentID: listData[i]
                                                                      ['SectionStudenID'],
                                                                      grn: listData[i]
                                                                      ['GRN']);
                                                                }
                                                                feeNarrationController
                                                                    .clear();
                                                                feeAmountController
                                                                    .clear();
                                                                dueOnDateController
                                                                    .clear();

                                                                Provider.of<
                                                                    ShowInsertingTableRowTOServer>(
                                                                    context,
                                                                    listen: false)
                                                                    .resetRow();
                                                                Provider.of<
                                                                    ShowInsertingTableRowTOServer>(
                                                                    context,
                                                                    listen: false)
                                                                    .resetTotalNumber();

                                                                Constants
                                                                    .hideDialog(
                                                                    context);

                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    contextDueFee);
                                                              }, child: Text(
                                                              'Confirm')),
                                                        ],
                                                      );
                                                    });
                                              }
                                            },
                                            context: contextDueFee),
                                      )),
                                );
                              });

                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.replay_30_rounded,
                                color: Colors.blue.shade900, size: fontSize,),
                              Text('Due Fee'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List list = await _feeCollectionSQL
                              .dataForAllStudentForNEWBYGRNANDFamilyGroupNo(
                              modelClassEducation.id.toString(),
                              'Sch3Classes.ClassID');

                          Navigator.push(mainBuildContext,
                              MaterialPageRoute(builder: (context) =>
                                  FeeCollection(menuName: widget.menuName,
                                      list: list,
                                      status: 'RecBulk'),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, color: Colors.grey,
                                size: fontSize,),
                              Text('Fee Rec'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForAllStudentByID(
                              modelClassEducation.id.toString(),
                              'Sch3Classes.ClassID');


                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                StudentTotalBalance(
                                    listOFAllStudent: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(

                            children: [
                              Icon(Icons.contact_page_outlined,
                                color: Colors.yellow.shade900, size: fontSize,),
                              Text('Student Balance'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForDueFeeDetails(
                              modelClassEducation.id.toString(),
                              'Sch3Classes.ClassID');

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                DueFeeDetails(
                                    list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restore_page_outlined,
                                color: Colors.brown,
                                size: fontSize,),
                              Text('Due Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForFeeRECCompleteDetailsByID(
                              modelClassEducation.id.toString(),
                              'Sch3Classes.ClassID');

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                FeeDetailsComplete(
                                    titleName: modelClassEducation.getName(),
                                    list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.request_page_outlined, color: Colors.red,
                                size: fontSize,),
                              Text('Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        FutureBuilder(
          future: _schoolSQL.checkNewAllFeeDueForDeletion(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(content: Text(
                          'Do You Really Want TO delete New FeeDue Records'),
                        actions: [
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: Text('Cancel')),
                          TextButton(onPressed: () async {
                            await _schoolSQL.deleteNewAllFeeDue();
                            await _schoolSQL.deleteNewAllFeeREC1();
                            await _schoolSQL.deleteNewAllFeeREC2();

                            Navigator.pop(context);
                            setState(() {});
                          }, child: Text('delete'))
                        ],
                      );
                    },);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all()
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.delete,
                          color: Colors.red, size: 35,),
                        Text('Delete all new feeDue'),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    )
        : 'SectionStudent' == modelShowYearListView.getStatus()
        ? ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Align(alignment: Alignment.centerLeft, child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text('(${modelShowYearListView.getStudentQTY()})',
                    style: TextStyle(
                        fontSize: 14, color: Colors.lightBlueAccent),),
                ),
                Text('Students',
                  style: TextStyle(
                      fontSize: 20, color: Colors.lightBlueAccent),),
              ],
            ),
          ),
        )),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: studentSearch,
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

        FutureBuilder(
          future:
          _schoolSQL.dataForSch1ClassSectionStudent(
              sectionID: modelShowSectionListView.id
                  .toString()),
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return filterListStudent.length == 0 &&
                  studentSearch.text
                      .toString()
                      .isNotEmpty ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('No Data Found')),
              )
                  : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: filterListStudent.isEmpty
                    ? snapshot.data!.length
                    : filterListStudent.length,
                itemBuilder: (context, index) {
                  List sortedList = [];
                  sortedList = List.from(snapshot.data!);
                  sortedList.sort((a, b) => a["GRN"].compareTo(b["GRN"]));
                  sortedList.sort((a, b) {
                    if (_isNumeric(a["GRN"]) && _isNumeric(b["GRN"])) {
                      return int.parse(a["GRN"]).compareTo(int.parse(
                          b["GRN"])); // Sort numbers in ascending order
                    } else if (_isNumeric(a["GRN"])) {
                      return -1; // Place numbers before alphabets
                    } else if (_isNumeric(b["GRN"])) {
                      return 1; // Place alphabets after numbers
                    } else {
                      if (a["GRN"].toLowerCase() == b["GRN"].toLowerCase()) {
                        return a["GRN"].compareTo(
                            b["GRN"]); // Sort alphabets in case-insensitive ascending order
                      } else {
                        if (a["GRN"].toLowerCase().contains(
                            b["GRN"].toLowerCase())) {
                          return -1; // Place a before b if a contains b
                        } else if (b["GRN"].toLowerCase().contains(
                            a["GRN"].toLowerCase())) {
                          return 1; // Place b before a if b contains a
                        } else {
                          return a["GRN"].compareTo(
                              b["GRN"]); // Sort alphabets in case-insensitive ascending order
                        }
                      }
                    }
                  });


                  wholeListOFStudent = snapshot.data!;
                  Map map = filterListStudent.isEmpty
                      ? sortedList[index]
                      : filterListStudent[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        modelsectionStudent.setName(
                            '${map['GRN']
                                .toString()}  ${map['StudentName']
                                .toString()}'
                        );
                        modelShowYearListView
                            .setStatus(
                            'StudentFeeDue');
                        grnOfStudent = map['GRN'].toString();


                        modelsectionStudent.setID(
                            map['SectionStudenID']);

                        modelsectionStudent
                            .opacity = 1.0;
                      });
                    },
                    child: customListView(
                      studentQuantity: '',
                      statusRecord: map['SectionStudenID'] == null
                          ? Text('')
                          : map['SectionStudenID'] < 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'New',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : map['SectionStudenID'] > 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Modified',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : SizedBox(),
                      backColor: Color(0xFFBBDEFB),
                      borderColor: Colors.lightBlueAccent,
                      name:
                      '${map['GRN']
                          .toString()}  ${map['StudentName'].toString()}',
                      totalDue: map['TotalDue'] == null ? '0' :
                      map['TotalDue']
                          .toString(),
                      totalReceived: map['TotalReceived'] == null ? '0' :
                      map['TotalReceived']
                          .toString(),
                      totalBalance: map['TotalBalance'] == null ? '0' :
                      map['TotalBalance']
                          .toString(),
                      onSelected: (int value) async {
                        if (value == 0) {
                          Provider.of<StudentImageManagement>(
                              context, listen: false)
                              .resetImage();
                          Provider.of<StudentImageManagement>(
                              context, listen: false)
                              .resetImageBase64();
                          Provider.of<StudentImageManagement>(
                              context, listen: false)
                              .resetImageURL();


                          if (map['SectionStudenID'] < 0) {
                            Directory? appDocDir =
                            await getExternalStorageDirectory();


                            if (map['SectionStudenID'] < 0) {
                              print(
                                  'pick  updated image to local location .......................................');
                              String path =
                                  '${appDocDir!
                                  .path}/ClientImages/${SharedPreferencesKeys
                                  .prefs!.getString(
                                  'CountryName')}/${SharedPreferencesKeys.prefs!
                                  .getInt(SharedPreferencesKeys
                                  .clinetId)}/StudentImage/${map['SectionStudenID']}.jpg';
                              var file = File(path);

                              if (file.existsSync()) {
                                Provider.of<StudentImageManagement>(
                                    context, listen: false)
                                    .setImage(image: file.path);
                              } else {
                                print(
                                    'pick updated to server ................................');

                                var imageURL =
                                    'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys
                                    .prefs!.getString(
                                    'CountryName')}/${SharedPreferencesKeys
                                    .prefs!
                                    .getInt(SharedPreferencesKeys
                                    .clinetId)}/StudentImage/${map['SectionStudenID']}.jpg';

                                print(imageURL);
                                Provider.of<StudentImageManagement>(
                                    context, listen: false)
                                    .setImageURL(imageURL: imageURL);
                              }
                            }

                            sectionStudentController
                                .clear();
                            sectionStudentController
                                .text =
                                map['GRN'].toString()
                                    .trim();
                            sectionMonthlyFeeController.text =
                                map['MonthlyFee'].toString()
                                    .trim();
                            await showGeneralDialog(
                                context: context,
                                pageBuilder: (BuildContext
                                context,
                                    animation,
                                    secondaryAnimation) {
                                  return Align(
                                    alignment: Alignment
                                        .center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery
                                              .of(context)
                                              .viewInsets
                                              .bottom),
                                      child: CustomDialogForSectionStudent
                                          .customSectionStudentDialog(
                                          onPressedClose: () async {
                                            Provider.of<
                                                ShowInsertingTableRowTOServer>(
                                                context, listen: false)
                                                .resetRow();
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          onPickImage: () async {
                                            image =
                                            await imageUploadingToServer(
                                                mainContext: context,
                                                status: 'Profile');

                                            imageBase64 =
                                                base64Encode(
                                                    image!.readAsBytesSync());

                                            Provider.of<StudentImageManagement>(
                                                context, listen: false)
                                                .setImage(image: image!.path);

                                            Provider.of<StudentImageManagement>(
                                                context, listen: false)
                                                .setImageBase64(
                                                imageBase64: imageBase64!);
                                            //  setState(() {});
                                          },
                                          titleHeight: 'Height',
                                          titleWeight: 'Weight',
                                          sectionStudentID: map['SectionStudenID'],
                                          status: 'UPDATE',
                                          pathOfDir: appDocDir!.path,
                                          sectionID: modelShowSectionListView
                                              .id,
                                          controllerHeight: studentHeight,
                                          id: map['ID'],
                                          controllerWeight: studentWeight,
                                          GRNTitle:
                                          'GRN',
                                          controllerMonthlyFee: sectionMonthlyFeeController,
                                          titleMonthlyFee: 'monthly Fee',
                                          grnController:
                                          sectionStudentController,
                                          context:
                                          context),
                                    ),
                                  );
                                });
                            setState(() {});
                          } else {
                            List userRightList = await _salePurSQLDataBase
                                .userRightsChecking(widget.menuName);
                            if (SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.userRightsClient) ==
                                'Custom Right') {
                              if (userRightList[0]['Editing']
                                  .toString()
                                  == 'true') {
                                Directory? appDocDir =
                                await getExternalStorageDirectory();

                                if (map['SectionStudenID'] < 0) {
                                  print(
                                      'pick  updated image to local location .......................................');
                                  String path =
                                      '${appDocDir!
                                      .path}/ClientImages/${SharedPreferencesKeys
                                      .prefs!.getString(
                                      'CountryName')}/${SharedPreferencesKeys
                                      .prefs!.getInt(SharedPreferencesKeys
                                      .clinetId)}/StudentImage/${map['SectionStudenID']}.jpg';
                                  var file = File(path);

                                  if (file.existsSync()) {
                                    Provider.of<StudentImageManagement>(
                                        context, listen: false)
                                        .setImage(image: file.path);
                                  } else {
                                    print(
                                        'pick updated to server ................................');

                                    var imageURL =
                                        'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys
                                        .prefs!.getString(
                                        'CountryName')}/${SharedPreferencesKeys
                                        .prefs!.getInt(SharedPreferencesKeys
                                        .clinetId)}/StudentImage/${map['SectionStudenID']}.jpg';
                                    Provider.of<StudentImageManagement>(
                                        context, listen: false)
                                        .setImageURL(imageURL: imageURL);
                                  }
                                }

                                sectionStudentController
                                    .clear();
                                sectionStudentController
                                    .text =
                                    map['GRN'].toString()
                                        .trim();
                                sectionMonthlyFeeController.text =
                                    map['MonthlyFee'].toString()
                                        .trim();
                                await showGeneralDialog(
                                    context: context,
                                    pageBuilder: (BuildContext
                                    context,
                                        animation,
                                        secondaryAnimation) {
                                      return Align(
                                        alignment: Alignment
                                            .center,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery
                                                  .of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: CustomDialogForSectionStudent
                                              .customSectionStudentDialog(
                                              onPressedClose: () async {
                                                Provider.of<
                                                    ShowInsertingTableRowTOServer>(
                                                    context, listen: false)
                                                    .resetRow();
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              titleHeight: 'Height',
                                              titleWeight: 'Weight',
                                              sectionStudentID: map['SectionStudenID'],
                                              status: 'UPDATE',
                                              onPickImage: () async {
                                                image =
                                                await imageUploadingToServer(
                                                    mainContext: context,
                                                    status: 'Profile');

                                                imageBase64 =
                                                    base64Encode(
                                                        image!
                                                            .readAsBytesSync());

                                                Provider.of<
                                                    StudentImageManagement>(
                                                    context, listen: false)
                                                    .setImage(
                                                    image: image!.path);

                                                Provider.of<
                                                    StudentImageManagement>(
                                                    context, listen: false)
                                                    .setImageBase64(
                                                    imageBase64: imageBase64!);
                                                //  setState(() {});
                                              },
                                              pathOfDir: appDocDir!.path,
                                              sectionID: modelShowSectionListView
                                                  .id,
                                              controllerHeight: studentHeight,
                                              id: map['ID'],
                                              controllerWeight: studentWeight,
                                              GRNTitle:
                                              'GRN',
                                              controllerMonthlyFee: sectionMonthlyFeeController,
                                              titleMonthlyFee: 'monthly Fee',
                                              grnController:
                                              sectionStudentController,
                                              context:
                                              context),
                                        ),
                                      );
                                    });
                                setState(() {});
                              }
                            } else if (SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.userRightsClient) ==
                                'Admin') {
                              Directory? appDocDir =
                              await getExternalStorageDirectory();

                              if (map['SectionStudenID'] < 0) {
                                print(
                                    'pick  updated image to local location .......................................');
                                String path =
                                    '${appDocDir!
                                    .path}/ClientImages/${SharedPreferencesKeys
                                    .prefs!.getString(
                                    'CountryName')}/${SharedPreferencesKeys
                                    .prefs!
                                    .getInt(SharedPreferencesKeys
                                    .clinetId)}/StudentImage/${map['SectionStudenID']}.jpg';
                                var file = File(path);

                                if (file.existsSync()) {
                                  Provider.of<StudentImageManagement>(
                                      context, listen: false)
                                      .setImage(image: file.path);
                                }
                              } else {
                                var imageURL =
                                    'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys
                                    .prefs!.getString(
                                    'CountryName')}/${SharedPreferencesKeys
                                    .prefs!
                                    .getInt(SharedPreferencesKeys
                                    .clinetId)}/StudentImage/${map['SectionStudenID']}.jpg';

                                print(
                                    'pick updated to server ..........rer3r3r3.........$imageURL.............');
                                Provider.of<StudentImageManagement>(
                                    context, listen: false)
                                    .setImageURL(imageURL: imageURL);
                              }

                              sectionStudentController
                                  .clear();
                              sectionStudentController
                                  .text =
                                  map['GRN'].toString()
                                      .trim();
                              sectionMonthlyFeeController.text =
                                  map['MonthlyFee'].toString()
                                      .trim();
                              await showGeneralDialog(
                                  context: context,
                                  pageBuilder: (BuildContext
                                  context,
                                      animation,
                                      secondaryAnimation) {
                                    return Align(
                                      alignment: Alignment
                                          .center,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery
                                                .of(context)
                                                .viewInsets
                                                .bottom),
                                        child: CustomDialogForSectionStudent
                                            .customSectionStudentDialog(
                                            onPressedClose: () async {
                                              Provider.of<
                                                  ShowInsertingTableRowTOServer>(
                                                  context, listen: false)
                                                  .resetRow();


                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            titleHeight: 'Height',
                                            onPickImage: () async {
                                              image =
                                              await imageUploadingToServer(
                                                  mainContext: context,
                                                  status: 'Profile');

                                              imageBase64 =
                                                  base64Encode(
                                                      image!.readAsBytesSync());

                                              Provider.of<
                                                  StudentImageManagement>(
                                                  context, listen: false)
                                                  .setImage(image: image!.path);

                                              Provider.of<
                                                  StudentImageManagement>(
                                                  context, listen: false)
                                                  .setImageBase64(
                                                  imageBase64: imageBase64!);

                                              Provider.of<
                                                  StudentImageManagement>(
                                                  context, listen: false)
                                                  .resetImageURL();
                                              //  setState(() {});
                                            },
                                            titleWeight: 'Weight',
                                            sectionStudentID: map['SectionStudenID'],
                                            status: 'UPDATE',
                                            pathOfDir: appDocDir!.path,
                                            sectionID: modelShowSectionListView
                                                .id,
                                            controllerHeight: studentHeight,
                                            id: map['ID'],
                                            controllerWeight: studentWeight,
                                            GRNTitle:
                                            'GRN',
                                            controllerMonthlyFee: sectionMonthlyFeeController,
                                            titleMonthlyFee: 'monthly Fee',
                                            grnController:
                                            sectionStudentController,
                                            context:
                                            context),
                                      ),
                                    );
                                  });
                              setState(() {});
                            }
                          }
                        }
                        if (value == 1) {
                          List studentLedgerList = await _schoolSQL
                              .dataForAllStudentLedgerFeeDue(map['GRN']
                              .toString());

                          Navigator.push(mainBuildContext, MaterialPageRoute(
                            builder: (context) =>
                                StudentLedger(list: studentLedgerList,),));
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FutureBuilder(
                        future:
                        _salePurSQLDataBase.userRightsChecking(widget.menuName),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: () async {
                                Provider.of<StudentImageManagement>(
                                    context, listen: false)
                                    .resetImage();
                                Provider.of<StudentImageManagement>(
                                    context, listen: false)
                                    .resetImageBase64();
                                Provider.of<StudentImageManagement>(
                                    context, listen: false)
                                    .resetImageURL();
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Custom Right') {
                                  if (snapshot.data![0]['Inserting']
                                      .toString()
                                      == 'true') {
                                    studentWeight.clear();
                                    studentHeight.clear();
                                    sectionStudentController
                                        .clear();
                                    sectionMonthlyFeeController.clear();
                                    await showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext
                                        context,
                                            animation,
                                            secondaryAnimation) {
                                          return Align(
                                            alignment:
                                            Alignment
                                                .center,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery
                                                      .of(context)
                                                      .viewInsets
                                                      .bottom),

                                              child: CustomDialogForSectionStudent
                                                  .customSectionStudentDialog(
                                                  onPressedClose: () async {
                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .resetRow();
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  onPickImage: () async {
                                                    image =
                                                    await imageUploadingToServer(
                                                        mainContext: context,
                                                        status: 'Profile');

                                                    imageBase64 =
                                                        base64Encode(image!
                                                            .readAsBytesSync());

                                                    Provider.of<
                                                        StudentImageManagement>(
                                                        context, listen: false)
                                                        .setImage(
                                                        image: image!.path);

                                                    Provider.of<
                                                        StudentImageManagement>(
                                                        context, listen: false)
                                                        .setImageBase64(
                                                        imageBase64: imageBase64!);
                                                  },
                                                  titleHeight: 'Height',
                                                  titleWeight: 'Weight',
                                                  status: 'SAVE',
                                                  controllerHeight: studentHeight,
                                                  controllerWeight: studentWeight,
                                                  sectionID: modelShowSectionListView
                                                      .id,
                                                  GRNTitle:
                                                  'GRN',
                                                  titleMonthlyFee: 'Monthly Fee',
                                                  controllerMonthlyFee: sectionMonthlyFeeController,
                                                  grnController:
                                                  sectionStudentController,
                                                  context:
                                                  context),
                                            ),
                                          );
                                        });

                                    setState(() {});
                                  }
                                } else if
                                (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Admin') {
                                  studentWeight.clear();
                                  studentHeight.clear();
                                  sectionStudentController
                                      .clear();
                                  sectionMonthlyFeeController.clear();
                                  await showGeneralDialog(
                                      context: context,
                                      pageBuilder: (BuildContext
                                      context,
                                          animation,
                                          secondaryAnimation) {
                                        return Align(
                                          alignment:
                                          Alignment
                                              .center,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: CustomDialogForSectionStudent
                                                .customSectionStudentDialog(
                                                onPressedClose: () async {
                                                  Provider.of<
                                                      ShowInsertingTableRowTOServer>(
                                                      context, listen: false)
                                                      .resetRow();
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                onPickImage: () async {
                                                  image =
                                                  await imageUploadingToServer(
                                                      mainContext: context,
                                                      status: 'Profile');

                                                  imageBase64 =
                                                      base64Encode(image!
                                                          .readAsBytesSync());

                                                  Provider.of<
                                                      StudentImageManagement>(
                                                      context, listen: false)
                                                      .setImage(
                                                      image: image!.path);

                                                  Provider.of<
                                                      StudentImageManagement>(
                                                      context, listen: false)
                                                      .setImageBase64(
                                                      imageBase64: imageBase64!);
                                                },
                                                titleHeight: 'Height',
                                                titleWeight: 'Weight',
                                                status: 'SAVE',
                                                controllerHeight: studentHeight,
                                                controllerWeight: studentWeight,
                                                sectionID: modelShowSectionListView
                                                    .id,
                                                GRNTitle:
                                                'GRN',
                                                titleMonthlyFee: 'Monthly Fee',
                                                controllerMonthlyFee: sectionMonthlyFeeController,
                                                grnController:
                                                sectionStudentController,
                                                context:
                                                context),
                                          ),
                                        );
                                      });

                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all()
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(Icons.add, color: Colors.green,
                                      size: fontSize,),
                                    Text('ADD student'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),

                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          double monthlyFee = 0.0;
                          checkValue = false;
                          feeAmountController.clear();
                          feeNarrationController.clear();

                          int feeDueID =
                          await studentFeeDue
                              .maxIdForStudentFeeDue();
                          List listData = await _schoolSQL
                              .dataForBulkFeeAllStudentYear(
                              whereCon: 'Sch5SectionStudent.SectionID',
                              iD:
                              modelShowSectionListView.id.toString());

                          for (int i = 0;
                          i < listData
                              .length;
                          i++) {
                            monthlyFee += listData[i]['MonthlyFee'];
                          }

                          showGeneralDialog(
                              context: mainBuildContext,
                              pageBuilder: (BuildContext contextDueFee,
                                  animation, secondaryAnimation) {
                                dueOnDateController.text =
                                    currentDate.toString().substring(0, 10);
                                return SafeArea(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery
                                                .of(contextDueFee)
                                                .viewInsets
                                                .bottom),
                                        duration: const Duration(
                                            milliseconds: 300),
                                        child: bulkFeeAllStudentYear(
                                            dialogTitle: 'Due Fee On All Student of Section',
                                            stateName: modelShowSectionListView
                                                .getName(),
                                            maxID: feeDueID,
                                            dueOnDate: dueOnDateController,
                                            feeNarration:
                                            feeNarrationController,
                                            feeAmount: feeAmountController,
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                showDialog(
                                                    context: contextDueFee,
                                                    builder: (context) {
                                                      return AlertDialog(

                                                        title: Text(
                                                            'Confirmation'),
                                                        content: Text(
                                                            'Total Student : ${listData
                                                                .length}  \n Total Due Fee : ${feeAmountController
                                                                .text
                                                                .toString()
                                                                .length == 0
                                                                ? monthlyFee
                                                                : (int.parse(
                                                                feeAmountController
                                                                    .text
                                                                    .toString()) *
                                                                listData
                                                                    .length)}'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () async {
                                                                Provider.of<
                                                                    ShowInsertingTableRowTOServer>(
                                                                    context,
                                                                    listen: false)
                                                                    .totalNumberOfTableRow(
                                                                    totalNumberOfRow: listData
                                                                        .length
                                                                        .toInt());
                                                                Constants
                                                                    .onLoading(
                                                                    context,
                                                                    'Due Fee Processing');
                                                                for (int i = 0;
                                                                i < listData
                                                                    .length;
                                                                i++) {
                                                                  if (i > 0) {
                                                                    feeDueID +=
                                                                    -1;
                                                                  }
                                                                  Provider.of<
                                                                      ShowInsertingTableRowTOServer>(
                                                                      context,
                                                                      listen: false)
                                                                      .insertingRow();
                                                                  await studentFeeDue
                                                                      .insertStudentFeeDue(
                                                                      feeDueId: feeDueID,

                                                                      feeNarration:
                                                                      feeNarrationController
                                                                          .text
                                                                          .toString(),
                                                                      feeDueAmount: feeAmountController
                                                                          .text
                                                                          .toString()
                                                                          .length >
                                                                          0
                                                                          ? double
                                                                          .parse(
                                                                          feeAmountController
                                                                              .text
                                                                              .toString())
                                                                          : listData[i]['MonthlyFee'] ==
                                                                          null
                                                                          ? 0.0
                                                                          : double
                                                                          .parse(
                                                                          listData[i]['MonthlyFee']
                                                                              .toString()),
                                                                      dueDate:
                                                                      dueOnDateController
                                                                          .text
                                                                          .toString(),
                                                                      sectionStudentID: listData[i]
                                                                      ['SectionStudenID'],
                                                                      grn: listData[i]
                                                                      ['GRN']);
                                                                }


                                                                feeNarrationController
                                                                    .clear();
                                                                feeAmountController
                                                                    .clear();
                                                                dueOnDateController
                                                                    .clear();

                                                                Provider.of<
                                                                    ShowInsertingTableRowTOServer>(
                                                                    context,
                                                                    listen: false)
                                                                    .resetRow();
                                                                Provider.of<
                                                                    ShowInsertingTableRowTOServer>(
                                                                    context,
                                                                    listen: false)
                                                                    .resetTotalNumber();

                                                                Constants
                                                                    .hideDialog(
                                                                    context);
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    contextDueFee);
                                                              }, child: Text(
                                                              'Confirm')),
                                                        ],
                                                      );
                                                    });
                                              }
                                            },
                                            context: contextDueFee),
                                      )),
                                );
                              });

                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.replay_30_rounded,
                                color: Colors.blue.shade900, size: fontSize,),
                              Text('Due Fee'),
                            ],
                          ),
                        ),
                      ),
                    ),


                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List list = await _feeCollectionSQL
                              .dataForAllStudentForNEWBYGRNANDFamilyGroupNo(
                              modelShowSectionListView.id.toString(),
                              'Sch4ClassesSection.SectionID');

                          print(list);
                          Navigator.push(mainBuildContext,
                              MaterialPageRoute(builder: (context) =>
                                  FeeCollection(menuName: widget.menuName,
                                      list: list,
                                      status: 'RecBulk'),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, color: Colors.grey,
                                size: fontSize,),
                              Text('Fee Rec'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForAllStudentByID(
                              modelShowSectionListView.id.toString(),
                              'Sch4ClassesSection.SectionID');


                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                              StudentTotalBalance(
                                  listOFAllStudent: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(

                            children: [
                              Icon(Icons.contact_page_outlined,
                                color: Colors.yellow.shade900, size: fontSize,),
                              Text('Student Balance'),
                            ],
                          ),
                        ),
                      ),
                    ),


                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForDueFeeDetails(
                              modelShowSectionListView.id.toString(),
                              'Sch4ClassesSection.SectionID');

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                DueFeeDetails(
                                    list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restore_page_outlined,
                                color: Colors.brown,
                                size: fontSize,),
                              Text('Due Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForFeeRECCompleteDetailsByID(
                              modelShowSectionListView.id.toString(),
                              'Sch4ClassesSection.SectionID');


                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                FeeDetailsComplete(
                                    titleName: modelShowSectionListView
                                        .getName(), list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.request_page_outlined, color: Colors.red,
                                size: fontSize,),
                              Text('Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        FutureBuilder(
          future: _schoolSQL.checkNewAllFeeDueForDeletion(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(content: Text(
                          'Do You Really Want TO delete New FeeDue Records'),
                        actions: [
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: Text('Cancel')),
                          TextButton(onPressed: () async {
                            await _schoolSQL.deleteNewAllFeeDue();
                            await _schoolSQL.deleteNewAllFeeREC1();
                            await _schoolSQL.deleteNewAllFeeREC2();

                            Navigator.pop(context);
                            setState(() {});
                          }, child: Text('delete'))
                        ],
                      );
                    },);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all()
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.delete,
                          color: Colors.red, size: 35,),
                        Text('Delete all new feeDue'),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),

      ],
    )
        : "StudentFeeDue" ==
        modelShowYearListView.getStatus()
        ? ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Align(alignment: Alignment.centerLeft, child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Due Fee of a Student',
            style: TextStyle(fontSize: 20, color: Colors.redAccent),),
        )),
        FutureBuilder(
          future: _schoolSQL.dataForSch1StudentFeeDue(
              sectionStudentID:
              modelsectionStudent.id.toString()),
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  List sortedList = [];
                  sortedList = List.from(snapshot.data!);
                  final dateFormat = DateFormat("yyyy-MM-dd");

                  sortedList.sort((a, b) {
                    return a["DueDate"] != null ? dateFormat.parse(a["DueDate"])
                        .compareTo(dateFormat.parse(b["DueDate"])) : 0;
                  });

                  Map map = {};
                  if (index < snapshot.data!.length) {
                    map = sortedList[index];
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        modelFeeDueList.setName(
                          map['FeeNarration']
                              .toString(),
                        );
                        modelShowYearListView
                            .setStatus(
                            'FeeRec2');
                        modelFeeDueList.setID(
                            map['FeeDueID']);
                        modelFeeDueList
                            .opacity = 1.0;
                      });
                    },
                    child: customListView(
                      studentQuantity: '',
                      statusRecord: map['FeeDueID'] == null
                          ? Text('')
                          : map['FeeDueID'] < 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'New',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : map['FeeDueID'] > 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Modified',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : SizedBox(),

                      backColor: Colors.pink.shade50,
                      borderColor: Colors.redAccent.shade700,
                      name: map['DueDate'] == null ? '' :
                      '${DateFormat(SharedPreferencesKeys.prefs!.getString(
                          SharedPreferencesKeys.dateFormat))
                          .format(DateTime(int.parse(
                          map['DueDate'].toString().substring(0, 4)),
                          int.parse(map['DueDate'].substring(
                            5,
                            7,
                          )), int.parse(map['DueDate'].substring(8, 10))))
                          .toString()} , ${map['FeeNarration']
                          .toString()}',
                      totalDue: map['FeeDueAmount'] == null ? '0' :
                      map['FeeDueAmount']
                          .toString(),
                      totalReceived: map['TotalReceived'] == null ? '0' :
                      map['TotalReceived']
                          .toString(),
                      totalBalance: map['TotalBalance'] == null ? '0' :
                      map['TotalBalance']
                          .toString(),
                      onSelected: (int value) async {
                        int feeRecID = await studentFeeRec.maxIDForFeeRec();

                        if (value == 0) {
                          if (map['FeeDueID'] < 0) {
                            await showGeneralDialog(
                                context: context,
                                pageBuilder: (BuildContext context,
                                    animation, secondaryAnimation) {
                                  dueOnDateController.text =
                                  '${DateFormat(
                                      SharedPreferencesKeys.prefs!.getString(
                                          SharedPreferencesKeys.dateFormat))
                                      .format(DateTime(int.parse(
                                      map['DueDate'].toString().substring(
                                          0, 4)),
                                      int.parse(map['DueDate'].substring(
                                        5,
                                        7,
                                      )), int.parse(
                                          map['DueDate'].substring(8, 10))))
                                      .toString()}';
                                  feeNarrationController.text =
                                      map['FeeNarration'].toString();
                                  feeAmountController.text =
                                      map['FeeDueAmount'].toString();
                                  checkValue = true;
                                  return Align(
                                      alignment: Alignment.center,
                                      child: AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery
                                                .of(context)
                                                .viewInsets
                                                .bottom),
                                        duration: const Duration(
                                            milliseconds: 300),
                                        child: bulkFeeAllStudentYear(
                                            OpenForEditOrSave: 'Edit',
                                            dialogTitle: 'Due Fee on Student Edit',
                                            maxID: map['FeeDueID'],
                                            stateName: modelsectionStudent
                                                .getName(),
                                            dueOnDate: dueOnDateController,
                                            feeNarration:
                                            feeNarrationController,
                                            feeAmount: feeAmountController,
                                            onPressed: () async {
                                              await studentFeeDue
                                                  .updateStudentFeeDue(
                                                  GRN: map['GRN'],
                                                  DueDate: currentDate
                                                      .toString()
                                                      .substring(0, 10),
                                                  FeeDueAmount: feeAmountController
                                                      .text
                                                      .toString(),
                                                  FeeNarration: feeNarrationController
                                                      .text.toString(),
                                                  id: map['ID']);
                                              feeNarrationController.clear();
                                              feeAmountController.clear();
                                              dueOnDateController.clear();

                                              setState(() {

                                              });
                                              Navigator.pop(context);
                                            },
                                            context: context),
                                      ));
                                });
                          } else {
                            List userRightList = await _salePurSQLDataBase
                                .userRightsChecking(widget.menuName);
                            if (SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.userRightsClient) ==
                                'Custom Right') {
                              if (userRightList[0]['Editing']
                                  .toString()
                                  == 'true') {
                                await showGeneralDialog(
                                    context: context,
                                    pageBuilder: (BuildContext context,
                                        animation, secondaryAnimation) {
                                      dueOnDateController.text =
                                      '${DateFormat(SharedPreferencesKeys.prefs!
                                          .getString(
                                          SharedPreferencesKeys.dateFormat))
                                          .format(DateTime(int.parse(
                                          map['DueDate'].toString().substring(
                                              0, 4)),
                                          int.parse(map['DueDate'].substring(
                                            5,
                                            7,
                                          )), int.parse(
                                              map['DueDate'].substring(8, 10))))
                                          .toString()}';
                                      feeNarrationController.text =
                                          map['FeeNarration'].toString();
                                      feeAmountController.text =
                                          map['FeeDueAmount'].toString();
                                      checkValue = true;
                                      return Align(
                                          alignment: Alignment.center,
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .viewInsets
                                                    .bottom),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: bulkFeeAllStudentYear(
                                                OpenForEditOrSave: 'Edit',
                                                dialogTitle: 'Due Fee on Student Edit',
                                                maxID: map['FeeDueID'],
                                                stateName: modelsectionStudent
                                                    .getName(),
                                                dueOnDate: dueOnDateController,
                                                feeNarration:
                                                feeNarrationController,
                                                feeAmount: feeAmountController,
                                                onPressed: () async {
                                                  await studentFeeDue
                                                      .updateStudentFeeDue(
                                                      GRN: map['GRN'],
                                                      DueDate: currentDate
                                                          .toString()
                                                          .substring(0, 10),
                                                      FeeDueAmount: feeAmountController
                                                          .text
                                                          .toString(),
                                                      FeeNarration: feeNarrationController
                                                          .text.toString(),
                                                      id: map['ID']);
                                                  feeNarrationController
                                                      .clear();
                                                  feeAmountController.clear();
                                                  dueOnDateController.clear();

                                                  setState(() {

                                                  });
                                                  Navigator.pop(context);
                                                },
                                                context: context),
                                          ));
                                    });
                              }
                            } else if (SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.userRightsClient) ==
                                'Admin') {
                              await showGeneralDialog(
                                  context: context,
                                  pageBuilder: (BuildContext context,
                                      animation, secondaryAnimation) {
                                    dueOnDateController.text =
                                    '${DateFormat(
                                        SharedPreferencesKeys.prefs!.getString(
                                            SharedPreferencesKeys.dateFormat))
                                        .format(DateTime(int.parse(
                                        map['DueDate'].toString().substring(
                                            0, 4)),
                                        int.parse(map['DueDate'].substring(
                                          5,
                                          7,
                                        )), int.parse(
                                            map['DueDate'].substring(8, 10))))
                                        .toString()}';
                                    feeNarrationController.text =
                                        map['FeeNarration'].toString();
                                    feeAmountController.text =
                                        map['FeeDueAmount'].toString();
                                    checkValue = true;
                                    return SafeArea(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery
                                                    .of(context)
                                                    .viewInsets
                                                    .bottom),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: bulkFeeAllStudentYear(
                                                OpenForEditOrSave: 'Edit',
                                                dialogTitle: 'Due Fee on Student Edit',
                                                maxID: map['FeeDueID'],
                                                stateName: modelsectionStudent
                                                    .getName(),
                                                dueOnDate: dueOnDateController,
                                                feeNarration:
                                                feeNarrationController,
                                                feeAmount: feeAmountController,
                                                onPressed: () async {
                                                  await studentFeeDue
                                                      .updateStudentFeeDue(
                                                      GRN: map['GRN'],
                                                      DueDate: currentDate
                                                          .toString()
                                                          .substring(0, 10),
                                                      FeeDueAmount: feeAmountController
                                                          .text
                                                          .toString(),
                                                      FeeNarration: feeNarrationController
                                                          .text.toString(),
                                                      id: map['ID']);
                                                  feeNarrationController
                                                      .clear();
                                                  feeAmountController.clear();
                                                  dueOnDateController.clear();

                                                  setState(() {

                                                  });
                                                  Navigator.pop(context);
                                                },
                                                context: context),
                                          )),
                                    );
                                  });
                            }
                          }
                        }
                        if (value == 1) {
                          feeRecAmountController.text =
                              map['TotalBalance'].toString();
                          await showGeneralDialog(
                              context: context,
                              pageBuilder:
                                  (BuildContext
                              context,
                                  animation,
                                  secondaryAnimation) {
                                return StatefulBuilder(
                                  builder: (context, state) =>
                                      Align(
                                        alignment:
                                        Alignment
                                            .center,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery
                                                  .of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: CustomDialogForFeeRec
                                              .customFeeRecDueDialog(
                                            onPressedClose: () async {
                                              Provider.of<
                                                  ShowInsertingTableRowTOServer>(
                                                  context, listen: false)
                                                  .resetRow();

                                              Navigator.pop(context);

                                              setState(() {});
                                            },
                                            maxID: feeRecID.toString(),
                                            onTap: () async {
                                              currentDate = await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return DatePickerStyle1();
                                                  });
                                              state(() {

                                              });
                                            },
                                            remarksController: longLatController,
                                            remarksTitle: 'Remarks',
                                            title:
                                            'Receiving Amount',
                                            controller:
                                            feeRecAmountController,
                                            onPressed:
                                                () async {
                                              int feeRec1ID = await studentFeeRec
                                                  .insertStudentFeeRec(
                                                  feeRecDate: currentDate
                                                      .toString(),
                                                  feeRecRemarks: longLatController
                                                      .text.toString(),

                                                  feeRecAmount: double.parse(
                                                      feeRecAmountController
                                                          .text),
                                                  feeDueID: int.parse(
                                                      map['FeeDueID']
                                                          .toString()));

                                              Provider.of<
                                                  ShowInsertingTableRowTOServer>(
                                                  context, listen: false)
                                                  .insertingRow();

                                              Navigator.pop(context);


                                              await showDialog(
                                                  context:
                                                  context,
                                                  builder:
                                                      (context) {
                                                    return Center(
                                                      child:
                                                      Material(
                                                        child: Container(
                                                          height: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .height *
                                                              .35,
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width *
                                                              .8,
                                                          color: Colors
                                                              .white,
                                                          child:
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                            child:
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            'Rec ID : '),
                                                                        Text(
                                                                          '$feeRec1ID',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .grey),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            'Total Rec : '),
                                                                        Text(
                                                                          '${feeRecAmountController
                                                                              .text
                                                                              .toString()}',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .green,
                                                                              fontSize: 25,
                                                                              fontWeight: FontWeight
                                                                                  .bold),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Date :'),
                                                                    Text(
                                                                      '${DateFormat(
                                                                          SharedPreferencesKeys
                                                                              .prefs!
                                                                              .getString(
                                                                              SharedPreferencesKeys
                                                                                  .dateFormat))
                                                                          .format(
                                                                          DateTime(
                                                                              int
                                                                                  .parse(
                                                                                  currentDate
                                                                                      .toString()
                                                                                      .substring(
                                                                                      0,
                                                                                      4)),
                                                                              int
                                                                                  .parse(
                                                                                  currentDate
                                                                                      .toString()
                                                                                      .substring(
                                                                                    5,
                                                                                    7,
                                                                                  )),
                                                                              int
                                                                                  .parse(
                                                                                  currentDate
                                                                                      .toString()
                                                                                      .substring(
                                                                                      8,
                                                                                      10))))
                                                                          .toString()}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Fee Remarks :  '),
                                                                    Text(
                                                                      '${longLatController
                                                                          .text
                                                                          .toString()}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Align(
                                                                  alignment: Alignment
                                                                      .bottomCenter,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .spaceEvenly,
                                                                    children: [
                                                                      ElevatedButton(
                                                                          onPressed: () async {
                                                                            List list = await _feeCollectionSQL
                                                                                .selectPhoneNumberOFStudent(
                                                                                feeRec1ID
                                                                                    .toString());

                                                                            feeRecPrint(context: context, slipInfoOfREc: list);
                                                                          },
                                                                          child: Text(
                                                                              'Print')),
                                                                      //  FatherMobileNo  MotherMobileNo

                                                                      ElevatedButton(
                                                                          onPressed: () async {

                                                                            numberSendToWhatsApp(
                                                                                feeRec1ID
                                                                                    .toString(), context, );
                                                                          },
                                                                          child: Text(
                                                                              'WhatsApp')),
                                                                      ElevatedButton(
                                                                          onPressed: () {
                                                                            Navigator
                                                                                .pop(
                                                                                context);
                                                                          },
                                                                          child: Text(
                                                                              'back')),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });


                                              setState(() {});
                                            },
                                            context:
                                            context,
                                            currentDate: currentDate.toString(),
                                          ),
                                        ),
                                      ),
                                );
                              });
                        }
                        feeRecAmountController.clear();
                        longLatController.clear();
                        setState(() {

                        });
                      },
                    ),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FutureBuilder(
                        future:
                        _salePurSQLDataBase.userRightsChecking(widget.menuName),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: () async {
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Custom Right') {
                                  if (snapshot.data![0]['Inserting']
                                      .toString()
                                      == 'true') {
                                    int feeDueID =
                                    await studentFeeDue
                                        .maxIdForStudentFeeDue();

                                    List listData = await _schoolSQL
                                        .dataForBulkFeeAllStudentYear(
                                        whereCon: 'Sch5SectionStudent.SectionStudenID',
                                        iD:
                                        modelsectionStudent
                                            .id.toString());


                                    showGeneralDialog(
                                        context: mainBuildContext,
                                        pageBuilder: (BuildContext context,
                                            animation, secondaryAnimation) {
                                          dueOnDateController.text =
                                              currentDate.toString().substring(
                                                  0, 10);
                                          return SafeArea(
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: AnimatedContainer(
                                                  padding: EdgeInsets.only(
                                                      bottom: MediaQuery
                                                          .of(context)
                                                          .viewInsets
                                                          .bottom),
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  child: bulkFeeAllStudentYear(
                                                      dialogTitle: 'Due Fee on Student',
                                                      stateName: modelsectionStudent
                                                          .getName(),
                                                      maxID: feeDueID,
                                                      dueOnDate: dueOnDateController,
                                                      feeNarration:
                                                      feeNarrationController,
                                                      feeAmount: feeAmountController,
                                                      onPressed: () async {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          for (int i = 0;
                                                          i < listData.length;
                                                          i++) {
                                                            if (i > 0) {
                                                              feeDueID += -1;
                                                            }
                                                            await studentFeeDue
                                                                .insertStudentFeeDue(
                                                                feeDueId: feeDueID,

                                                                feeNarration:
                                                                feeNarrationController
                                                                    .text
                                                                    .toString(),
                                                                feeDueAmount: feeAmountController
                                                                    .text
                                                                    .isNotEmpty
                                                                    ? double
                                                                    .parse(
                                                                    feeAmountController
                                                                        .text
                                                                        .toString())
                                                                    : listData[i]['MonthlyFee'] ==
                                                                    null
                                                                    ? 0.0
                                                                    : double
                                                                    .parse(
                                                                    listData[i]['MonthlyFee']
                                                                        .toString()),
                                                                dueDate:
                                                                dueOnDateController
                                                                    .text
                                                                    .toString()
                                                                    .substring(
                                                                    0, 10)
                                                                    .toString(),
                                                                sectionStudentID: listData[i]
                                                                ['SectionStudenID'],
                                                                grn: listData[i]
                                                                ['GRN']);
                                                          }
                                                          feeNarrationController
                                                              .clear();
                                                          feeAmountController
                                                              .clear();
                                                          dueOnDateController
                                                              .clear();

                                                          setState(() {});
                                                          // Navigator.pop(
                                                          //     context);
                                                        }
                                                      },
                                                      context: context),
                                                )),
                                          );
                                        });

                                    setState(() {});
                                  }
                                } else
                                if (SharedPreferencesKeys.prefs!.getString(
                                    SharedPreferencesKeys.userRightsClient) ==
                                    'Admin') {
                                  int feeDueID =
                                  await studentFeeDue
                                      .maxIdForStudentFeeDue();

                                  List listData = await _schoolSQL
                                      .dataForBulkFeeAllStudentYear(
                                      whereCon: 'Sch5SectionStudent.SectionStudenID',
                                      iD:
                                      modelsectionStudent
                                          .id.toString());


                                  showGeneralDialog(
                                      context: mainBuildContext,
                                      pageBuilder: (BuildContext context,
                                          animation, secondaryAnimation) {
                                        dueOnDateController.text =
                                            currentDate.toString().substring(
                                                0, 10);
                                        return SafeArea(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: AnimatedContainer(
                                                padding: EdgeInsets.only(
                                                    bottom: MediaQuery
                                                        .of(context)
                                                        .viewInsets
                                                        .bottom),
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                child: bulkFeeAllStudentYear(
                                                    dialogTitle: 'Due Fee on Student',
                                                    stateName: modelsectionStudent
                                                        .getName(),
                                                    maxID: feeDueID,
                                                    dueOnDate: dueOnDateController,
                                                    feeNarration:
                                                    feeNarrationController,
                                                    feeAmount: feeAmountController,
                                                    onPressed: () async {
                                                      if (formKey
                                                          .currentState!
                                                          .validate()) {
                                                        for (int i = 0;
                                                        i < listData.length;
                                                        i++) {
                                                          if (i > 0) {
                                                            feeDueID += -1;
                                                          }


                                                          await studentFeeDue
                                                              .insertStudentFeeDue(
                                                              feeDueId: feeDueID,

                                                              feeNarration:
                                                              feeNarrationController
                                                                  .text
                                                                  .toString(),
                                                              feeDueAmount: feeAmountController
                                                                  .text
                                                                  .isNotEmpty
                                                                  ? double
                                                                  .parse(
                                                                  feeAmountController
                                                                      .text
                                                                      .toString())
                                                                  : listData[i]['MonthlyFee'] ==
                                                                  null
                                                                  ? 0.0
                                                                  : double
                                                                  .parse(
                                                                  listData[i]['MonthlyFee']
                                                                      .toString()),
                                                              dueDate:
                                                              dueOnDateController
                                                                  .text
                                                                  .toString()
                                                                  .substring(
                                                                  0, 10)
                                                                  .toString(),
                                                              sectionStudentID: listData[i]
                                                              ['SectionStudenID'],
                                                              grn: listData[i]
                                                              ['GRN']);
                                                        }
                                                        feeNarrationController
                                                            .clear();
                                                        feeAmountController
                                                            .clear();
                                                        dueOnDateController
                                                            .clear();

                                                        setState(() {});
                                                        // Navigator.pop(
                                                        //     context);
                                                      }
                                                    },
                                                    context: context),
                                              )),
                                        );
                                      });

                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all()
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(Icons.add, color: Colors.green,
                                      size: fontSize,),
                                    Text('Due Fee'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),

                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          checkValue = false;
                          feeAmountController.clear();
                          int feeDueID =
                          await studentFeeDue
                              .maxIdForStudentFeeDue();
                          List listData = await _schoolSQL
                              .dataForBulkFeeAllStudentYear(
                              whereCon: 'Sch5SectionStudent.SectionStudenID',
                              iD:
                              modelsectionStudent
                                  .id.toString());


                          showGeneralDialog(
                              context: mainBuildContext,
                              pageBuilder: (BuildContext context,
                                  animation, secondaryAnimation) {
                                dueOnDateController.text =
                                    currentDate.toString().substring(0, 10);
                                return SafeArea(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery
                                                .of(context)
                                                .viewInsets
                                                .bottom),
                                        duration: const Duration(
                                            milliseconds: 300),
                                        child: bulkFeeAllStudentYear(
                                            dialogTitle: 'Due Fee on Student',
                                            stateName: modelsectionStudent
                                                .getName(),
                                            maxID: feeDueID,
                                            dueOnDate: dueOnDateController,
                                            feeNarration:
                                            feeNarrationController,
                                            feeAmount: feeAmountController,
                                            onPressed: () async {
                                              Provider.of<
                                                  ShowInsertingTableRowTOServer>(
                                                  context, listen: false)
                                                  .totalNumberOfTableRow(
                                                  totalNumberOfRow: listData
                                                      .length.toInt());
                                              Constants.onLoading(context,
                                                  'Due Fee Processing');
                                              if (formKey.currentState!
                                                  .validate()) {
                                                for (int i = 0;
                                                i < listData.length;
                                                i++) {
                                                  if (i > 0) {
                                                    feeDueID += -1;
                                                  }
                                                  Provider.of<
                                                      ShowInsertingTableRowTOServer>(
                                                      context, listen: false)
                                                      .insertingRow();
                                                  await studentFeeDue
                                                      .insertStudentFeeDue(
                                                      feeDueId: feeDueID,

                                                      feeNarration:
                                                      feeNarrationController
                                                          .text
                                                          .toString(),
                                                      feeDueAmount: feeAmountController
                                                          .text
                                                          .isNotEmpty
                                                          ? double.parse(
                                                          feeAmountController
                                                              .text
                                                              .toString())
                                                          : listData[i]['MonthlyFee'] ==
                                                          null
                                                          ? 0.0
                                                          : double.parse(
                                                          listData[i]['MonthlyFee']
                                                              .toString()),
                                                      dueDate:
                                                      dueOnDateController
                                                          .text
                                                          .toString(),
                                                      sectionStudentID: listData[i]
                                                      ['SectionStudenID'],
                                                      grn: listData[i]
                                                      ['GRN']);
                                                }
                                                feeNarrationController.clear();
                                                feeAmountController.clear();
                                                dueOnDateController.clear();


                                                Provider.of<
                                                    ShowInsertingTableRowTOServer>(
                                                    context, listen: false)
                                                    .resetRow();
                                                Provider.of<
                                                    ShowInsertingTableRowTOServer>(
                                                    context, listen: false)
                                                    .resetTotalNumber();
                                                Constants.hideDialog(context);

                                                setState(() {});
                                                Navigator.pop(context);
                                              }
                                            },
                                            context: context),
                                      )),
                                );
                              });
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.replay_30_rounded,
                                color: Colors.blue.shade900, size: fontSize,),
                              Text('Due Fee'),
                            ],
                          ),
                        ),
                      ),
                    ),


                    Flexible(
                      child: InkWell(
                        onTap: () async {

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, color: Colors.grey,
                                size: fontSize,),
                              Text('Fee Rec'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List studentLedgerList = await _schoolSQL
                              .dataForAllStudentLedgerFeeDue(grnOfStudent);

                          Navigator.push(mainBuildContext, MaterialPageRoute(
                            builder: (context) =>
                                StudentLedger(list: studentLedgerList,),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(

                            children: [
                              Icon(Icons.contact_page_outlined,
                                color: Colors.yellow.shade900, size: fontSize,),
                              Text('Student Balance'),
                            ],
                          ),
                        ),
                      ),
                    ),


                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForDueFeeDetails(
                              modelsectionStudent.id.toString(),
                              'Sch5SectionStudent.SectionStudenID');

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                DueFeeDetails(
                                    list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restore_page_outlined,
                                color: Colors.brown,
                                size: fontSize,),
                              Text('Due Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),


                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          List listData = await _schoolSQL
                              .dataForFeeRECCompleteDetailsByID(
                              modelsectionStudent.id.toString(),
                              'Sch5SectionStudent.SectionStudenID');

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                FeeDetailsComplete(
                                    titleName: modelsectionStudent.getName(),
                                    list: listData),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.request_page_outlined, color: Colors.red,
                                size: fontSize,),
                              Text('Fee Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        FutureBuilder(
          future: _schoolSQL.checkNewAllFeeDueForDeletion(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(content: Text(
                          'Do You Really Want TO delete New FeeDue Records'),
                        actions: [
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: Text('Cancel')),
                          TextButton(onPressed: () async {
                            await _schoolSQL.deleteNewAllFeeDue();
                            await _schoolSQL.deleteNewAllFeeREC1();
                            await _schoolSQL.deleteNewAllFeeREC2();

                            Navigator.pop(context);
                            setState(() {});
                          }, child: Text('delete'))
                        ],
                      );
                    },);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all()
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.delete,
                          color: Colors.red, size: 35,),
                        Text('Delete all new feeDue'),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    )
        : StatefulBuilder(
      builder: (context, state) =>
       ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
          Align(alignment: Alignment.centerLeft, child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Fee Rec  Against Due',
              style: TextStyle(fontSize: 20, color: Colors.black87),),
          )),
          FutureBuilder(
            future: _schoolSQL.dataForSch1FeeReceived(
                feeDueID:
                modelFeeDueList.id.toString()),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List sortedList = [];
                    if (widget.isDecending == true) {
                      sortedList = snapshot
                          .data!.reversed
                          .toList();
                    } else if (widget
                        .isDecendingCredit ==
                        true) {
                      sortedList = snapshot
                          .data!.reversed
                          .toList();
                    } else if (widget
                        .isDecendingDebit ==
                        true) {
                      sortedList = snapshot
                          .data!.reversed
                          .toList();
                    } else {
                      sortedList = snapshot.data!;
                    }
                    Map map = {};
                    if (index < snapshot.data!.length) {
                      map = sortedList[index];
                    }

                    print(map);


                    return customListView(
                      studentQuantity: '',
                      statusRecord: map['FeeRec1ID'] == null
                          ? Text('')
                          : map['FeeRec1ID'] < 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'New',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : map['FeeRec1ID'] > 0 &&
                          map['UpdatedDate']
                              .toString()
                              .length == 0 ? Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Modified',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ) : SizedBox(),

                      backColor: Colors.grey.shade100,
                      borderColor: Colors.black,
                      name: map['FeeRecDate']
                          .toString(),
                      totalDue: map['FeeDueAmount'] == null
                          ? '0'
                          : map['FeeDueAmount']
                          .toString(),
                      totalReceived: map['RecAmount'] == null ? '0' :
                      map['RecAmount']
                          .toString(),
                      totalBalance: map['TotalBalance'] == null ? '0' :
                      map['TotalBalance']
                          .toString(),
                      onSelected: (int value) async {
                        if (value == 0) {
                          if (map['FeeRec1ID'] < 0) {
                            feeRecAmountController.text = map['RecAmount']
                                .toString();
                            longLatController.text = map['FeeRecRemarks']
                                .toString();
                            await showGeneralDialog(
                                context: context,
                                pageBuilder:
                                    (BuildContext
                                context,
                                    animation,
                                    secondaryAnimation) {
                                  return StatefulBuilder(
                                    builder: (context, state) =>
                                        Align(
                                            alignment:
                                            Alignment
                                                .center,
                                            child: AnimatedContainer(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery
                                                      .of(context)
                                                      .viewInsets
                                                      .bottom),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: CustomDialogForFeeRec
                                                  .customFeeRecDueDialog(
                                                  OpenForEditOrSave: 'Edit',
                                                  onPressedClose: () async {
                                                    Provider.of<
                                                        ShowInsertingTableRowTOServer>(
                                                        context, listen: false)
                                                        .resetRow();

                                                    Navigator.pop(context);

                                                    setState(() {});
                                                  },
                                                  maxID: map['FeeRec1ID']
                                                      .toString(),
                                                  title: 'Receiving Amount',
                                                  onTap: () async {
                                                    currentDate =
                                                    await showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return DatePickerStyle1();
                                                        });
                                                    state(() {

                                                    });
                                                  },
                                                  currentDate: currentDate
                                                      .toString()
                                                      .substring(
                                                      0, 10),
                                                  remarksTitle: 'Remarks',
                                                  controller: feeRecAmountController,
                                                  remarksController: longLatController,
                                                  onPressed: () async {
                                                    await studentFeeRec
                                                        .updateStudentFeeRec(
                                                      id: map['ID'],
                                                      recAmount:
                                                      feeRecAmountController.text
                                                          .toString()
                                                          .trim(),
                                                      context:
                                                      context,
                                                      feeRecRemarks: longLatController
                                                          .text.toString(),
                                                      feeRecDate: map['FeeRecDate']
                                                          .toString(),
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  context: context),
                                            )

                                        ),
                                  );
                                });
                          } else {
                            List userRightList = await _salePurSQLDataBase
                                .userRightsChecking(widget.menuName);
                            if (SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.userRightsClient) ==
                                'Custom Right') {
                              if (userRightList[0]['Editing']
                                  .toString()
                                  == 'true') {
                                feeRecAmountController.text = map['RecAmount']
                                    .toString();
                                longLatController.text = map['FeeRecRemarks']
                                    .toString();
                                await showGeneralDialog(
                                    context: context,
                                    pageBuilder:
                                        (BuildContext
                                    context,
                                        animation,
                                        secondaryAnimation) {
                                      return StatefulBuilder(
                                        builder: (context, state) =>
                                            Align(
                                                alignment:
                                                Alignment
                                                    .center,
                                                child: AnimatedContainer(
                                                  padding: EdgeInsets.only(
                                                      bottom: MediaQuery
                                                          .of(context)
                                                          .viewInsets
                                                          .bottom),
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  child: CustomDialogForFeeRec
                                                      .customFeeRecDueDialog(
                                                      OpenForEditOrSave: 'Edit',
                                                      onPressedClose: () async {
                                                        Provider.of<
                                                            ShowInsertingTableRowTOServer>(
                                                            context,
                                                            listen: false)
                                                            .resetRow();

                                                        Navigator.pop(context);

                                                        setState(() {});
                                                      },
                                                      maxID: map['FeeRec1ID']
                                                          .toString(),
                                                      title: 'Receiving Amount',
                                                      onTap: () async {
                                                        currentDate =
                                                        await showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return DatePickerStyle1();
                                                            });
                                                        state(() {

                                                        });
                                                      },
                                                      currentDate: currentDate
                                                          .toString()
                                                          .substring(
                                                          0, 10),
                                                      remarksTitle: 'Remarks',
                                                      controller: feeRecAmountController,
                                                      remarksController: longLatController,
                                                      onPressed: () async {
                                                        await studentFeeRec
                                                            .updateStudentFeeRec(
                                                          id: map['ID'],
                                                          recAmount:
                                                          feeRecAmountController
                                                              .text
                                                              .toString()
                                                              .trim(),
                                                          context:
                                                          context,
                                                          feeRecRemarks: longLatController
                                                              .text.toString(),
                                                          feeRecDate: map['FeeRecDate']
                                                              .toString(),
                                                        );

                                                        Navigator.pop(context);
                                                      },
                                                      context: context),
                                                )

                                            ),
                                      );
                                    });
                              }
                            } else if (SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.userRightsClient) ==
                                'Admin') {
                              feeRecAmountController.text = map['RecAmount']
                                  .toString();
                              longLatController.text = map['FeeRecRemarks']
                                  .toString();
                              await showGeneralDialog(
                                  context: context,
                                  pageBuilder:
                                      (BuildContext
                                  context,
                                      animation,
                                      secondaryAnimation) {
                                    return StatefulBuilder(
                                      builder: (context, state) =>
                                          Align(
                                              alignment:
                                              Alignment
                                                  .center,
                                              child: AnimatedContainer(
                                                padding: EdgeInsets.only(
                                                    bottom: MediaQuery
                                                        .of(context)
                                                        .viewInsets
                                                        .bottom),
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                child: CustomDialogForFeeRec
                                                    .customFeeRecDueDialog(
                                                    OpenForEditOrSave: 'Edit',
                                                    onPressedClose: () async {
                                                      Provider.of<
                                                          ShowInsertingTableRowTOServer>(
                                                          context, listen: false)
                                                          .resetRow();
                                                      Navigator.pop(context);

                                                      setState(() {});
                                                    },
                                                    maxID: map['FeeRec1ID']
                                                        .toString(),
                                                    title: 'Receiving Amount',
                                                    onTap: () async {
                                                      currentDate =
                                                      await showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return DatePickerStyle1();
                                                          });
                                                      state(() {

                                                      });
                                                    },
                                                    currentDate: currentDate
                                                        .toString()
                                                        .substring(
                                                        0, 10),
                                                    remarksTitle: 'Remarks',
                                                    controller: feeRecAmountController,
                                                    remarksController: longLatController,
                                                    onPressed: () async {
                                                      await studentFeeRec
                                                          .updateStudentFeeRec(
                                                        id: map['ID'],
                                                        recAmount:
                                                        feeRecAmountController
                                                            .text
                                                            .toString()
                                                            .trim(),
                                                        context:
                                                        context,
                                                        feeRecRemarks: longLatController
                                                            .text.toString(),
                                                        feeRecDate: map['FeeRecDate']
                                                            .toString(),
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    context: context),
                                              )

                                          ),
                                    );
                                  });
                            }
                          }
                        }
                        if (value == 1) {

                        }

                        if (value == 2) {
                          await showDialog(
                              context:
                              context,
                              builder:
                                  (context) {
                                return   Center(
                                    child:
                                    Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          .35,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .8,
                                      color: Colors
                                          .white,
                                      child:
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child:
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Rec ID : '),
                                                    Text(
                                                      '${map['FeeRec1ID']}',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Total Rec : '),
                                                    Text(
                                                      '${map['RecAmount']}',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 25,
                                                          fontWeight: FontWeight
                                                              .bold),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Date :'),
                                                Text(
                                                  '${DateFormat(
                                                      SharedPreferencesKeys.prefs!
                                                          .getString(
                                                          SharedPreferencesKeys
                                                              .dateFormat))
                                                      .format(DateTime(int.parse(
                                                      map['FeeRecDate']
                                                          .toString()
                                                          .substring(0, 4)),
                                                      int.parse(map['FeeRecDate']
                                                          .toString()
                                                          .substring(
                                                        5,
                                                        7,
                                                      )), int.parse(
                                                          map['FeeRecDate']
                                                              .toString()
                                                              .substring(8, 10))))
                                                      .toString()}',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Fee Remarks :  '),
                                                Text(
                                                  '${map['FeeRecRemarks']}',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Text('Total Selected : '),
                                            //     Text(
                                            //       '',
                                            //       style: TextStyle(color: Colors.grey),
                                            //     ),
                                            //   ],
                                            // ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        List list = await _feeCollectionSQL
                                                            .selectPhoneNumberOFStudent(
                                                            map['FeeRec1ID']
                                                                .toString());

                                                        feeRecPrint(context: context, slipInfoOfREc: list);
                                                      },
                                                      child: Text('Print')),
                                                  //  FatherMobileNo  MotherMobileNo

                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        numberSendToWhatsApp(
                                                            map['FeeRec1ID']
                                                                .toString(), context, );
                                                      },
                                                      child: Text('WhatsApp')),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('back')),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );

                              });
                        }

                        setState(() {

                        });
                      },
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: FutureBuilder(
                          future:
                          _salePurSQLDataBase.userRightsChecking(widget.menuName),
                          builder: (context, AsyncSnapshot<List> snapshot) {
                            if (snapshot.hasData) {
                              return InkWell(
                                onTap: () async {
                                  if (SharedPreferencesKeys.prefs!.getString(
                                      SharedPreferencesKeys.userRightsClient) ==
                                      'Custom Right') {
                                    if (snapshot.data![0]['Inserting']
                                        .toString()
                                        == 'true') {
                                      int feeRecID = await studentFeeRec
                                          .maxIDForFeeRec();
                                      longLatController.clear();
                                      feeRecAmountController
                                          .clear();
                                      await showGeneralDialog(
                                          context: context,
                                          pageBuilder:
                                              (BuildContext
                                          context,
                                              animation,
                                              secondaryAnimation) {
                                            return StatefulBuilder(
                                              builder: (context, state) =>
                                                  Align(
                                                    alignment:
                                                    Alignment
                                                        .center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery
                                                              .of(context)
                                                              .viewInsets
                                                              .bottom),
                                                      child: CustomDialogForFeeRec
                                                          .customFeeRecDueDialog(
                                                        onPressedClose: () async {
                                                          Provider.of<
                                                              ShowInsertingTableRowTOServer>(
                                                              context,
                                                              listen: false)
                                                              .resetRow();

                                                          Navigator.pop(context);

                                                          setState(() {});
                                                        },
                                                        maxID: feeRecID
                                                            .toString(),
                                                        onTap: () async {
                                                          currentDate =
                                                          await showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return DatePickerStyle1();
                                                              });
                                                          state(() {

                                                          });
                                                        },
                                                        remarksController: longLatController,
                                                        remarksTitle: 'Remarks',
                                                        title:
                                                        'Receiving Amount',
                                                        controller:
                                                        feeRecAmountController,
                                                        onPressed:
                                                            () async {
                                                          await studentFeeRec
                                                              .insertStudentFeeRec(

                                                              feeRecDate: currentDate
                                                                  .toString(),
                                                              feeRecRemarks: longLatController
                                                                  .text
                                                                  .toString(),

                                                              feeRecAmount: double
                                                                  .parse(
                                                                  feeRecAmountController
                                                                      .text),

                                                              feeDueID:
                                                              modelFeeDueList.id);

                                                          Provider.of<
                                                              ShowInsertingTableRowTOServer>(
                                                              context,
                                                              listen: false)
                                                              .insertingRow();

                                                          setState(() {});

                                                          //  Navigator.pop(context);
                                                        },
                                                        context:
                                                        context,
                                                        currentDate: currentDate
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ),
                                            );
                                          });

                                      longLatController.clear();
                                      feeRecAmountController
                                          .clear();

                                      setState(() {

                                      });
                                    }
                                  } else if (
                                  SharedPreferencesKeys.prefs!.getString(
                                      SharedPreferencesKeys.userRightsClient) ==
                                      'Admin'
                                  ) {
                                    int feeRecID = await studentFeeRec
                                        .maxIDForFeeRec();
                                    longLatController.clear();
                                    feeRecAmountController
                                        .clear();
                                    await showGeneralDialog(
                                        context: context,
                                        pageBuilder:
                                            (BuildContext
                                        context,
                                            animation,
                                            secondaryAnimation) {
                                          return StatefulBuilder(
                                            builder: (context, state) =>
                                                Align(
                                                  alignment:
                                                  Alignment
                                                      .center,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery
                                                            .of(context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: CustomDialogForFeeRec
                                                        .customFeeRecDueDialog(
                                                      onPressedClose: () async {
                                                        Provider.of<
                                                            ShowInsertingTableRowTOServer>(
                                                            context,
                                                            listen: false)
                                                            .resetRow();


                                                        Navigator.pop(context);

                                                        setState(() {});
                                                      },
                                                      maxID: feeRecID.toString(),
                                                      onTap: () async {
                                                        currentDate =
                                                        await showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return DatePickerStyle1();
                                                            });
                                                        state(() {

                                                        });
                                                      },
                                                      remarksController: longLatController,
                                                      remarksTitle: 'Remarks',
                                                      title:
                                                      'Receiving Amount',
                                                      controller:
                                                      feeRecAmountController,
                                                      onPressed:
                                                          () async {
                                                        int feeRec1ID = await studentFeeRec
                                                            .insertStudentFeeRec(

                                                            feeRecDate: currentDate
                                                                .toString(),
                                                            feeRecRemarks: longLatController
                                                                .text.toString(),

                                                            feeRecAmount: double
                                                                .parse(
                                                                feeRecAmountController
                                                                    .text),

                                                            feeDueID:
                                                            modelFeeDueList.id);
                                                        Provider.of<
                                                            ShowInsertingTableRowTOServer>(
                                                            context,
                                                            listen: false)
                                                            .insertingRow();


                                                        await showDialog(
                                                            context:
                                                            context,
                                                            builder:
                                                                (context) {
                                                              return Center(
                                                                child:
                                                                Material(
                                                                  child: Container(
                                                                    height: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .height *
                                                                        .35,
                                                                    width: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        .8,
                                                                    color: Colors
                                                                        .white,
                                                                    child:
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                      'Rec ID : '),
                                                                                  Text(
                                                                                    '$feeRec1ID',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .grey),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                      'Total Rec : '),
                                                                                  Text(
                                                                                    '${feeRecAmountController
                                                                                        .text
                                                                                        .toString()}',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .green,
                                                                                        fontSize: 25,
                                                                                        fontWeight: FontWeight
                                                                                            .bold),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  'Date :'),
                                                                              Text(
                                                                                '${DateFormat(
                                                                                    SharedPreferencesKeys
                                                                                        .prefs!
                                                                                        .getString(
                                                                                        SharedPreferencesKeys
                                                                                            .dateFormat))
                                                                                    .format(
                                                                                    DateTime(
                                                                                        int
                                                                                            .parse(
                                                                                            currentDate
                                                                                                .toString()
                                                                                                .substring(
                                                                                                0,
                                                                                                4)),
                                                                                        int
                                                                                            .parse(
                                                                                            currentDate
                                                                                                .toString()
                                                                                                .substring(
                                                                                              5,
                                                                                              7,
                                                                                            )),
                                                                                        int
                                                                                            .parse(
                                                                                            currentDate
                                                                                                .toString()
                                                                                                .substring(
                                                                                                8,
                                                                                                10))))
                                                                                    .toString()}',
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .grey),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  'Fee Remarks :  '),
                                                                              Text(
                                                                                '${longLatController
                                                                                    .text
                                                                                    .toString()}',
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .grey),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Align(
                                                                            alignment: Alignment
                                                                                .bottomCenter,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                  .spaceEvenly,
                                                                              children: [
                                                                                ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      List list = await _feeCollectionSQL
                                                                                          .selectPhoneNumberOFStudent(
                                                                                          feeRec1ID
                                                                                              .toString());

                                                                                      feeRecPrint(context: context, slipInfoOfREc: list);


                                                                                    },
                                                                                    child: Text(
                                                                                        'Print')),
                                                                                //  FatherMobileNo  MotherMobileNo

                                                                                ElevatedButton(
                                                                                    onPressed: () async {

                                                                                      numberSendToWhatsApp(
                                                                                        feeRec1ID
                                                                                            .toString(), context, );


                                                                                    },
                                                                                    child: Text(
                                                                                        'WhatsApp')),
                                                                                ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Navigator
                                                                                          .pop(
                                                                                          context);
                                                                                    },
                                                                                    child: Text(
                                                                                        'back')),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            });


                                                        setState(() {});
                                                      },
                                                      context:
                                                      context,
                                                      currentDate: currentDate
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                          );
                                        });

                                    longLatController.clear();
                                    feeRecAmountController
                                        .clear();

                                    setState(() {

                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all()
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Icon(Icons.add, color: Colors.green,
                                        size: fontSize,),
                                      Text('Fee Rec'),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ),


                    ],
                  ),


                ],
              ),
            ),
          )
      ],
    ),
        );
  }




  getSearchListFOrNewRecord({required String searchValue}) {
    List<Map<dynamic, dynamic>> tempList = [];
    for (Map<dynamic, dynamic> element in wholeListOFStudent) {
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
    filterListStudent = tempList;
  }

  Widget customListView({required String name,
    required String totalDue,
    required String totalReceived,
    required String totalBalance,
    required Color backColor,
    required String studentQuantity,
    Widget statusRecord = const Text(''),
    required Color borderColor,
    required void Function(int value)? onSelected}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
      child: Card(
        elevation: 6,
        shadowColor: borderColor,
        margin: EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor),),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            name, style: TextStyle(fontSize: 18,
                              color: Colors.black),
                          ),
                          studentQuantity != '' ? Text(
                            '($studentQuantity)',
                            style: TextStyle(fontSize: 14,
                              color: Colors.grey,),
                          ) : const SizedBox(),


                        ],
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 25,
                      child: 'FeeRec2' ==
                          Provider.of<ModelShowYearListView>(
                              context, listen: false)
                              .getStatus() ? PopupMenuButton<int>(
                        padding: EdgeInsets.only(
                            bottom: 30, left: 0, right: 0, top: 0),
                        icon: Icon(Icons.more_horiz, color: Colors.grey,),
                        onSelected: onSelected,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(value: 0, child: Text('Edit')),
                            PopupMenuItem(
                                value: 1,
                                child: Text('Receiving')),
                            PopupMenuItem(
                                value: 2,
                                child: Text('Print'))
                          ];
                        },
                      ) : PopupMenuButton<int>(
                        padding: EdgeInsets.only(
                            bottom: 30, left: 0, right: 0, top: 0),
                        icon: Icon(Icons.more_horiz, color: Colors.grey,),
                        onSelected: onSelected,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(value: 0, child: Text('Edit')),
                            PopupMenuItem(
                                value: 1,
                                child: Text('SectionStudent' ==
                                    Provider.of<ModelShowYearListView>(
                                        context, listen: false)
                                        .getStatus()
                                    ? 'Student GL'
                                    : 'Receiving'))
                          ];
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      totalDue,
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        totalReceived,
                        style: TextStyle(
                            fontSize: 14, color: Colors.green),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Center(child: statusRecord,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        totalBalance,
                        style: TextStyle(color: Colors.red, fontSize: 20),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bulkFeeAllStudentYear({required TextEditingController dueOnDate,
    required TextEditingController feeNarration,
    String OpenForEditOrSave = '',
    required TextEditingController feeAmount,

    required void Function()? onPressed,
    required String dialogTitle,
    String? stateName = '',
    required int maxID,
    required BuildContext context}) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (context, state) =>
              Material(
                elevation: 20,
                color: Colors.transparent,
                child: Form(
                  key: formKey,
                  child: Container(
                    color: Provider
                        .of<ThemeDataHomePage>(context,
                        listen: false)
                        .backGroundColor,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .53,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .80,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35,

                          color: Provider
                              .of<ThemeDataHomePage>(context,
                              listen: false)
                              .borderTextAppBarColor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0, right: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(flex: 8, child: FittedBox(child: Text(
                                  dialogTitle,
                                  style: TextStyle(color: Colors.white),),),),
                                Flexible(flex: 2,
                                    child: Text(maxID.toString(),
                                      style: TextStyle(color: Colors.white),)),
                              ],
                            ),
                          ),
                        ),

                        Text(stateName!,
                          style: TextStyle(fontWeight: FontWeight.bold),),

                        Padding(
                          padding: const EdgeInsets.only(left: 6.0, right: 6),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'required';
                              } else {
                                return null;
                              }
                            },
                            controller: dueOnDate,
                            onTap: () async {
                              currentDate = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DatePickerStyle1();
                                  });
                              dueOnDate.text = '${DateFormat(
                                  SharedPreferencesKeys.prefs!.getString(
                                      SharedPreferencesKeys.dateFormat))
                                  .format(DateTime(int.parse(
                                  currentDate.toString().substring(0, 4)),
                                  int.parse(currentDate.toString().substring(
                                    5,
                                    7,
                                  )), int.parse(
                                      currentDate.toString().substring(8, 10))))
                                  .toString()}';


                              state(() {});
                            },
                            readOnly: true,
                            decoration:
                            InputDecoration(border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,

                                label: Text('Due On date',
                                  style: TextStyle(color: Colors.black),)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0, right: 6),
                          child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'required';
                                } else {
                                  return null;
                                }
                              },
                              controller: feeNarration,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                label: Text('Fee Narration',
                                  style: TextStyle(color: Colors.black),),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0, right: 6),

                          child: SwitchListTile(contentPadding: EdgeInsets.all(
                              0),
                              activeColor: Provider
                                  .of<ThemeDataHomePage>(context,
                                  listen: false)
                                  .borderTextAppBarColor,
                              title: Text(checkValueTitle),
                              value: checkValue,
                              onChanged: (value) {
                                state(() {
                                  checkValue = value;
                                  if (value) {
                                    checkValueTitle = 'Custom Fee';
                                  } else {
                                    checkValueTitle = 'Monthly Fee';
                                  }
                                });
                              }),
                        ),
                        checkValue
                            ? Padding(
                          padding: const EdgeInsets.only(left: 6.0, right: 6),
                          child: TextFormField(
                            controller: feeAmount,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return checkValue ? 'required' : null;
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                label: Text('Fee Amount',
                                  style: TextStyle(color: Colors.black),)),
                          ),
                        )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, top: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 30,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20),
                                        ) // foreground
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);

                                      setState(() {});
                                    },
                                    child: Text(
                                      'CLOSE',
                                    )),
                              ),
                              Container(
                                height: 30,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20),
                                        ) // foreground
                                    ),
                                    onPressed: onPressed,
                                    child: Text(
                                      OpenForEditOrSave == 'Edit' ? 'Update'
                                          : 'SAVE',
                                    )),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

}




