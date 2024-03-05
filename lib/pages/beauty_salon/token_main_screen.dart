import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/pages/beauty_salon/sql_file_beauty_salon.dart';
import 'package:com/pages/material/printer_conection.dart';
import 'package:com/pages/material/token_size_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../login/create_account_and_login_code_provider.dart';
import '../material/countrypicker.dart';

class TokenMainScreen extends StatefulWidget {
  final int? clientID;

  const TokenMainScreen({
    super.key,
    this.clientID,
  });

  @override
  State<TokenMainScreen> createState() => _TokenMainScreenState();
}

class _TokenMainScreenState extends State<TokenMainScreen> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController totalChargesController = TextEditingController();
  TextEditingController statusController =
      TextEditingController(text: 'waiting');
  CollectionReference country =
      FirebaseFirestore.instance.collection('Country');
  TextEditingController tokenNumberController = TextEditingController();

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  ScreenshotController screenshotController = ScreenshotController();

  List<bool> listOFCheck = [];
  List<TextEditingController> servicePriceControllersList = [];
  List<TextEditingController> serviceNameControllersList = [];

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

  double totalCharges = 0;
  double totalServiceDuration = 0;

  String details = '';

  List<String> listOfServiceWithPrice = [];

  List<String> beauticianIDs = [];
  String chairNo = '';

  String beauticianID = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FutureBuilder<List>(
                  future: getAllBeautician(
                      clientId: widget.clientID == null
                          ? SharedPreferencesKeys.prefs!
                              .getInt(SharedPreferencesKeys.clinetId)!
                          : widget.clientID!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        if (beauticianIDs.isEmpty) {
                          snapshot.data!.forEach((element) {
                            beauticianIDs
                                .add(element['BeauticianID'].toString());
                          });

                          beauticianID = beauticianIDs.first;
                          chairNo = snapshot.data!.first['ChairNo'];
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: DropdownMenu<String>(
                            initialSelection: beauticianIDs.first,
                            width: MediaQuery.of(context).size.width * .9,
                            onSelected: (String? value) {
                              setState(() {
                                beauticianID = value!;
                              });

                              snapshot.data!.forEach((element) {
                                print('chairNo');
                                if (element['BeauticianID'].toString() ==
                                    value!.toString()) {
                                  chairNo = element['ChairNo'].toString();
                                }
                              });

                              print(chairNo);
                            },
                            dropdownMenuEntries: beauticianIDs
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                        );
                      } else {
                        return Center(child: SizedBox());
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    label: Text(
                      'Customer Name',
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () async {
                        String details = '';

                        for (int i = 0; i < listOFCheck.length; i++) {
                          if (listOFCheck[i] == true) {
                            details +=
                                "${serviceNameControllersList[i].text}@${servicePriceControllersList[i].text}\n";
                          }
                        }

                        var allDataForLengthTokenSerial = await country
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                            .collection('CountryUser')
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                            .collection('Client')
                            .doc(
                                '${widget.clientID == null ? SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)! : widget.clientID!}')
                            .collection('Token')
                            .get();

                        Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>
                            dateForTokenNo = {};

                        if (allDataForLengthTokenSerial.docs.length > 0) {
                          dateForTokenNo =
                              allDataForLengthTokenSerial.docs.where((element) {
                            return DateTime.now().day ==
                                    DateTime.parse('${element['TokenDate']}')
                                        .day &&
                                chairNo == '${element['ChairNo']}';
                          });
                        }

                        DateTime now = DateTime.now();

                        int ID = await addNewBill(
                            BeauticianID: beauticianID,
                            CustomerName: nameController.text,
                            CustomerMobileNo: mobileController.text,
                            BillStatus: statusController.text,
                            ServicesDetail: details,
                            BillAmount: totalChargesController.text,
                            TokenNo: '${dateForTokenNo.length + 1}',
                            BillDate:
                                DateTime.now().toString().substring(0, 10),
                            BookingTime: '',
                            BookForTime: '',
                            ServiceStartTime: '',
                            ServiceEndTime: '');

                        country
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                            .collection('CountryUser')
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                            .collection('Client')
                            .doc(
                                '${widget.clientID == null ? SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)! : widget.clientID!}')
                            .collection('Token')
                            .add({
                          'TokenSerial':
                              '${allDataForLengthTokenSerial.docs.length + 1}',
                          'TokenDate': '${now.toString()}',
                          'ChairNo': '$chairNo',
                          'BeauticianID': beauticianID,
                          'ServicesDetail': details,
                          'BillDate':
                              DateTime.now().toString().substring(0, 10),
                          'BillID': '$ID',
                          'TokenNo': '${dateForTokenNo.length + 1}',
                          'TokenTime':
                              "${now.hour}:${now.minute}:${now.second}",
                          'BillAmount': '${totalChargesController.text}',
                          'CustomerNumber': '${mobileController.text}',
                          'CustomerName': '${nameController.text}',
                          'ClientID':
                              '${widget.clientID == null ? SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)! : widget.clientID!}',
                          'ClientUserid':
                              '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId).toString()}',
                          'Status': 'waiting',
                          'ServiceStartTime': '',
                          'ServiceEndTime': '',
                          'ServiceDuration': '$totalServiceDuration',
                        });

                        await showDialog(
                          context: context,
                          builder: (context) => Center(
                            child: Material(
                              child: Container(
                                height: 200,
                                width: 170,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Token No',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${dateForTokenNo.length + 1}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue),
                                          onPressed: () async {
                                            bool? isConnected =
                                                await bluetooth.isConnected;

                                            if (isConnected!) {
                                              print('Printer is connected');

                                              bluetooth.printCustom(
                                                  'Your Booking successfully has been submitted',
                                                  SizeToken.medium.val,
                                                  AlignToken.center.val);
                                              bluetooth.printNewLine();
                                              bluetooth.printCustom(
                                                  'Name : Muhammad Amir',
                                                  SizeToken.medium.val,
                                                  AlignToken.center.val);
                                              bluetooth.printNewLine();
                                              bluetooth.printCustom(
                                                  'Your Token No',
                                                  SizeToken.boldMedium.val,
                                                  AlignToken.center.val);
                                              bluetooth.printCustom(
                                                  '${dateForTokenNo.length + 1}',
                                                  9,
                                                  AlignToken.center.val);
                                              bluetooth.printNewLine();
                                              bluetooth.printCustom(
                                                  'Bill Amount : ${totalChargesController.text} ',
                                                  SizeToken.medium.val,
                                                  AlignToken.left.val);

                                              bluetooth.printCustom(
                                                  'Booking DateTime : ${DateTime.now().toString()} ',
                                                  SizeToken.medium.val,
                                                  AlignToken.left.val);
                                              bluetooth.printCustom(
                                                  'Token No was on Chair : $chairNo ',
                                                  SizeToken.medium.val,
                                                  AlignToken.left.val);
                                              bluetooth.printCustom(
                                                  'Estimate Time : ' ' ',
                                                  SizeToken.medium.val,
                                                  AlignToken.left.val);
                                              bluetooth.printNewLine();
                                              bluetooth.printNewLine();
                                            } else {
                                              print(
                                                  'Printer is  not connected');

                                              // Map data = {
                                              //   'TokenNo':
                                              //       '${dateForTokenNo.length + 1}',
                                              //   'BillAmount':
                                              //       totalChargesController.text,
                                              //   'DateTime':
                                              //       '${DateTime.now().toString()}',
                                              //   'ChairNO': '',
                                              //   'Time': '',
                                              // };

                                              showDialog(
                                                context: context,
                                                builder: (context) => Center(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Container(
                                                        height: 150,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child:
                                                            PrinterConnection(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text('Print')),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () async {
                                            screenshotController
                                                .captureFromWidget(Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Center(
                                                        child: Text(
                                                      '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyName).toString()}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    )),
                                                    Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        'Name : Muhammad Amir',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )),
                                                    Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        'Current Token No : ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )),
                                                    Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        '${dateForTokenNo.length + 1}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 75,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        'Bill Amount : ${totalChargesController.text}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        'Booking DateTime : ${DateTime.now().toString()}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        'Token No was on Chair :  $chairNo  ',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        'Estimate Time : ',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                                .then((Uint8List
                                                    capturedImage) async {
                                              final directory =
                                                  await getExternalStorageDirectory();
                                              final imagePath = await File(
                                                  '${directory!.path}/${DateTime.now().microsecondsSinceEpoch}image.png');
                                              await imagePath
                                                  .writeAsBytes(capturedImage);

                                              await WhatsappShare.shareFile(
                                                filePath: [imagePath.path],
                                                phone: '923041810687',
                                              );

                                              // Handle captured image
                                            });
                                          },
                                          child: Text('WhatsApp')),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text('Get Token'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: totalChargesController,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.green),
                  readOnly: true,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Expanded(
                            child: FutureBuilder<List>(
                              future: getAllServicePriceList(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.length > 0) {
                                    if (listOFCheck.isEmpty) {
                                      listOFCheck.clear();

                                      snapshot.data!.forEach((element) {
                                        servicePriceControllersList.add(
                                            TextEditingController(
                                                text: element['Price']
                                                    .toString()));
                                        serviceNameControllersList.add(
                                            TextEditingController(
                                                text: element['ServiceName']
                                                    .toString()));
                                        listOFCheck.add(false);
                                      });
                                      listOFCheck.first = true;
                                      totalServiceDuration += double.parse(
                                          snapshot.data![0]['ServiceDuration']
                                                  .toString()
                                                  .isEmpty
                                              ? '0'
                                              : snapshot.data![0]
                                                  ['ServiceDuration']);
                                      Future.delayed(Duration.zero)
                                          .then((value) {
                                        totalChargesController.text =
                                            servicePriceControllersList
                                                .first.text;

                                        totalCharges = double.parse(
                                            servicePriceControllersList
                                                .first.text
                                                .toString());
                                      });
                                    }

                                    return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              color: listOFCheck[index] == true
                                                  ? Colors.green.shade50
                                                  : Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                    value: listOFCheck[index],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        listOFCheck[index] =
                                                            value!;
                                                        if (value) {
                                                          totalCharges += double.parse(
                                                              servicePriceControllersList[
                                                                      index]
                                                                  .text
                                                                  .toString());
                                                          totalServiceDuration +=
                                                              double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          'ServiceDuration']
                                                                      .toString()
                                                                      .isEmpty
                                                                  ? '0'
                                                                  : snapshot.data![
                                                                          index]
                                                                      [
                                                                      'ServiceDuration']);
                                                        } else {
                                                          totalCharges = totalCharges -
                                                              double.parse(
                                                                  servicePriceControllersList[
                                                                          index]
                                                                      .text
                                                                      .toString());
                                                          totalServiceDuration = totalServiceDuration -
                                                              double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                          [
                                                                          'ServiceDuration']
                                                                      .toString()
                                                                      .isEmpty
                                                                  ? '0'
                                                                  : snapshot.data![
                                                                          index]
                                                                      [
                                                                      'ServiceDuration']);
                                                        }

                                                        print(
                                                            totalServiceDuration
                                                                .toString());
                                                        totalChargesController
                                                                .text =
                                                            totalCharges
                                                                .toString();
                                                      });
                                                    }),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: TextField(
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      style: TextStyle(
                                                          fontWeight: listOFCheck[
                                                                      index] ==
                                                                  true
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal),
                                                      controller:
                                                          serviceNameControllersList[
                                                              index],
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        focusedBorder:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: SizedBox(
                                                    width: 100,
                                                    child: TextField(
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          servicePriceControllersList[
                                                              index],
                                                      readOnly:
                                                          !listOFCheck[index],
                                                      onChanged: (value) {
                                                        print(value);
                                                        double totalBill = 0;
                                                        if (value.isNotEmpty) {
                                                          for (int i = 0;
                                                              i <
                                                                  servicePriceControllersList
                                                                      .length;
                                                              i++) {
                                                            if (listOFCheck[
                                                                    i] ==
                                                                true) {
                                                              totalBill += double.parse(
                                                                  servicePriceControllersList[
                                                                          i]
                                                                      .text
                                                                      .toString());
                                                            }
                                                          }
                                                        }
                                                        totalCharges =
                                                            totalBill;

                                                        totalChargesController
                                                                .text =
                                                            totalBill
                                                                .toString();
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        focusedBorder:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center(child: SizedBox());
                                  }
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> share() async {}
