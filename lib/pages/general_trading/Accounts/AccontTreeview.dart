
import 'package:flutter/material.dart';

List<Map>? acc1TypeList = [];
List<Map> acc2GroupList = [];
List<Map> acc3NameList = [];
List<Map> acc4sectionList = [];
List<Map> acc5secstudentList = [];
List<Map> acc6studentFeeDueList = [];
List<Map> accFeeRecDueList = [];

class AccountTreeView extends StatefulWidget {
  final List list;

  const AccountTreeView({Key? key, required this.list}) : super(key: key);

  @override
  State<AccountTreeView> createState() => _AccountTreeViewState();
}

class _AccountTreeViewState extends State<AccountTreeView> {
  Set<String> accountTypeList = {};
  Set<String> accountGroupList = {};
  Set<String> accountNameList = {};
  int totalCountAccountType = 0;
  List<int> totalAccountTypeCountList = [];

  int totalCountAccountGroup = 0;
  List<int> totalAccountGroupList = [];

  double debitTotalForAccountType = 0;
  List<double> debitTotalListForAccountType = [];

  double creditTotalForAccountType = 0;
  List<double> creditTotalListForAccountType = [];

  double debitTotalForGroupName = 0;
  List<double> debitTotalListForGroupName = [];

  double creditTotalForGroupName = 0;
  List<double> creditTotalListForGroupName = [];

  double debitTotalForAccountName = 0;
  List<double> debitTotalListForAccountName = [];

  double creditTotalForAccountName = 0;
  List<double> creditTotalListForAccountName = [];
  double grandTotalDebit = 0;
  double grandTotalCredit = 0;

  @override
  void initState() {
    super.initState();
    print('.......................list         ${widget.list}');
    print('.......................list         ${widget.list.length}');

    for (int count = 0; count < widget.list.length; count++) {
      accountTypeList.add(widget.list[count]['AccountType'].toString());
      if (widget.list[count]['Debit'] != null) {
        grandTotalDebit += widget.list[count]['Debit'];
        grandTotalCredit += widget.list[count]['Credit'];
      }
    }

    for (int count = 0; count < accountTypeList.length; count++) {
      debitTotalForAccountType = 0;
      creditTotalForAccountType = 0;
      totalCountAccountType = 0;
      for (int countOFList = 0;
          countOFList < widget.list.length;
          countOFList++) {
        if (accountTypeList.elementAt(count) ==
            widget.list[countOFList]['AccountType']) {
          totalCountAccountType++;

          if (widget.list[countOFList]['Debit'] != null) {
            debitTotalForAccountType +=
                double.parse(widget.list[countOFList]['Debit'].toString());
            creditTotalForAccountType +=
                double.parse(widget.list[countOFList]['Credit'].toString());
          }
        }
      }
      totalAccountTypeCountList.add(totalCountAccountType);
      debitTotalListForAccountType.add(debitTotalForAccountType);
      creditTotalListForAccountType.add(creditTotalForAccountType);
    }
  }

  void getGroupName(String accountName) {
    accountGroupList.clear();
    debitTotalListForGroupName.clear();
    creditTotalListForGroupName.clear();
    totalAccountGroupList.clear();
    for (int count = 0; count < widget.list.length; count++) {
      if (widget.list[count]['AccountType'] == accountName) {
        accountGroupList.add(widget.list[count]['GroupName']);
      }
    }

    for (int count = 0; count < accountGroupList.length; count++) {
      debitTotalForGroupName = 0;
      creditTotalForGroupName = 0;
      totalCountAccountGroup = 0;
      for (int countOFList = 0;
          countOFList < widget.list.length;
          countOFList++) {
        if (accountGroupList.elementAt(count) ==
            widget.list[countOFList]['GroupName']) {
          totalCountAccountGroup++;
          if (widget.list[countOFList]['Debit'] != null) {
            debitTotalForGroupName +=
                double.parse(widget.list[countOFList]['Debit'].toString());
            creditTotalForGroupName +=
                double.parse(widget.list[countOFList]['Credit'].toString());
          }
        }
      }
      totalAccountGroupList.add(totalCountAccountGroup);
      debitTotalListForGroupName.add(debitTotalForGroupName);
      creditTotalListForGroupName.add(creditTotalForGroupName);
    }
  }

