import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:com/pages/general_trading/SalePur/model_sale_item_quantity.dart';
import 'package:com/pages/general_trading/SalePur/sale_pur1_SQL.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../main/tab_bar_pages/home/themedataclass.dart';
import '../../material/datepickerstyle1.dart';
import '../../material/drop_down_style1.dart';
import '../../restaurant/resturantSQL.dart';
import '../../sqlite_data_views/sqlite_database_code_provider.dart';
import 'SalePur2AddItemSQL.dart';
import 'SalePur2AddItemUISingle.dart';

class AddItemBySelection extends StatefulWidget {
  final String entryType;
  final int salePurId1;
  final String paymentAfterDate;
  final String contactNo;
  final String openFor;
  final int id;
  final String nameOfPerson;
  final String? accountName;
  final String date;
  final String remarks;
  final int accountID;
  final double? billAmount;

  AddItemBySelection(
      {Key? key,
      required this.entryType,
      required this.accountID,
      required this.remarks,
      required this.id,
      required this.openFor,
      this.billAmount = 0.0,
      required this.accountName,
      required this.contactNo,
      required this.date,
      required this.nameOfPerson,
      required this.paymentAfterDate,
      required this.salePurId1})
      : super(key: key);

  @override
  State<AddItemBySelection> createState() => _AddItemBySelectionState();
}

class _AddItemBySelectionState extends State<AddItemBySelection> {
  TextEditingController quantity_controller = TextEditingController();
  TextEditingController price_controller = TextEditingController();
  TextEditingController total_controller = TextEditingController();
  TextEditingController itemDescription_controller = TextEditingController();
  String EntryTime = DateTime.now().toString();

  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();

  DatabaseProvider db = DatabaseProvider();
  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  List originalList = [];
  double QtyAdd = 0;
  double QtyLess = 0;
  double price = 0;
  double Total = 0;
  List list = [];
  bool checkItemForContain = true;
  double opacity = 0;
  bool sliderOpacity = true;
  int sliderValue = 2;
  Set<String> totalTileCount = {};
  int value = 0;
  bool checkForAdd = false;
  List gridCountList = [];
  String dateTime = '';
  Map<String, dynamic> filterForTable = <String, dynamic>{};
  SalePur2AddItemSQl _pur2addItemSQl = SalePur2AddItemSQl();

  List scaleAnimation = [];

  List<Map<String, dynamic>> tableData = <Map<String, dynamic>>[];
  double grandTotal = 0.0;

  bool quantityLock = false;
  bool priceLock = false;
  bool totalLock = true;

  IconData chekIconForQuantity = CupertinoIcons.textformat_123;
  IconData chekIconForPrice = CupertinoIcons.textformat_123;
  IconData chekIconForTotal = CupertinoIcons.equal;

  List listOfColorOfGrid = [];
  List listOFTotal = [];
  bool checkForQty = true;
  List<double> subTotal = [];

  Map dropDownAccountNameMap = {
    "ID": null,
    'Title': "Item Name",
    'SubTitle': null,
    "Value": null
  };

  @override
  void initState() {
    getListOfItem3Name();
    super.initState();
    grandTotal = widget.billAmount!;
    if (SharedPreferencesKeys.prefs!.getInt('gridValue') == 0) {
      SharedPreferencesKeys.prefs!.setInt('gridValue', 2);
    }

    sliderValue = SharedPreferencesKeys.prefs!.getInt('gridValue') ?? 2;
  }

  Future<List> allItemStockQuery() async {
    var db = await DatabaseProvider().init();
    String query = '''
    Select FlutterQuery from ProjectMenuSub WHERE SabMenuName='All Items';
    ''';
    List queryResult = (await db.rawQuery(query));
    String flutterQuery = queryResult[0]['FlutterQuery'];
    flutterQuery = flutterQuery.replaceAll('@ClientID', clientId);
    flutterQuery = flutterQuery.replaceAll('@Date2', date2);
    flutterQuery = flutterQuery.replaceAll('@Date1', date1);
    list = await db.rawQuery(flutterQuery);
    originalList = list;

    for (int count = 0; count < list.length; count++) {
      totalTileCount.add(list[count]['GroupName']);
    }
    return list;
  }

  getDatabase() async {
    await db.init();
  }

  getListOfItem3Name() async {
    await allItemStockQuery().then((value) {
      list = value;
    });
  }

