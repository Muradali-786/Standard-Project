import 'dart:io';

import 'package:com/pages/marriage_hall_booking/sql_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../free_classified_add/image_upload_to_server/image_upload_to_server.dart';
import '../login/create_account_and_login_code_provider.dart';
import '../material/countrypicker.dart';
import '../material/datepickerstyle1.dart';
import 'image_processing_merriage.dart';

class BookingPage extends StatefulWidget {
  final Map? data;
  final String? eventDate;
  final String? shift;

  const BookingPage({super.key, this.data, this.eventDate, this.shift});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController nameOFPersonController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventTimingController = TextEditingController();
  TextEditingController numberPerController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController totalChargesController = TextEditingController();
  TextEditingController nicController = TextEditingController();

  var orderDate = DateTime.now();
  var eventDate = DateTime.now();

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

  List<File> imagesPicked = [];

  List<String> shiftList = ['Night', 'Day', 'Morning'];

  String selectedShift = 'Night';

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      orderDate = DateTime.parse(widget.data!['BookingDate'].toString());
      eventDate = DateTime.parse(widget.data!['EventDate'].toString());
      nameOFPersonController.text = widget.data!['ClientName'].toString();
      mobileController.text = widget.data!['ClientMobile'].toString();
      nicController.text = widget.data!['ClientNIC'].toString();
      addressController.text = widget.data!['ClientAddress'].toString();
      eventNameController.text = widget.data!['EventName'].toString();
      numberPerController.text = widget.data!['PersonsQty'].toString();
      desController.text = widget.data!['Description'].toString();
      totalChargesController.text = widget.data!['TotalCharges'].toString();

      selectedShift = widget.data!['Shift'].toString();

      String phoneNumber = widget.data!['ClientMobile'].toString();
      PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber).then((value) {
        countryCode = value.dialCode.toString();
        setState(() {});
      });

      if (widget.data!['BookingID'] < 0) {
        getExternalStorageDirectory().then((value) {
          var docDIR = Directory(
              '${value!.path}/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/MarriageImages/${widget.data!['BookingID']}');

          List<FileSystemEntity> list =
              docDIR.listSync(followLinks: false, recursive: true);
          for (int i = 0; i < list.length; i++) {
            imagesPicked.add(File(list[i].path));
          }
          setState(() {});
        });
      } else {
        MarriageFileImages(widget.data!['BookingID'].toString()).then((value) {
          setState(() {
            imagesPicked.addAll(value);
          });
        });
      }
    }

    if (widget.eventDate != null && widget.shift != null) {
      selectedShift = widget.shift!;
      eventDate = DateTime.parse(widget.eventDate.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.data == null
                    ? FutureBuilder<int>(
                        future: bookingNewID(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(border: Border.all()),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Center(
                                      child: Text(
                                    'Order No : ${snapshot.data!}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
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
                            'Order No : ${widget.data!['BookingID']}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                        )),
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
                        'Booking Date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: nameOFPersonController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'Name of Person',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FutureBuilder(
                    future: Provider.of<AuthenticationProvider>(context,
                            listen: false)
                        .getAllDataFromCountryCodeTable(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        if (widget.data == null) {
                          Future.delayed(
                            Duration.zero,
                            () {
                              if (check) {
                                for (int i = 0;
                                    i < snapshot.data!.length;
                                    i++) {
                                  if (DateTime.now().timeZoneName ==
                                      snapshot.data![i]['SName']) {
                                    dropDownMap['ID'] =
                                        snapshot.data[i]['ID'].toString();
                                    dropDownMap['CountryName'] = snapshot
                                        .data[i]['CountryName']
                                        .toString();
                                    dropDownMap['Image'] =
                                        'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                    dropDownMap['CountryCode'] = snapshot
                                        .data[i]['CountryCode']
                                        .toString();
                                    dropDownMap['DateFormat'] = snapshot.data[i]
                                            ['DateFormat']
                                        .toString();
                                    dropDownMap['CurrencySign'] = snapshot
                                        .data[i]['CurrencySigne']
                                        .toString();
                                    dropDownMap['Code2'] =
                                        snapshot.data[i]['Code2'].toString();
                                    countryClientId = int.parse(snapshot.data[i]
                                            ['ClientID']
                                        .toString());
                                    mobileController.text = snapshot.data[i]
                                            ['CountryCode']
                                        .toString();
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
                                for (int i = 0;
                                    i < snapshot.data!.length;
                                    i++) {
                                  if (snapshot.data![i]['CountryCode']
                                          .toString() ==
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
                                        countryCode = dropDownMap['CountryCode']
                                            .toString();
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
                    controller: nicController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'NIC',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'Address',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: eventNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'Event Name',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    onTap: () async {
                      eventDate = await showDialog(
                          context: context,
                          builder: (context) {
                            return DatePickerStyle1();
                          });
                      setState(() {});
                    },
                    readOnly: true,
                    controller: TextEditingController(
                        text: '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(eventDate.toString().substring(0, 4)), int.parse(eventDate.toString().substring(
                              5,
                              7,
                            )), int.parse(eventDate.toString().substring(8, 10)))).toString()}'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      label: Text(
                        'Event Date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropdownMenu<String>(
                    initialSelection: selectedShift,
                    width: MediaQuery.of(context).size.width * .9,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        selectedShift = value!;
                      });
                    },
                    dropdownMenuEntries: shiftList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: eventTimingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'Event Time',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: numberPerController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'Number of person for arrangement',
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
                        'Description of Event',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: totalChargesController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'Total Charges',
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
                              itemBuilder: (context, index) => Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(imagesPicked[index]))),
                              ),
                            ),
                          )
                        : SizedBox(),
                    ElevatedButton(
                        onPressed: () async {
                          File? file = await imageUploadingToServer(
                              status: '', mainContext: context);
                          if (file == null) return;
                          imagesPicked.add(file);
                          setState(() {});
                        },
                        child: Text('PICk Images')),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () async {
                            if (widget.data == null) {
                              bool checkInsert = await addMarriageBooking(
                                context: context,
                                ClientName: nameOFPersonController.text,
                                ClientMobile: mobileController.text,
                                ClientAddress: addressController.text,
                                docImage: imagesPicked,
                                ClientNIC: nicController.text,
                                EventName: eventNameController.text,
                                BookingDate:
                                    orderDate.toString().substring(0, 10),
                                EventDate:
                                    eventDate.toString().substring(0, 10),
                                PersonsQty: numberPerController.text,
                                TotalCharges: totalChargesController.text,
                                Shift: selectedShift,
                                Description: desController.text,
                                TotalReceived: 0,
                                BillBalance: 0,
                                EventTiming: eventTimingController.text,
                                ChargesDetail: '',
                              );

                              if (checkInsert) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Booked successful')));
                              }
                            } else {
                              String update = await updateMarriageBooking(
                                ClientName: nameOFPersonController.text,
                                ClientMobile: mobileController.text,
                                ClientAddress: addressController.text,
                                ClientNIC: nicController.text,
                                EventName: eventNameController.text,
                                BookingDate:
                                    orderDate.toString().substring(0, 10),
                                EventDate:
                                    eventDate.toString().substring(0, 10),
                                PersonsQty: numberPerController.text,
                                TotalCharges: totalChargesController.text,
                                Shift: selectedShift,
                                Description: desController.text,
                                ID: widget.data!['ID'].toString(),
                                EventTiming: eventTimingController.text,
                              );

                              if (update == 'Update') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Booked successful')));
                              }
                            }
                          },
                          child: Text('SAVE')),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
