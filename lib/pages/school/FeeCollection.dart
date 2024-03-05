import 'package:com/pages/school/feerecslip.dart';
import 'package:com/pages/school/send_whatapp_student.dart';
import 'package:flutter/material.dart';
import 'package:com/pages/material/datepickerstyle1.dart';
import 'package:com/pages/school/FeeCollectionSQL.dart';
import 'package:com/pages/school/Sch7FeeRec2.dart';
import 'package:com/pages/school/SchoolSql.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../general_trading/CashBook/CashBookEntryDialogUI.dart';
import '../general_trading/CashBook/cashBookSql.dart';
import '../general_trading/SalePur/sale_pur1_SQL.dart';
import 'Sch1Branch.dart';
import 'Sch6StudentFeeDue.dart';
import 'StudentLedger.dart';

class FeeCollection extends StatefulWidget {
  final String menuName;
  final List? list;
  final String? status;

  const FeeCollection(
      {this.status, this.list, required this.menuName, Key? key})
      : super(key: key);

  @override
  State<FeeCollection> createState() => _FeeCollectionState();
}

class _FeeCollectionState extends State<FeeCollection> {
  TextEditingController _grnController = TextEditingController();
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController _narrationController = TextEditingController();
  FeeCollectionSQL _feeCollectionSql = FeeCollectionSQL();
  DateTime currentDate = DateTime.now();
  bool checkValue = false;
  String checkValueTitle = 'Monthly Fee';
  int groundTotalOfSelectedList = 0;
  List listOFFeeCollection = [];
  List listOFSelectedCollection = [];
  List<Color> listForColorCheck = [];
  FeeCollectionSQL _feeCollectionSQL = FeeCollectionSQL();
  StudentFeeRec studentFeeRec = StudentFeeRec();

  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  SchoolSQL _schoolSQL = SchoolSQL();
  String checkValueForGroupName = 'GRN';
  bool showSearchList = false;
  String btnText = 'Save';
  String checkEditAll = '';
  int feeRec1ID = 0;
  String checkValueForGRN = 'GRN';
  String checkValueForFamilyGroupNo = 'FamilyCode';
  String checkValueForMobileNo = 'MobileNO';
  String checkValueForStudentName = 'StudentName';
  String checkForShowExpenseAndRec = 'FeeRec';
  bool showTreeView = true;

