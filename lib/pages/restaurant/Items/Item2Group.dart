

import 'package:com/main/tab_bar_pages/home/themedataclass.dart';
import 'package:com/pages/material/drop_down_style1.dart';
import 'package:com/pages/restaurant/Items/ItemsSQL.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Item2Group extends StatefulWidget {
  final String? entryMode;
  final String? itemGroupName;
  final String? itemType;
  final int? itemTypeId;

  const Item2Group(
      {Key? key,
      this.entryMode,
      this.itemGroupName,
      this.itemType,
      this.itemTypeId})
      : super(key: key);

  @override
  _Item2GroupState createState() => _Item2GroupState();
}

class _Item2GroupState extends State<Item2Group> {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);

  TextEditingController itemGroup_name_controller = TextEditingController();


  DatabaseProvider db = DatabaseProvider();
  List<Map> acc1TypeList = [];
  late String result = "ItemType";
  Map dropDownMap = {
    "ID": null,
    'Title': "Item Type",
    'SubTitle': null,
    "Value": null
  };
  int Item1TypeID = 0;
  int maxIDNumber = 0;
  int item1TypeId = 0;
  ItemSql _itemSql = ItemSql();

  fun() async {
    await MaxId();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.entryMode == 'Edit') {
        itemGroup_name_controller.text = widget.itemGroupName!;
        dropDownMap['Title'] = widget.itemType.toString();
      }
    });
    fun();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Provider.of<ThemeDataHomePage>(context, listen: false)
          .backGroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Item Group",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Center(
                    child: widget.entryMode == 'Add'
                        ? Text(
                            maxIDNumber.toString(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          )
                        : Text(
                            widget.itemTypeId.toString(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                  ),
                ],
              ),
              widget.entryMode == 'Edit'
                  ? Center(
                      child: Text(
                        widget.itemTypeId.toString(),
                      ),
                    )
                  : Center(child: Text('Add')),
              Column(
                children: [
                  SizedBox(
                    child: FutureBuilder(
                      future: _itemSql.dropDownDataForItemType(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                            child: InkWell(
                                onTap: () async {
                                  dropDownMap = await showDialog(
                                    context: context,
                                    builder: (_) => DropDownStyle1(
                                      acc1TypeList: snapshot.data,
                                      dropdown_title: dropDownMap['Title'],
                                      map: dropDownMap,
                                    ),
                                  );
                                  setState(() {
                                    Item1TypeID =
                                        int.parse(dropDownMap['ID'].toString());
                                  });
                                },
                                child: DropDownStyle1State.DropDownButton(
                                  title: dropDownMap['Title'].toString(),
                                  id: dropDownMap['ID'].toString(),
                                )),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      controller: itemGroup_name_controller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: Text('Item Group Name'),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width / 3,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,// background
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ) // foreground
                                  ),
                              onPressed: () async {
                                if (widget.entryMode == 'Add') {
                                  await _itemSql.insertItem2Group(
                                      int.parse(dropDownMap['ID']),
                                      itemGroup_name_controller.text,
                                      context);
                                } else if (widget.entryMode == 'Edit') {
                                   await _itemSql.UpdateItem2Group(
                                      widget.itemTypeId,
                                      int.parse(dropDownMap['ID']),
                                      itemGroup_name_controller.text);
                                }

                                itemGroup_name_controller.clear();
                              },
                              child: widget.entryMode == 'Add'
                                  ? Text(
                                      "Save",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "Update",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border.all(width: 0, color: Colors.blue)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getDatabase() async {
    await db.init();
  }

  MaxId() async {
    var db =  await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(RestaurantItem2Group.Item2GroupID)),0)+1) as MaxId from RestaurantItem2Group where ClientID=$clientID
    ''';
    List list = await db.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();
    setState(() {
      maxIDNumber = maxID;
    });


    if (widget.entryMode == 'Edit') {
      String query = '''
          Select Item1TypeID from RestaurantItem1Type where ItemType = '${widget.itemType}'
    ''';
      List list = await db.rawQuery(query);
      setState(() {
        item1TypeId = int.parse(list[0]['Item1TypeID'].toString());
        dropDownMap['ID'] = item1TypeId.toString();
      });
    }
  }

}
