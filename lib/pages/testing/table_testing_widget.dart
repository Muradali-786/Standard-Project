// ignore_for_file: unused_field, non_constant_identifier_names, unnecessary_null_comparison, unused_element
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:com/pages/material/color_picker_page.dart';
import 'package:com/pages/material/column_visibility.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:com/config/screen_config.dart';
import 'package:com/config/values.dart';
import 'package:com/pages/sqlite_data_views/table_column_dialog_design.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../material/grid_column_quantity_picker.dart';
import 'package:recase/recase.dart';


class TableTestingWidget extends StatefulWidget {
  final editPageRoute;
  final String query;
  const TableTestingWidget(
      {Key? key, required this.editPageRoute, required this.query})
      : super(key: key);

  @override
  _TableTestingWidgetState createState() => _TableTestingWidgetState();
}

class _TableTestingWidgetState extends State<TableTestingWidget> {
  List<Map<String, dynamic>> tableDetail = List.generate(
      Provider.of<DatabaseProvider>(
              Values.navigatorKey.currentContext as BuildContext,
              listen: false)
          .tableDetailList
          .length, (index) {
    Map<String, dynamic> map = Provider.of<DatabaseProvider>(
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
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Query Test"),
        actions: <Widget>[
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(value: 0, child: Text('Print')),
                    PopupMenuItem<int>(value: 1, child: Text('Grid Layout')),
                    PopupMenuItem<int>(value: 2, child: Text('Slider')),
                    PopupMenuItem<int>(value: 3, child: Text('ColorPicker')),
                    PopupMenuItem<int>(
                        value: 4, child: Text('Column Visibility')),
                    PopupMenuItem<int>(value: 5, child: Text('Screen Shot')),
                    PopupMenuItem<int>(
                        value: 6, child: Text('Export To Excel')),
                  ]),
        ],
      ),
      body: (layout == 0)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Screenshot(
                          controller: screenshotController,
                          child: DataTable(
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
                                   // print(sortAscending);
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
                                        var db =  await DatabaseProvider().init();
                                        if (value == 1) {
                                          try {
                                            String query = '''
                                        Update Setting Set visibility=0,UpdatedDate=''
                                        where `layout`='${Provider.of<DatabaseProvider>(context, listen: false).layoutName}' AND
                                        `columnName`='${Provider.of<DatabaseProvider>(context, listen: false).tableColumnName[index].toString()}' AND
                                        `ClientID`=${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)} AND
                                         `ClientUserID`='${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}' ;
                                        ''';
                                            if (await db.rawUpdate(query) > 0) {
                                              Provider.of<DatabaseProvider>(
                                                      context,
                                                      listen: false)
                                                  .removeColumn(Provider.of<
                                                              DatabaseProvider>(
                                                          context,
                                                          listen: false)
                                                      .tableColumnName[index]
                                                      .toString())
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            }
                                          } on Exception catch (e, stk) {
                                            print(e);
                                            print(stk);
                                          }
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
                                          //print(sum);
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
                                              Map<String,
                                                  dynamic> map = Provider.of<
                                                          DatabaseProvider>(
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
                                            Map<String, dynamic> map =
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
                                        .toString()
                                        .sentenceCase),
                                  ));
                            }),
                            rows: getTableRows(),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 100,
                  ),
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

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) async {
    return showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) => InteractiveViewer(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Captured widget screenshot"),
                ),
                body: Column(
                  children: [
                    capturedImage != null
                        ? Image.memory(capturedImage)
                        : Container(),
                    ElevatedButton(
                      onPressed: () {
                        doc.addPage(pw.MultiPage(
                            pageFormat: PdfPageFormat.a4,
                            build: (pw.Context context) => [
                                  pw.Image(pw.MemoryImage(capturedImage)),
                                ]));
                        Navigator.pushNamed(context, '/pdf_preview_page',
                            arguments: doc);
                      },
                      child: Text("Printing"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // await WhatsappShare.shareFile(
                        //   text: 'Whatsapp share text',
                        //   phone: '+923410579881',
                        //   filePath: [],
                        // );
                      },
                      child: Text("Whatsapp Share"),
                    ),
                  ],
                ),
              ),
            ));
  }

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;
  final PdfColor baseColor = PdfColors.teal;
  final PdfColor accentColor = PdfColors.blueGrey900;
  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;
  onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:

        doc.addPage(pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) => [
                  pw.Table.fromTextArray(
                    border: null,
                    cellAlignment: pw.Alignment.centerLeft,
                    headerDecoration: pw.BoxDecoration(
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: baseColor,
                    ),
                    headerHeight: 25,
                    cellHeight: 40,
                    cellAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.centerRight,
                      3: pw.Alignment.center,
                      4: pw.Alignment.centerRight,
                    },
                    headerStyle: pw.TextStyle(
                      color: _baseTextColor,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    cellStyle: const pw.TextStyle(
                      color: _darkColor,
                      fontSize: 10,
                    ),
                    rowDecoration: pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: accentColor,
                          width: .5,
                        ),
                      ),
                    ),
                    data: tableDetail.map((e) {
                      return List<String>.of(e.values.map((e) => e.toString()));
                    }).toList(),
                  ),
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
      case 4:
        print("Visibility Column Display here");
        showColumnVisibility(context);
        break;
      case 5:
        screenshotController
            .capture(delay: Duration(milliseconds: 10))
            .then((capturedImage) async {
          ShowCapturedWidget(context, capturedImage!);
        }).catchError((onError) {
          print(onError);
        });
        break;
      case 6:
        print('..........................................$tableDetail');
        print(mapListToCsv(tableDetail));
        final String directory = (await getApplicationSupportDirectory()).path;
        final path = "$directory/csv-${DateTime.now()}.csv";
        print(path);
        final File file = File(path);
        await file.writeAsString(mapListToCsv(tableDetail)!);
        // OpenFilex.open(
        //   path,
        //   type: "application/vnd.ms-excel",
        //   uti: "com.microsoft.excel.xls",
        // );
        break;
    }
  }

  String? mapListToCsv(List<Map<String, Object?>>? mapList,
      {ListToCsvConverter? converter}) {
    if (mapList == null) {
      return null;
    }
    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
    int _addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      // This list might grow if a new key is found
      var dataRow = List<Object?>.filled(keyIndexMap.length, null);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = _addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[keys, ...data]);
  }

  showColumnVisibility(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ColumnVisibility(
                query: widget.query,
              )),
    );

    setState(() {});
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
                List list = [];
                list.add(Map.from(tableDetail[selectedIndex!]));
                list.add({"action": "EDIT"});
                if (widget.editPageRoute != null)
                  Navigator.pushNamed(context, widget.editPageRoute,
                      arguments: list);
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
      print("show sum here");
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
    print("table row list");
    print(tableRowList);
    return tableRowList;
  }
}
