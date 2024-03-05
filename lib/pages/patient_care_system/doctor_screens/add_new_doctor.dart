import 'dart:convert';
import 'dart:io';

import 'package:com/pages/patient_care_system/sql_file_care_system.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../shared_preferences/shared_preference_keys.dart';
import '../../free_classified_add/image_upload_to_server/image_upload_to_server.dart';
import '../../login/create_account_and_login_code_provider.dart';
import '../../material/countrypicker.dart';
import '../image_operation_care_system.dart';

class AddNewDoctor extends StatefulWidget {
  final Map? data;

  const AddNewDoctor({super.key, this.data});

  @override
  State<AddNewDoctor> createState() => _AddNewDoctorState();
}

class _AddNewDoctorState extends State<AddNewDoctor> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController chargesController = TextEditingController();
  TextEditingController otherChargesController = TextEditingController();
  TextEditingController timingController = TextEditingController();
  TextEditingController educationController = TextEditingController();

  // List<File> imagesPicked = [];
  // List<File> PdfPicked = [];
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
  File? _image;
  String? imageBase64;
  String? imageURl;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      nameController.text = widget.data!['DoctorName'].toString();
      subtitleController.text = widget.data!['SubTitle'].toString();
      mobileController.text = widget.data!['MobileNo'].toString();
      roomController.text = widget.data!['SeatingRoom'].toString();
      chargesController.text = widget.data!['CheckupCharges'].toString();
      otherChargesController.text =
          widget.data!['OtherChargesDetail'].toString();

      String phoneNumber = widget.data!['MobileNo'].toString();
      PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber).then((value) {
        countryCode = value.dialCode.toString();
        setState(() {});
      });

      if (widget.data!['DoctorID'] < 0) {
        getExternalStorageDirectory().then((value) {
          var dir = Directory(
              '${value!.path}/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/DoctorImages/${widget.data!['DoctorID']}.jpg');
          File file = File(dir.path);
          if (file.existsSync()) {
            _image = file;
            imageBase64 = base64Encode(_image!.readAsBytesSync());
          }
          // var docDIR = Directory(
          //     '${value.path}/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/DoctorImages/DoctorDocuments/${widget.data!['DoctorID']}');
          //
          // List<FileSystemEntity> list =
          // docDIR.listSync(followLinks: false, recursive: true);
          // for (int i = 0; i < list.length; i++) {
          //   if(list[i].path.contains('.pdf')){
          //     PdfPicked.add(File(list[i].path));
          //   }else{
          //     imagesPicked.add(File(list[i].path));
          //   }
          // }
          setState(() {});
        });
      } else {
        imageURl =
            'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/DoctorImages/${widget.data!['DoctorID']}.jpg';
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
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    _image = await imageUploadingToServer(
                        mainContext: context, status: 'Profile');

                    if (_image != null) {
                      imageBase64 = base64Encode(_image!.readAsBytesSync());
                    }

                    imageURl = null;

                    setState(() {});
                  },
                  child: Container(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: (_image == null && imageURl == null)
                            ? Container(
                                color: Colors.blue,
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 30,
                                ))
                            : imageURl == null
                                ? Image.file(
                                    _image!,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(imageURl!),
                      )),
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
                    'Doctor Name',
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
                controller: subtitleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Sub Title',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: roomController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Seating Room No',
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
                    'Checkup Charges',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: otherChargesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Other Charges Details',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: timingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Timing Details',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: educationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Doctor Education and Experience Details',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            // Wrap(
            //   children: [
            //     imagesPicked.isNotEmpty
            //         ? SizedBox(
            //             width: MediaQuery.of(context).size.width,
            //             height: 100,
            //             child: ListView.builder(
            //               scrollDirection: Axis.horizontal,
            //               itemCount: imagesPicked.length,
            //               itemBuilder: (context, index) => Stack(
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(3.0),
            //                     child: Container(
            //                       height: 100,
            //                       width: 100,
            //                       decoration: BoxDecoration(
            //                           image: DecorationImage(
            //                               image: FileImage(
            //                                 imagesPicked[index],
            //                               ),
            //                               fit: BoxFit.cover)),
            //                     ),
            //                   ),
            //
            //                   // InkWell(
            //                   //   onTap: () async{
            //                   //
            //                   //     await  showDialog(context: context, builder: (context) => AlertDialog(
            //                   //       content: Text('Do you rally want to delete this image'),
            //                   //       actions: [
            //                   //         TextButton(onPressed: () async {
            //                   //         }, child: Text('Delete')),
            //                   //         TextButton(onPressed: (){
            //                   //           Navigator.pop(context);
            //                   //         }, child: Text('Cancel'))
            //                   //       ],
            //                   //     ),);
            //                   //
            //                   //     setState(() { });
            //                   //   },
            //                   //   child: Padding(
            //                   //     padding: const EdgeInsets.all(8.0),
            //                   //     child: Icon(Icons.cancel, color: Colors.red,),
            //                   //   ),
            //                   // )
            //                 ],
            //               ),
            //             ),
            //           )
            //         : SizedBox(),
            //     PdfPicked.isNotEmpty
            //         ? SizedBox(
            //             width: MediaQuery.of(context).size.width,
            //             height: 100,
            //             child: ListView.builder(
            //               scrollDirection: Axis.horizontal,
            //               itemCount: PdfPicked.length,
            //               itemBuilder: (context, index) => Stack(
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(3.0),
            //                     child: InkWell(
            //                       onTap: () {
            //                         print(
            //                             '................................................');
            //                         OpenFilex.open(
            //                             PdfPicked[index].path.toString());
            //                       },
            //                       child: Container(
            //                         height: 100,
            //                         width: 100,
            //                         color: Colors.blue.shade50,
            //                         child: Icon(
            //                           Icons.picture_as_pdf,
            //                           color: Colors.red,
            //                           size: 50,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //
            //                   // InkWell(
            //                   //   onTap: () async{
            //                   //
            //                   //     await  showDialog(context: context, builder: (context) => AlertDialog(
            //                   //       content: Text('Do you rally want to delete this image'),
            //                   //       actions: [
            //                   //         TextButton(onPressed: () async {
            //                   //         }, child: Text('Delete')),
            //                   //         TextButton(onPressed: (){
            //                   //           Navigator.pop(context);
            //                   //         }, child: Text('Cancel'))
            //                   //       ],
            //                   //     ),);
            //                   //
            //                   //     setState(() { });
            //                   //   },
            //                   //   child: Padding(
            //                   //     padding: const EdgeInsets.all(8.0),
            //                   //     child: Icon(Icons.cancel, color: Colors.red,),
            //                   //   ),
            //                   // )
            //                 ],
            //               ),
            //             ),
            //           )
            //         : SizedBox(),
            //     Center(
            //       child: ElevatedButton(
            //           onPressed: () async {
            //             FilePickerResult? result =
            //                 await FilePicker.platform.pickFiles(
            //               type: FileType.custom,
            //               allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
            //             );
            //
            //             if (result != null) {
            //               File file = File(result.files.single.path!);
            //               if (file.path.contains('.pdf')) {
            //                 PdfPicked.add(file);
            //               } else {
            //                 imagesPicked.add(file);
            //               }
            //             }
            //
            //             setState(() {});
            //           },
            //           child: Text('Pick Documents')),
            //     ),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (widget.data == null) {
                              //imagesPicked.addAll(PdfPicked);

                              bool insert = await addNewDoctor(
                                  DoctorName: nameController.text,
                                  SubTitle: subtitleController.text,
                                  MobileNo: mobileController.text,
                                  SeatingRoom: roomController.text,
                                  imagePAth: _image,
                                  CheckupCharges: chargesController.text,
                                  OtherChargesDetail:
                                      otherChargesController.text,
                                  Status: '');

                              if (insert) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Inserted Successfully')));
                                Navigator.pop(context);
                              }
                            } else {
                              String update = await updateDoctor(
                                  DoctorName: nameController.text,
                                  SubTitle: subtitleController.text,
                                  MobileNo: mobileController.text,
                                  SeatingRoom: roomController.text,
                                  CheckupCharges: chargesController.text,
                                  OtherChargesDetail:
                                      otherChargesController.text,
                                  Status: '',
                                  ID: widget.data!['ID'].toString());

                              if (widget.data!['DoctorID'] < 0) {
                                doctorProfileImageSaveToLocal(
                                    imagePath: _image!.path,
                                    doctorID:
                                        widget.data!['DoctorID'].toString());
                              } else {
                                doctorImageUpdateToServer(
                                    imageBase64!, widget.data!['DoctorID']);
                              }

                              if (update == 'Update') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Updated Successfully')));
                              }
                            }
                          },
                          child: Text('SAVE')))),
            )
          ],
        ),
      ),
    );
  }
}
