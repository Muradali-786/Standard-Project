import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/show_inserting_table_row_server.dart';

class Constants {
  static  onLoading(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Consumer<ShowInsertingTableRowTOServer>(
            builder: (context, value, child) =>  Container(
              padding: EdgeInsets.all(20),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                         CircularProgressIndicator(),
                        SizedBox(width: 20),
                         Text(msg),
                      ],
                    ),
                  ),
                  // value.tableName != '' ?
                  Column(
                    children: [
                      Text(value.tableName),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value.status),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${value.totalNumberOfRow.toString()}/'),
                              Text('${value.count.toString()}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                      // : SizedBox()

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static hideDialog(BuildContext context) {
    Navigator.pop(context);
  }
}