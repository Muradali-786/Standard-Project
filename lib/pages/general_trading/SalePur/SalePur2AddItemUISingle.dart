import 'package:com/pages/general_trading/SalePur/SalePur2AddItemBySelection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:com/pages/general_trading/SalePur/SalePur2AddItemSQL.dart';
import 'package:com/pages/general_trading/SalePur/sale_pur1_SQL.dart';
import 'package:com/pages/material/drop_down_style1.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';

import '../SalePurNewDesign/components/custom_round_button.dart';

/////////////////////////////////////////////////////////////////////////////////
///////////       SalePur2 Entry Dialog UI Code    ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class SalesPur2Dialog extends StatefulWidget {
  final String EntryType;
  final int salePur1Id;
  final String action;
  final String PaymentAfterDate;
  final String contactNo;
  final int id;
  final String NameOfPerson;
  final String date;
  final String remarks;
  final int accountID;
  final String? accountName;
  final Map map;

  const SalesPur2Dialog(
      {Key? key,
      required this.date,
      required this.accountName,
      required this.id,
      required this.accountID,
      required this.contactNo,
      required this.NameOfPerson,
      required this.PaymentAfterDate,
      required this.remarks,
      required this.EntryType,
      required this.salePur1Id,
      required this.action,
      required this.map})
      : super(key: key);

  @override
  _SalesPur2DialogState createState() => _SalesPur2DialogState();
}

class _SalesPur2DialogState extends State<SalesPur2Dialog> {
  TextEditingController quantity_controller = TextEditingController();
  TextEditingController price_controller = TextEditingController();
  TextEditingController total_controller = TextEditingController();
  TextEditingController itemDescription_controller = TextEditingController();

  List<String> LocationNameDetailList = [];
  int _selectedLocationId = 1;
  String location = '';
  String btnCondition = 'save';
  List<String> listDropDown = ['java', 'flutter'];
  double QtyAdd = 0;
  double QtyLess = 0;
  double Total = 0;
  int TotalAmount = 0;
  double price = 0;
  SalePur2AddItemSQl _pur2addItemSQl = SalePur2AddItemSQl();
  DatabaseProvider db = DatabaseProvider();
  String BillStatus = "Active";
  String EntryTime = DateTime.now().toString();
  String ModifiedTime = DateTime.now().toString();

  bool quantityLock = false;
  bool priceLock = false;
  bool totalLock = true;

  IconData chekIconForQuantity = CupertinoIcons.textformat_123;
  IconData chekIconForPrice = CupertinoIcons.textformat_123;
  IconData chekIconForTotal = CupertinoIcons.equal;

  String quantityCondition = '';
  String priceCondition = '';
  String totalCondition = '';

  String dateTime = '';

  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();

  getDatabase() async {
    await db.init();
  }

  Map dropDownAccountNameMap = {
    "ID": null,
    'Title': "Item Name",
    'SubTitle': null,
    "Value": null
  };

