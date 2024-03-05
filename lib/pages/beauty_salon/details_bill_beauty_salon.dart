import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../marriage_hall_booking/widget.dart';
import '../tailor_shop_systom/sql_file.dart';
import '../tailor_shop_systom/widgets.dart';

class DetailsBillSalon extends StatefulWidget {
  final Map data;

  const DetailsBillSalon({super.key, required this.data});

  @override
  State<DetailsBillSalon> createState() => _DetailsBillSalonState();
}

class _DetailsBillSalonState extends State<DetailsBillSalon> {
  List<String> listOfServiceWithPrice = [];
  String details = '';

  @override
  void initState() {
    super.initState();

    details = widget.data['ServicesDetail'].toString();

    List<String> list = details.split('\n');

    listOfServiceWithPrice = list.getRange(0, list.length - 1).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order No : ${widget.data['BillID']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${widget.data['BillStatus']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        'Balance: 000',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Bill Amount :  ${widget.data['BillAmount'].toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  'Other Expanse :  0000',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Received :  000',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Order',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Text(
                  'Order Date : ${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['BillDate'].toString().substring(0, 4)), int.parse(widget.data['BillDate'].toString().substring(
                        5,
                        7,
                      )), int.parse(widget.data['BillDate'].toString().substring(8, 10)))).toString()}',
                ),
                Text(
                  'Name of the Person : ${widget.data['CustomerName'].toString()}',
                ),
                Text(
                  'Mobile Number : ${widget.data['CustomerMobileNo'].toString()}',
                ),
                Text(
                  'Token No : ${widget.data['TokenNo'].toString()}',
                ),
                Text(
                  'Booking Time : ',
                ),
                Text(
                  'Book for Time : ',
                ),
                Text(
                  'Process Time : ',
                ),
                Text(
                  'Finished Time : ',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Job Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                ListView.builder(
                  itemCount: listOfServiceWithPrice.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                        children: [
                          Text(
                              '${listOfServiceWithPrice[index].toString().split('@').first} : '),
                          Text(
                              '${listOfServiceWithPrice[index].toString().split('@').last}'),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cash Detail',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () async {
                            await showGeneralDialog(
                              context: context,
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return AnimatedContainer(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  duration: const Duration(milliseconds: 300),
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: SizedBox(
                                      height: 410,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          child:
                                              CashBookDialogForMarriageBooking(
                                                  mode: 'ADD',
                                                  ID: '${widget.data['BillID']}',
                                                  tableName: 'BS_Rec'),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 30,
                          ))
                    ],
                  ),
                ),
                FutureBuilder<List>(
                  future: getCashBookDetailsData(
                      tableName: 'BS_Rec', tableID: '${widget.data['BillID']}'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data!);
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 6,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Cb No : ${snapshot.data![index]['CashBookID']}'),
                                            Text(
                                                'Date : ${snapshot.data![index]['CBDate']}'),
                                            Text(
                                                'Debit Account : ${snapshot.data![index]['DebitAccountName']}'),
                                            Text(
                                                'Credit Account : ${snapshot.data![index]['CreditAccountName']}'),
                                            Text(
                                                'Remarks :  ${snapshot.data![index]['CBRemarks']}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    menuForCB(onSelected: (value) async {
                                      if (value == 1) {
                                        await showGeneralDialog(
                                          context: context,
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) {
                                            return AnimatedContainer(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              alignment: Alignment.center,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 410,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Material(
                                                      child: CashBookDialog(
                                                        mode: 'EDIT',
                                                        data: snapshot
                                                            .data![index],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    }),
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        'Amount :  ${snapshot.data![index]['Amount']}',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Other Expanse',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () async {
                            await showGeneralDialog(
                              context: context,
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return AnimatedContainer(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  duration: const Duration(milliseconds: 300),
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: SizedBox(
                                      height: 410,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          child:
                                              CashBookDialogForMarriageBooking(
                                                  mode: 'ADD',
                                                  ID: '${widget.data['BillID']}',
                                                  tableName: 'BS_Exp'),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 30,
                          ))
                    ],
                  ),
                ),
                FutureBuilder<List>(
                  future: getCashBookDetailsData(
                    tableName: 'BS_Exp',
                    tableID: '${widget.data['BillID']}',
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data!);
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 6,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Cb No : ${snapshot.data![index]['CashBookID']}'),
                                            Text(
                                                'Date : ${snapshot.data![index]['CBDate']}'),
                                            Text(
                                                'Debit Account : ${snapshot.data![index]['DebitAccountName']}'),
                                            Text(
                                                'Credit Account : ${snapshot.data![index]['CreditAccountName']}'),
                                            Text(
                                                'Remarks :  ${snapshot.data![index]['CBRemarks']}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    menuForCB(onSelected: (value) async {
                                      if (value == 1) {
                                        await showGeneralDialog(
                                          context: context,
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) {
                                            return AnimatedContainer(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              alignment: Alignment.center,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 410,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Material(
                                                      child: CashBookDialog(
                                                        mode: 'EDIT',
                                                        data: snapshot
                                                            .data![index],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        setState(() {});
                                      }
                                    }),
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        'Amount :  ${snapshot.data![index]['Amount']}',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {},
                        child: Text('Print / Cash Receive')),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
