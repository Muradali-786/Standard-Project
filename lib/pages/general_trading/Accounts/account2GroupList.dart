import 'package:flutter/material.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import '../../sqlite_data_views/sqlite_database_code_provider.dart';

class Account2GroupList extends StatefulWidget {
  const Account2GroupList({Key? key}) : super(key: key);

  @override
  _Account2GroupListState createState() => _Account2GroupListState();
}


class _Account2GroupListState extends State<Account2GroupList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getAccount2GroupDropDownTitle(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              List<Map<String, dynamic>> list=snapshot.data as List<Map<String, dynamic>>;

              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context,index){
                    Map map=list[index];
                return InkWell(
                  onTap: ()async{
                    print(map);
                    //await getAccount2GroupDropDownTitle();
                    // await showDialog(
                    //     context: context,
                    //     builder: (_) => Account2GroupDesign(map:list[index],action: "EDIT",));
                  },
                  child: ListTile(
                    title: Text(map['Title'].toString()),
                  ),
                );
              });
            }
            return CircularProgressIndicator();
      }),
    );
  }

 Future<List<Map<String, dynamic>>> getAccount2GroupData()async {
   var db =  await DatabaseProvider().init();

   try {
     List<Map<String, dynamic>> dropDownData = await db.rawQuery('''
         Select * From Account2Group
          ''');
     return dropDownData;
   } catch (e,stk) {
     print(e.toString());
     print(stk);
   }
   return [];
 }
  Future<List<Map<String, dynamic>>> getAccount2GroupDropDownTitle()async {
    var db =  await DatabaseProvider().init();

    try {
      List<Map<String, dynamic>> dropDownData = await db.rawQuery('''
         Select
    Account2Group.AcTypeID As ID,
    Account2Group.AcGroupID As Value,
    Account2Group.AcGruopName As Title,
    Account1Type.AcTypeName As SubTitle,
    Account2Group.ClientID
      From
    Account2Group Left Join
    Account1Type On Account1Type.AcTypeID = Account2Group.AcTypeID
    Where
    Account2Group.ClientID = '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}'
          ''');
      return dropDownData;
    } catch (e,stk) {
      print(e.toString());
      print(stk);
    }
    return [];
  }
}
