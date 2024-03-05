import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../Server/RefreshDataProvider.dart';
import '../../../api/api_constants.dart';
import '../../../main/tab_bar_pages/home/themedataclass.dart';
import '../../../shared_preferences/shared_preference_keys.dart';
import '../../login/create_account_and_login_code_provider.dart';
import '../../material/countrypicker.dart' as country;
import '../../material/drop_down_style1.dart';
import '../CashBook/cashBookSql.dart';
import 'Account2Group.dart';
import 'AccountSQL.dart';
import 'account2GroupList.dart';
import 'custom_user_rights_page.dart';

extension E on String {
  String lastChars(int n) => substring(length - n);
}

class Account3Name extends StatefulWidget {
  final List? list;
  final state;

  Account3Name(this.list, {Key? key, this.state}) : super(key: key);

  @override
  _Account3NameState createState() => _Account3NameState();
}

class _Account3NameState extends State<Account3Name> {
  final _formKey = GlobalKey<FormState>();
  CashBookSQL _cashBookSQL = CashBookSQL();
  RefreshDataProvider refreshing = RefreshDataProvider();
  AccountSQL _accountSQL = AccountSQL();
  TextEditingController _accountGroupIdController = TextEditingController();
  TextEditingController _accountNameController = TextEditingController();
  TextEditingController _receivableController = TextEditingController();
  TextEditingController _payableController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _countryCodeController = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _nameOfPersonController = TextEditingController();
  DateTime currentDate = DateTime.now();
  double itemExtend = 100;
  Map dropDownMap = {
    "ID": null,
    'Title': 'Account Group Name',
    'SubTitle': null,
    "Value": null
  };
  Map dropDownForCountry = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
  };
  String? action;
  String? id;
  String countryCode = '';
  Map? args;
  String accountIDForRec = '';
  String accountIDForPay = '';
  String? path;
  List mapRec = [];
  List mapPay = [];
  String? errorMessage;
  String? dir;
  int? accountID;
  String userRightsDropdownValue = "Statement View Only";

  @override
  void initState() {
    args = widget.list![0];
    action = widget.list![1]['action'];

    if (action == 'ADD') {
      // _emailController.text = 'gmail.com';
    }
    if (action == "EDIT") {
      mapRec = widget.list![3];
      mapPay = widget.list![4];
      accountID = args!['AccountId'];
      _initDir(args!['AccountId'].toString());
      if (mapRec.length != 0) {
        accountIDForRec = mapRec[0]['CashBookID'].toString();
        _receivableController.text = mapRec[0]['Amount'].toString();
      }
      if (mapPay.length != 0) {
        accountIDForPay = mapPay[0]['CashBookID'].toString();
        _payableController.text = mapPay[0]['Amount'].toString();
      }

      _accountGroupIdController.text = args!.containsKey('GroupName')
          ? args!['GroupName'] == null
              ? ""
              : args!['GroupName'].toString()
          : "";
      _accountNameController.text = args!.containsKey('AccountName')
          ? args!['AccountName'] == null
              ? ""
              : args!['AccountName'].toString()
          : "";
      _addressController.text = args!.containsKey('Address')
          ? args!['Address'] == null
              ? ""
              : args!['Address'].toString()
          : "";
      _phoneNoController.text = args!.containsKey('OfficeNo')
          ? args!['OfficeNo'] == null
              ? ''
              : args!['OfficeNo'].toString()
          : "";
      _mobileNoController.text = args!.containsKey('MobileNo')
          ? args!['MobileNo'] == null
              ? ""
              : args!['MobileNo'].toString()
          : "";
      userRightsDropdownValue =
          args!.containsKey('UserRights') && args!['UserRights'] != null
              ? args!['UserRights'].toString()
              : "Statement View Only";
      _remarksController.text = args!.containsKey('Remarks')
          ? args!['Remarks'] == null
              ? ""
              : args!['Remarks'].toString()
          : "";
      _emailController.text = args!['E-Mail'].toString().split('@').first;

      id = args!.containsKey('ID') ? args!['ID'].toString() : "";
      dropDownMap['ID'] =
          args!.containsKey('GroupId') ? args!['GroupId'] : null;
      dropDownMap['Title'] =
          args!.containsKey('GroupName') ? args!['GroupName'] : null;
      dropDownMap['SubTitle'] =
          args!.containsKey('AccountType') ? args!['AccountType'] : null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
          .backGroundColor,
      body: () {
        if (widget.list![1]['action'] == 'EDIT') {
          if (accountID! < 0) {
            return account3Dialog(context);
          }
        }
        if (SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.userRightsClient) ==
            'Custom Right') {
          if (widget.list![1]['action'] == 'ADD') {
            return FutureBuilder<bool>(
              future: _accountSQL.userRightsChecking(
                  'Inserting', widget.list![2]['menuName']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == false) {
                    return AlertDialog(
                      title: Text("Message"),
                      content: Text(
                          'You have no ${widget.list![1]['action']} rights by the admin'),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        )
                      ],
                    );
                  } else {
                    return account3Dialog(context);
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          } else {
            return FutureBuilder<bool>(
              future: _accountSQL.userRightsChecking(
                  'Edting', widget.list![2]['menuName']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == false) {
                    return AlertDialog(
                      title: Text("Message"),
                      content: Text(
                          'You have no ${widget.list![1]['action']} rights by the admin'),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        )
                      ],
                    );
                  } else {
                    print('........else..................');
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          }
        } else {
          return account3Dialog(context);
        }
      }(),
    );
  }

  ///   Whole Dialog UI ...................................//
  Widget account3Dialog(BuildContext context) {
    Future<void> handleClick(String value) async {
      switch (value) {
        case 'Add Account Group':
          {
            showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedContainer(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  child: Center(
                      child: SizedBox(
                          height: 300,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Account2GroupDesign(
                                action: 'Add',
                              )))),
                );
              },
            );
            setState(() {});
            break;
          }

        case 'EDIT Account Group':
          await showDialog(
            context: context,
            builder: (_) => Account2GroupList(),
          );
          break;
      }
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Provider.of<ThemeDataHomePage>(context, listen: false)
                      .borderTextAppBarColor,
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account Name',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        (action != "EDIT"
                            ? FutureBuilder(
                                future: _accountSQL.MaxIdForAccount3Name(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    accountID = snapshot.data!;
                                    return Text(
                                      snapshot.data!.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                            : Text(
                                accountID.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))
                      ],
                    ),
                  ),
                ),
                (path == null)
                    ? Container()
                    : InkWell(
                        child: Center(
                          child: Container(
                            height: 250,
                            width: 250,
                            color: Colors.blue,
                            child: Image.file(
                              File(path!),
                            ),
                          ),
                        ),
                        onTap: () async {},
                      ),
                Center(
                  child: CircleAvatar(
                    child: Builder(
                      builder: (context) {
                        return IconButton(
                          onPressed: () async {
                            showBottomSheet(
                              context: context,
                              builder: (context) => Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          'jpg',
                                        ],
                                      );
                                      path = result!.paths[0];
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: ListTile(
                                      title: Text(Platform.isWindows
                                          ? "Pick from pictures"
                                          : "Pick from gallery"),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.camera_alt,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Form(
                    key: _formKey,
                    child: MediaQuery.of(context).size.width < 600
                        ? Column(
                            children: [
                              ///    required fields..................................................
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: ExpansionTile(
                                    iconColor: Colors.black,
                                    collapsedIconColor: Colors.black,
                                    title: Text(
                                      'Required Fields',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    initiallyExpanded: true,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              child: PopupMenuButton<String>(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                icon: Icon(Icons.more_horiz),
                                                onSelected: handleClick,
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return {
                                                    'Add Account Group',
                                                    'EDIT Account Group'
                                                  }.map(
                                                    (String choice) {
                                                      return PopupMenuItem<
                                                          String>(
                                                        value: choice,
                                                        child: Text(choice),
                                                      );
                                                    },
                                                  ).toList();
                                                },
                                              ),
                                            ),
                                            FutureBuilder(
                                              future: _accountSQL
                                                  .dropDownDataForAccount3Group(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return Center(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        dropDownMap =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              DropDownStyle1(
                                                            acc1TypeList:
                                                                snapshot.data,
                                                            dropdown_title:
                                                                dropDownMap[
                                                                    'Title'],
                                                            map: dropDownMap,
                                                          ),
                                                        );
                                                        setState(() {});
                                                      },
                                                      child: DropDownStyle1State
                                                          .DropDownButton(
                                                        title:
                                                            dropDownMap['Title']
                                                                .toString(),
                                                        id: dropDownMap['ID']
                                                            .toString(),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return CircularProgressIndicator();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8, left: 8),
                                        child: TextFormField(
                                          controller: _accountNameController,
                                          validator: (value) {
                                            if (_accountNameController.text
                                                    .toString()
                                                    .length ==
                                                0) {
                                              return 'required';
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              fillColor: Colors.white,
                                              filled: true,
                                              label: Text(
                                                'Account Name',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8, left: 8, top: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('Opening Balance :'),
                                                    Text(
                                                        'CB $accountIDForRec $accountIDForPay')
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 4,
                                                                top: 8),
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              _receivableController,
                                                          textAlign:
                                                              TextAlign.end,
                                                          decoration:
                                                              InputDecoration(
                                                                  focusedBorder:
                                                                      OutlineInputBorder(),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  label: Text(
                                                                    'Receivable',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                  border:
                                                                      OutlineInputBorder()),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4,
                                                                top: 8),
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          textAlign:
                                                              TextAlign.end,
                                                          controller:
                                                              _payableController,
                                                          decoration:
                                                              InputDecoration(
                                                                  focusedBorder:
                                                                      OutlineInputBorder(),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  label: Text(
                                                                    'Payable',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                  border:
                                                                      OutlineInputBorder()),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ///    login fields..................................................
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 6.0),
                              //   child: Container(
                              //     decoration:
                              //         BoxDecoration(border: Border.all()),
                              //     child: ExpansionTile(
                              //         title: Text('Login Right'),
                              //         iconColor: Colors.black,
                              //         collapsedIconColor: Colors.black,
                              //         children: [
                              //           accountID == 1
                              //               ? Padding(
                              //                   padding: const EdgeInsets.only(
                              //                       top: 8.0,
                              //                       right: 8,
                              //                       left: 8),
                              //                   child: Text(
                              //                     'This is super Admin account You do not have rights to change this information',
                              //                     style: TextStyle(
                              //                         color: Colors.red),
                              //                   ),
                              //                 )
                              //               : SizedBox(),
                              //           IgnorePointer(
                              //             ignoring: accountID == 1 ? true : false,
                              //             child: Padding(
                              //               padding: const EdgeInsets.only(
                              //                   top: 8.0, right: 8, left: 8),
                              //               child: FutureBuilder(
                              //                 future: Provider.of<AuthProvider>(
                              //                         context,
                              //                         listen: false)
                              //                     .getAllDataFromCountryCodeTable(),
                              //                 builder: (BuildContext context,
                              //                     AsyncSnapshot<dynamic>
                              //                         snapshot) {
                              //                   if (snapshot.hasData) {
                              //                     return Center(
                              //                       child: InkWell(
                              //                         onTap: () async {
                              //                           dropDownForCountry =
                              //                               await showDialog(
                              //                             context: context,
                              //                             builder: (_) => country
                              //                                 .DropDownStyle1Image(
                              //                               acc1TypeList:
                              //                                   snapshot.data,
                              //                               map:
                              //                                   dropDownForCountry,
                              //                             ),
                              //                           );
                              //                           setState(() {
                              //                             if (_mobileNoController
                              //                                     .text
                              //                                     .toString()
                              //                                     .length ==
                              //                                 0) {
                              //                               countryCode =
                              //                                   dropDownForCountry[
                              //                                           'CountryCode']
                              //                                       .toString();
                              //
                              //                               _mobileNoController
                              //                                       .text =
                              //                                   dropDownForCountry[
                              //                                           'CountryCode']
                              //                                       .toString();
                              //                             }
                              //                           });
                              //                         },
                              //                         child: country
                              //                                 .DropDownStyle1State
                              //                             .DropDownButton(
                              //                           title: dropDownForCountry[
                              //                                   'CountryName']
                              //                               .toString(),
                              //                           id: dropDownForCountry[
                              //                                   'CountryCode']
                              //                               .toString(),
                              //                           image:
                              //                               dropDownForCountry[
                              //                                       'Image']
                              //                                   .toString(),
                              //                         ),
                              //                       ),
                              //                     );
                              //                   }
                              //                   return Container();
                              //                 },
                              //               ),
                              //             ),
                              //           ),
                              //           IgnorePointer(
                              //             ignoring: accountID == 1 ? true : false,
                              //             child: Padding(
                              //               padding: const EdgeInsets.only(
                              //                   top: 8.0, right: 8, left: 8),
                              //               child: TextFormField(
                              //                 controller: _mobileNoController,
                              //                 decoration: InputDecoration(
                              //                     focusedBorder:
                              //                         OutlineInputBorder(),
                              //                     fillColor: Colors.white,
                              //                     filled: true,
                              //                     //  prefixText: countryCode,
                              //                     suffixIcon: IconButton(
                              //                         onPressed: () async {
                              //                           if (countryCode
                              //                                       .length ==
                              //                                   0 &&
                              //                               _mobileNoController
                              //                                       .text
                              //                                       .toString()
                              //                                       .length ==
                              //                                   0) {
                              //                             showDialog(
                              //                                 context: context,
                              //                                 builder:
                              //                                     (context) {
                              //                                   return Center(
                              //                                     child:
                              //                                         SizedBox(
                              //                                       height: 200,
                              //                                       child:
                              //                                           AlertDialog(
                              //                                         content: Text(
                              //                                             'Please Select Country First!'),
                              //                                         actions: [
                              //                                           TextButton(
                              //                                             onPressed:
                              //                                                 () {
                              //                                               Navigator.pop(context);
                              //                                             },
                              //                                             child:
                              //                                                 Text('ok'),
                              //                                           )
                              //                                         ],
                              //                                       ),
                              //                                     ),
                              //                                   );
                              //                                 });
                              //                           } else {
                              //                             String? number;
                              //                             Contact? contacts =
                              //                                 await ContactsService
                              //                                     .openDeviceContactPicker();
                              //                             contacts!.phones!
                              //                                 .forEach(
                              //                                     (element) {
                              //                               number =
                              //                                   element.value;
                              //                             });
                              //                             number!
                              //                                 .trim()
                              //                                 .toString()
                              //                                 .lastChars(9);
                              //                             _mobileNoController
                              //                                     .text =
                              //                                 '$countryCode${number!.trim().toString().lastChars(10)}';
                              //                           }
                              //                         },
                              //                         icon: Icon(Icons
                              //                             .contact_page_sharp)),
                              //                     label: Text(
                              //                       'Login With Mobile No',
                              //                       style: TextStyle(
                              //                           color: Colors.black),
                              //                     ),
                              //                     border: OutlineInputBorder()),
                              //               ),
                              //             ),
                              //           ),
                              //           IgnorePointer(
                              //             ignoring: accountID == 1 ? true : false,
                              //             child: Padding(
                              //               padding: const EdgeInsets.only(
                              //                   top: 8.0, right: 8, left: 8),
                              //               child: Row(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment
                              //                         .spaceBetween,
                              //                 children: [
                              //                   Flexible(
                              //                     flex: 7,
                              //                     child: TextFormField(
                              //                       inputFormatters: [
                              //                         FilteringTextInputFormatter
                              //                             .allow(
                              //                           RegExp("[a-zA-Z0-9.]"),
                              //                         ),
                              //                       ],
                              //                       controller:
                              //                           _emailController,
                              //                       decoration: InputDecoration(
                              //                           focusedBorder:
                              //                               OutlineInputBorder(),
                              //                           fillColor: Colors.white,
                              //                           filled: true,
                              //                           suffix: Text(
                              //                             '@gmail.com',
                              //                             style: TextStyle(
                              //                                 color:
                              //                                     Colors.grey),
                              //                           ),
                              //                           label: Text(
                              //                             'Email Address',
                              //                             style: TextStyle(
                              //                                 color:
                              //                                     Colors.black),
                              //                           ),
                              //                           border:
                              //                               OutlineInputBorder()),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           ),
                              //           IgnorePointer(
                              //             ignoring: accountID == 1 ? true : false,
                              //             child: Padding(
                              //               padding: const EdgeInsets.only(
                              //                   top: 8.0, right: 8, left: 8),
                              //               child: Container(
                              //                 width: MediaQuery.of(context)
                              //                     .size
                              //                     .width,
                              //                 decoration: BoxDecoration(
                              //                     color: Colors.white,
                              //                     borderRadius:
                              //                         BorderRadius.circular(5),
                              //                     border: Border.all(
                              //                         color: Colors.grey)),
                              //                 child: Padding(
                              //                   padding:
                              //                       const EdgeInsets.all(4.0),
                              //                   child: Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment
                              //                             .spaceBetween,
                              //                     children: [
                              //                       Flexible(
                              //                         child: DropdownButton<
                              //                             String>(
                              //                           isExpanded: true,
                              //                           value:
                              //                               userRightsDropdownValue,
                              //                           icon: const Icon(
                              //                             Icons.arrow_downward,
                              //                             color: Colors.grey,
                              //                             size: 20,
                              //                           ),
                              //                           style: const TextStyle(
                              //                               color:
                              //                                   Colors.black),
                              //                           onChanged: (String?
                              //                               newValue) async {
                              //                             setState(() {
                              //                               userRightsDropdownValue =
                              //                                   newValue!;
                              //                             });
                              //
                              //                             if (action == 'ADD') {
                              //                               await _accountSQL.insertAccount3Name(
                              //                                   _nameOfPersonController
                              //                                       .text
                              //                                       .toString(),
                              //                                   dropDownMap[
                              //                                           'ID']
                              //                                       .toString(),
                              //                                   _accountNameController
                              //                                       .text,
                              //                                   _addressController
                              //                                       .text,
                              //                                   _phoneNoController
                              //                                       .text,
                              //                                   _emailController
                              //                                               .text
                              //                                               .toString()
                              //                                               .length >
                              //                                           0
                              //                                       ? '${_emailController.text}@gmail.com'
                              //                                       : '',
                              //                                   _countryCodeController
                              //                                       .text,
                              //                                   _mobileNoController
                              //                                       .text,
                              //                                   userRightsDropdownValue,
                              //                                   _remarksController
                              //                                       .text,
                              //                                   path);
                              //
                              //                               _accountNameController
                              //                                   .text = '';
                              //                               _addressController
                              //                                   .text = '';
                              //                               _phoneNoController
                              //                                   .text = '';
                              //                               _emailController
                              //                                   .text = '';
                              //                               _mobileNoController
                              //                                   .text = '';
                              //                               _remarksController
                              //                                   .text = '';
                              //                               path = null;
                              //                               setState(() {});
                              //                             } else {
                              //                               await _accountSQL.UpdateAccount3Name(
                              //                                   int.parse(args![
                              //                                           'ID']
                              //                                       .toString()),
                              //                                   int.parse(
                              //                                       dropDownMap[
                              //                                               "ID"]
                              //                                           .toString()),
                              //                                   _accountNameController
                              //                                       .text,
                              //                                   _addressController
                              //                                       .text,
                              //                                   _phoneNoController
                              //                                       .text,
                              //                                   _emailController
                              //                                               .text
                              //                                               .toString()
                              //                                               .length >
                              //                                           0
                              //                                       ? '${_emailController.text}@gmail.com'
                              //                                       : '',
                              //                                   _mobileNoController
                              //                                       .text,
                              //                                   userRightsDropdownValue,
                              //                                   _remarksController
                              //                                       .text,
                              //                                   context);
                              //                             }
                              //
                              //                             if (newValue ==
                              //                                 'Custom Right') {
                              //                               List list =
                              //                                   await _accountSQL
                              //                                       .getAccount4UserRightsData(
                              //                                           accountID!);
                              //
                              //                               List menuList =
                              //                                   await _accountSQL
                              //                                       .getProjectTable();
                              //
                              //                               print(
                              //                                   '/////////${menuList.length}/////////${list.length}');
                              //
                              //                               for (int count = 0;
                              //                                   count <
                              //                                       menuList
                              //                                           .length;
                              //                                   count++) {
                              //                                 bool check = true;
                              //                                 for (int j = 0;
                              //                                     j < list.length;
                              //                                     j++) {
                              //                                   Account4UserRightsModel
                              //                                       userRight =
                              //                                       list[j];
                              //                                   if (menuList[
                              //                                               count]
                              //                                           [
                              //                                           'MenuName'] ==
                              //                                       userRight
                              //                                           .menuName) {
                              //                                     check = false;
                              //
                              //                                     print(
                              //                                         '....$count......$j.......${menuList[count]['MenuName']}...');
                              //                                     break;
                              //                                   }
                              //                                 }
                              //
                              //                                 if (check) {
                              //                                   print(
                              //                                       '..............fffffffffffffffffffffffff............$count');
                              //                                   await _accountSQL.insertIntoCustonUserRight(
                              //                                       account3Id:
                              //                                           accountID!,
                              //                                       menuaname: menuList[count]
                              //                                               [
                              //                                               'MenuName']
                              //                                           .toString(),
                              //                                       view:
                              //                                           'true',
                              //                                       custonRightInserting:
                              //                                           'true',
                              //                                       customRightEiditing:
                              //                                           'true',
                              //                                       customRightDeleting:
                              //                                           'true',
                              //                                       customRightReporting:
                              //                                           'true',
                              //                                       sortBy: menuList[
                              //                                               count]
                              //                                           [
                              //                                           'SortBy'],
                              //                                       groupSortBy:
                              //                                           menuList[count]
                              //                                               [
                              //                                               'GroupSortBy']);
                              //                                 }
                              //                               }
                              //
                              //                               Navigator.push(
                              //                                 context,
                              //                                 MaterialPageRoute(
                              //                                     builder:
                              //                                         (context) =>
                              //                                             CustomUserRightsScreen(
                              //                                               menuName:
                              //                                                   widget.list![2]['menuName'],
                              //                                               account3Id:
                              //                                                   accountID!,
                              //                                               length:
                              //                                                   list.length,
                              //                                               action:
                              //                                                   'ADD',
                              //                                             )),
                              //                               );
                              //
                              //                               // Navigator.pop(context);
                              //
                              //                               widget.state(() {});
                              //                             }
                              //                           },
                              //                           items: <String>[
                              //                             'Not Allow Login',
                              //                             'Admin',
                              //                             'Statement View Only',
                              //                             'Custom Right'
                              //                           ].map<
                              //                               DropdownMenuItem<
                              //                                   String>>((String
                              //                               value) {
                              //                             return DropdownMenuItem<
                              //                                 String>(
                              //                               value: value,
                              //                               child: Text(value),
                              //                             );
                              //                           }).toList(),
                              //                         ),
                              //                       ),
                              //                       (userRightsDropdownValue ==
                              //                               "Custom Right")
                              //                           ? IconButton(
                              //                               onPressed:
                              //                                   () async {
                              //                                 List list =
                              //                                     await _accountSQL
                              //                                         .getAccount4UserRightsData(
                              //                                             accountID!);
                              //
                              //                                 List menuList =
                              //                                     await _accountSQL
                              //                                         .getProjectTable();
                              //
                              //                                 print(
                              //                                     '/////////${menuList.length}/////////${list.length}');
                              //
                              //                                 for (int count =
                              //                                         0;
                              //                                     count <
                              //                                         menuList
                              //                                             .length;
                              //                                     count++) {
                              //                                   bool check =
                              //                                       true;
                              //                                   for (int j = 0;
                              //                                       j < list.length;
                              //                                       j++) {
                              //                                     Account4UserRightsModel
                              //                                         userRight =
                              //                                         list[j];
                              //                                     if (menuList[
                              //                                                 count]
                              //                                             [
                              //                                             'MenuName'] ==
                              //                                         userRight
                              //                                             .menuName) {
                              //                                       check =
                              //                                           false;
                              //
                              //                                       print(
                              //                                           '....$count......$j.......${menuList[count]['MenuName']}...');
                              //                                       break;
                              //                                     }
                              //                                   }
                              //
                              //                                   if (check) {
                              //                                     print(
                              //                                         '..............fffffffffffffffffffffffff............$count');
                              //                                     await _accountSQL.insertIntoCustonUserRight(
                              //                                         account3Id:
                              //                                             accountID!,
                              //                                         menuaname:
                              //                                             menuList[count]['MenuName']
                              //                                                 .toString(),
                              //                                         view:
                              //                                             'true',
                              //                                         custonRightInserting:
                              //                                             'true',
                              //                                         customRightEiditing:
                              //                                             'true',
                              //                                         customRightDeleting:
                              //                                             'true',
                              //                                         customRightReporting:
                              //                                             'true',
                              //                                         sortBy: menuList[
                              //                                                 count]
                              //                                             [
                              //                                             'SortBy'],
                              //                                         groupSortBy:
                              //                                             menuList[count]
                              //                                                 [
                              //                                                 'GroupSortBy']);
                              //                                   }
                              //                                 }
                              //
                              //                                 print(accountID);
                              //
                              //                                 Navigator.push(
                              //                                   context,
                              //                                   MaterialPageRoute(
                              //                                       builder:
                              //                                           (context) =>
                              //                                               CustomUserRightsScreen(
                              //                                                 menuName: widget.list![2]['menuName'],
                              //                                                 account3Id: accountID!,
                              //                                                 length: list.length,
                              //                                                 action: 'EDIT',
                              //                                               )),
                              //                                 );
                              //                               },
                              //                               icon: Icon(
                              //                                   Icons.settings))
                              //                           :  const SizedBox(),
                              //                     ],
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ]),
                              //   ),
                              // ),

                              ///    optioanl fields..................................................
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 6.0, bottom: 6),
                                child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: ExpansionTile(
                                    title: Text('Optional Fields'),
                                    iconColor: Colors.black,
                                    collapsedIconColor: Colors.black,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, right: 8, left: 8),
                                        child: TextFormField(
                                          controller: _nameOfPersonController,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              fillColor: Colors.white,
                                              filled: true,
                                              label: Text(
                                                'Name of Person',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, right: 8, left: 8),
                                        child: TextFormField(
                                          controller: _addressController,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              fillColor: Colors.white,
                                              filled: true,
                                              label: Text(
                                                'Address',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, right: 8, left: 8),
                                        child: TextFormField(
                                          controller: _phoneNoController,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              fillColor: Colors.white,
                                              filled: true,
                                              label: Text(
                                                'PhoneNo',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, right: 8, left: 8),
                                        child: TextFormField(
                                          controller: _remarksController,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              fillColor: Colors.white,
                                              filled: true,
                                              label: Text(
                                                'Remarks',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Flexible(
                                child: ExpansionTile(
                                  title: Text('Required Fields'),
                                  initiallyExpanded: true,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            child: PopupMenuButton<String>(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              icon: Icon(Icons.more_horiz),
                                              onSelected: handleClick,
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return {
                                                  'Add Account Group',
                                                  'EDIT Account Group'
                                                }.map(
                                                  (String choice) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: choice,
                                                      child: Text(choice),
                                                    );
                                                  },
                                                ).toList();
                                              },
                                            ),
                                          ),
                                          FutureBuilder(
                                            future: _accountSQL
                                                .dropDownDataForAccount3Group(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                return Center(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      dropDownMap =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            DropDownStyle1(
                                                          acc1TypeList:
                                                              snapshot.data,
                                                          dropdown_title:
                                                              dropDownMap[
                                                                  'Title'],
                                                          map: dropDownMap,
                                                        ),
                                                      );
                                                      setState(() {});
                                                    },
                                                    child: DropDownStyle1State
                                                        .DropDownButton(
                                                      title:
                                                          dropDownMap['Title']
                                                              .toString(),
                                                      id: dropDownMap['ID']
                                                          .toString(),
                                                    ),
                                                  ),
                                                );
                                              }
                                              return CircularProgressIndicator();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8),
                                      child: TextFormField(
                                        controller: _accountNameController,
                                        decoration: InputDecoration(
                                            label: Text('Account Name'),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8, top: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Opening Balance :'),
                                                  Text('CB')
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4, top: 8),
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            _receivableController,
                                                        textAlign:
                                                            TextAlign.end,
                                                        decoration: InputDecoration(
                                                            label: Text(
                                                                'Receivable'),
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        20),
                                                            border:
                                                                OutlineInputBorder()),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4, top: 8),
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        textAlign:
                                                            TextAlign.end,
                                                        controller:
                                                            _payableController,
                                                        decoration: InputDecoration(
                                                            label:
                                                                Text('Payable'),
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        20),
                                                            border:
                                                                OutlineInputBorder()),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: ExpansionTile(
                                  title: Text('Optional Fields'),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8, left: 8),
                                      child: TextFormField(
                                        controller: _nameOfPersonController,
                                        decoration: InputDecoration(
                                            label: Text('Name of Person'),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8, left: 8),
                                      child: TextFormField(
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                            label: Text('Address'),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8, left: 8),
                                      child: TextFormField(
                                        controller: _phoneNoController,
                                        decoration: InputDecoration(
                                            label: Text('PhoneNo'),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8, left: 8),
                                      child: TextFormField(
                                        controller: _remarksController,
                                        decoration: InputDecoration(
                                            label: Text('Remarks'),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: ExpansionTile(
                                  title: Text('Login Right'),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8, left: 8),
                                      child: FutureBuilder(
                                        future: Provider.of<
                                                    AuthenticationProvider>(
                                                context,
                                                listen: false)
                                            .getAllDataFromCountryCodeTable(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.hasData) {
                                            return Center(
                                              child: InkWell(
                                                onTap: () async {
                                                  dropDownForCountry =
                                                      await showDialog(
                                                    context: context,
                                                    builder: (_) => country
                                                        .DropDownStyle1Image(
                                                      acc1TypeList:
                                                          snapshot.data,
                                                      map: dropDownForCountry,
                                                    ),
                                                  );
                                                  setState(() {
                                                    if (_mobileNoController.text
                                                            .toString()
                                                            .length ==
                                                        0) {
                                                      countryCode =
                                                          dropDownForCountry[
                                                                  'CountryCode']
                                                              .toString();

                                                      _mobileNoController.text =
                                                          dropDownForCountry[
                                                                  'CountryCode']
                                                              .toString();
                                                    }
                                                  });
                                                },
                                                child:
                                                    country.DropDownStyle1State
                                                        .DropDownButton(
                                                  title: dropDownForCountry[
                                                          'CountryName']
                                                      .toString(),
                                                  id: dropDownForCountry[
                                                          'CountryCode']
                                                      .toString(),
                                                  image: dropDownForCountry[
                                                          'Image']
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8, left: 8),
                                      child: TextFormField(
                                        controller: _mobileNoController,
                                        decoration: InputDecoration(
                                            //  prefixText: countryCode,
                                            suffixIcon: IconButton(
                                                onPressed: () async {
                                                  if (countryCode.length == 0 &&
                                                      _mobileNoController.text
                                                              .toString()
                                                              .length ==
                                                          0) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Center(
                                                            child: SizedBox(
                                                              height: 200,
                                                              child:
                                                                  AlertDialog(
                                                                content: Text(
                                                                    'Please Select Country First!'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        'ok'),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  } else {
                                                    String? number;
                                                    Contact? contacts =
                                                        await ContactsService
                                                            .openDeviceContactPicker();
                                                    contacts!.phones!
                                                        .forEach((element) {
                                                      number = element.value;
                                                    });
                                                    number!
                                                        .trim()
                                                        .toString()
                                                        .lastChars(9);
                                                    _mobileNoController.text =
                                                        '$countryCode${number!.trim().toString().lastChars(10)}';
                                                  }
                                                },
                                                icon: Icon(
                                                    Icons.contact_page_sharp)),
                                            label: Text('Login With Mobile No'),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8, left: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 7,
                                            child: TextFormField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp("[a-zA-Z0-9.]"),
                                                ),
                                              ],
                                              controller: _emailController,
                                              decoration: InputDecoration(
                                                  suffix: Text(
                                                    '@gmail.com',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  label: Text('Email Address'),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                          // Flexible(
                                          //   flex: 3,
                                          //   child: Center(
                                          //     child: Text('gmail.com'),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8, left: 8),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  value:
                                                      userRightsDropdownValue,
                                                  icon: const Icon(
                                                    Icons.arrow_downward,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  onChanged:
                                                      (String? newValue) async {
                                                    setState(() {
                                                      userRightsDropdownValue =
                                                          newValue!;

                                                      if (action == 'ADD') {
                                                        _accountSQL.insertAccount3Name(
                                                            _nameOfPersonController
                                                                .text
                                                                .toString(),
                                                            dropDownMap['ID']
                                                                .toString(),
                                                            _accountNameController
                                                                .text,
                                                            _addressController
                                                                .text,
                                                            _phoneNoController
                                                                .text,
                                                            _emailController.text
                                                                        .toString()
                                                                        .length >
                                                                    0
                                                                ? '${_emailController.text}@gmail.com'
                                                                : '',
                                                            _countryCodeController
                                                                .text,
                                                            _mobileNoController
                                                                .text,
                                                            userRightsDropdownValue,
                                                            _remarksController
                                                                .text,
                                                            path);
                                                        if (_receivableController
                                                                .text
                                                                .toString()
                                                                .length !=
                                                            0) {
                                                          if (int.parse(
                                                                  _receivableController
                                                                      .text
                                                                      .toString()) >
                                                              0) {
                                                            print(
                                                                '....................rece.........................');
                                                            _cashBookSQL.insertCashBook(
                                                                currentDate
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10),
                                                                accountID
                                                                    .toString(),
                                                                '7',
                                                                '',
                                                                _receivableController
                                                                    .text
                                                                    .toString(),
                                                                'CB',
                                                                '',
                                                                '',
                                                                currentDate
                                                                    .toString(),
                                                                '');
                                                          }
                                                        }

                                                        if (_payableController
                                                                .text
                                                                .toString()
                                                                .length !=
                                                            0) {
                                                          if (int.parse(
                                                                  _payableController
                                                                      .text
                                                                      .toString()) >
                                                              0) {
                                                            print(
                                                                '....................pay.........................');
                                                            _cashBookSQL.insertCashBook(
                                                                currentDate
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10),
                                                                '8',
                                                                accountID
                                                                    .toString(),
                                                                '',
                                                                _payableController
                                                                    .text
                                                                    .toString(),
                                                                'CB',
                                                                '',
                                                                '',
                                                                currentDate
                                                                    .toString(),
                                                                '');
                                                          }
                                                        }

                                                        _accountNameController
                                                            .text = '';
                                                        _addressController
                                                            .text = '';
                                                        _phoneNoController
                                                            .text = '';
                                                        _emailController.text =
                                                            '';
                                                        _mobileNoController
                                                            .text = '';
                                                        _remarksController
                                                            .text = '';
                                                        path = null;
                                                        setState(() {});
                                                      }
                                                    });
                                                    if (newValue ==
                                                        'Custom Right') {
                                                      print(
                                                          '/////////////////////////////////////////////////vvvvvv');

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CustomUserRightsScreen(
                                                                  menuName: widget
                                                                          .list![2]
                                                                      [
                                                                      'menuName'],
                                                                  account3Id:
                                                                      accountID!,
                                                                  action: 'ADD',
                                                                )),
                                                      );
                                                    }
                                                  },
                                                  items: <String>[
                                                    'Not Allow Login',
                                                    'Admin',
                                                    'Statement View Only',
                                                    'Custom Right'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              (userRightsDropdownValue ==
                                                      "Custom Right")
                                                  ? IconButton(
                                                      onPressed: () async {
                                                        print(accountID);
                                                        print(
                                                            '..............................................................');
                                                        if (action == 'ADD'
                                                            // &&
                                                            // await _accountSQL.insertAccount3Name(
                                                            //     dropDownMap['ID']
                                                            //         .toString(),
                                                            //     _accountNameController
                                                            //         .text,
                                                            //     _addressController
                                                            //         .text,
                                                            //     _phoneNoController
                                                            //         .text,
                                                            //     _emailController.text,
                                                            //     _countryCodeController
                                                            //         .text,
                                                            //     _mobileNoController
                                                            //         .text,
                                                            //     userRightsDropdownValue,
                                                            //     _remarksController
                                                            //         .text,
                                                            //     path)

                                                            ) {
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //       builder: (context) =>
                                                          //           CustomUserRightsScreen(
                                                          //             account3Id:
                                                          //                 maxId!,
                                                          //             action: 'ADD',
                                                          //           )),
                                                          // );
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CustomUserRightsScreen(
                                                                          menuName:
                                                                              widget.list![2]['menuName'],
                                                                          account3Id:
                                                                              accountID!,
                                                                          action:
                                                                              'EDIT',
                                                                        )),
                                                          );
                                                        }

                                                        // if(action == 'ADD' &&
                                                        //     await obj.insertAccount3Name(
                                                        //         dropDownMap['ID'].toString(),
                                                        //         account_name_controller.text,
                                                        //         address_controller.text,
                                                        //         phone_no_controller.text,
                                                        //         email_controller.text,
                                                        //         country_code_controller.text,
                                                        //         mobile_no_controller.text,
                                                        //         userRightsDropdownValue,
                                                        //         remarks_controller.text,
                                                        //         path)
                                                        // ){
                                                        //   Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(builder: (context) => CustomUserRightsScreen(account3Id: maxId!,action: 'ADD',)),
                                                        //   );
                                                        // }else{
                                                        //   Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(builder: (context) => CustomUserRightsScreen(account3Id: maxId!,action: 'EDIT',)),
                                                        //   );
                                                        // }
                                                      },
                                                      icon:
                                                          Icon(Icons.settings))
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),

                /// save button ////////////////////////////////////////////////////////
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // background
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ) // foreground
                              ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (action == 'ADD') {
                                await _accountSQL.insertAccount3Name(
                                    _nameOfPersonController.text.toString(),
                                    dropDownMap['ID'].toString(),
                                    _accountNameController.text,
                                    _addressController.text,
                                    _phoneNoController.text,
                                    _emailController.text.toString().length > 0
                                        ? '${_emailController.text}@gmail.com'
                                        : '',
                                    _countryCodeController.text,
                                    _mobileNoController.text,
                                    userRightsDropdownValue,
                                    _remarksController.text,
                                    path);
                                // if (path != null) {
                                //   // uploadImage(base64Encode(File(path.toString()).readAsBytesSync()));
                                // }

                                if (_receivableController.text
                                        .toString()
                                        .length !=
                                    0) {
                                  if (int.parse(_receivableController.text
                                          .toString()) >
                                      0) {
                                    print(
                                        '....................rece.........................');
                                    await _cashBookSQL.insertCashBook(
                                        currentDate.toString().substring(0, 10),
                                        accountID.toString(),
                                        '7',
                                        '',
                                        _receivableController.text.toString(),
                                        'CB',
                                        '',
                                        '',
                                        currentDate.toString(),
                                        '');
                                  }
                                }

                                if (_payableController.text.toString().length !=
                                    0) {
                                  if (int.parse(
                                          _payableController.text.toString()) >
                                      0) {
                                    print(
                                        '....................pay.........................');
                                    await _cashBookSQL.insertCashBook(
                                        currentDate.toString().substring(0, 10),
                                        '8',
                                        accountID.toString(),
                                        '',
                                        _payableController.text.toString(),
                                        'CB',
                                        '',
                                        '',
                                        currentDate.toString(),
                                        '');
                                  }
                                }
                              } else {
                                await _accountSQL.UpdateAccount3Name(
                                    int.parse(args!['ID'].toString()),
                                    int.parse(dropDownMap["ID"].toString()),
                                    _accountNameController.text,
                                    _addressController.text,
                                    _phoneNoController.text,
                                    _emailController.text.toString().length > 0
                                        ? '${_emailController.text}@gmail.com'
                                        : '',
                                    _mobileNoController.text,
                                    userRightsDropdownValue,
                                    _remarksController.text,
                                    context);
                                if (mapRec.length != 0) {
                                  if (_receivableController.text
                                          .toString()
                                          .length !=
                                      0) {
                                    if (int.parse(_receivableController.text
                                            .toString()) >
                                        0) {
                                      print(
                                          '....................rece.........................');
                                      await _cashBookSQL.UpdateCashBook(
                                          mapRec[0]['CashBookID'],
                                          mapRec[0]['CBDate'].toString(),
                                          accountID.toString(),
                                          '7',
                                          mapRec[0]['CBRemarks'].toString(),
                                          _receivableController.text.toString(),
                                          mapRec[0]['EntryTime'].toString());
                                    }
                                  }
                                } else {
                                  if (_receivableController.text
                                          .toString()
                                          .length !=
                                      0) {
                                    if (int.parse(_receivableController.text
                                            .toString()) >
                                        0) {
                                      print(
                                          '....................rece.........................');
                                      await _cashBookSQL.insertCashBook(
                                          currentDate
                                              .toString()
                                              .substring(0, 10),
                                          accountID.toString(),
                                          '7',
                                          '',
                                          _receivableController.text.toString(),
                                          'CB',
                                          '',
                                          '',
                                          currentDate.toString(),
                                          '');
                                    }
                                  }
                                }
                                if (mapPay.length != 0) {
                                  if (_payableController.text
                                          .toString()
                                          .length !=
                                      0) {
                                    if (int.parse(_payableController.text
                                            .toString()) >
                                        0) {
                                      print(
                                          '....................pay.........................');
                                      await _cashBookSQL.UpdateCashBook(
                                          mapRec[0]['CashBookID'],
                                          mapRec[0]['CBDate'].toString(),
                                          '8',
                                          accountID.toString(),
                                          mapRec[0]['CBRemarks'].toString(),
                                          _receivableController.text.toString(),
                                          mapRec[0]['EntryTime'].toString());
                                    }
                                  }
                                } else {
                                  if (_payableController.text
                                          .toString()
                                          .length !=
                                      0) {
                                    if (int.parse(_payableController.text
                                            .toString()) >
                                        0) {
                                      print(
                                          '....................pay.........................');
                                      await _cashBookSQL.insertCashBook(
                                          currentDate
                                              .toString()
                                              .substring(0, 10),
                                          '8',
                                          accountID.toString(),
                                          '',
                                          _payableController.text.toString(),
                                          'CB',
                                          '',
                                          '',
                                          currentDate.toString(),
                                          '');
                                    }
                                  }
                                }
                              }
                              _accountNameController.text = '';
                              _addressController.text = '';
                              _phoneNoController.text = '';
                              _emailController.text = '';
                              _mobileNoController.text = '';
                              _receivableController.text = '';
                              _payableController.text = '';
                              _remarksController.text = '';
                              path = null;

                              Navigator.pop(context);

                              widget.state(() {});
                            }
                          },
                          child: Text((action == 'EDIT') ? "Edit" : "Save")),
                    ),
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
                            // if (await Provider.of<MySqlProvider>(context,
                            //         listen: false)
                            //     .connectToServerDb()) {
                            //   ///    Account2Group   //////// sc
                            //   var maxDate3 = await refreshing
                            //       .updateAccount2GroupDataToServer(context);
                            //   await refreshing
                            //       .insertAccount2GroupDataToServer(context);
                            //   await refreshing.getTableDataFromServeToInSqlite(
                            //       context, 'Account2Group', maxDate3);
                            //
                            //   ///    Account3Name   //////// sc
                            //   var maxDate = await refreshing
                            //       .updateAccount3NameDataToServer(context);
                            //   await refreshing
                            //       .account3NameDataInsertToServer(context);
                            //   await refreshing.getTableDataFromServeToInSqlite(
                            //       context, 'Account3Name', maxDate);
                            // }
                            Navigator.pop(context);

                            widget.state(() {});
                          },
                          child: Text(
                            'CLOSE',
                          )),
                    ),
                  ],
                ),
                // Text("error box"),
                // Text(errorMessage.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadImage(String base64Image) async {
    Uri url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.uploadImageWithPath}');
    print(base64Image);
    try {
      var response = await http.post(url, body: {
        // 'DisplayImage':base64Image,
        // 'Name':"logo.jpg",
        // 'ClientID':SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId).toString(),
        'DisplayImage': base64Image,
        'ImageName': "logo.jpg",
        //'ClientID':SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId).toString(),
        'ImagePath': 'ClientImages/3/AccountName',
      });
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        print(map);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> _initDir(String accountId) async {
    if (null == dir) {
      if (Platform.isWindows) {
        Directory? directory = await getApplicationDocumentsDirectory();
        dir = directory.path;
      } else {
        List<Directory>? list = (await getExternalStorageDirectories());
        dir = list![0].path;
      }

      if (File(
              '$dir/ClientImages/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/AccountImages/$accountId.jpg')
          .existsSync()) {
        if (mounted) {
          setState(() {
            path =
                '$dir/ClientImages/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/AccountImages/$accountId.jpg';
          });
        } else {
          path =
              '$dir/ClientImages/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/AccountImages/$accountId.jpg';
        }
      }
    }
  }
}
