import 'package:flutter/material.dart';

import '../../../../shared_preferences/shared_preference_keys.dart';
import '../../../restaurant/SalePur/SalePur2AddItemUISingle.dart';
dynamic totalAmmount;
class ItemTable1 extends StatelessWidget {
  dynamic tableData;

  ItemTable1({super.key, required this.tableData});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Colors.blue,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                'Qty x Price',
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
            ],
          ),
        ),
        SizedBox(height: h * 0.01),

        FutureBuilder<List<dynamic>>(
            future: tableData,
            builder: (context, snapshot) {
              var tableData = snapshot.data;

              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: tableData!.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var data = tableData[index];

                    return GestureDetector(
                      onTap: (){


                      },
                      child: Table(
                        border: TableBorder.all(color: Colors.black, width: 1),
                        columnWidths: {
                          0: FlexColumnWidth(
                              3), // First cell occupies 75% of space
                          1: FlexColumnWidth(
                              1), // Second cell occupies 25% of space
                        },
                        children: [
                          TableRow(children: [
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: w * 0.04,
                                  right: w * 0.02,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "${data['ItemName'].toString()}\t,\t${data['ItemDescription'].toString()}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${data['Qty'].toString()} \t x \t${data['Price'].toString()}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),


                                  ],
                                ),
                              ),
                            ),

                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.only(right: w * 0.04),
                                child: Text(
                                  data['Total'].toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return SizedBox();
              }
            }),
        SizedBox(height: h * 0.01),
      ],
    );
  }
}

class TotalPrice extends StatelessWidget {
  final String billAmount;
  const TotalPrice({super.key, required this.billAmount});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: h * 0.06,
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
          Text(
            billAmount,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