  @override
  void initState() {
    super.initState();
    if (widget.status == 'RecBulk') {
      showSearchList = true;
      listOFFeeCollection = widget.list!;
      for (int i = 0; i < listOFFeeCollection.length; i++) {
        listForColorCheck.add(Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    groundTotalOfSelectedList = 0;
    for (int i = 0; i < listOFSelectedCollection.length; i++) {
      int value = listOFSelectedCollection[i]['TotalBalance']
                  .toString()
                  .length >
              0
          ? int.parse(listOFSelectedCollection[i]['TotalBalance'].toString())
          : 0;
      groundTotalOfSelectedList += value;
    }
    return Material(
        child: StatefulBuilder(
      builder: (context, state) => Container(
        color: Provider.of<ThemeDataHomePage>(context, listen: false)
            .backGroundColor,
        child: ListView(
          children: [
            listOFSelectedCollection.length > 0 || checkEditAll == 'EditALL'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            flex: 7,
                                            child: InkWell(
                                              onTap: () async {},
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0),
                                                child: Container(
                                                  height: 50,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(currentDate.toString().substring(0, 4)), int.parse(currentDate.toString().substring(
                                                                5,
                                                                7,
                                                              )), int.parse(currentDate.toString().substring(8, 10)))).toString()}',
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                              currentDate =
                                                                  await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return DatePickerStyle1();
                                                                      });
                                                              setState(() {});
                                                            },
                                                            icon: Icon(Icons
                                                                .calendar_month))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Flexible(
                                            flex: 3,
                                            child: FutureBuilder(
                                              future: _salePurSQLDataBase
                                                  .userRightsChecking(
                                                      widget.menuName),
                                              builder: (context,
                                                  AsyncSnapshot<List>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return ElevatedButton(
                                                      onPressed: () async {
                                                        if (btnText == 'Save') {
                                                          if (SharedPreferencesKeys
                                                                  .prefs!
                                                                  .getString(
                                                                      SharedPreferencesKeys
                                                                          .userRightsClient) ==
                                                              'Custom Right') {
                                                            if (snapshot
                                                                    .data![0][
                                                                        'Inserting']
                                                                    .toString() ==
                                                                'true') {
                                                              int feeRec1ID =
                                                                  await _feeCollectionSQL
                                                                      .maxIDRex1();

                                                              await _feeCollectionSQL.insertRec1(
                                                                  feeRecAmount:
                                                                      groundTotalOfSelectedList,
                                                                  feeRecDate:
                                                                      currentDate
                                                                          .toString(),
                                                                  feeRecRemarks:
                                                                      _narrationController
                                                                          .text
                                                                          .toString());

                                                              for (int count =
                                                                      0;
                                                                  count <
                                                                      listOFSelectedCollection
                                                                          .length;
                                                                  count++) {
                                                                await _feeCollectionSQL.insertRec2(
                                                                    feeRec1id:
                                                                        feeRec1ID,
                                                                    feeRecAmount:
                                                                        listOFSelectedCollection[count]
                                                                            [
                                                                            'TotalBalance'],
                                                                    feeRecDate:
                                                                        currentDate
                                                                            .toString(),
                                                                    feeRecRemarks:
                                                                        _narrationController
                                                                            .text
                                                                            .toString(),
                                                                    feeDueID: listOFSelectedCollection[
                                                                            count]
                                                                        [
                                                                        'FeeDueID']);
                                                              }

                                                              setState(() {});

                                                              await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Center(
                                                                      child:
                                                                          Container(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            .35,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            .8,
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Text('Rec ID : '),
                                                                                      Text(
                                                                                        '${feeRec1ID.toString()}',
                                                                                        style: TextStyle(color: Colors.grey),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text('Total Rec : '),
                                                                                      Text(
                                                                                        '${groundTotalOfSelectedList.toString()}',
                                                                                        style: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Date :'),
                                                                                  Text(
                                                                                    '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(currentDate.toString().substring(0, 4)), int.parse(currentDate.toString().substring(
                                                                                          5,
                                                                                          7,
                                                                                        )), int.parse(currentDate.toString().substring(8, 10)))).toString()}',
                                                                                    style: TextStyle(color: Colors.grey),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Fee Remarks :  '),
                                                                                  Text(
                                                                                    '${_narrationController.text.toString()}',
                                                                                    style: TextStyle(color: Colors.grey),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Total Selected : '),
                                                                                  Text(
                                                                                    '${listOFSelectedCollection.length}',
                                                                                    style: TextStyle(color: Colors.grey),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Align(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    ElevatedButton(
                                                                                        onPressed: () async {
                                                                                          List list = await _feeCollectionSQL.selectPhoneNumberOFStudent(feeRec1ID.toString());

                                                                                          feeRecPrint(context: context, slipInfoOfREc: list);
                                                                                        },
                                                                                        child: Text('Print')),
                                                                                    //  FatherMobileNo  MotherMobileNo

                                                                                    ElevatedButton(
                                                                                        onPressed: () async {


                                                                                          numberSendToWhatsApp(
                                                                                            feeRec1ID
                                                                                                .toString(), context, );
                                                                                        },
                                                                                        child: Text('WhatsApp')),
                                                                                    ElevatedButton(
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            listOFFeeCollection = [];
                                                                                            listOFSelectedCollection.clear();
                                                                                            listForColorCheck.clear();
                                                                                          });
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text('back')),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });

                                                              setState(() {
                                                                // listOFSelectedCollection
                                                                //     .clear();
                                                                // listOFFeeCollection.clear();
                                                                // listForColorCheck.clear();
                                                                // _grnController.clear();
                                                              });
                                                            }
                                                          } else if (SharedPreferencesKeys
                                                                  .prefs!
                                                                  .getString(
                                                                      SharedPreferencesKeys
                                                                          .userRightsClient) ==
                                                              'Admin') {
                                                            int feeRec1ID =
                                                                await _feeCollectionSQL
                                                                    .maxIDRex1();

                                                            await _feeCollectionSQL.insertRec1(
                                                                feeRecAmount:
                                                                    groundTotalOfSelectedList,
                                                                feeRecDate:
                                                                    currentDate
                                                                        .toString(),
                                                                feeRecRemarks:
                                                                    _narrationController
                                                                        .text
                                                                        .toString());

                                                            for (int count = 0;
                                                                count <
                                                                    listOFSelectedCollection
                                                                        .length;
                                                                count++) {
                                                              await _feeCollectionSQL.insertRec2(
                                                                  feeRec1id:
                                                                      feeRec1ID,
                                                                  feeRecAmount:
                                                                      listOFSelectedCollection[count]
                                                                          [
                                                                          'TotalBalance'],
                                                                  feeRecDate:
                                                                      currentDate
                                                                          .toString(),
                                                                  feeRecRemarks:
                                                                      _narrationController
                                                                          .text
                                                                          .toString(),
                                                                  feeDueID: listOFSelectedCollection[
                                                                          count]
                                                                      [
                                                                      'FeeDueID']);
                                                            }

                                                            setState(() {});

                                                            await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Center(
                                                                    child:
                                                                        Container(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          .35,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          .8,
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text('Rec ID : '),
                                                                                    Text(
                                                                                      '${feeRec1ID.toString()}',
                                                                                      style: TextStyle(color: Colors.grey),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text('Total Rec : '),
                                                                                    Text(
                                                                                      '${groundTotalOfSelectedList.toString()}',
                                                                                      style: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text('Date :'),
                                                                                Text(
                                                                                  '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(currentDate.toString().substring(0, 4)), int.parse(currentDate.toString().substring(
                                                                                        5,
                                                                                        7,
                                                                                      )), int.parse(currentDate.toString().substring(8, 10)))).toString()}',
                                                                                  style: TextStyle(color: Colors.grey),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text('Fee Remarks :  '),
                                                                                Text(
                                                                                  '${_narrationController.text.toString()}',
                                                                                  style: TextStyle(color: Colors.grey),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text('Total Selected : '),
                                                                                Text(
                                                                                  '${listOFSelectedCollection.length}',
                                                                                  style: TextStyle(color: Colors.grey),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.bottomCenter,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  ElevatedButton(
                                                                                      onPressed: () async {
                                                                                        List list = await _feeCollectionSQL.selectPhoneNumberOFStudent(feeRec1ID.toString());

                                                                                        feeRecPrint(context: context, slipInfoOfREc: list);
                                                                                      },
                                                                                      child: Text('Print')),
                                                                                  //  FatherMobileNo  MotherMobileNo

                                                                                  ElevatedButton(
                                                                                      onPressed: () async {
                                                                                        numberSendToWhatsApp(
                                                                                          feeRec1ID
                                                                                              .toString(), context, );
                                                                                      },
                                                                                      child: Text('WhatsApp')),
                                                                                  ElevatedButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          listOFFeeCollection = [];
                                                                                          listOFSelectedCollection.clear();
                                                                                          listForColorCheck.clear();
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text('back')),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                });

                                                            setState(() {
                                                              // listOFSelectedCollection
                                                              //     .clear();
                                                              // listOFFeeCollection.clear();
                                                              // listForColorCheck.clear();
                                                              // _grnController.clear();
                                                            });
                                                          }
                                                        } else {
                                                          if (feeRec1ID < 0) {
                                                            await _feeCollectionSql.updateStudent7FeeRec1(
                                                                id: feeRec1ID,
                                                                recDate: currentDate
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10),
                                                                recRemarks:
                                                                    _narrationController
                                                                        .text
                                                                        .toString());
                                                          } else if (SharedPreferencesKeys
                                                                  .prefs!
                                                                  .getString(
                                                                      SharedPreferencesKeys
                                                                          .userRightsClient) ==
                                                              'Custom Right') {
                                                            if (snapshot
                                                                    .data![0][
                                                                        'Editing']
                                                                    .toString() ==
                                                                'true') {
                                                              await _feeCollectionSql.updateStudent7FeeRec1(
                                                                  id: feeRec1ID,
                                                                  recDate: currentDate
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                                  recRemarks:
                                                                      _narrationController
                                                                          .text
                                                                          .toString());
                                                            }
                                                          } else if (SharedPreferencesKeys
                                                                  .prefs!
                                                                  .getString(
                                                                      SharedPreferencesKeys
                                                                          .userRightsClient) ==
                                                              'Admin') {
                                                            await _feeCollectionSql.updateStudent7FeeRec1(
                                                                id: feeRec1ID,
                                                                recDate: currentDate
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10),
                                                                recRemarks:
                                                                    _narrationController
                                                                        .text
                                                                        .toString());
                                                          }

                                                          setState(() {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('Update Successful')));
                                                            checkEditAll = '';
                                                          });
                                                          await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Center(
                                                                  child:
                                                                      Container(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        .35,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .8,
                                                                    color: Colors
                                                                        .white,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text('Rec ID : '),
                                                                                  Text(
                                                                                    '${feeRec1ID.toString()}',
                                                                                    style: TextStyle(color: Colors.grey),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Total Rec : '),
                                                                                  Text(
                                                                                    '${groundTotalOfSelectedList.toString()}',
                                                                                    style: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text('Date :'),
                                                                              Text(
                                                                                '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(currentDate.toString().substring(0, 4)), int.parse(currentDate.toString().substring(
                                                                                      5,
                                                                                      7,
                                                                                    )), int.parse(currentDate.toString().substring(8, 10)))).toString()}',
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text('Fee Remarks :  '),
                                                                              Text(
                                                                                '${_narrationController.text.toString()}',
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text('Total Selected : '),
                                                                              Text(
                                                                                '${listOFSelectedCollection.length}',
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      List list = await _feeCollectionSQL.selectPhoneNumberOFStudent(feeRec1ID.toString());

                                                                                      feeRecPrint(context: context, slipInfoOfREc: list);
                                                                                    },
                                                                                    child: Text('Print')),
                                                                                //  FatherMobileNo  MotherMobileNo

                                                                                ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      numberSendToWhatsApp(
                                                                                        feeRec1ID
                                                                                            .toString(), context, );
                                                                                    },
                                                                                    child: Text('WhatsApp')),
                                                                                ElevatedButton(
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        listOFFeeCollection = [];
                                                                                        listOFSelectedCollection.clear();
                                                                                        listForColorCheck.clear();
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text('back')),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        }
                                                      },
                                                      child: Text(btnText));
                                                } else {
                                                  return SizedBox();
                                                }
                                              },
                                            ))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 7,
                                          child: SizedBox(
                                            height: 50,
                                            child: TextField(
                                              controller: _narrationController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: Text('Fee Remarks'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 3,
                                            child: Text(
                                              groundTotalOfSelectedList
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: listOFSelectedCollection.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${listOFSelectedCollection[index]['GRN']} , ',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              Text(
                                                listOFSelectedCollection[index]
                                                    ['FamilyGroupNo'],
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: popUpButtonForItemEdit(
                                                  onSelected: (value) async {
                                                if (value == 0) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        _totalAmountController
                                                            .clear();
                                                        return Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Material(
                                                            child: SizedBox(
                                                              height: 140,
                                                              width: 300,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Center(
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 8.0),
                                                                        child:
                                                                            TextField(
                                                                          controller:
                                                                              _totalAmountController,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            label:
                                                                                Text('Total Amount'),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 25.0),
                                                                            child: TextButton(
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    listOFSelectedCollection[index]['TotalBalance'] = _totalAmountController.text.toString();
                                                                                  });

                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text(
                                                                                  'ok',
                                                                                  style: TextStyle(fontSize: 20),
                                                                                )),
                                                                          ),
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text('Cancel')),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              '${listOFSelectedCollection[index]['FahterName'].toString()} , '),
                                          Text(listOFSelectedCollection[index]
                                                  ['StudentName']
                                              .toString()),
                                          //Text(listOFFeeCollection[index]['FeeNarration']),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${listOFSelectedCollection[index]['FeeNarration'].toString()} '),
                                          Row(
                                            children: [
                                              Text(
                                                  listOFSelectedCollection[
                                                                  index][
                                                              'TotalReceived'] ==
                                                          0
                                                      ? ''
                                                      : '${listOFSelectedCollection[index]['TotalReceived'].toString()} ',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  )),
                                              Text(
                                                listOFSelectedCollection[index]
                                                        ['TotalBalance']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  '${listOFSelectedCollection[index]['SectionName'].toString()} , '),
                                              Text(
                                                  '${listOFSelectedCollection[index]['ClassName'].toString()} , '),
                                              Text(
                                                  '${listOFSelectedCollection[index]['EducationalYear'].toString()} , '),
                                              Text(listOFSelectedCollection[
                                                      index]['BranchName']
                                                  .toString()),
                                            ],
                                          ),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  for (int i = 0;
                                                      i <
                                                          listOFFeeCollection
                                                              .length;
                                                      i++) {
                                                    if (listOFFeeCollection[i]
                                                            ['GRN'] ==
                                                        listOFSelectedCollection[
                                                            index]['GRN']) {
                                                      listForColorCheck[i] =
                                                          Colors.white;
                                                    }
                                                  }

                                                  listOFSelectedCollection
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                size: 20,
                                                color: Colors.grey,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Radio<String>(
                          activeColor: Provider.of<ThemeDataHomePage>(context,
                                  listen: false)
                              .borderTextAppBarColor,
                          groupValue: checkValueForGroupName,
                          value: checkValueForGRN,
                          onChanged: (value) {
                            setState(() {
                              checkValueForGroupName = value!;
                            });
                          }),
                      Text('GRN')
                    ],
                  ),
                  Column(
                    children: [
                      Radio<String>(
                          activeColor: Provider.of<ThemeDataHomePage>(context,
                                  listen: false)
                              .borderTextAppBarColor,
                          groupValue: checkValueForGroupName,
                          value: checkValueForFamilyGroupNo,
                          onChanged: (value) {
                            setState(() {
                              checkValueForGroupName = value!;
                            });
                          }),
                      FittedBox(child: Text('Family Code'))
                    ],
                  ),
                  Column(
                    children: [
                      Radio<String>(
                          activeColor: Provider.of<ThemeDataHomePage>(context,
                                  listen: false)
                              .borderTextAppBarColor,
                          groupValue: checkValueForGroupName,
                          value: checkValueForMobileNo,
                          onChanged: (value) {
                            setState(() {
                              checkValueForGroupName = value!;
                            });
                          }),
                      FittedBox(child: Text('Mobile NO'))
                    ],
                  ),
                  Column(
                    children: [
                      Radio<String>(
                          activeColor: Provider.of<ThemeDataHomePage>(context,
                                  listen: false)
                              .borderTextAppBarColor,
                          groupValue: checkValueForGroupName,
                          value: checkValueForStudentName,
                          onChanged: (value) {
                            setState(() {
                              checkValueForGroupName = value!;
                            });
                          }),
                      FittedBox(child: Text('Student Name'))
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _grnController,
                      onTap: () {
                        setState(() {
                          showTreeView = false;
                        });
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(),
                        border: OutlineInputBorder(),
                        label: Text(
                          'Search by $checkValueForGroupName',
                          style: TextStyle(color: Colors.black),
                        ),
                        suffix: InkWell(
                            onTap: () async {
                              // listForColorCheck.clear();
                              // if (checkValueForGroupName == checkValueForGRN) {
                              //   listOFFeeCollection = await _feeCollectionSQL
                              //       .dataForAllStudentForNEWBYGRNANDFamilyGroupNo(
                              //           _grnController.text.toString().trim(),
                              //           'Sch6StudentFeeDue.GRN');
                              // }
                              // if (checkValueForGroupName ==
                              //     checkValueForFamilyGroupNo) {
                              //   listOFFeeCollection = await _feeCollectionSQL
                              //       .dataForAllStudentForNEWBYGRNANDFamilyGroupNo(
                              //           _grnController.text.toString().trim(),
                              //           'Sch9StudentsInfo.FamilyGroupNo');
                              // }
                              // if (checkValueForGroupName ==
                              //     checkValueForMobileNo) {
                              //   listOFFeeCollection = await _feeCollectionSQL
                              //       .dataForAllStudentForNEWBYMobileNumber(
                              //           _grnController.text.toString().trim());
                              // }
                              //
                              // if (checkValueForGroupName ==
                              //     checkValueForStudentName) {
                              //   listOFFeeCollection = await _feeCollectionSQL
                              //       .dataForAllStudentForNEWBYStudentName(
                              //           _grnController.text.toString().trim());
                              // }
                              //
                              // for (int i = 0;
                              //     i < listOFFeeCollection.length;
                              //     i++) {
                              //   listForColorCheck.add(Colors.white);
                              // }
                              //
                              // setState(() {});
                            },
                            child: Icon(Icons.search)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            showSearchList ? listOFFeeCollection.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listOFFeeCollection.length,
                    itemBuilder: (context, index) =>
                        Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (listForColorCheck[index] ==
                                Colors.blue.shade100) {
                              for (int i = 0;
                                  i < listOFSelectedCollection.length;
                                  i++) {
                                if (listOFSelectedCollection[i]['GRN'] ==
                                    listOFFeeCollection[index]['GRN']) {
                                  listOFSelectedCollection.removeAt(i);
                                }
                              }
                              listForColorCheck[index] = Colors.white;
                            } else {
                              listForColorCheck[index] = Colors.blue.shade100;

                              var recStudentFee = ModelFeeRec2.fromMap(
                                  listOFFeeCollection[index]);
                              listOFSelectedCollection
                                  .add(recStudentFee.toMap());
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: listForColorCheck[index],
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${listOFFeeCollection[index]['GRN']} , ',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        Text(
                                          listOFFeeCollection[index]
                                                  ['FamilyGroupNo']
                                              .toString(),
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        '${listOFFeeCollection[index]['FahterName'].toString()} , '),
                                    Text(listOFFeeCollection[index]
                                            ['StudentName']
                                        .toString()),
                                    //Text(listOFFeeCollection[index]['FeeNarration']),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${listOFFeeCollection[index]['FeeNarration'].toString()} '),
                                    Row(
                                      children: [
                                        Text(
                                            listOFFeeCollection[index]
                                                        ['TotalReceived'] ==
                                                    0
                                                ? ''
                                                : '${listOFFeeCollection[index]['TotalReceived'].toString()} ',
                                            style: TextStyle(
                                              color: Colors.green,
                                            )),
                                        Text(
                                          listOFFeeCollection[index]
                                                  ['TotalBalance']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        '${listOFFeeCollection[index]['SectionName'].toString()} , '),
                                    Text(
                                        '${listOFFeeCollection[index]['ClassName'].toString()} , '),
                                    Text(
                                        '${listOFFeeCollection[index]['EducationalYear'].toString()} , '),
                                    Text(listOFFeeCollection[index]
                                            ['BranchName']
                                        .toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ) :Center(
                child: Text(
                  'No Data Found',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                )) :  SizedBox(),


            _grnController.text.isEmpty
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            List studentLedgerList =
                                await _schoolSQL.dataForAllStudentLedgerFeeDue(
                                    _grnController.text.toString().trim());

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentLedger(
                                    list: studentLedgerList,
                                  ),
                                ));
                          },
                          child: Text('Student GL')),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              listForColorCheck.clear();
                              if (checkValueForGroupName == checkValueForGRN) {
                                listOFFeeCollection = await _feeCollectionSQL
                                    .dataForAllStudentForNEWBYGRNANDFamilyGroupNo(
                                        _grnController.text.toString().trim(),
                                        'Sch6StudentFeeDue.GRN');
                              }
                              if (checkValueForGroupName ==
                                  checkValueForFamilyGroupNo) {
                                listOFFeeCollection = await _feeCollectionSQL
                                    .dataForAllStudentForNEWBYGRNANDFamilyGroupNo(
                                        _grnController.text.toString().trim(),
                                        'Sch9StudentsInfo.FamilyGroupNo');
                              }
                              if (checkValueForGroupName ==
                                  checkValueForMobileNo) {
                                listOFFeeCollection = await _feeCollectionSQL
                                    .dataForAllStudentForNEWBYMobileNumber(
                                        _grnController.text.toString().trim());
                              }

                              if (checkValueForGroupName ==
                                  checkValueForStudentName) {
                                listOFFeeCollection = await _feeCollectionSQL
                                    .dataForAllStudentForNEWBYStudentName(
                                        _grnController.text.toString().trim());
                              }

                              for (int i = 0;
                                  i < listOFFeeCollection.length;
                                  i++) {
                                listForColorCheck.add(Colors.white);
                              }

                              showSearchList = true;

                              setState(() {});
                            },
                            child: Text('Fee Collect')),
                      ),
                    ],
                  ),

            /// Ui Date ForMate /  tree type////////////////////////////////////////////////

            showTreeView
                ? FutureBuilder(
                    future: _feeCollectionSQL.dataForYearTotal(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshotOFYear) {
                      if (snapshotOFYear.hasData) {
                        return Container(
                          color: Colors.white,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshotOFYear.data!.length,
                              itemBuilder: (context, index) {
                                return ExpansionTile(
                                  backgroundColor: Colors.white,
                                  collapsedBackgroundColor: Colors.white,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(snapshotOFYear.data![index]['Year']
                                          .toString()),
                                      Text(
                                        NumberFormat("###,###", "en_US")
                                            .format(snapshotOFYear.data![index]
                                                ['TotalBalance'])
                                            .toString()
                                            .toString(),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${NumberFormat("###,###", "en_US").format(snapshotOFYear.data![index]['TotalDue']).toString()}  -  ',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      Text(
                                        '${NumberFormat("###,###", "en_US").format(snapshotOFYear.data![index]['TotalReceived']).toString()}  -  ',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      Text(
                                        NumberFormat("###,###", "en_US")
                                            .format(snapshotOFYear.data![index]
                                                ['TotalExpense'])
                                            .toString()
                                            .toString(),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    FutureBuilder(
                                      future: _feeCollectionSQL
                                          .dataForMonthTotal(snapshotOFYear
                                              .data![index]['Year']
                                              .toString()),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<dynamic>>
                                              snapshotOFMonth) {
                                        if (snapshotOFMonth.hasData) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: snapshotOFMonth
                                                    .data!.length,
                                                itemBuilder:
                                                    (context, indexOFMonth) {
                                                  return ExpansionTile(
                                                    backgroundColor:
                                                        Colors.white,
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            '    ${snapshotOFMonth.data![indexOFMonth]['Month'].toString()}'),
                                                        Text(
                                                          NumberFormat(
                                                                  "###,###",
                                                                  "en_US")
                                                              .format(snapshotOFMonth
                                                                          .data![
                                                                      indexOFMonth]
                                                                  [
                                                                  'TotalBalance'])
                                                              .toString()
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                    subtitle: Row(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          '    ${NumberFormat("###,###", "en_US").format(snapshotOFMonth.data![indexOFMonth]['TotalDue']).toString()}  -  ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        Text(
                                                          '${NumberFormat("###,###", "en_US").format(snapshotOFMonth.data![indexOFMonth]['TotalReceived']).toString()}  -  ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        Text(
                                                          NumberFormat(
                                                                  "###,###",
                                                                  "en_US")
                                                              .format(snapshotOFMonth
                                                                          .data![
                                                                      indexOFMonth]
                                                                  [
                                                                  'TotalExpense'])
                                                              .toString()
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ],
                                                    ),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 32.0),
                                                        child: FutureBuilder(
                                                          future: _feeCollectionSQL
                                                              .dataForDayTotal(
                                                                  snapshotOFYear
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          'Year']
                                                                      .toString(),
                                                                  snapshotOFMonth
                                                                      .data![
                                                                          indexOFMonth]
                                                                          [
                                                                          'Month']
                                                                      .toString()),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      List<
                                                                          dynamic>>
                                                                  snapshotOFDay) {
                                                            if (snapshotOFDay
                                                                .hasData) {
                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black)),
                                                                child: ListView
                                                                    .builder(
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: snapshotOFDay
                                                                            .data!
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                indexOFDAy) {
                                                                          return ExpansionTile(
                                                                            title:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text('        ${snapshotOFDay.data![indexOFDAy]['Day'].toString()}'),
                                                                                Text(
                                                                                  NumberFormat("###,###", "en_US").format(snapshotOFDay.data![indexOFDAy]['TotalBalance']).toString().toString(),
                                                                                  style: TextStyle(color: Colors.grey),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            subtitle:
                                                                                Row(
                                                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      checkForShowExpenseAndRec = 'TotalDue';
                                                                                    });
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 32.0),
                                                                                    child: Text(
                                                                                      '${NumberFormat("###,###", "en_US").format(snapshotOFDay.data![indexOFDAy]['TotalDue']).toString()}  -  ',
                                                                                      style: TextStyle(
                                                                                        color: Colors.blue,
                                                                                        fontWeight: checkForShowExpenseAndRec == 'TotalDue' ? FontWeight.bold : FontWeight.normal,
                                                                                        decoration: checkForShowExpenseAndRec == 'TotalDue' ? TextDecoration.underline : TextDecoration.none,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      checkForShowExpenseAndRec = 'FeeRec';
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    '${NumberFormat("###,###", "en_US").format(snapshotOFDay.data![indexOFDAy]['TotalReceived']).toString()}  -  ',
                                                                                    style: TextStyle(
                                                                                      color: Colors.green,
                                                                                      fontWeight: checkForShowExpenseAndRec == 'FeeRec' ? FontWeight.bold : FontWeight.normal,
                                                                                      decoration: checkForShowExpenseAndRec == 'FeeRec' ? TextDecoration.underline : TextDecoration.none,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      checkForShowExpenseAndRec = 'Expense';
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    NumberFormat("###,###", "en_US").format(snapshotOFDay.data![indexOFDAy]['TotalExpense']).toString().toString(),
                                                                                    style: TextStyle(
                                                                                      color: Colors.red,
                                                                                      fontWeight: checkForShowExpenseAndRec == 'Expense' ? FontWeight.bold : FontWeight.normal,
                                                                                      decoration: checkForShowExpenseAndRec == 'Expense' ? TextDecoration.underline : TextDecoration.none,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            children: [
                                                                              checkForShowExpenseAndRec == 'FeeRec'
                                                                                  ? Column(
                                                                                      children: [
                                                                                        Align(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 8.0),
                                                                                              child: Text(
                                                                                                'Fee Receive :',
                                                                                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 17),
                                                                                              ),
                                                                                            )),
                                                                                        FutureBuilder(
                                                                                          future: _schoolSQL.dataForFeeRECCompleteDetailsByID(snapshotOFDay.data![indexOFDAy]['Date'], 'Sch7FeeRec1.FeeRecDate'),
                                                                                          builder: (context, AsyncSnapshot<List> snapshotOFData) {
                                                                                            if (snapshotOFData.hasData) {
                                                                                              return uIListViewFeeDetails(snapshotOFData.data!, widget.menuName, state);
                                                                                            } else {
                                                                                              return CircularProgressIndicator();
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : checkForShowExpenseAndRec == 'Expense'
                                                                                      ? Column(
                                                                                          children: [
                                                                                            Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(left: 8.0),
                                                                                                  child: Text(
                                                                                                    'Expense :',
                                                                                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 17),
                                                                                                  ),
                                                                                                )),
                                                                                            FutureBuilder(
                                                                                              future: _schoolSQL.dataForAllExpense(snapshotOFDay.data![indexOFDAy]['Date'].toString()),
                                                                                              builder: (context, AsyncSnapshot<List> snapshotOFExpenses) {
                                                                                                if (snapshotOFExpenses.hasData) {
                                                                                                  return uIListViewFeeExpanseDetails(snapshotOFExpenses.data!, widget.menuName, state);
                                                                                                } else {
                                                                                                  return CircularProgressIndicator();
                                                                                                }
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : Column(
                                                                                          children: [
                                                                                            Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(left: 8.0),
                                                                                                  child: Text(
                                                                                                    'Total Due :',
                                                                                                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 17),
                                                                                                  ),
                                                                                                )),
                                                                                            FutureBuilder(
                                                                                              future: _schoolSQL.dataForTotalDue(snapshotOFDay.data![indexOFDAy]['Date'].toString()),
                                                                                              builder: (context, AsyncSnapshot<List> snapshotOFDue) {
                                                                                                if (snapshotOFDue.hasData) {
                                                                                                  return uIListViewTotalDue(snapshotOFDue.data!, widget.menuName, state);
                                                                                                } else {
                                                                                                  return CircularProgressIndicator();
                                                                                                }
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                            ],
                                                                          );
                                                                        }),
                                                              );
                                                            } else {
                                                              return CircularProgressIndicator();
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }),
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    )
                                  ],
                                );
                              }),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                : SizedBox()
          ],
        ),
      ),
    ));
  }

  Widget uIListViewTotalDue(List list, String menuName, var setState) {
    TextEditingController dueOnDateController = TextEditingController();
    TextEditingController feeNarrationController = TextEditingController();
    TextEditingController feeAmountController = TextEditingController();
    StudentFeeDue studentFeeDue = StudentFeeDue();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          list[index]['DueDate'] != null
                              ? Text(
                                  '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(list[index]['DueDate'].toString().substring(0, 4)), int.parse(list[index]['DueDate'].toString().substring(
                                        5,
                                        7,
                                      )), int.parse(list[index]['DueDate'].toString().substring(8, 10)))).toString()} ',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              : SizedBox(),
                          Text(' (${list[index]['FeeDueID'].toString()}) '),
                          Text('${list[index]['FeeNarration'].toString()}'),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FutureBuilder(
                            future: _salePurSQLDataBase
                                .userRightsChecking(menuName),
                            builder: (context, AsyncSnapshot<List> snapshot) {
                              if (snapshot.hasData) {
                                return popUpButtonForItemEditForExpanse(
                                    onSelected: (value) async {
                                  if (value == 0) {
                                    if (list[index]['FeeDueID'] < 0) {
                                      await showGeneralDialog(
                                          context: context,
                                          pageBuilder: (BuildContext context,
                                              animation, secondaryAnimation) {
                                            dueOnDateController.text =
                                                currentDate
                                                    .toString()
                                                    .substring(0, 10);
                                            feeNarrationController.text =
                                                list[index]['FeeNarration']
                                                    .toString();
                                            feeAmountController.text =
                                                list[index]['FeeDueAmount']
                                                    .toString();
                                            checkValue = true;
                                            return Align(
                                                alignment: Alignment.center,
                                                child: AnimatedContainer(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  child: bulkFeeAllStudentYear(
                                                      OpenForEditOrSave: 'Edit',
                                                      dialogTitle:
                                                          'Due Fee on Student Edit',
                                                      maxID: list[index]
                                                          ['FeeDueID'],
                                                      stateName:
                                                          '${list[index]['GRN']} ${list[index]['StudentName'].toString()}',
                                                      dueOnDate:
                                                          dueOnDateController,
                                                      feeNarration:
                                                          feeNarrationController,
                                                      feeAmount:
                                                          feeAmountController,
                                                      onPressed: () async {
                                                        await studentFeeDue.updateStudentFeeDue(
                                                            GRN: list[index]
                                                                ['GRN'],
                                                            DueDate: currentDate
                                                                .toString()
                                                                .substring(
                                                                    0, 10),
                                                            FeeDueAmount:
                                                                feeAmountController
                                                                    .text
                                                                    .toString(),
                                                            FeeNarration:
                                                                feeNarrationController
                                                                    .text
                                                                    .toString(),
                                                            id: list[index]
                                                                ['ID']);
                                                        feeNarrationController
                                                            .clear();
                                                        feeAmountController
                                                            .clear();
                                                        dueOnDateController
                                                            .clear();

                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      context: context),
                                                ));
                                          });
                                    } else {
                                      List userRightList =
                                          await _salePurSQLDataBase
                                              .userRightsChecking(
                                                  widget.menuName);
                                      if (SharedPreferencesKeys.prefs!
                                              .getString(SharedPreferencesKeys
                                                  .userRightsClient) ==
                                          'Custom Right') {
                                        if (userRightList[0]['Editing']
                                                .toString() ==
                                            'true') {
                                          await showGeneralDialog(
                                              context: context,
                                              pageBuilder:
                                                  (BuildContext context,
                                                      animation,
                                                      secondaryAnimation) {
                                                dueOnDateController.text =
                                                    currentDate
                                                        .toString()
                                                        .substring(0, 10);
                                                feeNarrationController.text =
                                                    list[index]['FeeNarration']
                                                        .toString();
                                                feeAmountController.text =
                                                    list[index]['FeeDueAmount']
                                                        .toString();
                                                checkValue = true;
                                                return Align(
                                                    alignment: Alignment.center,
                                                    child: AnimatedContainer(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      child:
                                                          bulkFeeAllStudentYear(
                                                              OpenForEditOrSave:
                                                                  'Edit',
                                                              dialogTitle:
                                                                  'Due Fee on Student Edit',
                                                              maxID: list[index]
                                                                  ['FeeDueID'],
                                                              stateName:
                                                                  '${list[index]['GRN']} ${list[index]['StudentName'].toString()}',
                                                              dueOnDate:
                                                                  dueOnDateController,
                                                              feeNarration:
                                                                  feeNarrationController,
                                                              feeAmount:
                                                                  feeAmountController,
                                                              onPressed:
                                                                  () async {
                                                                await studentFeeDue.updateStudentFeeDue(
                                                                    GRN: list[
                                                                            index]
                                                                        ['GRN'],
                                                                    DueDate: currentDate
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10),
                                                                    FeeDueAmount:
                                                                        feeAmountController
                                                                            .text
                                                                            .toString(),
                                                                    FeeNarration:
                                                                        feeNarrationController
                                                                            .text
                                                                            .toString(),
                                                                    id: list[
                                                                            index]
                                                                        ['ID']);
                                                                feeNarrationController
                                                                    .clear();
                                                                feeAmountController
                                                                    .clear();
                                                                dueOnDateController
                                                                    .clear();

                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              context: context),
                                                    ));
                                              });
                                        }
                                      } else if (SharedPreferencesKeys.prefs!
                                              .getString(SharedPreferencesKeys
                                                  .userRightsClient) ==
                                          'Admin') {
                                        await showGeneralDialog(
                                            context: context,
                                            pageBuilder: (BuildContext context,
                                                animation, secondaryAnimation) {
                                              dueOnDateController.text =
                                                  currentDate
                                                      .toString()
                                                      .substring(0, 10);
                                              feeNarrationController.text =
                                                  list[index]['FeeNarration']
                                                      .toString();
                                              feeAmountController.text =
                                                  list[index]['FeeDueAmount']
                                                      .toString();
                                              checkValue = true;
                                              return SafeArea(
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: AnimatedContainer(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      child:
                                                          bulkFeeAllStudentYear(
                                                              OpenForEditOrSave:
                                                                  'Edit',
                                                              dialogTitle:
                                                                  'Due Fee on Student Edit',
                                                              maxID: list[index]
                                                                  ['FeeDueID'],
                                                              stateName:
                                                                  '${list[index]['GRN']} ${list[index]['StudentName'].toString()}',
                                                              dueOnDate:
                                                                  dueOnDateController,
                                                              feeNarration:
                                                                  feeNarrationController,
                                                              feeAmount:
                                                                  feeAmountController,
                                                              onPressed:
                                                                  () async {
                                                                await studentFeeDue.updateStudentFeeDue(
                                                                    GRN: list[
                                                                            index]
                                                                        ['GRN'],
                                                                    DueDate: currentDate
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10),
                                                                    FeeDueAmount:
                                                                        feeAmountController
                                                                            .text
                                                                            .toString(),
                                                                    FeeNarration:
                                                                        feeNarrationController
                                                                            .text
                                                                            .toString(),
                                                                    id: list[
                                                                            index]
                                                                        ['ID']);
                                                                feeNarrationController
                                                                    .clear();
                                                                feeAmountController
                                                                    .clear();
                                                                dueOnDateController
                                                                    .clear();

                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              context: context),
                                                    )),
                                              );
                                            });
                                      }
                                    }
                                  }
                                });
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${list[index]['StudentName'].toString()}'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          '${list[index]['FeeDueAmount'].toString()}',
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget uIListViewFeeExpanseDetails(List list, String menuName, var setState) {
    CashBookSQL _cashBookSQL = CashBookSQL();
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          list[index]['CBDate'] != null
                              ? Text(
                                  '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(list[index]['CBDate'].toString().substring(0, 4)), int.parse(list[index]['CBDate'].toString().substring(
                                        5,
                                        7,
                                      )), int.parse(list[index]['CBDate'].toString().substring(8, 10)))).toString()} ',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              : SizedBox(),
                          Text(' (${list[index]['CashBookID'].toString()}) '),
                          Text('${list[index]['DebitAccountName'].toString()}'),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FutureBuilder(
                            future: _salePurSQLDataBase
                                .userRightsChecking(menuName),
                            builder: (context, AsyncSnapshot<List> snapshot) {
                              if (snapshot.hasData) {
                                return popUpButtonForItemEditForExpanse(
                                    onSelected: (value) async {
                                  if (value == 0) {
                                    if (list[index]['CashBookID'] < 0) {
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
                                                    height: 410,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                    } else if (SharedPreferencesKeys.prefs!
                                            .getString(SharedPreferencesKeys
                                                .userRightsClient) ==
                                        'Custom Right') {
                                      if (snapshot.data![0]['Inserting']
                                              .toString() ==
                                          'true') {
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
                                                      height: 410,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CashBook(
                                                            context: context,
                                                            list: argumentList,
                                                            menuName: widget
                                                                .menuName),
                                                      ))),
                                            );
                                          },
                                        );
                                        setState(() {});
                                      }
                                    } else if (SharedPreferencesKeys.prefs!
                                            .getString(SharedPreferencesKeys
                                                .userRightsClient) ==
                                        'Admin') {
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
                                                    height: 410,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                  }
                                });
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${list[index]['CBRemarks'].toString()}'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          '${list[index]['Amount'].toString()}',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget uIListViewFeeDetails(List list, String menuName, var setState) {
    TextEditingController _totalAmountController = TextEditingController();
    FeeCollectionSQL _feeCollectionSql = FeeCollectionSQL();
    SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
    print(list);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          list[index]['FeeRecDate'] != null
                              ? Text(
                                  '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(list[index]['FeeRecDate'].toString().substring(0, 4)), int.parse(list[index]['FeeRecDate'].toString().substring(
                                        5,
                                        7,
                                      )), int.parse(list[index]['FeeRecDate'].toString().substring(8, 10)))).toString()} ',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              : SizedBox(),
                          Text(' (${list[index]['FeeRec1ID'].toString()}) '),
                          Text('${list[index]['GRN'].toString()} ,'),
                          Text(
                            '${list[index]['FamilyGroupNo'].toString()}',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FutureBuilder(
                            future: _salePurSQLDataBase
                                .userRightsChecking(menuName),
                            builder: (context, AsyncSnapshot<List> snapshot) {
                              if (snapshot.hasData) {
                                return popUpButtonForItemEdit2(
                                    onSelected: (value) async {
                                  if (value == 0) {
                                    if (list[index]['FeeRec2ID'] < 0) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            _totalAmountController.clear();
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Material(
                                                child: SizedBox(
                                                  height: 140,
                                                  width: 300,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: TextField(
                                                              controller:
                                                                  _totalAmountController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                label: Text(
                                                                    'Total Amount'),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            25.0),
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await _feeCollectionSql.updateStudentFeeRec(
                                                                              id: list[index]['FeeRec2ID'],
                                                                              recAmount: _totalAmountController.text.toString());

                                                                          Navigator.pop(
                                                                              context);

                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'ok',
                                                                          style:
                                                                              TextStyle(fontSize: 20),
                                                                        )),
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                      'Cancel')),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    } else if (SharedPreferencesKeys.prefs!
                                            .getString(SharedPreferencesKeys
                                                .userRightsClient) ==
                                        'Custom Right') {
                                      if (snapshot.data![0]['Inserting']
                                              .toString() ==
                                          'true') {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              _totalAmountController.clear();
                                              return Align(
                                                alignment: Alignment.center,
                                                child: Material(
                                                  child: SizedBox(
                                                    height: 140,
                                                    width: 300,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                              child: TextField(
                                                                controller:
                                                                    _totalAmountController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  label: Text(
                                                                      'Total Amount'),
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          25.0),
                                                                  child:
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await _feeCollectionSql.updateStudentFeeRec(
                                                                                id: list[index]['FeeRec2ID'],
                                                                                recAmount: _totalAmountController.text.toString());

                                                                            Navigator.pop(context);
                                                                            setState(() {});
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'ok',
                                                                            style:
                                                                                TextStyle(fontSize: 20),
                                                                          )),
                                                                ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child: Text(
                                                                        'Cancel')),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    } else if (SharedPreferencesKeys.prefs!
                                            .getString(SharedPreferencesKeys
                                                .userRightsClient) ==
                                        'Admin') {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            _totalAmountController.clear();
                                            return Align(
                                              alignment: Alignment.center,
                                              child: Material(
                                                child: SizedBox(
                                                  height: 140,
                                                  width: 300,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: TextField(
                                                              controller:
                                                                  _totalAmountController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                label: Text(
                                                                    'Total Amount'),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            25.0),
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await _feeCollectionSql.updateStudentFeeRec(
                                                                              id: list[index]['FeeRec2ID'],
                                                                              recAmount: _totalAmountController.text.toString());

                                                                          Navigator.pop(
                                                                              context);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'ok',
                                                                          style:
                                                                              TextStyle(fontSize: 20),
                                                                        )),
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                      'Cancel')),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  }

                                  if (value == 1) {
                                    checkEditAll = 'EditALL';

                                    currentDate = DateTime(
                                        int.parse(list[index]['FeeRecDate']
                                            .toString()
                                            .substring(0, 4)),
                                        int.parse(list[index]['FeeRecDate']
                                            .toString()
                                            .substring(5, 7)),
                                        int.parse(list[index]['FeeRecDate']
                                            .toString()
                                            .substring(8, 10)));

                                    _narrationController.text =
                                        list[index]['FeeRecRemarks'];

                                    btnText = 'Update';
                                    feeRec1ID = list[index]['FeeRec1ID'];

                                    List lsit2 = await _feeCollectionSQL
                                        .dataForAllStudentForNEWBYGRNANDFamilyGroupNoForEdit(
                                            list[index]['FeeRec1ID'].toString(),
                                            'Sch7FeeRec2.FeeRec1ID');

                                    for (int i = 0; i < lsit2.length; i++) {
                                      var recStudentFee =
                                          ModelFeeRec2.fromMap(lsit2[i]);
                                      listOFSelectedCollection
                                          .add(recStudentFee.toMap());
                                    }

                                    setState(() {});
                                  }

                                  if(value  == 2) {
                                    await showDialog(
                                        context:
                                        context,
                                        builder:
                                            (context) {
                                          return Center(
                                            child:
                                            Material(
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    .35,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    .8,
                                                color: Colors
                                                    .white,
                                                child:
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child:
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text('Rec ID : '),
                                                              Text(
                                                                '${list[index]['FeeRec1ID'].toString()}',
                                                                style: TextStyle(color: Colors.grey),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text('Total Rec : '),
                                                              Text(
                                                                '${list[index]['RecAmount'].toString()}',
                                                                style: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('Date :'),
                                                          Text(
                                                            '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(list[index]['FeeRecDate'].toString().substring(0, 4)), int.parse(list[index]['FeeRecDate'].toString().substring(
                                                              5,
                                                              7,
                                                            )), int.parse(list[index]['FeeRecDate'].toString().substring(8, 10)))).toString()}',
                                                            style: TextStyle(color: Colors.grey),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('Fee Remarks :  '),
                                                          Text(
                                                            '${list[index]['FeeRecRemarks'].toString()}',
                                                            style: TextStyle(color: Colors.grey),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment: Alignment.bottomCenter,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () async {
                                                                  List listData = await _feeCollectionSQL.selectPhoneNumberOFStudent('${list[index]['FeeRec1ID'].toString()}');

                                                                  feeRecPrint(context: context, slipInfoOfREc: listData);
                                                                },
                                                                child: Text('Print')),
                                                            //  FatherMobileNo  MotherMobileNo

                                                            ElevatedButton(
                                                                onPressed: () async {


                                                                  numberSendToWhatsApp(
                                                                    '${list[index]['FeeRec1ID'].toString()}', context, );
                                                                },
                                                                child: Text('WhatsApp')),
                                                            ElevatedButton(
                                                                onPressed: () {

                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text('back')),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }

                                });
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${list[index]['StudentName'].toString()}  ,'),
                          Text('${list[index]['FahterName'].toString()}')
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          '${list[index]['RecAmount'].toString()}',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      icon: Icon(
        Icons.more_horiz,
        size: 20,
        color: Colors.grey,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('Edit Amount')),
          // PopupMenuItem(value: 1, child: Text('Delete')),
        ];
      },
    );
  }

  Widget bulkFeeAllStudentYear(
      {required TextEditingController dueOnDate,
      required TextEditingController feeNarration,
      String OpenForEditOrSave = '',
      required TextEditingController feeAmount,
      required void Function()? onPressed,
      required String dialogTitle,
      String? stateName = '',
      required int maxID,
      required BuildContext context}) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (context, state) => Material(
            elevation: 20,
            color: Colors.transparent,
            child: Form(
              key: formKey,
              child: Container(
                color: Provider.of<ThemeDataHomePage>(context, listen: false)
                    .backGroundColor,
                height: MediaQuery.of(context).size.height * .53,
                width: MediaQuery.of(context).size.width * .80,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 35,
                      color:
                          Provider.of<ThemeDataHomePage>(context, listen: false)
                              .borderTextAppBarColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0, right: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 8,
                              child: FittedBox(
                                child: Text(
                                  dialogTitle,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 2,
                                child: Text(
                                  maxID.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      stateName!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 6),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'required';
                          } else {
                            return null;
                          }
                        },
                        controller: dueOnDate,
                        onTap: () async {
                          currentDate = await showDialog(
                              context: context,
                              builder: (context) {
                                return DatePickerStyle1();
                              });
                          dueOnDate.text =
                              '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(currentDate.toString().substring(0, 4)), int.parse(currentDate.toString().substring(
                                    5,
                                    7,
                                  )), int.parse(currentDate.toString().substring(8, 10)))).toString()}';

                          state(() {});
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            label: Text(
                              'Due On date',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 6),
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'required';
                            } else {
                              return null;
                            }
                          },
                          controller: feeNarration,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            label: Text(
                              'Fee Narration',
                              style: TextStyle(color: Colors.black),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 6),
                      child: SwitchListTile(
                          contentPadding: EdgeInsets.all(0),
                          activeColor: Provider.of<ThemeDataHomePage>(context,
                                  listen: false)
                              .borderTextAppBarColor,
                          title: Text(checkValueTitle),
                          value: checkValue,
                          onChanged: (value) {
                            state(() {
                              checkValue = value;
                              if (value) {
                                checkValueTitle = 'Custom Fee';
                              } else {
                                checkValueTitle = 'Monthly Fee';
                              }
                            });
                          }),
                    ),
                    checkValue
                        ? Padding(
                            padding: const EdgeInsets.only(left: 6.0, right: 6),
                            child: TextFormField(
                              controller: feeAmount,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return checkValue ? 'required' : null;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                  label: Text(
                                    'Fee Amount',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width / 3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ) // foreground
                                    ),
                                onPressed: () async {
                                  Navigator.pop(context);

                                  setState(() {});
                                },
                                child: Text(
                                  'CLOSE',
                                )),
                          ),
                          Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width / 3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ) // foreground
                                    ),
                                onPressed: onPressed,
                                child: Text(
                                  OpenForEditOrSave == 'Edit'
                                      ? 'Update'
                                      : 'SAVE',
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget popUpButtonForItemEdit2({Function(int)? onSelected}) {
  return PopupMenuButton<int>(
    padding: EdgeInsets.only(left: 8, bottom: 5),
    icon: Icon(
      Icons.more_horiz,
      size: 20,
      color: Colors.grey,
    ),
    onSelected: onSelected,
    itemBuilder: (context) {
      return [
        PopupMenuItem(value: 0, child: Text('Edit Amount')),
        PopupMenuItem(value: 1, child: Text('Edit All')),
        PopupMenuItem(value: 2, child: Text('Print')),
      ];
    },
  );
}

Widget popUpButtonForItemEditForExpanse({Function(int)? onSelected}) {
  return PopupMenuButton<int>(
    padding: EdgeInsets.only(left: 8, bottom: 5),
    icon: Icon(
      Icons.more_horiz,
      size: 20,
      color: Colors.grey,
    ),
    onSelected: onSelected,
    itemBuilder: (context) {
      return [
        PopupMenuItem(value: 0, child: Text('Edit')),
      ];
    },
  );
}

/// model class for state management ////////////////////////////////////////////////////////
class ModelFeeRec2 {
  late String branchName;
  late String educationalYear;
  late String sectionName;
  late String className;
  late String GRN;
  late String FeeNarration;
  late String TotalDue;
  late String TotalReceived;
  late String TotalBalance;
  late String DueDate;
  late String FeeDueID;
  late String StudentID;
  late String StudentName;
  late String DateOfBirth;
  late String FahterName;
  late String FatherMobileNo;
  late String FatherNIC;
  late String MotherName;
  late String MotherMobileNo;
  late String MotherNIC;
  late String Address;
  late String AddressPhoneNo;
  late String OtherDetail;
  late String UpdatedDate;
  late String AdmissionDate;
  late String LeavingDate;
  late String AdmissionRemarks;
  late String LeavingRemarks;
  late String FamilyGroupNo;

  ModelFeeRec2();

  ModelFeeRec2.fromMap(Map<String, dynamic> map) {
    branchName = map['BranchName'].toString();
    educationalYear = map['EducationalYear'].toString();
    sectionName = map['SectionName'].toString();
    FeeDueID = map['FeeDueID'].toString();
    className = map['ClassName'].toString();
    GRN = map['GRN'].toString();
    FeeNarration = map['FeeNarration'].toString();
    TotalDue = map['TotalDue'].toString();
    TotalReceived = map['TotalReceived'].toString();
    TotalBalance = map['TotalBalance'].toString();
    DueDate = map['DueDate'].toString();
    StudentID = map['StudentID'].toString();
    StudentName = map['StudentName'].toString();
    DateOfBirth = map['DateOfBirth'].toString();
    FahterName = map['FahterName'].toString();
    FatherMobileNo = map['FatherMobileNo'].toString();
    FatherNIC = map['FatherNIC'].toString();
    MotherName = map['MotherName'].toString();
    MotherMobileNo = map['MotherMobileNo'].toString();
    MotherNIC = map['MotherNIC'].toString();
    Address = map['Address'].toString();
    AddressPhoneNo = map['AddressPhoneNo'].toString();
    OtherDetail = map['OtherDetail'].toString();
    UpdatedDate = map['UpdatedDate'].toString();
    AdmissionDate = map['AdmissionDate'].toString();
    LeavingDate = map['LeavingDate'].toString();
    AdmissionRemarks = map['AdmissionRemarks'].toString();
    LeavingRemarks = map['LeavingRemarks'].toString();
    FamilyGroupNo = map['FamilyGroupNo'].toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'BranchName': branchName,
      'EducationalYear': educationalYear,
      'SectionName': sectionName,
      'FeeDueID': FeeDueID,
      'ClassName': className,
      'GRN': GRN,
      'FeeNarration': FeeNarration,
      'TotalDue': TotalDue,
      'TotalReceived': TotalReceived,
      'TotalBalance': TotalBalance,
      'DueDate': DueDate,
      'StudentID': StudentID,
      'StudentName': StudentName,
      'DateOfBirth': DateOfBirth,
      'FahterName': FahterName,
      'FatherMobileNo': FatherMobileNo,
      'FatherNIC': FatherNIC,
      'MotherName': MotherName,
      'MotherMobileNo': MotherMobileNo,
      'MotherNIC': MotherNIC,
      'Address': Address,
      'AddressPhoneNo': AddressPhoneNo,
      'OtherDetail': OtherDetail,
      'UpdatedDate': UpdatedDate,
      'AdmissionDate': AdmissionDate,
      'LeavingDate': LeavingDate,
      'AdmissionRemarks': AdmissionRemarks,
      'LeavingRemarks': LeavingRemarks,
      'FamilyGroupNo': FamilyGroupNo,
    };
  }
}
