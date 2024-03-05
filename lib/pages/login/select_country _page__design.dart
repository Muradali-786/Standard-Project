import 'package:com/pages/login/create_account_and_login_code_provider.dart';
import 'package:com/pages/material/countrypicker.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectCountryPage extends StatefulWidget {
  const SelectCountryPage({Key? key}) : super(key: key);

  @override
  _SelectCountryPageState createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  Map dropDownMap = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    'Image': '',
    'DateFormat': '',
    'CurrencySign': '',
  };
  String countryCode = '+92';
  num? countryClinetId;
  String? countryName;

  void initState() {
    Provider.of<AuthenticationProvider>(context, listen: false)
        .getClientIdFromCountryCodeTable(countryCode)
        .then((value) {
      countryClinetId = value;
      print("asa" + countryClinetId.toString());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future:
                  Provider.of<AuthenticationProvider>(context, listen: false)
                      .getAllDataFromCountryCodeTable(),
              //getting the dropdown data from query
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  //print(snapshot.data);
                  for (int i = 0; i < snapshot.data!.length; i++) {
                    if (DateTime.now().timeZoneName ==
                        snapshot.data![i]['SName']) {
                      dropDownMap['ID'] = snapshot.data[i]['ID'].toString();
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

                      SharedPreferencesKeys.prefs!.setString(
                          SharedPreferencesKeys.dateFormat,
                          dropDownMap['DateFormat'].toString());
                      SharedPreferencesKeys.prefs!.setString(
                          SharedPreferencesKeys.currencySign,
                          dropDownMap['CurrencySign'].toString());
                      SharedPreferencesKeys.prefs!.setString(
                          'CountryName', dropDownMap['CountryName'].toString());
                    }
                  }
                  return Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: InkWell(
                          onTap: () async {
                            print(
                                '...........................${snapshot.data}');

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
                              SharedPreferencesKeys.prefs!.setString(
                                  SharedPreferencesKeys.dateFormat,
                                  dropDownMap['DateFormat'].toString());
                              SharedPreferencesKeys.prefs!.setString(
                                  SharedPreferencesKeys.currencySign,
                                  dropDownMap['CurrencySign'].toString());
                              SharedPreferencesKeys.prefs!.setString(
                                  'CountryName',
                                  dropDownMap['CountryName'].toString());
                              countryCode =
                                  dropDownMap['CountryCode'].toString();
                              String obj = dropDownMap['ClientID'].toString();
                              countryName =
                                  dropDownMap['CountryName'].toString();
                              SharedPreferencesKeys.prefs!
                                  .setString('CountryName', countryName!);
                              // ignore: unnecessary_null_comparison
                              if (obj != null) {
                                countryClinetId = int.parse(obj.toString());
                              }
                              print(
                                  '..........................................................$dropDownMap');
                              print(countryClinetId);
                            });
                          },
                          child: DropDownStyle1State.DropDownButton(
                            title: dropDownMap['CountryName'].toString(),
                            id: dropDownMap['CountryCode'].toString(),
                            image: dropDownMap['Image'].toString(),
                          )),
                    ),
                  );
                }
                return Container();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 100,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // background
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ), // foreground
                  ),
                  onPressed: () {
                    Navigator.pop(context, countryClinetId);
                  },
                  child: Text('OK')),
            ),
          ],
        ),
      ),
    );
  }
}
