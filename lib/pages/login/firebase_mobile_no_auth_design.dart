import 'package:com/config/validator.dart';
import 'package:com/pages/login/create_account_and_login_code_provider.dart';
import 'package:com/pages/login/firebase_auth_provider.dart';
import 'package:com/pages/material/countrypicker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../../widgets/constants.dart';

class PhoneNumberAuthForm extends StatefulWidget {
  final String? countryUserID;
  final String? status;
  PhoneNumberAuthForm({Key? key, this.countryUserID, this.status})
      : super(key: key);

  @override
  _PhoneNumberAuthFormState createState() => _PhoneNumberAuthFormState();
}

class _PhoneNumberAuthFormState extends State<PhoneNumberAuthForm> {
  final _formKey = GlobalKey<FormState>();
  String countryCode = '';
  int? countryClinetId;
  bool check = true;
  Map dropDownMap = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
  };
  TextEditingController phoneNumberController = TextEditingController();

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
    return Material(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Text('Please verify your mobile number')),
              FutureBuilder(
                future:
                    Provider.of<AuthenticationProvider>(context, listen: false)
                        .getAllDataFromCountryCodeTable(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    Future.delayed(
                      Duration.zero,
                      () {
                        if (check) {
                          for (int i = 0; i < snapshot.data!.length; i++) {
                            if (DateTime.now().timeZoneName ==
                                snapshot.data![i]['SName']) {
                              print(
                                  '.............................................................time...........................f');
                              dropDownMap['ID'] =
                                  snapshot.data[i]['ID'].toString();
                              dropDownMap['CountryName'] =
                                  snapshot.data[i]['CountryName'].toString();
                              dropDownMap['Image'] =
                                  'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                              dropDownMap['CountryCode'] =
                                  snapshot.data[i]['CountryCode'].toString();
                              dropDownMap['DateFormat'] =
                                  snapshot.data[i]['DateFormat'].toString();
                              dropDownMap['CurrencySign'] =
                                  snapshot.data[i]['CurrencySigne'].toString();
                              countryClinetId = int.parse(
                                  snapshot.data[i]['ClientID'].toString());
                              // phoneNumberController.text =
                              //     snapshot.data[i]['CountryCode'].toString();
                              SharedPreferencesKeys.prefs!.setString(
                                  SharedPreferencesKeys.dateFormat,
                                  dropDownMap['DateFormat'].toString());
                              SharedPreferencesKeys.prefs!.setString(
                                  SharedPreferencesKeys.currencySign,
                                  dropDownMap['CurrencySign'].toString());
                              SharedPreferencesKeys.prefs!.setString(
                                  'CountryName',
                                  dropDownMap['CountryName'].toString());

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
                            builder: (_) => DropDownStyle1Image(
                              acc1TypeList: snapshot.data,
                              // dropdown_title: dropDownMap['Title'],
                              //dropdown_title: dropDownMap['Title'],
                              map: dropDownMap,
                            ),
                          );
                          setState(
                            () {
                              countryCode =
                                  dropDownMap['CountryCode'].toString();
                              String obj = dropDownMap['ClientID'].toString();
                              // ignore: unnecessary_null_comparison
                              if (obj != null) {
                                countryClinetId = int.parse(obj.toString());
                              }
                              print(countryCode);
                              print(countryClinetId);
                            },
                          );
                        },
                        child: DropDownStyle1State.DropDownButton(
                          title: dropDownMap['CountryName'].toString(),
                          id: dropDownMap['CountryCode'].toString(),
                          image: dropDownMap['Image'].toString(),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 50,
                  child: TextFormField(
                    controller: phoneNumberController,
                    validator: (value) {
                      if (Validator.validateNumber(value!)) {
                        return "Phone number cannot be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone_android_sharp),
                        prefix: Text(dropDownMap['CountryCode'].toString()),
                        hintText: "Number",
                        labelText: "Number",
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.green,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                width: 20,
                                style: BorderStyle.solid))),
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // background
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ) // foreground
                      ),
                  onPressed: () {
                    Constants.onLoading(context, 'Please Wait.....');
                    Provider.of<AuthenticationProvider>(context, listen: false)
                        .checkPhoneNumber(
                            '${dropDownMap['CountryCode']}${phoneNumberController.text}',
                            countryClinetId!,
                            context)
                        .then(
                      (value) {
                        if (value != 1) {
                          // Constants.hideDialog(context);
                          print('$value..................................');
                          Provider.of<FirebaseAuthProvider>(context,
                                  listen: false)
                              .sentRequestForOtp(
                                  '${dropDownMap['CountryCode']}${phoneNumberController.text}',
                                  context,
                                  countryClientId: countryClinetId,
                                  countryUserID: widget.countryUserID,
                                  status: widget.status == null
                                      ? 'Add'
                                      : widget.status);
                        } else {
                          print('$value...................else...............');
                        }
                      },
                    );
                  },
                  child: Text("Send Code"))
            ],
          ),
        ),
      ),
    );
  }
}
