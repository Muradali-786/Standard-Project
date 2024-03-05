import 'package:com/pages/material/datepickerstyle2.dart';
import 'package:com/pages/material/drop_down_style1.dart';
import 'package:com/pages/restaurant/Items/Item2Group.dart';
import 'package:com/pages/restaurant/Items/Item3Name.dart';
import 'package:com/pages/restaurant/Items/ItemLocation.dart';
import 'package:com/pages/restaurant/Items/ItemTreeView.dart';
import 'package:com/pages/restaurant/Items/ItemsSQL.dart';
import 'package:com/pages/restaurant/Items/rawMaterialPage.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:com/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResturantDefaultItemsPage extends StatefulWidget {
  final String menuName;

  const ResturantDefaultItemsPage({Key? key, required this.menuName})
      : super(key: key);

  @override
  _ResturantDefaultItemsPageState createState() =>
      _ResturantDefaultItemsPageState();
}

class _ResturantDefaultItemsPageState extends State<ResturantDefaultItemsPage> {
  String toDate =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String fromDate =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  List originalList = [];
  List list = [];
  TextEditingController _searchController = TextEditingController();
  DateTime dateTimeData = DateTime.now();
  ItemSql _itemSql = ItemSql();
  bool hideSearch = false;
  IconData iconData = Icons.list;
  List<Map> itemTypeList = [];
  String filterByItemGroupName = '';
  String filterByItemTypeName = '';
  bool checkForItemMenu = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map dropDownMap = {
      "ID": null,
      'Title': "Item Group",
      'SubTitle': null,
      "Value": null
    };

