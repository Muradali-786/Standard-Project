import 'package:com/pages/tailor_shop_systom/dateGrouping.dart';
import 'package:com/pages/tailor_shop_systom/sql_file.dart';
import 'package:com/pages/tailor_shop_systom/widgets.dart';
import 'package:flutter/material.dart';



class AllOrderPages extends StatefulWidget {
  const AllOrderPages({
    super.key,
  });

  @override
  State<AllOrderPages> createState() => _AllOrderPagesState();
}

class _AllOrderPagesState extends State<AllOrderPages> {
  TextEditingController searchController =
      TextEditingController();
  String selectedJObs = 'current';
  var orderDate = DateTime.now();

  Map dropDownDebitMap = {
    "ID": null,
    'Title': "Worker Account",
    'SubTitle': null,
    "Value": null
  };

  String selectedStatus = '';

  List<String> orderStatus = [
    'Select Status',
    'New Order',
    'Cutting',
    'Sewing',
    'Finished'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
          builder: (context, state) => ListView(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: searchController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Mobile Number'),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {

                                // final url = Uri.parse('https://graph.facebook.com/v17.0/104277659114065/messages');
                                // final headers = {
                                //   'Authorization': 'Bearer EAAEk79lvtKoBO5vONN9P44orFkBMXwkh062NBNacZB0kB4oeZANTQ6RyZAGauGOSNoxwd2LtKSEEiBHs9EALAyoQ5vE9ngHF7s3XoKSe2b9qZCLuMM3hm2Oh671nB4v18XvhiZBuqwliSYkuSTMg1IKp0icrpFWVwv9UyUyviRS3RwVBNdJYVIb5ZATArsTpVVwA2lIIOAhTCjj26CjMWAvjEuo85NVg5frIsH',
                                //   'Content-Type': 'application/json',
                                // };
                                //
                                // final body = jsonEncode({
                                //   "messaging_product": "whatsapp",
                                //   "to": "+923041810687",
                                //   "type": "template",
                                //   "template": {
                                //     "name": "hello_world",
                                //     "language": {
                                //       "code": "en_US"
                                //     }
                                //   }
                                // });
                                //
                                // final response = await http.post(url, headers: headers, body: body);
                                //
                                // if (response.statusCode == 200) {
                                //   print('Message sent successfully');
                                // } else {
                                //   print(
                                //       'Failed to send message. Status code: ${response
                                //           .statusCode}');
                                //   print('Response body: ${response.body}');
                                // }
                                //




                              // List data = await getSearchByNumber(
                              //     context: context,
                              //     number: searchController.text);
                              //
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => SearchPage(
                              //               data: data,
                              //               searchNumber: searchController.text,
                              //               state: state,
                              //             )));
                            },
                            child: Text('Search')))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedJObs = 'current';
                            });
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: selectedJObs == 'current'
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black)),
                            child: Center(child: Text('Current Jobs')),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedJObs = 'delivered';
                            });
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: selectedJObs == 'delivered'
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black)),
                            child: Center(child: Text('Delivered Jobs')),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedJObs = 'employ';
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: selectedJObs == 'employ'
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black)),
                          child: Center(child: Text('Employ Details')),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              selectedJObs == 'current'
                  ? Column(
                      children: [
                        FutureBuilder<List>(
                          future: getAllData(
                               status: 'New Order'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return customListTile(
                                dropDownDebitMap: dropDownDebitMap,
                                state: state,
                                orderDate: orderDate,
                                data: snapshot.data!,
                                title: 'New Order',
                                context: context,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        FutureBuilder<List>(
                          future: getAllData(
                               status: 'Cutting'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return customListTile(
                                dropDownDebitMap: dropDownDebitMap,
                                state: state,
                                orderDate: orderDate,
                                data: snapshot.data!,
                                title: 'Cutting',
                                context: context,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        FutureBuilder<List>(
                          future: getAllData(
                               status: 'Sewing'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return customListTile(
                                dropDownDebitMap: dropDownDebitMap,
                                state: state,
                                orderDate: orderDate,
                                data: snapshot.data!,
                                title: 'Sewing',
                                context: context,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        FutureBuilder<List>(
                          future: getAllData(
                              status: 'Finished'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return customListTile(
                                dropDownDebitMap: dropDownDebitMap,
                                state: state,
                                orderDate: orderDate,
                                data: snapshot.data!,
                                title: 'Finished',
                                context: context,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    )
                  : FutureBuilder<List>(
                future: getAllTailorData(),
                    builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return TreeViewForTailor(
                      data: snapshot.data!,
                      state: state,
                      color: Colors.blue,
                      date: 'DeliveredDate',
                      amount: 'BillAmount',
                      childWidget: 'Tailor',
                    );
                  }else{
                    return const SizedBox();
                  }
                    },
                  )
            ],
          ),
        ),
      ),
    );
  }
}
