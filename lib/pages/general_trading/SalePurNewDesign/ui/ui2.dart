import 'dart:math';

import 'package:com/pages/general_trading/SalePur/SalePur2AddItemUISingle.dart';
import 'package:com/pages/general_trading/SalePur/sale_pur1_SQL.dart';
import 'package:com/pages/general_trading/SalePurNewDesign/components/item_table.dart';
import 'package:com/pages/tailor_shop_systom/widgets.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../material/datepickerstyle1.dart';
import '../../../material/drop_down_style1.dart';
import '../components/custom_input_text_field.dart';
import '../components/custom_round_button.dart';



class UI2 extends StatefulWidget {
  String appbarTitle, salPur1ID, menuName, accountName;
  String accountID;
  final Map dropDown;
  UI2(
      {super.key,
      this.appbarTitle = '',
      this.salPur1ID = '',
      this.menuName = '',
      this.accountID = '',
      this.accountName = '',
      required this.dropDown});

  @override
  State<UI2> createState() => _UI2State();
}

class _UI2State extends State<UI2> {
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  TextEditingController date_controller = TextEditingController();
  final _cashController = TextEditingController();
  final _contactNoController = TextEditingController();
  final _nameOfPersonController = TextEditingController();
  final _remarksController = TextEditingController();
  final _contactNoFocusNode = FocusNode();
  final _nameOFPersonFocusNode = FocusNode();
  final _remarksFocusNode = FocusNode();
  final _payDueDateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  late double h;
  late double w;

  DateTime currentDate = DateTime.now();

  Color myColor = Color(Random().nextInt(0xffffffff));

  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;
  Map dropDownAccountNameMap = {
    "ID": null,
    'Title': '',
    'SubTitle': null,
    "Value": null
  };
  late List<dynamic> _snapData;

  Future<List<dynamic>> getSalePurchase2Data() async {
    final data = await _salePurSQLDataBase.SalePur2Data(
        salePur1Id1: widget.salPur1ID.toString(),
        entryType: widget.dropDown['SubTitle']);

    return data;
  }

  Future<void> _getData() async {
    List<dynamic> result = await _salePurSQLDataBase.getSalePur1DataForInvoice(
      salPur1ID: widget.salPur1ID,
      entryType: widget.dropDown['SubTitle'],
    );
    setState(() {
      _snapData = result;

      date_controller.text = DateFormat(SharedPreferencesKeys.prefs!
              .getString(SharedPreferencesKeys.dateFormat))
          .format(DateTime(
              int.parse(_snapData[0]['Date'].substring(0, 4)),
              int.parse(_snapData[0]['Date'].substring(
                5,
                7,
              )),
              int.parse(_snapData[0]['Date'].substring(8, 10))))
          .toString();
      _cashController.text = _snapData[0]['Account Name'];
      _contactNoController.text = _snapData[0]['ContactNo'];
      _payDueDateController.text = _snapData[0]['PayAfterDay'];
      _nameOfPersonController.text = _snapData[0]['NameOfPerson'];
      _remarksController.text = _snapData[0]['Remarks'];
    });
  }

  @override
  void initState() {
    // date_controller.text=currentDate.
    _snapData = [];
    if (widget.accountID != '' && widget.accountName != '') {
      dropDownAccountNameMap['ID'] = widget.accountID.toString();
      dropDownAccountNameMap['Title'] = widget.accountName.toString();
    }
    ////////////////////////////////////////////////
    // default account value///////////////
    //////////////////////////////////////////////////

    if (SharedPreferencesKeys.prefs!
            .getString(SharedPreferencesKeys.defaultSaleTwoAccountName) ==
        null) {
      SharedPreferencesKeys.prefs!
          .setInt(SharedPreferencesKeys.defaultSaleTwoAccount, 2);

      SharedPreferencesKeys.prefs!
          .setString(SharedPreferencesKeys.defaultSaleTwoAccountName, 'Cash');
    }

    super.initState();
    _getData();
  }

  final _formKey = GlobalKey<FormState>();

  bool isVisible = false;
  bool isVisibleForSaveButton = true;

