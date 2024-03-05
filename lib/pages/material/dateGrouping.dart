import 'package:flutter/material.dart';
import 'package:com/pages/general_trading/Accounts/accountLedgerWidgetUI.dart';
import 'package:com/pages/general_trading/SalePur/salePurItemUI.dart';
import 'package:intl/intl.dart';
import '../general_trading/CashBook/CashBookListUI.dart';

class DateGrouping extends StatefulWidget {
  final List list;
  final Color color;
  final String date;
  final String updatedDate;
  final String amount;
  final String childWidget;
  final String? menuName;
  final Map? dropDownMap;

  const DateGrouping(
      {Key? key,
      this.dropDownMap,
      this.menuName,
      required this.date,
      required this.childWidget,
      required this.amount,
      required this.updatedDate,
      required this.list,
      required this.color})
      : super(key: key);

  @override
  State<DateGrouping> createState() => _DateGroupingState();
}

class _DateGroupingState extends State<DateGrouping> {
  Set<String> yearBilling = {};
  Set<String> monthBilling = {};
  Set<String> dayBilling = {};
  List<String> dayNameList = [];
  List<int> totalYearCount = [];
  int totalCountYear = 0;
  double totalBillAmYear = 0;
  List<double> totalBillAmountYear = [];
  int totalCountMonth = 0;
  double totalBillAmMonth = 0;
  List<int> totalMonthCount = [];
  List<double> totalBillAmountMonth = [];
  int totalCountDay = 0;
  double totalBillAmDay = 0;
  List<int> totalDayCount = [];
  List<double> totalBillAmountDay = [];
  double groundTotalYear = 0.0;
  List<double> perYear = [];
  List<double> perMonth = [];
  List<double> perDay = [];
  List modifiedRecord = [];
  String selectedYear = '';
  String selectedMonth = '';
  bool checkSortingForMonth = true;
  bool checkSortingForYear = true;
  bool checkSortingForDay = true;
  List<double> showSortingYearIcon = [];
  List<double> showSortingMonthIcon = [];
  List<double> showSortingDayIcon = [];
  List dataBilling = [];
  bool checkForSearch = true;
  double opacity = 0;
  List listItemSalePur = [];
  List<bool> listCheckForEdit = [];
  List<double> lisOpacityForEdit = [];
  List<double> lisOpacityForCancel = [];
  List<double> lisOpacityForUpdateCheck = [];

  Set<String> getMonth(String year, double grandTotal) {
    print('.......grand total month...............$grandTotal');
    Set<String> monthList = {};
    showSortingMonthIcon.clear();
    totalBillAmountMonth.clear();
    totalMonthCount.clear();
    perMonth.clear();

    //UpdatedDate  Date
    for (int count = 0; count < widget.list.length; count++) {
      if (widget.list[count][widget.updatedDate].toString().length != 0) {
        if (year ==
            widget.list[count][widget.date].toString().substring(0, 4)) {
          DateTime dateMonth = DateTime(
              int.parse(widget.list[count][widget.date]
                  .toString()
                  .substring(0, 4)
                  .toString()),
              int.parse(
                  widget.list[count][widget.date].toString().substring(5, 7)));
          showSortingMonthIcon.add(0.0);
          monthList.add('${DateFormat('MM,MMMM').format(dateMonth)}');
        }
      }
    }

    print('........... list of month.............${monthList.toString()}...');

    for (int countOFMonth = 0;
        countOFMonth < monthList.length;
        countOFMonth++) {
      totalBillAmMonth = 0.0;
      totalCountMonth = 0;
      for (int countOFList = 0;
          countOFList < widget.list.length;
          countOFList++) {
        if (widget.list[countOFList][widget.updatedDate].toString().length !=
            0) {
          if (year ==
              widget.list[countOFList][widget.date]
                  .toString()
                  .substring(0, 4)) {
            if (monthList.elementAt(countOFMonth).substring(0, 2) ==
                widget.list[countOFList][widget.date]
                    .toString()
                    .substring(5, 7)) {
              totalCountMonth++;
              totalBillAmMonth += double.parse(
                  widget.list[countOFList][widget.amount].toString());
            }
          }
        }
      }

      totalMonthCount.add(totalCountMonth);
      totalBillAmountMonth.add(totalBillAmMonth);
    }

    for (int per = 0; per < totalBillAmountMonth.length; per++) {
      print(
          '...........100 / ...ground Total ... ${(100.0 / grandTotal) * totalBillAmountMonth[per]}.....');
      perMonth.add((100.0 / grandTotal) * totalBillAmountMonth[per]);
    }

    print('...........................per month $perMonth');

    return monthList;
  }

