import 'dart:convert';
import 'dart:io';
import 'package:com/utils/api_query_for_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../Server/mysql_provider.dart';
import '../../../pages/sqlite_data_views/sqlite_database_code_provider.dart';

class DashboardProvider extends ChangeNotifier {
  List projectTableDetailList = [];
  List projectMenuTableDetailList = [];
  List<dynamic> projectTableColumnName = [];
  List<dynamic> projectMenuTableColumnName = [];
  String apiUri =
      'https://api.easysoftapp.com/PhpApi1/GenericAPI/genericAPI1.php?query=';

  Future<void> getDataFromApiForWeb(String query) async {
    final String finalApiUrl = apiUri + query;
    debugPrint('-------------------------$finalApiUrl-----------------');

    try {
      final response = await http.get(Uri.parse(finalApiUrl));
      if (response.statusCode == 200) {
        var json = await jsonDecode(response.body);
        List list = await json as List<dynamic>;
        List listCopy = List.from(list);
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
      }
    } catch (e) {
      debugPrint('--------------------${e.toString()}----------------');
    }

    // debugPrint('-------------------------$list-----------------');
    // debugPrint(
    //     '-------------------------$projectTableDetailList-----------------');
  }

  Future<void> getProjectTable() async {
    String actualQuery = 'select * from Project  where ProjectID !=1';
    String query;
    List list = [];

    if (kIsWeb) {
      list = await apiFetchForWeb(query: actualQuery);
    } else if (Platform.isAndroid || Platform.isWindows) {
      try {
        var db = await DatabaseProvider().init();
        query = '''
         $actualQuery
      ''';
        list = await db.rawQuery(query);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    projectTableDetailList.clear();
    List listCopy = List.from(list);
    for (int i = 0; i < listCopy.length; i++) {
      if (listCopy[i] != null) {
        projectTableDetailList.add(listCopy[i]);
      }
    }
    Map map = projectTableDetailList[0];
    projectTableColumnName.clear();
    map.forEach((key, value) {
      projectTableColumnName.add(key);
    });
    // debugPrint(
    //     '-------------------------$projectTableDetailList-----------------
  }

  Future<void> getProjectTable1() async {
    var db = await DatabaseProvider().init();
    String query;
    query = '''
      Select * from ProjectMenu WHERE ProjectID=${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.projectId)};
      ''';
    List list = await db.rawQuery(query);
    //print(list);
    projectTableDetailList.clear();
    List listCopy = List.from(list);
    for (int i = 0; i < listCopy.length; i++) {
      if (listCopy[i] != null) {
        projectTableDetailList.add(listCopy[i]);
      }
    }
    projectTableColumnName.clear();
    Map map = projectTableDetailList[0];
    //print(map);
    projectTableColumnName.clear();
    map.forEach((key, value) {
      projectTableColumnName.add(key);
    });
    //print(projectMenuTableColumnName);
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

    String query  = '';
    List list = [];
    query =  kIsWeb ? "Select Account3Name.AcNameID As UserID, Account3Name.AcName As UserName, Account3Name.UserRights, Account3Name.AcEmailAddress, Client.* From Account3Name Inner Join Client On Account3Name.ClientID = Client.ClientID Where Account3Name.AcEmailAddress = '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.email)}'" : 'SELECT * FROM Client';
    if (SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.subMenuQuery) ==
            null ||
        SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.subMenuQuery) ==
            '0') {
      if (kIsWeb) {
        list = await apiFetchForWeb(query: query);
      } else {
        var db = await DatabaseProvider().init();
        list = await db.rawQuery(query);
      }
    }

    return list;
  }

