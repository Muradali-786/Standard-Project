import 'dart:io';

import 'package:com/pages/login/create_account_and_login_code_provider.dart';
import 'package:com/pages/login/firebase_auth_provider.dart';
import 'package:com/pages/material/countrypicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../shared_preferences/shared_preference_keys.dart';

class NumberLogin extends StatefulWidget {
  const NumberLogin({Key? key}) : super(key: key);

  @override
  _NumberLoginState createState() => _NumberLoginState();
}

class _NumberLoginState extends State<NumberLogin> {
  Map dropDownMap = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    'Image': '',
  };
  String countryCode = '+92';
  int? countryClinetId;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();

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
  Widget build(BuildContext mainContext) {
    return (Platform.isWindows)
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  height: 330,
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
                          "Login With Phone Number",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        FutureBuilder(
                          future: Provider.of<AuthenticationProvider>(
                                  mainContext,
                                  listen: false)
                              .getAllDataFromCountryCodeTable(),
                          //getting the dropdown data from query
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              //print(snapshot.data);
                              for (int i = 0; i < snapshot.data!.length; i++) {
                                if (DateTime.now().timeZoneName ==
                                    snapshot.data![i]['SName']) {
                                  dropDownMap['ID'] =
                                      snapshot.data[i]['ID'].toString();
                                  dropDownMap['CountryName'] = snapshot.data[i]
                                          ['CountryName']
                                      .toString();
                                  dropDownMap['Image'] =
                                      'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                  dropDownMap['CountryCode'] = snapshot.data[i]
                                          ['CountryCode']
                                      .toString();
                                  dropDownMap['DateFormat'] =
                                      snapshot.data[i]['DateFormat'].toString();
                                  dropDownMap['CurrencySign'] = snapshot.data[i]
                                          ['CurrencySigne']
                                      .toString();

                                  SharedPreferencesKeys.prefs!.setString(
                                      SharedPreferencesKeys.dateFormat,
                                      dropDownMap['DateFormat'].toString());
                                  SharedPreferencesKeys.prefs!.setString(
                                      SharedPreferencesKeys.currencySign,
                                      dropDownMap['CurrencySign'].toString());
                                  SharedPreferencesKeys.prefs!.setString(
                                      'CountryName',
                                      dropDownMap['CountryName'].toString());
                                }
                              }

                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 8.0, right: 8.0),
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
                        // CountryCodePicker(
                        //   initialSelection: "PK",
                        //   showCountryOnly: true,
                        //   showOnlyCountryWhenClosed: true,
                        //   favorite: [countryCode, 'PK'],
                        //   onChanged: (CountryCode _countryCode)async{
                        //     countryCode=_countryCode.dialCode!;
                        //     countryClinetId=await Provider.of<AuthProvider>(context,listen: false).getClientIdFromCountryCodeTable(_countryCode.dialCode!);
                        //   },
                        // ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 8.0, right: 8.0),
                                child: TextFormField(
                                    controller: _phoneNumberController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1)),
                                      prefixIcon: Icon(Icons.phone),
                                      labelText: "Enter Phone Number",
                                      //  labelText: "Enter Phone Number",
                                      filled: true,
                                      fillColor: Colors.white,
                                      focusColor: Colors.green,
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.black, // background
                                      foregroundColor: Colors.white,
                                      minimumSize: Size(150, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ) // foreground
                                      ),
                                  onPressed: () async {
                                    print(
                                      await Provider.of<FirebaseAuthProvider>(
                                        mainContext,
                                        listen: false,
                                      ).sentRequestForOtp(
                                        _phoneNumberController.text,
                                        mainContext,
                                        countryClientId: countryClinetId,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Send OTP",
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
                  designSize: const Size(320.0, 405.0),
                  builder: (child, con) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            height: 330.w,
                            width: 320.h,
                            color: Colors.white,
                            margin: MediaQuery.of(context).viewInsets,
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
                                    "Login With Phone Number",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  FutureBuilder(
                                    future: Provider.of<AuthenticationProvider>(
                                            context,
                                            listen: false)
                                        .getAllDataFromCountryCodeTable(),
                                    //getting the dropdown data from query
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.hasData) {
                                        //print(snapshot.data);
                                        for (int i = 0;
                                            i < snapshot.data!.length;
                                            i++) {
                                          if (DateTime.now().timeZoneName ==
                                              snapshot.data![i]['SName']) {
                                            dropDownMap['ID'] = snapshot.data[i]
                                                    ['ID']
                                                .toString();
                                            dropDownMap['CountryName'] =
                                                snapshot.data[i]['CountryName']
                                                    .toString();

                                            dropDownMap['ClientID'] =
                                                snapshot.data[i]['ClientID'];

                                            dropDownMap['Image'] =
                                                'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                            dropDownMap['CountryCode'] =
                                                snapshot.data[i]['CountryCode']
                                                    .toString();

                                            if (_phoneNumberController.text
                                                    .toString()
                                                    .length <
                                                5) {
                                              _phoneNumberController.value =
                                                  _phoneNumberController.value
                                                      .copyWith(
                                                          text: snapshot.data[i]
                                                                  [
                                                                  'CountryCode']
                                                              .toString(),
                                                          selection:
                                                              TextSelection
                                                                  .fromPosition(
                                                            TextPosition(
                                                                offset: snapshot
                                                                    .data[i][
                                                                        'CountryCode']
                                                                    .toString()
                                                                    .length),
                                                          ));
                                            }

                                            dropDownMap['DateFormat'] = snapshot
                                                .data[i]['DateFormat']
                                                .toString();
                                            countryClinetId =
                                                snapshot.data[i]['ClientID'];
                                            dropDownMap['CurrencySign'] =
                                                snapshot.data[i]
                                                        ['CurrencySigne']
                                                    .toString();

                                            SharedPreferencesKeys.prefs!
                                                .setString(
                                                    SharedPreferencesKeys
                                                        .dateFormat,
                                                    dropDownMap['DateFormat']
                                                        .toString());
                                            SharedPreferencesKeys.prefs!
                                                .setString(
                                                    SharedPreferencesKeys
                                                        .currencySign,
                                                    dropDownMap['CurrencySign']
                                                        .toString());
                                            SharedPreferencesKeys.prefs!
                                                .setString(
                                                    'CountryName',
                                                    dropDownMap['CountryName']
                                                        .toString());
                                          }
                                        }

                                        return Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.h,
                                                left: 8.0.w,
                                                right: 8.0.w),
                                            child: InkWell(
                                                onTap: () async {
                                                  dropDownMap =
                                                      await showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        DropDownStyle1Image(
                                                      acc1TypeList:
                                                          snapshot.data,
                                                      // dropdown_title: dropDownMap['Title'],
                                                      //dropdown_title: dropDownMap['Title'],
                                                      map: dropDownMap,
                                                    ),
                                                  );
                                                  setState(() {
                                                    _phoneNumberController
                                                        .text = dropDownMap[
                                                            'CountryCode']
                                                        .toString();

                                                    countryCode = dropDownMap[
                                                            'CountryCode']
                                                        .toString();
                                                    String obj =
                                                        dropDownMap['ClientID']
                                                            .toString();
                                                    // ignore: unnecessary_null_comparison
                                                    if (obj != null) {
                                                      countryClinetId =
                                                          int.parse(
                                                              obj.toString());
                                                    }
                                                    print(countryCode);
                                                    print(countryClinetId);
                                                  });
                                                },
                                                child: DropDownStyle1State
                                                    .DropDownButton(
                                                        title: dropDownMap[
                                                                'CountryName']
                                                            .toString(),
                                                        id: dropDownMap[
                                                                'CountryCode']
                                                            .toString(),
                                                        image:
                                                            dropDownMap['Image']
                                                                .toString())),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.h,
                                              left: 8.0.w,
                                              right: 8.0.w),
                                          child: TextFormField(
                                              controller:
                                                  _phoneNumberController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.h,
                                                  ),
                                                ),
                                                prefixIcon: Icon(Icons.phone),
                                                labelText: "Enter Phone Number",
                                                //  labelText: "Enter Phone Number",
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusColor: Colors.green,
                                              )),
                                        ),
                                        SizedBox(
                                          height: 30.w,
                                        ),
                                        Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.black, // background
                                                foregroundColor: Colors.white,
                                                minimumSize: Size(150, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ) // foreground
                                                ),
                                            onPressed: () async {
                                              SharedPreferencesKeys.prefs!
                                                  .setInt(
                                                      SharedPreferencesKeys
                                                          .projectId,
                                                      0);

                                              var valueToCheck = await Provider
                                                  .of<AuthenticationProvider>(
                                                context,
                                                listen: false,
                                              ).checkPhoneNumber(
                                                  _phoneNumberController.text
                                                      .toString(),
                                                  dropDownMap['ClientID'],
                                                  context);
                                              if (valueToCheck != 0) {
                                                await Provider.of<
                                                    FirebaseAuthProvider>(
                                                  context,
                                                  listen: false,
                                                ).sentRequestForOtp(
                                                  _phoneNumberController.text,
                                                  context,
                                                  countryClientId:
                                                      countryClinetId,
                                                );
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Center(
                                                        child: SizedBox(
                                                          height: 150,
                                                          width: 300,
                                                          child: Material(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                      'Your Number is not register'),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            mainContext);
                                                                      },
                                                                      child: Text(
                                                                          'ok'))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            },
                                            child: Text(
                                              "Send OTP",
                                              style:
                                                  TextStyle(fontSize: 15.0.sp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
}