  void getDay(String year, String month, double grandTotal) {
    print('.......... grand day.......$grandTotal');
    Set<String> dayList = {};
    showSortingDayIcon.clear();
    totalBillAmountDay.clear();
    totalDayCount.clear();
    perDay.clear();

    for (int count = 0; count < widget.list.length; count++) {
      if (widget.list[count][widget.updatedDate].toString().length != 0) {
        if (year ==
            widget.list[count][widget.date].toString().substring(0, 4)) {
          if (month ==
              widget.list[count][widget.date].toString().substring(5, 7)) {
            dayList.add(
                widget.list[count][widget.date].toString().substring(8, 10));
          }
        }
      }
    }
    for (int count = 0; count < dayList.length; count++) {
      DateTime dateDay = DateTime(int.parse(year), int.parse(month),
          int.parse(dayList.elementAt(count)));

      print(DateFormat('dd,EEEE').format(dateDay));

      showSortingDayIcon.add(0.0);
      dayNameList.add(DateFormat('dd,EEE').format(dateDay));
    }

    print('..........list of day.............${dayNameList.toString()}...');

    for (int countOFDay = 0; countOFDay < dayNameList.length; countOFDay++) {
      totalBillAmDay = 0.0;
      totalCountDay = 0;
      for (int countOFList = 0;
          countOFList < widget.list.length;
          countOFList++) {
        if (widget.list[countOFList][widget.updatedDate].toString().length !=
            0) {
          if (year ==
              widget.list[countOFList][widget.date]
                  .toString()
                  .substring(0, 4)) {
            print('.............................year...............');
            if (month ==
                widget.list[countOFList][widget.date]
                    .toString()
                    .substring(5, 7)) {
              if (dayNameList.elementAt(countOFDay).substring(0, 2) ==
                  widget.list[countOFList][widget.date]
                      .toString()
                      .substring(8, 10)) {
                print('......................month....................');
                totalCountDay++;
                totalBillAmDay += double.parse(
                    widget.list[countOFList][widget.amount].toString());
              }
            }
          }
        }
      }
      print('..................adding......................');
      totalDayCount.add(totalCountDay);
      totalBillAmountDay.add(totalBillAmDay);
    }

    print('...................count...${totalDayCount.toString()}');
    print('...................total...${totalBillAmountDay.toString()}');

    for (int per = 0; per < totalBillAmountDay.length; per++) {
      print(
          '...........100 / ...ground Total ... ${(100.0 / grandTotal) * totalBillAmountDay[per]}.....');
      perDay.add((100.0 / grandTotal) * totalBillAmountDay[per]);
    }

    print('...........................per day $perDay');

    //return dayList;
  }

  List getData(String year, String month, String day) {
    List dataBilling = [];
    for (int count = 0; count < widget.list.length; count++) {
      if (widget.list[count][widget.updatedDate].toString().length != 0) {
        if (year ==
            widget.list[count][widget.date].toString().substring(0, 4)) {
          if (month ==
              widget.list[count][widget.date].toString().substring(5, 7)) {
            if (widget.list[count][widget.date].toString().substring(8, 10) ==
                day) {
              dataBilling.add(widget.list[count]);
            }
          }
        }
      }
    }
    print('...........list of data.............${dataBilling.toString()}...');
    return dataBilling;
  }

