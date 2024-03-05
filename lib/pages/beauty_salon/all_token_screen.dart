import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/pages/beauty_salon/sql_file_beauty_salon.dart';
import 'package:flutter/material.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../tailor_shop_systom/widgets.dart';
import 'add_bill_beauty_salon.dart';

class AllTokenList extends StatefulWidget {
  const AllTokenList({super.key});

  @override
  State<AllTokenList> createState() => _AllTokenListState();
}

class _AllTokenListState extends State<AllTokenList> {
  CollectionReference country =
      FirebaseFirestore.instance.collection('Country');

  Set<String> chairCatList = {};
  Set<String> beauticianList = {};
  var chairAllData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            StreamBuilder(
              stream: country
                  .doc(
                      '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                  .collection('CountryUser')
                  .doc(
                      '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                  .collection('Client')
                  .doc(
                      '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}')
                  .collection('Token')
                  .where('Status', isNotEqualTo: 'Finished')
                  // .orderBy(
                  //   'TokenNo',
                  // )
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  chairCatList.clear();

                  snapshot.data!.docs.forEach((element) {
                    chairCatList.add(element['ChairNo']);
                  });

                  return ListView.builder(
                    itemCount: chairCatList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, chairIndex) {
                      var chairAllData = snapshot.data!.docs.where((element) =>
                          chairCatList.elementAt(chairIndex) ==
                          element['ChairNo']);

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Chair number :  ${chairCatList.elementAt(chairIndex)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddBillBeautySalon(),
                                            ));
                                      },
                                      child: Text('Add Job')),
                                )
                              ],
                            ),
                          ),
                          ListView.builder(
                            itemCount: chairAllData.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TokenItem(
                                  chairAllData: chairAllData.elementAt(index),
                                )),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class TokenItem extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> chairAllData;

  const TokenItem({super.key, required this.chairAllData});

  @override
  State<TokenItem> createState() => _TokenItemState();
}

class _TokenItemState extends State<TokenItem> {
  CollectionReference country =
      FirebaseFirestore.instance.collection('Country');
  DateTime currentDateTime = DateTime.now();
  List<String> statusList = ['Finished', 'Waiting', 'Cancel'];
  String selectedStatus = 'Finished';
  bool check = false;

