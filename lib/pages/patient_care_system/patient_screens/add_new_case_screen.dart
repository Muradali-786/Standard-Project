import 'dart:io';

import 'package:com/pages/patient_care_system/sql_file_care_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../shared_preferences/shared_preference_keys.dart';
import '../../login/create_account_and_login_code_provider.dart';
import '../../material/countrypicker.dart';
import '../../material/datepickerstyle1.dart';
import '../image_operation_care_system.dart';

class AddNewCaseScreen extends StatefulWidget {
  final Map? data;

  const AddNewCaseScreen({super.key, this.data});

  @override
  State<AddNewCaseScreen> createState() => _AddNewCaseScreenState();
}

class _AddNewCaseScreenState extends State<AddNewCaseScreen> {
  TextEditingController oldIDController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameOfPatientController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController otherDetailsController = TextEditingController();
  TextEditingController chargesController = TextEditingController();
  TextEditingController tokenNumberController = TextEditingController();

  String gender = 'Gender';

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

  List<String> genderList = ['Gender', 'Male', 'Female'];

  String checkup = 'Checkup to Doctor';

  List<String> checkupList = ['Checkup to Doctor'];

  var orderDate = DateTime.now();

  List<File> imagesPicked = [];

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      oldIDController.text = widget.data!['OldCaseID'].toString();
      mobileController.text = widget.data!['PatientMobileNo'].toString();
      nameOfPatientController.text = widget.data!['PatientName'].toString();
      otherDetailsController.text = widget.data!['OtherDetail'].toString();
      chargesController.text = widget.data!['BillAmount'].toString();
      tokenNumberController.text = widget.data!['TokenNo'].toString();
      gender = widget.data!['Gender'].toString();

      orderDate = DateTime.parse(widget.data!['CaseDate'].toString());

      String phoneNumber = widget.data!['PatientMobileNo'].toString();
      PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber).then((value) {
        countryCode = value.dialCode.toString();
        setState(() {});
      });

      if (widget.data!['CaseID'] < 0) {
        getExternalStorageDirectory().then((value) {
          var docDIR = Directory(
              '${value!.path}/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/DoctorImages/DoctorCase/${widget.data!['CaseID']}');

          List<FileSystemEntity> list =
              docDIR.listSync(followLinks: false, recursive: true);
          for (int i = 0; i < list.length; i++) {
            imagesPicked.add(File(list[i].path));
          }
          setState(() {});
        });
      } else {
        CaseFileImages(widget.data!['CaseID'].toString()).then((value) {
          setState(() {
            imagesPicked.addAll(value);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            widget.data == null
                ? FutureBuilder<int>(
                    future: NewCaseID(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(border: Border.all()),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Center(
                                  child: Text(
                                'Case No : ${snapshot.data!}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ));
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                          child: Text(
                        'Order No : ${widget.data!['CaseID']}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    )),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: oldIDController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Old Case ID',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                onTap: () async {
                  orderDate = await showDialog(
                      context: context,
                      builder: (context) {
                        return DatePickerStyle1();
                      });
                  setState(() {});
                },
                readOnly: true,
                controller: TextEditingController(
                    text: '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(orderDate.toString().substring(0, 4)), int.parse(orderDate.toString().substring(
                          5,
                          7,
                        )), int.parse(orderDate.toString().substring(8, 10)))).toString()}'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  label: Text(
                    'Date',
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
              child: TextField(
                controller: nameOfPatientController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Name of Patient',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DropdownMenu<String>(
                initialSelection: gender,
                width: MediaQuery.of(context).size.width * .95,
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
              child: DropdownMenu<String>(
                initialSelection: checkup,
                width: MediaQuery.of(context).size.width * .95,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    checkup = value!;
                  });
                },
                dropdownMenuEntries:
                    checkupList.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: otherDetailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Other Details',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: chargesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Charges',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: tokenNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Token No',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Wrap(
              children: [
                imagesPicked.isNotEmpty
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imagesPicked.length,
                          itemBuilder: (context, index) => Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(
                                            imagesPicked[index],
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                              ),

                              // InkWell(
                              //   onTap: () async{
                              //
                              //     await  showDialog(context: context, builder: (context) => AlertDialog(
                              //       content: Text('Do you rally want to delete this image'),
                              //       actions: [
                              //         TextButton(onPressed: () async {
                              //         }, child: Text('Delete')),
                              //         TextButton(onPressed: (){
                              //           Navigator.pop(context);
                              //         }, child: Text('Cancel'))
                              //       ],
                              //     ),);
                              //
                              //     setState(() { });
                              //   },
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Icon(Icons.cancel, color: Colors.red,),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                        );

                        if (result != null) {
                          File file = File(result.files.single.path!);

                          imagesPicked.add(file);
                        }

                        setState(() {});
                      },
                      child: Text('Pick Documents')),
                ),
              ],
            ),
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      if (widget.data == null) {
                        bool insert = await addNewCase(
                            context: context,
                            CaseDate: orderDate.toString().substring(0, 10),
                            docImage: imagesPicked,
                            OldCaseID: oldIDController.text,
                            CaseTime: '',
                            PatientName: nameOfPatientController.text,
                            PatientMobileNo: mobileController.text,
                            Gender: gender,
                            CheckupToDoctorID: checkup,
                            OtherDetail: otherDetailsController.text,
                            BillAmount: chargesController.text,
                            TokenNo: tokenNumberController.text);

                        if (insert) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Inserted Successfully')));
                          Navigator.pop(context);

                          setState(() {});
                        }
                      } else {
                        String update = await updateCasePatient(
                            CaseDate: orderDate.toString().substring(0, 10),
                            OldCaseID: oldIDController.text,
                            CaseTime: '',
                            PatientName: nameOfPatientController.text,
                            PatientMobileNo: mobileController.text,
                            Gender: gender,
                            CheckupToDoctorID: checkup,
                            OtherDetail: otherDetailsController.text,
                            BillAmount: chargesController.text,
                            TokenNo: tokenNumberController.text,
                            ID: widget.data!['ID'].toString());

                        if (update == 'Update') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Inserted Successfully')));
                        }
                      }
                    },
                    child: Text('Save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
