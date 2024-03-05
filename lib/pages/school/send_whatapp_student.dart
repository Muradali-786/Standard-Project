import 'package:com/pages/school/FeeCollectionSQL.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../login/create_account_and_login_code_provider.dart';
import '../material/countrypicker.dart';
import 'feerecslip.dart';

FeeCollectionSQL _feeCollectionSQL = FeeCollectionSQL();
ScreenshotController screenshotController = ScreenshotController();

void numberSendToWhatsApp(
  String id,
  BuildContext context,
) async {
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, state) => FutureBuilder<List>(
            future: _feeCollectionSQL.selectPhoneNumberOFStudent(id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var list = snapshot.data!;
                return Center(
                  child: Container(
                    color: Colors.white,
                    height: 250,
                    width: 300,
                    alignment: Alignment.center,
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Mobile Number',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                List list = await _feeCollectionSQL
                                    .selectPhoneNumberOFStudent(id);

                                feeRecShare(
                                    list: list,
                                    number: list[0]['StudentMobileNo']);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Student :'),
                                  list[0]['StudentMobileNo'].toString().isEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return NumberPickersForSending(
                                                      numberFor: 'Student',
                                                      GRN: list[0]['GRN']
                                                          .toString(),
                                                      state: state,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text('Add Number')),
                                        )
                                      : Text(list[0]['StudentMobileNo']),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                List list = await _feeCollectionSQL
                                    .selectPhoneNumberOFStudent(id);

                                feeRecShare(
                                    list: list,
                                    number: list[0]['FatherMobileNo']);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Father :'),
                                  list[0]['FatherMobileNo'].toString().isEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return NumberPickersForSending(
                                                      numberFor: 'Father',
                                                      GRN: list[0]['GRN']
                                                          .toString(),
                                                      state: state,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text('Add Number')),
                                        )
                                      : Text(list[0]['FatherMobileNo']),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                List list = await _feeCollectionSQL
                                    .selectPhoneNumberOFStudent(id);

                                feeRecShare(
                                    list: list,
                                    number: list[0]['MotherMobileNo']);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Mother :'),
                                  list[0]['MotherMobileNo'].toString().isEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return NumberPickersForSending(
                                                      numberFor: 'Mother',
                                                      GRN: list[0]['GRN']
                                                          .toString(),
                                                      state: state,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text('Add Number')),
                                        )
                                      : Text(list[0]['MotherMobileNo']),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                List list = await _feeCollectionSQL
                                    .selectPhoneNumberOFStudent(id);

                                feeRecShare(
                                    list: list,
                                    number: list[0]['GuardianMobileNo']);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Guardian :'),
                                  list[0]['GuardianMobileNo'].toString().isEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return NumberPickersForSending(
                                                      numberFor: 'Guardian',
                                                      GRN: list[0]['GRN']
                                                          .toString(),
                                                      state: state,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text('Add Number')),
                                        )
                                      : Text(list[0]['GuardianMobileNo']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        );
      });
}

class NumberPickersForSending extends StatefulWidget {
  final String numberFor;
  final String GRN;
  final void Function(void Function()) state;

  const NumberPickersForSending(
      {super.key,
      required this.numberFor,
      required this.GRN,
      required this.state});

  @override
  State<NumberPickersForSending> createState() =>
      _NumberPickersForSendingState();
}

class _NumberPickersForSendingState extends State<NumberPickersForSending> {
  TextEditingController _controller = TextEditingController();

  String countryCode = '+92';
  bool check = true;
  Map dropDownMap = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
    'Code2': '',
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FutureBuilder(
                      future: Provider.of<AuthenticationProvider>(context,
                              listen: false)
                          .getAllDataFromCountryCodeTable(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          Future.delayed(
                            Duration.zero,
                            () {
                              if (check) {
                                print(
                                    '..................................................feefe...............................................');
                                for (int i = 0;
                                    i < snapshot.data!.length;
                                    i++) {
                                  if (DateTime.now().timeZoneName ==
                                      snapshot.data![i]['SName']) {
                                    dropDownMap['ID'] =
                                        snapshot.data[i]['ID'].toString();
                                    dropDownMap['CountryName'] = snapshot
                                        .data[i]['CountryName']
                                        .toString();
                                    dropDownMap['Image'] =
                                        'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                    dropDownMap['CountryCode'] = snapshot
                                        .data[i]['CountryCode']
                                        .toString();
                                    dropDownMap['DateFormat'] = snapshot.data[i]
                                            ['DateFormat']
                                        .toString();
                                    dropDownMap['CurrencySign'] = snapshot
                                        .data[i]['CurrencySigne']
                                        .toString();
                                    dropDownMap['Code2'] =
                                        snapshot.data[i]['Code2'].toString();
                                    _controller.text = snapshot.data[i]
                                            ['CountryCode']
                                        .toString();
                                    setState(() {});
                                  }
                                }
                                check = false;
                              }
                            },
                          );
                          // } else {
                          //   Future.delayed(
                          //     Duration.zero,
                          //         () {
                          //       if (checkFather) {
                          //         for (int i = 0;
                          //         i < snapshot.data!.length;
                          //         i++) {
                          //           if (snapshot.data![i]
                          //           ['CountryCode']
                          //               .toString() ==
                          //               '+$countryCodeFather') {
                          //             dropDownMap['Image'] =
                          //             'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                          //
                          //             setState(() {
                          //
                          //             });
                          //           }
                          //         }
                          //         checkFather = false;
                          //       }
                          //     },
                          //   );
                          // }
                          return SizedBox(
                            height: 60,
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Map data = await showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    DropDownStyle1Image(
                                                  acc1TypeList: snapshot.data,
                                                  map: dropDownMap,
                                                ),
                                              ) ??
                                              {};

                                          print(data);

                                          if (data.isNotEmpty) {
                                            setState(
                                              () {
                                                dropDownMap = data;
                                                countryCode =
                                                    dropDownMap['CountryCode']
                                                        .toString();
                                                _controller.text =
                                                    countryCode.toString();
                                              },
                                            );
                                          }
                                        },
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        child: Image.asset(
                                          dropDownMap['Image'].toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(),
                                label: Text(
                                  '${widget.numberFor} Mobile No',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          bool checkUpdate = false;
                          if (widget.numberFor == 'Student') {
                            checkUpdate = await updateNumbersForFeeRecStudent(
                              GRN: widget.GRN,
                              StudentMobileNo: _controller.text.toString(),
                            );
                          }

                          if (widget.numberFor == 'Father') {
                            checkUpdate = await updateNumbersForFeeRecFather(
                              GRN: widget.GRN,
                              FatherMobileNo: _controller.text.toString(),
                            );
                          }
                          if (widget.numberFor == 'Mother') {
                            checkUpdate = await updateNumbersForFeeRecMother(
                              GRN: widget.GRN,
                              MotherMobileNo: _controller.text.toString(),
                            );
                          }
                          if (widget.numberFor == 'Guardian') {
                            checkUpdate = await updateNumbersForFeeRecGuardian(
                              GRN: widget.GRN,
                              GuardianMobileNo: _controller.text.toString(),
                            );
                          }

                          if (checkUpdate) {
                            Navigator.pop(context);
                            widget.state(() {});
                          }
                        },
                        child: Text('Add Number'))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