  @override
  void initState() {
    super.initState();

    check = widget.chairAllData['Status'] == 'waiting' ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4),
              child: Checkbox(
                onChanged: (value) {
                  setState(() {
                    check = value!;
                    if (check) {
                      country
                          .doc(
                              '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                          .collection('CountryUser')
                          .doc(
                              '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                          .collection('Client')
                          .doc(
                              '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}')
                          .collection('Token')
                          .doc(widget.chairAllData.id.toString())
                          .update({
                        'Status': 'working',
                        'ServiceStartTime':
                            "${currentDateTime.hour}:${currentDateTime.minute}:${currentDateTime.second}"
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Material(
                                child: Container(
                                  height: 360,
                                  width: MediaQuery.of(context).size.width * .7,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Token No : ${widget.chairAllData['TokenNo']}',
                                      ),
                                      Text(
                                        'BillID : ${widget.chairAllData['BillID']}',
                                      ),
                                      Text(
                                        'Amount : ${widget.chairAllData['BillAmount']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      FutureBuilder<List>(
                                        future: getRECAmountCashBook(
                                          tableName: 'BS_Rec',
                                          tableID: widget.chairAllData['BillID']
                                              .toString(),
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            double grandPrice = 0;

                                            snapshot.data!.forEach((element) {
                                              grandPrice += double.parse(
                                                  element['Amount'].toString());
                                            });

                                            return Text(
                                              'Rec Amount : $grandPrice ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: DropdownMenu<String>(
                                          initialSelection: selectedStatus,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .65,
                                          onSelected: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              selectedStatus = value!;
                                            });
                                          },
                                          dropdownMenuEntries: statusList
                                              .map<DropdownMenuEntry<String>>(
                                                  (String value) {
                                            return DropdownMenuEntry<String>(
                                                value: value, label: value);
                                          }).toList(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                width: 100,
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (widget.chairAllData[
                                                              'BillID']
                                                          .toString()
                                                          .isEmpty) {
                                                        int ID =
                                                            await addNewBill(
                                                          BeauticianID:
                                                              '${widget.chairAllData['BeauticianID']}',
                                                          CustomerName:
                                                              '${widget.chairAllData['CustomerName']}',
                                                          CustomerMobileNo:
                                                              '${widget.chairAllData['CustomerNumber']}',
                                                          ServicesDetail:
                                                              '${widget.chairAllData['ServicesDetail']}',
                                                          BillAmount:
                                                              '${widget.chairAllData['BillAmount']}',
                                                          BillStatus:
                                                              '${widget.chairAllData['Status']}',
                                                          TokenNo:
                                                              '${widget.chairAllData['TokenNo']}',
                                                          BillDate:
                                                              '${widget.chairAllData['BillDate']}',
                                                          BookingTime:
                                                              '${widget.chairAllData['TokenTime']}',
                                                          BookForTime: '',
                                                          ServiceStartTime:
                                                              '${widget.chairAllData['ServiceStartTime']}',
                                                          ServiceEndTime:
                                                              '${widget.chairAllData['ServiceEndTime']}',
                                                        );
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
                                                                  height: 410,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Material(
                                                                      child: CashBookDialog(
                                                                          mode:
                                                                              'ADD',
                                                                          ID: ID
                                                                              .toString(),
                                                                          tableName:
                                                                              'BS_Rec'),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        print(
                                                            '..............................................................');
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
                                                                  height: 410,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Material(
                                                                      child: CashBookDialog(
                                                                          mode:
                                                                              'ADD',
                                                                          ID: widget.chairAllData['BillID']
                                                                              .toString(),
                                                                          tableName:
                                                                              'BS_Rec'),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: Text('Cash Rec'))),
                                            SizedBox(
                                                width: 100,
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddBillBeautySalon(
                                                                    data: {
                                                                  'BillID':
                                                                      '${widget.chairAllData['BillID']}',
                                                                  'ID': widget
                                                                      .chairAllData
                                                                      .id
                                                                      .toString(),
                                                                  'ChairNo':
                                                                      '${widget.chairAllData['ChairNo']}',
                                                                  'BeauticianID':
                                                                      '${widget.chairAllData['BeauticianID']}',
                                                                  'CustomerName':
                                                                      '${widget.chairAllData['CustomerName']}',
                                                                  'CustomerMobileNo':
                                                                      '${widget.chairAllData['CustomerNumber']}',
                                                                  'ServicesDetail':
                                                                      '${widget.chairAllData['ServicesDetail']}',
                                                                  'BillAmount':
                                                                      '${widget.chairAllData['BillAmount']}',
                                                                  'BillStatus':
                                                                      '${widget.chairAllData['Status']}',
                                                                  'TokenNo':
                                                                      '${widget.chairAllData['TokenNo']}',
                                                                  'BillDate':
                                                                      '${widget.chairAllData['BillDate']}',
                                                                  'BookingTime':
                                                                      '${widget.chairAllData['TokenTime']}',
                                                                  'BookForTime':
                                                                      '',
                                                                  'ServiceStartTime':
                                                                      '${widget.chairAllData['ServiceStartTime']}',
                                                                  'ServiceEndTime':
                                                                      '${widget.chairAllData['ServiceEndTime']}',
                                                                }),
                                                          ));
                                                    },
                                                    child:
                                                        Text('Modify Bill'))),
                                            SizedBox(
                                                width: 100,
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (widget.chairAllData[
                                                                  'BillID']
                                                              .toString()
                                                              .isEmpty &&
                                                          selectedStatus ==
                                                              'Finished') {
                                                        int ID =
                                                            await addNewBill(
                                                          BeauticianID:
                                                              '${widget.chairAllData['BeauticianID']}',
                                                          CustomerName:
                                                              '${widget.chairAllData['CustomerName']}',
                                                          CustomerMobileNo:
                                                              '${widget.chairAllData['CustomerNumber']}',
                                                          ServicesDetail:
                                                              '${widget.chairAllData['ServicesDetail']}',
                                                          BillAmount:
                                                              '${widget.chairAllData['BillAmount']}',
                                                          BillStatus:
                                                              '${widget.chairAllData['Status']}',
                                                          TokenNo:
                                                              '${widget.chairAllData['TokenNo']}',
                                                          BillDate:
                                                              '${widget.chairAllData['BillDate']}',
                                                          BookingTime:
                                                              '${widget.chairAllData['TokenTime']}',
                                                          BookForTime: '',
                                                          ServiceStartTime:
                                                              '${widget.chairAllData['ServiceStartTime']}',
                                                          ServiceEndTime:
                                                              '${widget.chairAllData['ServiceEndTime']}',
                                                        );

                                                        country
                                                            .doc(
                                                                '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                                                            .collection(
                                                                'CountryUser')
                                                            .doc(
                                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                                                            .collection(
                                                                'Client')
                                                            .doc(
                                                                '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}')
                                                            .collection('Token')
                                                            .doc(widget
                                                                .chairAllData.id
                                                                .toString())
                                                            .update({
                                                          'Status':
                                                              '$selectedStatus',
                                                          'ServiceEndTime':
                                                              "${currentDateTime.hour}:${currentDateTime.minute}:${currentDateTime.second}",
                                                          'BillDate':
                                                              '${currentDateTime}',
                                                          'BillID': ID,
                                                        });
                                                      }

                                                      if (selectedStatus ==
                                                          'Cancel') {
                                                        country
                                                            .doc(
                                                                '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                                                            .collection(
                                                                'CountryUser')
                                                            .doc(
                                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                                                            .collection(
                                                                'Client')
                                                            .doc(
                                                                '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}')
                                                            .collection('Token')
                                                            .doc(widget
                                                                .chairAllData.id
                                                                .toString())
                                                            .update({
                                                          'Status': 'Cancel',
                                                        });

                                                        if (widget.chairAllData[
                                                                    'BillID']
                                                                .toString()
                                                                .isEmpty
                                                            ? false
                                                            : int.parse(widget
                                                                    .chairAllData[
                                                                        'BillID']
                                                                    .toString()) <
                                                                0) {
                                                          deleteBill(
                                                              id: widget
                                                                  .chairAllData[
                                                                      'BillID']
                                                                  .toString());
                                                        }
                                                      }

                                                      if (selectedStatus ==
                                                          'Waiting') {
                                                        country
                                                            .doc(
                                                                '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                                                            .collection(
                                                                'CountryUser')
                                                            .doc(
                                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                                                            .collection(
                                                                'Client')
                                                            .doc(
                                                                '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}')
                                                            .collection('Token')
                                                            .doc(widget
                                                                .chairAllData.id
                                                                .toString())
                                                            .update({
                                                          'Status': 'Waiting',
                                                        });
                                                      }
                                                    },
                                                    child: Text('Update'))),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  });
                },
                value: check,
              ),
            ),
            SizedBox(
                width: 50,
                child: Text(
                  '${widget.chairAllData['TokenNo']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.chairAllData['CustomerName']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.chairAllData['Status']}',
                      ),
                      Column(
                        children: [
                          Text(
                            '${widget.chairAllData['BillAmount']}',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            '${widget.chairAllData['ServiceDuration']} min',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '${widget.chairAllData['ServicesDetail']}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