  bool isVisibleForEditMode = true;
  bool isVisibleForSaveEditMode = false;

  bool isObsorbPionterEdit = true;
  bool isObsorbPionterForAdd = false;

  @override
  Widget build(BuildContext context) {

    final entryType = widget.dropDown['SubTitle'];
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    // this calculation is for adding the data for add filed
    Future<List<dynamic>> tableData = getSalePurchase2Data();
    int defaultDropDownAccountNameMapID = 2;
    if (dropDownAccountNameMap['ID'] != null) {
      defaultDropDownAccountNameMapID =
          int.tryParse(dropDownAccountNameMap['ID'])!;
    }

    date_controller.text = DateFormat(SharedPreferencesKeys.prefs!
            .getString(SharedPreferencesKeys.dateFormat))
        .format(DateTime(
            int.parse(selectedDate.toString().substring(0, 4)),
            int.parse(selectedDate.toString().substring(
                  5,
                  7,
                )),
            int.parse(selectedDate.toString().substring(8, 10))))
        .toString();

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.appbarTitle} ${widget.salPur1ID}"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.appbarTitle == 'Edit')
              if (_snapData.isNotEmpty)
                ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      //passing the the coming data to data variable data
                      dynamic snap = _snapData;
                      dynamic data = snap[index];
                      // here i am calling the function to get the table data and