  @override
  void initState() {
    super.initState();
    print('....................${widget.list.length}.........................');

    for (int count = 0; count < widget.list.length; count++) {
      if (widget.list[count][widget.updatedDate].toString().length != 0) {
        lisOpacityForEdit.add(0.0);
        lisOpacityForCancel.add(0.0);
        lisOpacityForUpdateCheck.add(0.0);
        listCheckForEdit.add(true);
        yearBilling
            .add(widget.list[count][widget.date].toString().substring(0, 4));
      }
    }

    print('....yearBIlling  .....    $yearBilling');
    for (int countYear = 0; countYear < yearBilling.length; countYear++) {
      showSortingYearIcon.add(0.0);
    }

    for (int countOFYear = 0; countOFYear < yearBilling.length; countOFYear++) {
      totalBillAmYear = 0.0;
      totalCountYear = 0;
      for (int countOFList = 0;
          countOFList < widget.list.length;
          countOFList++) {
        if (widget.list[countOFList][widget.updatedDate].toString().length !=
            0) {
          if (yearBilling.elementAt(countOFYear) ==
              widget.list[countOFList][widget.date]
                  .toString()
                  .substring(0, 4)) {
            totalCountYear++;
            totalBillAmYear += double.parse(
                widget.list[countOFList][widget.amount].toString());
          }
        }
      }
      totalYearCount.add(totalCountYear);
      totalBillAmountYear.add(totalBillAmYear);
    }

    for (int gTotal = 0; gTotal < totalBillAmountYear.length; gTotal++) {
      groundTotalYear += totalBillAmountYear[gTotal];
    }

    for (int per = 0; per < totalBillAmountYear.length; per++) {
      perYear.add((100.0 / groundTotalYear) * totalBillAmountYear[per]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: yearBilling.length,
      itemBuilder: (context, indexOfYear) {
        return Column(
          children: [
            ExpansionTile(
              subtitle: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 1,
                    width: (MediaQuery.of(context).size.width),
                        // *
                        // ((perYear[indexOfYear]) / 100),,
                    color: widget.color,
                  )),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: [
                        Text(
                          yearBilling.elementAt(indexOfYear).toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: InkWell(
                              onTap: () {
                                List<String> listDayNameString = [];

                                List<DateTime> dateTimeList = [];

                                for (int count = 0;
                                    count < monthBilling.length;
                                    count++) {
                                  DateTime dateDay = DateTime(
                                      int.parse(selectedYear),
                                      int.parse(monthBilling
                                          .elementAt(count)
                                          .substring(0, 2)));
                                  dateTimeList.add(dateDay);
                                }

                                print(
                                    '.................datetime   ${dateTimeList.toString()}');

                                if (checkSortingForYear) {
                                  dateTimeList.sort((a, b) {
                                    return a.compareTo(b);
                                  });

                                  checkSortingForYear = false;
                                } else {
                                  dateTimeList.sort((a, b) {
                                    return b.compareTo(a);
                                  });

                                  checkSortingForYear = true;
                                }

                                for (int count = 0;
                                    count < dateTimeList.length;
                                    count++) {
                                  listDayNameString.add(DateFormat('MM,MMMM')
                                      .format(dateTimeList[count]));
                                }
                                monthBilling.clear();
                                monthBilling.addAll(listDayNameString);
                              },
                              child: Opacity(
                                  opacity: showSortingYearIcon[indexOfYear],
                                  child: Icon(
                                    checkSortingForYear
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    size: 15,
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                            child: FittedBox(
                                child:
                                    Text('(${totalYearCount[indexOfYear]})'))),
                        Flexible(
                            child: FittedBox(
                                child: Text(
                                    '${totalBillAmountYear[indexOfYear]}'))),
                      ],
                    ),
                  )
                ],
              ),
              onExpansionChanged: (value) {
                if (value) {
                  setState(() {
                    selectedYear = yearBilling.elementAt(indexOfYear);
                    monthBilling = getMonth(yearBilling.elementAt(indexOfYear),
                        totalBillAmountYear[indexOfYear]);
                    showSortingYearIcon[indexOfYear] = 1.0;
                  });
                } else {
                  selectedYear = '';
                  setState(() {
                    showSortingYearIcon[indexOfYear] = 0.0;
                  });

                  monthBilling.clear();
                  dataBilling.clear();
                  dayBilling.clear();
                  dayNameList.clear();
                }
              },
              children: List.generate(
                monthBilling.length,
                (indexOFMonth) => ExpansionTile(
                  onExpansionChanged: (value) {
                    if (value) {
                      setState(() {
                        showSortingMonthIcon[indexOFMonth] = 1.0;
                        selectedMonth = monthBilling
                            .elementAt(indexOFMonth)
                            .substring(0, 2);
                        getDay(
                            yearBilling.elementAt(indexOfYear).toString(),
                            monthBilling
                                .elementAt(indexOFMonth)
                                .substring(0, 2),
                            totalBillAmountYear[indexOfYear]);
                      });
                    } else {
                      dayNameList.clear();
                      setState(() {
                        showSortingMonthIcon[indexOFMonth] = 0.0;
                      });

                      selectedMonth = '';
                    }
                  },
                  subtitle: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 1,
                        width: (MediaQuery.of(context).size.width),
                            // *
                            // (perMonth[indexOFMonth] / 100),
                        color: widget.color,
                      )),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 4,
                          child: FittedBox(
                            child: Row(
                              children: [
                                Text(
                                    '${monthBilling.elementAt(indexOFMonth).toString()}'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          List<String> listDayNameString = [];
                                          List<DateTime> dateTimeList = [];
                                          for (int count = 0;
                                              count < dayNameList.length;
                                              count++) {
                                            DateTime dateDay = DateTime(
                                                int.parse(selectedYear),
                                                int.parse(selectedMonth),
                                                int.parse(dayNameList
                                                    .elementAt(count)
                                                    .substring(0, 2)));

                                            dateTimeList.add(dateDay);
                                          }

                                          if (checkSortingForMonth) {
                                            dateTimeList.sort((a, b) {
                                              return a.compareTo(b);
                                            });

                                            checkSortingForMonth = false;
                                          } else {
                                            dateTimeList.sort((a, b) {
                                              return b.compareTo(a);
                                            });

                                            checkSortingForMonth = true;
                                          }

                                          print('.....$dateTimeList');
                                          for (int count = 0;
                                              count < dateTimeList.length;
                                              count++) {
                                            listDayNameString.add(
                                                DateFormat('dd,EEE').format(
                                                    dateTimeList[count]));
                                          }

                                          dayNameList.clear();
                                          dayNameList.addAll(listDayNameString);
                                        });
                                      },
                                      child: Opacity(
                                        opacity:
                                            showSortingMonthIcon[indexOFMonth],
                                        child: Icon(
                                          checkSortingForMonth
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward,
                                          size: 15,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                  child: FittedBox(
                                      child: Text(
                                          '(${totalMonthCount[indexOFMonth]})'))),
                              Flexible(
                                  child: FittedBox(
                                      child: Text(
                                          '${totalBillAmountMonth[indexOFMonth]}'))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: List.generate(
                    dayNameList.length,
                    (indexOFDay) => ExpansionTile(
                      subtitle: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 1,
                            width: (MediaQuery.of(context).size.width) ,
                                // *
                                // (perDay[indexOFDay] / 100),
                            color: widget.color,
                          )),
                      onExpansionChanged: (value) {
                        setState(() {
                          if (value) {
                            lisOpacityForEdit.clear();
                            lisOpacityForCancel.clear();
                            lisOpacityForUpdateCheck.clear();
                            listCheckForEdit.clear();

                            showSortingDayIcon[indexOFDay] = 1.0;

                            dataBilling = getData(
                                yearBilling.elementAt(indexOfYear),
                                monthBilling
                                    .elementAt(indexOFMonth)
                                    .substring(0, 2),
                                dayNameList
                                    .elementAt(indexOFDay)
                                    .substring(0, 2));
                            for (int count = 0;
                                count < dataBilling.length;
                                count++) {
                              lisOpacityForEdit.add(0.0);
                              lisOpacityForCancel.add(0.0);
                              lisOpacityForUpdateCheck.add(0.0);
                              listCheckForEdit.add(true);
                            }
                          } else {
                            dataBilling.clear();
                            showSortingDayIcon[indexOFDay] = 0.0;
                          }
                        });
                      },
                      title: Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 4,
                              child: Row(
                                children: [
                                  Text(
                                    '${dayNameList.elementAt(indexOFDay)}',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        List list = [];

                                        setState(() {
                                          if (checkSortingForDay) {
                                            final listOfData =
                                                dataBilling.reversed;
                                            list.addAll(listOfData.toList());
                                            checkSortingForDay = false;
                                          } else {
                                            final listOfData =
                                                dataBilling.reversed;
                                            list.addAll(listOfData.toList());
                                            checkSortingForDay = true;
                                          }

                                          print(
                                              '.....................listOFDat ${list.toString()}');

                                          dataBilling.clear();
                                          dataBilling.addAll(list);
                                        });

                                        print(
                                            '............salePurID.......$dataBilling ..');
                                      },
                                      child: Opacity(
                                        opacity: showSortingDayIcon[indexOFDay],
                                        child: Icon(
                                          checkSortingForDay
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                      child: FittedBox(
                                          child: Text(
                                              '(${totalDayCount[indexOFDay]})'))),
                                  Flexible(
                                      child: FittedBox(
                                          child: Text(
                                              '${totalBillAmountDay[indexOFDay]}'))),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      children: [
                        widget.childWidget == 'Sale'
                            ? SalePurItemUI(
                                color: widget.color,
                                list: widget.list,
                                entryType: widget.dropDownMap!['SubTitle'],
                                menuName: widget.menuName!,
                                itemData: dataBilling,
                                status: 'daysRecord')
                            : widget.childWidget == 'CashBook'
                                ? CashItemUI(
                                    list: dataBilling,
                                    menuName: widget.menuName,
                                    showStatus: 'DateGrouping',
                                  )
                                : widget.childWidget == 'Ledger'
                                    ? AccountLedgerListUI(list: dataBilling)
                                    : Container()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
