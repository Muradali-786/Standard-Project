import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class ImportDataFromCsvToSqlite extends StatefulWidget {
  ImportDataFromCsvToSqlite({Key? key}) : super(key: key);

  @override
  State<ImportDataFromCsvToSqlite> createState() =>
      _ImportDataFromCsvToSqliteState();
}

class _ImportDataFromCsvToSqliteState extends State<ImportDataFromCsvToSqlite> {
  late List<dynamic> employeeData;
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<PlatformFile>? _paths;
  String? _extension = "csv";
  FileType _pickingType = FileType.custom;

  openFile(filepath) async {
    File f = new File(filepath);
    print("CSV to List");
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    print(fields);
    setState(() {
      employeeData = fields;
    });
  }

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
      print(_paths);
      print("File path ${_paths![0]}");
      print(_paths!.first.extension);
    });
  }

  @override
  void initState() {
    employeeData = List<List<dynamic>>.empty(growable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Csv to Sqlite'),
        centerTitle: true,
      ),
      body: Center(
        child: MaterialButton(
          onPressed: _openFileExplorer,
          child: Text('Import Csv File'),
        ),
      ),
    );
  }
}
