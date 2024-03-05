import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../utils/api_query_for_web.dart';



class SchoolSQL {
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

  ///      data for Sch1Branch ///////////////////////////////////
  Future<List> dataForSch1Branch() async {

    String query = '';
    List list = [];
    query =

    '''
    Select
    Sch1Branches.*,
    Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue,
    Sum(DueAndBalance.SumOfReceived) As TotalReceived,
    Sum(DueAndBalance.SumOfBalance) As TotalBalance,
    Sch1Branches.ID As ID1,
    StuQty.StudentQty
From
    Sch1Branches Left Join
    Sch2Year On Sch2Year.BranchID = Sch1Branches.BranchID
            And Sch2Year.ClientID = Sch1Branches.ClientID Left Join
    Sch3Classes On Sch3Classes.EducationalYearID = Sch2Year.EducationalYearID
            And Sch3Classes.ClientID = Sch2Year.ClientID Left Join
    Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID
            And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join
    Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID
            And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID Left Join
    Sch6StudentFeeDue On Sch6StudentFeeDue.SectionStudentID = Sch5SectionStudent.SectionStudenID
            And Sch6StudentFeeDue.ClientID = Sch5SectionStudent.ClientID Left Join
    (Select
         Sch6StudentFeeDue.SectionStudentID,
         Sch6StudentFeeDue.FeeDueID,
         Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount,
         Sum(Received.TotalReceived) As SumOfReceived,
         Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance,
         Sch6StudentFeeDue.ClientID
     From
         Sch6StudentFeeDue Left Join
         (Select
              Sch7FeeRec2.FeeDueID,
              Sum(Sch7FeeRec2.RecAmount) As TotalReceived,
              Sch7FeeRec2.ClientID
          From
              Sch7FeeRec2
          Group By
              Sch7FeeRec2.FeeDueID,
              Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID
                 And Received.ClientID = Sch6StudentFeeDue.ClientID
     Group By
         Sch6StudentFeeDue.SectionStudentID,
         Sch6StudentFeeDue.FeeDueID,
         Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID
            And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Left Join
    (Select
         Sch1Branches.BranchID,
         Sch1Branches.ClientID,
         Count(Sch5SectionStudent.GRN) As StudentQty
     From
         Sch1Branches Left Join
         Sch2Year On Sch2Year.BranchID = Sch1Branches.BranchID
                 And Sch2Year.ClientID = Sch1Branches.ClientID Left Join
         Sch3Classes On Sch3Classes.ClientID = Sch2Year.ClientID
                 And Sch3Classes.EducationalYearID = Sch2Year.EducationalYearID Left Join
         Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID
                 And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join
         Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID
                 And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID
     Where
         Sch5SectionStudent.GRN <> ''
     Group By
         Sch1Branches.BranchID,
         Sch1Branches.ClientID) StuQty On StuQty.BranchID = Sch1Branches.BranchID
            And StuQty.ClientID = Sch1Branches.ClientID
Where
    Sch1Branches.ClientID = '$clientID'
Group By
    Sch1Branches.ClientID,
    Sch1Branches.ID,
    StuQty.StudentQty
    ''';
       // "Select Sch1Branches.*, Sch1Branches.ID As ID1,Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue, Sum(DueAndBalance.SumOfReceived) As TotalReceived, Sum(DueAndBalance.SumOfBalance) As TotalBalance From Sch1Branches Left Join Sch2Year On Sch2Year.BranchID = Sch1Branches.BranchID And Sch2Year.ClientID = Sch1Branches.ClientID Left Join Sch3Classes On Sch3Classes.EducationalYearID = Sch2Year.EducationalYearID And Sch3Classes.ClientID = Sch2Year.ClientID Left Join Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID  And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID Left Join Sch6StudentFeeDue On Sch6StudentFeeDue.SectionStudentID = Sch5SectionStudent.SectionStudenID And Sch6StudentFeeDue.ClientID = Sch5SectionStudent.ClientID Left Join (Select Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount,  Sum(Received.TotalReceived) As SumOfReceived,  Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance, Sch6StudentFeeDue.ClientID From Sch6StudentFeeDue Left Join (Select Sch7FeeRec2.FeeDueID, Sum(Sch7FeeRec2.RecAmount) As TotalReceived, Sch7FeeRec2.ClientID From Sch7FeeRec2 Group By Sch7FeeRec2.FeeDueID, Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID And Received.ClientID = Sch6StudentFeeDue.ClientID Group By Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID  And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Where Sch1Branches.ClientID = '$clientID' Group By Sch1Branches.ID, Sch1Branches.ClientID";

    try {

      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        // list = await apiFetchForWeb(query: query);

      }
      List listCopy = List.from(list);
      listCopy.sort((a, b) => a["BranchName"].compareTo(b["BranchName"]));

      print(listCopy);


      return listCopy;
    } catch (e) {
      return [];
    }
  }

  ///      data for Sch1Educational Year ///////////////////////////////////
  Future<List> dataForSch1EducationYear({required String branchID}) async {
    String query = '';
    List list = [];
    query =
    '''
    Select
    Sch2Year.*,
    Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue,
    Sum(DueAndBalance.SumOfReceived) As TotalReceived,
    Sum(DueAndBalance.SumOfBalance) As TotalBalance,
    Sch2Year.ID As ID1,
    Account3Name.AcName As UserName,
    StuQty.StudentQTY
From
    Sch2Year Left Join
    Sch3Classes On Sch3Classes.EducationalYearID = Sch2Year.EducationalYearID
            And Sch3Classes.ClientID = Sch2Year.ClientID Left Join
    Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID
            And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join
    Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID
            And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID Left Join
    Sch6StudentFeeDue On Sch6StudentFeeDue.SectionStudentID = Sch5SectionStudent.SectionStudenID
            And Sch6StudentFeeDue.ClientID = Sch5SectionStudent.ClientID Left Join
    (Select
         Sch6StudentFeeDue.SectionStudentID,
         Sch6StudentFeeDue.FeeDueID,
         Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount,
         Sum(Received.TotalReceived) As SumOfReceived,
         Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance,
         Sch6StudentFeeDue.ClientID
     From
         Sch6StudentFeeDue Left Join
         (Select
              Sch7FeeRec2.FeeDueID,
              Sum(Sch7FeeRec2.RecAmount) As TotalReceived,
              Sch7FeeRec2.ClientID
          From
              Sch7FeeRec2
          Group By
              Sch7FeeRec2.FeeDueID,
              Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID
                 And Received.ClientID = Sch6StudentFeeDue.ClientID
     Group By
         Sch6StudentFeeDue.SectionStudentID,
         Sch6StudentFeeDue.FeeDueID,
         Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID
            And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Left Join
    Account3Name On Account3Name.ClientID = Sch2Year.ClientID
            And Account3Name.AcNameID = Sch2Year.ClientUserID Left Join
    (Select
         Sch2Year.EducationalYear,
         Sch2Year.ClientID,
         Count(Sch5SectionStudent.GRN) As StudentQTY
     From
         Sch2Year Left Join
         Sch3Classes On Sch3Classes.EducationalYearID = Sch2Year.EducationalYearID
                 And Sch3Classes.ClientID = Sch2Year.ClientID Left Join
         Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID
                 And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join
         Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID
                 And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID
     Where
         Sch5SectionStudent.GRN <> ""
     Group By
         Sch2Year.EducationalYear,
         Sch2Year.ClientID) StuQty On StuQty.EducationalYear = Sch2Year.EducationalYear
            And StuQty.ClientID = Sch2Year.ClientID
Where
    Sch2Year.ClientID = '$clientID' And
    Sch2Year.BranchID = $branchID
Group By
    Sch2Year.ID,
    Account3Name.AcName,
    Sch2Year.ClientID,
    Sch2Year.BranchID,
    StuQty.StudentQTY
        '''    ;



    //"Select Sch2Year.*, Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue,  Sum(DueAndBalance.SumOfReceived) As TotalReceived, Sum(DueAndBalance.SumOfBalance) As TotalBalance, Sch2Year.ID As ID1,  Account3Name.AcName As UserName From Sch2Year Left Join Sch3Classes On Sch3Classes.EducationalYearID = Sch2Year.EducationalYearID And Sch3Classes.ClientID = Sch2Year.ClientID Left Join Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID Left Join Sch6StudentFeeDue On Sch6StudentFeeDue.SectionStudentID = Sch5SectionStudent.SectionStudenID And Sch6StudentFeeDue.ClientID = Sch5SectionStudent.ClientID Left Join (Select  Sch6StudentFeeDue.SectionStudentID,  Sch6StudentFeeDue.FeeDueID,  Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount, Sum(Received.TotalReceived) As SumOfReceived,  Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance, Sch6StudentFeeDue.ClientID From Sch6StudentFeeDue Left Join  (Select  Sch7FeeRec2.FeeDueID, Sum(Sch7FeeRec2.RecAmount) As TotalReceived, Sch7FeeRec2.ClientID From Sch7FeeRec2 Group By Sch7FeeRec2.FeeDueID, Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID And Received.ClientID = Sch6StudentFeeDue.ClientID Group By Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID  And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Left Join  Account3Name On Account3Name.ClientID = Sch2Year.ClientID And Account3Name.AcNameID = Sch2Year.ClientUserID Where Sch2Year.ClientID = '$clientID' And  Sch2Year.BranchID = $branchID Group By Sch2Year.ID, Sch2Year.ClientID, Sch2Year.BranchID, Account3Name.AcName";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  ///      data for Sch1Educational Year  class ///////////////////////////////////
  Future<List> dataForSch1EducationYearClass(
      {required String educationalYearID}) async {
    String query = '';
    List list = [];

    query =
       // "Select Sch3Classes.*, Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue, Sum(DueAndBalance.SumOfReceived) As TotalReceived, Sum(DueAndBalance.SumOfBalance) As TotalBalance, Account3Name.AcName As UserName, Sch3Classes.ID As ID1 From Sch3Classes Left Join Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID Left Join Sch6StudentFeeDue On Sch6StudentFeeDue.SectionStudentID = Sch5SectionStudent.SectionStudenID And Sch6StudentFeeDue.ClientID = Sch5SectionStudent.ClientID Left Join (Select Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount, Sum(Received.TotalReceived) As SumOfReceived, Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance, Sch6StudentFeeDue.ClientID From Sch6StudentFeeDue Left Join (Select Sch7FeeRec2.FeeDueID, Sum(Sch7FeeRec2.RecAmount) As TotalReceived, Sch7FeeRec2.ClientID From Sch7FeeRec2 Group By Sch7FeeRec2.FeeDueID, Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID And Received.ClientID = Sch6StudentFeeDue.ClientID Group By Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Left Join Account3Name On Account3Name.AcName = Sch3Classes.ClientUserID And Account3Name.ClientID = Sch3Classes.ClientID Where Sch3Classes.EducationalYearID = '$educationalYearID' AND Sch3Classes.ClientID = '$clientID' Group By Account3Name.AcName, Sch3Classes.ID, Sch3Classes.ClientID, Sch3Classes.EducationalYearID";

    '''
    Select
    Sch3Classes.*,
    Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue,
    Sum(DueAndBalance.SumOfReceived) As TotalReceived,
    Sum(DueAndBalance.SumOfBalance) As TotalBalance,
    Account3Name.AcName As UserName,
    Sch3Classes.ID As ID1,
    StuQty.StudentQTY
From
    Sch3Classes Left Join
    Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID
            And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join
    Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID
            And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID Left Join
    Sch6StudentFeeDue On Sch6StudentFeeDue.SectionStudentID = Sch5SectionStudent.SectionStudenID
            And Sch6StudentFeeDue.ClientID = Sch5SectionStudent.ClientID Left Join
    (Select
         Sch6StudentFeeDue.SectionStudentID,
         Sch6StudentFeeDue.FeeDueID,
         Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount,
         Sum(Received.TotalReceived) As SumOfReceived,
         Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance,
         Sch6StudentFeeDue.ClientID
     From
         Sch6StudentFeeDue Left Join
         (Select
              Sch7FeeRec2.FeeDueID,
              Sum(Sch7FeeRec2.RecAmount) As TotalReceived,
              Sch7FeeRec2.ClientID
          From
              Sch7FeeRec2
          Group By
              Sch7FeeRec2.FeeDueID,
              Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID
                 And Received.ClientID = Sch6StudentFeeDue.ClientID
     Group By
         Sch6StudentFeeDue.SectionStudentID,
         Sch6StudentFeeDue.FeeDueID,
         Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID
            And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Left Join
    Account3Name On Account3Name.AcName = Sch3Classes.ClientUserID
            And Account3Name.ClientID = Sch3Classes.ClientID Left Join
    (Select
         Sch3Classes.ClassID,
         Sch3Classes.ClientID,
         Count(Sch5SectionStudent.GRN) As StudentQTY
     From
         Sch3Classes Left Join
         Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID
                 And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join
         Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID
                 And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID
     Where
         Sch5SectionStudent.GRN <> ""
     Group By
         Sch3Classes.ClassID,
         Sch3Classes.ClientID) StuQty On StuQty.ClassID = Sch3Classes.ClassID
            And StuQty.ClientID = Sch3Classes.ClientID
Where
    Sch3Classes.EducationalYearID = '$educationalYearID' And
    Sch3Classes.ClientID = '$clientID'
Group By
    Account3Name.AcName,
    Sch3Classes.ID,
    StuQty.StudentQTY,
    Sch3Classes.ClientID,
    Sch3Classes.EducationalYearID
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
      return [];
    }
  }

  ///      data for Sch1  class  section///////////////////////////////////
  Future<List> dataForSch1ClassSection({required String classID}) async {
    String query = '';
    List list = [];
    query = '''
    Select
    Sch4ClassesSection.*,
    Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue,
    Sum(DueAndBalance.SumOfReceived) As TotalReceived,
    Sum(DueAndBalance.SumOfBalance) As TotalBalance,
    Account3Name.AcName As UserName,
    Sch4ClassesSection.ID As ID1,
    SutQty.StudentQTY
From
    Sch4ClassesSection Left Join
    Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID
            And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID Left Join
    Sch6StudentFeeDue On Sch6StudentFeeDue.SectionStudentID = Sch5SectionStudent.SectionStudenID
            And Sch6StudentFeeDue.ClientID = Sch5SectionStudent.ClientID Left Join
    (Select
         Sch6StudentFeeDue.SectionStudentID,
         Sch6StudentFeeDue.FeeDueID,
         Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount,
         Sum(Received.TotalReceived) As SumOfReceived,
         Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance,
         Sch6StudentFeeDue.ClientID
     From
         Sch6StudentFeeDue Left Join
         (Select
              Sch7FeeRec2.FeeDueID,
              Sum(Sch7FeeRec2.RecAmount) As TotalReceived,
              Sch7FeeRec2.ClientID
          From
              Sch7FeeRec2
          Group By
              Sch7FeeRec2.FeeDueID,
              Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID
                 And Received.ClientID = Sch6StudentFeeDue.ClientID
     Group By
         Sch6StudentFeeDue.SectionStudentID,
         Sch6StudentFeeDue.FeeDueID,
         Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID
            And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Left Join
    Account3Name On Account3Name.ClientID = Sch4ClassesSection.ClientID
            And Account3Name.AcNameID = Sch4ClassesSection.ClientUserID Left Join
    (Select
         Sch5SectionStudent.SectionID,
         Sch5SectionStudent.ClientID,
         Count(Sch5SectionStudent.GRN) As StudentQTY
     From
         Sch5SectionStudent
     Where
         Sch5SectionStudent.GRN <> ""
     Group By
         Sch5SectionStudent.SectionID,
         Sch5SectionStudent.ClientID) SutQty On SutQty.SectionID = Sch4ClassesSection.SectionID
            And SutQty.ClientID = Sch4ClassesSection.ClientID
Where
    Sch4ClassesSection.ClassID = '$classID' And
    Sch4ClassesSection.ClientID = '$clientID'
Group By
    Account3Name.AcName,
    Sch4ClassesSection.ID,
    SutQty.StudentQTY,
    Sch4ClassesSection.ClassID,
    Sch4ClassesSection.ClientID
    ''';
    //"Select Sch4ClassesSection.*, Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue, Sum(DueAndBalance.SumOfReceived) As TotalReceived, Sum(DueAndBalance.SumOfBalance) As TotalBalance, Account3Name.AcName As UserName, Sch4ClassesSection.ID As ID1 From Sch4ClassesSection Left Join Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID Left Join Sch6StudentFeeDue On Sch6StudentFeeDue.SectionStudentID = Sch5SectionStudent.SectionStudenID And Sch6StudentFeeDue.ClientID = Sch5SectionStudent.ClientID Left Join (Select Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount, Sum(Received.TotalReceived) As SumOfReceived, Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance, Sch6StudentFeeDue.ClientID From Sch6StudentFeeDue Left Join (Select Sch7FeeRec2.FeeDueID, Sum(Sch7FeeRec2.RecAmount) As TotalReceived, Sch7FeeRec2.ClientID From Sch7FeeRec2 Group By Sch7FeeRec2.FeeDueID, Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID And Received.ClientID = Sch6StudentFeeDue.ClientID Group By Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Left Join Account3Name On Account3Name.ClientID = Sch4ClassesSection.ClientID And Account3Name.AcNameID = Sch4ClassesSection.ClientUserID Where Sch4ClassesSection.ClassID = '$classID' And Sch4ClassesSection.ClientID = '$clientID' Group By Account3Name.AcName, Sch4ClassesSection.ID, Sch4ClassesSection.ClassID, Sch4ClassesSection.ClientID";
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }

      print('................... list of section ..........................$list');
      return list;
    } catch (e) {
      return [];
    }
  }

  ///      data for Sch1  class  section   Student///////////////////////////////////
  Future<List> dataForSch1ClassSectionStudent(
      {required String sectionID}) async {
    String query = '';
    List list = [];
    query =
        "Select Sch5SectionStudent.*, Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue, Sum(DueAndBalance.SumOfReceived) As TotalReceived, Sum(DueAndBalance.SumOfBalance) As TotalBalance, Account3Name.AcName As UserName, Sch5SectionStudent.ID As ID1, Sch9StudentsInfo.StudentID, Sch9StudentsInfo.AdmissionDate, Sch9StudentsInfo.GRN As GRN1, Sch9StudentsInfo.FamilyGroupNo, Sch9StudentsInfo.StudentName, Sch9StudentsInfo.FahterName From Sch5SectionStudent Left Join Sch6StudentFeeDue On Sch6StudentFeeDue.SectionStudentID = Sch5SectionStudent.SectionStudenID And Sch6StudentFeeDue.ClientID = Sch5SectionStudent.ClientID Left Join (Select Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount, Sum(Received.TotalReceived) As SumOfReceived, Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance, Sch6StudentFeeDue.ClientID From Sch6StudentFeeDue Left Join (Select Sch7FeeRec2.FeeDueID, Sum(Sch7FeeRec2.RecAmount) As TotalReceived, Sch7FeeRec2.ClientID From Sch7FeeRec2 Group By Sch7FeeRec2.FeeDueID, Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID And Received.ClientID = Sch6StudentFeeDue.ClientID Group By Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Left Join Account3Name On Account3Name.AcNameID = Sch5SectionStudent.ClientUserID And Account3Name.ClientID = Sch5SectionStudent.ClientID Left Join Sch9StudentsInfo On Sch9StudentsInfo.ClientID = Sch5SectionStudent.ClientID And Sch9StudentsInfo.GRN = Sch5SectionStudent.GRN Where Sch5SectionStudent.ClientID = '$clientID' And Sch5SectionStudent.SectionID = $sectionID Group By Account3Name.AcName, Sch5SectionStudent.ID, Sch5SectionStudent.ClientID, Sch5SectionStudent.SectionID, Sch9StudentsInfo.StudentID, Sch9StudentsInfo.AdmissionDate, Sch9StudentsInfo.GRN, Sch9StudentsInfo.FamilyGroupNo, Sch9StudentsInfo.StudentName, Sch9StudentsInfo.FahterName";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  ///      data for Sch1  class  fee due///////////////////////////////////
  Future<List> dataForSch1StudentFeeDue(
      {required String sectionStudentID}) async {
    String query = '';
    List list = [];
    query =
        "Select Sch6StudentFeeDue.*, Sum(DueAndBalance.SumOfFeeDueAmount) As TotalDue, Sum(DueAndBalance.SumOfReceived) As TotalReceived, Sum(DueAndBalance.SumOfBalance) As TotalBalance, Account3Name.AcName As UserName, Sch6StudentFeeDue.ID As ID From Sch6StudentFeeDue Left Join (Select Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sum(Sch6StudentFeeDue.FeeDueAmount) As SumOfFeeDueAmount, Sum(Received.TotalReceived) As SumOfReceived, Sum(Sch6StudentFeeDue.FeeDueAmount - IfNull(Received.TotalReceived, 0)) As SumOfBalance, Sch6StudentFeeDue.ClientID From Sch6StudentFeeDue Left Join (Select Sch7FeeRec2.FeeDueID, Sum(Sch7FeeRec2.RecAmount) As TotalReceived, Sch7FeeRec2.ClientID From Sch7FeeRec2 Group By Sch7FeeRec2.FeeDueID, Sch7FeeRec2.ClientID) Received On Received.FeeDueID = Sch6StudentFeeDue.FeeDueID And Received.ClientID = Sch6StudentFeeDue.ClientID Group By Sch6StudentFeeDue.SectionStudentID, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.ClientID) DueAndBalance On DueAndBalance.ClientID = Sch6StudentFeeDue.ClientID And DueAndBalance.FeeDueID = Sch6StudentFeeDue.FeeDueID Left Join Account3Name On Account3Name.ClientID = Sch6StudentFeeDue.ClientID And Account3Name.AcNameID = Sch6StudentFeeDue.ClientUserID Where Sch6StudentFeeDue.ClientID = $clientID And Sch6StudentFeeDue.SectionStudentID = '$sectionStudentID' Group By Account3Name.AcName, Sch6StudentFeeDue.ID, Sch6StudentFeeDue.ClientID, Sch6StudentFeeDue.SectionStudentID";
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }

      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List> checkNewAllFeeDueForDeletion() async {
    String query = '';
    List data = [] ;
    query =
    "Select From Sch6StudentFeeDue Where Sch6StudentFeeDue.UpdatedDate = '' AND Sch6StudentFeeDue.FeeDueID < 0 AND Sch6StudentFeeDue.ClientID = '$clientID'";
    try {
      if (!kIsWeb) {
        Database db = await getDatabase();
        data = await db.rawQuery(query);
      } else {
        // list = await apiFetchForWeb(query: query);
      }
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<int> deleteNewAllFeeDue() async {
    String query = '';
    int delete = 0;
    query =
    "Delete From Sch6StudentFeeDue Where Sch6StudentFeeDue.UpdatedDate = '' AND Sch6StudentFeeDue.FeeDueID < 0 AND Sch6StudentFeeDue.ClientID = '$clientID'";
    try {
      if (!kIsWeb) {
        Database db = await getDatabase();
        delete = await db.rawDelete(query);
      } else {
        // list = await apiFetchForWeb(query: query);
      }
      return delete;
    } catch (e) {
      return 0;
    }
  }
  Future<int> deleteNewAllFeeREC1() async {
    String query = '';
    int delete = 0;
    query =
    "Delete From Sch7FeeRec1 Where Sch7FeeRec1.UpdatedDate = '' AND Sch7FeeRec1.FeeRec1ID  < 0 AND Sch7FeeRec1.ClientID = '$clientID'";
    try {
      if (!kIsWeb) {
        Database db = await getDatabase();
        delete = await db.rawDelete(query);
      } else {
        // list = await apiFetchForWeb(query: query);
      }
      return delete;
    } catch (e) {
      return 0;
    }
  }

  Future<int> deleteNewAllFeeREC2() async {
    String query = '';
    int delete = 0;
    query =
    "Delete From Sch7FeeRec2 Where Sch7FeeRec2.UpdatedDate = '' AND Sch7FeeRec2.FeeRec2ID  < 0 AND Sch7FeeRec2.ClientID = '$clientID'";
    try {
      if (!kIsWeb) {
        Database db = await getDatabase();
        delete = await db.rawDelete(query);
      } else {
        // list = await apiFetchForWeb(query: query);
      }
      return delete;
    } catch (e) {
      return 0;
    }
  }

  ///      data for Sch1  fee received///////////////////////////////////
  Future<List> dataForSch1FeeReceived({required String feeDueID}) async {
    String query = '';
    List list = [];
    query =
       ''' Select
    Sch7FeeRec2.*,
    Sch7FeeRec1.FeeRecDate,
    Sch7FeeRec1.FeeRecRemarks,
    Sch7FeeRec2.FeeDueID,
    Sch6StudentFeeDue.FeeDueAmount,
    Sch7FeeRec2.ClientID,
    Account3Name.AcName As UserName,
    Sch7FeeRec2.RecAmount,
    Sch6StudentFeeDue.FeeDueAmount - IfNull(Sch7FeeRec2.RecAmount, 0) As TotalBalance
    From
    Sch7FeeRec2 Left Join
    Sch7FeeRec1 On Sch7FeeRec1.FeeRec1ID = Sch7FeeRec2.FeeRec1ID
    And Sch7FeeRec1.ClientID = Sch7FeeRec2.ClientID Left Join
    Account3Name On Account3Name.ClientID = Sch7FeeRec2.ClientID
    And Account3Name.AcNameID = Sch7FeeRec2.ClientUserID Left Join
    Sch6StudentFeeDue On Sch6StudentFeeDue.FeeDueID = Sch7FeeRec2.FeeDueID
    And Sch6StudentFeeDue.ClientID = Sch7FeeRec2.ClientID
    Where
    Sch7FeeRec2.FeeDueID = '$feeDueID' And
    Sch7FeeRec2.ClientID = '$clientID'
    Group By
    Sch7FeeRec1.FeeRecDate,
    Sch7FeeRec1.FeeRecRemarks,
    Sch7FeeRec2.FeeDueID,
    Sch6StudentFeeDue.FeeDueAmount,
    Sch7FeeRec2.ClientID,
    Account3Name.AcName,
    Sch7FeeRec2.RecAmount,
    Sch6StudentFeeDue.FeeDueAmount - IfNull(Sch7FeeRec2.RecAmount,0)''';
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  ///      bulk fee due to all student of year//////////////////////////////////
  Future<List> dataForBulkFeeAllStudentYear(
      {required String iD, required String whereCon}) async {

    String query = '';
    List list = [];
    query =
        '''Select Sch5SectionStudent.GRN, Sch5SectionStudent.MonthlyFee, Sch5SectionStudent.SectionID, Sch5SectionStudent.SectionStudenID, Sch3Classes.EducationalYearID, Sch3Classes.ClientID From Sch3Classes Left Join Sch4ClassesSection On Sch4ClassesSection.ClassID = Sch3Classes.ClassID And Sch4ClassesSection.ClientID = Sch3Classes.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionID = Sch4ClassesSection.SectionID And Sch5SectionStudent.ClientID = Sch4ClassesSection.ClientID Where Sch5SectionStudent.GRN Is Not Null And  $whereCon = $iD And Sch3Classes.ClientID = $clientID ''';
    try {
      if (!kIsWeb) {

        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }


      return list;
    } catch (e) {
      return [];
    }
  }

  /// insert into sch9Admission //////////////////////////////////

  Future<bool> insertSch9Admission({
    required BuildContext context,
    String? GRN,
    String? StudentName,
    String? FahterName,
    String? FatherMobileNo,
    String? FatherNIC,
    String? MotherName,
    String? MotherMobileNo,
    String? OtherDetail,
    String? AdmissionDate,
    String? LeavingDate,
    String? MotherNIC,
    String? LeavingRemarks,
    String? FamilyGroupNo,
    String? AdmissionRemarks,
    String? Address,
    String? AddressPhoneNo,
    String? DateOfBirth,
    String? FatherProfession,
    String? MotherProfession,
    String? StudentMobileNo,
    String? GuardianName,
    String? GuardianMobileNo,
    String? GuardianNIC,
    String? GuardianRelatiion,
    String? GuardianProfession,
  }) async {
    var database = await DatabaseProvider().init();

    String maxId = '''
    select -(IfNull(Max(Abs(StudentID)),0)+1) as MaxId from Sch9StudentsInfo where ClientID=$clientID
    ''';

    List list = await database.rawQuery(maxId);

    var maxID = list[0]['MaxId'].round();

    String query = '''
            insert into Sch9StudentsInfo
            (StudentID,GRN,StudentName,FahterName,DateOfBirth,FatherProfession,StudentMobileNo,MotherProfession,GuardianName,GuardianNIC,GuardianMobileNo,GuardianRelatiion,GuardianProfession,FatherMobileNo,FatherNIC,MotherName,MotherMobileNo,MotherNIC,Address,AddressPhoneNo,OtherDetail,AdmissionDate,LeavingDate,AdmissionRemarks,LeavingRemarks,FamilyGroupNo,ClientID,ClientUserID,SysCode,NetCode,UpdatedDate) 
            values
            ($maxID,'$GRN','$StudentName','$FahterName','$DateOfBirth','$FatherProfession','$StudentMobileNo','$MotherProfession','$GuardianName','$GuardianNIC','$GuardianMobileNo','$GuardianRelatiion','$GuardianProfession','$FatherMobileNo','$FatherNIC',
            '$MotherName','$MotherMobileNo','$MotherNIC','$Address','$AddressPhoneNo','$OtherDetail','$AdmissionDate','$LeavingDate','$AdmissionRemarks','$LeavingRemarks','$FamilyGroupNo',$clientID,$clientUserID,'$sysCode','$netCode','') 
    ''';


    print('...........................................................................');

    try {
      await database.rawInsert(query);

      database.close();

      return true;
    } catch (e) {

      print('${e.toString()}');
      if (e is DatabaseException) {
        if (e.isUniqueConstraintError()) {
          // Handle the UNIQUE constraint violation here
          print('UNIQUE constraint violated');
          showDialog(context: context, builder: (context) => AlertDialog(content: Text('This GRN $GRN already exist'), actions: [TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Ok'))],),);
        } else {
          // Handle other database exceptions
          print('Database exception: $e');
        }
      } else {
        // Handle other exceptions
        print('Exception: $e');
      }


      return false;
    }
  }

  ///   update sch9 Admission  /////////////////////////////////
  Future<bool> updateSch9Admission({
    String? id,
    String? GRN,
    String? StudentName,
    String? FahterName,
    String? FatherMobileNo,
    String? FatherNIC,
    String? MotherName,
    String? MotherMobileNo,
    String? OtherDetail,
    String? AdmissionDate,
    String? LeavingDate,
    String? MotherNIC,
    String? LeavingRemarks,
    String? FamilyGroupNo,
    String? AdmissionRemarks,
    String? Address,
    String? AddressPhoneNo,
    String? DateOfBirth,
    String? FatherProfession,
    String? MotherProfession,
    String? StudentMobileNo,
    String? GuardianName,
    String? GuardianMobileNo,
    String? GuardianNIC,
    String? GuardianRelatiion,
    String? GuardianProfession,
  }) async {
    var database = await DatabaseProvider().init();
    try {
   await database.rawUpdate('''
          update Sch9StudentsInfo set GRN='$GRN',StudentName='$StudentName',FahterName='$FahterName',DateOfBirth='$DateOfBirth'
          ,FatherProfession='$FatherProfession',StudentMobileNo='$StudentMobileNo',
          MotherProfession='$MotherProfession',GuardianName='$GuardianName',GuardianNIC='$GuardianNIC'
          ,GuardianMobileNo='$GuardianMobileNo',GuardianRelatiion='$GuardianRelatiion'
          ,GuardianProfession='$GuardianProfession',FatherMobileNo='$FatherMobileNo',
          FatherNIC='$FatherNIC',MotherName='$MotherName',MotherMobileNo='$MotherMobileNo',MotherNIC='$MotherNIC'
          ,Address='$Address',AddressPhoneNo='$AddressPhoneNo',OtherDetail='$OtherDetail',AdmissionDate='$AdmissionDate',LeavingDate='$LeavingDate',AdmissionRemarks='$AdmissionRemarks'
          ,LeavingRemarks='$LeavingRemarks',FamilyGroupNo='$FamilyGroupNo',UpdatedDate=''
          ,ClientID='$clientID',ClientUserID='$clientUserID',NetCode='$netCode',SysCode='$sysCode' where ID=$id
          ''');



      database.close();

      return true;
    } catch (e) {



      return false;
    }
  }

  ///   update sch9 Admission  import from excel /////////////////////////////////
  Future<bool> updateSch9AdmissionByImportFromExcel({
    String? id,
    String? GRN,
    String? StudentName,
    String? FahterName,
    String? FatherMobileNo,
    String? FatherNIC,
    String? MotherName,
    String? MotherMobileNo,
    String? OtherDetail,
    String? AdmissionDate,
    String? LeavingDate,
    String? MotherNIC,
    String? LeavingRemarks,
    String? FamilyGroupNo,
    String? AdmissionRemarks,
    String? Address,
    String? AddressPhoneNo,
    String? DateOfBirth,
    String? FatherProfession,
    String? MotherProfession,
    String? StudentMobileNo,
    String? GuardianName,
    String? GuardianMobileNo,
    String? GuardianNIC,
    String? GuardianRelatiion,
    String? GuardianProfession,
  }) async {
    var database = await DatabaseProvider().init();
    try {
    await database.rawUpdate('''
          update Sch9StudentsInfo set GRN='$GRN',StudentName='$StudentName',FahterName='$FahterName',DateOfBirth='$DateOfBirth'
          ,FatherProfession='$FatherProfession',StudentMobileNo='$StudentMobileNo',
          MotherProfession='$MotherProfession',GuardianName='$GuardianName',GuardianNIC='$GuardianNIC'
          ,GuardianMobileNo='$GuardianMobileNo',GuardianRelatiion='$GuardianRelatiion'
          ,GuardianProfession='$GuardianProfession',FatherMobileNo='$FatherMobileNo',
          FatherNIC='$FatherNIC',MotherName='$MotherName',MotherMobileNo='$MotherMobileNo',MotherNIC='$MotherNIC'
          ,Address='$Address',AddressPhoneNo='$AddressPhoneNo',OtherDetail='$OtherDetail',AdmissionDate='$AdmissionDate',LeavingDate='$LeavingDate',AdmissionRemarks='$AdmissionRemarks'
          ,LeavingRemarks='$LeavingRemarks',FamilyGroupNo='$FamilyGroupNo',UpdatedDate=''
          ,ClientID='$clientID',ClientUserID='$clientUserID',NetCode='$netCode',SysCode='$sysCode' where GRN='$GRN' AND ClientID='$clientID'
          ''');



      database.close();

      return true;
    } catch (e) {


      return false;
    }
  }

  ///     select all student For   new record  //////////////////////////////////
  Future<List> dataForAllStudentForNEW(context) async {

    // Constants.onLoading(context, 'Loading......');
    String query = '';
    List list = [];
    query =
        "Select * From Sch9StudentsInfo Where Sch9StudentsInfo.UpdatedDate = '' AND Sch9StudentsInfo.StudentID < 0 AND Sch9StudentsInfo.ClientID = '$clientID'";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }

     // Constants.hideDialog(context);
      return list;
    } catch (e) {
      return [];
    }
  }

  ///     delete single student For   new record  //////////////////////////////////
  Future<int> StudentDeleteFromNEWRecord({required String GRN}) async {
    String query = '';
   int delete = 0;
    query =
    "Delete From Sch9StudentsInfo Where Sch9StudentsInfo.GRN = '$GRN' AND Sch9StudentsInfo.ClientID = '$clientID'";

    try {
      if (!kIsWeb) {
        Database db = await getDatabase();
        delete = await db.rawDelete(query);
      } else {
       // list = await apiFetchForWeb(query: query);
      }
      return delete;
    } catch (e) {
      return 0;
    }
  }
  ///     delete  all student For   new record  //////////////////////////////////
  Future<int> AllStudentDeleteFromNEWRecord() async {
    String query = '';
    int delete = 0;
    query =
    "Delete From Sch9StudentsInfo Where Sch9StudentsInfo.UpdatedDate = '' AND Sch9StudentsInfo.StudentID < 0 AND Sch9StudentsInfo.ClientID = '$clientID'";
    try {
      if (!kIsWeb) {
        Database db = await getDatabase();
        delete = await db.rawDelete(query);
      } else {
        // list = await apiFetchForWeb(query: query);
      }
      return delete;
    } catch (e) {
      return 0;
    }
  }
  ///     select all student For   new MOD  //////////////////////////////////
  Future<List> dataForAllStudentForMOD() async {
    String query = '';
    List list = [];
    query =
        "Select * From Sch9StudentsInfo Where Sch9StudentsInfo.UpdatedDate = '' AND Sch9StudentsInfo.StudentID > 0 AND Sch9StudentsInfo.ClientID = '$clientID' ";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  ///     select all present  student  //////////////////////////////////
  Future<List> dataForAllPresentStudent() async {
    String query = '';
    List list = [];
    query =
        "Select * From Sch9StudentsInfo Where Sch9StudentsInfo.LeavingDate = '' AND  Sch9StudentsInfo.StudentID > 0 AND  Sch9StudentsInfo.UpdatedDate != '' AND Sch9StudentsInfo.ClientID = '$clientID'";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  ///     select all   student  For export  //////////////////////////////////
  Future<List> dataForAllStudentForExport() async {
    String query = '';
    List list = [];
    query =
        "Select * From Sch9StudentsInfo Where Sch9StudentsInfo.ClientID = '$clientID'";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  ///     select all   student  For export  //////////////////////////////////
  Future<List> dataForAllStudentForImport(String excelGRN) async {
    String query = '';
    List list = [];
    query =
        "Select GRN From Sch9StudentsInfo Where Sch9StudentsInfo.ClientID = '$clientID' AND Sch9StudentsInfo.GRN = '$excelGRN'";
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  ///     select all student   for closed admission //////////////////////////////////
  Future<List> dataForAllStudentClosedAdmission() async {
    String query = '';
    List list = [];

    query =
        "Select * From Sch9StudentsInfo Where Sch9StudentsInfo.LeavingDate != '' AND Sch9StudentsInfo.ClientID = '$clientID'";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  ///     select all Student statement fee due//////////////////////////////////
  Future<List> dataForAllStudentLedgerFeeDue(String GRN) async {
    String query = '';
    List list = [];
    query =
    '''
 Select
    LedgerQuery.*,
    Sch9StudentsInfo.FamilyGroupNo,
    Sch9StudentsInfo.StudentName,
    Sch9StudentsInfo.StudentMobileNo,
    Sch9StudentsInfo.FahterName,
    Sch9StudentsInfo.FatherMobileNo,
    Sch9StudentsInfo.MotherMobileNo
From
    (Select
         Sch6StudentFeeDue.FeeDueID As ID,
         'Due' As EntryType,
         Sch6StudentFeeDue.DueDate As Date,
         Sch6StudentFeeDue.FeeNarration As Particulars,
         Sch6StudentFeeDue.FeeDueAmount As Debit,
         0 As Credit,
         Sch6StudentFeeDue.ClientID,
         Sch6StudentFeeDue.GRN
     From
         Sch6StudentFeeDue
     Where
         Sch6StudentFeeDue.ClientID = '$clientID' And
         Sch6StudentFeeDue.GRN = '$GRN'
     Union All
     Select
         Sch7FeeRec2.FeeRec1ID,
         'Rec' As EntryType,
         Sch7FeeRec1.FeeRecDate,
         Sch7FeeRec1.FeeRecRemarks,
         0 As Debit,
         Sch7FeeRec2.RecAmount As Credit,
         Sch7FeeRec2.ClientID,
         Sch6StudentFeeDue.GRN
     From
         Sch7FeeRec2 Left Join
         Sch7FeeRec1 On Sch7FeeRec1.FeeRec1ID = Sch7FeeRec2.FeeRec1ID
                 And Sch7FeeRec1.ClientID = Sch7FeeRec2.ClientID Left Join
         Sch6StudentFeeDue On Sch6StudentFeeDue.FeeDueID = Sch7FeeRec2.FeeDueID
                 And Sch6StudentFeeDue.ClientID = Sch7FeeRec2.ClientID
     Where
         Sch7FeeRec2.ClientID = '$clientID' And
         Sch6StudentFeeDue.GRN = '$GRN') LedgerQuery Left Join
    Sch9StudentsInfo On Sch9StudentsInfo.GRN = LedgerQuery.GRN
            And Sch9StudentsInfo.ClientID = LedgerQuery.ClientID
    ''';

      // "Select Sch6StudentFeeDue.FeeDueID As ID,
    // Due As 'E-Type',
    // Sch6StudentFeeDue.DueDate As Date,
    // Sch6StudentFeeDue.FeeNarration As Particulars,
    // Sch6StudentFeeDue.FeeDueAmount As Debit, 0 As Credit,
    // Sch6StudentFeeDue.ClientID,
    // Sch6StudentFeeDue.GRN
    // From Sch6StudentFeeDue Where Sch6StudentFeeDue.ClientID = '$clientID' And Sch6StudentFeeDue.GRN = '$GRN'
    // Union All Select Sch7FeeRec2.FeeRec1ID, Rec As EntryType,
    // Sch7FeeRec1.FeeRecDate, Sch7FeeRec1.FeeRecRemarks,
    // 0 As Debit, Sch7FeeRec2.RecAmount As Credit,
    // Sch7FeeRec2.ClientID, Sch6StudentFeeDue.GRN From
    // Sch7FeeRec2 Left Join Sch7FeeRec1 On Sch7FeeRec1.FeeRec1ID = Sch7FeeRec2.FeeRec1ID
    // And Sch7FeeRec1.ClientID = Sch7FeeRec2.ClientID Left Join Sch6StudentFeeDue
    // On Sch6StudentFeeDue.FeeDueID = Sch7FeeRec2.FeeDueID And Sch6StudentFeeDue.ClientID
    // = Sch7FeeRec2.ClientID Where Sch7FeeRec2.ClientID = '$clientID' And Sch6StudentFeeDue.GRN = '$GRN'";
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      print(list);
      return list;
    } catch (e) {
      return [];
    }
  }

  ///     select all Student   by ID //////////////////////////////////
  Future<List> dataForAllStudentByID(String id, String whereCon) async {
    String query = '';
    List list = [];
    query =
        "Select Sch9StudentsInfo.*, Sch9StudentsInfo.GRN As GRN, Sum(IfNull(Sch6StudentFeeDue.FeeDueAmount, 0)) As TotalDue, Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalReceived, Sum(IfNull(Sch6StudentFeeDue.FeeDueAmount, 0)) - Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalBallance, Sch4ClassesSection.SectionID, Sch4ClassesSection.SectionName, Sch3Classes.ClassID, Sch3Classes.ClassName, Sch2Year.EducationalYearID, Sch2Year.EducationalYear, Sch1Branches.BranchID, Sch1Branches.BranchName, Sch9StudentsInfo.ClientID From Sch9StudentsInfo Left Join Sch6StudentFeeDue On Sch6StudentFeeDue.GRN = Sch9StudentsInfo.GRN And Sch6StudentFeeDue.ClientID = Sch9StudentsInfo.ClientID Left Join Sch7FeeRec2 On Sch7FeeRec2.FeeDueID = Sch6StudentFeeDue.FeeDueID And Sch7FeeRec2.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionStudenID = Sch6StudentFeeDue.SectionStudentID And Sch5SectionStudent.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch4ClassesSection On Sch4ClassesSection.SectionID = Sch5SectionStudent.SectionID And Sch4ClassesSection.ClientID = Sch5SectionStudent.ClientID Left Join Sch3Classes On Sch3Classes.ClassID = Sch4ClassesSection.ClassID And Sch3Classes.ClientID = Sch4ClassesSection.ClientID Left Join Sch2Year On Sch2Year.EducationalYearID = Sch3Classes.EducationalYearID And Sch2Year.ClientID = Sch3Classes.ClientID Left Join Sch1Branches On Sch1Branches.BranchID = Sch2Year.BranchID And Sch1Branches.ClientID = Sch2Year.ClientID Where $whereCon = '$id' And Sch9StudentsInfo.ClientID = '$clientID' Group By Sch9StudentsInfo.GRN, Sch4ClassesSection.SectionID, Sch4ClassesSection.SectionName, Sch3Classes.ClassID, Sch3Classes.ClassName, Sch2Year.EducationalYearID, Sch2Year.EducationalYear, Sch1Branches.BranchID, Sch1Branches.BranchName, Sch9StudentsInfo.ClientID";
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }

      return list;
    } catch (e) {
      return [];
    }
  }

  ///    fee rec complete details with date//////////////////////////////////
  Future<List> dataForFeeRECCompleteDetailsByID(
      String id, String whereCon) async {
    String query = '';
    List list = [];

    query =
        "Select Sch7FeeRec1.*, Sch7FeeRec1.ID As ID1, Sch7FeeRec2.RecAmount, Sch7FeeRec2.FeeRec2ID, Sch6StudentFeeDue.FeeDueID, Sch6StudentFeeDue.FeeNarration, Sch5SectionStudent.SectionStudenID, Sch5SectionStudent.GRN, Sch4ClassesSection.SectionID, Sch4ClassesSection.SectionName, Sch3Classes.ClassID, Sch3Classes.ClassName, Sch2Year.EducationalYearID, Sch2Year.EducationalYear, Sch1Branches.BranchID, Sch1Branches.BranchName, Sch9StudentsInfo.StudentName, Sch9StudentsInfo.FamilyGroupNo, Sch9StudentsInfo.FahterName, Sch7FeeRec1.FeeRecDate From Sch7FeeRec1 Left Join Sch7FeeRec2 On Sch7FeeRec2.FeeRec1ID = Sch7FeeRec1.FeeRec1ID And Sch7FeeRec2.ClientID = Sch7FeeRec1.ClientID Left Join Sch6StudentFeeDue On Sch6StudentFeeDue.FeeDueID = Sch7FeeRec2.FeeDueID And Sch6StudentFeeDue.ClientID = Sch7FeeRec2.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionStudenID = Sch6StudentFeeDue.SectionStudentID And Sch5SectionStudent.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch4ClassesSection On Sch4ClassesSection.SectionID = Sch5SectionStudent.SectionID And Sch4ClassesSection.ClientID = Sch5SectionStudent.ClientID Left Join Sch3Classes On Sch3Classes.ClassID = Sch4ClassesSection.ClassID And Sch3Classes.ClientID = Sch4ClassesSection.ClientID Left Join Sch2Year On Sch2Year.EducationalYearID = Sch3Classes.EducationalYearID And Sch2Year.ClientID = Sch3Classes.ClientID Left Join Sch1Branches On Sch1Branches.BranchID = Sch2Year.BranchID And Sch1Branches.ClientID = Sch2Year.ClientID Left Join Sch9StudentsInfo On Sch9StudentsInfo.GRN = Sch5SectionStudent.GRN And Sch9StudentsInfo.ClientID = Sch5SectionStudent.ClientID Where Sch7FeeRec1.ClientID = '$clientID' And $whereCon = '$id' Group By Sch7FeeRec1.ID, Sch7FeeRec2.RecAmount, Sch6StudentFeeDue.FeeDueID, Sch7FeeRec2.FeeRec2ID, Sch6StudentFeeDue.FeeNarration, Sch5SectionStudent.SectionStudenID, Sch5SectionStudent.GRN, Sch4ClassesSection.SectionID, Sch4ClassesSection.SectionName, Sch3Classes.ClassID, Sch3Classes.ClassName, Sch2Year.EducationalYearID, Sch2Year.EducationalYear, Sch1Branches.BranchID, Sch1Branches.BranchName, Sch9StudentsInfo.StudentName, Sch9StudentsInfo.FahterName, Sch7FeeRec2.ClientID, Sch6StudentFeeDue.SectionStudentID, Sch4ClassesSection.ClassID, Sch3Classes.EducationalYearID, Sch2Year.BranchID, Sch7FeeRec1.ClientID, Sch7FeeRec1.FeeRecDate";
    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  ///    show all expense//////////////////////////////////
  Future<List> dataForAllExpense(String date) async {
    String query = '';
    List list = [];

    query =
       '''   
   Select
    CashBook.*,
    CashBook.ID As ID1,
    Account3Name.AcName As DebitAccountName,
    Account3Name1.AcName As CreditAccountName,
    CashBook.CBDate As CBDate1
From
    CashBook Left Join
    Account3Name On Account3Name.AcNameID = CashBook.DebitAccount
            And Account3Name.ClientID = CashBook.ClientID Left Join
    Account2Group On Account2Group.AcGroupID = Account3Name.AcGroupID
            And Account2Group.ClientID = Account3Name.ClientID Left Join
    Account1Type On Account1Type.AcTypeID = Account2Group.AcTypeID Left Join
    Account3Name Account3Name1 On Account3Name1.AcNameID = CashBook.CreditAccount
            And Account3Name1.ClientID = CashBook.ClientID
Where
    Account1Type.AcTypeID = 2 And
    CashBook.ClientID = '$clientID' And
    CashBook.CBDate='$date'
       ''';

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      print(list);

      return list;
    } catch (e) {
      return [];
    }
  }


  ///    show all expense//////////////////////////////////
  Future<List> dataForTotalDue(String date) async {
    String query = '';
    List list = [];

    query =
    '''   Select
    Sch6StudentFeeDue.*,
    Account3Name.AcName As UserName,
    Sch6StudentFeeDue.ID As ID,
    Sch9StudentsInfo.StudentName
 
From
    Sch6StudentFeeDue Left Join
    Account3Name On Account3Name.ClientID = Sch6StudentFeeDue.ClientID
            And Account3Name.AcNameID = Sch6StudentFeeDue.ClientUserID Left Join
    Sch9StudentsInfo On Sch9StudentsInfo.ClientID = Sch6StudentFeeDue.ClientID
            And Sch9StudentsInfo.GRN = Sch6StudentFeeDue.GRN
Where
    Sch6StudentFeeDue.ClientID = '$clientID' And
    Sch6StudentFeeDue.DueDate='$date'
  
       ''';

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      print(list);

      return list;
    } catch (e) {
      return [];
    }
  }

  ///     select all  Due Fee Details //////////////////////////////////
  Future<List> dataForDueFeeDetails(String id, String whereCon) async {
    String query = '';
    List list = [];

    query =
        "Select Sch6StudentFeeDue.DueDate, Sch6StudentFeeDue.FeeNarration, Sum(IfNull(Sch6StudentFeeDue.FeeDueAmount, 0)) As TotaFeeDue, Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalReceived, Sum(IfNull(Sch6StudentFeeDue.FeeDueAmount, 0)) - Sum(IfNull(Sch7FeeRec2.RecAmount, 0)) As TotalBalnce, Sch6StudentFeeDue.ClientID From Sch6StudentFeeDue Left Join Sch7FeeRec2 On Sch7FeeRec2.FeeDueID = Sch6StudentFeeDue.SectionStudentID And Sch7FeeRec2.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch5SectionStudent On Sch5SectionStudent.SectionStudenID = Sch6StudentFeeDue.SectionStudentID And Sch5SectionStudent.ClientID = Sch6StudentFeeDue.ClientID Left Join Sch4ClassesSection On Sch4ClassesSection.SectionID = Sch5SectionStudent.SectionID And Sch4ClassesSection.ClientID = Sch5SectionStudent.ClientID Left Join Sch3Classes On Sch3Classes.ClassID = Sch4ClassesSection.ClassID And Sch3Classes.ClientID = Sch4ClassesSection.ClientID Left Join Sch2Year On Sch2Year.EducationalYearID = Sch3Classes.EducationalYearID And Sch2Year.ClientID = Sch3Classes.ClientID Left Join Sch1Branches On Sch1Branches.BranchID = Sch2Year.BranchID And Sch1Branches.ClientID = Sch2Year.ClientID Where $whereCon = '$id' And Sch6StudentFeeDue.ClientID = '$clientID' Group By Sch6StudentFeeDue.DueDate, Sch6StudentFeeDue.FeeNarration, Sch1Branches.BranchID, Sch6StudentFeeDue.ClientID";

    try {
      if (!kIsWeb) {
        var db = await getDatabase();
        list = await db.rawQuery(query);
      } else {
        list = await apiFetchForWeb(query: query);
      }
      return list;
    } catch (e) {
      return [];
    }
  }
}
