import 'package:com/pages/tailor_shop_systom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared_preferences/shared_preference_keys.dart';

class SearchPage extends StatefulWidget {
  final List data;
  final String searchNumber;
  final void Function(void Function()) state;

  const SearchPage(
      {super.key,
      required this.data,
      required this.state,
      required this.searchNumber});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int totalDeliveredJOb = 0;
  int processJob = 0;

  var orderDate = DateTime.now();

  Map dropDownDebitMap = {
    "ID": null,
    'Title': "Worker Account",
    'SubTitle': null,
    "Value": null
  };

  @override
  void initState() {
    super.initState();

    print('.${widget.data.length}');

    widget.data.forEach((element) {
      if (element['OrderStatus'] == 'Delivered') {
        totalDeliveredJOb = totalDeliveredJOb + 1;
      } else {
        processJob = processJob + 1;
      }
    });
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
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Details of:'),
                          Text('${widget.searchNumber}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Balance:'),
                          Text('5000'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Delivered Jobs : '),
                          Text('$totalDeliveredJOb'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('In Process Jobs:'),
                          Text('$processJob'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.data.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                        'Order No: ${widget.data[index]['TailorBooking1ID']}'),
                                  ),
                                  Text('${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(widget.data[index]['OrderDate'].toString().substring(0, 4)), int.parse(widget.data[index]['OrderDate'].toString().substring(
                                        5,
                                        7,
                                      )), int.parse(widget.data[index]['OrderDate'].toString().substring(8, 10)))).toString()}'),
                                ],
                              ),
                              Text(widget.data[index]['CustomerName'].toString()),
                              Text(widget.data[index]['OrderTitle'].toString()),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      widget.data[index]['BillAmount']
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      widget.data[index]['TotalReceived']
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.data[index]['BillBalance']
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                menuBtnForOrderDetails(
                                  onSelected: (value) {
                                    if (value == 1) {}
                                    if (value == 2) {}
                                    if (value == 3) {
                                      showDialogForPrintCash(
                                          context: context,
                                          onPressedBack: () {},
                                          onPressedOtherExp: (){},
                                          onPressedCashRec: () {},
                                          onPressedPrint: () {},
                                          onPressedPrintPreview: (){},
                                          onPressedWhatsApp: () {

                                          });
                                    }
                                  },
                                  onTapCutting: () async {
                                    Navigator.pop(context);
                                    await dialogForChangeStatus(
                                        context: context,
                                        parentState: widget.state,
                                        selectedStatus: 'Cutting',
                                        orderDate: orderDate,
                                        dropDownDebitMap: dropDownDebitMap,
                                        ID: widget.data[index]['ID']
                                            .toString());
                                  },
                                  onTapDelivered: () async {
                                    Navigator.pop(context);
                                    await dialogForChangeStatus(
                                        context: context,
                                        parentState: widget.state,
                                        selectedStatus: 'Delivered',
                                        orderDate: orderDate,
                                        dropDownDebitMap: dropDownDebitMap,
                                        ID: widget.data[index]['ID']
                                            .toString());
                                  },
                                  onTapFinished: () async {
                                    Navigator.pop(context);
                                    await dialogForChangeStatus(
                                      context: context,
                                      parentState: widget.state,
                                      selectedStatus: 'Finished',
                                      ID: widget.data[index]['ID'].toString(),
                                      orderDate: orderDate,
                                      dropDownDebitMap: dropDownDebitMap,
                                    );
                                  },
                                  onTapSewing: () async {
                                    Navigator.pop(context);
                                    await dialogForChangeStatus(
                                      context: context,
                                      selectedStatus: 'Sewing',
                                      parentState: widget.state,
                                      orderDate: orderDate,
                                      ID: widget.data[index]['ID'].toString(),
                                      dropDownDebitMap: dropDownDebitMap,
                                    );
                                  },
                                ),
                                Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                              '${widget.data[index]['OrderStatus']}')),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
