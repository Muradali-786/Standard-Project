import 'package:com/pages/beauty_salon/sql_file_beauty_salon.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/foundation.dart';
import '../../utils/api_query_for_web.dart';

class FeeCollectionSQL {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);
  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;

  int? clientUserID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId);
  String? netCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.netcode);
  String? sysCode =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.sysCode);
  DatabaseProvider db = DatabaseProvider();

  getDatabase() async {
    var db = await DatabaseProvider().init();

    return db;
  }

  updateStudentFeeRec({
    required int id,
    required String recAmount,
  }) async {
    var db = await DatabaseProvider().init();
    try {
      var updateRec2SchoolBranch = await db.rawUpdate('''
          update Sch7FeeRec2 set RecAmount='$recAmount',UpdatedDate='' where FeeRec2ID='$id'
          ''');

      print(
          '.....................$updateRec2SchoolBranch..............................');

      db.close();
    } catch (e) {
      print(e.toString());
    }
  }

  updateStudent7FeeRec1({
    required int id,
    required String recDate,
    required String recRemarks,
  }) async {
    var db = await DatabaseProvider().init();
    try {
      var updateRec2SchoolBranch = await db.rawUpdate('''
          update Sch7FeeRec1 set FeeRecDate='$recDate',FeeRecRemarks='$recRemarks' where FeeRec1ID='$id'
          ''');

      print(
          '.....................$updateRec2SchoolBranch..............................');

      db.close();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List> dataForFeeRec(String feeRec1ID) async {
    var db = await DatabaseProvider().init();
    try {
      List list = await db.rawQuery('''
 Select FeeRecDate, FeeRecRemarks
From
Sch7FeeRec1
Where
FeeRec1ID='$feeRec1ID' AND
ClientID = $clientID 
          ''');
      return list;
    } catch (e) {
      return [];
    }
  }

  ///     Max ID Dor Rec 1 //////////////////////////////////
  Future<int> maxIDRex1() async {
    var db = await getDatabase();

    String maxFeeRec1Id = '''
    select -(IfNull(Max(Abs(FeeRec1ID)),0)+1) as MaxId from Sch7FeeRec1"+" where ClientID=$clientID
    ''';
    List listForRec1 = await db.rawQuery(maxFeeRec1Id);
    var feeRec1id = listForRec1[0]['MaxId'].round();

    return feeRec1id;
  }

  ///     insert into Sch REc 1 //////////////////////////////////
  insertRec1({
    required int feeRecAmount,
    required String feeRecDate,
    required String feeRecRemarks,
  }) async {
    var db = await getDatabase();

    try {
      var feeRec1id = await maxIDRex1();
      var v = await db.rawInsert(
          'INSERT INTO Sch7FeeRec1 (FeeRec1ID,FeeRecDate,FeeRecRemarks,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate)'
          ' VALUES (?,?,?,?,?,?,?,?)',
          [
            feeRec1id,
            feeRecDate.substring(0, 10),
            feeRecRemarks,
            clientID,
            clientUserID,
            0,
            0,
            ''
          ]);

      print('insert into 1 $v');
    } catch (e) {
      print(e.toString());
    }
  }

  ///     insert into Sch REc 2 //////////////////////////////////

  insertRec2({
    required String feeRecAmount,
    required String feeRecDate,
    required String feeRecRemarks,
    required String feeDueID,
    required int feeRec1id,
  }) async {
    var db = await getDatabase();

    try {
      // var feeRec1id = await maxIDRex1();
      String maxFeeRec2Id = '''
    select -(IfNull(Max(Abs(FeeRec2ID)),0)+1) as MaxId from Sch7FeeRec2"+" where ClientID=$clientID
    ''';
      List listForRec2 = await db.rawQuery(maxFeeRec2Id);
      var feeRec2id = listForRec2[0]['MaxId'].round();

      var q = await db.rawInsert(
          'INSERT INTO Sch7FeeRec2 (FeeRec2ID,FeeRec1ID,FeeDueID,RecAmount,ClientID,ClientUserID,NetCode,SysCode,UpdatedDate)'
          ' VALUES (?,?,?,?,?,?,?,?,?)',
          [
            feeRec2id,
            feeRec1id,
            feeDueID,
            feeRecAmount,
            clientID,
            clientUserID,
            0,
            0,
            ''
          ]);
      print('  .......insert 2 $q');
    } catch (e) {
      print(e.toString());
    }
  }

  ///      year total //////////////////////////////////
  Future<List> dataForYearTotal() async {
    String query = '';
    List list = [];
    query = '''
        SELECT MurjedUnionQuery.Year,
       SUM(MurjedUnionQuery.Due) AS TotalDue,
       SUM(MurjedUnionQuery.Received) AS TotalReceived,
       SUM(MurjedUnionQuery.Expense) AS TotalExpense,
       SUM(MurjedUnionQuery.Received) - SUM(MurjedUnionQuery.Expense) AS TotalBalance,
       MurjedUnionQuery.ClientID
FROM (
    SELECT STRFTIME('%Y', Sch6StudentFeeDue.DueDate) AS Year,
           SUM(Sch6StudentFeeDue.FeeDueAmount) AS Due,
           SUM(0) AS Received,
           SUM(0) AS Expense,
           Sch6StudentFeeDue.ClientID
    FROM Sch6StudentFeeDue
    WHERE Sch6StudentFeeDue.ClientID = '$clientId'
    GROUP BY STRFTIME('%Y', Sch6StudentFeeDue.DueDate), Sch6StudentFeeDue.ClientID

    UNION ALL

    SELECT STRFTIME('%Y', Sch7FeeRec1.FeeRecDate) AS Year,
           SUM(0) AS Due,
           SUM(Sch7FeeRec2.RecAmount) AS Received,
           SUM(0) AS Expense,
           Sch7FeeRec1.ClientID
    FROM Sch7FeeRec1
    LEFT JOIN Sch7FeeRec2 ON Sch7FeeRec2.FeeRec2ID = Sch7FeeRec1.FeeRec1ID
                           AND Sch7FeeRec2.ClientID = Sch7FeeRec1.ClientID
    WHERE Sch7FeeRec1.ClientID = '$clientId'
    GROUP BY STRFTIME('%Y', Sch7FeeRec1.FeeRecDate), Sch7FeeRec1.ClientID

    UNION ALL

    SELECT STRFTIME('%Y', CashBook.CBDate) AS Year,
           SUM(0) AS Due,
           SUM(0) AS Received,
           SUM(CashBook.Amount) AS Expense,
           CashBook.ClientID
    FROM CashBook
    LEFT JOIN Account3Name ON Account3Name.AcNameID = CashBook.DebitAccount
                           AND Account3Name.ClientID = CashBook.ClientID
    LEFT JOIN Account2Group ON Account2Group.AcGroupID = Account3Name.AcGroupID
                            AND Account2Group.ClientID = Account3Name.ClientID
    WHERE Account2Group.AcTypeID = '2'
      AND CashBook.ClientID = '$clientId'
    GROUP BY STRFTIME('%Y', CashBook.CBDate), CashBook.ClientID, Account2Group.AcTypeID
) AS MurjedUnionQuery
GROUP BY MurjedUnionQuery.Year, MurjedUnionQuery.ClientID;

        ''';
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }

      print('list of yea ris .................   $list');

      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  ///      month total //////////////////////////////////
  Future<List> dataForMonthTotal(String year) async {
    print(clientID);

    String query = '';
    List list = [];

    query = '''
       SELECT MurjedUnionQuery.Year,
       MurjedUnionQuery.Month,
       SUM(MurjedUnionQuery.Due) AS TotalDue,
       SUM(MurjedUnionQuery.Received) AS TotalReceived,
       SUM(MurjedUnionQuery.Expense) AS TotalExpense,
       SUM(MurjedUnionQuery.Received) - SUM(MurjedUnionQuery.Expense) AS TotalBalance,
       MurjedUnionQuery.ClientID
FROM (
    SELECT STRFTIME('%Y', Sch6StudentFeeDue.DueDate) AS Year,
           STRFTIME('%m', Sch6StudentFeeDue.DueDate) AS Month,
           SUM(Sch6StudentFeeDue.FeeDueAmount) AS Due,
           SUM(0) AS Received,
           SUM(0) AS Expense,
           Sch6StudentFeeDue.ClientID
    FROM Sch6StudentFeeDue
    WHERE Sch6StudentFeeDue.ClientID = '$clientId'
      AND STRFTIME('%Y', Sch6StudentFeeDue.DueDate) = '$year'
    GROUP BY STRFTIME('%Y', Sch6StudentFeeDue.DueDate),
             STRFTIME('%m', Sch6StudentFeeDue.DueDate),
             Sch6StudentFeeDue.ClientID

    UNION ALL

    SELECT STRFTIME('%Y', Sch7FeeRec1.FeeRecDate) AS Year,
           STRFTIME('%m', Sch7FeeRec1.FeeRecDate) AS Month,
           SUM(0) AS Due,
           SUM(Sch7FeeRec2.RecAmount) AS Received,
           SUM(0) AS Expense,
           Sch7FeeRec1.ClientID
    FROM Sch7FeeRec1
    LEFT JOIN Sch7FeeRec2 ON Sch7FeeRec2.FeeRec2ID = Sch7FeeRec1.FeeRec1ID
                           AND Sch7FeeRec2.ClientID = Sch7FeeRec1.ClientID
    WHERE Sch7FeeRec1.ClientID = '$clientId'
      AND STRFTIME('%Y', Sch7FeeRec1.FeeRecDate) = '$year'
    GROUP BY STRFTIME('%Y', Sch7FeeRec1.FeeRecDate),
             STRFTIME('%m', Sch7FeeRec1.FeeRecDate),
             Sch7FeeRec1.ClientID

    UNION ALL

    SELECT STRFTIME('%Y', CashBook.CBDate) AS Year,
           STRFTIME('%m', CashBook.CBDate) AS Month,
           SUM(0) AS Due,
           SUM(0) AS Received,
           SUM(CashBook.Amount) AS Expense,
           CashBook.ClientID
    FROM CashBook
    LEFT JOIN Account3Name ON Account3Name.AcNameID = CashBook.DebitAccount
                           AND Account3Name.ClientID = CashBook.ClientID
    LEFT JOIN Account2Group ON Account2Group.AcGroupID = Account3Name.AcGroupID
                            AND Account2Group.ClientID = Account3Name.ClientID
    WHERE Account2Group.AcTypeID = 2
      AND CashBook.ClientID = '$clientId'
      AND STRFTIME('%Y', CashBook.CBDate) = '$year'
    GROUP BY STRFTIME('%Y', CashBook.CBDate),
             STRFTIME('%m', CashBook.CBDate),
             CashBook.ClientID,
             Account2Group.AcTypeID
) AS MurjedUnionQuery
GROUP BY MurjedUnionQuery.Year,
         MurjedUnionQuery.Month,
         MurjedUnionQuery.ClientID;

       
       ''';
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  ///      day total //////////////////////////////////
  Future<List> dataForDayTotal(String year, String month) async {
    print(clientID);

    String query = '';
    List list = [];

    query = '''
       SELECT MurjedUnionQuery.Year,
       MurjedUnionQuery.Month,
       MurjedUnionQuery.Day,
       MurjedUnionQuery.DueDate AS Date,
       SUM(MurjedUnionQuery.Due) AS TotalDue,
       SUM(MurjedUnionQuery.Received) AS TotalReceived,
       SUM(MurjedUnionQuery.Expense) AS TotalExpense,
       MurjedUnionQuery.ClientID,
       SUM(MurjedUnionQuery.Received) - SUM(MurjedUnionQuery.Expense) AS TotalBalance
FROM (
    SELECT STRFTIME('%Y', Sch6StudentFeeDue.DueDate) AS Year,
           STRFTIME('%m', Sch6StudentFeeDue.DueDate) AS Month,
           STRFTIME('%d', Sch6StudentFeeDue.DueDate) AS Day,
           Sch6StudentFeeDue.DueDate,
           SUM(Sch6StudentFeeDue.FeeDueAmount) AS Due,
           SUM(0) AS Received,
           SUM(0) AS Expense,
           Sch6StudentFeeDue.ClientID
    FROM Sch6StudentFeeDue
    WHERE Sch6StudentFeeDue.ClientID = '$clientId'
      AND STRFTIME('%Y', Sch6StudentFeeDue.DueDate) = '$year'
      AND STRFTIME('%m', Sch6StudentFeeDue.DueDate) = '$month'
    GROUP BY STRFTIME('%Y', Sch6StudentFeeDue.DueDate),
             STRFTIME('%m', Sch6StudentFeeDue.DueDate),
             STRFTIME('%d', Sch6StudentFeeDue.DueDate),
             Sch6StudentFeeDue.DueDate,
             Sch6StudentFeeDue.ClientID

    UNION ALL

    SELECT STRFTIME('%Y', Sch7FeeRec1.FeeRecDate) AS Year,
           STRFTIME('%m', Sch7FeeRec1.FeeRecDate) AS Month,
           STRFTIME('%d', Sch7FeeRec1.FeeRecDate) AS Day,
           Sch7FeeRec1.FeeRecDate,
           SUM(0) AS Due,
           SUM(Sch7FeeRec2.RecAmount) AS Received,
           SUM(0) AS Expense,
           Sch7FeeRec1.ClientID
    FROM Sch7FeeRec1
    LEFT JOIN Sch7FeeRec2 ON Sch7FeeRec2.FeeRec2ID = Sch7FeeRec1.FeeRec1ID
                           AND Sch7FeeRec2.ClientID = Sch7FeeRec1.ClientID
    WHERE Sch7FeeRec1.ClientID = '$clientId'
      AND STRFTIME('%Y', Sch7FeeRec1.FeeRecDate) = '$year'
      AND STRFTIME('%m', Sch7FeeRec1.FeeRecDate) = '$month'
    GROUP BY STRFTIME('%Y', Sch7FeeRec1.FeeRecDate),
             STRFTIME('%m', Sch7FeeRec1.FeeRecDate),
             STRFTIME('%d', Sch7FeeRec1.FeeRecDate),
             Sch7FeeRec1.FeeRecDate,
             Sch7FeeRec1.ClientID

    UNION ALL

    SELECT STRFTIME('%Y', CashBook.CBDate) AS Year,
           STRFTIME('%m', CashBook.CBDate) AS Month,
           STRFTIME('%d', CashBook.CBDate) AS Day,
           CashBook.CBDate,
           SUM(0) AS Due,
           SUM(0) AS Received,
           SUM(CashBook.Amount) AS Expense,
           CashBook.ClientID
    FROM CashBook
    LEFT JOIN Account3Name ON Account3Name.AcNameID = CashBook.DebitAccount
                           AND Account3Name.ClientID = CashBook.ClientID
    LEFT JOIN Account2Group ON Account2Group.AcGroupID = Account3Name.AcGroupID
                            AND Account2Group.ClientID = Account3Name.ClientID
    WHERE STRFTIME('%Y', CashBook.CBDate) = '$year'
      AND STRFTIME('%m', CashBook.CBDate) = '$month'
      AND Account2Group.AcTypeID = 2
      AND CashBook.ClientID = '$clientId'
    GROUP BY STRFTIME('%Y', CashBook.CBDate),
             STRFTIME('%m', CashBook.CBDate),
             STRFTIME('%d', CashBook.CBDate),
             CashBook.CBDate,
             CashBook.ClientID,
             Account2Group.AcTypeID
) AS MurjedUnionQuery
GROUP BY MurjedUnionQuery.Year,
         MurjedUnionQuery.Month,
         MurjedUnionQuery.Day,
         MurjedUnionQuery.DueDate,
         MurjedUnionQuery.ClientID;

       
       ''';

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  ///      for bulk fee receiving  by all Search//////////////////////////////////
  Future<List> dataForAllStudentForNEWBYGRNANDFamilyGroupNo(
      String WhereValue, String WhereCondition) async {
    String query = '';
    List list = [];

    query = '''
    Select
    Sch1Branches.BranchName,
    Sch2Year.EducationalYear,
    Sch3Classes.ClassName,
    Sch4ClassesSection.SectionName,
    Sch6StudentFeeDue.GRN,
    Sch6StudentFeeDue.FeeNarration,
    Sch6StudentFeeDue.FeeDueAmount As TotalDue,
    Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalReceived,
    Sch6StudentFeeDue.FeeDueAmount - Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalBalance,
    Sch6StudentFeeDue.DueDate,
    Sch6StudentFeeDue.FeeDueID,
    Sch9StudentsInfo.*,
    Sch6StudentFeeDue.ClientID
From
    Sch6StudentFeeDue Left Join
    Sch7FeeRec2 On Sch7FeeRec2.FeeDueID = Sch6StudentFeeDue.FeeDueID
            And Sch7FeeRec2.ClientID = Sch6StudentFeeDue.ClientID Left Join
    Sch9StudentsInfo On Sch9StudentsInfo.GRN = Sch6StudentFeeDue.GRN
            And Sch9StudentsInfo.ClientID = Sch6StudentFeeDue.ClientID Left Join
    Sch5SectionStudent On Sch5SectionStudent.SectionStudenID = Sch6StudentFeeDue.SectionStudentID
            And Sch5SectionStudent.ClientID = Sch6StudentFeeDue.ClientID Left Join
    Sch4ClassesSection On Sch4ClassesSection.SectionID = Sch5SectionStudent.SectionID
            And Sch4ClassesSection.ClientID = Sch5SectionStudent.ClientID Left Join
    Sch3Classes On Sch3Classes.ClassID = Sch4ClassesSection.ClassID
            And Sch3Classes.ClientID = Sch4ClassesSection.ClientID Left Join
    Sch2Year On Sch2Year.EducationalYearID = Sch3Classes.EducationalYearID
            And Sch2Year.ClientID = Sch3Classes.ClientID Left Join
    Sch1Branches On Sch1Branches.BranchID = Sch2Year.BranchID
            And Sch1Branches.ClientID = Sch2Year.ClientID
Where
    $WhereCondition = '$WhereValue' And
    Sch6StudentFeeDue.ClientID = '$clientID'
Group By
    Sch1Branches.BranchName,
    Sch2Year.EducationalYear,
    Sch3Classes.ClassName,
    Sch4ClassesSection.SectionName,
    Sch6StudentFeeDue.GRN,
    Sch6StudentFeeDue.FeeNarration,
    Sch6StudentFeeDue.FeeDueAmount,
    Sch6StudentFeeDue.DueDate,
    Sch6StudentFeeDue.FeeDueID,
    Sch6StudentFeeDue.ClientID
Having
    Sch6StudentFeeDue.FeeDueAmount - Sum(IfNull(Sch7FeeRec2.RecAmount,0))<>0
    ''';

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      print('...........................list  of st === $list');
      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  ///      for bulk fee receiving  by all Search/for Edit/////////////////////////////////
  Future<List> dataForAllStudentForNEWBYGRNANDFamilyGroupNoForEdit(
      String WhereValue, String WhereCondition) async {
    String query = '';
    List list = [];

    query =
        "Select Sch1Branches.BranchName, Sch2Year.EducationalYear, Sch3Classes.ClassName, Sch4ClassesSection.SectionName, Sch6StudentFeeDue.GRN, Sch6StudentFeeDue.FeeNarration, Sch6StudentFeeDue.FeeDueAmount As TotalDue, Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalReceived, Sch6StudentFeeDue.FeeDueAmount - Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalBalance, Sch6StudentFeeDue.DueDate, Sch6StudentFeeDue.FeeDueID, Sch9StudentsInfo.*, Sch6StudentFeeDue.ClientID From Sch6StudentFeeDue Left Join Sch7FeeRec2 On Sch7FeeRec2.FeeDueID = Sch6StudentFeeDue.FeeDueID And Sch7FeeRec2.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch9StudentsInfo On Sch9StudentsInfo.GRN = Sch6StudentFeeDue.GRN And Sch9StudentsInfo.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionStudenID = Sch6StudentFeeDue.SectionStudentID And Sch5SectionStudent.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch4ClassesSection On Sch4ClassesSection.SectionID = Sch5SectionStudent.SectionID And Sch4ClassesSection.ClientID = Sch5SectionStudent.ClientID Left Join Sch3Classes On Sch3Classes.ClassID = Sch4ClassesSection.ClassID And Sch3Classes.ClientID = Sch4ClassesSection.ClientID Left Join Sch2Year On Sch2Year.EducationalYearID = Sch3Classes.EducationalYearID And Sch2Year.ClientID = Sch3Classes.ClientID Left Join Sch1Branches On Sch1Branches.BranchID = Sch2Year.BranchID And Sch1Branches.ClientID = Sch2Year.ClientID Where '$WhereCondition' = '$WhereValue' And Sch6StudentFeeDue.ClientID = '$clientID' Group By Sch1Branches.BranchName, Sch2Year.EducationalYear, Sch3Classes.ClassName, Sch4ClassesSection.SectionName, Sch6StudentFeeDue.GRN, Sch6StudentFeeDue.FeeNarration, Sch6StudentFeeDue.FeeDueAmount, Sch6StudentFeeDue.DueDate, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID Having Sch6StudentFeeDue.FeeDueAmount - Sum(IfNull(Sch7FeeRec2.RecAmount, 0))";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  ///      for bulk fee receiving  by  mobile number//////////////////////////////////
  Future<List> dataForAllStudentForNEWBYMobileNumber(String mobileNo) async {
    String query = '';
    List list = [];

    query =
        "Select Sch9StudentsInfo.*, Sch1Branches.BranchName, Sch2Year.EducationalYear, Sch3Classes.ClassName, Sch4ClassesSection.SectionName, Sch6StudentFeeDue.FeeNarration, Sch6StudentFeeDue.FeeDueAmount As TotalDue, Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalReceived, Sch6StudentFeeDue.DueDate, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID, Sch6StudentFeeDue.FeeDueAmount - Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalBalance, Sch9StudentsInfo.StudentMobileNo As StudentMobileNo1, Sch9StudentsInfo.FatherProfession As FatherProfession1, Sch9StudentsInfo.MotherMobileNo As MotherMobileNo1, Sch9StudentsInfo.GuardianMobileNo As GuardianMobileNo1 From Sch6StudentFeeDue Left Join Sch7FeeRec2 On Sch7FeeRec2.FeeDueID = Sch6StudentFeeDue.FeeDueID And Sch7FeeRec2.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch9StudentsInfo On Sch9StudentsInfo.GRN = Sch6StudentFeeDue.GRN And Sch9StudentsInfo.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionStudenID = Sch6StudentFeeDue.SectionStudentID And Sch5SectionStudent.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch4ClassesSection On Sch4ClassesSection.SectionID = Sch5SectionStudent.SectionID And Sch4ClassesSection.ClientID = Sch5SectionStudent.ClientID Left Join Sch3Classes On Sch3Classes.ClassID = Sch4ClassesSection.ClassID And Sch3Classes.ClientID = Sch4ClassesSection.ClientID Left Join Sch2Year On Sch2Year.EducationalYearID = Sch3Classes.EducationalYearID And Sch2Year.ClientID = Sch3Classes.ClientID Left Join Sch1Branches On Sch1Branches.BranchID = Sch2Year.BranchID And Sch1Branches.ClientID = Sch2Year.ClientID Where (Sch6StudentFeeDue.ClientID = '$clientID' And Sch9StudentsInfo.StudentMobileNo = '$mobileNo') Or (Sch9StudentsInfo.FatherMobileNo = '$mobileNo') Or (Sch9StudentsInfo.MotherMobileNo = '$mobileNo') Or (Sch9StudentsInfo.GuardianMobileNo = '$mobileNo') Group By Sch1Branches.BranchName, Sch2Year.EducationalYear, Sch3Classes.ClassName, Sch4ClassesSection.SectionName, Sch6StudentFeeDue.FeeNarration, Sch6StudentFeeDue.FeeDueAmount, Sch6StudentFeeDue.DueDate, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID, Sch9StudentsInfo.StudentMobileNo, Sch9StudentsInfo.FatherProfession, Sch9StudentsInfo.MotherMobileNo, Sch9StudentsInfo.GuardianMobileNo Having Sch6StudentFeeDue.FeeDueAmount - Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) <> 0";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  ///      for bulk fee receiving  by  Student name//////////////////////////////////
  Future<List> dataForAllStudentForNEWBYStudentName(String studentName) async {
    String query = '';
    List list = [];
    query =
        "Select Sch9StudentsInfo.*, Sch1Branches.BranchName, Sch2Year.EducationalYear, Sch3Classes.ClassName, Sch4ClassesSection.SectionName, Sch6StudentFeeDue.FeeNarration, Sch6StudentFeeDue.FeeDueAmount As TotalDue, Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalReceived, Sch6StudentFeeDue.DueDate, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID, Sch6StudentFeeDue.FeeDueAmount - Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalBalance, Sch9StudentsInfo.StudentName As StudentName1, Sch6StudentFeeDue.GRN As GRN1 From Sch6StudentFeeDue Left Join Sch7FeeRec2 On Sch7FeeRec2.FeeDueID = Sch6StudentFeeDue.FeeDueID And Sch7FeeRec2.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch9StudentsInfo On Sch9StudentsInfo.GRN = Sch6StudentFeeDue.GRN And Sch9StudentsInfo.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionStudenID = Sch6StudentFeeDue.SectionStudentID And Sch5SectionStudent.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch4ClassesSection On Sch4ClassesSection.SectionID = Sch5SectionStudent.SectionID And Sch4ClassesSection.ClientID = Sch5SectionStudent.ClientID Left Join Sch3Classes On Sch3Classes.ClassID = Sch4ClassesSection.ClassID And Sch3Classes.ClientID = Sch4ClassesSection.ClientID Left Join Sch2Year On Sch2Year.EducationalYearID = Sch3Classes.EducationalYearID And Sch2Year.ClientID = Sch3Classes.ClientID Left Join Sch1Branches On Sch1Branches.BranchID = Sch2Year.BranchID And Sch1Branches.ClientID = Sch2Year.ClientID Where Sch6StudentFeeDue.ClientID = '$clientID' And Sch9StudentsInfo.StudentName Like '%$studentName%' Group By Sch1Branches.BranchName, Sch2Year.EducationalYear, Sch3Classes.ClassName, Sch4ClassesSection.SectionName, Sch6StudentFeeDue.FeeNarration, Sch6StudentFeeDue.FeeDueAmount, Sch6StudentFeeDue.DueDate, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID, Sch9StudentsInfo.StudentName, Sch6StudentFeeDue.GRN Having Sch6StudentFeeDue.FeeDueAmount - Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) <> 0";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  ///      for bulk fee receiving  by  Student name//////////////////////////////////
  Future<List> selectPhoneNumberOFStudent(String feeRecID) async {
    String query = '';
    List list = [];

    query =
        "Select Sch7FeeRec1.FeeRec1ID, Sch7FeeRec2.FeeRec2ID, Sch7FeeRec1.FeeRecDate, Sch7FeeRec1.FeeRecRemarks, Sch7FeeRec2.FeeDueID, Sch7FeeRec2.RecAmount, Sch6StudentFeeDue.DueDate, Sch6StudentFeeDue.FeeNarration, Sch6StudentFeeDue.FeeDueAmount, Sch5SectionStudent.GRN, Sch4ClassesSection.SectionName, Sch3Classes.ClassName, Sch2Year.EducationalYear, Sch9StudentsInfo.StudentID, Sch9StudentsInfo.FamilyGroupNo, Sch9StudentsInfo.StudentName, Sch9StudentsInfo.FahterName, Sch9StudentsInfo.MotherName, Sch9StudentsInfo.FatherMobileNo, Sch9StudentsInfo.MotherMobileNo, Sch9StudentsInfo.GuardianMobileNo, Sch9StudentsInfo.StudentMobileNo, Sch7FeeRec1.ClientID From Sch7FeeRec1 Left Join Sch7FeeRec2 On Sch7FeeRec2.FeeRec1ID = Sch7FeeRec1.FeeRec1ID And Sch7FeeRec2.ClientID = Sch7FeeRec1.ClientID Left Join Sch6StudentFeeDue On Sch6StudentFeeDue.FeeDueID = Sch7FeeRec2.FeeDueID And Sch6StudentFeeDue.ClientID = Sch7FeeRec2.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionStudenID = Sch6StudentFeeDue.SectionStudentID And Sch5SectionStudent.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch4ClassesSection On Sch4ClassesSection.SectionID = Sch5SectionStudent.SectionID And Sch4ClassesSection.ClientID = Sch5SectionStudent.ClientID Left Join Sch3Classes On Sch3Classes.ClassID = Sch4ClassesSection.ClassID And Sch3Classes.ClientID = Sch4ClassesSection.ClientID Left Join Sch2Year On Sch2Year.EducationalYearID = Sch3Classes.EducationalYearID And Sch2Year.ClientID = Sch3Classes.ClientID Left Join Sch9StudentsInfo On Sch9StudentsInfo.GRN = Sch5SectionStudent.GRN And Sch9StudentsInfo.ClientID = Sch5SectionStudent.ClientID Where Sch7FeeRec1.FeeRec1ID = '$feeRecID' And Sch7FeeRec1.ClientID = '$clientId'";
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);

        print('${list}///////////////////////////////////////////////////////');
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}

Future<bool> updateNumbersForFeeRecStudent({
  String? GRN,
  String? StudentMobileNo,

}) async {
  var database = await DatabaseProvider().init();
  try {
    await database.rawUpdate('''
          update Sch9StudentsInfo set StudentMobileNo='$StudentMobileNo'
        
           where GRN='$GRN' AND ClientID='$clientID'
          ''');

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}
Future<bool> updateNumbersForFeeRecFather({
  String? GRN,


  String? FatherMobileNo,

}) async {
  var database = await DatabaseProvider().init();
  try {
    await database.rawUpdate('''
          update Sch9StudentsInfo set
         FatherMobileNo='$FatherMobileNo'
           where GRN='$GRN' AND ClientID='$clientID'
          ''');

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}
Future<bool> updateNumbersForFeeRecMother({
  String? GRN,


  String? MotherMobileNo,
}) async {
  var database = await DatabaseProvider().init();
  try {
    await database.rawUpdate('''
          update Sch9StudentsInfo set 
         MotherMobileNo='$MotherMobileNo'
           where GRN='$GRN' AND ClientID='$clientID'
          ''');

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> updateNumbersForFeeRecGuardian({
  String? GRN,

  String? GuardianMobileNo,

}) async {
  var database = await DatabaseProvider().init();
  try {
    await database.rawUpdate('''
          update Sch9StudentsInfo set 
         GuardianMobileNo='$GuardianMobileNo'
           where GRN='$GRN' AND ClientID='$clientID'
          ''');

    database.close();

    return true;
  } catch (e) {
    return false;
  }
}