                      Future<List<dynamic>> tableData = getSalePurchase2Data();

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AbsorbPointer(
                            absorbing: isObsorbPionterEdit,
                            child: _formUI(),
                          ),
                          SizedBox(height: h * 0.02),
                          ItemTable1(
                            tableData: tableData,
                          ),
                          TotalPrice(billAmount: data['BillAmount'].toString()),
                          _addButtonUI(defaultDropDownAccountNameMapID),
                          SizedBox(height: h * 0.03),
                          Visibility(
                            visible: isVisibleForSaveEditMode,
                            child: CustomRoundButton2(
                              title: 'Save',
                              buttonColor: Colors.green,
                              onTap: () {
                                setState(() {});
                                _updateSalPur1(
                                    data['ID'],
                                    defaultDropDownAccountNameMapID,
                                    _nameOfPersonController.text,
                                    _remarksController.text,
                                    _contactNoController.text.toString(),
                                    _payDueDateController.text.toString(),
                                    entryType,
                                    date_controller.text.toString(),
                                    context);
                              },
                            ),
                          ),
                          Visibility(
                              visible: isVisibleForEditMode,
                              child: buttonContainer()),
                        ],
                      );
                    }),
            if (widget.appbarTitle == 'Add')
              Column(
                children: [
                  AbsorbPointer(
                    absorbing: isObsorbPionterForAdd,
                    child: _formUI(),
                  ),
                  SizedBox(height: h * 0.02),
                  ItemTable1(tableData: tableData),
                  if (widget.salPur1ID != '')
                    FutureBuilder<dynamic>(
                        future: _salePurSQLDataBase.getSalePur1DataForInvoice(
                            salPur1ID: widget.salPur1ID, entryType: entryType),
                        builder: (context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data[0];
                            return TotalPrice(
                                billAmount: data['BillAmount'].toString() == ''
                                    ? '00'
                                    : data['BillAmount'].toString());
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  _addButtonUI(defaultDropDownAccountNameMapID),
                  SizedBox(height: h * 0.03),
                  Visibility(
                      visible: isVisibleForSaveButton,
                      child: _insertNewDataInSalPur1(
                          defaultDropDownAccountNameMapID)),
                  Visibility(visible: isVisible, child: buttonContainer())
                ],
              ),
            SizedBox(height: h * 0.03),
          ],
        ),
      )),
    );
  }

  Widget buttonContainer() {
    return Column(
      children: [
        CustomRoundButton(
          title: 'Edit',
          buttonColor: Colors.teal,
          onTap: () async {
            if (widget.appbarTitle == 'Edit') {
              isVisibleForEditMode = false;
              isVisibleForSaveEditMode = true;
              isObsorbPionterEdit = false;
              setState(() {});
            } else {
              setState(() {
                isVisible = false;
                isVisibleForSaveButton = true;
                isObsorbPionterForAdd=false;
              });
            }
          },
        ),
        CustomRoundButton(
          title: 'Add New Invoice',
          buttonColor: Color(0xff2f5596),
          onTap: () async {
            isVisible = false;
            isVisibleForSaveButton = true;
            setState(() {
              widget.salPur1ID = '';
              _remarksController.clear();
              _nameOfPersonController.clear();
              _contactNoController.clear();
            });
          },
        ),
        CustomRoundButton(
          title: 'Print',
          buttonColor: Colors.black,
          onTap: () {},
        ),
        CustomRoundButton(
          title: 'Print Preview',
          buttonColor: Color(0xff7d8080),
          onTap: () {},
        ),
        CustomRoundButton(
            title: "What's App", buttonColor: Colors.green, onTap: () {}),
      ],
    );
  }

  Widget _formUI() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _customText('Invoice Date:'),
          SizedBox(height: 4),
          SizedBox(
            height: 50,
            child: TextField(
              controller: date_controller,
              readOnly: true,
              onTap: () async {
                selectedDate = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => DatePickerStyle1()));

                date_controller.text = DateFormat(SharedPreferencesKeys.prefs!
                        .getString(SharedPreferencesKeys.dateFormat))
                    .format(DateTime(
                        int.parse(selectedDate.toString().substring(0, 4)),
                        int.parse(selectedDate.toString().substring(
                              5,
                              7,
                            )),
                        int.parse(selectedDate.toString().substring(8, 10))))
                    .toString();

                setState(() {});
              },
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(),
                  focusColor: Colors.black,
                  fillColor: Colors.white,
                  filled: true,
                  suffix: Icon(Icons.expand_more),
                  label: Text(
                    'Date',
                    style: TextStyle(color: Colors.black),
                  ),
                  border: OutlineInputBorder()),
            ),
          ),
          _customText('Account Name:'),
          FutureBuilder(
            future: _salePurSQLDataBase.dropDownData1(),
            //getting the dropdown data from query
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: InkWell(
                      onTap: () async {
                        dropDownAccountNameMap = await showDialog(
                          context: context,
                          builder: (_) => DropDownStyle1(
                            acc1TypeList: snapshot.data,
                            dropdown_title: dropDownAccountNameMap['Title'],
                            map: dropDownAccountNameMap,
                            titleFor: 'Sale',
                          ),
                        );
                        setState(() {});
                      },
                      child: DropDownButton(
                        title: dropDownAccountNameMap['Title'].toString(),
                        id: dropDownAccountNameMap['ID'].toString(),
                      )),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          _customText('Remarks:'),
          CustomInputTextField(
            myController: _remarksController,
            focusNode: _remarksFocusNode,
            onFieldSubmittedValue: (e) {},
            hint: 'remarks',
            onValidator: (e) {},
            keyBoardType: TextInputType.datetime,
          ),
          _customText('Name Of Person:'),
          CustomInputTextField(
            myController: _nameOfPersonController,
            focusNode: _nameOFPersonFocusNode,
            onFieldSubmittedValue: (e) {},
            hint: 'Name Of Person',
            onValidator: (e) {},
            keyBoardType: TextInputType.datetime,
          ),
          _customText('Contact No:'),
          CustomInputTextField(
            myController: _contactNoController,
            focusNode: _contactNoFocusNode,
            onFieldSubmittedValue: (e) {},
            hint: 'Contact No',
            onValidator: (e) {},
            keyBoardType: TextInputType.datetime,
          ),
          _customText('Payment Due Date:'),
          SizedBox(
            height: 50,
            child: TextField(
              controller: _payDueDateController,
              readOnly: true,
              onTap: () async {
                selectedDate = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => DatePickerStyle1()));

                _payDueDateController.text = DateFormat(SharedPreferencesKeys
                        .prefs!
                        .getString(SharedPreferencesKeys.dateFormat))
                    .format(DateTime(
                        int.parse(selectedDate.toString().substring(0, 4)),
                        int.parse(selectedDate.toString().substring(
                              5,
                              7,
                            )),
                        int.parse(selectedDate.toString().substring(8, 10))))
                    .toString();

                setState(() {});
              },
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(),
                  focusColor: Colors.black,
                  fillColor: Colors.white,
                  filled: true,
                  suffix: Icon(Icons.expand_more),
                  label: Text(
                    'Payment Due Date',
                    style: TextStyle(color: Colors.black),
                  ),
                  border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addButtonUI(int accountId) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [_addButton(accountId), _addBySelectionButton()],
      ),
    );
  }

  Widget _addButton(int accountId) {
    return FutureBuilder(
      future: _salePurSQLDataBase.userRightsChecking(widget.menuName),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                print('${snapshot.data!}..............................');
                if (SharedPreferencesKeys.prefs!
                        .getString(SharedPreferencesKeys.userRightsClient) ==
                    'Custom Right') {
                  if (snapshot.data![0]['Inserting'].toString() == 'true') {
                    print(
                        '.......current date.......${currentDate.toString().substring(0, 10)}...........');
                    var salePur1ID;

                    if (widget.salPur1ID.isEmpty) {
                      salePur1ID = await _salePurSQLDataBase.insertSalePur1(
                          currentDate.toString().substring(0, 10),
                          accountId,
                          'remarks',
                          'person',
                          'paymentAfterDate',
                          'contactNo',
                          widget.dropDown);
                      widget.salPur1ID = salePur1ID.toString();
                    } else {
                      salePur1ID = int.tryParse(widget.salPur1ID);
                    }

                    print(
                        '...........${widget.dropDown['SubTitle']}.............salePur1 ID..............$salePur1ID');
                    await showGeneralDialog(
                        context: context,
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return AnimatedContainer(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            duration: const Duration(milliseconds: 300),
                            alignment: Alignment.center,
                            child: SalesPur2Dialog(
                              accountID: accountId,
                              id: salePur1ID,
                              contactNo: 'contactNo',
                              NameOfPerson: 'NameOfPerson',
                              PaymentAfterDate: 'PayAfterDay',
                              remarks: 'Remarks',
                              date: currentDate.toString().substring(0, 10),
                              accountName: SharedPreferencesKeys.prefs!
                                  .getString(SharedPreferencesKeys
                                      .defaultSaleTwoAccountName),
                              EntryType: widget.dropDown['SubTitle'],
                              salePur1Id: salePur1ID,
                              map: {},
                              action: 'ADD',
                            ),
                          );
                        });

                    print(
                        '.....................setSate////////////////////////');

                    setState(() {});
                  }
                } else if (SharedPreferencesKeys.prefs!
                        .getString(SharedPreferencesKeys.userRightsClient) ==
                    'Admin') {
                  print(
                      '.......current date.......${currentDate.toString().substring(0, 10)}...........');

                  var salePur1ID;
                  if (widget.salPur1ID.isEmpty) {
                    salePur1ID = await _salePurSQLDataBase.insertSalePur1(
                        currentDate.toString().substring(0, 10),
                        accountId,
                        'remarks',
                        'person',
                        'paymentAfterDate',
                        'contactNo',
                        widget.dropDown);
                    widget.salPur1ID = salePur1ID.toString();
                  } else {
                    salePur1ID = int.tryParse(widget.salPur1ID);
                  }

                  print(
                      '...........${widget.dropDown['SubTitle']}.............salePur1 ID..............$salePur1ID');
                  await showGeneralDialog(
                      context: context,
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return AnimatedContainer(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          duration: const Duration(milliseconds: 300),
                          alignment: Alignment.center,
                          child: SalesPur2Dialog(
                            accountID: accountId,
                            id: salePur1ID,
                            contactNo: 'contactNo',
                            NameOfPerson: 'NameOfPerson',
                            PaymentAfterDate: 'PayAfterDay',
                            remarks: 'Remarks',
                            date: currentDate.toString().substring(0, 10),
                            accountName: SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys
                                    .defaultSaleTwoAccountName),
                            EntryType: widget.dropDown['SubTitle'],
                            salePur1Id: salePur1ID,
                            map: {},
                            action: 'ADD',
                          ),
                        );
                      });

                  print('.....................setSate////////////////////////');

                  setState(() {});
                }
              },
              child: Text(
                '+ Add Item By Typing',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _insertNewDataInSalPur1(int dropDownId) {
    return FutureBuilder(
      future: _salePurSQLDataBase.userRightsChecking(widget.menuName),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Align(
            alignment: Alignment.center,
            child: CustomRoundButton2(
              title: 'Save',
              buttonColor: Colors.green,
              onTap: () async {
                isObsorbPionterForAdd=true;

                print('${snapshot.data!}..............................');
                if (SharedPreferencesKeys.prefs!
                        .getString(SharedPreferencesKeys.userRightsClient) ==
                    'Custom Right') {
                  if (snapshot.data![0]['Inserting'].toString() == 'true') {
                    print(
                        '.......current date.......${currentDate.toString().substring(0, 10)}...........');
                    var salePur1ID;

                    if (widget.salPur1ID.isEmpty) {
                      salePur1ID = await _salePurSQLDataBase.insertSalePur1(
                          currentDate.toString().substring(0, 10),
                          SharedPreferencesKeys.prefs!.getInt(
                              SharedPreferencesKeys.defaultSaleTwoAccount),
                          _remarksController.text.toString(),
                          _nameOfPersonController.text.toString(),
                          _payDueDateController.text.toString(),
                          _contactNoController.text.toString(),
                          widget.dropDown);
                      widget.salPur1ID = salePur1ID.toString();
                    } else {
                      salePur1ID = int.tryParse(widget.salPur1ID);
                    }
                    isVisible = true;
                    isVisibleForSaveButton = false;

                    print(
                        '...........${widget.dropDown['SubTitle']}.............salePur1 ID..............$salePur1ID');

                    print(
                        '.....................setSate////////////////////////');

                    setState(() {});
                  }
                } else if (SharedPreferencesKeys.prefs!
                        .getString(SharedPreferencesKeys.userRightsClient) ==
                    'Admin') {
                  print(
                      '.......current date.......${currentDate.toString().substring(0, 10)}...........');

                  var salePur1ID;
                  if (widget.salPur1ID.isEmpty) {
                    salePur1ID = await _salePurSQLDataBase.insertSalePur1(
                        currentDate.toString().substring(0, 10),
                        dropDownId,
                        _remarksController.text.toString(),
                        _nameOfPersonController.text.toString(),
                        _payDueDateController.text.toString(),
                        _contactNoController.text.toString(),
                        widget.dropDown);
                    widget.salPur1ID = salePur1ID.toString();
                  } else {
                    salePur1ID = int.tryParse(widget.salPur1ID);
                  }
                  isVisible = true;
                  isVisibleForSaveButton = false;
                  print('data added');

                  print(
                      '...........${widget.dropDown['SubTitle']}.............salePur1 ID..............$salePur1ID');

                  print('.....................setSate////////////////////////');

                  setState(() {});
                }
              },
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _customText(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.grey),
    );
  }

  Widget _addBySelectionButton() {
    return TextButton(
        onPressed: () {},
        child: Text(
          '+ Add item By Selection',
          style: TextStyle(color: Colors.blue),
        ));
  }

  void _updateSalPur1(
      int id,
      int ACNameID,
      String NameOfPerson,
      String remarks,
      String ContactNo,
      String PaymentAfterDate,
      String EntryType,
      String SPDate,
      BuildContext context) async {
    try {
      await _salePurSQLDataBase.UpdateSalePur1(
        id: id,
        ACNameID: ACNameID,
        remarks: remarks,
        NameOfPerson: NameOfPerson,
        ContactNo: ContactNo,
        PaymentAfterDate: PaymentAfterDate,
        EntryType: EntryType,
        SPDate: SPDate,
        context: context,
      );
      print('update done');
    } catch (e) {
      print('error while updating the data');
    }
  }
}
