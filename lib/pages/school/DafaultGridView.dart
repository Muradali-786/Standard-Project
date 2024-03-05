import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'modelFeeDue.dart';
import 'modelclasseducation.dart';
import 'modelschoolbranch.dart';
import 'modelsection.dart';
import 'modelsectionstudent.dart';
import 'modelshowyearlistview.dart';
import 'modelyeareducation.dart';

class DefaultGridView extends StatefulWidget {
  final List schBranches;

  const DefaultGridView({required this.schBranches, Key? key})
      : super(key: key);

  @override
  State<DefaultGridView> createState() => _DefaultGridViewState();
}

class _DefaultGridViewState extends State<DefaultGridView> {
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
  ClassSection classSection = ClassSection();
  SectionStudent sectionStudent = SectionStudent();
  StudentFeeDue studentFeeDue = StudentFeeDue();
  StudentFeeRec studentFeeRec = StudentFeeRec();
  YearClasses yearClasses = YearClasses();
  SchoolYear schoolYear = SchoolYear();
  SchoolBranches schoolBranches = SchoolBranches();
  SchoolSQL _schoolSQL = SchoolSQL();
  double fontSize = 40;
  int sliderValue = 3;
  double opacity = 0;
  String grnOfStudent = '';
  var currentDate = DateTime.now();
  String checkValueTitle = 'Monthly Fee';
  bool checkValue = false;


