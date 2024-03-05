import 'package:com/pages/restaurant/total_amount.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import 'TableViewScreen.dart';
import 'resturantSQL.dart';

class DefaultTableService extends StatefulWidget {
  DefaultTableService({Key? key}) : super(key: key);

  @override
  State<DefaultTableService> createState() => _DefaultTableServiceState();
}

class _DefaultTableServiceState extends State<DefaultTableService> {
  RestaurantDatabaseProvider providerValue = RestaurantDatabaseProvider();

  final portionController = TextEditingController();

  final GlobalKey<FormState> _form1 = GlobalKey<FormState>();

  static double slVal = 5;
  late int homeSliderValue = 3;
  bool check = true;

  @override
  void initState() {
    super.initState();
    if (!SharedPreferencesKeys.prefs!.containsKey('portionGrid')) {
      SharedPreferencesKeys.prefs!
          .setDouble('portionGrid', homeSliderValue.toDouble());
    } else {
      homeSliderValue =
          SharedPreferencesKeys.prefs!.getDouble('portionGrid')!.toInt();
    }
  }

  List<PopupMenuItem<int>> portionItems = [
    PopupMenuItem(
      value: 0,
      child: Text("Add Portion"),
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
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
            .backGroundColor,
        body: ListView(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<int>(
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      showDialog(
                        context: context,
                        builder: (_) => SingleChildScrollView(
                          child: AlertDialog(
                            backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
                                .backGroundColor,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Add New Portion "),
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
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,

                                    labelText: "Add Portion",
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'Portion Name should not be empty';
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: ElevatedButton(
                                  style:ElevatedButton.styleFrom(
                                    backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
                                        .borderTextAppBarColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await providerValue
                                        .getMaxValuePortionRestaurant1Portion();

                                    if (!_form1.currentState!.validate()) return;


                                    print(providerValue.maxIdOfRestaurant1Portion);

                                    providerValue.addPortion(
                                      portionID:
                                      providerValue.maxIdOfRestaurant1Portion!,
                                      portionName: portionController.text,
                                    );
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
              ),
            ),
            FutureBuilder(
                future: providerValue.getPortion(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {

                    // if(check) {
                    //   Provider
                    //       .of<TotalAmount>(context, listen: false)
                    //       .grandTotal.clear();
                    //   List.generate(snapshot.data!.length, (index) {
                    //     Provider
                    //         .of<TotalAmount>(context, listen: false)
                    //         .grandTotal
                    //         .add(0.0);
                    //   });
                    //   check = false;
                    // }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 3, right: 3),
                            child: TableViewScreen(
                                portionName: snapshot.data![index]['PortionName'],
                                index: index,
                                portionID: snapshot.data![index]['PortionID'],
                                tables: snapshot.data!,
                                sliderValue: homeSliderValue),
                          ),
                          color: Provider.of<ThemeDataHomePage>(context, listen: false)
                              .borderTextAppBarColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: StatefulBuilder(
                              builder: (context, State) => Container(
                                height: 80,
                                width: 300,
                                alignment: Alignment.center,
                                child: Material(
                                  child: Slider(
                                      value: SharedPreferencesKeys.prefs!
                                          .getDouble('portionGrid')!,
                                      min: 1.0,
                                      max: 4,
                                      onChanged: (double value) {
                                        State(() {});
                                        setState(() {
                                          homeSliderValue = value.toInt();
                                        });
                                        SharedPreferencesKeys.prefs!.setDouble(
                                            'portionGrid',
                                            homeSliderValue.toDouble());
                                      }),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  icon: Icon(Icons.settings)),
            ),
          ],
        ),
      );
  }
}
