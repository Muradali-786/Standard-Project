import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../main/tab_bar_pages/home/themedataclass.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import 'CashBookEntryDialogUI.dart';
import 'cashBookSql.dart';

class CashItemUI extends StatefulWidget {
   List list;
  final String? menuName;
  final String showStatus;
  final String? ForSlip;
   void Function(void Function())? setState;

    CashItemUI(
      {Key? key,
        this.ForSlip,
      required this.showStatus,
        this.setState,
      required this.list,
      required this.menuName})
      : super(key: key);

  @override
  State<CashItemUI> createState() => _CashItemUIState();
}

class _CashItemUIState extends State<CashItemUI> {
  Color myColor = Color(Random().nextInt(0xffffffff));
  List originalList = [];
  CashBookSQL _cashBookSQL = CashBookSQL();
  final TextStyle posRes =
      TextStyle(color: Colors.black, backgroundColor: Colors.yellow);
  Set<String> entryType = {};
  List data = [];
  List<int> entryTypeCount = [];
  List<double> totalEntryTypeAmount = [];
  List<Color> colorsList = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.grey.shade600
  ];
  bool sliderOpacity = true;
  double opacity = 0;
  int sliderValue = 2;

  @override
  void initState() {
    super.initState();

    if (widget.showStatus == 'DateGrouping') {
      for (int i = 0; i < widget.list.length; i++) {
        entryType.add(widget.list[i]['EntryType']);
      }
      entryType.forEach((element) {
        entryTypeCount.add(0);
        totalEntryTypeAmount.add(0);
      });
    }



    SharedPreferencesKeys.prefs!.setInt('gridValue', 1);

    sliderValue = SharedPreferencesKeys.prefs!.getInt('gridValue')!;



    for (int i = 0; i < entryType.length; i++) {
      for (int j = 0; j < widget.list.length; j++) {
        if (entryType.elementAt(i) == widget.list[j]['EntryType']) {
          entryTypeCount[i]++;
          totalEntryTypeAmount[i] += widget.list[j]['Amount'];
        }
      }
    }
  }

  void getData(String entryType) {
    for (int i = 0; i < widget.list.length; i++) {
      if (widget.list[i]['EntryType'] == entryType) {
        data.add(widget.list[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.showStatus == 'DateGrouping'
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: entryType.length,
            itemBuilder: (context, index) {
              myColor = (widget.list[index]['EntryType'] == "SL")
                  ? colorsList[0]
                  : (widget.list[index]['EntryType'] == "PU")
                      ? colorsList[1]
                      : (widget.list[index]['EntryType'] == "SR")
                          ? colorsList[2]
                          : (widget.list[index]['EntryType'] == "PR")
                              ? colorsList[3]
                              : colorsList[4];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  onExpansionChanged: (value) {
                    setState(() {
                      if (value) {
                        getData(entryType.elementAt(index));
                      } else {
                        data.clear();
                      }
                    });
                  },
                  title: Text(entryType.elementAt(index)),
                  subtitle: Text(
                      '(${entryTypeCount[index].toString()}) ${totalEntryTypeAmount[index]}'),
                  children: [itemUI(data)],
                ),
              );
            })
        : itemUI(widget.list);
  }


  Widget itemUI(List list) {
    return Column(
      children: [
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: sliderValue, mainAxisExtent: 225),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            print('.....${list.length}........list of cash book   ${list[index]['CBDate'].toString()}');
            return  list[index]['CBDate'] != null  ?Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Container(
                  decoration: BoxDecoration(
                      color:
                          Provider.of<ThemeDataHomePage>(context, listen: false)
                              .backGroundColor,
                      border: Border.all(
                        color: Provider.of<ThemeDataHomePage>(context,
                                listen: false)
                            .borderTextAppBarColor,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: PopupMenuButton<int>(
                              padding: EdgeInsets.only(
                                  bottom: 8, right: 0, left: 15),
                              icon: Icon(
                                Icons.more_horiz,
                                size: 20,
                                color: Colors.brown.shade900,
                              ),
                              onSelected: (value) async {

                                print('......................edit................................');
                                if (value == 0) {
                                  List listOFDataLedgerFromCashBook =
                                      await _cashBookSQL
                                          .getDataForLedgerFromCashBook(
                                              list[index]['CashBookID']);



                                  List argumentList = [
                                    {"action": "EDIT"},
                                    listOFDataLedgerFromCashBook[0]
                                  ];

                                  await showGeneralDialog(
                                    context: context,
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        alignment: Alignment.center,
                                        child: Center(
                                            child: SizedBox(
                                                height: 410,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CashBook(
                                                      context: context,
                                                      list: argumentList,
                                                      menuName:
                                                          widget.menuName),
                                                ))),
                                      );
                                    },
                                  );
                                  setState(() {});
                                }

                                setState(() {});
                                if(widget.showStatus == 'modifiedRecord' || widget.showStatus == 'NewEntries' || widget.showStatus == 'ListView' ) {
                                  widget.setState!(() {});
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(value: 0, child: Text('Edit')),
                                  PopupMenuItem(
                                      value: 1, child: Text('Delete')),
                                ];
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                FittedBox(
                                  child: Text(
                                    "CB ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    list[index]['CashBookID'].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            FittedBox(
                              child: Text(
                                '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(list[index]['CBDate'].toString().substring(0, 4)), int.parse(list[index]['CBDate'].toString().substring(
                                      5,
                                      7,
                                    )), int.parse(list[index]['CBDate'].toString().substring(8, 10)))).toString()}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                list[index]['Amount'].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Debit',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700),
                                    )),
                                Icon(
                                  CupertinoIcons.add,
                                  color: Colors.green,
                                  size: 15,
                                )
                              ],
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.grey.shade700)),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: list[index]['DebitAccountName']
                                            .toString()
                                            .length >
                                        30
                                    ? GestureDetector(
                                        onTap: () {
                                          showGeneralDialog(
                                              context: context,
                                              pageBuilder: (context, animation,
                                                  Animation) {
                                                return Center(
                                                  child: AlertDialog(
                                                    content: Text(list[index][
                                                            'CreditAccountName']
                                                        .toString()),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('ok'))
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: Center(
                                            child: Text(
                                          list[index]['DebitAccountName']
                                              .toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                          maxLines: 2,
                                        )))
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          list[index]['DebitAccountName']
                                              .toString(),
                                          maxLines: 2,
                                        )),
                              ),
                            ),
                            // DebitAccountName

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Credit',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700),
                                        )),
                                    Icon(
                                      CupertinoIcons.minus,
                                      color: Colors.red,
                                      size: 15,
                                    )
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.grey.shade700)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: list[index]['CreditAccountName']
                                                .toString()
                                                .length >
                                            30
                                        ? GestureDetector(
                                            onTap: () {
                                              showGeneralDialog(
                                                  context: context,
                                                  pageBuilder: (context,
                                                      animation, Animation) {
                                                    return Center(
                                                      child: AlertDialog(
                                                        content: Text(list[
                                                                    index][
                                                                'CreditAccountName']
                                                            .toString()),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text('ok'))
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Text(
                                              list[index]['CreditAccountName']
                                                  .toString(),
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              maxLines: 2,
                                            ))
                                        : Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              list[index]['CreditAccountName']
                                                  .toString(),
                                              maxLines: 2,
                                            )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'RemarKs',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700),
                                )),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.grey.shade700)),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: list[index]['CBRemarks']
                                            .toString()
                                            .length >
                                        30
                                    ? GestureDetector(
                                        onTap: () {
                                          showGeneralDialog(
                                              context: context,
                                              pageBuilder: (context, animation,
                                                  Animation) {
                                                return Center(
                                                  child: AlertDialog(
                                                    content: Text(list[index]
                                                            ['CBRemarks']
                                                        .toString()),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('ok'))
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text(
                                          list[index]['CBRemarks'].toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                          maxLines: 1,
                                        ))
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          list[index]['CBRemarks'].toString(),
                                          maxLines: 1,
                                        )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )  :  SizedBox();
          },
        ),
        widget.ForSlip == null ?
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  setState(() {
                    if (sliderOpacity) {
                      opacity = 1;
                      sliderOpacity = false;
                    } else {
                      opacity = 0;
                      sliderOpacity = true;
                    }
                  });
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 12,
                )),
            Opacity(
              opacity: opacity,
              child: Slider(
                  value: sliderValue.toDouble(),
                  min: 1.0,
                  max: 4.0,
                  onChanged: (double value) {
                    setState(() {
                      sliderValue = value.toInt();
                      SharedPreferencesKeys.prefs!
                          .setInt('gridValue', sliderValue);
                    });
                  }),
            )
          ],
        ) : SizedBox()
      ],
    );
  }




  ///     Searching ////////////////////////////////
  void getSearchList(String value) async {
    originalList = await _cashBookSQL.getDefaultCashBookQueryData();
    List<Map<dynamic, dynamic>> tempList = [];

    for (Map<dynamic, dynamic> element in originalList) {
      if (element['CBRemarks']
          .toString()
          .toLowerCase()
          .contains(value.toLowerCase()) ||
          element['CreditAccountName']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['Amount']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['CashBookID']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['CBDate']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element['DebitAccountName']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())) {
        tempList.add(element);
      }
    }
    widget.list = tempList;
  }

  TextSpan searchMatch(String match, String searchText) {
    if (searchText == "") return TextSpan(text: match);
    var refinedMatch = match.toLowerCase();
    var refinedSearch = searchText.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: posRes,
          text: match.substring(0, refinedSearch.length),
          children: [
            searchMatch(
                match.substring(
                  refinedSearch.length,
                ),
                searchText),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: match, style: posRes);
      } else {
        return TextSpan(
          //style: negRes,
          text: match.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
                match.substring(
                  refinedMatch.indexOf(refinedSearch),
                ),
                searchText),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(
        text: match,
      );
    }
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      children: [
        searchMatch(
            match.substring(refinedMatch.indexOf(refinedSearch)), searchText)
      ],
    );
  }

}
