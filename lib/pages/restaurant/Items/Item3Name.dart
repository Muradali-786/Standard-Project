import 'dart:io';
import 'package:com/main/tab_bar_pages/home/themedataclass.dart';
import 'package:com/pages/material/drop_down_style1.dart';
import 'package:com/pages/restaurant/Items/Item2Group.dart';
import 'package:com/pages/restaurant/Items/ItemsSQL.dart';
import 'package:com/pages/restaurant/SalePur/SalePur2AddItemSQL.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Item3Name extends StatefulWidget {
  final List? list;
  final  state;
  final String? menuName;

  const Item3Name({Key? key,this.state, this.list, this.menuName}) : super(key: key);

  @override
  _Item3NameState createState() => _Item3NameState();
}

class _Item3NameState extends State<Item3Name> {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);

  Map dropDownMap = {
    "ID": null,
    'Title': "Item Name",
    'SubTitle': null,
    "Value": null
  };

  TextEditingController itemName_controller = TextEditingController();
  TextEditingController _openingQty_controller = TextEditingController();
  TextEditingController _costOfUnit_controller = TextEditingController();
  TextEditingController _totalCost_controller = TextEditingController();
  TextEditingController standard_sale_price_controller =
      TextEditingController();
  TextEditingController item_code_controller = TextEditingController();
  TextEditingController minimum_stock_required_controller =
      TextEditingController();
  TextEditingController web_url_controller = TextEditingController();
  TextEditingController item_description_controller = TextEditingController();

  DatabaseProvider db = DatabaseProvider();

  SalePur2AddItemSQl _pur2addItemSQl = SalePur2AddItemSQl();
  ItemSql _itemSql = ItemSql();

  final _formKey = GlobalKey<FormState>();
  int maxID = 0;
  Map? args;
  String? action;
  String? id;
  String? path;
  String? dir;

  //////////////no use/////////////////////////
  // Future<void> _initDir(String itemId) async {
  //   if (null == dir) {
  //     List<Directory>? list = (await getExternalStorageDirectories());
  //     dir = list![0].path;
  //     if (File(
  //             '$dir/ClientImages/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/ItemImages/$itemId.jpg')
  //         .existsSync()) {
  //       if (mounted) {
  //         setState(() {
  //           path =
  //               '$dir/ClientImages/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/ItemImages/$itemId.jpg';
  //         });
  //       } else {
  //         path =
  //             '$dir/ClientImages/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/ItemImages/$itemId.jpg';
  //       }
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    args = widget.list![0];
    action = widget.list![1]['action'];

    if (action == "EDIT") {
      args = widget.list![0];
      action = widget.list![1]['action'];

      maxID = widget.list![2]['Item3NameID'];
      _openingQty_controller.text = widget.list![2]['QtyAdd'].toString();
      _costOfUnit_controller.text = widget.list![2]['Price'].toString();
      _totalCost_controller.text = widget.list![2]['Total'].toString();
      itemName_controller.text = args!.containsKey('ItemName')
          ? args!['ItemName'] == null
              ? ""
              : args!['ItemName'].toString()
          : "";
      standard_sale_price_controller.text = args!.containsKey('SalePrice')
          ? args!['SalePrice'] == null
              ? ""
              : args!['SalePrice'].toString()
          : "";
      item_code_controller.text = args!.containsKey('ItemCode')
          ? args!['ItemCode'] == null
              ? ''
              : args!['ItemCode'].toString()
          : "";
      minimum_stock_required_controller.text = args!.containsKey('MinimumStock')
          ? args!['MinimumStock'] == null
              ? ""
              : args!['MinimumStock'].toString()
          : "";
      web_url_controller.text = args!.containsKey('WebUrl')
          ? args!['WebUrl'] == null
              ? ""
              : args!['WebUrl'].toString()
          : "";
      item_description_controller.text = args!.containsKey('ItemDescription')
          ? args!['ItemDescription'] == null
              ? ""
              : args!['ItemDescription'].toString()
          : "";
      id = args!.containsKey('ID') ? args!['ID'].toString() : "";
      dropDownMap['ID'] =
          args!.containsKey('GroupID') ? args!['GroupID'] : null;
      dropDownMap['Title'] =
          args!.containsKey('GroupName') ? args!['GroupName'] : null;
      dropDownMap['SubTitle'] =
          args!.containsKey('AccountType') ? args!['AccountType'] : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Provider.of<ThemeDataHomePage>(context, listen: false)
          .backGroundColor,
      child: SingleChildScrollView(
        child: Center(
          child: () {
            if (SharedPreferencesKeys.prefs!
                    .getString(SharedPreferencesKeys.userRightsClient) ==
                'Custom Right') {
              if (widget.list![1]['action'] == 'ADD') {
                return FutureBuilder<bool>(
                  future:
                      _itemSql.userRightsChecking('Inserting', widget.menuName!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == false) {
                        return AlertDialog(
                          title: Text("Message"),
                          content: Text(
                              'You have no ${widget.list![1]['action']} rights by the admin'),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            )
                          ],
                        );
                      } else {
                        return item3NameDialog(context);
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              } else {
                return FutureBuilder<bool>(
                  future: _itemSql.userRightsChecking('Edting', widget.menuName!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == false) {
                        return AlertDialog(
                          title: Text("Message"),
                          content: Text(
                              'You have no ${widget.list![1]['action']} rights by the admin'),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            )
                          ],
                        );
                      } else {
                        return item3NameDialog(context);
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              }
            } else  if(SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.userRightsClient) ==
                'Admin'){
              return item3NameDialog(context);
            }
          }(),
        ),
      ),
    );
  }

  Widget item3NameDialog(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Item Name',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        action == "EDIT"
                            ? Text(
                                maxID.toString(),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            : FutureBuilder(
                                future: _itemSql.maxIdForItem3Name(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data!.toString());
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ////////////////////////////////////////////
                      //Image uploading work
                      ///////////////////////////////////////////
                      (path == null)
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.all(16.0),
                              child: InkWell(
                                child: Center(
                                  child: Container(
                                    height: 250,
                                    width: 250,
                                    color: Colors.blue,
                                    child: Image.file(
                                      File(path!),
                                    ),
                                  ),
                                ),
                                onTap: () async {},
                              )),

                      Center(
                          child: CircleAvatar(
                        child: IconButton(
                          onPressed: () async {
                          },
                          icon: Icon(
                            Icons.camera_alt,
                          ),
                        ),
                      )),

                      SizedBox(
                        height: 15,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: PopupMenuButton<int>(
                            padding: EdgeInsets.only(bottom: 8),
                            icon: Icon(
                              Icons.more_horiz,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onSelected: (value) async {
                              if (value == 0) {
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
                                              entryMode: 'Add',
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                    value: 0, child: Text('Add Item Group')),
                              ];
                            },
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, left: 8, top: 8),
                              child: FutureBuilder(
                                future: _itemSql.dropDownDataItem2(),
                                //getting the dropdown data from query
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
                                                dropdown_title:
                                                    dropDownMap['Title'],
                                                map: dropDownMap,
                                              ),
                                            );
                                            setState(() {});
                                          },
                                          child: DropDownStyle1State
                                              .DropDownButton(
                                            title:
                                                dropDownMap['Title'].toString(),
                                            id: dropDownMap['ID'].toString(),
                                          )),
                                    );
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, left: 8, top: 8),
                              child: TextFormField(
                                controller: itemName_controller,
                                decoration: InputDecoration(
                                  filled: true,
                                    fillColor: Colors.white,
                                    label: Text('Item Name'),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, left: 8, top: 8),
                              child: TextFormField(
                                controller:
                                standard_sale_price_controller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: Text('Standard Sale Price'),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, left: 8, top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('opening stock :'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4, top: 8),
                                              child: TextFormField(

                                                onChanged: (value) {
                                                  int cost = 0;
                                                  int qty = 0;

                                                  if (_costOfUnit_controller
                                                          .text
                                                          .toString()
                                                          .length !=
                                                      0) {
                                                    int.parse(
                                                        _openingQty_controller
                                                            .text
                                                            .toString());
                                                    cost = int.parse(
                                                        _costOfUnit_controller
                                                            .text
                                                            .toString());
                                                  }
                                                  _totalCost_controller.text =
                                                      (qty * cost).toString();
                                                  if (_openingQty_controller
                                                          .text
                                                          .toString()
                                                          .length ==
                                                      0) {
                                                    _totalCost_controller
                                                        .clear();
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    _openingQty_controller,
                                                textAlign: TextAlign.end,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    label: FittedBox(
                                                      child:
                                                          Text('opening Qty'),
                                                    ),
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4, top: 8),
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  int qty = 0;
                                                  int cost = 0;

                                                  if (_openingQty_controller
                                                          .text
                                                          .toString()
                                                          .length !=
                                                      0) {
                                                    cost = int.parse(
                                                        _costOfUnit_controller
                                                            .text
                                                            .toString());
                                                    qty = int.parse(
                                                        _openingQty_controller
                                                            .text
                                                            .toString());
                                                  }
                                                  if (_costOfUnit_controller
                                                          .text
                                                          .toString()
                                                          .length ==
                                                      0) {
                                                    _totalCost_controller
                                                        .clear();
                                                  }
                                                  _totalCost_controller.text =
                                                      (qty * cost).toString();
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    _costOfUnit_controller,
                                                textAlign: TextAlign.end,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    label: FittedBox(
                                                      child:
                                                          Text('Cost of unit'),
                                                    ),
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, top: 8),
                                              child: TextFormField(
                                                readOnly: true,
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.end,
                                                controller:
                                                    _totalCost_controller,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    label: FittedBox(
                                                        child:
                                                            Text('Total Cost')),
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ExpansionTile(
                                title: Text('Option Field'),
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8, top: 8),
                                    child: TextFormField(
                                      controller: item_code_controller,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: Text('Item Code'),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8, top: 8),
                                    child: TextFormField(
                                      controller:
                                          minimum_stock_required_controller,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: Text('Minimum Stock Required'),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8, top: 8),
                                    child: TextFormField(
                                      controller: web_url_controller,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: Text('Web Url'),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8, top: 8),
                                    child: TextFormField(
                                      controller: item_description_controller,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: Text('Item Description'),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
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
                                backgroundColor: Colors.green, // background
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ) // foreground
                                ),
                            onPressed: () async {
                              int item3NameID =
                                  await _itemSql.maxIdForItem3Name();
                              if (_formKey.currentState!.validate()) {
                                if (action == 'ADD') {
                                  await _itemSql.insertItem3Name(
                                    int.parse(dropDownMap['ID']),
                                    itemName_controller.text,
                                    int.parse(standard_sale_price_controller
                                                .text.length ==
                                            0
                                        ? '0'
                                        : standard_sale_price_controller.text),
                                    item_code_controller.text,
                                    web_url_controller.text,
                                    int.parse(minimum_stock_required_controller
                                                .text.length ==
                                            0
                                        ? '0'
                                        : minimum_stock_required_controller
                                            .text),
                                    item_description_controller.text,
                                    path,
                                  );

                                  if (_openingQty_controller.text
                                          .toString()
                                          .length !=
                                      0) {
                                    if (int.parse(_openingQty_controller.text
                                            .toString()) >
                                        0) {
                                      await _pur2addItemSQl.insertSalePur2(
                                          total: double.parse(
                                            _totalCost_controller.text
                                                .toString(),
                                          ),
                                          EntryTime: DateTime.now().toString(),
                                          EntryType: 'SL',
                                          Item3NameId: item3NameID,
                                          ItemDescription: '',
                                          Location: '1',
                                          Price: _costOfUnit_controller.text
                                              .toString(),
                                          Qtyless: '0',
                                          Qty: _openingQty_controller.text
                                              .toString(),
                                          QtyAdd: _openingQty_controller.text
                                              .toString(),
                                          SalePur1ID: 1);
                                    }
                                  }
                                } else {

                                   await _itemSql.UpdateItem3Name(
                                    1,
                                    int.parse(dropDownMap['ID'].toString()),
                                    itemName_controller.text,
                                    int.parse(standard_sale_price_controller
                                                .text.length ==
                                            0
                                        ? '0'
                                        : standard_sale_price_controller.text),
                                    item_code_controller.text,
                                    args!['ItemID'].toString(),
                                    web_url_controller.text,
                                    int.parse(minimum_stock_required_controller
                                                .text.length ==
                                            0
                                        ? '0'
                                        : minimum_stock_required_controller
                                            .text),
                                    item_description_controller.text,
                                  );

                                  await _pur2addItemSQl.UpdateSalePur2(
                                    Price:
                                        _costOfUnit_controller.text.toString(),
                                    Qtyless: '0',
                                    Qty: _openingQty_controller.text.toString(),
                                    QtyAdd:
                                        _openingQty_controller.text.toString(),
                                    SalePur1ID: 1,
                                    Location: '1',
                                    ItemDescription: '',
                                    Item3NameId: maxID,
                                    EntryType: 'SL',
                                    context: context,
                                    OrderStatus: '',
                                    id: widget.list![2]['ID'],
                                    Total:
                                        _totalCost_controller.text.toString(),
                                  );
                                }
                              }

                              Navigator.pop(context);
                              widget.state(() {});
                            },
                            child: Text("Save")),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
