// ignore_for_file: unused_field, unused_element


import 'package:com/pages/material/color_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:com/config/screen_config.dart';
import 'package:com/config/values.dart';
import 'package:com/pages/sqlite_data_views/table_column_dialog_design.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../material/grid_column_quantity_picker.dart';

class TableDetailPage extends StatefulWidget {
  //final editPageRoute;

  const TableDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TableDetailPage();
  }
}

class _TableDetailPage extends State<TableDetailPage> {
  List<Map> tableDetail = List.generate(
      Provider.of<DatabaseProvider>(
              Values.navigatorKey.currentContext as BuildContext,
              listen: false)
          .tableDetailList
          .length, (index) {
    Map map = Provider.of<DatabaseProvider>(
            Values.navigatorKey.currentContext as BuildContext,
            listen: false)
        .tableDetailList[index];
    return map;
  });

  int layout = 0;
  double column = 2;
  final doc = pw.Document();
  int _currentSortColumn = 0;
  bool _isAscending = true;
  bool showSum = false;
  bool showMin = false;
  bool showMax = false;
  bool showCount = false;
  num sum = 0;
  num? min;
  num? max;
  num? count;
  int? sumColumnIndex;
  Color backgroundColr = Colors.blue;
  int? selectedIndex;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();

  _TableDetailPage({Key? key});

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    //final args = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("Query Test"),
        actions: <Widget>[
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(value: 0, child: Text('Print')),
                    PopupMenuItem<int>(value: 1, child: Text('Grid Layout')),
                    PopupMenuItem<int>(value: 2, child: Text('Slider')),
                    PopupMenuItem<int>(value: 3, child: Text('ColorPicker')),
                  ]),
        ],
      ),
      body: (layout == 0)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     Form(
                  //       key: _formKey,
                  //       child: Expanded(
                  //         child: TextFormField(
                  //           controller: _searchController,
                  //           validator: (value) {
                  //           },
                  //           onChanged: (value){
                  //             print(value);
                  //
                  //           },),
                  //       ),
                  //     ),
                  //
                  //   ],
                  // ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          // showBottomBorder: true,
                          // dividerThickness: 5.0,
                          decoration: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  style: BorderStyle.solid)),
                          showCheckboxColumn: false,
                          sortColumnIndex: _currentSortColumn,
                          sortAscending: _isAscending,
                          columns: List.generate(
                              Provider.of<DatabaseProvider>(context,
                                      listen: false)
                                  .tableColumnName
                                  .length, (index) {
                            return DataColumn(
                                onSort: (columnIndex, sortAscending) {
                                  print(sortAscending);
                                  setState(() {
                                    String cName =
                                        Provider.of<DatabaseProvider>(context,
                                                listen: false)
                                            .tableColumnName[columnIndex];
                                    _currentSortColumn = columnIndex;
                                    if (_isAscending == true) {
                                      _isAscending = false;
                                      // sort the product list in Ascending, order by Price
                                      tableDetail.sort((productA, productB) =>
                                          productB[cName]
                                              .compareTo(productA[cName]));
                                    } else {
                                      _isAscending = true;
                                      // sort the product list in Descending, order by Price
                                      tableDetail.sort((productA, productB) =>
                                          productA[cName]
                                              .compareTo(productB[cName]));
                                    }
                                  });
                                },
                                label: InkWell(
                                  onLongPress: () async {
                                    print("on long press is pressed");
                                    final value = await showDialog(
                                      context: context,
                                      builder: (context) => VisibilityPage(
                                        columnName:
                                            Provider.of<DatabaseProvider>(
                                                    context,
                                                    listen: false)
                                                .tableColumnName[index]
                                                .toString(),
                                        columnIndex: index,
                                      ),
                                    );

                                    // execution of this code continues when the dialog was closed (popped)

                                    // note that the result can also be null, so check it
                                    // (back button or pressed outside of the dialog)
                                    if (value != null &&
                                        value.runtimeType == int) {
                                      var db = await DatabaseProvider().init();
                                      if (value == 1) {
                                        Map<String, dynamic> map = {
                                          "layout": "dataTable",
                                          "columnName":
                                              Provider.of<DatabaseProvider>(
                                                      context,
                                                      listen: false)
                                                  .tableColumnName[index]
                                                  .toString(),
                                          "visibility": "0"
                                        };
                                        print(await db.insert('Setting', map));
                                        Provider.of<DatabaseProvider>(context,
                                                listen: false)
                                            .removeColumn(
                                                Provider.of<DatabaseProvider>(
                                                        context,
                                                        listen: false)
                                                    .tableColumnName[index]
                                                    .toString())
                                            .then((value) {
                                          setState(() {});
                                        });
                                      } else if (value == 2) {
                                        Provider.of<DatabaseProvider>(context,
                                                listen: false)
                                            .groupBy(
                                                Provider.of<DatabaseProvider>(
                                                        context,
                                                        listen: false)
                                                    .tableColumnName[index]
                                                    .toString());
                                        Navigator.pushNamed(
                                            context, '/group_by_page',
                                            arguments:
                                                Provider.of<DatabaseProvider>(
                                                        context,
                                                        listen: false)
                                                    .tableColumnName[index]
                                                    .toString());
                                      } else if (value == 3) {
                                        sum = Provider.of<DatabaseProvider>(
                                                context,
                                                listen: false)
                                            .getSumOfColumn(
                                                Provider.of<DatabaseProvider>(
                                                        context,
                                                        listen: false)
                                                    .tableColumnName[index],
                                                index);
                                        setState(() {
                                          showCount = false;
                                          showSum = true;
                                          showMin = false;
                                          showMax = false;
                                          sumColumnIndex = index;
                                          print(index);
                                        });
                                      } else if (value == 4) {
                                        //4 for min
                                        min = Provider.of<DatabaseProvider>(
                                                context,
                                                listen: false)
                                            .getMinValue(
                                                Provider.of<DatabaseProvider>(
                                                        context,
                                                        listen: false)
                                                    .tableColumnName[index]);
                                        //print(Provider.of<DatabaseProvider>(context,listen:false).tableColumnName![index]);
                                        setState(() {
                                          showCount = false;
                                          showMin = true;
                                          showSum = false;
                                          showMax = false;
                                          sumColumnIndex = index;
                                        });
                                      } else if (value == 5) {
                                        max = Provider.of<DatabaseProvider>(
                                                context,
                                                listen: false)
                                            .getMaxValue(
                                                Provider.of<DatabaseProvider>(
                                                        context,
                                                        listen: false)
                                                    .tableColumnName[index]);
                                        setState(() {
                                          showCount = false;
                                          showMin = false;
                                          showSum = false;
                                          showMax = true;
                                          sumColumnIndex = index;
                                        });
                                      } else if (value == 6) {
                                        count = Provider.of<DatabaseProvider>(
                                                context,
                                                listen: false)
                                            .getColumnCount(
                                                Provider.of<DatabaseProvider>(
                                                        context,
                                                        listen: false)
                                                    .tableColumnName[index]);
                                        setState(() {
                                          showCount = true;
                                          showMin = false;
                                          showSum = false;
                                          showMax = false;
                                          sumColumnIndex = index;
                                        });
                                      } else if (value == 7) {
                                        Provider.of<DatabaseProvider>(context,
                                                listen: false)
                                            .runningSum(
                                                Provider.of<DatabaseProvider>(
                                                        context,
                                                        listen: false)
                                                    .tableColumnName[index]);
                                        setState(() {
                                          tableDetail = List.generate(
                                              Provider.of<DatabaseProvider>(
                                                      Values.navigatorKey
                                                              .currentContext
                                                          as BuildContext,
                                                      listen: false)
                                                  .tableDetailList
                                                  .length, (index) {
                                            Map map =
                                                Provider.of<DatabaseProvider>(
                                                        Values.navigatorKey
                                                                .currentContext
                                                            as BuildContext,
                                                        listen: false)
                                                    .tableDetailList[index];
                                            return map;
                                          });
                                        });
                                      }
                                    } else if (value != null &&
                                        value.runtimeType.toString() ==
                                            "List<dynamic>") {
                                      Provider.of<DatabaseProvider>(context,
                                              listen: false)
                                          .getSearchTable(
                                              Provider.of<DatabaseProvider>(
                                                      context,
                                                      listen: false)
                                                  .tableColumnName[index]
                                                  .toString(),
                                              index,
                                              value);
                                      setState(() {
                                        tableDetail = List.generate(
                                            Provider.of<DatabaseProvider>(
                                                    Values.navigatorKey
                                                            .currentContext
                                                        as BuildContext,
                                                    listen: false)
                                                .tableDetailList
                                                .length, (index) {
                                          Map map =
                                              Provider.of<DatabaseProvider>(
                                                      Values.navigatorKey
                                                              .currentContext
                                                          as BuildContext,
                                                      listen: false)
                                                  .tableDetailList[index];
                                          return map;
                                        });
                                      });
                                    }
                                  },
                                  child: Text(Provider.of<DatabaseProvider>(
                                          context,
                                          listen: false)
                                      .tableColumnName[index]
                                      .toString()),
                                ));
                          }),
                          rows: getTableRows(),
                        )),
                  )
                ],
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: column.round()),
              itemCount: Provider.of<DatabaseProvider>(context, listen: false)
                  .tableDetailList
                  .length,
              itemBuilder: (BuildContext ctx, index) {
                Map map = Provider.of<DatabaseProvider>(context, listen: false)
                    .tableDetailList[index];
                List list = map.values.toList();
                List columnList = map.keys.toList();

                return Card(
                    borderOnForeground: true,
                    child: SizedBox(
                      width: ScreenConfig.screenWidth,
                      height: ScreenConfig.blockHeight * 30,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Text(columnList[index].toString() +
                                " : " +
                                list[index].toString());
                          }),
                    ));
              }),
    );
  }

  onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        doc.addPage(pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) => [
                  pw.Table.fromTextArray(data: <List<String>>[
                    List<String>.generate(
                        Provider.of<DatabaseProvider>(
                                Values.navigatorKey.currentContext
                                    as BuildContext,
                                listen: false)
                            .tableColumnName
                            .length, (index) {
                      return Provider.of<DatabaseProvider>(
                              Values.navigatorKey.currentContext
                                  as BuildContext,
                              listen: false)
                          .tableColumnName[index]
                          .toString();
                    }),
                    ...tableDetail.map((e) {
                      return List<String>.of(e.values.map((e) => e.toString()));
                    }),
                  ]),
                ]));
        Navigator.pushNamed(context, '/pdf_preview_page', arguments: doc);
        break;
      case 1:
        setState(() {
          layout = 1;
        });
        break;
      case 2:
        _showTotalColumnPickerDialog();
        break;
      case 3:
        print("Color picker");
        _showColorPicker();
        break;
    }
  }

  void _showColorPicker() async {
    final selectedColor = await showDialog<Color>(
        context: context, builder: (context) => ColorPickerPage());
    setState(() {
      backgroundColr = selectedColor!;
    });
  }

  void _showTotalColumnPickerDialog() async {
    // <-- note the async keyword here

    // this will contain the result from Navigator.pop(context, result)
    final selectedTotalColumns = await showDialog<double>(
      context: context,
      builder: (context) => ColumnSlider(
        totalColumns: column,
      ),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedTotalColumns != null) {
      print(selectedTotalColumns);
      setState(() {
        column = selectedTotalColumns;
      });
    }
  }

  getTableRows() {
    List<DataRow> tableRowList = [];
    tableRowList.clear();
    for (int i = 0;
        i <
            Provider.of<DatabaseProvider>(context, listen: false)
                .tableDetailList
                .length;
        i++) {
      var tableDetailRow = tableDetail[i];
      if (selectedIndex == i) {
        print(tableDetailRow);

        tableRowList.add(DataRow(
            selected: true,
            color: MaterialStateColor.resolveWith((states) => backgroundColr),
            onSelectChanged: (
              bool? selected,
            ) {
              selectedIndex = i;
            },
            cells: List.generate(
                Provider.of<DatabaseProvider>(context, listen: false)
                    .tableColumnName
                    .length, (index) {
              return DataCell(Text(tableDetailRow[
                      Provider.of<DatabaseProvider>(context, listen: false)
                          .tableColumnName[index]]
                  .toString()));
            })));
      } else {
        tableRowList.add(DataRow(
            onSelectChanged: (
              bool? selected,
            ) {
              setState(() {
                selectedIndex = i;
                //  tableDetail[selectedIndex!].addAll({"operation":"EDIT"});
                //  Navigator.pushNamed(context, widget.editPageRoute,arguments: tableDetail[selectedIndex!]);
              });
            },
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
    if (showSum) {
      tableRowList.add((DataRow(
          selected: true,
          cells: List.generate(
              Provider.of<DatabaseProvider>(context, listen: false)
                  .tableColumnName
                  .length, (index) {
            if (index == sumColumnIndex) {
              return DataCell(Text(sum.toString()));
            } else {
              return DataCell(Text(''));
            }
          }))));
    } else if (showMin) {
      tableRowList.add((DataRow(
          selected: true,
          cells: List.generate(
              Provider.of<DatabaseProvider>(context, listen: false)
                  .tableColumnName
                  .length, (index) {
            if (index == sumColumnIndex) {
              return DataCell(Text(min.toString()));
            } else {
              return DataCell(Text(''));
            }
          }))));
    } else if (showMax) {
      tableRowList.add((DataRow(
          selected: true,
          cells: List.generate(
              Provider.of<DatabaseProvider>(context, listen: false)
                  .tableColumnName
                  .length, (index) {
            if (index == sumColumnIndex) {
              return DataCell(Text(max.toString()));
            } else {
              return DataCell(Text(''));
            }
          }))));
    } else if (showCount) {
      tableRowList.add((DataRow(
          selected: true,
          cells: List.generate(
              Provider.of<DatabaseProvider>(context, listen: false)
                  .tableColumnName
                  .length, (index) {
            if (index == sumColumnIndex) {
              return DataCell(Text(count.toString()));
            } else {
              return DataCell(Text(''));
            }
          }))));
    }
    return tableRowList;
  }
}
