import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared_preferences/shared_preference_keys.dart';
import '../../marriage_hall_booking/widget.dart';
import '../../tailor_shop_systom/sql_file.dart';
import '../../tailor_shop_systom/widgets.dart';

class DetailCaseScreen extends StatefulWidget {
  final Map data;

  const DetailCaseScreen({super.key, required this.data});

  @override
  State<DetailCaseScreen> createState() => _DetailCaseScreenState();
}

class _DetailCaseScreenState extends State<DetailCaseScreen> {
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
                Center(
                  child: Text(
                    'Complete Details of Case',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Case No: ${widget.data['CaseID'].toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        'Balance: ${widget.data['BillAmount'].toString()}',
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
                  'Other Charges :  4324',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Received :  4324',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Detail of the patient',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Text(
                  'Date : ${DateFormat(SharedPreferencesKeys.prefs!.getString(
                      SharedPreferencesKeys.dateFormat))
                      .format(DateTime(int.parse(widget.data['CaseDate'].toString()
                      .substring(0, 4)), int.parse(widget.data['CaseDate'].toString()
                      .substring(
                    5,
                    7,
                  )), int.parse(widget.data['CaseDate'].toString().substring(8, 10))))
                      .toString()}',
                ),
                Text(
                  'Time : ${widget.data['CaseTime'].toString()}',
                ),
                Text(
                  'Delivered Date : 02-43-3545',
                ),
                Text(
                  'Name of the patient : ${widget.data['PatientName'].toString()}',
                ),
                Text(
                  'Mobile Number :${widget.data['PatientMobileNo'].toString()}',
                ),
                Text(
                  'Gender :${widget.data['Gender'].toString()}',
                ),
                Text(
                  'Doctor Name :${widget.data['CheckupToDoctorID'].toString()}',
                ),
                Text(
                  'Other Detail : ${widget.data['OtherDetail'].toString()}',
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Diagnose Detail of Doctor',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),

                Text(
                  '1. Adfa alkdj',
                ),
                Text(
                  '2. Adfa alkdj',
                ),
                Text(
                  '3. Adfa alkdj',
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Treatment',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),

                Text(
                  '1. Adfa alkdj',
                ),
                Text(
                  '2. Adfa alkdj',
                ),
                Text(
                  '3. Adfa alkdj',
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cash Receiving Detail',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () async {
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
                                              ID: '${widget.data['CaseID']}',
                                              tableName:
                                              'CL_Rec'),
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
                      tableName: 'CL_Rec',
                      tableID: '${widget.data['CaseID']}'),
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
                        'Other Charges Detail',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () async {
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
                                              ID: '${widget.data['CaseID']}',
                                              tableName:
                                              'CL_Exp'),
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
                    tableName: 'CL_Exp',
                    tableID:  '${widget.data['CaseID']}', ),
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

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Old Checkup History',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
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
