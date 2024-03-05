// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:com/pages/restaurant/SalePur/sale_pur1_SQL.dart';
// import 'package:com/pages/restaurant/total_amount.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../shared_preferences/shared_preference_keys.dart';
//
// class Slip extends StatefulWidget {
//   final String entryType;
//   final int? tableID;
//   final List data;
//
//   const Slip(
//       {Key? key,
//       required this.data,
//       required this.entryType,
//         this.tableID})
//       : super(key: key);
//
//   @override
//   State<Slip> createState() => _SlipState();
// }
//
// class _SlipState extends State<Slip> {
//
//   NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
//   SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
//
//   // ReceiptController? controller;
//   double grandTotal = 0.0;
//   bool check = true;
//
//   @override
//   void initState() {
//     print(widget.data);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var grand = Provider.of<TotalAmount>(context, listen: true);
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height * .9,
//           child: Receipt(
//             onInitialized: (controller) {
//               this.controller = controller;
//             },
//             builder: (context) => SizedBox(
//               height: MediaQuery.of(context).size.height * .9,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius:
//                             BorderRadius.circular(10),
//                             child: CachedNetworkImage(
//                                 height: 50,
//                                 width: 50,
//                                 imageUrl:
//                                 'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}',
//                                 alignment:
//                                 Alignment.center,
//                                 imageBuilder: (context,
//                                     imageProvider) =>
//                                     Container(
//                                       decoration:
//                                       BoxDecoration(
//                                         image:
//                                         DecorationImage(
//                                           image:
//                                           imageProvider,
//                                           fit:
//                                           BoxFit.fill,
//                                         ),
//                                       ),
//                                     ),
//                                 placeholder:
//                                     (context, url) =>
//                                     Center(
//                                       child:
//                                       CircularProgressIndicator(),
//                                     ),
//                                 errorWidget: (context,
//                                     url, error) =>
//                                     Container(
//                                       color: Colors.grey,
//                                     )),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   SharedPreferencesKeys
//                                       .prefs!
//                                       .getString(
//                                       SharedPreferencesKeys
//                                           .companyName)!,
//                                   overflow: TextOverflow
//                                       .ellipsis,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight:
//                                       FontWeight
//                                           .bold),
//                                 ),
//                                 Text(SharedPreferencesKeys
//                                     .prefs!
//                                     .getString(
//                                     SharedPreferencesKeys
//                                         .companyAddress)!,
//                                   overflow: TextOverflow
//                                       .ellipsis,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15
//                                   ),
//                                 ),
//                                 Text(SharedPreferencesKeys
//                                     .prefs!
//                                     .getString(
//                                     SharedPreferencesKeys
//                                         .companyNumber)!,
//                                   overflow: TextOverflow
//                                       .ellipsis,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                     fontSize: 15
//
//                                       ),
//                                 ),
//
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Invoice Number : '),
//                         Text(
//                           widget.data[0]['SalePur1ID'].toString(),
//                           style: TextStyle(
//                               fontSize: 25, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Date : '),
//                       Text(
//                         widget.data[0]['SPDate'].toString(),
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Customer Name: '),
//                       Text(
//                         widget.data[0]['NameOfPerson'].toString().toString(),
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('ContactNo : '),
//                       Text(
//                         widget.data[0]['ContactNo'].toString().toString(),
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Grand Total : '),
//                         Text(myFormat.format(grand.grandTotal)
//                           .toString(),
//                           style: TextStyle(
//                               fontSize: 35, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//                     child: const Text(
//                       'Items : ',
//                       style:
//                           TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   FutureBuilder(
//                     future: _salePurSQLDataBase.SalePur2Data(
//                         entryType: widget.data[0]['EntryType'].toString(),
//                         salePur1Id1: widget.data[0]['SalePur1ID'].toString()),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<dynamic> snapshot) {
//                       if (snapshot.hasData) {
//                         if (check) {
//                           Future.delayed(Duration.zero, () {
//                             for (int i = 0; i < snapshot.data!.length; i++) {
//                               grand.grandTotal += snapshot.data![i]['Total'];
//                             }
//                             check = false;
//                           });
//                           print(grandTotal.toString());
//                         }
//                         return Table(
//                           border: TableBorder.all(),
//                           columnWidths: const <int, TableColumnWidth>{
//                             0: FlexColumnWidth(1),
//                             1: FlexColumnWidth(4.5),
//                             2: FlexColumnWidth(1.5),
//                             3: FlexColumnWidth(2),
//                             4: FlexColumnWidth(2.5),
//                           },
//                           children: List.generate(
//                             snapshot.data.length + 1,
//                             (index) {
//                               return TableRow(children: [
//                                 Center(
//                                     child: index == 0
//                                         ? Text(
//                                             'ID',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         : Text(snapshot.data![index - 1]
//                                                 ['ItemSerial']
//                                             .toString())),
//                                 Center(
//                                     child: index == 0
//                                         ? Text(
//                                             'Item Name',
//                                             style: TextStyle(
//                                                 //fontSize: 12,
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         : Align(
//                                       alignment: Alignment.centerLeft,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(left: 8.0),
//                                             child: Text(snapshot.data![index - 1]
//                                                     ['ItemName']
//                                                 .toString()),
//                                           ),
//                                         )),
//                                 Center(
//                                     child: index == 0
//                                         ? Text(
//                                             'Qty',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         : Text(snapshot.data![index - 1]['Qty']
//                                             .toString())),
//                                 Center(
//                                     child: index == 0
//                                         ? Text(
//                                             'Price',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         : Align(
//                                       alignment: Alignment.centerRight,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(right: 8.0),
//                                             child: Text(snapshot.data![index - 1]
//                                                     ['Price']
//                                                 .toString()),
//                                           ),
//                                         )),
//                                 Center(
//                                     child: index == 0
//                                         ? Text(
//                                             'Total',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         : Align(
//                                       alignment: Alignment.centerRight,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(right: 8.0),
//                                             child: Text(snapshot.data![index - 1]
//                                                     ['Total']
//                                                 .toString()),
//                                           ),
//                                         ))
//                               ]);
//                             },
//                           ),
//                         );
//                       } else {
//                         return const CircularProgressIndicator();
//                       }
//                     },
//                   ),
//                   FutureBuilder<List>(
//                     future: _salePurSQLDataBase.receivedAgainstBill(
//                         entryType: widget.data[0]['EntryType'],
//                         entryID: widget.data[0]['Entry ID'].toString()),
//                     builder:
//                         (BuildContext context, AsyncSnapshot<List> snapshot) {
//                       if (snapshot.hasData && snapshot.data!.length > 0) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(top: 8.0, bottom: 8),
//                               child: const Text(
//                                 'Receiving : ',
//                                 style: TextStyle(
//                                     fontSize: 25, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Table(
//                               border: TableBorder.all(),
//                               columnWidths: const <int, TableColumnWidth>{
//                                 0: FlexColumnWidth(2.5),
//                                 1: FlexColumnWidth(5),
//                                 2: FlexColumnWidth(2.5),
//                               },
//                               children: List.generate(
//                                 snapshot.data!.length + 1,
//                                 (index) {
//                                   return TableRow(children: [
//                                     Center(
//                                         child: index == 0
//                                             ? Text(
//                                                 'ID',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             : Text(snapshot.data![index - 1]
//                                                     ['CashBookID']
//                                                 .toString())),
//                                     Center(
//                                         child: index == 0
//                                             ? Text(
//                                                 'Date',
//                                                 style: TextStyle(
//                                                     //fontSize: 12,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             : Text(snapshot.data![index - 1]
//                                                 ['CBDate'])),
//                                     Center(
//                                       child: index == 0
//                                           ? Text(
//                                               'Amount',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold),
//                                             )
//                                           : Text(snapshot.data![index - 1]
//                                                   ['Amount']
//                                               .toString()),
//                                     ),
//                                   ]);
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       } else {
//                         return SizedBox();
//                       }
//                     },
//                   ),
//                   FutureBuilder<List>(
//                     future: _salePurSQLDataBase.paymentAgainstBill(
//                         entryType: widget.data[0]['EntryType'],
//                         entryID: widget.data[0]['Entry ID'].toString()),
//                     builder:
//                         (BuildContext context, AsyncSnapshot<List> snapshot) {
//                       if (snapshot.hasData && snapshot.data!.length > 0) {
//                         return Column(
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(top: 8.0, bottom: 8),
//                               child: const Text(
//                                 'Payment : ',
//                                 style: TextStyle(
//                                     fontSize: 25, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Table(
//                               border: TableBorder.all(),
//                               columnWidths: const <int, TableColumnWidth>{
//                                 0: FlexColumnWidth(2.5),
//                                 1: FlexColumnWidth(5),
//                                 2: FlexColumnWidth(2.5),
//                               },
//                               children: List.generate(
//                                 snapshot.data!.length + 1,
//                                 (index) {
//                                   return TableRow(children: [
//                                     Center(
//                                         child: index == 0
//                                             ? Text(
//                                                 'ID',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             : Text(snapshot.data![index - 1]
//                                                     ['CashBookID']
//                                                 .toString())),
//                                     Center(
//                                         child: index == 0
//                                             ? Text(
//                                                 'Date',
//                                                 style: TextStyle(
//                                                     //fontSize: 12,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             : Text(snapshot.data![index - 1]
//                                                 ['CBDate'])),
//                                     Center(
//                                       child: index == 0
//                                           ? Text(
//                                               'Amount',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold),
//                                             )
//                                           : Text(snapshot.data![index - 1]
//                                                   ['Amount']
//                                               .toString()),
//                                     ),
//                                   ]);
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       } else {
//                         return SizedBox();
//                       }
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             printRe();
//           },
//           child: Icon(Icons.print)),
//     );
//   }
//
//   Future<void> printRe() async {
//     final device = await FlutterBluetoothPrinter.selectDevice(context);
//     if (device != null) {
//       /// do print
//       controller?.print(address: device.address);
//     }
//   }
//
//   Widget customGridView(
//       {required String itemName,
//       required String quantity,
//       required String price,
//       required String total}) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 7,
//                 offset: Offset(5, 5),
//                 spreadRadius: 2)
//           ],
//           borderRadius: BorderRadius.circular(5)),
//       child: Column(
//         children: [
//           Flexible(
//             flex: 7,
//             child: Image(
//                 image: AssetImage('assets/images/easysoft_logo.jpg'),
//                 fit: BoxFit.fill,
//                 width: double.infinity),
//           ),
//           Flexible(
//             flex: 3,
//             child: Column(
//               children: [
//                 Flexible(
//                     child: Container(
//                   decoration: BoxDecoration(
//                       border: Border(bottom: BorderSide(width: .4))),
//                   alignment: Alignment.center,
//                   child: Text(
//                     itemName,
//                     style: TextStyle(fontSize: 10),
//                   ),
//                 )),
//                 Flexible(
//                   child: Row(
//                     children: [
//                       Flexible(
//                           flex: 5,
//                           child: Center(
//                             child: Column(
//                               children: [
//                                 Flexible(
//                                     flex: 5,
//                                     child: Center(
//                                       child: Text(
//                                         quantity,
//                                         style: TextStyle(fontSize: 9),
//                                       ),
//                                     )),
//                                 Flexible(
//                                     flex: 5,
//                                     child: Center(
//                                       child: Text(
//                                         price,
//                                         style: TextStyle(fontSize: 9),
//                                       ),
//                                     ))
//                               ],
//                             ),
//                           )),
//                       Flexible(
//                           flex: 5,
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 border: Border(left: BorderSide(width: .4))),
//                             alignment: Alignment.center,
//                             child: Text(
//                               total,
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           )),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
