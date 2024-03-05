import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../main/tab_bar_pages/home/home_page.dart';
import '../../../main/tab_bar_pages/home/themedataclass.dart';
import '../../../utils/constants.dart';
import '../../login/create_account_and_login_code_provider.dart';
import '../../material/countrypicker.dart';
import '../CashBook/cashBookSql.dart';
import 'Account3Name.dart';
import 'Account4UserRightsModel.dart';
import 'AccountLedger.dart';
import 'AccountSQL.dart';
import 'custom_user_rights_page.dart';

class AccountListView extends StatefulWidget {
  final ItemSelectedCallback? onItemSelected;
  final List list;

  final String menuName;
  final state;

  const AccountListView(
      {Key? key,
      this.onItemSelected,
      required this.list,
      required this.state,
      required this.menuName})
      : super(key: key);

  @override
  State<AccountListView> createState() => _AccountListViewState();
}

class _AccountListViewState extends State<AccountListView> {
  bool isDecending = false;
  bool isDecendingDebit = false;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  bool isDecendingCredit = false;
  CashBookSQL _cashBookSQL = CashBookSQL();
  AccountSQL _accountSQL = AccountSQL();
  String userRightsDropdownValue = "Statement View Only";
  String countryCode = '';
  final _formKey = GlobalKey<FormState>();
  bool check = true;

