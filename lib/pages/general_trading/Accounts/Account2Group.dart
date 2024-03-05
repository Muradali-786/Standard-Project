
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Server/RefreshDataProvider.dart';
import '../../../Server/mysql_provider.dart';
import '../../../main/tab_bar_pages/home/themedataclass.dart';
import '../../material/drop_down_style1.dart';
import 'AccountSQL.dart';

class Account2GroupDesign extends StatefulWidget {
  final String? title;
  final int? id;
  final String? subtitle;
  final String? action;
  final Map? map;

  const Account2GroupDesign({
    Key? key,
    this.title,
    this.id,
    this.subtitle,
    required this.action,
    this.map,
  }) : super(key: key);

  @override
  _Account2GroupState createState() => _Account2GroupState();
}

// ignore: duplicate_ignore
class _Account2GroupState extends State<Account2GroupDesign> {
  AccountSQL _accountSQL = AccountSQL();
  RefreshDataProvider refreshing = RefreshDataProvider();
  TextEditingController accountGroupNameController =
      new TextEditingController();

  Map dropDownMap = {
    "ID": null,
    'Title': "Account Type",
    'SubTitle': null,
    "Value": null
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          color: Provider.of<ThemeDataHomePage>(context, listen: false)
              .backGroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 35,
                color: Provider.of<ThemeDataHomePage>(context, listen: false)
                    .borderTextAppBarColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Account Group ${widget.action.toString()}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Center(
                        child: widget.action == 'Add'
                            ? FutureBuilder(
                                future: _accountSQL.maxIdForAccount2Group(),
                                //getting the dropdown data from query
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                            : Text(
                                widget.id.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                maxLines: 2,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: FutureBuilder(
                  future: _accountSQL.dropDownData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: InkWell(
                            onTap: () async {
                              print('object');
                              dropDownMap = await showDialog(
                                context: context,
                                builder: (_) => DropDownStyle1(
                                  acc1TypeList: snapshot.data,
                                  dropdown_title: dropDownMap['Title'],
                                  map: dropDownMap,
                                ),
                              );
                              setState(() {});
                            },
                            child: DropDownStyle1State.DropDownButton(
                              title: dropDownMap['Title'].toString(),
                              id: dropDownMap['ID'].toString(),
                            )),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: TextField(
                  controller: accountGroupNameController,
                  decoration: InputDecoration(
                    label: Text(
                      'Account Group Name',
                      style: TextStyle(color: Colors.black),
                    ),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      width: Platform.isWindows
                          ? 300
                          : MediaQuery.of(context).size.width / 3,
                      // width:  MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        onPressed: () async {
                          var res = await _accountSQL.insertAccount2Group(
                              int.parse(dropDownMap['ID'].toString()),
                              accountGroupNameController.text,
                              context);
                          print(res);
                          print('insert');

                          accountGroupNameController.text = '';
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ) // foreground
                            ),
                        child: Text("Save"),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: Platform.isWindows
                          ? 300
                          : MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ) // foreground
                              ),
                          onPressed: () async {
                            if (await Provider.of<MySqlProvider>(context,
                                    listen: false)
                                .connectToServerDb()) {
                              ///    Account2Group   //////// sc
                              var maxDate = await refreshing
                                  .updateAccount2GroupDataToServer(context);
                              await refreshing
                                  .insertAccount2GroupDataToServer(context);
                              await refreshing.getTableDataFromServeToInSqlite(
                                  context, 'Account2Group', maxDate);
                            }

                            Navigator.pop(context);

                            setState(() {});
                          },
                          child: Text(
                            'CLOSE',
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
