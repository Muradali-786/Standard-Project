import 'dart:io';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../material/datepickerstyle1.dart';
import 'Sch1Branch.dart';
import 'Sch2Year.dart';
import 'Sch3ClassSection.dart';
import 'Sch3Classes.dart';
import 'Sch5SectionStudrent.dart';
import 'Sch6StudentFeeDue.dart';
import 'Sch7FeeRec2.dart';
import 'SchoolSql.dart';

class TreeView extends StatefulWidget {
  final List sch1Branch;
  final BuildContext context;

  const TreeView({Key? key, required this.sch1Branch, required this.context})
      : super(key: key);

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  DatabaseProvider db = DatabaseProvider();
  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  TextEditingController yearEducationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController longLatController = TextEditingController();
  TextEditingController feeRecAmountController = TextEditingController();
  TextEditingController classSectionController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController studentHeight = TextEditingController();
  TextEditingController sectionStudentController = TextEditingController();
  TextEditingController sectionMonthlyFeeController = TextEditingController();
  TextEditingController studentWeight = TextEditingController();
  TextEditingController feeAmountController = TextEditingController();
  TextEditingController dueOnDateController = TextEditingController();
  TextEditingController feeNarrationController = TextEditingController();
  YearClasses yearClasses = YearClasses();
  SchoolSQL _schoolSQL = SchoolSQL();
  StudentFeeRec studentFeeRec = StudentFeeRec();
  StudentFeeDue studentFeeDue = StudentFeeDue();
  ClassSection classSection = ClassSection();
  SchoolYear schoolYear = SchoolYear();
  var currentDate = DateTime.now();
  SchoolBranches schoolBranches = SchoolBranches();
  String checkValueTitle = 'Monthly Fee';
  bool checkValue = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext mainBuildContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: MediaQuery.of(mainBuildContext).size.width * 1.6,
          child: ListView(
            children: [
              FutureBuilder(
                  future: _schoolSQL.dataForSch1Branch(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> branchSnap) {
                    if (branchSnap.hasData) {
                      return Column(
                        children: [
                          ///   branches view .......................................................
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: branchSnap.data!.length,
                            itemBuilder:
                                (BuildContext context, int indexBranch) {
                              return ExpansionTile(

                                ///  eit pop  menu button ............................................
                                trailing: PopupMenuButton<int>(
                                  initialValue: 0,
                                  onSelected: (int value) {
                                    nameController.text = branchSnap
                                        .data![indexBranch]['BranchName']
                                        .toString();
                                    longLatController.text = branchSnap
                                        .data![indexBranch]['LongLat']
                                        .toString();

                                    contactNumberController.text = branchSnap
                                        .data![indexBranch]['ContactNo']
                                        .toString();

                                    addressController.text = branchSnap
                                        .data![indexBranch]['Address']
                                        .toString();
                                    showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext context,
                                            animation, secondaryAnimation) {
                                          return Align(
                                              alignment: Alignment.center,
                                              child: branchDialog(
                                                onPressedClose: (){
                                                  Navigator.pop(context);
                                                },
                                                onPressed: () async {
                                                  SchoolBranches schoolBranch =
                                                      SchoolBranches();

                                                  await schoolBranch
                                                      .updateSchoolBranches(
                                                          id: branchSnap.data![
                                                                  indexBranch][
                                                              'ID'],
                                                          name:
                                                              nameController
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

                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                ContactNumber:
                                                    contactNumberController,
                                                Address: addressController,
                                                name: nameController,
                                                context: context,
                                                LongLat: longLatController,
                                              ));
                                        });
                                  },
                                  itemBuilder: (context) => List.generate(
                                      1,
                                      (index) => PopupMenuItem(
                                          value: index, child: Text('Edit'))),
                                ),
                                leading: Icon(
                                  Icons.expand_more,
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            branchSnap.data![indexBranch]
                                                        ['BranchName'] !=
                                                    null
                                                ? branchSnap.data![indexBranch]
                                                        ['BranchName']
                                                    .toString()
                                                : '0',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(width: 20),
                                        Row(
                                          children: [
                                            Text(
                                                branchSnap.data![indexBranch]
                                                            ['TotalDue'] !=
                                                        null
                                                    ? branchSnap
                                                        .data![indexBranch]
                                                            ['TotalDue']
                                                        .toString()
                                                    : '0',
                                                style: TextStyle(fontSize: 12)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                  branchSnap.data![indexBranch][
                                                              'TotalReceived'] !=
                                                          null
                                                      ? branchSnap
                                                          .data![indexBranch]
                                                              ['TotalReceived']
                                                          .toString()
                                                      : '0',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 25.0),
                                      child: Text(branchSnap.data![indexBranch]
                                                  ['TotalBalance'] !=
                                              null
                                          ? branchSnap.data![indexBranch]
                                                  ['TotalBalance']
                                              .toString()
                                          : '0'),
                                    ),
                                  ],
                                ),
                                children: [

                                  ///  year view ........................................................
                                  FutureBuilder(
                                    future: _schoolSQL.dataForSch1EducationYear(
                                      branchID: branchSnap.data![indexBranch]
                                              ['BranchID']
                                          .toString(),
                                    ),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<dynamic>> yearSnap) {
                                      if (yearSnap.hasData) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                physics: ScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    yearSnap.data!.length,
                                                itemBuilder: (BuildContext
                                                        context,
                                                    int indexYearEducation) {
                                                  return ExpansionTile(

                                                    /// edit btn for year ..........................................
                                                    trailing:
                                                        PopupMenuButton<int>(
                                                      initialValue: 0,
                                                      onSelected: (int value)  async{
                                                        yearEducationController.clear();
                                                        yearEducationController.text =
                                                            yearSnap.data![indexYearEducation]['EducationalYear']
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
                                                            child: YearEducationalDialog
                                                                .yearEducationalDialog(
                                                                onPressedClose: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                title:
                                                                'Year Education',
                                                                controller:
                                                                yearEducationController,
                                                                onPressed: () async {
                                                                  int updateStatus = await schoolYear
                                                                      .updateSchoolYear(
                                                                      id: yearSnap.data![indexYearEducation]['ID'],
                                                                      yearEducation:
                                                                      yearEducationController
                                                                          .text
                                                                          .toString(),
                                                                      context:
                                                                      context);
                                                                  if (updateStatus ==
                                                                      1) {
                                                                    print('SUCCESS');
                                                                    ScaffoldMessenger
                                                                        .of(
                                                                        context)
                                                                        .showSnackBar(
                                                                        SnackBar(
                                                                            content:
                                                                            Text('Update Successful')));
                                                                    Navigator.pop(
                                                                        context);
                                                                  } else {
                                                                    print('FAILED');
                                                                    ScaffoldMessenger
                                                                        .of(
                                                                        context)
                                                                        .showSnackBar(
                                                                        SnackBar(
                                                                            content:
                                                                            Text('Update Failed')));
                                                                  }
                                                                },
                                                                context: context),
                                                          );
                                                        });
                                                        setState(() {});
                                                      },
                                                      itemBuilder: (context) =>
                                                          List.generate(
                                                              1,
                                                              (index) =>
                                                                  PopupMenuItem(
                                                                      value:
                                                                          index,
                                                                      child: Text(
                                                                          'Edit'))),
                                                    ),
                                                    leading:
                                                        Icon(Icons.expand_more),
                                                    title:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(yearSnap.data![indexYearEducation]
                                                                              [
                                                                              'EducationalYear'] !=
                                                                          null
                                                                      ? yearSnap
                                                                          .data![
                                                                              indexYearEducation]
                                                                              [
                                                                              'EducationalYear']
                                                                          .toString()
                                                                      : '0'),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        yearSnap.data![indexYearEducation]['TotalDue'] !=
                                                                                null
                                                                            ? yearSnap.data![indexYearEducation]['TotalDue'].toString()
                                                                            : '0',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 8.0),
                                                                        child:
                                                                            Text(
                                                                          yearSnap.data![indexYearEducation]['TotalReceived'] != null
                                                                              ? yearSnap.data![indexYearEducation]['TotalReceived'].toString()
                                                                              : '0',
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(yearSnap.data![
                                                                              indexYearEducation]
                                                                          [
                                                                          'TotalBalance'] !=
                                                                      null
                                                                  ? yearSnap
                                                                      .data![
                                                                          indexYearEducation]
                                                                          [
                                                                          'TotalBalance']
                                                                      .toString()
                                                                  : '0'),
                                                            ],
                                                          ),
                                                          SizedBox(width: 20),
                                                        ],
                                                      ),
                                                    ),
                                                    children: [

                                                      ///  classs view ........................................................
                                                      FutureBuilder(
                                                        future: _schoolSQL
                                                            .dataForSch1EducationYearClass(
                                                                educationalYearID: yearSnap
                                                                    .data![
                                                                        indexYearEducation]
                                                                        [
                                                                        'EducationalYearID']
                                                                    .toString()),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    List<
                                                                        dynamic>>
                                                                classSnap) {
                                                          if (classSnap
                                                              .hasData) {
                                                            return Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 30),
                                                                  child: ListView
                                                                      .builder(
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    physics:
                                                                        ScrollPhysics(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount:
                                                                        classSnap
                                                                            .data!
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int classIndex) {
                                                                      return ExpansionTile(
                                                                        trailing:
                                                                            PopupMenuButton<int>(
                                                                          initialValue:
                                                                              0,
                                                                          onSelected:
                                                                              (int value) {
                                                                                yearEducationController
                                                                                    .clear();
                                                                                yearEducationController.text =
                                                                                    classSnap
                                                                                        .data![classIndex]
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
                                                                                        child: CustomDialogForClasses
                                                                                            .customDialog(
                                                                                            onPressedClose: (){
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            title:
                                                                                            'ADD Classes',
                                                                                            controller:
                                                                                            yearEducationController,
                                                                                            onPressed:
                                                                                                () async {
                                                                                              int updateStatus = await yearClasses
                                                                                                  .updateClasses(
                                                                                                  id: classSnap
                                                                                                      .data![classIndex]['ID'],
                                                                                                  classYearName: yearEducationController
                                                                                                      .text
                                                                                                      .toString()
                                                                                                      .trim(),
                                                                                                  context:
                                                                                                  context);
                                                                                              if (updateStatus ==
                                                                                                  1) {
                                                                                                print(
                                                                                                    'SUCCESS');
                                                                                                ScaffoldMessenger.of(
                                                                                                    context)
                                                                                                    .showSnackBar(
                                                                                                    SnackBar(content: Text(
                                                                                                        'Update Successful')));
                                                                                                Navigator.pop(
                                                                                                    context);
                                                                                              } else {
                                                                                                print(
                                                                                                    'FAILED');
                                                                                                ScaffoldMessenger.of(
                                                                                                    context)
                                                                                                    .showSnackBar(
                                                                                                    SnackBar(content: Text(
                                                                                                        'Update Failed')));
                                                                                              }
                                                                                            },
                                                                                            context:
                                                                                            context),
                                                                                      );
                                                                                    });
                                                                                setState(() {

                                                                                });
                                                                          },
                                                                          itemBuilder: (context) => List.generate(
                                                                              1,
                                                                              (index) => PopupMenuItem(value: index, child: Text('Edit'))),
                                                                        ),
                                                                        leading:
                                                                            Icon(Icons.expand_more),
                                                                        title:
                                                                            SizedBox(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(classSnap.data![classIndex]['ClassName'].toString()),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        classSnap.data![classIndex]['TotalDue'] != null ? classSnap.data![classIndex]['TotalDue'].toString() : '0',
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 8.0),
                                                                                        child: Text(
                                                                                          classSnap.data![classIndex]['TotalReceived'] != null ? classSnap.data![classIndex]['TotalReceived'].toString() : '0',
                                                                                          style: TextStyle(fontSize: 12),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 24.0),
                                                                                child: Text(
                                                                                  classSnap.data![classIndex]['TotalBalance'] != null ? classSnap.data![classIndex]['TotalBalance'].toString() : '0',
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        children: [

                                                                          ///  class section view.....................................................
                                                                          FutureBuilder(
                                                                            future:
                                                                                _schoolSQL.dataForSch1ClassSection(classID: classSnap.data![classIndex]['ClassID'].toString()),
                                                                            builder:
                                                                                (BuildContext context, AsyncSnapshot<List<dynamic>> sectionSnap) {
                                                                              if (sectionSnap.hasData) {
                                                                                return Column(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 30),
                                                                                      child: ListView.builder(
                                                                                        scrollDirection: Axis.vertical,
                                                                                        physics: ScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        itemCount: sectionSnap.data!.length,
                                                                                        itemBuilder: (BuildContext context, int sectionIndex) {
                                                                                          return ExpansionTile(
                                                                                            trailing: PopupMenuButton<int>(
                                                                                              initialValue: 0,
                                                                                              onSelected: (int value) async{
                                                                                                classSectionController.clear();
                                                                                                classSectionController.text =
                                                                                                    sectionSnap.data![sectionIndex]
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
                                                                                                    child: CustomDialogForClassSection
                                                                                                        .customClassSectionDialog(
                                                                                                        onPressedClose: (){
                                                                                                          Navigator.pop(context);
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
                                                                                                            id: sectionSnap.data![sectionIndex]['ID'],
                                                                                                            classSectionName: classSectionController
                                                                                                                .text
                                                                                                                .toString()
                                                                                                                .trim(),
                                                                                                            context:
                                                                                                            context,
                                                                                                          );
                                                                                                          if (updateStatus ==
                                                                                                              1) {
                                                                                                            print(
                                                                                                                'SUCCESS');
                                                                                                            ScaffoldMessenger.of(
                                                                                                                context)
                                                                                                                .showSnackBar(SnackBar(
                                                                                                                content:
                                                                                                                Text('Update Successful')));
                                                                                                            Navigator.pop(
                                                                                                                context);
                                                                                                          } else {
                                                                                                            print(
                                                                                                                'FAILED');
                                                                                                            ScaffoldMessenger.of(
                                                                                                                context)
                                                                                                                .showSnackBar(SnackBar(
                                                                                                                content:
                                                                                                                Text('Update Failed')));
                                                                                                          }
                                                                                                        },
                                                                                                        context:
                                                                                                        context),
                                                                                                  );
                                                                                                });

                                                                                                setState(() {});
                                                                                              },
                                                                                              itemBuilder: (context) => List.generate(1, (index) => PopupMenuItem(value: index, child: Text('Edit'))),
                                                                                            ),
                                                                                            leading: Icon(Icons.expand_more),
                                                                                            title: SizedBox(
                                                                                              width: MediaQuery.of(context).size.width,
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(sectionSnap.data![sectionIndex]['SectionName'].toString()),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            sectionSnap.data![sectionIndex]['TotalDue'] != null ? sectionSnap.data![sectionIndex]['TotalDue'].toString() : '0',
                                                                                                            style: TextStyle(fontSize: 12),
                                                                                                          ),
                                                                                                          Padding(
                                                                                                            padding: const EdgeInsets.only(left: 8.0),
                                                                                                            child: Text(
                                                                                                              sectionSnap.data![sectionIndex]['TotalReceived'] != null ? sectionSnap.data![sectionIndex]['TotalReceived'].toString() : '0',
                                                                                                              style: TextStyle(fontSize: 12),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 24.0),
                                                                                                    child: Text(
                                                                                                      sectionSnap.data![sectionIndex]['TotalBalance'] != null ? sectionSnap.data![sectionIndex]['TotalBalance'].toString() : '0',
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            children: [

                                                                                              /// section student view ..................................................
                                                                                              FutureBuilder(
                                                                                                future: _schoolSQL.dataForSch1ClassSectionStudent(sectionID: sectionSnap.data![sectionIndex]['SectionID'].toString()),
                                                                                                builder: (BuildContext context, AsyncSnapshot<List<dynamic>> sectionStudentSnap) {
                                                                                                  if (sectionStudentSnap.hasData) {
                                                                                                    return Column(
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.only(left: 30),
                                                                                                          child: ListView.builder(
                                                                                                            scrollDirection: Axis.vertical,
                                                                                                            physics: ScrollPhysics(),
                                                                                                            shrinkWrap: true,
                                                                                                            itemCount: sectionStudentSnap.data!.length,
                                                                                                            itemBuilder: (BuildContext context, int sectionStudentIndex) {
                                                                                                              return ExpansionTile(
                                                                                                                trailing: PopupMenuButton<int>(
                                                                                                                  initialValue: 0,
                                                                                                                  onSelected: (int value) async {
                                                                                                                    Directory? appDocDir =
                                                                                                                        await getExternalStorageDirectory();

                                                                                                                    sectionStudentController
                                                                                                                        .clear();
                                                                                                                    sectionStudentController
                                                                                                                        .text =
                                                                                                                        sectionStudentSnap.data![sectionStudentIndex]['GRN'].toString()
                                                                                                                            .trim();
                                                                                                                    sectionMonthlyFeeController.text =
                                                                                                                        sectionStudentSnap.data![sectionStudentIndex]['MonthlyFee'].toString()
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
                                                                                                                        child: CustomDialogForSectionStudent
                                                                                                                            .customSectionStudentDialog(
                                                                                                                            onPressedClose: (){
                                                                                                                              Navigator.pop(context);
                                                                                                                            },
                                                                                                                            titleHeight: 'Height',
                                                                                                                            titleWeight: 'Weight',
                                                                                                                            sectionStudentID: sectionStudentSnap.data![sectionStudentIndex]['SectionStudenID'],
                                                                                                                            status: 'UPDATE',
                                                                                                                            pathOfDir:appDocDir!.path ,
                                                                                                                            sectionID:  sectionSnap.data![sectionIndex]['SectionID'],
                                                                                                                            controllerHeight: studentHeight,
                                                                                                                            id: sectionStudentSnap.data![sectionStudentIndex]['ID'],
                                                                                                                            controllerWeight: studentWeight,
                                                                                                                            GRNTitle:
                                                                                                                            'GRN',
                                                                                                                            controllerMonthlyFee: sectionMonthlyFeeController,
                                                                                                                            titleMonthlyFee: 'monthly Fee',
                                                                                                                            grnController:
                                                                                                                            sectionStudentController,
                                                                                                                            context:
                                                                                                                            context),
                                                                                                                      );
                                                                                                                    });
                                                                                                                    setState(() {});
                                                                                                                  },
                                                                                                                  itemBuilder: (context) => List.generate(1, (index) => PopupMenuItem(value: index, child: Text('Edit'))),
                                                                                                                ),
                                                                                                                leading: Icon(Icons.expand_more),
                                                                                                                title: SizedBox(
                                                                                                                  width: MediaQuery.of(context).size.width,
                                                                                                                  child: Row(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                    children: [
                                                                                                                      Column(
                                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                        children: [
                                                                                                                          Text(sectionStudentSnap.data![sectionStudentIndex]['GRN'].toString()),
                                                                                                                          Row(
                                                                                                                            children: [
                                                                                                                              Text(
                                                                                                                                sectionStudentSnap.data![sectionStudentIndex]['TotalDue'] != null ? sectionStudentSnap.data![sectionStudentIndex]['TotalDue'].toString() : '0',
                                                                                                                                style: TextStyle(fontSize: 12),
                                                                                                                              ),
                                                                                                                              Padding(
                                                                                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                                                                                child: Text(
                                                                                                                                  sectionStudentSnap.data![sectionStudentIndex]['TotalReceived'] != null ? sectionStudentSnap.data![sectionStudentIndex]['TotalReceived'].toString() : '0',
                                                                                                                                  style: TextStyle(fontSize: 12),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          )
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                      Padding(
                                                                                                                        padding: const EdgeInsets.only(left: 24.0),
                                                                                                                        child: Text(
                                                                                                                          sectionStudentSnap.data![sectionStudentIndex]['TotalBalance'] != null ? sectionStudentSnap.data![sectionStudentIndex]['TotalBalance'].toString() : '0',
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ),
                                                                                                                children: [

                                                                                                                  /// fee due view ....................................................
                                                                                                                  FutureBuilder(
                                                                                                                    future: _schoolSQL.dataForSch1StudentFeeDue(sectionStudentID: sectionStudentSnap.data![sectionStudentIndex]['SectionStudenID'].toString()),
                                                                                                                    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> studentFeeDueSnap) {
                                                                                                                      if (studentFeeDueSnap.hasData) {
                                                                                                                        return Column(
                                                                                                                          children: [
                                                                                                                            Padding(
                                                                                                                              padding: const EdgeInsets.only(left: 30),
                                                                                                                              child: ListView.builder(
                                                                                                                                scrollDirection: Axis.vertical,
                                                                                                                                physics: ScrollPhysics(),
                                                                                                                                shrinkWrap: true,
                                                                                                                                itemCount: studentFeeDueSnap.data!.length,
                                                                                                                                itemBuilder: (BuildContext context, int studentFeeDueIndex) {
                                                                                                                                  return ExpansionTile(
                                                                                                                                    trailing: PopupMenuButton<int>(
                                                                                                                                      initialValue: 0,
                                                                                                                                      onSelected: (int value) async{
                                                                                                                                        await showGeneralDialog(
                                                                                                                                            context: context,
                                                                                                                                            pageBuilder: (BuildContext context,
                                                                                                                                            animation, secondaryAnimation) {
                                                                                                                                          dueOnDateController.text =
                                                                                                                                              currentDate.toString().substring(0, 10);
                                                                                                                                          feeNarrationController.text =
                                                                                                                                              studentFeeDueSnap.data![studentFeeDueIndex]['FeeNarration'].toString();
                                                                                                                                          feeAmountController.text =
                                                                                                                                              studentFeeDueSnap.data![studentFeeDueIndex]['FeeDueAmount'].toString();
                                                                                                                                          checkValue = true;
                                                                                                                                          return Align(
                                                                                                                                              alignment: Alignment.center,
                                                                                                                                              child: bulkFeeAllStudentYear(
                                                                                                                                                  dialogTitle: 'Due Fee on Student Edit',
                                                                                                                                                  maxID: studentFeeDueSnap.data![studentFeeDueIndex]['FeeDueID'],
                                                                                                                                                  stateName: sectionStudentSnap.data![sectionStudentIndex]['GRN'].toString(),
                                                                                                                                                  dueOnDate: dueOnDateController,
                                                                                                                                                  feeNarration:
                                                                                                                                                  feeNarrationController,
                                                                                                                                                  feeAmount: feeAmountController,
                                                                                                                                                  onPressed: () async {
                                                                                                                                                    await studentFeeDue
                                                                                                                                                        .updateStudentFeeDue(
                                                                                                                                                        GRN: studentFeeDueSnap.data![studentFeeDueIndex]['GRN'],
                                                                                                                                                        DueDate: currentDate.toString()
                                                                                                                                                            .substring(0, 10),
                                                                                                                                                        FeeDueAmount: feeAmountController
                                                                                                                                                            .text
                                                                                                                                                            .toString(),
                                                                                                                                                        FeeNarration: feeNarrationController
                                                                                                                                                            .text.toString(),
                                                                                                                                                        id: studentFeeDueSnap.data![studentFeeDueIndex]['ID']);
                                                                                                                                                    feeNarrationController.clear();
                                                                                                                                                    feeAmountController.clear();
                                                                                                                                                    dueOnDateController.clear();

                                                                                                                                                    setState(() {

                                                                                                                                                    });
                                                                                                                                                    Navigator.pop(context);
                                                                                                                                                  },
                                                                                                                                                  context: context));
                                                                                                                                        });
                                                                                                                                      },
                                                                                                                                      itemBuilder: (context) => List.generate(1, (index) => PopupMenuItem(value: index, child: Text('Edit'))),
                                                                                                                                    ),
                                                                                                                                    leading: Icon(Icons.expand_more),
                                                                                                                                    title: SizedBox(
                                                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                                                      child: Row(
                                                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                        children: [
                                                                                                                                          Column(
                                                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                            children: [
                                                                                                                                              Text('${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(studentFeeDueSnap.data![studentFeeDueIndex]['DueDate'].toString().substring(0, 4)), int.parse(studentFeeDueSnap.data![studentFeeDueIndex]['DueDate'].substring(
                                                                                                                                                    5,
                                                                                                                                                    7,
                                                                                                                                                  )), int.parse(studentFeeDueSnap.data![studentFeeDueIndex]['DueDate'].substring(8, 10)))).toString()} , ${studentFeeDueSnap.data![studentFeeDueIndex]['FeeNarration'].toString()}'),
                                                                                                                                              Row(
                                                                                                                                                children: [
                                                                                                                                                  Text(
                                                                                                                                                    studentFeeDueSnap.data![studentFeeDueIndex]['FeeDueAmount'] != null ? studentFeeDueSnap.data![studentFeeDueIndex]['FeeDueAmount'].toString() : '0',
                                                                                                                                                    style: TextStyle(fontSize: 12),
                                                                                                                                                  ),
                                                                                                                                                  Padding(
                                                                                                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                                                                                                    child: Text(
                                                                                                                                                      studentFeeDueSnap.data![studentFeeDueIndex]['TotalReceived'] != null ? studentFeeDueSnap.data![studentFeeDueIndex]['TotalReceived'].toString() : '0',
                                                                                                                                                      style: TextStyle(fontSize: 12),
                                                                                                                                                    ),
                                                                                                                                                  ),
                                                                                                                                                ],
                                                                                                                                              )
                                                                                                                                            ],
                                                                                                                                          ),
                                                                                                                                          Padding(
                                                                                                                                            padding: const EdgeInsets.only(left: 24.0),
                                                                                                                                            child: Text(
                                                                                                                                              studentFeeDueSnap.data![studentFeeDueIndex]['TotalBalance'] != null ? studentFeeDueSnap.data![studentFeeDueIndex]['TotalBalance'].toString() : '0',
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ],
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    children: [
                                                                                                                                      ///  fee received view............................................
                                                                                                                                      FutureBuilder(
                                                                                                                                        future: _schoolSQL.dataForSch1FeeReceived(feeDueID: studentFeeDueSnap.data![studentFeeDueIndex]['FeeDueID'].toString()),
                                                                                                                                        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> feeReceivedSnap) {
                                                                                                                                          if (feeReceivedSnap.hasData) {
                                                                                                                                            return Column(
                                                                                                                                              children: [
                                                                                                                                                Padding(
                                                                                                                                                  padding: const EdgeInsets.only(left: 30),
                                                                                                                                                  child: ListView.builder(
                                                                                                                                                    scrollDirection: Axis.vertical,
                                                                                                                                                    physics: ScrollPhysics(),
                                                                                                                                                    shrinkWrap: true,
                                                                                                                                                    itemCount: feeReceivedSnap.data!.length,
                                                                                                                                                    itemBuilder: (BuildContext context, int feeReceivedIndex) {
                                                                                                                                                      return ExpansionTile(
                                                                                                                                                        trailing: PopupMenuButton<int>(
                                                                                                                                                          initialValue: 0,
                                                                                                                                                          onSelected: (int value) async {
                                                                                                                                                            feeRecAmountController.text = feeReceivedSnap.data![feeReceivedIndex]['RecAmount']
                                                                                                                                                                .toString();
                                                                                                                                                            longLatController.text = feeReceivedSnap.data![feeReceivedIndex]['FeeRecRemarks']
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
                                                                                                                                                                        child: CustomDialogForFeeRec
                                                                                                                                                                            .customFeeRecDueDialog(
                                                                                                                                                                            onPressedClose: (){
                                                                                                                                                                              Navigator.pop(context);
                                                                                                                                                                            },
                                                                                                                                                                            maxID: feeReceivedSnap.data![feeReceivedIndex]['FeeRec1ID'].toString(),
                                                                                                                                                                            title: 'Receiving Amount',
                                                                                                                                                                            onTap: () async {
                                                                                                                                                                              currentDate = await showDialog(
                                                                                                                                                                                  context: context,
                                                                                                                                                                                  builder: (context) {
                                                                                                                                                                                    return DatePickerStyle1();
                                                                                                                                                                                  });
                                                                                                                                                                              state(() {

                                                                                                                                                                              });
                                                                                                                                                                            },
                                                                                                                                                                            currentDate: currentDate.toString()
                                                                                                                                                                                .substring(
                                                                                                                                                                                0, 10),
                                                                                                                                                                            remarksTitle: 'Remarks',
                                                                                                                                                                            controller: feeRecAmountController,
                                                                                                                                                                            remarksController: longLatController,
                                                                                                                                                                            onPressed: () async {
                                                                                                                                                                              await studentFeeRec
                                                                                                                                                                                  .updateStudentFeeRec(
                                                                                                                                                                                id: feeReceivedSnap.data![feeReceivedIndex]['ID'],
                                                                                                                                                                                recAmount:
                                                                                                                                                                                feeRecAmountController.text
                                                                                                                                                                                    .toString()
                                                                                                                                                                                    .trim(),
                                                                                                                                                                                context:
                                                                                                                                                                                context,
                                                                                                                                                                                feeRecRemarks: longLatController
                                                                                                                                                                                    .text.toString(),
                                                                                                                                                                                feeRecDate: feeReceivedSnap.data![feeReceivedIndex]['FeeRecDate']
                                                                                                                                                                                    .toString(),
                                                                                                                                                                              );
                                                                                                                                                                            },
                                                                                                                                                                            context: context)

                                                                                                                                                                    ),
                                                                                                                                                              );
                                                                                                                                                            });

                                                                                                                                                          },
                                                                                                                                                          itemBuilder: (context) => List.generate(1, (index) => PopupMenuItem(value: index, child: Text('Edit'))),
                                                                                                                                                        ),
                                                                                                                                                        leading: Icon(Icons.expand_more),
                                                                                                                                                        title: SizedBox(
                                                                                                                                                          width: MediaQuery.of(context).size.width,
                                                                                                                                                          child: Row(
                                                                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                                            children: [
                                                                                                                                                              Column(
                                                                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                                                children: [
                                                                                                                                                                  Text(feeReceivedSnap.data![feeReceivedIndex]['FeeRecDate'].toString()),
                                                                                                                                                                  Row(
                                                                                                                                                                    children: [
                                                                                                                                                                      Text(
                                                                                                                                                                        feeReceivedSnap.data![feeReceivedIndex]['FeeDueAmount'] != null ? feeReceivedSnap.data![feeReceivedIndex]['FeeDueAmount'].toString() : '0',
                                                                                                                                                                        style: TextStyle(fontSize: 12),
                                                                                                                                                                      ),
                                                                                                                                                                      Padding(
                                                                                                                                                                        padding: const EdgeInsets.only(left: 8.0),
                                                                                                                                                                        child: Text(
                                                                                                                                                                          feeReceivedSnap.data![feeReceivedIndex]['RecAmount'] != null ? feeReceivedSnap.data![feeReceivedIndex]['RecAmount'].toString() : '0',
                                                                                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                                                                                        ),
                                                                                                                                                                      ),
                                                                                                                                                                    ],
                                                                                                                                                                  )
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                              Padding(
                                                                                                                                                                padding: const EdgeInsets.only(left: 24.0),
                                                                                                                                                                child: Text(
                                                                                                                                                                  feeReceivedSnap.data![feeReceivedIndex]['TotalRecAmount'] != null ? feeReceivedSnap.data![feeReceivedIndex]['TotalRecAmount'].toString() : '0',
                                                                                                                                                                ),
                                                                                                                                                              ),
                                                                                                                                                            ],
                                                                                                                                                          ),
                                                                                                                                                        ),
                                                                                                                                                      );
                                                                                                                                                    },
                                                                                                                                                  ),
                                                                                                                                                ),


                                                                                                                                                /// fee recevied btn.....................................................
                                                                                                                                                TextButton(onPressed: () async{

                                                                                                                                                  int feeRecID = await studentFeeRec.maxIDForFeeRec();
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
                                                                                                                                                            child: CustomDialogForFeeRec
                                                                                                                                                                .customFeeRecDueDialog(
                                                                                                                                                              onPressedClose: (){
                                                                                                                                                                Navigator.pop(context);
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
                                                                                                                                                                await studentFeeRec
                                                                                                                                                                    .insertStudentFeeRec(

                                                                                                                                                                    feeRecDate: currentDate
                                                                                                                                                                        .toString(),
                                                                                                                                                                    feeRecRemarks: longLatController
                                                                                                                                                                        .text.toString(),

                                                                                                                                                                    feeRecAmount: double.parse(
                                                                                                                                                                        feeRecAmountController
                                                                                                                                                                            .text),

                                                                                                                                                                    feeDueID:
                                                                                                                                                                    studentFeeDueSnap.data![studentFeeDueIndex]['FeeDueID']);

                                                                                                                                                                Navigator.pop(context);
                                                                                                                                                              },
                                                                                                                                                              context:
                                                                                                                                                              context,
                                                                                                                                                              currentDate: currentDate.toString(),
                                                                                                                                                            ),
                                                                                                                                                          ),
                                                                                                                                                    );
                                                                                                                                                  });

                                                                                                                                                  setState(() {

                                                                                                                                                  });
                                                                                                                                                }, child: Text('Fee Received'))
                                                                                                                                              ],
                                                                                                                                            );
                                                                                                                                          } else {
                                                                                                                                            return CircularProgressIndicator();
                                                                                                                                          }
                                                                                                                                        },
                                                                                                                                      )
                                                                                                                                    ],
                                                                                                                                  );
                                                                                                                                },
                                                                                                                              ),
                                                                                                                            ),


                                                                                                                            /// add fee due btn....................................................
                                                                                                                            TextButton(onPressed: () async{
                                                                                                                              int feeDueID =
                                                                                                                                  await studentFeeDue
                                                                                                                                  .maxIdForStudentFeeDue();

                                                                                                                              List listData = await _schoolSQL
                                                                                                                                  .dataForBulkFeeAllStudentYear(
                                                                                                                                  whereCon: 'Sch5SectionStudent.SectionStudenID',
                                                                                                                                  iD:
                                                                                                                                  sectionStudentSnap.data![sectionStudentIndex]['SectionStudenID'].toString());


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
                                                                                                                                                stateName: sectionStudentSnap.data![sectionStudentIndex]['SectionStudenID'].toString(),
                                                                                                                                                maxID: feeDueID,
                                                                                                                                                dueOnDate: dueOnDateController,
                                                                                                                                                feeNarration:
                                                                                                                                                feeNarrationController,
                                                                                                                                                feeAmount: feeAmountController,
                                                                                                                                                onPressed: () async {
                                                                                                                                                  if (formKey.currentState!
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
                                                                                                                                                              .toString().substring(
                                                                                                                                                              0, 10).toString(),
                                                                                                                                                          sectionStudentID: listData[i]
                                                                                                                                                          ['SectionID'],
                                                                                                                                                          grn: listData[i]
                                                                                                                                                          ['GRN']);
                                                                                                                                                    }
                                                                                                                                                    feeNarrationController.clear();
                                                                                                                                                    feeAmountController.clear();
                                                                                                                                                    dueOnDateController.clear();

                                                                                                                                                    setState(() {});
                                                                                                                                                    Navigator.pop(context);
                                                                                                                                                  }
                                                                                                                                                },
                                                                                                                                                context: context),
                                                                                                                                          )),
                                                                                                                                    );
                                                                                                                                  });

                                                                                                                              setState(() {});
                                                                                                                            }, child: Text('Due Fee'))
                                                                                                                          ],
                                                                                                                        );
                                                                                                                      } else {
                                                                                                                        return CircularProgressIndicator();
                                                                                                                      }
                                                                                                                    },
                                                                                                                  )
                                                                                                                ],
                                                                                                              );
                                                                                                            },
                                                                                                          ),
                                                                                                        ),


                                                                                                        /// add section student btn..................................................
                                                                                                        TextButton(onPressed: ()async {
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
                                                                                                              child: CustomDialogForSectionStudent
                                                                                                                  .customSectionStudentDialog(
                                                                                                                  onPressedClose: (){
                                                                                                                    Navigator.pop(context);
                                                                                                                  },
                                                                                                                  titleHeight: 'Height',
                                                                                                                  titleWeight: 'Weight',
                                                                                                                  status: 'SAVE',
                                                                                                                  controllerHeight: studentHeight,
                                                                                                                  controllerWeight: studentWeight,
                                                                                                                  sectionID:  sectionSnap.data![sectionIndex]['SectionID'],
                                                                                                                  GRNTitle:
                                                                                                                  'GRN',
                                                                                                                  titleMonthlyFee: 'Monthly Fee',
                                                                                                                  controllerMonthlyFee: sectionMonthlyFeeController,
                                                                                                                  grnController:
                                                                                                                  sectionStudentController,
                                                                                                                  context:
                                                                                                                  context),
                                                                                                            );
                                                                                                          });

                                                                                                          setState(() {});


                                                                                                        }, child: Text('ADD Student'))
                                                                                                      ],
                                                                                                    );
                                                                                                  } else {
                                                                                                    return CircularProgressIndicator();
                                                                                                  }
                                                                                                },
                                                                                              )
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ),


                                                                                    /// add section btn .......................................................
                                                                                    TextButton(onPressed: () async{
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
                                                                                          child: CustomDialogForClassSection
                                                                                              .customClassSectionDialog(
                                                                                              onPressedClose: (){
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              title:
                                                                                              'Class Section',
                                                                                              controller:
                                                                                              classSectionController,
                                                                                              onPressed:
                                                                                                  () async {
                                                                                                if (formKey.currentState!.validate()) {
                                                                                                  await classSection
                                                                                                      .insertCLassesSection(
                                                                                                      context:
                                                                                                      context,
                                                                                                      sectionName: classSectionController
                                                                                                          .text
                                                                                                          .toString(),
                                                                                                      classid:
                                                                                                      classSnap.data![classIndex]['ClassID']);

                                                                                                  Navigator.pop(context);
                                                                                                }
                                                                                              },
                                                                                              context:
                                                                                              context),
                                                                                        );
                                                                                      });

                                                                                      setState(() {});
                                                                                    }, child: Text('ADD Section'))
                                                                                  ],
                                                                                );
                                                                              } else {
                                                                                return CircularProgressIndicator();
                                                                              }
                                                                            },
                                                                          )
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ),

                                                                /// add class btn .............................................
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
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
                                                                              child: CustomDialogForClasses
                                                                                  .customDialog(
                                                                                  onPressedClose: (){
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  title:
                                                                                  'ADD Classes',
                                                                                  controller:
                                                                                  yearEducationController,
                                                                                  onPressed:
                                                                                      () async {
                                                                                    if (formKey.currentState!.validate()) {
                                                                                      await yearClasses.insertCLasses(
                                                                                          context:
                                                                                          context,
                                                                                          educationalYearID: yearSnap
                                                                                              .data![
                                                                                          indexYearEducation]
                                                                                          [
                                                                                          'EducationalYearID'],
                                                                                          className: yearEducationController
                                                                                              .text
                                                                                              .toString());

                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                  context:
                                                                                  context),
                                                                            );
                                                                          });

                                                                          setState(() {});
                                                                    },
                                                                    child: Text(
                                                                        'ADD Classes'))
                                                              ],
                                                            );
                                                          } else {
                                                            return CircularProgressIndicator();
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),

                                            /// add year btn ............................................
                                            TextButton(
                                                onPressed: () async{
                                                  yearEducationController.clear();
                                                  await showGeneralDialog(
                                                      context: context,
                                                      pageBuilder:
                                                      (BuildContext context,
                                                      animation,
                                                      secondaryAnimation) {
                                                    return Align(
                                                      alignment: Alignment.center,
                                                      child: YearEducationalDialog
                                                          .yearEducationalDialog(
                                                          onPressedClose: (){
                                                            Navigator.pop(context);
                                                          },
                                                          title:
                                                          'ADD Year Education',
                                                          controller:
                                                          yearEducationController,
                                                          onPressed:
                                                              () async {
                                                            if (formKey.currentState!.validate()) {
                                                              String valueStatus = await schoolYear
                                                                  .insetYearEducation(
                                                                  context:
                                                                  context,
                                                                  educationalYear:
                                                                  yearEducationController
                                                                      .text
                                                                      .toString(),
                                                                  branchID: branchSnap.data![indexBranch]
                                                                  ['BranchID']);
                                                              if (valueStatus != 'Insert') {
                                                                showDialog(context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      content: Text(valueStatus),
                                                                      actions: [
                                                                        TextButton(onPressed: () {
                                                                          Navigator.pop(context);
                                                                        }, child: Text('ok'))
                                                                      ],);
                                                                  },);
                                                              } else {
                                                                Navigator.pop(context);
                                                              }
                                                            }
                                                          },
                                                          context: context),
                                                    );
                                                  });

                                                  setState(() {});
                                                },
                                                child: Text('ADD Year'))
                                          ],
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          ),

                          ///     add branches   btn........................................................
                          ElevatedButton(
                              onPressed: () async {
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
                                          child: branchDialog(
                                              onPressedClose: (){
                                                Navigator.pop(context);
                                              },
                                              name: nameController,
                                              Address: addressController,
                                              ContactNumber:
                                                  contactNumberController,
                                              LongLat: longLatController,
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

                                                  Navigator.pop(context);
                                                }
                                              },
                                              context: context));
                                    });

                                setState(() {});
                              },
                              child: Text('ADD Branches Of your School')),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget bulkFeeAllStudentYear({required TextEditingController dueOnDate,
    required TextEditingController feeNarration,
    required TextEditingController feeAmount,
    required void Function()? onPressed,
    required String dialogTitle,
    String? stateName = '',
    required int maxID,
    required BuildContext context}) {
    return SingleChildScrollView(
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

                        child: SwitchListTile(contentPadding: EdgeInsets.all(0),
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
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ) // foreground
                                  ),
                                  onPressed: onPressed,
                                  child: Text(
                                    'SAVE',
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
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ) // foreground
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'CLOSE',
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
    );
  }
}
