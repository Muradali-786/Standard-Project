import 'package:com/pages/marriage_hall_booking/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../tailor_shop_systom/sql_file.dart';
import '../tailor_shop_systom/widgets.dart';

class DetailsBookingPage extends StatefulWidget {

 final  Map  data;
  const DetailsBookingPage({super.key, required this.data});

  @override
  State<DetailsBookingPage> createState() => _DetailsBookingPageState();
}

class _DetailsBookingPageState extends State<DetailsBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                'Order No.  ${widget.data['BookingID']}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${DateFormat(SharedPreferencesKeys.prefs!
                      .getString(SharedPreferencesKeys.dateFormat))
                      .format(DateTime(
                      int.parse(widget.data['BookingDate'].toString().substring(0, 4)),
                      int.parse(widget.data['BookingDate'].toString().substring(
                        5,
                        7,
                      )),
                      int.parse(widget.data['BookingDate'].toString().substring(8, 10))))
                      .toString()}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text('Name of Person : ${widget.data['ClientName']}'),
              ),
              Text('Mobile No : ${widget.data['ClientMobile']}'),
              Text('Bill Amount : ${widget.data['TotalCharges']}'),
              Text('Total Received : ${widget.data['TotalReceived']}'),
              Text('Other Expanse : name'),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Balance : ${widget.data['BillBalance']}',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Text(
                'Order Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text('Name of Person :  ${widget.data['ClientName']}'),
              ),
              Text('Mobile No : ${widget.data['ClientMobile']}'),
              Text('NIC : ${widget.data['ClientNIC']}'),
              Text('Address : ${widget.data['ClientAddress']}'),
              Text('Event Date : ${DateFormat(SharedPreferencesKeys.prefs!
                  .getString(SharedPreferencesKeys.dateFormat))
                  .format(DateTime(
                  int.parse(widget.data['EventDate'].toString().substring(0, 4)),
                  int.parse(widget.data['EventDate'].toString().substring(
                    5,
                    7,
                  )),
                  int.parse(widget.data['EventDate'].toString().substring(8, 10))))
                  .toString()}'),
              Text('Timing :  ${widget.data['EventTiming']}'),
              Text('Booking Date : ${DateFormat(SharedPreferencesKeys.prefs!
                  .getString(SharedPreferencesKeys.dateFormat))
                  .format(DateTime(
                  int.parse(widget.data['BookingDate'].toString().substring(0, 4)),
                  int.parse(widget.data['BookingDate'].toString().substring(
                    5,
                    7,
                  )),
                  int.parse(widget.data['BookingDate'].toString().substring(8, 10))))
                  .toString()}'),
              Text('Event name : ${widget.data['EventName']}'),
              Text('Shift : ${widget.data['Shift']}'),
              Text('Number of Person : ${widget.data['PersonsQty']}'),
              Text('Description  : ${widget.data['Description']}'),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Receiving Detail',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: () async{
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
                                    child: CashBookDialogForMarriageBooking(
                                        mode: 'ADD',
                                        ID: '${widget.data['BookingID']}',
                                        tableName:
                                        'EV_Rec'),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                     setState(() {

                     });
                    }, icon: Icon(Icons.add, color: Colors.green,size: 30,))
                  ],
                ),
              ),
              FutureBuilder<List>(
                future: getCashBookDetailsData(
                    tableName: 'EV_Rec',
                    tableID: '${widget.data['BookingID']}'),
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                                  menuForCB(onSelected: (value) async{
                                    if (value == 1) {
                                     await showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext
                                        context,
                                            Animation<double> animation,
                                            Animation<double>
                                            secondaryAnimation) {
                                          return AnimatedContainer(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                MediaQuery.of(context)
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
                                                  const EdgeInsets
                                                      .all(8.0),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: () async{
                   await   showGeneralDialog(
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
                                    child: CashBookDialogForMarriageBooking(
                                        mode: 'ADD',
                                        ID: '${widget.data['BookingID']}',
                                        tableName:
                                        'EV_Exp'),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                   setState(() {

                   });
                    }, icon: Icon(Icons.add, color: Colors.green,size: 30,))
                  ],
                ),
              ),
              FutureBuilder<List>(
                future: getCashBookDetailsData(
                    tableName: 'EV_Exp',
                    tableID:  '${widget.data['BookingID']}', ),
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                                    await  showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext
                                        context,
                                            Animation<double> animation,
                                            Animation<double>
                                            secondaryAnimation) {
                                          return AnimatedContainer(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                MediaQuery.of(context)
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
                                                  const EdgeInsets
                                                      .all(8.0),
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
                                    setState(() {

                                    });
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
            ],
          ),
        ),
      ),
    );
  }
}
