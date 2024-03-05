import 'package:com/pages/restaurant/Items/ItemsSQL.dart';
import 'package:com/pages/restaurant/Items/itemProduction.dart';
import 'package:flutter/material.dart';
import '../../material/drop_down_style1.dart';

class RawMaterialPage extends StatefulWidget {
  final Map map;

  const RawMaterialPage({Key? key, required this.map}) : super(key: key);

  @override
  State<RawMaterialPage> createState() => _RawMaterialPageState();
}

class _RawMaterialPageState extends State<RawMaterialPage> {
  ItemSql _itemSql = ItemSql();
  Map dropDownAccountNameMap = {
    "ID": null,
    'Title': "Item Name",
    'SubTitle': null,
    "Value": null
  };

  @override
  void initState() {
    super.initState();

    dropDownAccountNameMap['ID'] = widget.map['ID'];
    dropDownAccountNameMap['Title'] = widget.map['Title'];
    dropDownAccountNameMap['SubTitle'] = widget.map['SubTitle'];

    print('..............map Data =========== ${widget.map}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: Text(
                      'Production Setting',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ),
              Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product Name'),
                  FutureBuilder(
                    future: _itemSql.dropDownDataForItemName(),
                    builder:
                        (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return InkWell(
                            onTap: () async {
                              dropDownAccountNameMap = await showDialog(
                                context: context,
                                builder: (_) => DropDownStyle1(
                                  acc1TypeList: snapshot.data,
                                  dropdown_title: dropDownAccountNameMap['Title'],
                                  map: dropDownAccountNameMap,
                                ),
                              );
                              print(
                                  '..........................drop.....$dropDownAccountNameMap');
                              setState(() {});
                            },
                            child: DropDownStyle1State.DropDownButton(
                              title: dropDownAccountNameMap['Title'].toString(),
                              subtitle:
                                  dropDownAccountNameMap['SubTitle'].toString(),
                              id: dropDownAccountNameMap['SubTitle'].toString(),
                            ));
                      }
                      return Container();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Raw Material',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                    height: 500,
                                    child: ItemProduction(
                                      item3NameID: dropDownAccountNameMap['ID'],
                                      data: [
                                        {'Action': 'ADD'}
                                      ],
                                    )),
                              );
                            });
                      },
                      child: Icon(Icons.add)),
                ],
              ),
              FutureBuilder<List>(
                future: _itemSql.dataRawMaterial(dropDownAccountNameMap['ID']),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: ListTile(
                            dense: true,
                            tileColor: Colors.grey.shade200,
                            title: Text(
                                snapshot.data![index]['ItemName'].toString()),
                            subtitle: Text(snapshot.data![index]
                                    ['Item2GroupName']
                                .toString()),
                            trailing: SizedBox(
                              width: 50,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: SizedBox(
                                      height: 20,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: popUpButtonForItemEdit(
                                            onSelected: (value) async {
                                          if (value == 0) {
                                            List list = [];
                                            list.add({'Action': 'Edit'});
                                            list.add(snapshot.data![index]);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Align(
                                                    alignment: Alignment.center,
                                                    child: SizedBox(
                                                        height: 500,
                                                        child: ItemProduction(
                                                          item3NameID: snapshot
                                                              .data![index][
                                                                  'Item3NameID']
                                                              .toString(),
                                                          data: list,
                                                        )),
                                                  );
                                                });
                                          } else {}
                                        }),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 5,
                                      child: Text(snapshot.data![index]
                                              ['RawUseQty']
                                          .toString())),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      icon: Icon(
        Icons.more_horiz,
        size: 20,
        color: Colors.grey,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('Edit')),
          // PopupMenuItem(value: 1, child: Text('Delete')),
        ];
      },
    );
  }

}
