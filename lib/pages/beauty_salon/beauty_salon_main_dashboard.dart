import 'package:com/pages/beauty_salon/add_beautician_screen.dart';
import 'package:com/pages/beauty_salon/add_bill_beauty_salon.dart';
import 'package:com/pages/beauty_salon/all_token_screen.dart';
import 'package:com/pages/beauty_salon/dateGroupingForBeautyTreeView.dart';
import 'package:com/pages/beauty_salon/service_price_list.dart';
import 'package:com/pages/beauty_salon/sql_file_beauty_salon.dart';
import 'package:com/pages/beauty_salon/all_bill_list.dart';
import 'package:com/pages/beauty_salon/widget.dart';
import 'package:flutter/material.dart';

import '../../shared_preferences/shared_preference_keys.dart';

class BeautySAlonMainDashBoard extends StatefulWidget {
  const BeautySAlonMainDashBoard({super.key});

  @override
  State<BeautySAlonMainDashBoard> createState() =>
      _BeautySAlonMainDashBoardState();
}

class _BeautySAlonMainDashBoardState extends State<BeautySAlonMainDashBoard> {
  String selectedJObs = 'current';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
          builder: (context, state) => Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: menuBtnForPriceList(onSelected: (value) {
                  if (value == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServicePriceList(),
                        ));
                  }

                  if (value == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddBeauticianScreen(),
                        ));
                  }
                }),
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
                            child: Center(child: Text('Token Line')),
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
                            child: Center(child: Text('Current Jobs')),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
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
                          child: Center(child: Text('All Job')),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              selectedJObs == 'current'
                  ? Expanded(child: AllTokenList())
                  : selectedJObs == 'delivered'
                      ? Expanded(child: AllBillList())
                      : FutureBuilder<List>(
                future: getAllBill(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return TreeViewForBeautySalon(
                      data: snapshot.data!,
                      state: state,
                      color: Colors.blue,
                      date: 'BillDate',
                      amount: 'BillAmount',
                      childWidget: 'Salon',
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
