import 'package:com/pages/material/countrypicker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../../utils/api_query_for_web.dart';
import 'create_account_and_login_code_provider.dart';

class PasswordLogin extends StatefulWidget {
  const PasswordLogin({Key? key}) : super(key: key);

  @override
  _PasswordLoginState createState() => _PasswordLoginState();
}

class _PasswordLoginState extends State<PasswordLogin> {
  TextEditingController accountGroupNameController =
      new TextEditingController();
  Map dropDownMap = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
  };
  bool isShowPassword = false;
  Color emailColor = Colors.grey;
  Color phoneColor = Colors.blue;
  IconData iconForMailAndNumber = Icons.phone_android;
  String label = 'Mobile Number';
  String sufixForGmail = '';
  String countryChange = '';

  /// xxxxxxxxx get from country picker dropdown  xxxxxxxxxxxx///
  String countryCode = '';
  int? countryClinetId;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          child: Container(
            height: MediaQuery.of(context).size.height*0.48,
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(8)
         ),
            width: 320,
          
            margin: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Login With Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  FutureBuilder(
                    future: kIsWeb
                        ? apiFetchForWeb(query: 'Select * from CountryCode')
                        : Provider.of<AuthenticationProvider>(context,
                                listen: false)
                            .getAllDataFromCountryCodeTable(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        // List<Map>   snap  =  snapshot.data as  List<Map>;
                        print(
                            '================ data${snapshot.data}------------------------');

                        if (countryChange == '') {
                          for (int i = 0; i < snapshot.data!.length; i++) {
                            if (DateTime.now().timeZoneName ==
                                snapshot.data![i]['SName']) {
                              dropDownMap['ID'] =
                                  snapshot.data[i]['ID'].toString();
                              dropDownMap['CountryName'] =
                                  snapshot.data[i]['CountryName'].toString();
                              dropDownMap['Image'] =
                                  'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                              dropDownMap['CountryCode'] =
                                  snapshot.data[i]['CountryCode'].toString();
                              if (label == 'Mobile Number') {
                                if (_emailController.text.toString().length <
                                    5) {
                                  _emailController.value =
                                      _emailController.value.copyWith(
                                    text: snapshot.data[i]['CountryCode']
                                        .toString(),
                                    selection: TextSelection.fromPosition(
                                      TextPosition(
                                          offset: snapshot.data[i]
                                                  ['CountryCode']
                                              .toString()
                                              .length),
                                    ),
                                  );
                                }
                              }
                              dropDownMap['DateFormat'] =
                                  snapshot.data[i]['DateFormat'].toString();
                              dropDownMap['CurrencySign'] =
                                  snapshot.data[i]['CurrencySigne'].toString();
                              countryClinetId = int.parse(
                                  snapshot.data[i]['ClientID'].toString());

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
                        }
                        return Center(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 8, left: 20, right: 20),
                            child: InkWell(
                              onTap: () async {
                                countryChange = 'change';
                                dropDownMap = await showDialog(
                                  context: context,
                                  builder: (_) => DropDownStyle1Image(
                                    acc1TypeList: snapshot.data,
                                    // dropdown_title: dropDownMap['Title'],
                                    //dropdown_title: dropDownMap['Title'],
                                    map: dropDownMap,
                                  ),
                                );

                                print(
                                    '....${dropDownMap['CurrencySign']}.......$dropDownMap');
                                setState(() {
                                  SharedPreferencesKeys.prefs!.setString(
                                      SharedPreferencesKeys.dateFormat,
                                      dropDownMap['DateFormat'].toString());
                                  SharedPreferencesKeys.prefs!.setString(
                                      SharedPreferencesKeys.currencySign,
                                      dropDownMap['CurrencySign'].toString());
                                  SharedPreferencesKeys.prefs!.setString(
                                      'CountryName',
                                      dropDownMap['CountryName'].toString());
                                  _emailController.text =
                                      dropDownMap['CountryCode'].toString();
                                  countryCode =
                                      dropDownMap['CountryCode'].toString();
                                  String obj =
                                      dropDownMap['ClientID'].toString();

                                  countryClinetId = int.parse(obj.toString());

                                  print(countryCode);
                                  print(countryClinetId);
                                });
                              },
                              child: DropDownStyle1State.DropDownButton(
                                title: dropDownMap['CountryName'].toString(),
                                id: dropDownMap['CountryCode'].toString(),
                                image: dropDownMap['Image'].toString(),
                              ),
                            ),
                          ),
                        );
                      } else {
                        print(
                            '.......-----   no   data is fetching .....................');
                        return Container();
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                _emailController.text =
                                    dropDownMap['CountryCode'].toString();
                                phoneColor = Colors.blue;
                                emailColor = Colors.grey;
                                label = 'Mobile Number';
                                sufixForGmail = '';
                                iconForMailAndNumber = Icons.phone_android;
                              });
                            },
                            child: Icon(
                              Icons.phone_android,
                              color: phoneColor,
                            )),
                        InkWell(
                            onTap: () {
                              setState(() {
                                _emailController.clear();
                                phoneColor = Colors.grey;
                                emailColor = Colors.blue;
                                sufixForGmail = '@gmail.com';
                                label = 'Gmail';
                                iconForMailAndNumber = Icons.mail;
                              });
                            },
                            child: Icon(
                              Icons.mail,
                              color: emailColor,
                            )),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 20, right: 20),
                          child: TextFormField(
                              // initialValue:_emailController.text.toString(),
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Phone Number Or Password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffix: Text(sufixForGmail),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                //  prefix: Text('91'),
                                prefixIcon: Icon(iconForMailAndNumber),
                                labelText: label,
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.green,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 20, right: 20),
                          child: TextFormField(
                            obscureText: isShowPassword ? false : true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password cannot be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(Icons.vpn_key),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isShowPassword = !isShowPassword;
                                  });
                                },
                                child: Icon(Icons.visibility),
                              ),
                              labelText: "password",
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Colors.green,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                minimumSize: Size(150, 50),
                                maximumSize: Size(150, 50),
                                // background
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ) // foreground
                                ),
                            onPressed: () async {
                              SharedPreferencesKeys.prefs!
                                  .setInt(SharedPreferencesKeys.projectId, 0);
                              if (_formKey.currentState!.validate()) {
                                print('form is valid');
                                if (sufixForGmail == '') {
                                  print("It is a phone number");
                                  await Provider.of<AuthenticationProvider>(
                                          context,
                                          listen: false)
                                      .loginWithMobileNoOrEmailPasswordWithServer(
                                    _emailController.text,
                                    _passwordController.text,
                                    countryClinetId,
                                    'AcMobileNo',
                                    context,
                                  );
                                } else {
                                  print('It is an email');
                                  Provider.of<AuthenticationProvider>(context,
                                          listen: false)
                                      .loginWithMobileNoOrEmailPasswordWithServer(
                                          '${_emailController.text}@gmail.com',
                                          _passwordController.text,
                                          countryClinetId,
                                          'AcEmailAddress',
                                          context);
                                }
                              }
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
