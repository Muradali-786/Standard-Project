import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../../Server/mysql_provider.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';

getDatabase() async {
  var db = await DatabaseProvider().init();
  return db;
}

Future<List> getAddCategory1Data() async {
  String query = '';
  List list = [];
  query = "Select * from AddCategory1";

  try {
    var db = await getDatabase();
    list = await db.rawQuery(query);

    return list;
  } catch (e) {
    return [];
  }
}

Future<List> getAddCategory2Data({required int ID1}) async {
  String query = '';
  List list = [];
  query = "Select * from AddCategory2 where ID1 = '$ID1' ";

  try {
    var db = await getDatabase();
    list = await db.rawQuery(query);

    return list;
  } catch (e) {
    return [];
  }
}

Future<List> getAddCategory4Data({required BuildContext context}) async {
  String query = '';
  List list = [];
  query = "Select * from AddCategory4";

  try {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      // print('......................................${results.toSet().toList()}');
      // list = results.toSet().toList();

      for (var row in results) {
       list.add(row.fields);
      }


      return list;
    }
  } catch (e) {
    print(e);
    return [];
  }
  return [];
}

Future<String> createCategory({
  required int ID3,
  required BuildContext context,
  required String ClientAddNo,
  required String AddStatus,
  required String AddTitle,
  required String AddDetail,
  required String Price,
  required String AddGPSPostFrom,
  required String AddGPSLocation,
  required String AddArea,
  required String AddCategory,
  required String AddCategory2,
  required String ContactNo,
  required String NameOfPerson,
  required String Country,
  required String City,
}) async {





  try {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      List list = [];
      String ID = "select (IfNull(Max(Abs(ID4)),0)+1) as MaxId from AddCategory4" + "";

      Results resultsID = await Provider.of<MySqlProvider>(context, listen: false)
        .conn!
        .query(ID);

      for (var row in resultsID) {
        list.add(row.fields);
      }
    var ID4 = list[0]['MaxId'];


    String query = """
   INSERT INTO AddCategory4 (ID4,ID3,ClientAddNo,AddStatus,AddTitle,AddDetail,Price,AddGPSPostFrom,AddGPSLocation,
   AddArea,AddCategory,AddCategory2,ContactNo,NameOfPerson, CountryClientID,CountryUserID,NetCode,SysCode,UpdatedDate, AddPostingDate,Country,City) VALUES
        (
          '${ID4}',
          '${ID3}',
          '${ClientAddNo}',
          '${AddStatus}',
         '${AddTitle}' ,
         '${AddDetail}',
          '${Price}',
          '${AddGPSPostFrom}',
         '${AddGPSLocation}' ,
          '${AddArea}',
          '${AddCategory}',
          '${AddCategory2}',
         '${ContactNo}' ,
          '${NameOfPerson}',
          '0',
          '0',
          '0',
          '0',
          '',
          '${DateTime.now().toString()}',
          '${Country}',
          '$City'
        )
  """;

     await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);


    }

    // db.close();

    return 'Insert';
  } catch (e) {
    //  print('${e.toString()}');
    return e.toString();
  }
}

Future<List> fetchCityFromServer({required String countryName}) async {
  String query = '''
        SELECT * FROM `CountryCity` where iso3 = '$countryName'
        ''';
  try {
    var db = await getDatabase();
    List list = await db.rawQuery(query);

    print(
        '........................................  $list  mjmjmjmjmjmj....................');

    return list;
  } catch (e) {
    return [];
  }
}
