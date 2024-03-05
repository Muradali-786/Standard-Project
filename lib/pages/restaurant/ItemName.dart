import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:com/pages/restaurant/ItemGroup.dart';
import 'package:com/pages/restaurant/resturantSQL.dart';
import 'package:provider/provider.dart';

class ItemName extends StatefulWidget {
  final String groupName;
  final int groupID;
  final int index;
  final int salPur1ID;
  final int sliderValue;


  ItemName({
    required this.salPur1ID,
    required this.groupName,
    required this.index,
    required this.groupID,
    required this.sliderValue,
  });

  @override
  _ItemNameState createState() => _ItemNameState();
}

class _ItemNameState extends State<ItemName>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlaying = false;
  @override
  void initState() {
   Provider.of<RestaurantDatabaseProvider>(context, listen: false)
        .getItem3Name();
        
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final GlobalKey<FormState> _form1 = GlobalKey<FormState>();

  final GlobalKey<FormState> _form2 = GlobalKey<FormState>();

  final GlobalKey<FormState> _form3 = GlobalKey<FormState>();

  List<PopupMenuItem<int>> tableitems = [
    PopupMenuItem(
      value: 0,
      child: Text("Add Item"),
    ),
    PopupMenuItem(
      value: 1,
      child: Text("Edit Group Name"),
    ),
    PopupMenuItem(
      value: 2,
      child: Text("Delete Group"),
    ),
  ];
  //var count = [];
  List<PopupMenuItem<int>> singleIableItems = [
    PopupMenuItem(
      value: 0,
      child: Text("Edit Item Name"),
    ),
    PopupMenuItem(
      value: 1,
      child: Text("Delete Item"),
    ),
  ];

  final itemController = TextEditingController();
  final itemSalesController = TextEditingController();

  final singletableController = TextEditingController();
  final itemSalesUpdateController = TextEditingController();

  final portionController = TextEditingController();

  final quantityController = TextEditingController();

  List temListForSalePurInsertion = [];
 

  int countOccurrencesUsingLoop(List list, int element) {
    if (list.isEmpty) {
      return 0;
    }

    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == element) {
        count++;
      }
    }

    //debugPrint(count.toString());

    return count;
  }

  @override
  Widget build(BuildContext context) {
    //final isGet = MediaQuery.of(context).orientation;
    return Consumer<RestaurantDatabaseProvider>(
        builder: (context, providerValue, child) {
          //debugPrint(providerValue.listOfItem3Name.toString());
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.groupName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  if(widget.salPur1ID == 0){
                    providerValue.addSalePur1();
                  }
                  var distinctList = temListForSalePurInsertion.toSet().toList();
                   debugPrint(distinctList.toString());
                  List<int> listItemCount = [];
                  for(int i=0;i<distinctList.length;i++){
                    int obj = countOccurrencesUsingLoop(temListForSalePurInsertion, temListForSalePurInsertion[i]);
                    listItemCount.add(obj);                    
                  }
                  debugPrint(listItemCount.toString());
                  await providerValue.getMaxValueSalePur2();


                },
                child: Text('Confirm Order'),
                color: Colors.green,
              ),
              Row(
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 450),
                    child: isPlaying
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isPlaying = !isPlaying;
                                isPlaying
                                    ? _animationController.forward()
                                    : _animationController.reverse();
                              });
                            },
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                            },
                            icon: Icon(Icons.keyboard_arrow_up_rounded),
                          ),
                  ),
                  PopupMenuButton<int>(
                    onSelected: (value) {
                      switch (value) {
                        case 0:
                          showDialog(
                            context: context,
                            builder: (_) => SingleChildScrollView(
                              child: AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    AutoSizeText(
                                      "Add New Item in \n ${widget.groupName}",
                                      textAlign: TextAlign.center,
                                      //maxLines: 1,
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Form(
                                    key: _form,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: itemController,
                                          decoration: InputDecoration(
                                            labelText: "Add Item",
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty)
                                              return 'Item Name should not be empty';
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: itemSalesController,
                                          decoration: InputDecoration(
                                            labelText: "Sales Price",
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty)
                                              return 'Sales Price should not be empty';
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.greenAccent),
                                      ),
                                      onPressed: () async {
                                        await providerValue
                                            .getMaxValueItem3Name();
                                        int maxValItem =
                                            providerValue.maxIdOfItem3Name!;

                                        if (!_form.currentState!.validate())
                                          return;
                                        providerValue.addItem3Name(
                                          itemNameID: maxValItem,
                                          itemName: itemController.text,
                                          gID: widget.groupID,
                                          itemSale: double.parse(
                                            itemSalesController.text,
                                          ),
                                        );
                                        // DatabaseHelper.addItemName(
                                        //     itemNameID: maxValItem,
                                        //     itemName: itemController.text,
                                        //     gID: widget.groupID,
                                        //     itemSale: double.parse(
                                        //         itemSalesController.text));
                                        // widget.items.add(
                                        //   Item3Name(
                                        //     item3NameID: maxValItem,
                                        //     item2GroupID: widget.groupID,
                                        //     itemName: itemController.text,
                                        //     clientID: 0,
                                        //     clientUserID: 0,
                                        //     netCode: "",
                                        //     sysCode: "",
                                        //     salePrice: double.parse(
                                        //         itemSalesController.text),
                                        //     itemCode: "",
                                        //     stock: 0,
                                        //     updatedDate: "",
                                        //     itemStatus: "Empty",
                                        //     webUrl: "",
                                        //     minimumStock: 0,
                                        //     itemDescription: "",
                                        //   ),
                                        // );
                                        // MyApp.itemNames.add(
                                        //   Item3Name(
                                        //     item3NameID: maxValItem,
                                        //     item2GroupID: widget.groupID,
                                        //     itemName: itemController.text,
                                        //     clientID: 0,
                                        //     clientUserID: 0,
                                        //     netCode: "",
                                        //     sysCode: "",
                                        //     salePrice: double.parse(
                                        //         itemSalesController.text),
                                        //     itemCode: "",
                                        //     stock: 0,
                                        //     updatedDate: "",
                                        //     itemStatus: "Empty",
                                        //     webUrl: "",
                                        //     minimumStock: 0,
                                        //     itemDescription: "",
                                        //   ),
                                        // );

                                        // setState(() {});
                                        itemController.clear();
                                        itemSalesController.clear();
                                        //widget.change();
                                        //_form.currentState!.reset();
                                        //tableController.clear();
                                        //Navigator.of(context).pop();
                                      },
                                      child: Text("Add"),
                                    ),
                                  ),
                                ],
                                //shape: CircleBorder(),
                                elevation: 20,
                              ),
                            ),
                          );
                          break;
                        case 1:
                          showDialog(
                            context: context,
                            builder: (_) => SingleChildScrollView(
                              child: AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Edit Group Name"),
                                    IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: Icon(
                                        Icons.close,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Form(
                                    key: _form1,
                                    child: TextFormField(
                                      controller: portionController,
                                      decoration: InputDecoration(
                                        labelText: "Edit Group Name",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return 'Group Name should not be empty';
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.greenAccent,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (!_form1.currentState!.validate())
                                          return;
                                        providerValue.updateItemGroup(
                                            newName: portionController.text,
                                            itemGroupID: widget.groupID);
                                        // providerValue.up
                                        // widget.chnageName(
                                        //   portionController.text,
                                        //   widget.index,
                                        //   widget.groupID,
                                        // );
                                        portionController.text = "";
                                        //_form1.currentState!.reset();
                                        //portionController.clear();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Update"),
                                    ),
                                  ),
                                ],
                                elevation: 20,
                              ),
                            ),
                          );

                          break;
                        case 2:
                          // widget.deleteGroup(
                          //   widget.index,
                          //   widget.groupID,
                          // );

                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return tableitems;
                    },
                  )
                ],
              ),
            ],
          ),
          Text(
            "6/3675",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          providerValue.listOfItem3Name.isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(10),
                  //height: 20,
                  height: MediaQuery.of(context).orientation ==
                          Orientation.portrait
                      ? providerValue.listOfItem3Name.isEmpty || !isPlaying
                          ? 20
                          : ItemGroupState.slVal.round() == 5
                              ? (providerValue.listOfItem3Name.length / 5)
                                      .ceilToDouble() *
                                  110
                              : ItemGroupState.slVal.round() == 4
                                  ? (providerValue.listOfItem3Name.length / 4)
                                          .ceilToDouble() *
                                      120
                                  : ItemGroupState.slVal.round() == 3
                                      ? (providerValue.listOfItem3Name.length / 3)
                                              .ceilToDouble() *
                                          170
                                      : ItemGroupState.slVal.round() == 2
                                          ? (providerValue.listOfItem3Name.length / 2)
                                                  .ceilToDouble() *
                                              180
                                          : ItemGroupState.slVal.round() == 1
                                              ? (providerValue.listOfItem3Name
                                                              .length /
                                                          1)
                                                      .ceilToDouble() *
                                                  350
                                              : 100
                      : providerValue.listOfItem3Name.isEmpty || !isPlaying
                          ? 20
                          : ItemGroupState.slVal.round() == 5
                              ? (providerValue.listOfItem3Name.length / 5)
                                      .ceilToDouble() *
                                  65
                              : ItemGroupState.slVal.round() == 4
                                  ? (providerValue.listOfItem3Name.length / 4)
                                          .ceilToDouble() *
                                      70
                                  : ItemGroupState.slVal.round() == 3
                                      ? (providerValue.listOfItem3Name.length / 3).ceilToDouble() * 85
                                      : ItemGroupState.slVal.round() == 2
                                          ? (providerValue.listOfItem3Name.length / 2).ceilToDouble() * 110
                                          : ItemGroupState.slVal.round() == 1
                                              ? (providerValue.listOfItem3Name.length / 1).ceilToDouble() * 185
                                              : 100,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ItemGroupState.slVal.round(),
                      childAspectRatio: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? ItemGroupState.slVal.round() == 5
                              ? 0.7
                              : ItemGroupState.slVal.round() == 4
                                  ? 0.8
                                  : ItemGroupState.slVal.round() == 3
                                      ? 0.8
                                      : ItemGroupState.slVal.round() == 2
                                          ? 1.1
                                          : ItemGroupState.slVal.round() == 1
                                              ? 1
                                              : 100
                          : ItemGroupState.slVal.round() == 5
                              ? 2.5
                              : ItemGroupState.slVal.round() == 4
                                  ? 3
                                  : ItemGroupState.slVal.round() == 3
                                      ? 3
                                      : ItemGroupState.slVal.round() == 2
                                          ? 3.5
                                          : ItemGroupState.slVal.round() == 1
                                              ? 4
                                              : 100,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: providerValue.listOfItem3Name.length,
                    itemBuilder: (context, idx) {
                      //count.add(0);
                      //print((widget.items.length / 5).ceilToDouble());
                      return Container(
                        //alignment: Alignment.center,
                        //width: MediaQuery.of(context).size.width / 8,
                        //height: MediaQuery.of(context).size.width / 15 +
                        //MediaQuery.of(context).size.width / 30,
                        child: Column(
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => SingleChildScrollView(
                                    child: AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Enter Quantity"),
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: Icon(
                                              Icons.close,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        Form(
                                          key: _form3,
                                          child: TextFormField(
                                            controller: quantityController,
                                            decoration: InputDecoration(
                                              labelText: "Enter Quantity",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty)
                                                return 'Quantity should not be empty';
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Colors.greenAccent,
                                              ),
                                            ),
                                            onPressed: () {
                                              if (!_form3.currentState!
                                                  .validate()) return;
                                              // widget.items[idx].addCountMass(
                                              //   int.parse(quantityController.text),
                                              // );
                                              // MyApp.itemNames
                                              //     .firstWhere((element) =>
                                              //         element.item2GroupID ==
                                              //             widget.items![idx]
                                              //                 .item2GroupID &&
                                              //         element.item3NameID ==
                                              //             widget.items![idx]
                                              //                 .item3NameID)
                                              //     .addCountMass(
                                              //       int.parse(quantityController
                                              //           .text),
                                              //     );
                                              // // count[idx] = count[idx] +
                                              // //     int.parse(quantityController.text);
                                              // setState(() {});
                                            },
                                            child: Text("Add Quantity"),
                                          ),
                                        ),
                                      ],
                                      elevation: 20,
                                    ),
                                  ),
                                );
                              },
                              onDoubleTap: () {
                                // if (widget.items![idx].count > 0) {
                                //   //widget.items[idx].subCount();
                                //   MyApp.itemNames
                                //       .firstWhere((element) =>
                                //           element.item2GroupID ==
                                //               widget.items![idx].item2GroupID &&
                                //           element.item3NameID ==
                                //               widget.items![idx].item3NameID)
                                //       .subCount();
                                //   setState(() {});
                                // }
                                // if (count[idx] > 0) {
                                //   count[idx] = count[idx] - 1;
                                //   setState(() {});
                                // }
                              },
                              onTap: () {
                                temListForSalePurInsertion.add(providerValue
                                    .listOfItem3Name[idx]['Item3NameID']);

                                // tempMapOfItemId.add({
                                //   'itemNameID': providerValue
                                //       .listOfItem3Name[idx]['Item3NameID'],
                                //   'itemNameIDCount': tempMapOfItemId[idx]
                                //           ['itemNameIDCount'] +
                                //       1,
                                // });

                                debugPrint(
                                    temListForSalePurInsertion.toString());

                                //widget.items[idx].addCount();
                                // MyApp.itemNames
                                //     .firstWhere((element) =>
                                //         element.item2GroupID ==
                                //             widget.items![idx].item2GroupID &&
                                //         element.item3NameID ==
                                //             widget.items![idx].item3NameID)
                                //     .addCount();
                                // //count[idx] = count[idx] + 1;
                                 setState(() {});
                              },
                              child: Container(
                                height: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? ItemGroupState.slVal.round() == 5
                                        ? MediaQuery.of(context).size.height /
                                            15
                                        : ItemGroupState.slVal.round() == 4
                                            ? MediaQuery.of(context).size.height /
                                                11
                                            : ItemGroupState.slVal.round() == 3
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8
                                                : ItemGroupState.slVal.round() ==
                                                        2
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        6.5
                                                    : ItemGroupState.slVal
                                                                .round() ==
                                                            1
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            3
                                                        : 0
                                    : ItemGroupState.slVal.round() == 5
                                        ? MediaQuery.of(context).size.width / 25
                                        : ItemGroupState.slVal.round() == 4
                                            ? MediaQuery.of(context).size.width /
                                                20
                                            : ItemGroupState.slVal.round() == 3
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    15
                                                : ItemGroupState.slVal.round() ==
                                                        2
                                                    ? MediaQuery.of(context).size.width / 10
                                                    : ItemGroupState.slVal.round() == 1
                                                        ? MediaQuery.of(context).size.width / 5
                                                        : 0,
                                //width: MediaQuery.of(context).size.width / 8,
                                // color: providerValue.listOfItem3Name[idx]
                                //                 ['ItemStatus'] ==
                                //             'Empty' ||
                                //         providerValue.listOfItem3Name[idx]
                                //                 ['ItemStatus'] ==
                                //             ""
                                //     ? ItemGroupState
                                //         .colorList[ItemGroupState.colorVal]![1]
                                //     : ItemGroupState
                                //         .colorList[ItemGroupState.colorVal]![2],
                                color: Colors.yellow[100],
                                child: Center(
                                  child: AutoSizeText(
                                    providerValue.listOfItem3Name[idx]
                                        ['ItemName'],
                                    style: TextStyle(fontSize: 50),
                                    maxLines: 3,
                                    //minFontSize: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              onSelected: (value) {
                                switch (value) {
                                  case 0:
                                    showDialog(
                                      context: context,
                                      builder: (_) => SingleChildScrollView(
                                        child: AlertDialog(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Edit Item name"),
                                              IconButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                icon: Icon(
                                                  Icons.close,
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            Form(
                                              key: _form2,
                                              child: TextFormField(
                                                controller:
                                                    singletableController,
                                                decoration: InputDecoration(
                                                  labelText: "Edit Item Name",
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty)
                                                    return 'Item Name should not be empty';
                                                  return null;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.greenAccent),
                                                ),
                                                onPressed: () {
                                                  if (!_form2.currentState!
                                                      .validate()) return;
                                                  providerValue.updateItem3Name(
                                                      newName:
                                                          singletableController
                                                              .text,
                                                      itemGroupID: providerValue
                                                              .listOfItem3Name[
                                                          idx]['Item2GroupID'],
                                                      itemNameID: providerValue
                                                              .listOfItem3Name[
                                                          idx]['Item3NameID']);
                                                  singletableController.clear();
                                                  // _form2.currentState!.reset();
                                                  //singletableController.clear();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Update"),
                                              ),
                                            ),
                                          ],
                                          elevation: 20,
                                        ),
                                      ),
                                    );
                                    break;
                                  case 1:
                                    providerValue.deleteItem3Name(
                                        itemNameID:
                                            providerValue.listOfItem3Name[idx]
                                                ['Item3NameID'],
                                        itemGroupID:
                                            providerValue.listOfItem3Name[idx]
                                                ['Item2GroupID']);
                                    break;
                                }
                              },
                              itemBuilder: (context) {
                                return singleIableItems;
                              },
                              child: Container(
                                //height: MediaQuery.of(context).size.width / 30,
                                //width: MediaQuery.of(context).size.width / 8,
                                // color: ItemGroupState
                                //     .colorList[ItemGroupState.colorVal]![3],
                                color: Colors.blue[300],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        "${providerValue.listOfItem3Name[idx]['SalePrice']}"),
                                    Text(
                                    "${countOccurrencesUsingLoop(temListForSalePurInsertion, providerValue.listOfItem3Name[idx]['Item3NameID']).toString()}",
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Container()
        ],
      );
    });
  }
}