    return StatefulBuilder(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///         tool bar ................................
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///                      Date     ///
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (_) {
                          var date = DatePickerStyle2();
                          return date;
                        }));

                        setState(() {});
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('From: ${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(fromDate.toString().substring(0, 4)), int.parse(fromDate.substring(
                                5,
                                7,
                              )), int.parse(fromDate.substring(8, 10)))).toString()}'),
                          Text('To     :${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(toDate.toString().substring(0, 4)), int.parse(toDate.toString().substring(
                                5,
                                7,
                              )), int.parse(toDate.toString().substring(8, 10)))).toString()}'),
                        ],
                      ),
                    ),
                  ),

                  ///                      search     ///

                  hideSearch
                      ? Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: TextFormField(
                            //initialValue: args.dropdown_title,
                            //controller: passwordController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              labelText: "Search",
                              hintText: "Search",
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Colors.green,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 20,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            controller: _searchController,
                            onChanged: (value) {
                              getSearchList(searchValue: value);

                              if (value.length == 0) {}
                              setState(() {});
                            },
                          ),
                        )
                      : SizedBox(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (hideSearch) {
                            hideSearch = false;
                          } else {
                            hideSearch = true;
                          }
                        });
                      },
                      icon: Icon(Icons.search)),

                  ///                      filter     ///
                  IconButton(
                    onPressed: () {
                      showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(40.0, 235.0, 50.0, 0.0),
                        //position where you want to show the menu on screen
                        items: [
                          PopupMenuItem<String>(
                              child: const Text('Filter By Account Group'),
                              value: '1'),
                          PopupMenuItem<String>(
                              child: const Text('Filter By Account Type'),
                              value: '2'),
                          PopupMenuItem<String>(
                              child: const Text('Filter By User Rights'),
                              value: '3'),
                          PopupMenuItem<String>(
                              child: const Text(
                                'Clear All Filtration',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              value: '4'),
                        ],
                        elevation: 8.0,
                      ).then(
                        (value) async {
                          if (value == null) {}
                          if (value == '1') {}
                          if (value == '2') {}
                          if (value == '3') {}
                          if (value == '4') {}
                        },
                      );
                    },
                    icon: Icon(Icons.filter_alt_outlined),
                  ),

                  ///                      views to show as list , grid , tree     ///
                  IconButton(
                    onPressed: () {
                      showMenu<IconData>(
                        context: context,
                        position: RelativeRect.fromLTRB(70.0, 235.0, 40.0, 0.0),
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        size: 20,
                        color: Colors.grey,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton<int>(
                        child: Container(
                          color: Colors.green,
                          alignment: Alignment.center,
                          width: 60,
                          height: 50,
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 8),
                        onSelected: (value) async {
                          if (value == 0) {
                            List list = [];
                            list.add(Map());
                            list.add({"action": "ADD"});
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AnimatedContainer(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    duration: const Duration(milliseconds: 300),
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .65,
                                      width: MediaQuery.of(context).size.width *
                                          .9,
                                      child: Item3Name(
                                        state: state,
                                        list: list,
                                        menuName: widget.menuName,
                                      ),
                                    ),
                                  );
                                });
                          }
                          if (value == 1) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: AnimatedContainer(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      duration:
                                          const Duration(milliseconds: 300),
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .4,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        child: Item2Group(
                                          entryMode: 'Add',
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                          if (value == 6) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .27,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        child: ItemLocationDialogUI(
                                          status: 'ADD',
                                        )),
                                  );
                                });
                          }
                          if (value == 3) {
                            var res = await _itemSql.dropDownData1();

                            dropDownMap = await showDialog(
                              context: context,
                              builder: (_) => DropDownStyle1(
                                acc1TypeList: res,
                                dropdown_title: dropDownMap['Title'],
                                map: dropDownMap,
                              ),
                            );
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: AnimatedContainer(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      duration:
                                          const Duration(milliseconds: 300),
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .9,
                                          child: Item2Group(
                                            entryMode: 'Edit',
                                            itemGroupName:
                                                dropDownMap['Title'].toString(),
                                            itemType: dropDownMap['SubTitle']
                                                .toString(),
                                            itemTypeId: int.parse(
                                                dropDownMap['ID'].toString()),
                                          )),
                                    ),
                                  );
                                });
                          }

                          if (value == 7) {
                            List<Map> list =
                                await _itemSql.DropDownValue() as List<Map>;

                            dropDownMap = await showDialog(
                              context: context,
                              builder: (_) => DropDownStyle1(
                                acc1TypeList:
                                    //snapshot.data,
                                    list,
                                dropdown_title: '',
                                map: dropDownMap,
                              ),
                            );

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .27,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        child: ItemLocationDialogUI(
                                          locationName: dropDownMap,
                                          status: 'Edit',
                                        )),
                                  );
                                });
                          }

                          if (value == 5) {
                            List<Map> dataItemName =
                                await _itemSql.dropDownDataForItemName();

                            dropDownMap = await showDialog(
                              context: context,
                              builder: (_) => DropDownStyle1(
                                acc1TypeList: dataItemName,
                                dropdown_title: dropDownMap['Title'],
                                map: dropDownMap,
                              ),
                            );

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RawMaterialPage(
                                          map: dropDownMap,
                                        )));
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                                value: 0, child: Text('Add New Item')),
                            PopupMenuItem(
                                enabled: false,
                                height: 20,
                                child: Text('Item Category')),
                            PopupMenuItem(
                                height: 30,
                                value: 1,
                                child: Text(
                                  '    Add New Category',
                                  style: TextStyle(fontSize: 12),
                                )),
                            PopupMenuItem(
                                height: 30,
                                value: 3,
                                child: Text(
                                  '    Edit Category',
                                  style: TextStyle(fontSize: 12),
                                )),
                            PopupMenuItem(
                                height: 20,
                                enabled: false,
                                child: Text('Add  Location')),
                            PopupMenuItem(
                                height: 30,
                                value: 6,
                                child: Text(
                                  '    Add  Location',
                                  style: TextStyle(fontSize: 12),
                                )),
                            PopupMenuItem(
                                height: 30,
                                value: 7,
                                child: Text(
                                  '    Edit  Location',
                                  style: TextStyle(fontSize: 12),
                                )),
                            PopupMenuItem(
                                height: 20,
                                enabled: false,
                                child: Text(
                                  'Item Production',
                                )),
                            PopupMenuItem(
                                height: 30,
                                value: 5,
                                child: Text(
                                  '    Production Setting',
                                  style: TextStyle(fontSize: 12),
                                )),
                          ];
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Item Name',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Stock',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List>(
              future: _itemSql.getDefaultQueryData(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return iconData == Icons.list
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: list.length == 0
                              ? snapshot.data!.length
                              : list.length,
                          itemBuilder: (context, index) {
                            Map map = list.length == 0
                                ? snapshot.data![index]
                                : list[index];
                            return InkWell(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      ///title: Text('Select'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.pageview),
                                                SizedBox(width: 10.0),
                                                Text('Item Ledger'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          InkWell(
                                            onTap: () async {
                                              List itemStockEdit =
                                                  await _itemSql.itemStockEdit(
                                                      map['ItemID']);
                                              List list = [];
                                              list.add(map);
                                              list.add({"action": "EDIT"});
                                              list.add(itemStockEdit[0]);
                                              await showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .7,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .9,
                                                        child: Item3Name(
                                                          list: list,
                                                          menuName:
                                                              widget.menuName,
                                                        ),
                                                      ),
                                                    );
                                                  });
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.edit),
                                                SizedBox(width: 10.0),
                                                Text('Edit Item Detail'),
                                              ],
                                            ),
                                            //child: Text('Edit Account Detail'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              onLongPress: () async {},
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                text: Constants.searchMatch(
                                                    map['ItemName'].toString(),
                                                    _searchController.text)),
                                            RichText(
                                                text: Constants.searchMatch(
                                                    map['GroupName'].toString(),
                                                    _searchController.text))
                                          ],
                                        ),
                                      ),
                                      RichText(
                                          text: Constants.searchMatch(
                                              map['Stock'].toString(),
                                              _searchController.text)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : ItemTreeView(list: snapshot.data!);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  getSearchList({required String searchValue}) async {
    originalList = await _itemSql.getDefaultQueryData();
    List<Map<dynamic, dynamic>> tempList = [];

    for (Map<dynamic, dynamic> element in originalList) {
      if (element['ItemName']
              .toString()
              .toLowerCase()
              .contains(searchValue.toLowerCase()) ||
          element['GroupName']
              .toString()
              .toLowerCase()
              .contains(searchValue.toLowerCase()) ||
          element['ItemCode']
              .toString()
              .toLowerCase()
              .contains(searchValue.toLowerCase()) ||
          element['ItemID']
              .toString()
              .toLowerCase()
              .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      }
    }
    list = tempList;
  }
}
