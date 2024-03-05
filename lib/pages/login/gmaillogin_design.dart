import 'dart:io';

import 'package:com/pages/login/create_account_and_login_code_provider.dart';
import 'package:com/pages/login/firebase_auth_provider.dart';
import 'package:com/pages/material/countrypicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';

import '../../shared_preferences/shared_preference_keys.dart';

class GmailLogin extends StatefulWidget {
  const GmailLogin({Key? key}) : super(key: key);

  @override
  _GmailLoginState createState() => _GmailLoginState();
}

class _GmailLoginState extends State<GmailLogin> {
  Map dropDownMap = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
  };

  String countryCode = '+92';
  int? countryClinetId;
  bool check = true;

  @override
  void initState() {
    Provider.of<AuthenticationProvider>(context, listen: false)
        .getClientIdFromCountryCodeTable(countryCode)
        .then((value) {
      countryClinetId = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Platform.isWindows)
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  height: 200,
                  width: 320,
                  color: Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Login With Email",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        FutureBuilder(
                          future: Provider.of<AuthenticationProvider>(context,
                                  listen: false)
                              .getAllDataFromCountryCodeTable(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 8, right: 8),
                                  child: InkWell(
                                      onTap: () async {
                                        dropDownMap = await showDialog(
                                          context: context,
                                          builder: (_) => DropDownStyle1Image(
                                            acc1TypeList: snapshot.data,
                                            // dropdown_title: dropDownMap['Title'],
                                            //dropdown_title: dropDownMap['Title'],
                                            map: dropDownMap,
                                          ),
                                        );
                                        setState(() {
                                          countryCode =
                                              dropDownMap['CountryCode']
                                                  .toString();
                                          String obj = dropDownMap['ClientID']
                                              .toString();
                                          // ignore: unnecessary_null_comparison
                                          if (obj != null) {
                                            countryClinetId =
                                                int.parse(obj.toString());
                                          }
                                          print(countryCode);
                                          print(countryClinetId);
                                        });
                                      },
                                      child: DropDownStyle1State.DropDownButton(
                                          title: dropDownMap['CountryName']
                                              .toString(),
                                          id: dropDownMap['CountryCode']
                                              .toString(),
                                          image:
                                              dropDownMap['Image'].toString())),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                        SizedBox(height: 10),
                        Card(
                          elevation: 16,
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            width: 300,
                            height: 50,
                            child: SignInButton(
                              Buttons.Google,
                              elevation: 8,
                              text: "Sign up with Google",
                              onPressed: () async {
                                Provider.of<FirebaseAuthProvider>(context,
                                        listen: false)
                                    .signinWithEmail()
                                    .then(
                                  (UserCredential? userCredential) {
                                    if (userCredential!.user!.email != null) {
                                      Provider.of<AuthenticationProvider>(
                                              context,
                                              listen: false)
                                          .loginWithMobileNoOrEmailWithServer(
                                              userCredential.user!.email!,
                                              userCredential: userCredential,
                                              countryClinetId,
                                              "AcEmailAddress",
                                              context);
                                    }
                                  },
                                );

                                SharedPreferencesKeys.prefs!
                                    .setInt(SharedPreferencesKeys.projectId, 0);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: ScreenUtilInit(
                  builder: (context, child) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Card(
                          child: Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 15.h, left: 10.w, right: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.w,
                                  ),
                                  Text(
                                    "Login With Email",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: Provider.of<AuthenticationProvider>(
                                            context,
                                            listen: false)
                                        .getAllDataFromCountryCodeTable(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.hasData) {
                                        Future.delayed(
                                          Duration.zero,
                                          () {
                                            if (check) {
                                              for (int i = 0;
                                                  i < snapshot.data!.length;
                                                  i++) {
                                                if (DateTime.now()
                                                        .timeZoneName ==
                                                    snapshot.data![i]
                                                        ['SName']) {
                                                  print(
                                                      '.............................................................time...........................f');
                                                  dropDownMap['ID'] = snapshot
                                                      .data[i]['ID']
                                                      .toString();
                                                  dropDownMap['CountryName'] =
                                                      snapshot.data[i]
                                                              ['CountryName']
                                                          .toString();
                                                  dropDownMap['Image'] =
                                                      'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                                  dropDownMap['CountryCode'] =
                                                      snapshot.data[i]
                                                              ['CountryCode']
                                                          .toString();
                                                  dropDownMap['DateFormat'] =
                                                      snapshot.data[i]
                                                              ['DateFormat']
                                                          .toString();
                                                  dropDownMap['CurrencySign'] =
                                                      snapshot.data[i]
                                                              ['CurrencySigne']
                                                          .toString();
                                                  countryClinetId = int.parse(
                                                      snapshot.data[i]
                                                              ['ClientID']
                                                          .toString());
                                                  // phoneNumberController.text =
                                                  //     snapshot.data[i]['CountryCode'].toString();
                                                  SharedPreferencesKeys.prefs!
                                                      .setString(
                                                          SharedPreferencesKeys
                                                              .dateFormat,
                                                          dropDownMap[
                                                                  'DateFormat']
                                                              .toString());
                                                  SharedPreferencesKeys.prefs!
                                                      .setString(
                                                          SharedPreferencesKeys
                                                              .currencySign,
                                                          dropDownMap[
                                                                  'CurrencySign']
                                                              .toString());
                                                  SharedPreferencesKeys.prefs!
                                                      .setString(
                                                          'CountryName',
                                                          dropDownMap[
                                                                  'CountryName']
                                                              .toString());

                                                  setState(() {});
                                                }
                                              }
                                              check = false;
                                            }
                                          },
                                        );
                                        return Center(
                                          child: InkWell(
                                            onTap: () async {
                                              dropDownMap = await showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    DropDownStyle1Image(
                                                  acc1TypeList: snapshot.data,
                                                  // dropdown_title: dropDownMap['Title'],
                                                  //dropdown_title: dropDownMap['Title'],
                                                  map: dropDownMap,
                                                ),
                                              );
                                              print(dropDownMap);
                                              setState(
                                                () {
                                                  countryCode =
                                                      dropDownMap['CountryCode']
                                                          .toString();
                                                  String obj =
                                                      dropDownMap['ClientID']
                                                          .toString();
                                                  // ignore: unnecessary_null_comparison
                                                  if (obj != null) {
                                                    countryClinetId = int.parse(
                                                        obj.toString());
                                                  }
                                                  print(countryCode);
                                                  print(countryClinetId);
                                                },
                                              );
                                            },
                                            child: DropDownStyle1State
                                                .DropDownButton(
                                              title: dropDownMap['CountryName']
                                                  .toString(),
                                              id: dropDownMap['CountryCode']
                                                  .toString(),
                                              image: dropDownMap['Image']
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                  SizedBox(height: 10.w),
                                  Card(
                                    elevation: 16,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1.h),
                                      ),
                                      width: 290.h,
                                      height: 40.w,
                                      child: SignInButton(
                                        Buttons.Google,
                                        elevation: 8,
                                        text: "Sign up with Google",
                                        onPressed: () async {
                                          SharedPreferencesKeys.prefs!.setInt(
                                              SharedPreferencesKeys.projectId,
                                              0);

                                          Provider.of<FirebaseAuthProvider>(
                                                  context,
                                                  listen: false)
                                              .signinWithEmail()
                                              .then(
                                            (UserCredential? userCredential) {
                                              if (userCredential!.user!.email !=
                                                  null) {
                                                print(
                                                    '......................login................................');

                                                Provider.of<AuthenticationProvider>(
                                                        context,
                                                        listen: false)
                                                    .loginWithMobileNoOrEmailWithServer(
                                                        userCredential
                                                            .user!.email!,
                                                        countryClinetId,
                                                        userCredential:
                                                            userCredential,
                                                        "AcEmailAddress",
                                                        context);
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 30.w,
                                  // ),
                                  // Center(
                                  //   child: ElevatedButton(
                                  //       style: ElevatedButton.styleFrom(
                                  //           backgroundColor: Colors.black,
                                  //           minimumSize: Size(150, 50),
                                  //           maximumSize: Size(200, 60),
                                  //
                                  //           foregroundColor: Colors.white,
                                  //           shape: RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10.r),
                                  //           )
                                  //           ),
                                  //       onPressed: () async {
                                  //         //   var pos =  await   _determinePosition();
                                  //         //
                                  //         //   print('..............${pos.longitude}...................${pos.latitude}');
                                  //         //
                                  //         // var country   = await     _getAddress(pos.latitude,pos.longitude);
                                  //         //
                                  //         //
                                  //         // print(country);
                                  //         //
                                  //         //  // Future<Address> reverseGeocoding()
                                  //
                                  //         // List<Placemark> placemarks = await placemarkFromCoordinates( pos.latitude,pos.longitude,localeIdentifier: 'en');
                                  //         // Placemark placeMark = placemarks.first;
                                  //         // String? country = placeMark.country;
                                  //         // print(country);
                                  //
                                  //         // final coordinates = new Coordinates(position.latitude, position.longitude);
                                  //       },
                                  //       child: Text(
                                  //         "Log In",
                                  //         style: TextStyle(
                                  //           fontSize: 18.0.sp,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       )),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

// Future<String> _getAddress(double? lat, double? lang) async {
//   if (lat == null || lang == null) return "";
//   GeoCode geoCode = GeoCode();
//   Address address =
//   await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
//   return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
// }
}
