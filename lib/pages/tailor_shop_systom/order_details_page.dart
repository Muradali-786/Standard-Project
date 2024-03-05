import 'package:com/pages/tailor_shop_systom/print_page.dart';
import 'package:com/pages/tailor_shop_systom/sql_file.dart';
import 'package:com/pages/tailor_shop_systom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared_preferences/shared_preference_keys.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map data;

  const OrderDetailsPage({super.key, required this.data});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();

    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order No: ${widget.data['TailorBooking1ID']}'),
                          Text('${widget.data['OrderStatus']}'),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Balance : ${widget.data['BillBalance']}',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Bill Amount : ${widget.data['BillAmount']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Other Job Exp : 100',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Received : ${widget.data['TotalReceived']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Order Date : ${widget.data['OrderDate'].toString() == "" ? '' : DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['OrderDate'].toString().substring(0, 4)), int.parse(widget.data['OrderDate'].toString().substring(
                            5,
                            7,
                          )), int.parse(widget.data['OrderDate'].toString().substring(8, 10)))).toString()}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Delivery Date : ${widget.data['DeliveryDate'].toString() == "" ? '' : DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['DeliveryDate'].toString().substring(0, 4)), int.parse(widget.data['DeliveryDate'].toString().substring(
                            5,
                            7,
                          )), int.parse(widget.data['DeliveryDate'].toString().substring(8, 10)))).toString()}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Delivered Date : ${widget.data['DeliveredDate'].toString() == "" ? '' : DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['DeliveredDate'].toString().substring(0, 4)), int.parse(widget.data['DeliveredDate'].toString().substring(
                            5,
                            7,
                          )), int.parse(widget.data['DeliveredDate'].toString().substring(8, 10)))).toString()}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Name Of Person : ',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Mobile Number : ${widget.data['CustomerMobileNo']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Job Title : ${widget.data['OrderTitle']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Details : ${widget.data['OBRemarks']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 25,
                            ),
                          ),
                          Text(
                            'Cutting',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Cutting Date : ${widget.data['CuttingDate'].toString() == "" ? '' : DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['CuttingDate'].toString().substring(0, 4)), int.parse(widget.data['CuttingDate'].toString().substring(
                            5,
                            7,
                          )), int.parse(widget.data['CuttingDate'].toString().substring(8, 10)))).toString()}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Cutting by Account : ${widget.data['CuttingAccount3Name']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 25,
                            ),
                          ),
                          Text(
                            'Sewing',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Sewing Date : ${widget.data['SewingDate'].toString() == "" ? '' : DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['SewingDate'].toString().substring(0, 4)), int.parse(widget.data['SewingDate'].toString().substring(
                            5,
                            7,
                          )), int.parse(widget.data['SewingDate'].toString().substring(8, 10)))).toString()}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Sewing by Account : ${widget.data['SweingAccount3Name']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 25,
                            ),
                          ),
                          Text(
                            'Finished',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Finished Date : ${widget.data['FinishedDat'].toString() == "" ? '' : DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data['FinishedDat'].toString().substring(0, 4)), int.parse(widget.data['FinishedDat'].toString().substring(
                            5,
                            7,
                          )), int.parse(widget.data['FinishedDat'].toString().substring(8, 10)))).toString()}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Finished by Account : ${widget.data['FinishedAccount3Name']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Cash Details',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder<List>(
                      future: getCashBookDetailsData(
                          tableName: 'TS_Rec',
                          tableID: widget.data['TailorBooking1ID'].toString()),
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
                                        menuForCB(onSelected: (value) {
                                          if (value == 1) {
                                            showGeneralDialog(
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
                      child: Text(
                        'Other Job Exp',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder<List>(
                      future: getCashBookDetailsData(
                          tableName: 'TS_Exp',
                          tableID: widget.data['TailorBooking1ID'].toString()),
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
                                        menuForCB(onSelected: (value) {}),
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
                          SizedBox(
                              width: 140,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    showGeneralDialog(
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
                                          duration:
                                              const Duration(milliseconds: 300),
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: SizedBox(
                                              height: 410,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Material(
                                                  child: CashBookDialog(
                                                      mode: 'ADD',
                                                      ID: widget.data[
                                                              'TailorBooking1ID']
                                                          .toString(),
                                                      tableName:
                                                          'TS_Rec'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text('Cash Rec'))),
                          SizedBox(
                              width: 150,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    showGeneralDialog(
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
                                          duration:
                                              const Duration(milliseconds: 300),
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: SizedBox(
                                              height: 410,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Material(
                                                  child: CashBookDialog(
                                                      mode: 'ADD',
                                                      ID: widget.data[
                                                              'TailorBooking1ID']
                                                          .toString(),
                                                      tableName:
                                                          'TS_Exp'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text('Other Job Exp'))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 140,
                              child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.add),
                                  label: Text('Job Deliver'))),
                          SizedBox(
                              width: 140,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PrintPage(data: widget.data),));
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text('Print'))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 140,
                              child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.add),
                                  label: Text('WhatsApp'))),
                          SizedBox(
                              width: 140,
                              child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.add),
                                  label: Text('Go Back'))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
