import 'dart:convert';

import 'package:com/Server/RefreshDataProvider.dart';
import 'package:com/Server/mysql_provider.dart';
import 'package:com/api/api_constants.dart';
import 'package:com/main/tab_bar_pages/home/Dashboard.dart';
import 'package:com/pages/material/Toast.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:com/utils/api_query_for_web.dart';
import 'package:com/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../sqlite_data_views/sqlite_database_code_provider.dart';
import 'create_account_design.dart';

class AuthenticationProvider extends ChangeNotifier {
  Future<int> checkPhoneNumber(
      String number, int clientID, BuildContext context) async {
    try {
      String query = '';

      if (await Provider.of<MySqlProvider>(context, listen: false)
          .connectToServerDb()) {
        query = '''
            SELECT AcMobileNo FROM Account3Name Where ClientID = '$clientID' And AcMobileNo = '$number'
        ''';
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);

        print(results.toString());
        if (results.length > 0) {
          return 1;
        }
        return 0;
      }
    } on Exception catch (e) {
      print(
        e.toString(),
      );
    }
    return 0;
  }

  Future<int?> maxIDForAccount3Name(
      int countryClientId, BuildContext context) async {
    try {
      if (await Provider.of<MySqlProvider>(context, listen: false)
          .connectToServerDb()) {
        String query = '';
        query = '''
      Select (IfNull(Max(Abs(AcNameID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerDate from Account3Name where ClientID = '$countryClientId'
      ''';
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);
        Set<ResultRow> set = results.toSet();
        int maxAcNameId = set.elementAt(0).fields['MaxId'];
        return maxAcNameId;
      }
    } catch (e) {}
    return null;
  }

  Future<void> uploadImage(
      String base64Image, int countryClientId, BuildContext context) async {
    int? maxID = await maxIDForAccount3Name(countryClientId, context);
    Uri url = Uri.parse(
        'https://www.api.easysoftapp.com/PhpApi1/ImageUploadWithPath.php');

    try {
      var response = await http.post(url, body: {
        'DisplayImage': base64Image,
        'ImagePath':
            'ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/UserLogo',
        'ImageName': '$maxID',
        // 'ClientID': countryClientId.toString(),
      });
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        print(map);
      } else {
        print(
            '...........${response.statusCode}......... ........................');
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  createAccountWithServer(BuildContext context, String name, String password,
      String? email, String base64Image, int countryClientId) async {
    try {
      if (await Provider.of<MySqlProvider>(context, listen: false)
          .connectToServerDb()) {
        String query = '';
        query = '''
      Select (IfNull(Max(Abs(AcNameID)),0)+1) as MaxId, CAST(now(3) as VARCHAR(50)) as ServerDate from Account3Name where ClientID = '$countryClientId'
      ''';
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);
        Set<ResultRow> set = results.toSet();
        int maxAcNameId = set.elementAt(0).fields['MaxId'];
        String updatedDate = set.elementAt(0).fields['ServerDate'];
        query = '''
          INSERT INTO Account3Name (AcNameID,AcName,NameOfPerson, AcGroupID,
           AcAddress, AcContactNo, AcEmailAddress,
            Salary, AcMobileNo, AcPassward, 
             ClientID, UpdatedDate, 
            SerialNo,AcDebitBal,AcCreditBal,ClientUserID,
            SysCode,NetCode,UserRights)
             VALUES ('$maxAcNameId','$maxAcNameId','$name', 
             '5', 'Hardcoded', '',
              '$email', '0', ${null}, 
              '$password', '$countryClientId', 
              '$updatedDate','0','0',
              '0','1','0',
              '0','ACTIVE');
          ''';
        results = await Provider.of<MySqlProvider>(context, listen: false)
            .conn!
            .query(query);
        if (results.affectedRows! > 0) {
          // SharedPreferencesKeys.prefs!.setString(
          //     SharedPreferencesKeys.countryClientId,
          //     countryClientId.toString());
          // final bool? verifyPhoneNUmber = await showDialog<bool>(
          //   context: (context),
          //   builder: (context) =>
          //       Center(
          //           child: SizedBox(
          //               height: 250,
          //               child: VerifyPhoneDialog())),
          //);

          SharedPreferencesKeys.prefs!.setString(
              SharedPreferencesKeys.countryClientId,
              countryClientId.toString());
          SharedPreferencesKeys.prefs!.setString(
              SharedPreferencesKeys.countryUserId, maxAcNameId.toString());

          await Provider.of<RefreshDataProvider>(context, listen: false)
              .getClientDataFromServerToSqlite(context);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ListWidget()),
            (route) => false,
          );

          // final String? phoneNumber = await showDialog<String>(
          //   context: (context),
          //   builder: (context) => Padding(
          //     padding: EdgeInsets.only(
          //         bottom: MediaQuery.of(context).viewInsets.bottom),
          //     child: Center(
          //         child: SizedBox(
          //             height: 250,
          //             width: 300,
          //             child: PhoneNumberAuthForm(
          //               countryUserID: maxAcNameId.toString(),
          //             ))),
          //   ),
          // );
          // updateMobileNumberWithServer(phoneNumber!, countryClientId.toString(),
          //     maxAcNameId.toString(), context, 'loginPage');
        }

        await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
      } else {
        print('unable to connect to server');
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

////////////////////////////////////
//Update Mobile number after creating account
///////////////////////////////////
  //Successfully working with apis
//   updateMobileNumber(String mobileNumber,String ClientID,String AcNameID,BuildContext context)async{
//     Uri url=Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updateMobileNumber}');
//     try {
//       var response=await http.post(url,body: {
//         'CountryClientID':ClientID,
//         'PhoneNumber':mobileNumber,
//         'AcNameID':AcNameID,
//       });
//       if(response.statusCode==200){
//         Map map=json.decode(response.body);
//         if(map['success']==1){
//           Toast.buildErrorSnackBar(map['message']);
//           Navigator.pushNamed(context, '/login_selection_page');
//         }
//         Toast.buildErrorSnackBar(map.toString());
//       }
//     } on Exception catch (e) {
//       print(e.toString());
//     }
//   }
  updateMobileNumberWithServer(String mobileNumber, String countryClientID,
      String countryUserID, BuildContext context, String check) async {
    SharedPreferencesKeys.prefs!
        .setString(SharedPreferencesKeys.countryClientId, countryClientID);
    SharedPreferencesKeys.prefs!
        .setString(SharedPreferencesKeys.countryUserId, countryUserID);
    SharedPreferencesKeys.prefs!
        .setString(SharedPreferencesKeys.mobileNumber, mobileNumber);
    try {
      if (await Provider.of<MySqlProvider>(context, listen: false)
          .connectToServerDb()) {
        /////////////////////////////////////////////// Name checking
        String query = '''
      UPDATE Account3Name SET AcMobileNo='$mobileNumber'  WHERE AcNameID='$countryUserID' && ClientID = '$countryClientID'
      ''';
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);
        if (results.affectedRows! > 0) {
          // Toast.buildErrorSnackBar('Mobile number updated successfully');

          if (check == 'loginPage') {
            // Navigator.pushNamed(context, '/login_selection_page');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListWidget()));
          }
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  //////////////////////////////////////
  //Getting country client id from spinner
  /////////////////////////////////////
  Future<int?> getClientIdFromCountryCodeTable(String? countryCode) async {
    var db = await DatabaseProvider().init();
    String query = '''
    Select ClientID from CountryCode WHERE CountryCode='$countryCode';
    ''';
    List list = await db.rawQuery(query);
    //print(list);
    db.close();
    //debugPrint(list.toString());
    //print(list[0]['ClientID']);
    if (list.length > 0) {
      return list[0]['ClientID'];
    }
    return null;
  }

  Future<List<dynamic>> getAllDataFromCountryCodeTable() async {
    print(
        '..................inter into the fetch country method---------------------');
    // Directory? documentsDirectory = await getExternalStorageDirectory();
    // String path = join(documentsDirectory!.path, 'ESD.db');
    //
    // var db = await openDatabase(path, password: '1122334455');

    var db = await DatabaseProvider().init();
    String query = '''
    Select * from CountryCode; 
    ''';
    List list = await db.rawQuery(query);

    print('..................list of country ---------------------');
    print(list);
    return list;
  }

  /////////////////////////////////////
  //email authentication checking
  ////////////////////////////////////
  Future<int> checkEmailWithServer(
      String email, int countryClientId, BuildContext context) async {
    Uri.parse('${ApiConstants.baseUrl}${ApiConstants.checkEmail}');
    try {
      if (await Provider.of<MySqlProvider>(context, listen: false)
          .connectToServerDb()) {
        /////////////////////////////////////////////// Email es checking
        String query = '''
      SELECT * FROM Account3Name WHERE AcEmailAddress = '$email' AND ClientID = '$countryClientId'
      ''';
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);
        if (results.length > 0) {
          Toast.buildErrorSnackBar('Email Already exist');
          return 1;
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return 0;
  }

  Future<int> updatePasswordFromServer(
      String email, int countryClientId, BuildContext context) async {
    Uri.parse('${ApiConstants.baseUrl}${ApiConstants.checkEmail}');
    try {
      if (await Provider.of<MySqlProvider>(context, listen: false)
          .connectToServerDb()) {
        /////////////////////////////////////////////// Email es checking
        String query = '''
      SELECT * FROM Account3Name WHERE AcEmailAddress = '$email' AND ClientID = '$countryClientId'
      ''';
        Results results =
            await Provider.of<MySqlProvider>(context, listen: false)
                .conn!
                .query(query);
        if (results.length > 0) {
          Toast.buildErrorSnackBar('Email Already exist');
          return 1;
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return 0;
  }

  loginWithMobileNoOrEmailPasswordWithServer(
      String emailOrMobileNo,
      String password,
      int? countryClientId,
      String columnName,
      BuildContext context) async {
    try {
      if (kIsWeb
          ? true
          : await Provider.of<MySqlProvider>(context, listen: false)
              .connectToServerDb()) {
        String query =
            'select * from Account3Name WHERE ClientID = ${countryClientId} && $columnName = $emailOrMobileNo && AcPassward = $password'; //
        if (kIsWeb) {
          List list = await apiFetchForWeb(query: query);

          if (list.length > 0) {
            Constants.onLoading(context, 'Login Please wait........');
            if (list[0]['UserRights'] == 'ACTIVE' ||
                list[0]['UserRights'] == 'Admin') {
              saveDataInPrefs(
                  list[0]['AcNameID'].toString(),
                  list[0]['AcMobileNo'].toString(),
                  list[0]['ClientID'].toString(),
                  list[0]['NameOfPerson'],
                  list[0]['AcEmailAddress']);
              Constants.hideDialog(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListWidget(),
                ),
              );
            } else {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Message"),
                    content: Text('Your account is not active'),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            }
          } else {
            print('Somethings went wrong');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Message"),
                  content: Text('Please Field Correct Information'),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
            );
          }
        } else {
          Results results =
              await Provider.of<MySqlProvider>(context, listen: false)
                  .conn!
                  .query(query);

          if (results.length > 0) {
            Constants.onLoading(context, 'Login Please wait........');
            Set<ResultRow> resultRow = results.toSet();
            for (int i = 0; i < resultRow.length; i++) {
              Map<String, dynamic> map = resultRow.elementAt(i).fields;
              if (map['UserRights'] == 'ACTIVE' ||
                  map['UserRights'] == 'Admin') {
                saveDataInPrefs(
                    map['AcNameID'].toString(),
                    map['AcMobileNo'].toString(),
                    map['ClientID'].toString(),
                    map['NameOfPerson'],
                    map['AcEmailAddress']);

                await Provider.of<RefreshDataProvider>(context, listen: false)
                    .getClientDataFromServerToSqlite(context);

                Constants.hideDialog(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListWidget(),
                  ),
                );
              } else {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Message"),
                      content: Text('Your account is not active'),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              }
            }
          } else {
            print('Somethings went wrong');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Message"),
                  content: Text('Please Field Correct Information'),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
            );
          }
        }

        if (!kIsWeb) {
          await Provider.of<MySqlProvider>(context, listen: false)
              .conn!
              .close();
        }
      } else {
        print("unable to connect to server");
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  ///////////////////////////////////
  //Login with mobile number or email
  //////////////////////////////////
  loginWithMobileNoOrEmailWithServer(String mobileNoOrEmail,
      int? countryClinetId, String columnName, BuildContext context,
      {required UserCredential userCredential}) async {
    if (await Provider.of<MySqlProvider>(context, listen: false)
        .connectToServerDb()) {
      String query = '''
      SELECT * FROM Account3Name WHERE ClientID = $countryClinetId AND $columnName = '$mobileNoOrEmail'
      ''';
      Results results = await Provider.of<MySqlProvider>(context, listen: false)
          .conn!
          .query(query);

      if (results.length > 0) {
        Constants.onLoading(context, 'Login Please wait........');
        Set<ResultRow> resultRow = results.toSet();
        for (int i = 0; i < resultRow.length; i++) {
          Map<String, dynamic> map = resultRow.elementAt(i).fields;
          //user activation checking
          if (map['UserRights'] == 'ACTIVE' || map['UserRights'] == 'Admin') {
            saveDataInPrefs(
                map['AcNameID'].toString(),
                map['AcMobileNo'].toString(),
                map['ClientID'].toString(),
                map['NameOfPerson'],
                map['AcEmailAddress']);
            await Provider.of<RefreshDataProvider>(context, listen: false)
                .getClientDataFromServerToSqlite(context);
            //Navigator.pushNamed(context, '/dashboard_page');
            Constants.hideDialog(context);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ListWidget(),
              ),
              (route) => false,
            );
          } else {
            return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Message"),
                  content: Text('Your account is not active'),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
            );
          }
        }
      } else {
        ////   if you are not register then this will heppen ...............................
        ////////////////////////////////////////////////////////////////////////////
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Center(
                  child: SizedBox(
                    height: 150,
                    width: 300,
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Your Email is not register'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 130,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                        GoogleSignIn().signOut();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel')),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return WillPopScope(
                                                onWillPop: () async {
                                                  return false;
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: Center(
                                                    child: SizedBox(
                                                      height: 450,
                                                      child: CreateAccount(
                                                        userCredential:
                                                            userCredential,
                                                        countryUserId:
                                                            countryClinetId!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Text('Create Account')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      }
      await Provider.of<MySqlProvider>(context, listen: false).conn!.close();
    } else {
      print("unable to connect to server");
    }
  }

  Future<void> deleteTable(String tableName) async {
    var db = await DatabaseProvider().init();
    await db.delete(tableName);
  }

  //////////////////////////////////////
  //Preference creating on login
  /////////////////////////////////////
  saveDataInPrefs(String acNameId, String AcMobileNo, String ClientID,
      String NameOfPerson, String AcEmailAddres) {
    // print("Name" + NameOfPerson);
    SharedPreferencesKeys.prefs!
      ..setString(SharedPreferencesKeys.countryUserId, acNameId)
      ..setString(SharedPreferencesKeys.mobileNumber, AcMobileNo)
      ..setString(SharedPreferencesKeys.countryClientId, ClientID)
      ..setString(SharedPreferencesKeys.nameOfPerson, NameOfPerson)
      ..setString(SharedPreferencesKeys.email, AcEmailAddres);
    SharedPreferencesKeys.prefs!
        .setString(SharedPreferencesKeys.subMenuQuery, '0');
    SharedPreferencesKeys.prefs!
        .setString(SharedPreferencesKeys.fromDate, '2010-01-01');
    SharedPreferencesKeys.prefs!.setString(SharedPreferencesKeys.toDate,
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
  }

  /////////////////////////////////////////////
  //Import all data in client table after login
  ////////////////////////////////////////////
  Future<int> importLoginClinetData(
      String emailOrMobileNo, String columnName) async {
    Uri url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.importLoginClientData}');
    try {
      var response = await http.post(url, body: {
        'MobileNoOrEmail': emailOrMobileNo,
        'ColumnName': columnName,
      });
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        deleteTable('Client');
        if (map['success'] == 1) {
          print(map);
          List list = map['Clients'];
          list.forEach((element) {
            Map<String, dynamic> map = Map.from(element);
            map.remove('CompanyLogo');
            map.remove('Theme');
            map.remove('Background');
            insertTable('Client', map);
          });
        }
        return map['success'];
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return 0;
  }

  ////////////////////////////////////
  //Import default data in any table
  ///////////////////////////////////
  Future<void> insertTable(
      String tableName, Map<String, dynamic> values) async {
    var db = await DatabaseProvider().init();
    // String query = '''
    //   DELETE from $tableName;
    //   ''';
    await db.insert(tableName, values);
  }
}