  @override
  void initState() {
    print('........................open......................');

    if (widget.action == 'EDIT') {
      dropDownAccountNameMap['ID'] = widget.map['Item3NameID'];
      dropDownAccountNameMap['Title'] = widget.map['ItemName'];
      dropDownAccountNameMap['SubTitle'] = widget.map['Item2GroupName'];
      dropDownAccountNameMap['Value'] = widget.map['Stock'];
      quantity_controller.text = widget.map['Qty'].toString();
      itemDescription_controller.text = widget.map['ItemDescription'];
      price_controller.text = widget.map['Price'].toString();
      total_controller.text = widget.map['Total'].toString();
    }
    if (widget.action == 'MultiSelection') {
      print('....................multiselection........................');

      dropDownAccountNameMap['Title'] = widget.map['ItemName'];
      dropDownAccountNameMap['ID'] = widget.map['ItemID'];
      quantity_controller.text = widget.map['Quantity'].toString();
      price_controller.text = widget.map['Price'].toString();
      total_controller.text = widget.map['Total'].toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Card(
            elevation: 5,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(8)),
              height: MediaQuery.of(context).size.height * .52,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //////////////////////////////  action ADD button//////////////////////////////////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   '${widget.action} Itemss',
                      //   style: TextStyle(color: Colors.red),
                      // ),
                      Spacer(),
                      Text(
                        "${TotalAmount.toString()} inserted",
                        style: TextStyle(color: Colors.grey,),
                      ),
                      Spacer(),
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.close)),
                      InkWell(
                          onTap: () {
                            SharedPreferencesKeys.prefs!.setString(
                                'CheckStateItem', 'StateItemMulti');

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddItemBySelection(
                                        remarks: widget.remarks,
                                        openFor: 'Sale',
                                        id: widget.id,
                                        contactNo: widget.contactNo,
                                        accountID: widget.accountID,
                                        date: widget.date,
                                        accountName: widget.accountName,
                                        nameOfPerson: widget.NameOfPerson,
                                        paymentAfterDate:
                                            widget.PaymentAfterDate,
                                        entryType: widget.EntryType,
                                        salePurId1: widget.salePur1Id)));
                          },
                          child: Icon(
                            Icons.ac_unit_sharp,
                            color: Colors.grey,
                            size: 15,
                          )),
                    ],
                  ),


                  Padding(
                    padding: const EdgeInsets.only(left: 9,bottom: 8),
                    child: Text(
                      "Location 1",
                      style: TextStyle(color: Colors.grey,),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       FutureBuilder(
                  //         future: _salePurSQLDataBase.dropDownData1(),
                  //         builder: (BuildContext context,
                  //                 AsyncSnapshot<dynamic> snapshot) =>
                  //             InkWell(
                  //                 onTap: () async {
                  //                   print(
                  //                       '...............${dropDownAccountNameMap.toString()}....................');
                  //
                  //                   dropDownAccountNameMap = await showDialog(
                  //                     context: context,
                  //                     builder: (_) => DropDownStyle1(
                  //                       acc1TypeList: snapshot.data,
                  //                       dropdown_title:
                  //                           dropDownAccountNameMap['Title'],
                  //                       map: dropDownAccountNameMap,
                  //                     ),
                  //                   );
                  //
                  //                   print(
                  //                       '...............${dropDownAccountNameMap.toString()}....................');
                  //
                  //                   setState(() {
                  //                     _salePurSQLDataBase.UpdateSalePur1(
                  //                         SPDate: widget.date,
                  //                         context: context,
                  //                         ACNameID: int.parse(
                  //                             dropDownAccountNameMap['ID']
                  //                                 .toString()),
                  //                         ContactNo: widget.contactNo,
                  //                         EntryType: widget.EntryType,
                  //                         NameOfPerson: widget.NameOfPerson,
                  //                         PaymentAfterDate:
                  //                             widget.PaymentAfterDate,
                  //                         id: widget.id,
                  //                         remarks: widget.remarks);
                  //                   });
                  //                 },
                  //                 child: Text(
                  //                     dropDownAccountNameMap['Title'] ==
                  //                             "Item Name"
                  //                         ? widget.accountName
                  //                         : dropDownAccountNameMap['Title'])),
                  //       ),
                  //       InkWell(
                  //         onTap: () async {
                  //           var dateTimeC = await Navigator.push(context,
                  //               MaterialPageRoute(builder: (_) {
                  //             var date = DatePickerStyle1();
                  //             return date;
                  //           }));
                  //           print(
                  //               '.....datetime ${dateTimeC.toString().substring(0, 10)}..');
                  //
                  //           setState(() {
                  //             dateTime =
                  //                 dateTimeC.toString().substring(0, 10);
                  //           });
                  //
                  //           _salePurSQLDataBase.UpdateSalePur1(
                  //               SPDate: dateTimeC.toString().substring(0, 10),
                  //               context: context,
                  //               ACNameID: widget.accountID,
                  //               ContactNo: widget.contactNo,
                  //               EntryType: widget.EntryType,
                  //               NameOfPerson: widget.NameOfPerson,
                  //               PaymentAfterDate: widget.PaymentAfterDate,
                  //               id: widget.id,
                  //               remarks: widget.remarks);
                  //         },
                  //         child: dateTime == ''
                  //             ? Text('${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.date.substring(0, 4)), int.parse(widget.date.substring(
                  //                   5,
                  //                   7,
                  //                 )), int.parse(widget.date.substring(8, 10)))).toString()}')
                  //             : Text('${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(dateTime.substring(0, 4)), int.parse(dateTime.substring(
                  //                   5,
                  //                   7,
                  //                 )), int.parse(dateTime.substring(8, 10)))).toString()}'),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 9,bottom: 8),
                    child: Text(
                      "Item Name",
                      style: TextStyle(color: Colors.grey,),
                    ),
                  ),
                  FutureBuilder(
                    future: _pur2addItemSQl.dropDownData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        print(
                            '${snapshot.data!}..................................');
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8,0,8,8),
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
                                setState(() {});
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
                    padding: const EdgeInsets.only(left: 9,bottom: 4),
                    child: Text(
                      "Item Description",
                      style: TextStyle(color: Colors.grey,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
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
                  SizedBox(height: 12),
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
                                    double priceValue = 0;
                                    double qtyValue =
                                    double.parse(value.toString());
                                    if (price_controller.text
                                        .toString()
                                        .length !=
                                        0) {
                                      priceValue = double.parse(
                                          price_controller.text.toString());
                                    }
                                    double totalValue = qtyValue * priceValue;
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
                                      if (quantity_controller.text
                                          .toString()
                                          .length !=
                                          0) {
                                        double totalValue = priceValue *
                                            double.parse(quantity_controller
                                                .text
                                                .toString());
                                        total_controller.text =
                                            totalValue.toString();
                                      }
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
                            setState(() {
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
                            setState(() {
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
                            setState(() {
                              chekIconForQuantity =
                                  CupertinoIcons.textformat_123;
                              chekIconForPrice =
                                  CupertinoIcons.textformat_123;
                              chekIconForTotal = CupertinoIcons.equal;

                              priceCondition = 'Price';

                              totalLock = true;
                              priceLock = false;
                              quantityLock = false;
                            });
                          },
                          child: Icon(chekIconForTotal, size: 15)),
                    ],
                  ),


                  ////////////////////////////////// Save Button ///////////////////////////////////////////////
                  // FutureBuilder(
                  //   future: _pur2addItemSQl.dropDownData(),
                  //   //getting the dropdown data from query
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<dynamic> snapshot) {
                  //     if (snapshot.hasData) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: InkWell(
                  //             onTap: () async {
                  //               dropDownAccountNameMap = await showDialog(
                  //                 context: context,
                  //                 builder: (_) => DropDownStyle1(
                  //                   acc1TypeList: snapshot.data,
                  //                   dropdown_title:
                  //                       dropDownAccountNameMap['Title'],
                  //                   map: dropDownAccountNameMap,
                  //                 ),
                  //               );
                  //               setState(() {});
                  //             },
                  //             child: DropDownStyle1State.DropDownButton(
                  //               title: dropDownAccountNameMap['Title']
                  //                   .toString(),
                  //               subtitle: dropDownAccountNameMap['SubTitle']
                  //                   .toString(),
                  //               id: dropDownAccountNameMap['ID'].toString(),
                  //             )),
                  //       );
                  //     }
                  //     return Container();
                  //   },
                  // ),

                  ///////////////////////////////////////////////////////////
                  /////////////////////Add / Update Button////////////////////
                     /////////////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60.0, vertical: 10),
                    child: CustomRoundButton2(
                      title: 'Add / Update',
                      height: 35,
                      buttonColor: Colors.green,
                      onTap: () async {
                        if (widget.action == "EDIT") {
                          _pur2addItemSQl.salePur2SaveEditMode(
                            salePur1ID: widget.salePur1Id,
                            QtyValue: quantity_controller.text.toString(),
                            priceValue: price_controller.text.toString(),
                            map: widget.map,
                            QtyAdd: 0,
                            Qty: quantity_controller.text.toString(),
                            context: context,
                            price: 0,
                            entryType: widget.EntryType,
                            selectedLocation: _selectedLocationId,
                            Total: double.parse(
                                total_controller.text.toString()),
                            QtyLess: QtyLess,
                          );
                        } else if (widget.action == 'MultiSelection') {
                          print(
                              ',,,,,,,,,,,,,,,,,,,,,,,,,,multi................................');
                        } else {
                          switch (widget.EntryType) {
                            case 'PU':
                              setState(() {
                                QtyAdd =
                                    double.parse(quantity_controller.text);
                                QtyLess = 0;
                                price = double.parse(price_controller.text);
                                // Total = QtyAdd * price;
                              });
                              break;
                            case 'SR':
                              setState(() {
                                QtyAdd =
                                    double.parse(quantity_controller.text);
                                QtyLess = 0;
                                price = double.parse(price_controller.text);
                                // Total = QtyAdd * price;
                              });
                              break;
                            case 'SL':
                              setState(() {
                                QtyLess =
                                    double.parse(quantity_controller.text);
                                QtyAdd = 0;
                                price = double.parse(price_controller.text);
                                //  Total = QtyLess * price;
                              });
                              break;
                            case 'PR':
                              setState(() {
                                QtyLess =
                                    double.parse(quantity_controller.text);
                                QtyAdd = 0;
                                price = double.parse(price_controller.text);
                                // Total = QtyLess * price;
                              });
                              break;
                            default:
                              break;
                          }
                          _pur2addItemSQl.insertSalePur2(
                              total: double.parse(
                                  total_controller.text.toString()),
                              EntryType: widget.EntryType,
                              SalePur1ID: widget.salePur1Id,
                              EntryTime: EntryTime,
                              ItemDescription:
                                  itemDescription_controller.text.toString(),
                              Location: _selectedLocationId.toString(),
                              Price: price_controller.text.toString(),
                              Qty: quantity_controller.text.toString(),
                              QtyAdd: QtyAdd.toString(),
                              Qtyless: QtyLess.toString(),
                              TotalAmount: TotalAmount,
                              Item3NameId: int.parse(
                                  dropDownAccountNameMap['ID'].toString()));

                          itemDescription_controller.clear();
                          quantity_controller.clear();
                          price_controller.clear();
                          total_controller.clear();
                        }
                      },
                    ),
                  ),
                  // Container(
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Spacer(),
                  //       IconButton(
                  //         onPressed: () {
                  //           Navigator.pop(context);
                  //         },
                  //         icon: Icon(
                  //           Icons.close_rounded,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       Spacer(),
                  //       Container(
                  //         height: 30,
                  //         width: 150,
                  //         child: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //                 backgroundColor: Colors.greenAccent,
                  //                 foregroundColor: Colors.white,
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(20),
                  //                 ) // foreground
                  //                 ),
                  //             onPressed: () async {
                  //               if (widget.action == "EDIT") {
                  //                 _pur2addItemSQl.salePur2SaveEditMode(
                  //                   salePur1ID: widget.salePur1Id,
                  //                   QtyValue:
                  //                       quantity_controller.text.toString(),
                  //                   priceValue:
                  //                       price_controller.text.toString(),
                  //                   map: widget.map,
                  //                   QtyAdd: 0,
                  //                   Qty: quantity_controller.text.toString(),
                  //                   context: context,
                  //                   price: 0,
                  //                   entryType: widget.EntryType,
                  //                   selectedLocation: _selectedLocationId,
                  //                   Total: double.parse(
                  //                       total_controller.text.toString()),
                  //                   QtyLess: QtyLess,
                  //                 );
                  //               } else if (widget.action ==
                  //                   'MultiSelection') {
                  //                 print(
                  //                     ',,,,,,,,,,,,,,,,,,,,,,,,,,multi................................');
                  //               } else {
                  //                 switch (widget.EntryType) {
                  //                   case 'PU':
                  //                     setState(() {
                  //                       QtyAdd = double.parse(
                  //                           quantity_controller.text);
                  //                       QtyLess = 0;
                  //                       price = double.parse(
                  //                           price_controller.text);
                  //                       // Total = QtyAdd * price;
                  //                     });
                  //                     break;
                  //                   case 'SR':
                  //                     setState(() {
                  //                       QtyAdd = double.parse(
                  //                           quantity_controller.text);
                  //                       QtyLess = 0;
                  //                       price = double.parse(
                  //                           price_controller.text);
                  //                       // Total = QtyAdd * price;
                  //                     });
                  //                     break;
                  //                   case 'SL':
                  //                     setState(() {
                  //                       QtyLess = double.parse(
                  //                           quantity_controller.text);
                  //                       QtyAdd = 0;
                  //                       price = double.parse(
                  //                           price_controller.text);
                  //                       //  Total = QtyLess * price;
                  //                     });
                  //                     break;
                  //                   case 'PR':
                  //                     setState(() {
                  //                       QtyLess = double.parse(
                  //                           quantity_controller.text);
                  //                       QtyAdd = 0;
                  //                       price = double.parse(
                  //                           price_controller.text);
                  //                       // Total = QtyLess * price;
                  //                     });
                  //                     break;
                  //                   default:
                  //                     break;
                  //                 }
                  //                 _pur2addItemSQl.insertSalePur2(
                  //                     total: double.parse(
                  //                         total_controller.text.toString()),
                  //                     EntryType: widget.EntryType,
                  //                     SalePur1ID: widget.salePur1Id,
                  //                     EntryTime: EntryTime,
                  //                     ItemDescription:
                  //                         itemDescription_controller.text
                  //                             .toString(),
                  //                     Location:
                  //                         _selectedLocationId.toString(),
                  //                     Price: price_controller.text.toString(),
                  //                     Qty:
                  //                         quantity_controller.text.toString(),
                  //                     QtyAdd: QtyAdd.toString(),
                  //                     Qtyless: QtyLess.toString(),
                  //                     TotalAmount: TotalAmount,
                  //                     Item3NameId: int.parse(
                  //                         dropDownAccountNameMap['ID']
                  //                             .toString()));
                  //
                  //                 itemDescription_controller.clear();
                  //                 quantity_controller.clear();
                  //                 price_controller.clear();
                  //                 total_controller.clear();
                  //               }
                  //             },
                  //             child: Text(
                  //               "Save",
                  //               style: TextStyle(
                  //                   color: Colors.red,
                  //                   fontSize: 15,
                  //                   fontWeight: FontWeight.bold),
                  //             )),
                  //       ),
                  //       Spacer(),
                  //       IconButton(
                  //         onPressed: () async {
                  //           Navigator.pop(context);
                  //         },
                  //         icon: Icon(
                  //           Icons.close_rounded,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       Spacer(),
                  //     ],
                  //   ),
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //       color: Colors.blue[100],
                  //       border: Border.all(width: 0, color: Colors.blue)),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
