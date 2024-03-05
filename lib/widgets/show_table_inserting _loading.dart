// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../utils/show_inserting_table_row_server.dart';
//
// class ShowTableInsertingLoading {
//   static onLoading(BuildContext context, String totalLength, String tableName) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Align(
//           alignment: Alignment.topCenter,
//           child: Padding(
//             padding: const EdgeInsets.only(top: 32.0),
//             child: Material(
//               child: Container(
//                 height: 100,
//                 padding: EdgeInsets.all(20),
//                 child:Consumer<ShowInsertingTableRowTOServer>(
//                   builder: (context, value, child) =>  new Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(children: [
//                        
//                       ],),
//                       Text('$tableName'),
//                       Text('Total Table Row Length :  $totalLength'),
//                       Text('Number of Row Inserting :  ${value.count}'),
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   static hideDialogForTable(BuildContext context) {
//     Navigator.pop(context);
//   }
// }