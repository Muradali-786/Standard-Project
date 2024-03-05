import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../CashBook/CashBookEntryDialogUI.dart';
import '../CashBook/cashBookSql.dart';
import '../SalePur/salePurItemUI.dart';
import '../SalePur/sale_pur1_SQL.dart';

class AccountLedgerListUI extends StatefulWidget {
 final List list ;
  const AccountLedgerListUI({Key? key , required this.list}) : super(key: key);

  @override
  State<AccountLedgerListUI> createState() => _AccountLedgerListUIState();
}

class _AccountLedgerListUIState extends State<AccountLedgerListUI> {

  CashBookSQL _cashBookSQL = CashBookSQL();
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  late Color myColor;
  String menuName = '';
  List<Color> colorsList = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.grey.shade600
  ];
  bool check = true;
  int run = 0;
  int debitCurrent = 0;
  int creditCurrent = 0;
  int debitTotal = 0;
  int creditTotal = 0;

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.list.length,
        itemBuilder: (contexts, index) {
          if(check) {
            List list = widget.list;

            for (Map<String, dynamic> element in list) {
              debitTotal += element['Debit'] as int;
              creditTotal += element['Credit'] as int;
            }
            if (list.length > 0 && list[0]['EntryNo'] == 0) {
              debitCurrent = debitTotal - list[0]['Debit'] as int;
              creditCurrent = creditTotal - list[0]['Credit'] as int;
            }
            check = false;
          }

          if (widget.list[0]['EntryNo'] == 0) {

            int tempd = debitTotal -
                widget.list[index]['Debit'] as int;
            debitCurrent = debitTotal + tempd;
            int tempc = creditTotal -
                widget.list[index]['Credit'] as int;
            creditCurrent = creditTotal + tempc;
          }
          myColor = (widget.list[index]['EntryType'] == "SL")
              ? colorsList[0]
              : (widget.list[index]['EntryType'] == "PU")
              ? colorsList[1]
              : (widget.list[index]['EntryType'] == "SR")
              ? colorsList[2]
              : (widget.list[index]['EntryType'] ==
              "PR")
              ? colorsList[3]
              : colorsList[4];
          int cal = widget.list[index]['Debit'] -
              widget.list[index]['Credit'];
          run = run + cal;
          return Padding(
            padding: const EdgeInsets.only(
                top: 8, left: 8, right: 8),
            child: InkWell(
              onTap: () async {
                List argumentList = [];
                List listOFDataSalePur1 = [];

                if (widget.list[index]['EntryType']
                    .toString()
                    .length ==
                    0) {
                  print(
                      '......................if.......................');
                  List listOFDataLedgerFromCashBook =
                  await _cashBookSQL
                      .getDataForLedgerFromCashBook(
                      widget.list[index]['EntryNo']);
                  argumentList = [
                    {"action": "EDIT"},
                    listOFDataLedgerFromCashBook[0]
                  ];
                  menuName = 'CashBook';
                } else {
                  listOFDataSalePur1 =
                  await _salePurSQLDataBase
                      .getDataFromSalePur(
                      salePur1ID: widget.list[index]
                      ['TableID']);

                  if (widget.list[index]['EntryType']
                      .toString()
                      .substring(0, 2) ==
                      'SL') {
                    menuName = 'Sale';
                  }
                  if (widget.list[index]['EntryType']
                      .toString()
                      .substring(0, 2) ==
                      'PU') {
                    menuName = 'Purchase';
                  }
                  if (widget.list[index]['EntryType']
                      .toString()
                      .substring(0, 2) ==
                      'SR') {
                    menuName = 'Sales Return';
                  }
                  if (widget.list[index]['EntryType']
                      .toString()
                      .substring(0, 2) ==
                      'PR') {
                    menuName = 'Purchase Return';
                  }
                }

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
                      duration: const Duration(
                          milliseconds: 300),
                      alignment: Alignment.center,
                      child: Center(
                          child: SizedBox(
                              height: widget.list[index][
                              'EntryType']
                                  .toString()
                                  .length ==
                                  0
                                  ?  410
                                  : MediaQuery.of(
                                  context)
                                  .size
                                  .height,
                              child: Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(8.0),
                                  child: widget.list[index][
                                  'EntryType']
                                      .toString()
                                      .length ==
                                      0
                                      ? CashBook(
                                      context: context,
                                      list:
                                      argumentList,
                                      menuName:
                                      'Cash Book')
                                      : Material(
                                    child:
                                    SingleChildScrollView(
                                      child: SalePurItemUI(
                                          entryType:
                                          'SL',
                                          color: Colors
                                              .blue,
                                          list:
                                          listOFDataSalePur1,
                                          menuName:
                                          menuName,
                                          itemData:
                                          listOFDataSalePur1,
                                          status:
                                          'Ledger'),
                                    ),
                                  )))),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: (widget.list[index]['EntryNo'] == 0)
                        ? Colors.yellow[50]
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(5),
                    border: Border.all(
                        width: 1, color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: FittedBox(
                                    child: Text(
                                      widget.list[index]
                                      ['Date']
                                          .toString()
                                          .substring(
                                          0, 10),
                                      style: TextStyle(
                                        //fontSize: 15,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          color: Colors
                                              .black),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding:
                                    EdgeInsets.all(
                                        4)),
                                Flexible(
                                  child: FittedBox(
                                    child: Text(
                                      'CB ${widget.list[index]['EntryNo'].toString()} ${widget.list[index]['EntryType']} ${widget.list[index]['TableID']}',
                                      style: TextStyle(
                                          color:
                                          myColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${widget.list[index]['AccountName'].toString()}, ${widget.list[index]['Particulars']}',
                              maxLines: 2,
                              style: TextStyle(
                                overflow: TextOverflow
                                    .ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Center(
                                child: Align(
                                  alignment: Alignment
                                      .centerRight,
                                  child: FittedBox(
                                    child: Text(
                                      NumberFormat(
                                          "###,###",
                                          "en_US")
                                          .format(cal)
                                          .toString(),
                                      style: TextStyle(
                                          color: (widget.list[index][
                                          'EntryNo'] ==
                                              0)
                                              ? Colors
                                              .yellow[
                                          50]
                                              : (cal <
                                              0)
                                              ? Colors
                                              .red
                                              : Colors
                                              .green),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding:
                                EdgeInsets.all(4)),
                            Flexible(
                              flex: 5,
                              child: FittedBox(
                                child: Align(
                                  alignment: Alignment
                                      .centerRight,
                                  child: Text(
                                    NumberFormat(
                                        "###,###",
                                        "en_US")
                                        .format(run)
                                        .toString(),
                                    // textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