  Future<List> getClientTableById(String projectId) async {

    String query = '';
    List list = [];
    query = kIsWeb ?  "Select Account3Name.AcNameID As UserID, Account3Name.AcName As UserName, Account3Name.UserRights, Account3Name.AcEmailAddress, Client.* From Account3Name Inner Join Client On Account3Name.ClientID = Client.ClientID Where Account3Name.AcEmailAddress = '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.email)}' AND Client.ProjectID = '$projectId'"   : 'SELECT * FROM Client where ProjectID = $projectId';

    if (SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.subMenuQuery) ==
            null ||
        SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.subMenuQuery) ==
            '0') {
      if (kIsWeb) {
        list = await apiFetchForWeb(query: query);
      }else{
        var db = await DatabaseProvider().init();
        list = await db.rawQuery(query);
      }

    }

    return list;
  }

  Future<List> getProjectName(String projectID) async {
    var db;
    List list = [];
    String query = 'Select ProjectName from Project where ProjectID =$projectID';

    if(!kIsWeb) {
      db = await DatabaseProvider().init();
      list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }


    print(list);
    return list;
  }

  Future<List> checkAccount3Name(String clientID) async {
    var db;
    List list = [];
    String query = 'Select *from Account3Name where ClientID =$clientID';

    if(!kIsWeb) {
       db = await DatabaseProvider().init();
       list = await db.rawQuery(query);
    }else{
      list = await apiFetchForWeb(query: query);
    }
    return list;
  }

  Future<Map> getURLForYouTube(String projectID, BuildContext context) async {
    String query = '''
      Select ProjectVideo from Project where ProjectID='$projectID';
      ''';

    Results results = await Provider.of<MySqlProvider>(context, listen: false)
        .conn!
        .query(query);
    Set<ResultRow> resultRow = results.toSet();
    print(results);
    Map<String, dynamic> map = {};
    if (resultRow.length > 0) {
      for (int i = 0; i < resultRow.length; i++) {
        map = resultRow.elementAt(i).fields;
      }
    }
    return map;
  }

  Future<List> getALLURLForYouTubeVideo(
      String projectID, BuildContext context) async {

    String query= "";
    List list = [];

    if (kIsWeb ? true  : await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {

       query = "SELECT MenuName, ProjectMenuVideo, SortBy, CONCAT('https://api.easysoftapp.com/PhpApi1/ProjectImages/MenuIcon/',ImageName,'.png') As ImageURL  FROM `ProjectMenu` WHERE ProjectID = $projectID";


       if(kIsWeb){
         list = await apiFetchForWeb(query: query);
       }else {
         Results results = await Provider
             .of<MySqlProvider>(context, listen: false)
             .conn!
             .query(query);
         Set<ResultRow> resultRow = results.toSet();
         print(results);
         Map<String, dynamic> map = {};

         if (resultRow.length > 0) {
           for (int i = 0; i < resultRow.length; i++) {
             map = resultRow
                 .elementAt(i)
                 .fields;
             list.add(map);
           }
         }
       }
      return list;
    } else {
      return [];
    }
  }

  Future<List> getALLURLForYouTubeVideoIntro(
      String projectID, BuildContext context) async {

    String query= "";
    List list = [];
    if ( kIsWeb ? true  : await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
       query = "SELECT ProjectName,ProjectVideo, ' ' As SortingBy, CONCAT('https://api.easysoftapp.com/PhpApi1/ProjectImages/ProjectsLogo/',ProjectID,'.png') As ImageURL FROM `Project` WHERE ProjectID = $projectID";

       if(kIsWeb){
         list = await apiFetchForWeb(query: query);
       }else {
         Results results = await Provider
             .of<MySqlProvider>(context, listen: false)
             .conn!
             .query(query);
         Set<ResultRow> resultRow = results.toSet();
         print(results);
         Map<String, dynamic> map = {};
         if (resultRow.length > 0) {
           for (int i = 0; i < resultRow.length; i++) {
             map = resultRow
                 .elementAt(i)
                 .fields;
             list.add(map);
           }
         }
       }
      return list;
    } else {
      return [];
    }
  }

  Future<List> getClientFromServer(
      String projectID, BuildContext context) async {
    bool valueCheckForConn =
        await Provider.of<MySqlProvider>(context, listen: false)
            .connectToServerDb();

    if (valueCheckForConn) {
      String query = '''
     SELECT * FROM Client where ProjectID = $projectID;
 ''';

      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
      Set<ResultRow> resultRow = results.toSet();
      print(results);
      Map<String, dynamic> map = {};
      List list = [];
      if (resultRow.length > 0) {
        for (int i = 0; i < resultRow.length; i++) {
          map = resultRow.elementAt(i).fields;
          list.add(map);
        }
      }







      return list;
    } else {
      return [];
    }
  }



  Future<List> getInfoAboutClientFromServer(
      int clientID, BuildContext context) async {
    bool valueCheckForConn =
        await Provider.of<MySqlProvider>(context, listen: false)
            .connectToServerDb();

    if (valueCheckForConn) {
      String query = '''
     SELECT * FROM Client where ClientID = $clientID;
 ''';

      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
      Set<ResultRow> resultRow = results.toSet();
      print(results);
      Map<String, dynamic> map = {};
      List list = [];
      if (resultRow.length > 0) {
        for (int i = 0; i < resultRow.length; i++) {
          map = resultRow.elementAt(i).fields;
          list.add(map);
        }
      }
      return list;
    } else {
      return [];
    }
  }

  Future<Map> getURLForYouTubeForMenuName(
      String menuName, BuildContext context) async {
    String query = '''
    Select ProjectMenuVideo from ProjectMenu where MenuName='$menuName';
      ''';
    Results results = await Provider.of<MySqlProvider>(context, listen: false)
        .conn!
        .query(query);
    Set<ResultRow> resultRow = results.toSet();
    print('/////////////////////////////////////////////////${resultRow}');
    Map<String, dynamic> map = {};
    if (resultRow.length > 0) {
      for (int i = 0; i < resultRow.length; i++) {
        if(resultRow.elementAt(i).fields['ProjectMenuVideo'] != null) {
          map = resultRow
              .elementAt(i)
              .fields;
        }
      }
    }
    print(map);
    return map;
  }

  //  no use of this method

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
