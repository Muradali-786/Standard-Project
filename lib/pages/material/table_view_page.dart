import 'package:flutter/material.dart';
import 'package:com/config/screen_config.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:provider/provider.dart';

////////////////////////
//Show Table name design
///////////////////////
class TableViewPage extends StatefulWidget {
  const TableViewPage({Key? key}) : super(key: key);

  @override
  State<TableViewPage> createState() => _TableViewPageState();
}

class _TableViewPageState extends State<TableViewPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<DatabaseProvider>(context, listen: false).readTableName();
    ScreenConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Home Page"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Provider.of<DatabaseProvider>(context, listen: false)
              .readTableName(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return SizedBox(
                height: ScreenConfig.screenHeight,
                width: ScreenConfig.screenWidth,
                child: ListView.builder(
                    itemCount: (snapshot.data! as List).length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        trailing: SizedBox(
                          width: 50,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: popUpButtonForItemEdit(
                                onSelected: (value) async {
                              if (value == 0) {
                                deleteAllTableData(
                                    (snapshot.data! as List)[index]['name']);
                              }
                            }),
                          ),
                        ),
                        title: Text((snapshot.data! as List)[index]['name']),
                        onTap: () {
                          ////////////////////
                          //Getting table name
                          ////////////////////
                          Provider.of<DatabaseProvider>(context, listen: false)
                              .getTable((snapshot.data! as List)[index]['name'])
                              .then((value) {
                            Navigator.pushNamed(context, '/table_detail_page',
                                arguments: (snapshot.data! as List)[index]
                                    ['name']);
                          });
                        },
                      );
                    }),
              );
            }

            return CircularProgressIndicator();
          },
        ));
  }

  Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      icon: Icon(
        Icons.more_vert,
        size: 20,
        color: Colors.grey,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('Delete All Table Data')),
          // PopupMenuItem(value: 1, child: Text('Delete')),
        ];
      },
    );
  }

  getDatabase() async {
    var db = await DatabaseProvider().init();
    return db;
  }

  deleteAllTableData(String tableName) async {
    var db = await getDatabase();
    try {
      String query = '''
      Delete From $tableName
      ''';
      db.rawQuery(query);

      print('delete success');
    } catch (e) {
      print('error $e');
    }
  }
}
