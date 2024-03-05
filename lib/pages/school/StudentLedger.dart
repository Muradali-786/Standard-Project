import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class StudentLedger extends StatefulWidget {
  final List? list;

  const StudentLedger({this.list, Key? key}) : super(key: key);

  @override
  State<StudentLedger> createState() => _StudentLedgerState();
}

class _StudentLedgerState extends State<StudentLedger> {
  bool check = true;
  double totalValue = 0.0;
  List<double> sumStudentLedger = [];
  double totalDebit = 0;
  double totalCredit = 0;
  double grossAmount = 0;
  String toDate = '';
  String fromDate = '';
  List<Map<String, dynamic>> sortedEntries = [];

  @override
  void initState() {
    super.initState();

    final dateFormat = DateFormat("yyyy-MM-dd");
    List<Map<String, dynamic>> sortedList = List.from(widget.list!);
    sortedList.sort((a, b) =>
        dateFormat.parse(a["Date"]).compareTo(dateFormat.parse(b["Date"])));
    sortedEntries.addAll(sortedList);

    for (int i = 0; i < sortedEntries.length; i++) {
      totalValue += sortedEntries[i]['Debit'] - sortedEntries[i]['Credit'];
      sumStudentLedger.add(totalValue);

      totalDebit += sortedEntries[i]['Debit'];
      totalCredit += sortedEntries[i]['Credit'];
    }

    grossAmount = totalDebit - totalCredit;

    List<DateTime> dates = sortedEntries
        .map((dateString) => DateTime.parse(dateString['Date']))
        .toList();

    dates.sort((a, b) => a.compareTo(b));
    fromDate = dates.first.toString().substring(0, 10);
    toDate = dates.last.toString().substring(0, 10);
  }

  Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.all(0),
      icon: Icon(
        Icons.more_vert,
        size: 25,
        color: Colors.grey,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('Share')),
          PopupMenuItem(value: 1, child: Text('Print')),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl:
                              'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}',
                          alignment: Alignment.center,
                          imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                          placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                          errorWidget: (context, url, error) => Container(
                                color: Colors.grey,
                              )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SharedPreferencesKeys.prefs!
                                .getString(SharedPreferencesKeys.companyName)!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.companyNumber)!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys.companyAddress)!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Align(
                        alignment: Alignment.centerRight,
                        child: popUpButtonForItemEdit(onSelected: (value) {
                          if (value == 0) {
                            generatePDF(context);
                          }
                        })),
                  ],
                ),
              ),
            ),
            Center(
                child: Text(
              'Student GL',
              style: TextStyle(fontSize: 25, color: Colors.green),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'GRN: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${sortedEntries[0]['GRN']}',
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Family Group: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${sortedEntries[0]['FamilyGroupNo']}',
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'From: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(fromDate.toString().substring(0, 4)), int.parse(fromDate.substring(
                                  5,
                                  7,
                                )), int.parse(fromDate.substring(8, 10)))).toString()}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To:  ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(toDate.toString().substring(0, 4)), int.parse(toDate.toString().substring(
                                  5,
                                  7,
                                )), int.parse(toDate.toString().substring(8, 10)))).toString()}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                children: [
                  Text(
                    'Student Name: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${sortedEntries[0]['StudentName']}',
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                children: [
                  Text(
                    'Father Name: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${sortedEntries[0]['FahterName']}',
                    overflow: TextOverflow.fade,
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'BALANCE ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  // Text('0',overflow: TextOverflow.fade,)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    grossAmount.toString(),
                    style: TextStyle(
                        color: grossAmount < 0 ? Colors.red : Colors.green),
                  ),
                  // Text('0',overflow: TextOverflow.fade,)
                ],
              ),
            ),

            /// title of view list ///////////////////////////////
            Container(
              height: 40,
              color: Provider.of<ThemeDataHomePage>(context, listen: false)
                  .borderTextAppBarColor,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 5,
                        child: Text(
                          'Particular',
                          style: TextStyle(color: Colors.white),
                        )),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 2,
                              child: FittedBox(
                                  child: Text(
                                'Debit',
                                style: TextStyle(color: Colors.white),
                              ))),
                          Flexible(
                              flex: 2,
                              child: FittedBox(
                                  child: Text(
                                'Credit',
                                style: TextStyle(color: Colors.white),
                              ))),
                          Flexible(
                              flex: 2,
                              child: FittedBox(
                                  child: Center(
                                      child: Text(
                                'Running \n   Total',
                                style: TextStyle(color: Colors.white),
                              )))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            /// All ledger list   data  ///////////////////////////////
            ListView.builder(
              itemCount: sortedEntries.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1))),
                  child: ListTile(
                      title: Row(
                        children: [
                          FittedBox(
                              child: Text(
                            '${sortedEntries[index]['EntryType'].toString()}  ',
                            style: TextStyle(
                                color: sortedEntries[index]['EntryType']
                                            .toString() ==
                                        'Due'
                                    ? Colors.red
                                    : Colors.green),
                          )),
                          FittedBox(
                            child: Text(
                                '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(sortedEntries[index]['Date'].toString().substring(0, 4)), int.parse(sortedEntries[index]['Date'].substring(
                                      5,
                                      7,
                                    )), int.parse(sortedEntries[index]['Date'].substring(8, 10)))).toString()} '),
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${sortedEntries[index]['Debit']}'),
                            Text('${sortedEntries[index]['Credit']}'),
                            Text(
                              sumStudentLedger[index].toString(),
                              style: TextStyle(
                                  color: sumStudentLedger[index] < 0
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                          '${sortedEntries[index]['Particulars'].toString()}')),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Provider.of<ThemeDataHomePage>(context, listen: false)
                    .backGroundColor,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Total: ')),
                        Text(totalDebit.toString()),
                        Padding(padding: EdgeInsets.all(12)),
                        Text(totalCredit.toString()),
                      ],
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            grossAmount.toString(),
                            style: TextStyle(
                                color: grossAmount < 0
                                    ? Colors.red
                                    : Colors.green),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generatePDF(BuildContext context) async {
    final pdf = pw.Document();

    final netImage = await networkImage(
        'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}');

    pdf.addPage(pw.MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(16),
      build: (context) {
        return [

            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Row(
                children: [
                  pw.ClipRRect(
                    horizontalRadius: 12,
                    verticalRadius: 12,
                    child: pw.Image(netImage, height: 70, width: 70),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(
                      left: 16.0,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.companyName)!,
                          style: pw.TextStyle(
                              fontSize: 25, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.companyNumber)!,
                          style: pw.TextStyle(
                              fontSize: 23, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.companyAddress)!,
                          style: pw.TextStyle(
                              fontSize: 23, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.Center(
                child: pw.Text(
              'Student GL',
              style: pw.TextStyle(
                fontSize: 30,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
              ),
            )),

            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Flexible(
                    flex: 6,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'GRN: ',
                              style: pw.TextStyle(
                                  fontSize: 20, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              '${sortedEntries[0]['GRN']}',
                              style: pw.TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              'Family Group: ',
                              style: pw.TextStyle(
                                  fontSize: 20, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              '${sortedEntries[0]['FamilyGroupNo']}',
                              style: pw.TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.Flexible(
                    flex: 4,
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'From: ',
                              style: pw.TextStyle(
                                  fontSize: 20, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(fromDate.toString().substring(0, 4)), int.parse(fromDate.substring(
                                    5,
                                    7,
                                  )), int.parse(fromDate.substring(8, 10)))).toString()}',
                              style: pw.TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'To:  ',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            pw.Text(
                              '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(toDate.toString().substring(0, 4)), int.parse(toDate.toString().substring(
                                    5,
                                    7,
                                  )), int.parse(toDate.toString().substring(8, 10)))).toString()}',
                              style: pw.TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8.0, right: 8),
              child: pw.Row(
                children: [
                  pw.Text(
                    'Student Name: ',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  pw.Text(
                    '${sortedEntries[0]['StudentName']}',
                    style: pw.TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8.0, right: 8),
              child: pw.Row(
                children: [
                  pw.Text(
                    'Father Name: ',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  pw.Text(
                    '${sortedEntries[0]['FahterName']}',
                    style: pw.TextStyle(
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),

            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8.0, right: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'BALANCE ',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey,
                      fontSize: 20,
                    ),
                  ),
                  // Text('0',overflow: TextOverflow.fade,)
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    grossAmount.toString(),
                    style: pw.TextStyle(
                      color: grossAmount < 0 ? PdfColors.red : PdfColors.green,
                      fontSize: 20,
                    ),
                  ),
                  // Text('0',overflow: TextOverflow.fade,)
                ],
              ),
            ),

            pw.Container(
              height: 40,
              color: PdfColors.brown900,
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Flexible(
                        flex: 5,
                        child: pw.Text(
                          'Particular',
                          style: pw.TextStyle(color: PdfColors.white),
                        )),
                    pw.Flexible(
                      flex: 5,
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Flexible(
                              flex: 2,
                              child: pw.FittedBox(
                                  child: pw.Text(
                                'Debit',
                                style: pw.TextStyle(color: PdfColors.white),
                              ))),
                          pw.Flexible(
                              flex: 2,
                              child: pw.FittedBox(
                                  child: pw.Text(
                                'Credit',
                                style: pw.TextStyle(color: PdfColors.white),
                              ))),
                          pw.Flexible(
                              flex: 2,
                              child: pw.FittedBox(
                                  child: pw.Center(
                                      child: pw.Text(
                                'Running \n   Total',
                                style: pw.TextStyle(color: PdfColors.white),
                              )))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            /// All ledger list   data  ///////////////////////////////
            pw.ListView.builder(
              itemCount: sortedEntries.length,
              itemBuilder: (context, index) {
                return pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Container(
                        height: 40,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(
                                bottom: pw.BorderSide(
                                    color: PdfColors.grey, width: 1))),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Flexible(
                                flex: 5,
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Row(
                                        children: [
                                          pw.FittedBox(
                                              child: pw.Text(
                                            '${sortedEntries[index]['EntryType'].toString()}  ',
                                            style: pw.TextStyle(
                                                color: sortedEntries[index]
                                                                ['EntryType']
                                                            .toString() ==
                                                        'Due'
                                                    ? PdfColors.red
                                                    : PdfColors.green),
                                          )),
                                          pw.FittedBox(
                                            child: pw.Text(
                                                '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(sortedEntries[index]['Date'].toString().substring(0, 4)), int.parse(sortedEntries[index]['Date'].substring(
                                                      5,
                                                      7,
                                                    )), int.parse(sortedEntries[index]['Date'].substring(8, 10)))).toString()} '),
                                          ),
                                        ],
                                      ),
                                      pw.Text(
                                          '${sortedEntries[index]['Particulars'].toString()}'),
                                    ])),
                            pw.Flexible(
                              flex: 5,
                              child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Flexible(
                                    flex: 2,
                                    child: pw.Text(
                                        '${sortedEntries[index]['Debit']}'),
                                  ),
                                  pw.Flexible(
                                    flex: 2,
                                    child: pw.Text(
                                        '${sortedEntries[index]['Credit']}'),
                                  ),
                                  pw.Flexible(
                                    flex: 2,
                                    child: pw.Text(
                                      sumStudentLedger[index].toString(),
                                      style: pw.TextStyle(
                                          color: sumStudentLedger[index] < 0
                                              ? PdfColors.red
                                              : PdfColors.green),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )));
              },
            ),

          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Column(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 32.0),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text('Total: ',style: pw.TextStyle(
                         fontSize: 20),),),
                      pw. Text(totalDebit.toString(),style: pw.TextStyle(
                     fontSize: 20),),
                      pw.Padding(padding: pw.EdgeInsets.only(left: 32)),
                      pw.Text(totalCredit.toString(),style: pw.TextStyle(
                          fontSize: 20),),
                    ],
                  ),
                ),
                pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        grossAmount.toString(),
                        style: pw.TextStyle(
                            color: grossAmount < 0
                                ? PdfColors.red
                                : PdfColors.green,fontSize: 20),
                      ),
                    )),
              ],
            ),
          ),



        ];
      },
    ));

    Navigator.pushNamed(context, '/pdf_preview_page', arguments: pdf);
  }
}