  @override
  void initState() {
    super.initState();
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


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          modelShowYearListView.status == 'Branch'
              ? FutureBuilder(
            future: _schoolSQL.dataForSch1Branch(),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> branchSnap) {
              if (branchSnap.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sliderValue,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: branchSnap.data!.length + 1,
                  itemBuilder: (context, branchIndex) {
                    return branchIndex == branchSnap.data!.length
                        ? ElevatedButton(
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
                                        name: nameController,
                                        Address:
                                        addressController,
                                        onPressedClose: (){
                                          Navigator.pop(context);
                                        },
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

                                            Navigator.pop(context);
                                          }
                                        },
                                        context: context));
                              });

                          setState(() {});
                        },
                        child: Text('Add Campus', textAlign: TextAlign.center,))
                        : GestureDetector(
                        onLongPress: () {
                          nameController.text =
                              branchSnap.data![branchIndex]['BranchName']
                                  .toString();
                          longLatController.text =
                              branchSnap.data![branchIndex]['LongLat']
                                  .toString();

                          contactNumberController.text =
                              branchSnap.data![branchIndex]['ContactNo']
                                  .toString();

                          addressController.text =
                              branchSnap.data![branchIndex]['Address']
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
                                        SchoolBranches
                                        schoolBranch =
                                        SchoolBranches();

                                        await schoolBranch
                                            .updateSchoolBranches(
                                            id:
                                            branchSnap.data![branchIndex]['ID'],
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
                        onTap: () {
                          modelSchoolBranchSystem.setName(
                            branchSnap.data![branchIndex]['BranchName']
                                .toString(),
                          );
                          modelSchoolBranchSystem
                              .setID(branchSnap.data![branchIndex]['BranchID']);
                          modelSchoolBranchSystem.opacity = 1.0;
                          modelShowYearListView.setStatus('Year');
                          setState(() {});
                        },
                        child: customGridView(
                            name: branchSnap.data![branchIndex]
                            ['BranchName']
                                .toString(),
                            billing: branchSnap
                                .data![branchIndex]['TotalDue'] != null
                                ? branchSnap.data![branchIndex]['TotalDue']
                                .toString()
                                : '0',
                            received: branchSnap.data![branchIndex]
                            ['TotalReceived'] !=
                                null
                                ? branchSnap.data![branchIndex]
                            ['TotalReceived']
                                .toString()
                                : '0',
                            balance: branchSnap
                                .data![branchIndex]['TotalBalance'] != null
                                ? branchSnap.data![branchIndex]
                            ['TotalBalance']
                                .toString()
                                : '0'));
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
              : 'Year' == modelShowYearListView.getStatus()
              ? FutureBuilder(

            future: _schoolSQL.dataForSch1EducationYear(
                branchID: modelSchoolBranchSystem.id.toString()),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> yearSnap) {
              if (yearSnap.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sliderValue,

                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: yearSnap.data!.length + 1,
                  itemBuilder: (context, yearIndex) {
                    return yearIndex == yearSnap.data!.length
                        ? ElevatedButton(
                        onPressed: () async {
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
                                              branchID: modelSchoolBranchSystem
                                                  .id);

                                          print(
                                              '...............  $valueStatus');

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
                        child: Text('Add'))
                        : GestureDetector(
                      onLongPress: () async {
                        yearEducationController.clear();
                        yearEducationController.text =
                            yearSnap.data![yearIndex]['EducationalYear']
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
                                          id: yearSnap.data![yearIndex]['ID'],
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
                      onTap: () {
                        setState(() {
                          modelYearEducation.setName(
                            yearSnap.data![yearIndex]['EducationalYear']
                                .toString(),
                          );
                          modelYearEducation
                              .setID(
                              yearSnap.data![yearIndex]['EducationalYearID']);
                          modelYearEducation.opacity = 1.0;

                          modelShowYearListView
                              .setStatus('Classes');
                        });
                      },
                      child: customGridView(
                          name: yearSnap.data![yearIndex]
                          ['EducationalYear']
                              .toString(),
                          billing: yearSnap.data![yearIndex]['TotalDue'] != null
                              ? yearSnap.data![yearIndex]['TotalDue']
                              .toString()
                              : '0',
                          received: yearSnap
                              .data![yearIndex]['TotalReceived'] != null
                              ? yearSnap.data![yearIndex]
                          ['TotalReceived']
                              .toString()
                              : '0',
                          balance: yearSnap.data![yearIndex]['TotalBalance'] !=
                              null ? yearSnap.data![yearIndex]['TotalBalance']
                              .toString() : '0'),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
              : 'Classes' == modelShowYearListView.getStatus()
              ? FutureBuilder(
            future: _schoolSQL.dataForSch1EducationYearClass(
                educationalYearID:
                modelYearEducation.id.toString()),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> classSnap) {
              if (classSnap.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sliderValue,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount:
                  classSnap.data!.length + 1,
                  itemBuilder: (context, index) {
                    return index ==
                        classSnap.data!
                            .length
                        ? ElevatedButton(
                        onPressed: () async {
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
                                              educationalYearID: modelYearEducation
                                                  .id,
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
                        child: Text('Add'))
                        : GestureDetector(
                      onLongPress: () async {
                        yearEducationController
                            .clear();
                        yearEducationController.text =
                            classSnap.data![index]
                            ['ClassName']
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
                                          id: classSnap.data![index]['ID'],
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
                      onTap: () {
                        setState(() {
                          modelClassEducation.setName(
                            classSnap.data![index]['ClassName'].toString(),
                          );
                          modelShowYearListView
                              .setStatus(
                              'ClassesSection');
                          modelClassEducation
                              .setID(classSnap.data![index]['ClassID']);

                          modelClassEducation.opacity =
                          1.0;
                        });
                      },
                      child: customGridView(
                          name: classSnap.data![index]['ClassName']
                              .toString(),
                          billing: classSnap.data![index]['TotalDue'] != null
                              ? classSnap.data![index]['TotalDue']
                              .toString()
                              : '0',
                          received: classSnap.data![index]['TotalReceived'] !=
                              null ? classSnap.data![index]['TotalReceived']
                              .toString() : '0',
                          balance: classSnap.data![index]['TotalBalance'] !=
                              null ? classSnap.data![index]['TotalBalance']
                              .toString() : '0'),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
              : 'ClassesSection' == modelShowYearListView.getStatus()
              ? FutureBuilder(
            future: _schoolSQL.dataForSch1ClassSection(
                classID: modelClassEducation.id.toString()),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> sectionSnap) {
              if (sectionSnap.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sliderValue,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount:
                  sectionSnap.data!.length + 1,
                  itemBuilder: (context, sectionIndex) {
                    return sectionIndex ==
                        sectionSnap.data!
                            .length
                        ? ElevatedButton(
                        onPressed: () async {
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
                                              modelClassEducation.id);

                                          Navigator.pop(context);
                                        }
                                      },
                                      context:
                                      context),
                                );
                              });

                          setState(() {});
                        },
                        child: Text('Add'))
                        : GestureDetector(
                      onLongPress: () async {
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
                                        id: sectionSnap
                                            .data![sectionIndex]['ID'],
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
                      onTap: () {
                        setState(() {
                          modelShowSectionListView
                              .setName(
                            sectionSnap.data![sectionIndex]['SectionName']
                                .toString(),
                          );
                          modelShowYearListView.setStatus(
                              'SectionStudent');
                          modelShowSectionListView
                              .setID(
                              sectionSnap.data![sectionIndex]['SectionID']);
                          modelShowSectionListView
                              .opacity = 1.0;
                        });
                      },
                      child: customGridView(
                          name: sectionSnap.data![sectionIndex]['SectionName']
                              .toString(),
                          billing: sectionSnap
                              .data![sectionIndex]['TotalDue'] != null
                              ? sectionSnap.data![sectionIndex]['TotalDue']
                              .toString()
                              : '0',
                          received: sectionSnap
                              .data![sectionIndex]['TotalReceived'] != null
                              ? sectionSnap.data![sectionIndex]['TotalReceived']
                              .toString()
                              : '0',
                          balance: sectionSnap
                              .data![sectionIndex]['TotalBalance'] != null
                              ? sectionSnap.data![sectionIndex]['TotalBalance']
                              .toString()
                              : '0'),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
              : 'SectionStudent' == modelShowYearListView.getStatus()
              ? FutureBuilder(
            future: _schoolSQL.dataForSch1ClassSectionStudent(
                sectionID: modelShowSectionListView.id
                    .toString()),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> sectionStudentSnap) {
              if (sectionStudentSnap.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sliderValue,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount:
                  sectionStudentSnap.data!.length + 1,
                  itemBuilder: (context, sectionStudentIndex) {
                    return sectionStudentIndex ==
                        sectionStudentSnap.data!
                            .length
                        ? ElevatedButton(
                        onPressed: () async {
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
                                      sectionID: modelShowSectionListView.id,
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
                        },
                        child: Text('Add'))
                        : GestureDetector(
                      onLongPress: () async {
                        Directory? appDocDir =
                        await getExternalStorageDirectory();

                        sectionStudentController
                            .clear();
                        sectionStudentController
                            .text =
                            sectionStudentSnap
                                .data![sectionStudentIndex]['GRN'].toString()
                                .trim();
                        sectionMonthlyFeeController.text =
                            sectionStudentSnap
                                .data![sectionStudentIndex]['MonthlyFee']
                                .toString()
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
                                    sectionStudentID: sectionStudentSnap
                                        .data![sectionStudentIndex]['SectionStudenID'],
                                    status: 'UPDATE',
                                    pathOfDir: appDocDir!.path,
                                    sectionID: modelShowSectionListView.id,
                                    controllerHeight: studentHeight,
                                    id: sectionStudentSnap
                                        .data![sectionStudentIndex]['ID'],
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
                      onTap: () {
                        setState(() {
                          modelsectionStudent.setName(
                              '${sectionStudentSnap
                                  .data![sectionStudentIndex]['GRN']
                                  .toString()}  ${sectionStudentSnap
                                  .data![sectionStudentIndex]['StudentName']
                                  .toString()}'
                          );
                          modelShowYearListView
                              .setStatus(
                              'StudentFeeDue');
                          grnOfStudent = sectionStudentSnap
                              .data![sectionStudentIndex]['GRN'].toString();


                          modelsectionStudent.setID(
                              sectionStudentSnap
                                  .data![sectionStudentIndex]['SectionStudenID']);

                          modelsectionStudent
                              .opacity = 1.0;
                        });
                      },
                      child: customGridView(
                          name: '${sectionStudentSnap
                              .data![sectionStudentIndex]['GRN']
                              .toString()}  ${sectionStudentSnap
                              .data![sectionStudentIndex]['StudentName']
                              .toString()}',
                          billing: sectionStudentSnap
                              .data![sectionStudentIndex]['TotalDue'] != null
                              ? sectionStudentSnap
                              .data![sectionStudentIndex]['TotalDue']
                              .toString()
                              : '0',
                          received: sectionStudentSnap
                              .data![sectionStudentIndex]['TotalReceived'] !=
                              null ? sectionStudentSnap
                              .data![sectionStudentIndex]['TotalReceived']
                              .toString() : '0',
                          balance: sectionStudentSnap
                              .data![sectionStudentIndex]['TotalBalance'] !=
                              null ? sectionStudentSnap
                              .data![sectionStudentIndex]['TotalBalance']
                              .toString() : '0'),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
              : 'StudentFeeDue' == modelShowYearListView.getStatus()
              ? FutureBuilder(
            future: _schoolSQL.dataForSch1StudentFeeDue(
                sectionStudentID:
                modelsectionStudent.id.toString()),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> feeDueSnap) {
              if (feeDueSnap.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sliderValue,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount:
                  feeDueSnap.data!.length + 1,
                  itemBuilder: (context, feeDueIndex) {
                    return feeDueIndex ==
                        feeDueSnap.data!
                            .length
                        ? ElevatedButton(
                        onPressed: () async {
                          int feeDueID =
                          await studentFeeDue
                              .maxIdForStudentFeeDue();

                          List listData = await _schoolSQL
                              .dataForBulkFeeAllStudentYear(
                              whereCon: 'Sch5SectionStudent.SectionStudenID',
                              iD:
                              modelsectionStudent
                                  .id.toString());

                          print('....${modelsectionStudent
                              .id.toString()}......${listData.length}');

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
                        },
                        child: Text('Add'))
                        : GestureDetector(
                      onLongPress: () async {
                        await showGeneralDialog(
                            context: context,
                            pageBuilder: (BuildContext context,
                                animation, secondaryAnimation) {
                              dueOnDateController.text =
                                  currentDate.toString().substring(0, 10);
                              feeNarrationController.text =
                                  feeDueSnap.data![feeDueIndex]['FeeNarration']
                                      .toString();
                              feeAmountController.text =
                                  feeDueSnap.data![feeDueIndex]['FeeDueAmount']
                                      .toString();
                              checkValue = true;
                              return Align(
                                  alignment: Alignment.center,
                                  child: bulkFeeAllStudentYear(
                                      dialogTitle: 'Due Fee on Student Edit',
                                      maxID: feeDueSnap
                                          .data![feeDueIndex]['FeeDueID'],
                                      stateName: modelsectionStudent
                                          .getName(),
                                      dueOnDate: dueOnDateController,
                                      feeNarration:
                                      feeNarrationController,
                                      feeAmount: feeAmountController,
                                      onPressed: () async {
                                        await studentFeeDue
                                            .updateStudentFeeDue(
                                            GRN: feeDueSnap
                                                .data![feeDueIndex]['GRN'],
                                            DueDate: currentDate.toString()
                                                .substring(0, 10),
                                            FeeDueAmount: feeAmountController
                                                .text
                                                .toString(),
                                            FeeNarration: feeNarrationController
                                                .text.toString(),
                                            id: feeDueSnap
                                                .data![feeDueIndex]['ID']);
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
                      onTap: () {
                        setState(() {
                          modelFeeDueList.setName(
                            feeDueSnap.data![feeDueIndex]['FeeNarration']
                                .toString(),
                          );
                          modelShowYearListView
                              .setStatus(
                              'FeeRec2');
                          modelFeeDueList.setID(
                              feeDueSnap.data![feeDueIndex]['FeeDueID']);
                          modelFeeDueList
                              .opacity = 1.0;
                        });
                      },
                      child: customGridView(
                          name: feeDueSnap.data![feeDueIndex]['DueDate'] == null
                              ? ' '
                              : '${DateFormat(
                              SharedPreferencesKeys.prefs!.getString(
                                  SharedPreferencesKeys.dateFormat))
                              .format(DateTime(int.parse(
                              feeDueSnap.data![feeDueIndex]['DueDate']
                                  .toString()
                                  .substring(0, 4)),
                              int.parse(feeDueSnap.data![feeDueIndex]['DueDate']
                                  .substring(
                                5,
                                7,
                              )), int.parse(
                                  feeDueSnap.data![feeDueIndex]['DueDate']
                                      .substring(8, 10))))
                              .toString()} , ${feeDueSnap
                              .data![feeDueIndex]['FeeNarration']
                              .toString()}',
                          billing: feeDueSnap
                              .data![feeDueIndex]['TotalFeeDueAmountDue'] !=
                              null ? feeDueSnap
                              .data![feeDueIndex]['FeeDueAmount']
                              .toString() : '0',
                          received: feeDueSnap
                              .data![feeDueIndex]['TotalReceived'] != null
                              ? feeDueSnap.data![feeDueIndex]['TotalReceived']
                              .toString()
                              : '0',
                          balance: feeDueSnap
                              .data![feeDueIndex]['TotalBalance'] != null
                              ? feeDueSnap.data![feeDueIndex]['TotalBalance']
                              .toString()
                              : '0'),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
              : FutureBuilder(
            future: _schoolSQL.dataForSch1FeeReceived(
                feeDueID:
                modelFeeDueList.id.toString()),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> feeReceivedSnap) {
              if (feeReceivedSnap.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sliderValue,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount:
                  feeReceivedSnap.data!.length + 1,
                  itemBuilder: (context, feeReceivedIndex) {
                    return feeReceivedIndex ==
                        feeReceivedSnap.data!
                            .length
                        ? ElevatedButton(
                        onPressed: () async {
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
                                                modelFeeDueList.id);

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
                        },
                        child: Text('Add'))
                        : GestureDetector(
                      onLongPress: () async {
                        feeRecAmountController.text = feeReceivedSnap
                            .data![feeReceivedIndex]['RecAmount']
                            .toString();
                        longLatController.text = feeReceivedSnap
                            .data![feeReceivedIndex]['FeeRecRemarks']
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
                                            maxID: feeReceivedSnap
                                                .data![feeReceivedIndex]['FeeRec1ID']
                                                .toString(),
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
                                                id: feeReceivedSnap
                                                    .data![feeReceivedIndex]['ID'],
                                                recAmount:
                                                feeRecAmountController.text
                                                    .toString()
                                                    .trim(),
                                                context:
                                                context,
                                                feeRecRemarks: longLatController
                                                    .text.toString(),
                                                feeRecDate: feeReceivedSnap
                                                    .data![feeReceivedIndex]['FeeRecDate']
                                                    .toString(),
                                              );
                                            },
                                            context: context)

                                    ),
                              );
                            });

                        setState(() {});
                      },

                      child: customGridView(
                          name: feeReceivedSnap
                              .data![feeReceivedIndex]['FeeRecDate']
                              .toString(),
                          billing: feeReceivedSnap
                              .data![feeReceivedIndex]['FeeDueAmount'] != null
                              ? feeReceivedSnap
                              .data![feeReceivedIndex]['FeeDueAmount']
                              .toString()
                              : '0',
                          received: feeReceivedSnap
                              .data![feeReceivedIndex]['RecAmount'] != null
                              ? feeReceivedSnap
                              .data![feeReceivedIndex]['RecAmount']
                              .toString()
                              : '0',
                          balance: feeReceivedSnap
                              .data![feeReceivedIndex]['TotalRecAmount'] != null
                              ? feeReceivedSnap
                              .data![feeReceivedIndex]['TotalRecAmount']
                              .toString()
                              : '0'),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    setState(() {
                      opacity = 1;
                    });
                  },
                  icon: Icon(Icons.settings)),
              Opacity(
                opacity: opacity,
                child: Slider(
                    value: sliderValue.toDouble(),
                    min: 1.0,
                    max: 5.0,
                    onChanged: (double value) {
                      setState(() {
                        sliderValue = value.toInt();
                        //  share.setInt('gridValueCount', value.toInt());
                      });
                    }),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget customGridView({required String name,
    required String billing,
    required String received,
    required String balance}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
      ),
      child: Column(
        children: [
          Flexible(flex: 6, child: Center(child: Text(name))),
          Flexible(
            flex: 4,
            child: Row(
              children: [
                Flexible(
                    flex: 5,
                    child: Center(
                      child: Column(
                        children: [
                          Flexible(
                              flex: 5,
                              child: Center(
                                child: Text(billing),
                              )),
                          Flexible(
                              flex: 5,
                              child: Center(
                                child: Text(received),
                              ))
                        ],
                      ),
                    )),
                Flexible(
                    flex: 5,
                    child: Center(
                      child: Text(balance),
                    )),
              ],
            ),
          )
        ],
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
