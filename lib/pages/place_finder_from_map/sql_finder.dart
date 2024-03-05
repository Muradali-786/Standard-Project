import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqlcipher;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<Database> init() async {
  Directory? documentsDirectory;
  String path = '';

  documentsDirectory = await getExternalStorageDirectory();
  path = join(documentsDirectory!.path, 'ExternalContactData.db');

  if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
    ByteData data;

    data =
        await rootBundle.load(join('assets/database/ExternalContactData.db'));

    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await new File(path).writeAsBytes(bytes);
  }
  var db;

  db = await sqlcipher.openDatabase(path, password: '1122334455');

  return db;
}

Future<String> insetIntoContact({
  required BuildContext context,
  required String ContectGetFrom,
  required String BusinessName,
  required String BusinessAddress,
  required String BusinessType,
  required String ContactNo,
  required String RefranceKey,
  required String City,
  required String Country,
  required int SaveInContact,
}) async {
  var db = await init();

  String yearID = '''
    select (IfNull(Max(Abs(AutoID)),0)+1) as MaxId from BusnessContactNo"+"
    ''';
  List list = await db.rawQuery(yearID);
  var autoID = list[0]['MaxId'].round();

  try {
    await db.rawInsert(
        'INSERT INTO BusnessContactNo (AutoID,ContectGetFrom,BusinessName,BusinessAddress,BusinessType,ContactNo,RefranceKey,City,Country,SaveInContact) VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          autoID,
          ContectGetFrom,
          BusinessName,
          BusinessAddress,
          BusinessType,
          ContactNo,
          RefranceKey,
          City,
          Country,
          SaveInContact
        ]);


    return 'Insert';
  } catch (e) {
    return e.toString();
  }
}

Future  updateContactNumber({required int id,required String contactNO }) async {
  var db =  await init();
  try {
    var updateNumber = await db.rawUpdate('''
          update BusnessContactNo set ContactNo='$contactNO' where AutoID ='$id'
          ''');

    print(updateNumber);
   // return updateNumber;
  } catch (e) {
    print(e.toString());
   // return 0;
  }
}
Future  updateSaveINBook({required int id, }) async {
  var db =  await init();
  try {
    var updateNumber = await db.rawUpdate('''
          update BusnessContactNo set SaveInContact= 1 where AutoID ='$id'
          ''');

    print(updateNumber);
    // return updateNumber;
  } catch (e) {
    print(e.toString());
    // return 0;
  }
}

Future<List> selectAllDataFromContact() async {
  String query = '';
  List list = [];
  query = "Select * From BusnessContactNo ";

  try {
    var db = await init();
    list = await db.rawQuery(query);

    return list;
  } catch (e) {
    return [];
  }
}

Future<List> selectDataWithOutContact() async {
  String query = '';
  List list = [];
  query = "Select * From BusnessContactNo where ContactNo='Not Updated' ";

  try {
    var db = await init();
    list = await db.rawQuery(query);

    return list;
  } catch (e) {
    return [];
  }
}
Future<List> selectDataWithContact() async {
  String query = '';
  List list = [];
  query = "Select * From BusnessContactNo where ContactNo!='Not Updated' AND  SaveInContact=0";

  try {
    var db = await init();
    list = await db.rawQuery(query);

    return list;
  } catch (e) {
    return [];
  }
}


Future deleteAllData() async {

  try {
    var db = await init();
      await db.delete('BusnessContactNo');
  } catch (e) {
    return [];
  }
}