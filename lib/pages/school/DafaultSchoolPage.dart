import 'package:com/pages/general_trading/Accounts/AccontTreeview.dart';
import 'package:com/pages/school/DafaultGridView.dart';
import 'package:com/pages/school/DafaultListView.dart';
import 'package:com/pages/school/DafaultTreeView.dart';
import 'package:com/pages/school/modelclasseducation.dart';
import 'package:com/pages/school/modelschoolbranch.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import 'modelFeeDue.dart';
import 'modelsection.dart';
import 'modelsectionstudent.dart';
import 'modelshowyearlistview.dart';
import 'modelyeareducation.dart';

class DefaultSchoolPage extends StatefulWidget {
  final String menuName;

  const DefaultSchoolPage({Key? key, required this.menuName}) : super(key: key);

  @override
  DefaultSchoolPageState createState() => DefaultSchoolPageState();
}

class DefaultSchoolPageState extends State<DefaultSchoolPage> {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  List originalList = [];
  List sch1Branch = [];
  TextEditingController _searchController = TextEditingController();
  IconData iconData = Icons.list;
  int creditTotal = 0;
  int debitTotal = 0;
  int creditTotalCopy = 0;
  int debitTotalCopy = 0;
  String showStatusView = 'Branch';
  bool isDecending = false;
  SharedPreferences? sharedPreferences;
  bool isDecendingDebit = false;
  bool isDecendingCredit = false;
  int selected = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContextMain) {
    var modelSchoolBranchSystem =
        Provider.of<ModelSchoolBranchSystem>(buildContextMain, listen: false);
    var modelYearEducation =
        Provider.of<ModelYearEducation>(buildContextMain, listen: false);
    var modelShowYearListView =
        Provider.of<ModelShowYearListView>(buildContextMain, listen: false);
    var modelClassEducation =
        Provider.of<ModelClassEducation>(buildContextMain, listen: false);
    var modelshowsectionListview =
        Provider.of<ModelShowSectionListView>(buildContextMain, listen: false);
    var modelsectionStudentList =
        Provider.of<ModelSectionStudentList>(buildContextMain, listen: false);
    var modelFeeDueList =
        Provider.of<ModelFeeDueList>(buildContextMain, listen: false);

    return  WillPopScope(
          onWillPop: () async{
            bool exit = false;

            print('................Branch.......Year.. Classes.. ClassesSection...SectionStudent .....StudentFeeDue........................');

            if(Provider.of<ModelShowYearListView>(context, listen: false).getStatus() == 'Branch'){

              exit = true;

            } else if (Provider.of<ModelShowYearListView>(context, listen: false).getStatus() == 'Year'){
              setState(() {
                modelShowYearListView.setStatus('Branch');
                modelSchoolBranchSystem.setName('');
                modelSchoolBranchSystem.setOpacity(0.0);
                modelYearEducation.setName('');
                modelYearEducation.setOpacity(0.0);
                modelClassEducation.setName('');
                modelClassEducation.setOpacity(0.0);
                modelshowsectionListview.setName('');
                modelshowsectionListview.setOpacity(0.0);
                modelsectionStudentList.setName('');
                modelsectionStudentList.setOpacity(0.0);
                modelFeeDueList.setName('');
                modelFeeDueList.setOpacity(0.0);
              });
            }else if(Provider.of<ModelShowYearListView>(context, listen: false).getStatus() == 'Classes'){
              setState(() {
                modelShowYearListView.setStatus('Year');
                modelYearEducation.setName('');
                modelYearEducation.setOpacity(0.0);
                modelClassEducation.setName('');
                modelClassEducation.setOpacity(0.0);
                modelshowsectionListview.setName('');
                modelshowsectionListview.setOpacity(0.0);
                modelsectionStudentList.setName('');
                modelsectionStudentList.setOpacity(0.0);
                modelFeeDueList.setName('');
                modelFeeDueList.setOpacity(0.0);
              });
            }else if(Provider.of<ModelShowYearListView>(context, listen: false).getStatus() == 'ClassesSection'){
              setState(() {
                modelShowYearListView.setStatus('Classes');
                modelClassEducation.setName('');
                modelClassEducation.setOpacity(0.0);
                modelshowsectionListview.setName('');
                modelshowsectionListview.setOpacity(0.0);
                modelsectionStudentList.setName('');
                modelsectionStudentList.setOpacity(0.0);
                modelshowsectionListview.setName('');
                modelshowsectionListview.setOpacity(0.0);
                modelFeeDueList.setName('');
                modelFeeDueList.setOpacity(0.0);
              });
            }else  if(Provider.of<ModelShowYearListView>(context, listen: false).getStatus() == 'SectionStudent'){
              setState(() {
                modelShowYearListView.setStatus('ClassesSection');
                modelshowsectionListview.setName('');
                modelshowsectionListview.setOpacity(0.0);
                modelsectionStudentList.setName('');
                modelsectionStudentList.setOpacity(0.0);
                modelFeeDueList.setName('');
                modelFeeDueList.setOpacity(0.0);
              });
            }else if(Provider.of<ModelShowYearListView>(context, listen: false).getStatus() == 'StudentFeeDue'){
              setState(() {
                modelShowYearListView.setStatus('SectionStudent');

                modelFeeDueList.setName('');
                modelFeeDueList.setOpacity(0.0);
                modelsectionStudentList.setName('');
                modelsectionStudentList.setOpacity(0.0);
                modelFeeDueList.setName('');
                modelFeeDueList.setOpacity(0.0);
              });
            }else{
              setState(() {
                modelShowYearListView.setStatus('StudentFeeDue');
                modelFeeDueList.setName('');
                modelFeeDueList.setOpacity(0.0);
              });
            }
            return exit;
          },
          child: Scaffold(
            backgroundColor:
                Provider.of<ThemeDataHomePage>(context, listen: false)
                    .backGroundColor,
            body: Padding(
              padding:  EdgeInsets.only( bottom: MediaQuery.of(context).size.height *.05),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                          IconButton(
                            onPressed: () {
                              showMenu<IconData>(
                                context: context,
                                position: RelativeRect.fromLTRB(30.0, 30.0, 40.0, 0.0),
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
                              onPressed: () {
                                Navigator.pop(context);

                              },
                              icon: Icon(Icons.home)),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  modelShowYearListView.setStatus('Branch');
                                  modelSchoolBranchSystem.setName('');
                                  modelSchoolBranchSystem.setOpacity(0.0);
                                  modelYearEducation.setName('');
                                  modelYearEducation.setOpacity(0.0);
                                  modelClassEducation.setName('');
                                  modelClassEducation.setOpacity(0.0);
                                  modelshowsectionListview.setName('');
                                  modelshowsectionListview.setOpacity(0.0);
                                  modelsectionStudentList.setName('');
                                  modelsectionStudentList.setOpacity(0.0);
                                  modelFeeDueList.setName('');
                                  modelFeeDueList.setOpacity(0.0);
                                });
                              },
                              child: Text(
                                    'Campus',
                                    style: TextStyle(color: Colors.blue[900]))),
                          Icon(Icons.arrow_right_outlined),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  modelShowYearListView.setStatus('Year');
                                  modelYearEducation.setName('');
                                  modelYearEducation.setOpacity(0.0);
                                  modelClassEducation.setName('');
                                  modelClassEducation.setOpacity(0.0);
                                  modelshowsectionListview.setName('');
                                  modelshowsectionListview.setOpacity(0.0);
                                  modelsectionStudentList.setName('');
                                  modelsectionStudentList.setOpacity(0.0);
                                  modelFeeDueList.setName('');
                                  modelFeeDueList.setOpacity(0.0);
                                });
                              },
                              child: Consumer<ModelSchoolBranchSystem>(
                                  builder: (context, value, child) => Text(
                                        modelSchoolBranchSystem.getName(),
                                        style: TextStyle(color: Colors.blue[900]),
                                      ))),
                          Consumer<ModelSchoolBranchSystem>(
                              builder: (context, value, child) => Opacity(
                                  opacity: modelSchoolBranchSystem.opacity,
                                  child: Icon(Icons.arrow_right_outlined))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  modelShowYearListView.setStatus('Classes');
                                  modelClassEducation.setName('');
                                  modelClassEducation.setOpacity(0.0);
                                  modelshowsectionListview.setName('');
                                  modelshowsectionListview.setOpacity(0.0);
                                  modelsectionStudentList.setName('');
                                  modelsectionStudentList.setOpacity(0.0);
                                  modelshowsectionListview.setName('');
                                  modelshowsectionListview.setOpacity(0.0);
                                  modelFeeDueList.setName('');
                                  modelFeeDueList.setOpacity(0.0);
                                });
                              },
                              child: Consumer<ModelYearEducation>(
                                  builder: (context, value, child) => Text(
                                      modelYearEducation.getName(),
                                      style: TextStyle(color: Colors.green[900])))),
                          Consumer<ModelYearEducation>(
                              builder: (context, value, child) => Opacity(
                                  opacity: modelYearEducation.opacity,
                                  child: Icon(Icons.arrow_right_outlined))),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                modelShowYearListView.setStatus('ClassesSection');
                                modelshowsectionListview.setName('');
                                modelshowsectionListview.setOpacity(0.0);
                                modelsectionStudentList.setName('');
                                modelsectionStudentList.setOpacity(0.0);
                                modelFeeDueList.setName('');
                                modelFeeDueList.setOpacity(0.0);
                              });
                            },
                            child: Consumer<ModelClassEducation>(
                                builder: (context, value, child) => Text(
                                      modelClassEducation.getName(),
                                      style: TextStyle(color: Colors.orange[900]),
                                    )),
                          ),
                          Consumer<ModelClassEducation>(
                              builder: (context, value, child) => Opacity(
                                  opacity: modelClassEducation.opacity,
                                  child: Icon(Icons.arrow_right_outlined))),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                modelShowYearListView.setStatus('SectionStudent');

                                modelFeeDueList.setName('');
                                modelFeeDueList.setOpacity(0.0);
                                modelsectionStudentList.setName('');
                                modelsectionStudentList.setOpacity(0.0);
                                modelFeeDueList.setName('');
                                modelFeeDueList.setOpacity(0.0);
                              });
                            },
                            child: Consumer<ModelShowSectionListView>(
                                builder: (context, value, child) => Text(
                                      modelshowsectionListview.getName(),
                                      style: TextStyle(color: Colors.lightBlueAccent),
                                    )),
                          ),
                          Consumer<ModelShowSectionListView>(
                              builder: (context, value, child) => Opacity(
                                  opacity: modelshowsectionListview.opacity,
                                  child: Icon(Icons.arrow_right_outlined))),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                modelShowYearListView.setStatus('StudentFeeDue');
                                modelFeeDueList.setName('');
                                modelFeeDueList.setOpacity(0.0);
                              });
                            },
                            child: Consumer<ModelSectionStudentList>(
                                builder: (context, value, child) => Text(
                                      modelsectionStudentList.getName(),
                                      style: TextStyle(color: Colors.red),
                                    )),
                          ),
                          Consumer<ModelSectionStudentList>(
                              builder: (context, value, child) => Opacity(
                                  opacity: modelsectionStudentList.opacity,
                                  child: Icon(Icons.arrow_right_outlined))),
                          Consumer<ModelFeeDueList>(
                              builder: (context, value, child) =>
                                  Text(modelFeeDueList.getName())),
                          Consumer<ModelFeeDueList>(
                              builder: (context, value, child) => Opacity(
                                  opacity: modelFeeDueList.opacity,
                                  child: Icon(Icons.arrow_right_outlined))),
                      ],
                    ),
                        )),
                  ),
                  Stack(
                    children: [
                      iconData == Icons.list
                          ? SchListView(
                              listSchBranches: sch1Branch,
                              listSchClasses: acc2GroupList,
                              listSchYear: acc3NameList,
                              listSchSection: acc4sectionList,
                              showStatusView: showStatusView,
                              isDecending: isDecending,
                              isDecendingCredit: isDecendingCredit,
                              isDecendingDebit: isDecendingDebit,
                              menuName: widget.menuName,
                              searchController: _searchController.text.toString())
                          : iconData == Icons.account_tree
                              ? TreeView(
                                  sch1Branch: sch1Branch,
                                  context: buildContextMain,
                                )
                              : DefaultGridView(
                                  schBranches: sch1Branch,
                                ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
