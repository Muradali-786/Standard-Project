import 'package:auto_size_text/auto_size_text.dart';
import 'package:com/main/tab_bar_pages/home/themedataclass.dart';
import 'package:com/pages/general_trading/CashBook/CashBookEntryDialogUI.dart';
import 'package:com/pages/general_trading/CashBook/cashBookSql.dart';
import 'package:com/pages/restaurant/SalePur/SalePur2AddItemBySelection.dart';
import 'package:com/pages/restaurant/SalePur/salePurItemUI.dart';
import 'package:com/pages/restaurant/SalePur/sale_pur1_SQL.dart';
import 'package:com/pages/restaurant/resturantSQL.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared_preferences/shared_preference_keys.dart';

class TableViewScreen extends StatefulWidget {
  final String portionName;
  final Function? changeName;
  final Function? deletePortion;
  final int portionID;
  final int index;
  final int sliderValue;
  final List tables;

  TableViewScreen({
    required this.portionName,
    this.changeName,
    this.deletePortion,
    required this.index,
    required this.portionID,
    required this.tables,
    required this.sliderValue,
  });

  @override
  _TableViewScreenState createState() => _TableViewScreenState();
}

class _TableViewScreenState extends State<TableViewScreen> {
  bool isPlaying = true;
  final tableController = TextEditingController();
  final singleTableController = TextEditingController();
  final portionController = TextEditingController();
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  DateTime currentDate = DateTime.now();
  RestaurantDatabaseProvider providerValue = RestaurantDatabaseProvider();
  CashBookSQL _cashBookSQL = CashBookSQL();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final GlobalKey<FormState> _form1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _form2 = GlobalKey<FormState>();
  double grandTotalTable = 0.0;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
  }

  List<PopupMenuItem<int>> tableItems = [
    PopupMenuItem(
      value: 0,
      child: Text("Add Table"),
    ),
    PopupMenuItem(
      value: 1,
      child: Text("Edit Portion Name"),
    ),
    PopupMenuItem(
      value: 2,
      child: Text("Delete Portion"),
    ),
  ];

  List<PopupMenuItem<int>> singleTableItems = [
    PopupMenuItem(
      value: 0,
      child: Text("Edit Table Name"),
    ),
    PopupMenuItem(
      value: 1,
      child: Text("Delete Table"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      trailing: Icon(
        Icons.keyboard_arrow_down_outlined,
        size: 30,
      ),
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      collapsedBackgroundColor: Colors.transparent,
      backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
          .borderTextAppBarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.portionName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
              ),
              Text(
                '0.0',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          ///        drop down button ....................................................
          Align(
            alignment: Alignment.center,
            child: PopupMenuButton<int>(
              icon: Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ),
              onSelected: (value) {
                switch (value) {
                  case 0:
                    showDialog(
                      context: context,
                      builder: (_) => Center(
                        child: AlertDialog(
                          backgroundColor: Provider.of<ThemeDataHomePage>(
                                  context,
                                  listen: false)
                              .backGroundColor,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AutoSizeText(
                                "Add New Table in \n${widget.portionName}",
                                textAlign: TextAlign.start,
                              ),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                          actions: [
                            Form(
                              key: _form,
                              child: TextFormField(
                                controller: tableController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: const OutlineInputBorder(),
                                  labelText: "Add Table",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Table Name should not be empty';
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Provider.of<ThemeDataHomePage>(context,
                                              listen: false)
                                          .borderTextAppBarColor,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  await providerValue
                                      .getMaxValueRestaurant2TableTable();
                                  int maxValTable =
                                      providerValue.maxIdOfRestaurant2Table!;
                                  if (!_form.currentState!.validate()) return;
                                  providerValue.addTable(
                                    portionID: widget.portionID,
                                    tableID: maxValTable,
                                    tableName: tableController.text,
                                  );
                                  tableController.text = "";
                                },
                                child: Text("Add"),
                              ),
                            ),
                          ],
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
                          backgroundColor: Provider.of<ThemeDataHomePage>(
                                  context,
                                  listen: false)
                              .backGroundColor,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Edit Portion Name"),
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
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: const OutlineInputBorder(),
                                  labelText: "Edit Portion Name",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Portion Name should not be empty';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Provider.of<ThemeDataHomePage>(context,
                                              listen: false)
                                          .borderTextAppBarColor,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  if (!_form1.currentState!.validate()) return;
                                  providerValue.updatePortion(
                                      newName: portionController.text,
                                      portionID: widget.portionID);
                                  portionController.text = "";
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
                    providerValue.deletePortion(portionID: widget.portionID);
                    break;
                }
              },
              itemBuilder: (context) {
                return tableItems;
              },
            ),
          ),
        ],
      ),
      children: [
        Container(
          color: Provider.of<ThemeDataHomePage>(context, listen: false)
              .backGroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: providerValue.getTable(widget.portionID),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  // for(int i = 0 ; i < snapshot.data!.length ; i++) {
                  //   if (snapshot.data![i]['SalPur1ID'] != 0) {
                  //
                  //   }
                  // }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.sliderValue,
                      childAspectRatio: widget.sliderValue == 1
                          ? 5
                          : widget.sliderValue == 2
                              ? 2.5
                              : widget.sliderValue == 3
                                  ? 1.5
                                  : 1,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, idx) {
                      return GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => Center(
                              child: Material(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .4,
                                  width: MediaQuery.of(context).size.width * .8,
                                  color: Provider.of<ThemeDataHomePage>(context,
                                          listen: false)
                                      .backGroundColor,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ///   add item btn/////...........................
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Provider.of<
                                                                    ThemeDataHomePage>(
                                                                context,
                                                                listen: false)
                                                            .borderTextAppBarColor,
                                                        width: 2),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 35,
                                                  )),
                                              SizedBox(
                                                height: 45,
                                                width: 150,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Provider
                                                            .of<ThemeDataHomePage>(
                                                                context,
                                                                listen: false)
                                                        .borderTextAppBarColor,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    var salePur1ID;
                                                    double billAmount = 0;
                                                    if (providerValue
                                                                .listOfTable[
                                                            idx]['SalPur1ID'] ==
                                                        0) {
                                                      var dropDownMap = {
                                                        "ID": 1,
                                                        'Title': 'Sales',
                                                        'SubTitle': "SL",
                                                        "Value": ''
                                                      };
                                                      salePur1ID = await _salePurSQLDataBase
                                                          .insertSalePur1(
                                                              currentDate
                                                                  .toString()
                                                                  .substring(
                                                                      0, 10),
                                                              SharedPreferencesKeys
                                                                      .prefs!
                                                                      .getInt(SharedPreferencesKeys
                                                                          .defaultSaleTwoAccount) ??
                                                                  0,
                                                              'remarks',
                                                              'person',
                                                              'paymentAfterDate',
                                                              'contactNo',
                                                              dropDownMap);
                                                    } else {
                                                      var billAmountSnap =
                                                          await DatabaseHelper
                                                              .fetchBillAmount(
                                                        salPurID: providerValue
                                                                .listOfTable[
                                                            idx]['SalPur1ID'],
                                                      );

                                                      billAmount = double.parse(
                                                          billAmountSnap[0]
                                                                  ['BillAmount']
                                                              .toString());
                                                    }

                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AddItemBySelection(
                                                              openFor:
                                                                  'restaurant',
                                                              id: providerValue
                                                                      .listOfTable[idx]
                                                                  ['TableID'],
                                                              accountID: 12,
                                                              accountName:
                                                                  'Name',
                                                              billAmount:
                                                                  billAmount,
                                                              contactNo:
                                                                  'contactNo',
                                                              date: DateTime.now()
                                                                  .toString(),
                                                              entryType: 'SL',
                                                              nameOfPerson: '',
                                                              paymentAfterDate:
                                                                  DateTime.now()
                                                                      .toString(),
                                                              remarks: '',
                                                              salePurId1: providerValue
                                                                              .listOfTable[idx]
                                                                          [
                                                                          'SalPur1ID'] ==
                                                                      0
                                                                  ? salePur1ID
                                                                  : providerValue
                                                                          .listOfTable[idx]
                                                                      [
                                                                      'SalPur1ID'])),
                                                    );

                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    "Add Items",
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          ///   edit item btn/////...........................
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Provider.of<
                                                                      ThemeDataHomePage>(
                                                                  context,
                                                                  listen: false)
                                                              .borderTextAppBarColor,
                                                          width: 2),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 35,
                                                    )),
                                                SizedBox(
                                                  height: 45,
                                                  width: 150,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Provider
                                                              .of<ThemeDataHomePage>(
                                                                  context,
                                                                  listen: false)
                                                          .borderTextAppBarColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                    ),
                                                    onPressed: () async {
                                                      if (providerValue
                                                                  .listOfTable[
                                                              idx]['SalPur1ID'] !=
                                                          0) {
                                                        List
                                                            listOFDataSalePur1 =
                                                            [];

                                                        listOFDataSalePur1 =
                                                            await _salePurSQLDataBase
                                                                .getDataFromSalePur(
                                                                    salePur1ID:
                                                                        providerValue.listOfTable[idx]
                                                                            [
                                                                            'SalPur1ID']);

                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    Material(
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child: SalePurItemUI(
                                                                            entryType:
                                                                                'SL',
                                                                            tableID: providerValue.listOfTable[idx][
                                                                                'TableID'],
                                                                            color: Colors
                                                                                .blue,
                                                                            list:
                                                                                listOFDataSalePur1,
                                                                            menuName: widget
                                                                                .portionName,
                                                                            itemData:
                                                                                listOFDataSalePur1,
                                                                            status:
                                                                                'Ledger'),
                                                                      ),
                                                                    ));
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            content: Text(
                                                                'You must select some item to edit'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'OK'))
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      "Edit Item",
                                                      style: TextStyle(
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          ///   cash received btn/////...........................
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Provider.of<
                                                                      ThemeDataHomePage>(
                                                                  context,
                                                                  listen: false)
                                                              .borderTextAppBarColor,
                                                          width: 2),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons
                                                          .monetization_on_outlined,
                                                      size: 35,
                                                    )),
                                                SizedBox(
                                                  width: 150,
                                                  height: 45,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Provider
                                                              .of<ThemeDataHomePage>(
                                                                  context,
                                                                  listen: false)
                                                          .borderTextAppBarColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                    ),
                                                    onPressed: () async {
                                                      if (providerValue
                                                                  .listOfTable[
                                                              idx]['SalPur1ID'] !=
                                                          0) {
                                                        List
                                                            listOFDataSalePur1 =
                                                            [];

                                                        listOFDataSalePur1 =
                                                            await _salePurSQLDataBase
                                                                .getDataFromSalePur(
                                                                    salePur1ID:
                                                                        providerValue.listOfTable[idx]
                                                                            [
                                                                            'SalPur1ID']);

                                                        int maxID =
                                                            await _cashBookSQL
                                                                .maxID();
                                                        List argumentList = [
                                                          {
                                                            "action":
                                                                "Receiving"
                                                          },
                                                          listOFDataSalePur1[0],
                                                          maxID
                                                        ];

                                                        showGeneralDialog(
                                                          context: context,
                                                          pageBuilder: (BuildContext
                                                                  context,
                                                              Animation<double>
                                                                  animation,
                                                              Animation<double>
                                                                  secondaryAnimation) {
                                                            return AnimatedContainer(
                                                              padding: EdgeInsets.only(
                                                                  bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom),
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          300),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Center(
                                                                  child: SizedBox(
                                                                      height: 400,
                                                                      child: Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: CashBook(
                                                                            context: context,
                                                                            list:
                                                                                argumentList,
                                                                            tableID:
                                                                                providerValue.listOfTable[idx]['TableID'],
                                                                            menuName: 'Sale'),
                                                                      ))),
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            content: Text(
                                                                'You must select some item to edit'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'OK'))
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      "Cash Received",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          ///   slip btn/////...........................
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Provider.of<
                                                                      ThemeDataHomePage>(
                                                                  context,
                                                                  listen: false)
                                                              .borderTextAppBarColor,
                                                          width: 2),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.newspaper_sharp,
                                                      size: 35,
                                                    )),
                                                SizedBox(
                                                  width: 150,
                                                  height: 45,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Provider
                                                              .of<ThemeDataHomePage>(
                                                                  context,
                                                                  listen: false)
                                                          .borderTextAppBarColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                    ),
                                                    onPressed: () async {
                                                      if (providerValue
                                                                  .listOfTable[
                                                              idx]['SalPur1ID'] !=
                                                          0) {
                                                        List
                                                            listOFDataSalePur1 =
                                                            [];

                                                        listOFDataSalePur1 =
                                                            await _salePurSQLDataBase
                                                                .getDataFromSalePur(
                                                                    salePur1ID:
                                                                        providerValue.listOfTable[idx]
                                                                            [
                                                                            'SalPur1ID']);

                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder:
                                                        //           (context) =>
                                                        //               Slip(
                                                        //         entryType: 'SL',
                                                        //         tableID: providerValue
                                                        //                 .listOfTable[idx]
                                                        //             ['TableID'],
                                                        //         data:
                                                        //             listOFDataSalePur1,
                                                        //       ),
                                                        //     ));
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            content: Text(
                                                                'You must select some item to edit'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'OK'))
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      "Slip",
                                                      style: TextStyle(
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: snapshot.data![idx]['SalPur1ID'] != 0
                                ? Provider.of<ThemeDataHomePage>(context,
                                        listen: false)
                                    .borderTextAppBarColor
                                : Provider.of<ThemeDataHomePage>(context,
                                        listen: false)
                                    .backGroundColor,
                            border: Border.all(
                              color: Provider.of<ThemeDataHomePage>(context,
                                      listen: false)
                                  .borderTextAppBarColor,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          height: 50,
                          child: Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: FittedBox(
                                    child: Text(
                                      snapshot.data![idx]['TableName'],
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: providerValue.listOfTable[idx]
                                                    ['SalPur1ID'] !=
                                                0
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      maxLines: 3,
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
                                            backgroundColor:
                                                Provider.of<ThemeDataHomePage>(
                                                        context,
                                                        listen: false)
                                                    .backGroundColor,
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Edit Table Name"),
                                                IconButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
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
                                                      singleTableController,
                                                  decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    labelText:
                                                        "Edit Table Name",
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty)
                                                      return 'Table Name should not be empty';
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Provider
                                                            .of<ThemeDataHomePage>(
                                                                context,
                                                                listen: false)
                                                        .borderTextAppBarColor,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    if (!_form2.currentState!
                                                        .validate()) return;
                                                    providerValue.updateTable(
                                                      tableName: providerValue
                                                              .listOfTable[idx]
                                                          ['TableName'],
                                                      tableID: providerValue
                                                              .listOfTable[idx]
                                                          ['TableID'],
                                                      portionID:
                                                          widget.portionID,
                                                    );

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
                                      providerValue.deleteTable(
                                          tableID: providerValue
                                              .listOfTable[idx]['TableID'],
                                          portionID: widget.portionID);
                                      break;
                                  }
                                },
                                itemBuilder: (context) {
                                  return singleTableItems;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Provider.of<ThemeDataHomePage>(
                                            context,
                                            listen: false)
                                        .backGroundColor,
                                  ),
                                  child: Center(
                                      child: providerValue.listOfTable[idx]
                                                  ['SalPur1ID'] !=
                                              0
                                          ? FutureBuilder(
                                              future: DatabaseHelper
                                                  .fetchBillAmount(
                                                salPurID: providerValue
                                                        .listOfTable[idx]
                                                    ['SalPur1ID'],
                                              ),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<List<dynamic>>
                                                      snapshot) {
                                                if (snapshot.hasData &&
                                                    snapshot.data!.length > 0) {
                                                  //grandTotalTable = 0.0;
                                                  //for(int i = 0 ; i < snapshot.data!.length ; i++) {
                                                  //   grandTotalTable +=
                                                  //           snapshot.data![0]
                                                  //           ['BillAmount'];
                                                  // }
                                                  //double value1
                                                  //
                                                  // total  +=  snapshot.data![0]
                                                  //  ['BillAmount'];
                                                  //
                                                  //
                                                  // print('...................$total');
                                                  // Provider.of<TotalAmount>(context, listen: false)
                                                  //     .grandTotal[widget.index] = total;

                                                  return Text(snapshot.data![0]
                                                          ['BillAmount']
                                                      .toString());
                                                } else {
                                                  return const Text('0.0');
                                                }
                                              })
                                          : Text('0.0')),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

// setTotal({required int amount}){
//   Provider.of<ThemeDataHomePage>(
//       context,
//       listen: false)
//       .grandTotal += amount;
// }
}