  void getSearchList(String value) async {
    List<Map<dynamic, dynamic>> tempList = [];
    for (Map<dynamic, dynamic> element in originalList) {
      if (element['ItemName']
          .toString()
          .toLowerCase()
          .contains(value.toLowerCase())) {
        tempList.add(element);
      }
    }
    list = tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
          .backGroundColor,
      appBar: AppBar(
        backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
            .borderTextAppBarColor,
        title: const Text('Add Item By Selection'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                SharedPreferencesKeys.prefs!.setString('CheckStateItem', '');
                showGeneralDialog(
                  context: context,
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return AnimatedContainer(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.center,
                      child: SalesPur2Dialog(
                        remarks: widget.remarks,
                        id: widget.id,
                        contactNo: widget.contactNo,
                        accountID: widget.accountID,
                        date: widget.date,
                        accountName: widget.accountName,
                        NameOfPerson: widget.nameOfPerson,
                        PaymentAfterDate: widget.paymentAfterDate,
                        EntryType: widget.entryType,
                        salePur1Id: widget.salePurId1,
                        map: {},
                        action: 'ADD',
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.keyboard)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                /// textField for searching item..................................
                TextField(
                  onChanged: (value) {
                    setState(() {
                      getSearchList(value);
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), label: Text('Search')),
                ),

                ///   table view of total item selected .......................

                Container(
                  alignment: Alignment.center,
                  child: ExpansionTile(
                    onExpansionChanged: (value) {
                      setState(() {});
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          grandTotal.toStringAsFixed(2),
                          style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    tableData.clear();
                                  });
                                },
                                child: Text('Cancel')),
                            TextButton(
                                onPressed: () async {
                                  for (int count = 0;
                                      count < tableData.length;
                                      count++) {
                                    switch (widget.entryType) {
                                      case 'PU':
                                        setState(() {
                                          QtyAdd = double.parse(tableData[count]
                                                  ['quantity']
                                              .toString());
                                          QtyLess = 0;
                                          price = double.parse(tableData[count]
                                                  ['Price']
                                              .toString());
                                          Total = QtyAdd * price;
                                        });
                                        break;
                                      case 'SR':
                                        setState(() {
                                          QtyAdd = double.parse(tableData[count]
                                                  ['quantity']
                                              .toString());
                                          QtyLess = 0;
                                          price = double.parse(tableData[count]
                                                  ['Price']
                                              .toString());
                                          Total = QtyAdd * price;
                                        });
                                        break;
                                      case 'SL':
                                        setState(() {
                                          QtyLess = double.parse(
                                              tableData[count]['quantity']
                                                  .toString());
                                          QtyAdd = 0;
                                          price = double.parse(tableData[count]
                                                  ['Price']
                                              .toString());
                                          Total = QtyLess * price;
                                        });
                                        break;
                                      case 'PR':
                                        setState(() {
                                          QtyLess = double.parse(
                                              tableData[count]['quantity']
                                                  .toString());
                                          QtyAdd = 0;
                                          price = double.parse(tableData[count]
                                                  ['Price']
                                              .toString());
                                          Total = QtyLess * price;
                                        });
                                        break;
                                      default:
                                        break;
                                    }

                                    await _pur2addItemSQl.insertSalePur2(
                                        total: double.parse(
                                            Total.toStringAsFixed(2)),
                                        Qty: tableData[count]['quantity']
                                            .toString(),
                                        Price: tableData[count]['Price'],
                                        Item3NameId: int.parse(tableData[count]
                                                ['ItemID']
                                            .toString()),
                                        TotalAmount: 0,
                                        Location: '1',
                                        SalePur1ID: widget.salePurId1,
                                        ItemDescription: '',
                                        EntryType: widget.entryType,
                                        EntryTime: EntryTime.toString(),
                                        QtyAdd: QtyAdd.toString(),
                                        Qtyless: QtyLess.toString());
                                  }

                                  if (widget.openFor == 'restaurant') {
                                    await DatabaseHelper.updateTableSalePur1(
                                        tableID: widget.id,
                                        salePur: widget.salePurId1);
                                  }

                                  Navigator.pop(context);
                                },
                                child: Text('Save')),
                          ],
                        )
                      ],
                    ),
                    children: [
                      tableData.isNotEmpty
                          ? Table(
                              border: TableBorder.all(),
                              columnWidths: const <int, TableColumnWidth>{
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(4.5),
                                2: FlexColumnWidth(1),
                                3: FlexColumnWidth(2),
                                4: FlexColumnWidth(2.5),
                              },
                              children: List.generate(
                                tableData.length + 1,
                                (index) {
                                  return TableRow(children: [
                                    Center(
                                        child: index == 0
                                            ? Text('ID')
                                            : Text(tableData[index - 1][
                                                ModelSaleItemQuantity
                                                    .itemIDKey])),
                                    Center(
                                        child: index == 0
                                            ? Text(
                                                'Item Name',
                                                style: TextStyle(fontSize: 12),
                                              )
                                            : Text(tableData[index - 1][
                                                ModelSaleItemQuantity
                                                    .itemNameKey])),
                                    Center(
                                        child: index == 0
                                            ? Text('Qty')
                                            : Text(tableData[index - 1][
                                                ModelSaleItemQuantity
                                                    .quantityKey])),
                                    Center(
                                        child: index == 0
                                            ? Text('Price')
                                            : Text(tableData[index - 1][
                                                ModelSaleItemQuantity
                                                    .priceKey])),
                                    Center(
                                      child: index == 0
                                          ? Text('Total')
                                          : Text(
                                              '${(double.parse(tableData[index - 1][ModelSaleItemQuantity.priceKey]) * double.parse(tableData[index - 1][ModelSaleItemQuantity.quantityKey])).toStringAsFixed(2)}'),
                                    )
                                  ]);
                                },
                              ),
                            )
                          : Center(child: Text('No Data')),
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future: checkForQty
                        ? allItemStockQuery()
                        : Future.delayed(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      if (list.length != 0) {
                        return Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: totalTileCount.length,
                              itemBuilder: (context, index) {
                                gridCountList.clear();
                                for (int i = 0; i < list.length; i++) {
                                  if (totalTileCount.elementAt(index) ==
                                      list[i]['GroupName']) {
                                    gridCountList.add(list[i]);
                                  }
                                }

                                filterForTable.addAll({
                                  totalTileCount.elementAt(index):
                                      List.generate(
                                          gridCountList.length,
                                          (index) =>
                                              gridCountList[index]['ItemID'])
                                });

                                if (listOFTotal.length <
                                    totalTileCount.length) {
                                  listOFTotal.add(gridCountList.length);
                                }
                                if (listOFTotal.length ==
                                    totalTileCount.length) {
                                  if (checkForQty) {
                                    for (int i = 0;
                                        i < totalTileCount.length;
                                        i++) {
                                      subTotal.add(0.0);

                                      scaleAnimation.add(List.generate(
                                          listOFTotal[i], (index) => 1.0));

                                      listOfColorOfGrid.add(List.generate(
                                          listOFTotal[i],
                                          (index) => Colors.white));
                                      listOFTotal[i] = List.generate(
                                          listOFTotal[i],
                                          (index) => [0.0, 0.0, 0.0]);
                                    }
                                    checkForQty = false;
                                  }
                                }

                                return ExpansionTile(
                                  initiallyExpanded: true,
                                  maintainState: true,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(totalTileCount
                                          .elementAt(index)
                                          .toString()),
                                      Text(
                                        checkForQty
                                            ? '0'
                                            : subTotal[index].toString(),
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  children: [
                                    Center(
                                      child: GridView.builder(
                                          itemCount: gridCountList.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  mainAxisExtent: 100,
                                                  crossAxisCount: sliderValue),
                                          itemBuilder: (context, indexGrid) {
                                            return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    SystemSound.play(
                                                        SystemSoundType.click);
                                                    scaleAnimation[index]
                                                        [indexGrid] = .95;

                                                    listOfColorOfGrid[index]
                                                            [indexGrid] =
                                                        Colors.green.shade200;

                                                    ++listOFTotal[index]
                                                        [indexGrid][0];
                                                    for (int i = 0;
                                                        i < list.length;
                                                        i++) {
                                                      if (filterForTable[
                                                                  totalTileCount
                                                                      .elementAt(
                                                                          index)]
                                                              [indexGrid] ==
                                                          list[i]['ItemID']) {
                                                        int singleTotal = 0;

                                                        var modelSaleTableData =
                                                            ModelSaleItemQuantity(
                                                                itemID: list[i][
                                                                        'ItemID']
                                                                    .toString(),
                                                                itemName: list[
                                                                            i]
                                                                        [
                                                                        'ItemName']
                                                                    .toString(),
                                                                quantity: '1',
                                                                price: list[i][
                                                                        'SalePrice']
                                                                    .toString(),
                                                                total: singleTotal
                                                                    .toString());

                                                        listOFTotal[index]
                                                                [indexGrid]
                                                            [1] = listOFTotal[
                                                                    index]
                                                                [indexGrid][0] *
                                                            listOFTotal[index]
                                                                [indexGrid][2];

                                                        if (tableData.length !=
                                                            0) {
                                                          checkForAdd = true;
                                                          for (int j = 0;
                                                              j <
                                                                  tableData
                                                                      .length;
                                                              j++) {
                                                            if (tableData[j][
                                                                    ModelSaleItemQuantity
                                                                        .itemIDKey]
                                                                .toString()
                                                                .contains(list[
                                                                            i][
                                                                        'ItemID']
                                                                    .toString())) {
                                                              value = int.parse(
                                                                  tableData[j][
                                                                          ModelSaleItemQuantity
                                                                              .quantityKey]
                                                                      .toString()
                                                                      .split(
                                                                          '.')
                                                                      .first);
                                                              ++value;

                                                              tableData[j][
                                                                  ModelSaleItemQuantity
                                                                      .quantityKey] = value
                                                                  .toString();
                                                              checkForAdd =
                                                                  false;
                                                            }
                                                          }
                                                        } else {
                                                          tableData.add(
                                                              modelSaleTableData
                                                                  .toMap());
                                                        }
                                                        if (checkForAdd) {
                                                          tableData.add(
                                                              modelSaleTableData
                                                                  .toMap());
                                                        }

                                                        ///     ////////     calculate grand total ///////////////////////////
                                                        List listOfGTotal = [];
                                                        for (int i = 0;
                                                            i <
                                                                tableData
                                                                    .length;
                                                            i++) {
                                                          listOfGTotal.add(double
                                                                  .parse(tableData[
                                                                          i][
                                                                      ModelSaleItemQuantity
                                                                          .priceKey]) *
                                                              double.parse(tableData[
                                                                      i][
                                                                  ModelSaleItemQuantity
                                                                      .quantityKey]));
                                                        }

                                                        grandTotal = 0;

                                                        for (int i = 0;
                                                            i <
                                                                listOfGTotal
                                                                    .length;
                                                            i++) {
                                                          grandTotal +=
                                                              listOfGTotal[i];
                                                        }

                                                        ///  sub total For each person /////////////////////

                                                        for (int i = 0;
                                                            i <
                                                                totalTileCount
                                                                    .length;
                                                            i++) {
                                                          subTotal[i] = 0.0;
                                                          for (int j = 0;
                                                              j <
                                                                  listOFTotal[i]
                                                                      .length;
                                                              j++) {
                                                            subTotal[i] +=
                                                                listOFTotal[i]
                                                                    [j][1];
                                                          }
                                                        }
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: PopupMenuButton<
                                                            int>(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16),
                                                          icon: Icon(
                                                            Icons.more_horiz,
                                                            size: 20,
                                                            color: Colors.grey,
                                                          ),
                                                          onSelected:
                                                              (value) async {
                                                            if (value == 0) {
                                                              for (int i = 0;
                                                                  i < list.length;
                                                                  i++) {
                                                                if (filterForTable[
                                                                            totalTileCount.elementAt(index)]
                                                                        [
                                                                        indexGrid] ==
                                                                    list[i][
                                                                        'ItemID']) {
                                                                  quantity_controller
                                                                          .text =
                                                                      checkForQty
                                                                          ? '0'
                                                                          : listOFTotal[index][indexGrid][0]
                                                                              .toString();
                                                                  price_controller
                                                                      .text = list[
                                                                              i]
                                                                          [
                                                                          'SalePrice']
                                                                      .toString();
                                                                  total_controller
                                                                          .text =
                                                                      checkForQty
                                                                          ? '0'
                                                                          : listOFTotal[index][indexGrid][1]
                                                                              .toString();
                                                                  dropDownAccountNameMap[
                                                                      'ID'] = list[
                                                                              i]
                                                                          [
                                                                          'ItemID']
                                                                      .toString();
                                                                  dropDownAccountNameMap[
                                                                      'Title'] = list[
                                                                              i]
                                                                          [
                                                                          'ItemName']
                                                                      .toString();
                                                                }
                                                              }

                                                              ///  dialog

                                                              await showGeneralDialog(
                                                                context:
                                                                    context,
                                                                pageBuilder: (BuildContext context,
                                                                    Animation<
                                                                            double>
                                                                        animation,
                                                                    Animation<
                                                                            double>
                                                                        secondaryAnimation) {
                                                                  return AnimatedContainer(
                                                                      padding: EdgeInsets.only(
                                                                          bottom: MediaQuery.of(context)
                                                                              .viewInsets
                                                                              .bottom),
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              300),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: dialogForMultiSelection(
                                                                          indexOfGrid:
                                                                              indexGrid,
                                                                          indexOfItem:
                                                                              index,
                                                                          context:
                                                                              context));
                                                                },
                                                              );

                                                              setState(() {});
                                                            }

                                                            if (value == 1) {
                                                              setState(() {
                                                                listOFTotal[index]
                                                                        [
                                                                        indexGrid]
                                                                    [0] = 0.0;
                                                                listOFTotal[index]
                                                                        [
                                                                        indexGrid]
                                                                    [1] = 0.0;
                                                                listOFTotal[index]
                                                                        [
                                                                        indexGrid]
                                                                    [2] = 0.0;

                                                                for (int i = 0;
                                                                    i < list.length;
                                                                    i++) {
                                                                  if (filterForTable[
                                                                              totalTileCount.elementAt(index)]
                                                                          [
                                                                          indexGrid] ==
                                                                      list[i][
                                                                          'ItemID']) {
                                                                    for (int tableCount =
                                                                            0;
                                                                        tableCount <
                                                                            tableData.length;
                                                                        tableCount++) {
                                                                      if (tableData[tableCount][ModelSaleItemQuantity.itemIDKey]
                                                                              .toString() ==
                                                                          list[i]['ItemID']
                                                                              .toString()) {
                                                                        tableData
                                                                            .removeAt(tableCount);
                                                                      }
                                                                    }
                                                                  }
                                                                }

                                                                ///     ////////     calculate grand total ///////////////////////////
                                                                List
                                                                    listOfGTotal =
                                                                    [];
                                                                grandTotal =
                                                                    0.0;
                                                                for (int i = 0;
                                                                    i <
                                                                        tableData
                                                                            .length;
                                                                    i++) {
                                                                  listOfGTotal.add(double.parse(tableData[
                                                                              i]
                                                                          [
                                                                          ModelSaleItemQuantity
                                                                              .priceKey]) *
                                                                      double.parse(tableData[
                                                                              i]
                                                                          [
                                                                          ModelSaleItemQuantity
                                                                              .quantityKey]));
                                                                }
                                                                for (int i = 0;
                                                                    i <
                                                                        listOfGTotal
                                                                            .length;
                                                                    i++) {
                                                                  grandTotal +=
                                                                      listOfGTotal[
                                                                          i];
                                                                }

                                                                ///  sub total For each person /////////////////////
                                                                for (int i = 0;
                                                                    i <
                                                                        totalTileCount
                                                                            .length;
                                                                    i++) {
                                                                  subTotal[i] =
                                                                      0.0;
                                                                  for (int j =
                                                                          0;
                                                                      j <
                                                                          listOFTotal[i]
                                                                              .length;
                                                                      j++) {
                                                                    subTotal[
                                                                            i] +=
                                                                        listOFTotal[i]
                                                                            [
                                                                            j][1];
                                                                  }
                                                                }
                                                              });
                                                            }
                                                          },
                                                          itemBuilder:
                                                              (context) {
                                                            return [
                                                              PopupMenuItem(
                                                                  value: 0,
                                                                  child: Text(
                                                                      'Edit')),
                                                              PopupMenuItem(
                                                                  value: 1,
                                                                  child: Text(
                                                                      'Cancel')),
                                                            ];
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: customGridView(
                                                          onEnd: () {
                                                            setState(() {
                                                              scaleAnimation[
                                                                          index]
                                                                      [
                                                                      indexGrid] =
                                                                  1.0;
                                                            });
                                                          },
                                                          scale: checkForQty
                                                              ? 1.0
                                                              : scaleAnimation[index]
                                                                  [indexGrid],
                                                          context: context,
                                                          itemNameBackColor: checkForQty
                                                              ? Colors.white
                                                              : listOfColorOfGrid[index]
                                                                  [indexGrid],
                                                          itemName: gridCountList[indexGrid]
                                                                  ['ItemName']
                                                              .toString(),
                                                          ItemID: gridCountList[indexGrid]
                                                              ['ItemID'],
                                                          salePrice: checkForQty
                                                              ? gridCountList[indexGrid]['SalePrice']
                                                                  .toString()
                                                              : listOFTotal[index][indexGrid][2] ==
                                                                      0
                                                                  ? gridCountList[indexGrid]['SalePrice']
                                                                      .toString()
                                                                  : listOFTotal[index][indexGrid][2]
                                                                      .toString(),
                                                          quantity: checkForQty
                                                              ? '0'
                                                              : listOFTotal[index][indexGrid][0]
                                                                  .toString(),
                                                          total: checkForQty
                                                              ? '0'
                                                              : listOFTotal[index]
                                                                      [indexGrid][1]
                                                                  .toString()),
                                                    ),
                                                  ],
                                                ));
                                          }),
                                    )
                                  ],
                                );
                              },
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        if (sliderOpacity) {
                                          opacity = 1;
                                          sliderOpacity = false;
                                        } else {
                                          opacity = 0;
                                          sliderOpacity = true;
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.settings,
                                      color: Colors.grey,
                                      size: 12,
                                    )),
                                Opacity(
                                  opacity: opacity,
                                  child: Slider(
                                      value: sliderValue.toDouble(),
                                      min: 1.0,
                                      max: 4.0,
                                      onChanged: (double value) {
                                        setState(() {
                                          sliderValue = value.toInt();
                                          SharedPreferencesKeys.prefs!
                                              .setInt('gridValue', sliderValue);
                                        });
                                      }),
                                )
                              ],
                            )
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customGridView(
      {required String itemName,
      required String salePrice,
      required double scale,
      required void Function()? onEnd,
      required Color itemNameBackColor,
      required BuildContext context,
      required int ItemID,
      required String quantity,
      required String total}) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 50),
      scale: scale,
      onEnd: onEnd,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade200,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 1),
                  spreadRadius: 2,
                  color: Colors.black12,
                  blurRadius: 5)
            ]),
        child: Column(
          children: [
            Flexible(
              flex: 7,
              child: Container(
                alignment: Alignment.center,
                color: itemNameBackColor,
                child: Text(itemName),
              ),
            ),
            Flexible(
              flex: 3,
              child: Row(
                children: [
                  Flexible(
                      flex: 5,
                      child: Center(
                        child: Column(
                          children: [
                            Flexible(
                                flex: 5,
                                child: Center(
                                  child: FittedBox(child: Text(quantity)),
                                )),
                            Flexible(
                                flex: 5,
                                child: Center(
                                  child: FittedBox(child: Text(salePrice)),
                                )),
                          ],
                        ),
                      )),
                  Flexible(
                      flex: 5,
                      child: Center(
                        child: FittedBox(child: Text(total)),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dialogForMultiSelection({
    required int indexOfItem,
    required int indexOfGrid,
    required BuildContext context,
  }) {
    return StatefulBuilder(
      builder: (context, state) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 5,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.blue),
                    borderRadius: BorderRadius.circular(5)),
                height: MediaQuery.of(context).size.height * .55,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //////////////////////////////  action ADD button//////////////////////////////////
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MultiSelection Item',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            0.toString(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: _salePurSQLDataBase.dropDownData1(),
                            builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) =>
                                InkWell(
                                    onTap: () async {
                                      dropDownAccountNameMap = await showDialog(
                                        context: context,
                                        builder: (_) => DropDownStyle1(
                                          acc1TypeList: snapshot.data,
                                          dropdown_title:
                                              dropDownAccountNameMap['Title'],
                                          map: dropDownAccountNameMap,
                                        ),
                                      );

                                      state(() {
                                        _salePurSQLDataBase.UpdateSalePur1(
                                            SPDate: widget.date,
                                            context: context,
                                            ACNameID: int.parse(
                                                dropDownAccountNameMap['ID']
                                                    .toString()),
                                            ContactNo: widget.contactNo,
                                            EntryType: widget.entryType,
                                            NameOfPerson: widget.nameOfPerson,
                                            PaymentAfterDate:
                                                widget.paymentAfterDate,
                                            id: widget.id,
                                            remarks: widget.remarks);
                                      });
                                    },
                                    child: Text(
                                        dropDownAccountNameMap['Title'] ==
                                                "Item Name"
                                            ? widget.accountName
                                            : dropDownAccountNameMap['Title'])),
                          ),
                          InkWell(
                            onTap: () async {
                              var dateTimeC = await Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                var date = DatePickerStyle1();
                                return date;
                              }));

                              state(() {
                                dateTime =
                                    dateTimeC.toString().substring(0, 10);
                              });

                              _salePurSQLDataBase.UpdateSalePur1(
                                  SPDate: dateTimeC.toString().substring(0, 10),
                                  context: context,
                                  ACNameID: widget.accountID,
                                  ContactNo: widget.contactNo,
                                  EntryType: widget.entryType,
                                  NameOfPerson: widget.nameOfPerson,
                                  PaymentAfterDate: widget.paymentAfterDate,
                                  id: widget.id,
                                  remarks: widget.remarks);
                            },
                            child: dateTime == ''
                                ? Text('${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.date.substring(0, 4)), int.parse(widget.date.substring(
                                      5,
                                      7,
                                    )), int.parse(widget.date.substring(8, 10)))).toString()}')
                                : Text('${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(dateTime.substring(0, 4)), int.parse(dateTime.substring(
                                      5,
                                      7,
                                    )), int.parse(dateTime.substring(8, 10)))).toString()}'),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: _pur2addItemSQl.dropDownData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () async {
                                  dropDownAccountNameMap = await showDialog(
                                    context: context,
                                    builder: (_) => DropDownStyle1(
                                      acc1TypeList: snapshot.data,
                                      dropdown_title:
                                          dropDownAccountNameMap['Title'],
                                      map: dropDownAccountNameMap,
                                    ),
                                  );
                                  state(() {});
                                },
                                child: DropDownStyle1State.DropDownButton(
                                  title: dropDownAccountNameMap['Title']
                                      .toString(),
                                  subtitle: dropDownAccountNameMap['SubTitle']
                                      .toString(),
                                  id: dropDownAccountNameMap['ID'].toString(),
                                )),
                          );
                        }
                        return Container();
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Container(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                readOnly: quantityLock,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (totalLock) {
                                    if (quantity_controller.text.length > 0) {
                                      double qtyValue =
                                          double.parse(value.toString());
                                      double totalValue = qtyValue *
                                          double.parse(
                                              price_controller.text.toString());
                                      total_controller.text =
                                          totalValue.toString();
                                    } else {
                                      total_controller.clear();
                                    }
                                  }

                                  if (priceLock) {
                                    if (quantity_controller.text.length > 0) {
                                      double qty = double.parse(
                                          quantity_controller.text.toString());
                                      double total = double.parse(
                                          total_controller.text.toString());

                                      price_controller.text =
                                          (total / qty).toString();
                                    } else {
                                      price_controller.clear();
                                    }
                                  }
                                },
                                controller: quantity_controller,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: FittedBox(child: Text('Quantity'))),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  readOnly: priceLock,
                                  onChanged: (value) {
                                    if (totalLock) {
                                      if (price_controller.text.length > 0) {
                                        double priceValue =
                                            double.parse(value.toString());
                                        double totalValue = priceValue *
                                            double.parse(quantity_controller
                                                .text
                                                .toString());
                                        total_controller.text =
                                            totalValue.toString();
                                      } else {
                                        total_controller.clear();
                                      }
                                    }

                                    if (quantityLock) {
                                      if (price_controller.text.length > 0) {
                                        double priceValue = double.parse(
                                            price_controller.text.toString());
                                        double totalValue = double.parse(
                                            total_controller.text.toString());
                                        quantity_controller.text =
                                            (totalValue / priceValue)
                                                .toStringAsFixed(2)
                                                .toString();
                                      } else {
                                        quantity_controller.clear();
                                      }
                                    }
                                  },
                                  controller: price_controller,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text('Price')),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                readOnly: totalLock,
                                onChanged: (value) {
                                  if (quantityLock) {
                                    if (total_controller.text.length > 0) {
                                      double price = double.parse(
                                          price_controller.text.toString());
                                      double total = double.parse(
                                          total_controller.text.toString());

                                      quantity_controller.text = (total / price)
                                          .toStringAsFixed(2)
                                          .toString();
                                    } else {
                                      quantity_controller.clear();
                                    }
                                  }

                                  if (priceLock) {
                                    if (total_controller.text.length > 0) {
                                      double qty = double.parse(
                                          quantity_controller.text.toString());
                                      double total = double.parse(
                                          total_controller.text.toString());
                                      price_controller.text = (total / qty)
                                          .toStringAsFixed(2)
                                          .toString();
                                    } else {
                                      price_controller.clear();
                                    }
                                  }
                                },
                                controller: total_controller,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Total')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                            onTap: () {
                              state(() {
                                chekIconForQuantity = CupertinoIcons.equal;
                                chekIconForTotal =
                                    CupertinoIcons.textformat_123;
                                chekIconForPrice =
                                    CupertinoIcons.textformat_123;
                                quantityLock = true;
                                priceLock = false;
                                totalLock = false;
                              });
                            },
                            child: Icon(
                              chekIconForQuantity,
                              size: 15,
                            )),
                        InkWell(
                            onTap: () {
                              state(() {
                                chekIconForQuantity =
                                    CupertinoIcons.textformat_123;
                                chekIconForPrice = CupertinoIcons.equal;
                                chekIconForTotal =
                                    CupertinoIcons.textformat_123;

                                priceLock = true;
                                quantityLock = false;
                                totalLock = false;
                              });
                            },
                            child: Icon(
                              chekIconForPrice,
                              size: 15,
                            )),
                        InkWell(
                            onTap: () {
                              state(() {
                                chekIconForQuantity =
                                    CupertinoIcons.textformat_123;
                                chekIconForPrice =
                                    CupertinoIcons.textformat_123;
                                chekIconForTotal = CupertinoIcons.equal;

                                totalLock = true;
                                priceLock = false;
                                quantityLock = false;
                              });
                            },
                            child: Icon(chekIconForTotal, size: 15)),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: itemDescription_controller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Item Description')),
                        ),
                      ),
                    ),

                    ////////////////////////////////// Save Button ///////////////////////////////////////////////
                    FutureBuilder(
                      future: _pur2addItemSQl.dropDownData(),
                      //getting the dropdown data from query
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () async {
                                  dropDownAccountNameMap = await showDialog(
                                    context: context,
                                    builder: (_) => DropDownStyle1(
                                      acc1TypeList: snapshot.data,
                                      dropdown_title:
                                          dropDownAccountNameMap['Title'],
                                      map: dropDownAccountNameMap,
                                    ),
                                  );
                                  state(() {});
                                },
                                child: DropDownStyle1State.DropDownButton(
                                  title: dropDownAccountNameMap['Title']
                                      .toString(),
                                  subtitle: dropDownAccountNameMap['SubTitle']
                                      .toString(),
                                  id: dropDownAccountNameMap['ID'].toString(),
                                )),
                          );
                        }
                        return Container();
                      },
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width / 3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () async {
                                  checkItemForContain = true;
                                  var map = {
                                    ModelSaleItemQuantity.totalKey:
                                        total_controller.text.toString(),
                                    ModelSaleItemQuantity.itemIDKey:
                                        dropDownAccountNameMap['ID'],
                                    ModelSaleItemQuantity.itemNameKey:
                                        dropDownAccountNameMap['Title'],
                                    ModelSaleItemQuantity.priceKey:
                                        price_controller.text.toString(),
                                    ModelSaleItemQuantity.quantityKey:
                                        quantity_controller.text.toString(),
                                  };
                                  if (tableData.length != 0) {
                                    for (int i = 0; i < tableData.length; i++) {
                                      if (tableData[i][ModelSaleItemQuantity
                                                  .itemIDKey]
                                              .toString() ==
                                          map[ModelSaleItemQuantity.itemIDKey]
                                              .toString()) {
                                        checkItemForContain = false;
                                        setState(() {
                                          tableData[i].addAll({
                                            ModelSaleItemQuantity.totalKey:
                                                total_controller.text
                                                    .toString(),
                                            ModelSaleItemQuantity.itemIDKey:
                                                dropDownAccountNameMap['ID'],
                                            ModelSaleItemQuantity.itemNameKey:
                                                dropDownAccountNameMap['Title'],
                                            ModelSaleItemQuantity.priceKey:
                                                price_controller.text
                                                    .toString(),
                                            ModelSaleItemQuantity.quantityKey:
                                                quantity_controller.text
                                                    .toString(),
                                          });

                                          double totalValue = double.parse(
                                              total_controller.text.toString());
                                          double priceValue = double.parse(
                                              price_controller.text.toString());
                                          double qtyValue = double.parse(
                                              quantity_controller.text
                                                  .toString());

                                          listOFTotal[indexOfItem][indexOfGrid]
                                              [0] = qtyValue;
                                          listOFTotal[indexOfItem][indexOfGrid]
                                              [1] = totalValue;
                                          listOFTotal[indexOfItem][indexOfGrid]
                                              [2] = priceValue;

                                          ///     ////////     calculate grand total ///////////////////////////
                                          List listOfGTotal = [];

                                          for (int i = 0;
                                              i < tableData.length;
                                              i++) {
                                            listOfGTotal.add(double.parse(
                                                    tableData[i][
                                                        ModelSaleItemQuantity
                                                            .priceKey]) *
                                                double.parse(tableData[i][
                                                    ModelSaleItemQuantity
                                                        .quantityKey]));
                                          }
                                          grandTotal = 0.0;
                                          for (int i = 0;
                                              i < listOfGTotal.length;
                                              i++) {
                                            grandTotal += listOfGTotal[i];
                                          }

                                          ///  sub total For each person /////////////////////
                                          for (int i = 0;
                                              i < totalTileCount.length;
                                              i++) {
                                            subTotal[i] = 0.0;
                                            for (int j = 0;
                                                j < listOFTotal[i].length;
                                                j++) {
                                              subTotal[i] +=
                                                  listOFTotal[i][j][1];
                                            }
                                          }
                                        });
                                      }
                                    }

                                    if (checkItemForContain) {
                                      tableData.add(map);

                                      double totalValue = double.parse(
                                          total_controller.text.toString());
                                      double priceValue = double.parse(
                                          price_controller.text.toString());
                                      double qtyValue = double.parse(
                                          quantity_controller.text.toString());

                                      listOFTotal[indexOfItem][indexOfGrid][0] =
                                          qtyValue;
                                      listOFTotal[indexOfItem][indexOfGrid][1] =
                                          totalValue;
                                      listOFTotal[indexOfItem][indexOfGrid][2] =
                                          priceValue;

                                      ///     ////////     calculate grand total ///////////////////////////
                                      List listOfGTotal = [];

                                      for (int i = 0;
                                          i < tableData.length;
                                          i++) {
                                        listOfGTotal.add(double.parse(
                                                tableData[i][
                                                    ModelSaleItemQuantity
                                                        .priceKey]) *
                                            double.parse(tableData[i][
                                                ModelSaleItemQuantity
                                                    .quantityKey]));
                                      }

                                      grandTotal = 0.0;
                                      for (int i = 0;
                                          i < listOfGTotal.length;
                                          i++) {
                                        grandTotal += listOfGTotal[i];
                                      }

                                      ///  sub total For each person /////////////////////
                                      for (int i = 0;
                                          i < totalTileCount.length;
                                          i++) {
                                        subTotal[i] = 0.0;
                                        for (int j = 0;
                                            j < listOFTotal[i].length;
                                            j++) {
                                          subTotal[i] += listOFTotal[i][j][1];
                                        }
                                      }
                                    }
                                  } else {
                                    tableData.add(map);

                                    double totalValue = double.parse(
                                        total_controller.text.toString());
                                    double priceValue = double.parse(
                                        price_controller.text.toString());
                                    double qtyValue = double.parse(
                                        quantity_controller.text.toString());

                                    listOFTotal[indexOfItem][indexOfGrid][0] =
                                        qtyValue;
                                    listOFTotal[indexOfItem][indexOfGrid][1] =
                                        totalValue;
                                    listOFTotal[indexOfItem][indexOfGrid][2] =
                                        priceValue;

                                    ///     ////////     calculate grand total ///////////////////////////
                                    List listOfGTotal = [];
                                    grandTotal = 0.0;
                                    for (int i = 0; i < tableData.length; i++) {
                                      listOfGTotal.add(double.parse(tableData[i]
                                              [
                                              ModelSaleItemQuantity.priceKey]) *
                                          double.parse(tableData[i][
                                              ModelSaleItemQuantity
                                                  .quantityKey]));
                                    }
                                    for (int i = 0;
                                        i < listOfGTotal.length;
                                        i++) {
                                      grandTotal += listOfGTotal[i];
                                    }

                                    ///  sub total For each person /////////////////////
                                    for (int i = 0;
                                        i < totalTileCount.length;
                                        i++) {
                                      subTotal[i] = 0.0;
                                      for (int j = 0;
                                          j < listOFTotal[i].length;
                                          j++) {
                                        subTotal[i] += listOFTotal[i][j][1];
                                      }
                                    }
                                  }

                                  Navigator.pop(context);
                                  state(() {});
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () async {},
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue[100],
                          border: Border.all(width: 0, color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
