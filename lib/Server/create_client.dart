import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import '../pages/material/Toast.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../pages/sqlite_data_views/sqlite_database_code_provider.dart';
import '../shared_preferences/shared_preference_keys.dart';
import 'mysql_provider.dart';

class CreateClientProvider extends ChangeNotifier {
  /// update client ..................................................................
  /// /////////////////////////////////////////////////////////////////////////////////
  updateClient({
    required String facebook,
    required String longLat,
    required String companyName,
    required String companyAddress,
    required String companyNumber,
    required String nameOfPerson,
    required String website,
    required String clientID,
    required String businessDescriptions,
    required String financialYear,
    required BuildContext context
  }) async {
    try {
      if (await Provider.of<MySqlProvider>(context, listen: false)
          .connectToServerDb()) {
        String query = '''
      UPDATE Client SET CompanyName = '$companyName' , BusinessDescriptions= '$businessDescriptions' , Lng= '$longLat',  CompanyAddress= '$companyAddress' ,  CompanyNumber= '$companyNumber',
      NameOfPerson= '$nameOfPerson' , WebSite= '$website' , Facebook  = '$facebook' WHERE ClientID = '$clientID'
      ''';
        Results results =
        await Provider
            .of<MySqlProvider>(context, listen: false)
            .conn!
            .query(query);
        if (results.affectedRows! > 0) {
          Toast.buildErrorSnackBar('Mobile number updated successfully');
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }


  /// client id from server ................................................................
  /// //////////////////////////////////////////////////////////////////////
  Future<int> clientID(BuildContext context) async{
    if (await Provider.of<MySqlProvider>(context, listen: false)
    .connectToServerDb()) {
   Results   results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query('''select (IfNull(Max(Abs(ClientID)),0)+1) as MaxId from Client
              ''');
      var maxID = results
          .toSet()
          .elementAt(0)
          .fields["MaxId"];
      return maxID;
    }
    return 0;
  }

  ///  client data ........................................................
  ///  ///////////////////////////////////////////////////////////////////

  Future<List> getClientTableById(String clientId) async {
    var db =  await DatabaseProvider().init();
    String query;
    if (SharedPreferencesKeys.prefs!
        .getString(SharedPreferencesKeys.subMenuQuery) ==
        null ||
        SharedPreferencesKeys.prefs!
            .getString(SharedPreferencesKeys.subMenuQuery) ==
            '0') {
      query = '''
      SELECT * FROM Client where ClientID = $clientId;
      ''';
    } else {
      query = SharedPreferencesKeys.prefs!
          .getString(SharedPreferencesKeys.subMenuQuery)!;
    }
    List list = await db.rawQuery(query);
    return list;
  }



  ///  client create ..................................................................
  ///  ///////////////////////////////////////////////////////////////////////////////////////////
  createClient(String facebook,
      String lng,
      String netCode,
      String sysCode,
      String companyName,
      String companyAddress,
      String companyNumber,
      String nameOfPerson,
      String loginMobileNo,
      String email,
      String country,
      String password,
      String city,
      String subCity,
      String website,
      String capacityOfPersons,
      String companyLogo,
      String displayImage,
      String lat,
      String projectID,
      String businessDescriptions,
      String financialYear,
      String countryUserID,
      String countryClientID,
      BuildContext context) async {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Results results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query('SELECT CAST(now(3) as VARCHAR(50)) as ServerDate')
          .catchError((e, stk) {
        print(e);
        print(stk);
      });
      String serverDateTime = results
          .toSet()
          .elementAt(0)
          .fields['ServerDate'];
      results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query('''select (IfNull(Max(Abs(ClientID)),0)+1) as MaxId from Client
              ''');
      var maxID = results
          .toSet()
          .elementAt(0)
          .fields["MaxId"];

      /// client creatinh ...............................................................
      /// ////////////////////////////////////////////////////////////////////////////
      ///
      String query = '''
    INSERT INTO `Client` (`ClientID`,`LoginMobileNo`,`Facebook`,`CountryUserID`,
     `CountryClientID`,`CompanyName`, `CompanyAddress`,
     `CompanyNumber`, `NameOfPerson`, `Email`,
      `WebSite`, `Password`, `Country`,
       `City`, `SubCity`, `SysCode`,
        `NetCode`, `UpdatedDate`, `Lat`,
         `Lng`, `ProjectID`, `BusinessDescriptions`,
          `FinancialYear`, `ActiveClient`) 
            VALUES ( '$maxID','$loginMobileNo','$facebook','$countryUserID', '$countryClientID','$companyName', '$companyAddress', '$companyNumber', '$nameOfPerson', '$email', '$website', '$password', '$country', '$city', '$subCity', '$sysCode', '$netCode', '$serverDateTime', '$lat', '$lng', '$projectID', '$businessDescriptions', '$financialYear', '1');
    ''';
      results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

        SharedPreferencesKeys.prefs!.setInt(SharedPreferencesKeys.clinetId, maxID);
      /// Admin user creating ..........................................................
      /// ///////////////////////////////////////////////////////////////////////////////
      query = '''
    INSERT INTO `Account3Name` (
    `AcNameID`, `ClientID`, `ClientUserID`,
     `NetCode`, `SysCode`, `UpdatedDate`,
      `AcName`, `AcAddress`, `AcMobileNo`, `AcContactNo`, `AcEmailAddress`, `AcPassward`,
       `UserRights`, `AcGroupID`, `SerialNo`,
       `NameOfPerson`,`Remarks`)
        VALUES (
        '1',
        '$maxID',
        '1',
        '$netCode',
        '$sysCode',
        '$serverDateTime',
        '$nameOfPerson',
        '$companyAddress',
        '$loginMobileNo',
        '$companyNumber',
        '$email',
        '$password',
        'Admin',
        '1',
        '1',
        '',
        ''
    )
    ''';
      results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
      //Default data inserting in account2group
      query = '''
    INSERT INTO `Account2Group` (`AcGroupID`, `AcTypeID`, `AcGruopName`, `ClientID`, `ClientUserID`,`NetCode`, `SysCode`, `UpdatedDate`) 
        SELECT AcGroupID, AcTypeID, AcGroupName, $maxID, 1, '0', '0', '$serverDateTime'
        FROM ProjectDefaultAccountGroup
        WHERE (ProjectID = $projectID)
    ''';
      results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);
      //Default data inserting in Account3Name
      query = '''
    INSERT INTO `Account3Name`
                         (`AcGroupID`, `AcName`, `AcNameID`,`AcEmailAddress`,`AcMobileNo`, `SerialNo`, `UserRights`, `ClientID`, `ClientUserID`, `UpdatedDate`,`NameOfPerson`,`Remarks`)
SELECT        AcGroupID, AcName, AcNameID,AcEmailAddress,AcMobileNo, SerialNo, UserRights, $maxID AS ClientID, 1 AS ClientUserID, '$serverDateTime' AS UpdatedDate,'','' 
FROM            ProjectDefaultAccount
WHERE        (ProjectID = $projectID)
    ''';

      ///********************
      ///default data insert in account2Group and default data insert into item3Name and default data insert into Itemlocation
      results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .close();
    } else {
      print('unable to connect to server');
    }
  }




  ///  initilize database .......................................................
  ///  .........////////////////////////////////////////////////////////



  /// client data from server ................................................................
  /// /////////////////////////////////////////////////////////////////

  getClientDataFromServerToSqlite(BuildContext context,
      {bool? isFromCreateClient}) async {
    String tableName = 'Client';
    var db =  await DatabaseProvider().init();
    try {
      //////////////////////////
      //max date pick from give table
      ///////////////////////////
      //getting the last updated date from table because we can get data from server greater than this date
      String query = '''
      Select max(UpdatedDate) as MaxDate  FROM $tableName
          ''';
      List maxDate = await db.rawQuery(query);
      query = '''
      Select
    Account3Name.AcNameID As ClientUserID,
    Account3Name.AcName As UserName,
    Account3Name.UserRights,
    Client.Email,
    Client.UpdatedDate,
    Client.ClientParentID,
    Client.EntryType,
    Client.LoginMobileNo,
    Client.CompanyName,
    Client.CompanyAddress,
    Client.CompanyNumber,
    Client.NameOfPerson,
    Client.WebSite,
    Client.Password,
    Client.ActiveClient,
    Client.Country,
    Client.City,
    Client.SubCity,
    Client.CapacityOfPersons,
    Client.ClientID,
    Client.SysCode,
    Client.NetCode,
    Client.Lat,
    Client.Lng,
    Client.BookingTermsAndCondition,
    Client.CountryUserID,
    Client.ProjectID,
    Client.BusinessDescriptions,
    Client.FinancialYear,
    Client.CountryClientID,
    `Theme`, `Background`
From
    Client Left Join
    Account3Name On Client.ClientID = Account3Name.ClientID
 Where
 (Account3Name.AcMobileNo ='${SharedPreferencesKeys.prefs!.getString(
          SharedPreferencesKeys.mobileNumber)}' 
 or Account3Name.AcEmailAddress='${SharedPreferencesKeys.prefs!.getString(
          SharedPreferencesKeys.email)}')
 and(Account3Name.UserRights = 'Admin' or Account3Name.UserRights = 'Custom Right'
 or Account3Name.UserRights = 'Statement View Only')
 AND
      Client.UpdatedDate > '${maxDate[0]['MaxDate'] == null
          ? 0
          : maxDate[0]['MaxDate']}'  
        ''';

      Results results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      ///****************
      ///user rights not allowed login ayein tauh server se client ko delete karna hain
      Set<ResultRow> resultRow = results.toSet();
      for (int i = 0; i < resultRow.length; i++) {
        if (isFromCreateClient != null && isFromCreateClient == true) {
          /// Temprory block by Usama //////
           resultRow
              .elementAt(i)
              .fields;
        }

        await db
            .insert(
          tableName,
          resultRow
              .elementAt(i)
              .fields,
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
            .catchError((e, stk) {
          print(e);
          print(stk);
        });
      }
      await db.close();

      // Map map = jsonDecode(response.body);
      // List list = map["Account2Group"];
      // for (Map<String, dynamic> item in list) {
      //   query = '''
      //   Select AcGroupID from Account2Group where AcGroupID='${item['AcGroupID']}' AND ClientID='${clientID.toString()}'
      //   ''';
      //   List list = await db.rawQuery(query);
      //   if (list.length > 0) {
      //     print(await db.update('Account2Group', item,
      //         where:
      //         "AcGroupID='${item['AcGroupID']}' AND ClientID='${clientID.toString()}'"));
      //   } else {
      //     db.insert('Account2Group', item);
      //   }
      // }
    } catch (e, stktrace) {
      print(e.toString());
      print(stktrace);
    }
  }

  Future<int> maxID(BuildContext context) async {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      Results results = await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .query('''select (IfNull(Max(Abs(ClientID)),0)+1) as MaxId from Client
              ''');
      var maxID = results
          .toSet()
          .elementAt(0)
          .fields["MaxId"];


      await Provider
          .of<MySqlProvider>(context, listen: false)
          .conn!
          .close();

      return maxID;
    }

    return 0;
  }


  ///   client  image uploading
  ///   ///////////////////////////////////////////////////////////////////////////////////////////////
 Future<void>  onPressedUploadToServer(String image, BuildContext context,) async {
    int idFOrClient = await maxID(context);
    Uri url = Uri.parse(
        'https://www.api.easysoftapp.com/PhpApi1/ImageUploadWithPath.php');
    try {
      var response = await http.post(url, body: {
        'DisplayImage': image,
        'ImagePath':
        'ClientImages/${SharedPreferencesKeys.prefs!.getString(
            'CountryName')}/ClientLogo',
        'ImageName': '$idFOrClient',
        // 'ClientID': countryClientId.toString(),
      });
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        // showDialog(context: context, builder: (context) {
        //   return Center(
        //     child: SizedBox(
        //       height: 150,
        //       width: 300,
        //       child: Material(
        //         child: Column(
        //           children: [
        //             Text('Successful Created'),
        //             ElevatedButton(onPressed: () {
        //               Navigator.pop(context);
        //             }, child: Text('ok'))
        //           ],
        //         ),
        //       ),
        //     ),
        //   );
        // });
        print(map);
      } else {
        print(
            '...........${response
                .statusCode}.........not reponding ........................');
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }


  /// image uploading to server ..................................................
  /// /////////////////////////////////////////////////////////

  Future<void> updateOnPressedUploadToServer(String image, BuildContext context,
      int clientId) async {
    Uri url = Uri.parse(
        'https://www.api.easysoftapp.com/PhpApi1/ImageUploadWithPath.php');
    try {
      var response = await http.post(url, body: {
        'DisplayImage': image,
        'ImagePath':
        'ClientImages/${SharedPreferencesKeys.prefs!.getString(
            'CountryName')}/ClientLogo',
        'ImageName': '$clientId',
        // 'ClientID': countryClientId.toString(),
      });
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        showDialog(context: context, builder: (context) {
          return Center(
            child: SizedBox(
              height: 100,
              width: 300,
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Successful Update'),
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text('ok'))
                  ],
                ),
              ),
            ),
          );
        });
        print(map);
      } else {
        print(
            '...........${response
                .statusCode}.........not reponding ........................');
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }


}
