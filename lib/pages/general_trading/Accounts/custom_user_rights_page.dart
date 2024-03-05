import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Server/RefreshDataProvider.dart';
import '../../../config/screen_config.dart';
import '../../../main/tab_bar_pages/home/themedataclass.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import 'Account4UserRightsModel.dart';
import 'AccountSQL.dart';
import 'custom_user_rights_model.dart';

class CustomUserRightsScreen extends StatefulWidget {
  final int account3Id;
  final String action;
  final String menuName;
  final int? length;

  const CustomUserRightsScreen(
      {Key? key,
      required this.account3Id,
        this.length,
      required this.menuName,
      required this.action})
      : super(key: key);

  @override
  _CustomUserRightsState createState() => _CustomUserRightsState();
}

class _CustomUserRightsState extends State<CustomUserRightsScreen> {
  List<CustomUserRights> checkBoxValueList = [];
  RefreshDataProvider refresh = RefreshDataProvider();
  List list = [];
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  bool check = true;
  AccountSQL _accountSQL = AccountSQL();
  List<Account4UserRightsModel> listAccount4UserRights = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
          .backGroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
            .borderTextAppBarColor,
        title: Text('Custom Rights'),
        //automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () async {


                Navigator.pop(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    size: 20,
                    color: Colors.red,
                  ),
                  Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () async {
                try {

                    for (int locationAccount4UserRightsIndex = 0;
                        locationAccount4UserRightsIndex <
                            listAccount4UserRights.length;
                        locationAccount4UserRightsIndex++) {
                   await   _accountSQL.updateIntoCustonUserRight(
                          listAccount4UserRights[
                                  locationAccount4UserRightsIndex]
                              .toJson(),
                          listAccount4UserRights[
                                  locationAccount4UserRightsIndex]
                              .id);
                  }

                  print('data updated successfully');
                } catch (e, stk) {
                  print(e);
                  print(stk);
                }

                Navigator.pop(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    size: 20,
                    color: Colors.green,
                  ),
                  Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      body: FutureBuilder(
            future: _accountSQL.getAccount4UserRightsData(widget.account3Id) ,
            builder: (context,
                AsyncSnapshot<List<Account4UserRightsModel>> snapshot) {
              if (snapshot.hasData  ) {
                if (check) {
                  listAccount4UserRights = snapshot.data!;
                  check = false;
                }
                return ListView.builder(
                    itemCount: listAccount4UserRights.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Card(
                              margin: EdgeInsets.all(0),
                              color: Provider.of<ThemeDataHomePage>(context,
                                      listen: false)
                                  .borderTextAppBarColor,
                              child: SwitchListTile(
                                value:
                                    listAccount4UserRights[index].view == 'true'
                                        ? true
                                        : false,
                                activeColor: Colors.white,
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.white,
                                onChanged: (value) {

                                  setState(() {
                                    listAccount4UserRights[index].view =
                                        value.toString();

                                    if( listAccount4UserRights[index].view == 'false'){
                                      listAccount4UserRights[index].inserting = 'false';
                                      listAccount4UserRights[index].edting = 'false';
                                      listAccount4UserRights[index].deleting = 'false';
                                      listAccount4UserRights[index].reporting = 'false';
                                    }
                                  });

                                },
                                title: Text(
                                  listAccount4UserRights[index].menuName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            listAccount4UserRights[index].view == 'true' ?
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: CheckboxListTile(
                                      title: Text('Inserting'),
                                      tileColor: Colors.white,
                                      activeColor: Provider.of<ThemeDataHomePage>(
                                          context,
                                          listen: false)
                                          .borderTextAppBarColor,
                                      value:
                                      listAccount4UserRights[index].inserting ==
                                          'true'
                                          ? true
                                          : false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (listAccount4UserRights[index].view ==
                                              'true') {
                                            listAccount4UserRights[index]
                                                .inserting = value!.toString();
                                            print(bool.fromEnvironment(
                                                listAccount4UserRights[index]
                                                    .inserting));
                                            print(bool.fromEnvironment(
                                                listAccount4UserRights[index]
                                                    .inserting)
                                                .runtimeType);
                                          }
                                        });
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: CheckboxListTile(
                                      title: Text('Editing'),
                                      tileColor: Colors.white,
                                      activeColor: Provider.of<ThemeDataHomePage>(
                                          context,
                                          listen: false)
                                          .borderTextAppBarColor,
                                      value: listAccount4UserRights[index].edting ==
                                          'true'
                                          ? true
                                          : false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (listAccount4UserRights[index].view ==
                                              'true') {
                                            listAccount4UserRights[index].edting =
                                                value!.toString();
                                          }
                                        });
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: CheckboxListTile(
                                      title: Text('Deleting'),
                                      tileColor: Colors.white,
                                      activeColor: Provider.of<ThemeDataHomePage>(
                                          context,
                                          listen: false)
                                          .borderTextAppBarColor,
                                      value:
                                      listAccount4UserRights[index].deleting ==
                                          'true'
                                          ? true
                                          : false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (listAccount4UserRights[index].view ==
                                              'true') {
                                            listAccount4UserRights[index].deleting =
                                                value!.toString();
                                          }
                                        });
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: CheckboxListTile(
                                      title: Text('Reporting'),
                                      tileColor: Colors.white,
                                      activeColor: Provider.of<ThemeDataHomePage>(
                                          context,
                                          listen: false)
                                          .borderTextAppBarColor,
                                      value:
                                      listAccount4UserRights[index].reporting ==
                                          'true'
                                          ? true
                                          : false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (listAccount4UserRights[index].view ==
                                              'true') {
                                            listAccount4UserRights[index]
                                                .reporting = value!.toString();
                                          }
                                        });
                                      }),
                                ),
                              ],
                            ) : SizedBox()

                          ],
                        ),
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
    )


    );
  }

// Future<List> getProjectTable() async {
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   String databasePath = join(appDocDir.path, 'asset_EasySoftDataFile.db');
//   var db = await databaseFactoryFfi.openDatabase(databasePath,
//       options: OpenDatabaseOptions(singleInstance: false));
//   String query = '''
//     Select * from ProjectMenu WHERE ProjectID=${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.projectId)} Order By
//   ProjectMenu.GroupSortBy,
//   ProjectMenu.SortBy
//     ''';

//   List list = await db.rawQuery(query);
//   checkBoxValueList =
//       List.generate(list.length, (index) => CustomUserRights());

//   print('................list of tru $checkBoxValueList');
//   return list;
// }

// Future<List> getAccount4UserRightsData() async {

//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   String databasePath = join(appDocDir.path, 'asset_EasySoftDataFile.db');
//   var db = await databaseFactoryFfi.openDatabase(databasePath,
//       options: OpenDatabaseOptions(singleInstance: false));
//   String query = '''
//     select * from Account4UserRights where ClientID='$clientID' AND Account3ID='${widget.account3Id}' Order By
//   Account4UserRights.GroupSortBy,
//   Account4UserRights.SortBy
//     ''';
//   List list = await db.rawQuery(query);
//   print(list);
//   listAccount4UserRights = account4UserRightsModelFromJson(jsonEncode(list));
//   return list;
// }
}
