// ignore_for_file: unused_local_variable, dead_code

import 'package:flutter/material.dart';
import 'package:com/config/screen_config.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/widgets/group_by_dialog.dart';
import 'package:provider/provider.dart';

class GroupByPage extends StatefulWidget {
  final String? columnName;

  const GroupByPage({this.columnName, Key? key}) : super(key: key);

  @override
  _GroupByPageState createState() => _GroupByPageState();
}

class _GroupByPageState extends State<GroupByPage> {
  String groupValue = '';
  List<DataRow> getGroupedRowsList = [];

  @override
  void initState() {
    getGroupedRowsList = getGroupedRows(widget.columnName!, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map> tableDetail = List.generate(
        Provider.of<DatabaseProvider>(context, listen: false)
            .tableDetailList
            .length, (index) {
      Map map = Provider.of<DatabaseProvider>(context, listen: false)
          .tableDetailList[index];
      return map;
    });
    ScreenConfig().init(context);
    final columnName = widget.columnName;
    return Scaffold(
      appBar: AppBar(
        title: Text("Group By"),
      ),
      body: SingleChildScrollView(
        //scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaginatedDataTable(
                columns: List.generate(
                    Provider.of<DatabaseProvider>(context, listen: false)
                        .tableColumnName
                        .length, (iCol) {
                  return DataColumn(
                      label: GestureDetector(
                          onTap: () async {
                            final action = await showDialog(
                              context: context,
                              builder: (context) => GroupByDialog(),
                            );
                            if (action == "SUM") {
                              setState(() {
                                getGroupedRowsList.clear();
                                getGroupedRowsList = getSumOfSelectedColumn(
                                    Provider.of<DatabaseProvider>(context,
                                            listen: false)
                                        .tableColumnName[iCol],
                                    widget.columnName!,
                                    iCol);
                              });
                            }
                            print(action);
                          },
                          child: Text(Provider.of<DatabaseProvider>(context,
                                  listen: false)
                              .tableColumnName[iCol]
                              .toString())));
                }),
                source: PaginatedDataTableSource(getGroupedRowsList)),
          ],
        ),
      ),
    );
  }

  List<DataRow> getGroupedRows(String columnName, BuildContext context) {
    List<Map> tableDetail = List.generate(
        Provider.of<DatabaseProvider>(context, listen: false)
            .tableDetailList
            .length, (index) {
      Map map = Provider.of<DatabaseProvider>(context, listen: false)
          .tableDetailList[index];
      return map;
    });
    List<DataRow> dataRowList = [];
    for (var groupSetIndex = 0;
        groupSetIndex <
            Provider.of<DatabaseProvider>(context, listen: false)
                .groupSetList
                .length;
        groupSetIndex++) {
      bool firstTimeEntryAllow = true;
      for (int iRow = 0;
          iRow <
              Provider.of<DatabaseProvider>(context, listen: false)
                  .tableDetailList
                  .length;
          iRow++) {
        var tableDetailRow = tableDetail[iRow];
        if (tableDetailRow[columnName].toString() ==
            Provider.of<DatabaseProvider>(context, listen: false)
                .groupSetList[groupSetIndex]
                .toString()) {
          if (firstTimeEntryAllow) {
            dataRowList.add(DataRow(
                selected: true,
                cells: List.generate(
                    Provider.of<DatabaseProvider>(context, listen: false)
                        .tableColumnName
                        .length, (index) {
                  return DataCell(Text((index == 0)
                      ? tableDetailRow[columnName].toString()
                      : ""));
                })));
            firstTimeEntryAllow = false;
          }
          groupValue = tableDetailRow[columnName].toString();
          dataRowList.add(DataRow(
              selected: true,
              cells: List.generate(
                  Provider.of<DatabaseProvider>(context, listen: false)
                      .tableColumnName
                      .length, (index) {
                return DataCell(Text(tableDetailRow[
                        Provider.of<DatabaseProvider>(context, listen: false)
                            .tableColumnName[index]]
                    .toString()));
              })));
        }
      }
    }
    return dataRowList;
  }

  List<DataRow> getSumOfSelectedColumn(
      String sumColumnName, String groupByColumnName, int sumColumnNameIndex) {
    List<Map> tableDetail = List.generate(
        Provider.of<DatabaseProvider>(context, listen: false)
            .tableDetailList
            .length, (index) {
      Map map = Provider.of<DatabaseProvider>(context, listen: false)
          .tableDetailList[index];
      return map;
    });
    int totalSum = 0;

    List<DataRow> dataRowList = [];
    for (var groupSetIndex = 0;
        groupSetIndex <
            Provider.of<DatabaseProvider>(context, listen: false)
                .groupSetList
                .length;
        groupSetIndex++) {
      bool firstTimeEntryAllow = true;
      int groupSum = 0;
      for (int iRow = 0;
          iRow <
              Provider.of<DatabaseProvider>(context, listen: false)
                  .tableDetailList
                  .length;
          iRow++) {
        var tableDetailRow = tableDetail[iRow];
        if (tableDetailRow[groupByColumnName].toString() ==
            Provider.of<DatabaseProvider>(context, listen: false)
                .groupSetList[groupSetIndex]
                .toString()) {
          if (firstTimeEntryAllow) {
            dataRowList.add(DataRow(
                selected: true,
                cells: List.generate(
                    Provider.of<DatabaseProvider>(context, listen: false)
                        .tableColumnName
                        .length, (index) {
                  return DataCell(Text((index == 0)
                      ? tableDetailRow[groupByColumnName].toString()
                      : ""));
                })));
            firstTimeEntryAllow = false;
          }
          groupValue = tableDetailRow[groupByColumnName].toString();
          dataRowList.add(DataRow(
              selected: true,
              cells: List.generate(
                  Provider.of<DatabaseProvider>(context, listen: false)
                      .tableColumnName
                      .length, (index) {
                return DataCell(Text(tableDetailRow[
                        Provider.of<DatabaseProvider>(context, listen: false)
                            .tableColumnName[index]]
                    .toString()));
              })));
          if (tableDetailRow[sumColumnName] == null ||
              tableDetailRow[sumColumnName] == '') {
            groupSum += 0;
          } else {
            int value = tableDetailRow[sumColumnName] as int;
            groupSum += value;
          }
        }
      }
      dataRowList.add(DataRow(
          selected: true,
          cells: List.generate(
              Provider.of<DatabaseProvider>(context, listen: false)
                  .tableColumnName
                  .length, (index) {
            return DataCell(
                Text((index == sumColumnNameIndex) ? groupSum.toString() : ""));
          })));
      totalSum += groupSum;
    }
    dataRowList.add(DataRow(
        selected: true,
        cells: List.generate(
            Provider.of<DatabaseProvider>(context, listen: false)
                .tableColumnName
                .length, (index) {
          return DataCell(
              Text((index == sumColumnNameIndex) ? totalSum.toString() : ""));
        })));
    return dataRowList;
  }
}

class PaginatedDataTableSource extends DataTableSource {
  final List<DataRow> data;

  PaginatedDataTableSource(this.data);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= data.length) return null;
    return data[index];
    throw UnimplementedError();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
