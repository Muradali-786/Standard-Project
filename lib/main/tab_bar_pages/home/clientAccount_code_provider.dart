import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import '../../../Server/mysql_provider.dart';
import '../../../pages/sqlite_data_views/sqlite_database_code_provider.dart';
import '../../../utils/api_query_for_web.dart';

class ClientAccountProvider extends ChangeNotifier {
  List projectTableDetailList = [];
  List projectMenuTableDetailList = [];
  List<dynamic> projectTableColumnName = [];
  List<dynamic> projectMenuTableColumnName = [];

  Future<void> getProjectTable() async {
    var db = await DatabaseProvider().init();
    String query;
    query = '''
      SELECT * FROM Project;
      ''';
    List list = await db.rawQuery(query);
    //print(list);
    projectTableDetailList.clear();
    List listCopy = List.from(list);
    listCopy.sort((a, b) => a["SortBy"].compareTo(b["SortBy"]));
    for (int i = 0; i < listCopy.length; i++) {
      if (listCopy[i] != null) {
        projectTableDetailList.add(listCopy[i]);
      }
    }
    projectTableColumnName.clear();
    Map map = projectTableDetailList[0];

    projectTableColumnName.clear();
    map.forEach((key, value) {
      projectTableColumnName.add(key);
    });
    //print(projectMenuTableColumnName);
  }

  Future<int> updatePasswordFromServer(
      String password,
      String oldPass,
      String countryClientId,
      String countryUserID,
      BuildContext context) async {
    try {
      if (await Provider.of<MySqlProvider>(context, listen: false)
          .connectToServerDb()) {
        String getPassQuery = '''
        Select AcPassward FROM Account3Name  WHERE  ClientID ='$countryClientId' And AcNameID ='$countryUserID' AND AcPassward ='$oldPass'
     
        ''';

        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query(getPassQuery);

        if (results.length > 0) {
          String query = '''
      UPDATE  Account3Name SET AcPassward ='$password' WHERE  ClientID ='$countryClientId' And AcNameID ='$countryUserID'
      ''';
          print(query);
          Results results2 =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(query);
          if (results2.length > 0) {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: Material(
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'password is Update',
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ),
                  );
                });

            return 1;
          }
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: Material(
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Old Password is not match From Sever',
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                  ),
                );
              });
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return 0;
  }

  Future<List> userRightsChecking() async {
    try {
      var db;
      List list = [];
      String query = "select * from Account4UserRights where ClientID = '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}' AND Account3ID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}'";

      if(!kIsWeb) {
        db = await DatabaseProvider().init();
        list = await db.rawQuery(query);
      }else{
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<void> getProjectTable1() async {
    List l = await userRightsChecking();
    String query;
    List list = [];
    query = "Select * from ProjectMenu WHERE ProjectID='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.projectId)}'";

    print('//////////////$l');
    if (kIsWeb) {
      print('//////////////$l junijnuijunijunijunijunijnuin');
      list = await apiFetchForWeb(query: query);
    }else if (Platform.isAndroid || Platform.isWindows) {
      var db = await DatabaseProvider().init();
       list = await db.rawQuery(query);

    }

    print(list);
    projectTableDetailList.clear();
      List listCopy = List.from(list);
      listCopy.sort((a, b) => a["SortBy"].compareTo(b["SortBy"]));

      for (int i = 0; i < listCopy.length; i++) {
        if (listCopy[i] != null) {
          if (SharedPreferencesKeys.prefs!
                  .getString(SharedPreferencesKeys.userRightsClient) ==
              'Custom Right') {
            if (l.length > 0) {
              for (int j = 0; j < l.length; j++) {
                if (listCopy[i]['MenuName'] == l[j]['MenuName']) {
                  if (l[j]['Viwe'] == 'true') {
                    projectTableDetailList.add(listCopy[i]);
                  }
                } else {
                  // projectTableDetailList.add(listCopy[i]);
                  // break;
                }
              }
            }
          } else {
            projectTableDetailList.add(listCopy[i]);
          }
        }
      }
      projectTableColumnName.clear();
      Map map = projectTableDetailList[0];
      projectTableColumnName.clear();
      map.forEach((key, value) {
        projectTableColumnName.add(key);
      });


  }

  Future<void> getProjectMenuById(int id) async {
    var db = await DatabaseProvider().init();

    String query = '''
      Select * from ProjectMenu WHERE ProjectID=${id.toString()};
      ''';
    projectMenuTableDetailList = await db.rawQuery(query);
    Map map = projectMenuTableDetailList[0];
    projectMenuTableColumnName.clear();
    map.forEach((key, value) {
      projectMenuTableColumnName.add(key);
    });
  }

  Future<List> getClientTable() async {
    var db = await DatabaseProvider().init();
    String query;
    if (SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.subMenuQuery) ==
            null ||
        SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.subMenuQuery) ==
            '0') {
      query = '''
      SELECT * FROM Client;
      ''';
    } else {
      query = SharedPreferencesKeys.prefs!
          .getString(SharedPreferencesKeys.subMenuQuery)!;
    }
    List list = await db.rawQuery(query);
    return list;
  }





  Future<List> getProjectMenuSub(String menuName) async {
    var db = await DatabaseProvider().init();
    String query = '''
      Select * from ProjectMenuSub where MenuName='$menuName';
      ''';
    SharedPreferencesKeys.prefs!
        .setString(SharedPreferencesKeys.subMenuQuery, query);
    List list = await db.rawQuery(query);
    print(list);
    return list;
  }
}
