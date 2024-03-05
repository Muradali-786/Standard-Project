import 'package:com/pages/restaurant/Items/ItemsSQL.dart';
import 'package:flutter/material.dart';
import '../../material/drop_down_style1.dart';

class ItemProduction extends StatefulWidget {
  final String item3NameID;
  final List data;

  const ItemProduction(
      {Key? key, required this.item3NameID, required this.data})
      : super(key: key);

  @override
  State<ItemProduction> createState() => _ItemProductionState();
}

class _ItemProductionState extends State<ItemProduction> {
  TextEditingController _rawMaterialController = TextEditingController();

  Map dropDownAccountNameMap = {
    "ID": null,
    'Title': "Item Name",
    'SubTitle': null,
    "Value": null
  };
  ItemSql _itemSql = ItemSql();

  @override
  void initState() {
    super.initState();

    print('.................${widget.data}');
    if (widget.data[0]['Action'] == 'Edit') {
      dropDownAccountNameMap['Title'] = widget.data[1]['ItemName'];
      dropDownAccountNameMap['SubTitle'] = widget.data[1]['Item2GroupName'];
      _rawMaterialController.text = widget.data[1]['RawUseQty'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                    "Raw Material Quantity",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              FutureBuilder(
                future: _itemSql.dropDownDataForItemName(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
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
                          )),
                    );
                  }
                  return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _rawMaterialController,
                      decoration: InputDecoration(
                          label: Text('Raw Quantity'),
                          border: OutlineInputBorder()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
                                      backgroundColor: Colors.brown, // background
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ) // foreground
                                      ),
                                  onPressed: () async {
                                    if (widget.data[0]['Action'] == 'ADD') {
                                      _itemSql.insertRawMaterial(
                                          widget.item3NameID,
                                          dropDownAccountNameMap['ID']
                                              .toString(),
                                          _rawMaterialController.text
                                              .toString());
                                    } else {
                                      _itemSql.updateRawMaterial(widget.data[1]['ID'], dropDownAccountNameMap['ID']
                                          .toString(), _rawMaterialController.text
                                          .toString());


                                    }
                                  },
                                  child: Text(
                                    'Save',
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
                            color: Colors.brown[100],
                            border: Border.all(width: 0, color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
