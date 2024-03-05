

import 'package:flutter/material.dart';
import 'package:com/pages/restaurant/ItemName.dart';
import 'package:com/pages/restaurant/resturantSQL.dart';
import 'package:provider/provider.dart';

class ItemGroup extends StatefulWidget {
  final String portionName;
  final int portionID;
  final int salePur1ID;
  final int index;

 final int sliderValue;
  final String name;

  ItemGroup({
    required this.portionName,
    required this.index,
    required this.portionID,
    required this.sliderValue,
    required this.name,
    required this.salePur1ID,
  });

  @override
  ItemGroupState createState() => ItemGroupState();
}

class ItemGroupState extends State<ItemGroup> {
  final portionController = TextEditingController();

  final GlobalKey<FormState> _form1 = GlobalKey<FormState>();

  static double slVal = 5;
  int groupLength = 0;
  static int colorVal = 0;
  static var colorList = {
    1: [
      Colors.blue.shade100,
      Colors.blue.shade200,
      Colors.blue.shade400,
      Colors.grey,
    ],
    2: [
      Colors.white54,
      Colors.grey,
      Colors.white54,
      Colors.grey,
    ],
    3: [
      Colors.yellow.shade200,
      Colors.amber,
      Colors.yellow.shade400,
      Colors.orange,
    ],
    4: [
      Colors.blue.shade200,
      Colors.blue,
      Colors.blue.shade100,
      Colors.blue.shade900,
    ],
  };
  List<PopupMenuItem<int>> portionItems = [
    PopupMenuItem(
      value: 0,
      child: Text("Add Group"),
    ),
    PopupMenuItem(
      value: 1,
      child: Text("Layout Settings"),
    ),
  ];

  void slider(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Center(
          child: Text("Column Quantity Change"),
        ),
        actions: [
          Container(
            height: (MediaQuery.of(context).size.height / 6) * 3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Slider(
                  value: slVal,
                  min: 1,
                  max: 5,
                  divisions: 5,
                  label: '$slVal',
                  onChanged: (newValue) {
                    setState(
                      () {
                        slVal = newValue;
                        Navigator.of(context).pop();
                        slider(context);
                      },
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Back Color"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade200,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Back Table Color"),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Empty Table Color"),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade400,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Amount Color"),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          width: 40,
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    Provider.of<RestaurantDatabaseProvider>(context, listen: false)
        .getItemGroup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDatabaseProvider>(
        builder: (context, providerValue, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          title: Text(widget.name),
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
              onSelected: (value) {
                switch (value) {
                  case 0:
                    showDialog(
                      context: context,
                      builder: (_) => SingleChildScrollView(
                        child: AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Add New Group"),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
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
                                  labelText: "Add Item Group",
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
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.greenAccent),
                                ),
                                onPressed: () async {
                                  await providerValue.getMaxValueItemGroup();
                                  int maxVal = providerValue.maxIdOfItemGroup!;

                                  if (!_form1.currentState!.validate()) return;
                                  // MyApp.group.add(
                                  //   Item2Group(
                                  //     //id: ,
                                  //     item2GroupID: maxVal,
                                  //     item1TypeID: 0,
                                  //     item2GroupName: portionController.text,
                                  //     clientID: 0,
                                  //     clientUserID: 0,
                                  //     netCode: "",
                                  //     sysCode: "",
                                  //     updatedDate: "",
                                  //   ),
                                  // );
                                  providerValue.addItemGroup(
                                      itemGroupID: maxVal,
                                      itemGroupName: portionController.text);
                                  // DatabaseHelper.addItemGroup(
                                  //   itemGroupID: maxVal,
                                  //   itemGroupName: portionController.text,
                                  // );
                                  //setState(() {});
                                  // widget.tables.forEach((e) {
                                  //   print(e.tableID);
                                  // });
                                  //change();
                                  //(context as Element).reassemble();
                                  //portionController.clear();
                                  _form1.currentState!.reset();
                                  Navigator.of(context).pop();
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
                    slider(context);
                    break;
                }
              },
              itemBuilder: (context) {
                return portionItems;
              },
            )
          ],
        ),
        body: providerValue.listOfItemGroup.isEmpty
            ? Center(
                child: Text("No Item Right now"),
              )
            : ListView.builder(
                itemCount: providerValue.listOfItemGroup.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemName(
                        salPur1ID: widget.salePur1ID,
                        groupName: providerValue.listOfItemGroup[index]
                            ['Item2GroupName'],
                        index: index,
                        groupID: providerValue.listOfItemGroup[index]
                            ['Item2GroupID'],
                        sliderValue: slVal.round(),
                      ),
                    ),
                    color: Colors.blue[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
      );
    });
  }
}
