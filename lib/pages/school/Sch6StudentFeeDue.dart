
import '../../shared_preferences/shared_preference_keys.dart';
import '../sqlite_data_views/sqlite_database_code_provider.dart';



class StudentFeeDue {
  late int ID;
  late int FeeDueID;
  late String GRN;
  late DateTime dueDate;
  late String FeeNarration;
  late double FeeDueAmount;
  late int ClientID;
  late int ClientUserId;
  late String NetCode;
  late String SysCode;
  late String UpdatedData;

  StudentFeeDue();

  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);

  DatabaseProvider db = DatabaseProvider();

  StudentFeeDue.fromMap(Map<String, dynamic> map) {
    ID = map['ID'];
    FeeDueID = map['FeeDueID'];
    GRN = map['GRN'];
    dueDate = map['DueDate'];
    FeeNarration = map['FeeNarration'];
    FeeDueAmount = map['FeeDueAmount'];
    ClientID = map['ClientID'];
    ClientUserId = map['ClientUserID'];
    netCode = map['NetCode'];
    sysCode = map['SysCode'];
    UpdatedData = map['UpdatedDate'];
  }

  getDatabase() async {
    await db.init();
  }

  Future<int> maxIdForStudentFeeDue() async {
    var db =  await DatabaseProvider().init();

    String sectionId = '''
    select -(IfNull(Max(Abs(FeeDueID)),0)+1) as MaxId from Sch6StudentFeeDue"+" where ClientID=$clientID
    ''';
    List list = await db.rawQuery(sectionId);
    var feeDueId = list[0]['MaxId'].round();

    db.close();
    return feeDueId;
  }

  Future<void> insertStudentFeeDue(
      {required String dueDate,
      required String feeNarration,
      required double feeDueAmount,
      required String grn,
      required int sectionStudentID,
      required int feeDueId}) async {
    var db =  await DatabaseProvider().init();

    print('   section id is    >>>>>>>$sectionStudentID');
    try {
      var q = await db.rawInsert(
          'INSERT INTO Sch6StudentFeeDue (FeeDueID,GRN,DueDate,FeeNarration,FeeDueAmount,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate,SectionStudentID)'
          ' VALUES (?,?,?,?,?,?,?,?,?,?,?)',
          [
            feeDueId,
            grn,
            dueDate.toString(),
            feeNarration,
            feeDueAmount,
            clientID,
            clientUserID,
            0,
            0,
            '',
            sectionStudentID
          ]);
      db.close();

      print('data is inserted ...............................');
      print(q);
    } catch (e) {
      print('${e.toString()}');
    }
  }

  updateStudentFeeDue({
    required int id,
    required String GRN,
    required String DueDate,
    required String FeeNarration,
    required String FeeDueAmount,
  }) async {
    var db =  await DatabaseProvider().init();
    try {
      var updateSchoolBranch = await db.rawUpdate('''
          update Sch6StudentFeeDue set GRN='$GRN',DueDate='$DueDate',FeeNarration='$FeeNarration',FeeDueAmount='$FeeDueAmount',ClientID='$clientID',ClientUserID='$clientUserID',NetCode='$netCode!',SysCode='$sysCode!' ,UpdatedDate = '' where ID=$id
          ''');
      db.close();
      print(updateSchoolBranch);
      return updateSchoolBranch;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
}