  Map dropDownMap = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
  };

  @override
  void initState() {
    super.initState();
    print('................${widget.list}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ///   title for list view///////////////////////
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Provider.of<ThemeDataHomePage>(context, listen: false)
                    .borderTextAppBarColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isDecending = !isDecending;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'Account',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_downward_outlined,
                              color: Colors.white,
                              size: 12,
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isDecendingDebit = !isDecendingDebit;
                                });
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Debit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.arrow_downward_outlined,
                                      color: Colors.white,
                                      size: 12,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isDecendingCredit = !isDecendingCredit;
                                });
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Credit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.arrow_downward_outlined,
                                      color: Colors.white,
                                      size: 12,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          ///   whole data list view///////////////////////
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              List sortedList = [];
              if (isDecending == true) {
                sortedList = widget.list.reversed.toList();
              } else if (isDecendingCredit == true) {
                List listCopy = List.from(widget.list);
                listCopy.sort((a, b) =>
                    a["Credit"].toString().compareTo(b["Credit"].toString()));
                sortedList = listCopy;
              } else if (isDecendingDebit == true) {
                List listCopy = List.from(widget.list);
                listCopy.sort((a, b) =>
                    a["Debit"].toString().compareTo(b["Debit"].toString()));
                sortedList = listCopy;
              } else {
                sortedList = widget.list;
              }
              Map map = sortedList[index];
              return InkWell(
                onTap: () async {
                  if (!Platform.isWindows) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountLedger(
                          accountId: map['AccountId'],
                        ),
                      ),
                    );
                  } else {
                    widget.onItemSelected!(
                      AccountLedger(
                        accountId: map['AccountId'],
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Provider.of<ThemeDataHomePage>(context,
                                  listen: false)
                              .borderTextAppBarColor,
                        )),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: popUpButtonForItemEdit(
                                onSelected: (value) async {
                              if (value == 0) {
                                List mapRec = await _cashBookSQL
                                    .getReceivable(map['AccountId'].toString());
                                List mapPay = await _cashBookSQL
                                    .getPayable(map['AccountId'].toString());
                                if (mapPay.length > 1 || mapRec.length > 1) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(
                                              'Opening Balance are Duplicate in CashBook of this account Please remove any one entry from Cashbook then you can modify this record'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('OK'))
                                          ],
                                        );
                                      });
                                } else {
                                  List list = [];
                                  list.add(map);
                                  list.add({"action": "EDIT"});
                                  list.add({"menuName": widget.menuName});
                                  list.add(mapRec);
                                  list.add(mapPay);
                                  if (!Platform.isWindows) {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Account3Name(
                                            list,
                                            state: widget.state,
                                          );
                                        });
                                  } else {
                                    widget.onItemSelected!(Account3Name(
                                      list,
                                      state: widget.state,
                                    ));
                                  }
                                }

                                setState(() {});
                              }

                              if (value == 1) {
                                _mobileNoController.text =
                                    map['MobileNo'].toString();
                                _emailController.text = map['E-Mail']
                                    .toString()
                                    .toString()
                                    .split('@')
                                    .first;
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) => Center(
                                          child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Material(
                                            child: userRight(
                                                setState: setState,
                                                ID: map['ID'],
                                                accountID: map['AccountId'])),
                                      )),
                                    );
                                  },
                                );
                              }
                            }),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: RichText(
                                    text: Constants.searchMatch(
                                        map['AccountName'].toString(),
                                        _searchController.text),
                                    maxLines: 3),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: map['Debit'] != null
                                          ? FittedBox(
                                              child: Text(
                                                map['Debit'].toString(),
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '0',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 25),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: map['Credit'] != null
                                            ? FittedBox(
                                                child: Text(
                                                    map['Credit'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                    textAlign: TextAlign.right),
                                              )
                                            : Text(
                                                '0',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
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
          )
        ],
      ),
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
          PopupMenuItem(value: 0, child: Text('Edit')),
          PopupMenuItem(value: 1, child: Text('User Rights')),
        ];
      },
    );
  }

  Widget userRight({
    required int accountID,
    required int ID,
    required void Function(void Function()) setState,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'User Right :',
                    style: TextStyle(fontSize: 17),
                  ),
                )),
            accountID == 1
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                    child: Text(
                      'This is super Admin account You do not have rights to change this information',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox(),
            IgnorePointer(
              ignoring: accountID == 1 ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                child: FutureBuilder(
                  future: Provider.of<AuthenticationProvider>(context,
                          listen: false)
                      .getAllDataFromCountryCodeTable(),
                  //getting the dropdown data from query
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      //print(snapshot.data);

                      Future.delayed(
                        Duration.zero,
                        () {
                          if (check) {
                            for (int i = 0; i < snapshot.data!.length; i++) {
                              if (DateTime.now().timeZoneName ==
                                  snapshot.data![i]['SName']) {
                                print(
                                    '.............................................................time...........................f');
                                dropDownMap['ID'] =
                                    snapshot.data[i]['ID'].toString();
                                dropDownMap['CountryName'] =
                                    snapshot.data[i]['CountryName'].toString();
                                dropDownMap['Image'] =
                                    'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                dropDownMap['CountryCode'] =
                                    snapshot.data[i]['CountryCode'].toString();

                                dropDownMap['DateFormat'] =
                                    snapshot.data[i]['DateFormat'].toString();
                                dropDownMap['CurrencySign'] = snapshot.data[i]
                                        ['CurrencySigne']
                                    .toString();

                                setState(() {});
                              }
                            }
                            check = false;
                          }
                        },
                      );

                      return Center(
                        child: InkWell(
                            onTap: () async {
                              dropDownMap = await showDialog(
                                context: context,
                                builder: (_) => DropDownStyle1Image(
                                  acc1TypeList: snapshot.data,
                                  // dropdown_title: dropDownMap['Title'],
                                  //dropdown_title: dropDownMap['Title'],
                                  map: dropDownMap,
                                ),
                              );

                              countryCode =
                                  dropDownMap['CountryCode'].toString();

                              setState(() {});

                              print(countryCode);
                            },
                            child: DropDownStyle1State.DropDownButton(
                                title: dropDownMap['CountryName'].toString(),
                                id: dropDownMap['CountryCode'].toString(),
                                image: dropDownMap['Image'].toString())),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
            IgnorePointer(
              ignoring: accountID == 1 ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                child: TextFormField(
                  controller: _mobileNoController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'required';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      prefix: Text(dropDownMap['CountryCode'].toString()),
                      focusedBorder: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      //  prefixText: countryCode,
                      suffixIcon: IconButton(
                          onPressed: () async {
                            if (countryCode.length == 0 &&
                                _mobileNoController.text.toString().length ==
                                    0) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: SizedBox(
                                        height: 200,
                                        child: AlertDialog(
                                          content: Text(
                                              'Please Select Country First!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('ok'),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              String? number;
                              Contact? contacts = await ContactsService
                                  .openDeviceContactPicker();
                              contacts!.phones!.forEach((element) {
                                number = element.value;
                              });
                              number!.trim().toString().lastChars(9);
                              _mobileNoController.text =
                                  '$countryCode${number!.trim().toString().lastChars(10)}';
                            }
                          },
                          icon: Icon(Icons.contact_page_sharp)),
                      label: Text(
                        'Login With Mobile No',
                        style: TextStyle(color: Colors.black),
                      ),
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            IgnorePointer(
              ignoring: accountID == 1 ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 7,
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp("[a-zA-Z0-9.]"),
                          ),
                        ],
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'required';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(),
                            fillColor: Colors.white,
                            filled: true,
                            suffix: Text(
                              '@gmail.com',
                              style: TextStyle(color: Colors.grey),
                            ),
                            label: Text(
                              'Email Address',
                              style: TextStyle(color: Colors.black),
                            ),
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              ignoring: accountID == 1 ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: userRightsDropdownValue,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Colors.grey,
                              size: 20,
                            ),
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? newValue) async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  userRightsDropdownValue = newValue!;
                                });

                                await _accountSQL.UpdateAccount3NameUserRight(
                                    ID,
                                    _emailController.text.toString().length > 0
                                        ? '${_emailController.text}@gmail.com'
                                        : '',
                                    _mobileNoController.text,
                                    userRightsDropdownValue,
                                    context);

                                if (newValue == 'Custom Right') {
                                  List list = await _accountSQL
                                      .getAccount4UserRightsData(accountID);

                                  List menuList =
                                      await _accountSQL.getProjectTable();

                                  for (int count = 0;
                                      count < menuList.length;
                                      count++) {
                                    bool check = true;
                                    for (int j = 0; j < list.length; j++) {
                                      Account4UserRightsModel userRight =
                                          list[j];

                                      if (menuList[count]['MenuName'] ==
                                          userRight.menuName) {
                                        check = false;
                                        break;
                                      }
                                    }

                                    if (check) {
                                      await _accountSQL
                                          .insertIntoCustonUserRight(
                                              account3Id: accountID,
                                              menuaname: menuList[count]
                                                      ['MenuName']
                                                  .toString(),
                                              view: 'false',
                                              custonRightInserting: 'false',
                                              customRightEiditing: 'false',
                                              customRightDeleting: 'false',
                                              customRightReporting: 'false',
                                              sortBy: menuList[count]['SortBy'],
                                              groupSortBy: menuList[count]
                                                  ['GroupSortBy']);
                                    }
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomUserRightsScreen(
                                              menuName: widget.menuName,
                                              account3Id: accountID,
                                              length: list.length,
                                              action: 'ADD',
                                            )),
                                  );

                                  widget.state(() {});
                                }
                              }
                            },
                            items: <String>[
                              'Not Allow Login',
                              'Admin',
                              'Statement View Only',
                              'Custom Right'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        (userRightsDropdownValue == "Custom Right")
                            ? IconButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _accountSQL.UpdateAccount3NameUserRight(
                                        ID,
                                        _emailController.text
                                                    .toString()
                                                    .length >
                                                0
                                            ? '${_emailController.text}@gmail.com'
                                            : '',
                                        _mobileNoController.text,
                                        userRightsDropdownValue,
                                        context);

                                    List list = await _accountSQL
                                        .getAccount4UserRightsData(accountID);

                                    List menuList =
                                        await _accountSQL.getProjectTable();

                                    for (int count = 0;
                                        count < menuList.length;
                                        count++) {
                                      bool check = true;
                                      for (int j = 0; j < list.length; j++) {
                                        Account4UserRightsModel userRight =
                                            list[j];
                                        if (menuList[count]['MenuName'] ==
                                            userRight.menuName) {
                                          check = false;
                                          break;
                                        }
                                      }

                                      if (check) {
                                        await _accountSQL
                                            .insertIntoCustonUserRight(
                                                account3Id: accountID,
                                                menuaname: menuList[count]
                                                        ['MenuName']
                                                    .toString(),
                                                view: 'false',
                                                custonRightInserting: 'false',
                                                customRightEiditing: 'false',
                                                customRightDeleting: 'false',
                                                customRightReporting: 'false',
                                                sortBy: menuList[count]
                                                    ['SortBy'],
                                                groupSortBy: menuList[count]
                                                    ['GroupSortBy']);
                                      }
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomUserRightsScreen(
                                                menuName: widget.menuName,
                                                account3Id: accountID,
                                                length: list.length,
                                                action: 'ADD',
                                              )),
                                    );

                                    widget.state(() {});
                                  }
                                },
                                icon: Icon(Icons.settings))
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                        onPressed: () {
                          Navigator.pop(context);
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _accountSQL.UpdateAccount3NameUserRight(
                                ID,
                                _emailController.text.toString().length > 0
                                    ? '${_emailController.text}@gmail.com'
                                    : '',
                                _mobileNoController.text,
                                userRightsDropdownValue,
                                context);
                          }

                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Text(
                          'Update',
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
