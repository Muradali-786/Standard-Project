import 'package:com/pages/beauty_salon/add_bill_beauty_salon.dart';
import 'package:com/pages/beauty_salon/details_bill_beauty_salon.dart';
import 'package:com/pages/beauty_salon/sql_file_beauty_salon.dart';
import 'package:com/pages/beauty_salon/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../material/datepickerstyle1.dart';

class AllBillList extends StatefulWidget {
  const AllBillList({super.key});

  @override
  State<AllBillList> createState() => _AllBillListState();
}

class _AllBillListState extends State<AllBillList> {
  var orderDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: InkWell(
                          onTap: () async {
                            orderDate = await showDialog(
                                context: context,
                                builder: (context) {
                                  return DatePickerStyle1();
                                });
                            setState(() {});
                          },
                          child: Text(
                              '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(orderDate.toString().substring(0, 4)), int.parse(orderDate.toString().substring(
                                    5,
                                    7,
                                  )), int.parse(orderDate.toString().substring(8, 10)))).toString()}'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddBillBeautySalon(),
                              ));
                        },
                        child: Text('Add Job')),
                  ],
                ),
              ),
            ),
            FutureBuilder<List>(
              future: getAllBill(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var listData = snapshot.data!.where((element) {
                    return orderDate.toString().substring(0, 10) ==
                        DateTime.parse(element['BillDate'].toString())
                            .toString()
                            .substring(0, 10);
                  });

                  return ListView.builder(
                    itemCount: listData.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 50,
                                  child: Text(
                                    '${listData.elementAt(index)['BillID']}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${listData.elementAt(index)['BillDate']}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${listData.elementAt(index)['TokenNo']}',
                                        ),
                                        Text(
                                          '${listData.elementAt(index)['BillAmount']}',
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              menuBtnForDetails(onSelected: (value) {
                                if (value == 1) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddBillBeautySalon(
                                                data:
                                                    listData.elementAt(index)),
                                      ));
                                }

                                if (value == 2) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsBillSalon(
                                            data: listData.elementAt(index)),
                                      ));
                                }
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
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
