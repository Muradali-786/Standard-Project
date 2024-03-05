// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';


List<Map>? acc1TypeList = [];
List<Map> acc2GroupList = [];
List<Map> acc3NameList = [];

class AccountTreeView extends StatefulWidget {
  @override
  _AccountTreeViewState createState() => _AccountTreeViewState();
}

class _AccountTreeViewState extends State<AccountTreeView> {
  bool isExpand = false;
  int? AcTypeID, ClientID;
  int? AcGroupID;
  int maxid = 0;

  DatabaseProvider db = DatabaseProvider();

  MaxId() async {
    var db =  await DatabaseProvider().init();
    //
    // String maxId = '''
    // select -(IfNull(Max(Abs(AcGroupID)),0)+1) as MaxId from Account2Group"+" where ClientID=$clientID
    // ''';

    String query = 'SELECT * from Account1Type ';

    List list = await db.rawQuery(query);
    print(list[1]['AcTypeName']);
    // var maxID = list[0]['AcTypeName'];
    // AcTypeID = list[0]['AcTypeID'];
    // print(AcTypeID);
    setState(() {
      acc1TypeList = list.cast<Map>();
      //  maxid = maxID;
    });
    //print(list);
    // print(maxID);
  }

  Sub() async {
    var db =  await DatabaseProvider().init();

    String query =
        // 'select * from Account2Group';
        'SELECT * FROM Account2Group WHERE AcTypeID= $AcTypeID AND ClientID=$ClientID';

    List list1 = await db.rawQuery(query);
    //print(list1[1]['ID']);
    // print('Client id:$ClientID');
    // var maxID = list1[0]['AcGroupID'];
    setState(() {
      acc2GroupList = list1.cast<Map>();
      //  maxid = maxID;
    });
    //print(list1);
    // print(maxID);
  }

  MinSub() async {
    var db =  await DatabaseProvider().init();

    String query =
        // 'SELECT * FROM Account3Name';
        'SELECT * FROM Account3Name WHERE AcGroupID= $AcGroupID AND ClientID=$ClientID';

    List list2 = await db.rawQuery(query);
    // print('Account group:- $AcGroupID');
    // print(list2[0]['AcGroupID']);
    //var maxID = list2[0]['AcGroupID'];
    setState(() {
      acc3NameList = list2.cast<Map>();
      //  maxid = maxID;
    });
    //print(list2);
    // print(maxID);
  }

  fun() async {
    await MaxId();
    ClientID =
        SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
    print('Client id:$ClientID');
    //await Sub();
    //await MinSub();
  }

  getDatabase() async {
    await db.init();
  }

  @override
  void initState() {
    super.initState();
    fun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AccountTreeView'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: acc1TypeList!.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTile(
              // trailing: IconButton(
              //   onPressed: () {
              //      setState(() async {
              //       AcTypeID = acc1TypeList![index]['AcTypeID'];
              //       print('Account  Type id is $AcTypeID');
              //       await Sub();
              //     });
              //   },
              //   icon: Icon(Icons.expand_more),
              // ),
              title: GestureDetector(
                onTap: () {
                  setState(() async {
                    AcTypeID = acc1TypeList![index]['AcTypeID'];
                    print('Account  Type id is $AcTypeID');
                    await Sub();
                  });
                },
                child: Text(
                  //main TreeView title
                  acc1TypeList![index]['AcTypeName'].toString(),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: acc2GroupList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionTile(
                        title: GestureDetector(
                          onTap: () {
                            setState(() async {
                              //Sub();
                              AcGroupID = acc2GroupList[index]['AcGroupID'];
                              print('Account Group id:$AcGroupID');
                              await MinSub();
                              // MinSub()
                            });
                          },
                          child: Text(
                            //sub child
                            acc2GroupList[index]['AcGruopName'].toString(),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: acc3NameList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ExpansionTile(
                                  title: Text(
                                      //child Text
                                      acc3NameList[index]['AcName'].toString()),
                                );
                              },
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