  void getAccountName(String groupName) {
    accountNameList.clear();
    debitTotalListForAccountName.clear();
    creditTotalListForAccountName.clear();
    for (int count = 0; count < widget.list.length; count++) {
      if (widget.list[count]['GroupName'] == groupName) {
        accountNameList.add(widget.list[count]['AccountName']);
      }
    }
    for (int count = 0; count < accountNameList.length; count++) {
      debitTotalForAccountName = 0;
      creditTotalForAccountName = 0;

      for (int countOFList = 0;
          countOFList < widget.list.length;
          countOFList++) {
        if (accountNameList.elementAt(count) ==
            widget.list[countOFList]['AccountName']) {
          if (widget.list[countOFList]['Debit'] != null) {
            debitTotalForAccountName +=
                double.parse(widget.list[countOFList]['Debit'].toString());
            creditTotalForAccountName +=
                double.parse(widget.list[countOFList]['Credit'].toString());
          }
        }
      }
      debitTotalListForAccountName.add(debitTotalForAccountName);
      creditTotalListForAccountName.add(creditTotalForAccountName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Debit :',
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                      Text(
                        'Total Credit :',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$grandTotalDebit',
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                      Text(
                        '$grandTotalCredit',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: accountTypeList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, indexOfAccountType) {
                return ExpansionTile(
                  onExpansionChanged: (value) {
                    setState(() {
                      if (value) {
                        getGroupName(
                            accountTypeList.elementAt(indexOfAccountType));
                      } else {
                        accountGroupList.clear();
                      }
                    });
                  },
                  title: Text(
                      '(${totalAccountTypeCountList[indexOfAccountType]}) ${accountTypeList.elementAt(indexOfAccountType)}'),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FittedBox(
                          child: Text(
                        debitTotalListForAccountType[indexOfAccountType]
                            .toString(),
                        style: TextStyle(color: Colors.green),
                      )),
                      FittedBox(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          creditTotalListForAccountType[indexOfAccountType]
                              .toString(),
                          style: TextStyle(color: Colors.red),
                        ),
                      )),
                    ],
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: accountGroupList.length,
                      itemBuilder:
                          (BuildContext context, int indexOfGroupName) {
                        return ExpansionTile(
                          onExpansionChanged: (value) {
                            setState(() {
                              if (value) {
                                getAccountName(accountGroupList
                                    .elementAt(indexOfGroupName));
                              } else {
                                accountNameList.clear();
                              }
                            });
                          },
                          title: Text(
                              '    (${totalAccountGroupList[indexOfGroupName]}) ${accountGroupList.elementAt(indexOfGroupName)}'),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FittedBox(
                                  child: Text(
                                debitTotalListForGroupName[indexOfGroupName]
                                    .toString(),
                                style: TextStyle(color: Colors.green),
                              )),
                              FittedBox(
                                  child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  creditTotalListForGroupName[indexOfGroupName]
                                      .toString(),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )),
                            ],
                          ),
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: accountNameList.length,
                              itemBuilder: (context, indexOfAccountName) {
                                return ExpansionTile(
                                  title: Text(
                                      '            ${accountNameList.elementAt(indexOfAccountName)}'),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FittedBox(
                                          child: Text(
                                        debitTotalListForAccountName[
                                                indexOfAccountName]
                                            .toString(),
                                        style: TextStyle(color: Colors.green),
                                      )),
                                      FittedBox(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          creditTotalListForAccountName[
                                                  indexOfAccountName]
                                              .toString(),
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      )),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
