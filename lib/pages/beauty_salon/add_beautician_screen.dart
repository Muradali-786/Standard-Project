import 'package:com/pages/beauty_salon/sql_file_beauty_salon.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../login/create_account_and_login_code_provider.dart';
import '../material/countrypicker.dart';

class AddBeauticianScreen extends StatefulWidget {
  final Map? data;

  const AddBeauticianScreen({super.key, this.data});

  @override
  State<AddBeauticianScreen> createState() => _AddBeauticianScreenState();
}

class _AddBeauticianScreenState extends State<AddBeauticianScreen> {
  TextEditingController chairNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  Map dropDownMap = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
    'Code2': '',
  };

  bool check = true;
  String countryCode = '+92';
  int? countryClientId;
  String gender = 'Gender';

  List<String> genderList = ['Gender', 'Male', 'Female'];

  String status = 'Available';

  List<String> statusList = ['Available', 'Not Available'];

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      chairNumberController.text = widget.data!['ChairNo'].toString();
      nameController.text = widget.data!['BeauticianName'].toString();
      desController.text = widget.data!['BeauticianDescription'].toString();
      mobileController.text = widget.data!['MobileNo'].toString();
      ageController.text = widget.data!['Age'].toString();

      status = widget.data!['Status'].toString();
      gender = widget.data!['Gender'].toString();

      String phoneNumber = widget.data!['MobileNo'].toString();
      PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber).then((value) {
        countryCode = value.dialCode.toString();
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: chairNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Chair No',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Beautician Name',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FutureBuilder(
                future:
                    Provider.of<AuthenticationProvider>(context, listen: false)
                        .getAllDataFromCountryCodeTable(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    if (widget.data == null) {
                      Future.delayed(
                        Duration.zero,
                        () {
                          if (check) {
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
                                dropDownMap['DateFormat'] =
                                    snapshot.data[i]['DateFormat'].toString();
                                dropDownMap['CurrencySign'] = snapshot.data[i]
                                        ['CurrencySigne']
                                    .toString();
                                dropDownMap['Code2'] =
                                    snapshot.data[i]['Code2'].toString();
                                countryClientId = int.parse(
                                    snapshot.data[i]['ClientID'].toString());
                                mobileController.text =
                                    snapshot.data[i]['CountryCode'].toString();
                                setState(() {});
                              }
                            }
                            check = false;
                          }
                        },
                      );
                    } else {
                      Future.delayed(
                        Duration.zero,
                        () {
                          if (check) {
                            for (int i = 0; i < snapshot.data!.length; i++) {
                              if (snapshot.data![i]['CountryCode'].toString() ==
                                  '+$countryCode') {
                                dropDownMap['Image'] =
                                    'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';

                                setState(() {});
                              }
                            }
                            check = false;
                          }
                        },
                      );
                    }
                    return SizedBox(
                      height: 60,
                      child: TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: 30,
                              child: Image.asset(
                                dropDownMap['Image'].toString(),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          suffixIcon: InkWell(
                            onTap: () async {
                              Map data = await showDialog(
                                    context: context,
                                    builder: (_) => DropDownStyle1Image(
                                      acc1TypeList: snapshot.data,
                                      map: dropDownMap,
                                    ),
                                  ) ??
                                  {};

                              print(data);

                              if (data.isNotEmpty) {
                                setState(
                                  () {
                                    dropDownMap = data;
                                    countryCode =
                                        dropDownMap['CountryCode'].toString();
                                    String obj =
                                        dropDownMap['ClientID'].toString();
                                    // ignore: unnecessary_null_comparison
                                    if (obj != null) {
                                      countryClientId =
                                          int.parse(obj.toString());
                                    }
                                    print(countryCode);
                                    print(countryClientId);
                                    mobileController.text =
                                        countryCode.toString();
                                  },
                                );
                              }
                            },
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(),
                          label: Text(
                            'Mobile No',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DropdownMenu<String>(
                initialSelection: gender,
                width: MediaQuery.of(context).size.width * .9,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    gender = value!;
                  });
                },
                dropdownMenuEntries:
                    genderList.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Age',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: desController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Beautician Details',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DropdownMenu<String>(
                initialSelection: status,
                width: MediaQuery.of(context).size.width * .9,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    status = value!;
                  });
                },
                dropdownMenuEntries:
                    statusList.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () async {
                            if (widget.data == null) {
                              bool insert = await addNewBeautician(
                                  Age: ageController.text,
                                  BeauticianDescription: desController.text,
                                  BeauticianName: nameController.text,
                                  ChairNo: chairNumberController.text,
                                  Gender: gender,
                                  MobileNo: mobileController.text,
                                  Status: status);

                              if (insert) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Inserted Successfully')));
                                Navigator.pop(context);
                              }
                            } else {
                              updateBeautician(
                                  Age: ageController.text,
                                  BeauticianDescription: desController.text,
                                  BeauticianName: nameController.text,
                                  ChairNo: chairNumberController.text,
                                  Gender: gender,
                                  MobileNo: mobileController.text,
                                  Status: status,
                                  ID: widget.data!['ID'].toString());
                              Navigator.pop(context);
                            }
                          },
                          child: Text('ADD')))),
            )
          ],
        ),
      ),
    );
  }
}
