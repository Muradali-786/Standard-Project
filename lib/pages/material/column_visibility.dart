import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColumnVisibility extends StatefulWidget {
  final String query;
  const ColumnVisibility({Key? key,required this.query}) : super(key: key);

  @override
  _ColumnVisibilityState createState() => _ColumnVisibilityState();
}

class _ColumnVisibilityState extends State<ColumnVisibility> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
        future: getSettingRecords(context),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            List list=snapshot.data!;
            if(list.isNotEmpty){
              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context,settingIndex){
                Map map=list[settingIndex];
                return SwitchListTile(
                    title: Text(map['columnName']),
                value: map['visibility']==0?false:true,
                onChanged: (bool value) async{
                  await changeVisibility(context, map['id'],map['visibility'],map['columnName']);
                      setState(() {
                      });

              });
            });
          }else{
              return Center(
              child:Text("No Data To Display"),
              );
            }
                }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
  Future<void> changeVisibility(BuildContext context,int id,int visibility,String columnName)async{
    try{
      var db =  await DatabaseProvider().init();
      String query='''
      Update Setting Set visibility=${visibility==0?1:0},UpdatedDate='' WHERE id='$id'
      ''';
      await db.rawQuery(query);
      //await Provider.of<DatabaseProvider>(context,listen: false).removeColumn(columnName);
      await Provider.of<DatabaseProvider>(context,listen:false).
      getTableByQuery(widget.query, context);
    } on Exception catch(e,stk){
      print(e);
      print(stk);
    }
  }

  Future<List> getSettingRecords(BuildContext context)async{
    try {
      var db =  await DatabaseProvider().init();
      //getting Setting table records for column visibility decision
      String query='''
      Select * from Setting where
      "layout"='${Provider.of<DatabaseProvider>(context,listen:false).layoutName}' AND
      "ClientID"='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}'
      ''';
      print(query);
      List list =await db.rawQuery(query);
      return list;
    } on Exception catch (e,stk) {
      print(e);
      print(stk);
      return [];
    }

  }

}
