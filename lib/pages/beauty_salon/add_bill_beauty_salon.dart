import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/pages/beauty_salon/sql_file_beauty_salon.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../login/create_account_and_login_code_provider.dart';
import '../material/countrypicker.dart';

class AddBillBeautySalon extends StatefulWidget {
  final String? beauticianID;
  final String? chairNo;
  final Map? data;

  const AddBillBeautySalon(
      {super.key, this.beauticianID, this.data, this.chairNo});

  @override
  State<AddBillBeautySalon> createState() => _AddBillBeautySalonState();
}

class _AddBillBeautySalonState extends State<AddBillBeautySalon> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController totalChargesController = TextEditingController();
  TextEditingController statusController =
      TextEditingController(text: 'waiting');
  CollectionReference country =
      FirebaseFirestore.instance.collection('Country');
  TextEditingController tokenNumberController = TextEditingController();

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

  String details = '';

  List<String> listOfServiceWithPrice = [];
  List<String> beauticianIDs = [];
  String chairNo = '';

  String beauticianID = '';

  double totalServiceDuration = 0;

  List finalCombineData = [];

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      nameController.text = widget.data!['CustomerName'].toString();
      mobileController.text = widget.data!['CustomerMobileNo'].toString();
      totalChargesController.text = widget.data!['BillAmount'].toString();
      tokenNumberController.text = widget.data!['TokenNo'].toString();

      details = widget.data!['ServicesDetail'].toString();

      listOfServiceWithPrice = details.split('\n');

      print(listOfServiceWithPrice.toString());

      String phoneNumber = widget.data!['CustomerMobileNo'].toString();
      PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber).then((value) {
        countryCode = value.dialCode.toString();
        setState(() {});
      });

      for (int i = 0; i < listOfServiceWithPrice.length - 1; i++) {
        totalCharges += double.parse(listOfServiceWithPrice[i]
                .toString()
                .split('@')
                .last
                .isEmpty
            ? '0'
            : listOfServiceWithPrice[i].toString().split('@').last.toString());
      }

      List<String> allDataFromServicePriceList = [];

      List allSelectData = listOfServiceWithPrice
          .getRange(0, listOfServiceWithPrice.length - 1)
          .toList();

      ///// combine two list
      finalCombineData = listOfServiceWithPrice
          .getRange(0, listOfServiceWithPrice.length - 1)
          .toList();

      getAllServicePriceList().then((data) {
        setState(() {
          for (int i = 0; i < data.length; i++) {
            allDataFromServicePriceList
                .add('${data[i]['ServiceName']}@${data[i]['Price']}');
          }

          print(allDataFromServicePriceList);

          bool check = true;

          for (int i = 0; i < allDataFromServicePriceList.length; i++) {
            for (int j = 0; j < allSelectData.length; j++) {
              if (allSelectData[j].toString().split('@').first.contains(
                  allDataFromServicePriceList[i].toString().split('@').first)) {
                check = false;
                break;
              } else {
                check = true;
              }
            }

            if (check) {
              check = true;
              finalCombineData.add(allDataFromServicePriceList[i]);
            }
          }
        });

        for (int i = 0; i < finalCombineData.length; i++) {
          servicePriceControllersList.add(TextEditingController(
              text: finalCombineData[i].toString().split('@').last));
          serviceNameControllersList.add(TextEditingController(
              text: finalCombineData[i].toString().split('@').first));
          if (i < allSelectData.length) {
            listOFCheck.add(true);
          } else {
            listOFCheck.add(false);
          }
        }
      });
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
                    future: orderNewIDBIll(),
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
                        'Order No : ${widget.data!['BillID']}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    )),
            FutureBuilder<List>(
                future: getAllBeautician(
                    clientId: SharedPreferencesKeys.prefs!
                        .getInt(SharedPreferencesKeys.clinetId)!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      if (beauticianIDs.isEmpty) {
                        snapshot.data!.forEach((element) {
                          beauticianIDs.add(element['BeauticianID'].toString());
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
            Padding(
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
                      widget.data == null
                          ? FutureBuilder<List>(
                              future: getAllServicePriceList(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (listOFCheck.isEmpty) {
                                    listOFCheck.clear();

                                    snapshot.data!.forEach((element) {
                                      servicePriceControllersList.add(
                                          TextEditingController(
                                              text:
                                                  element['Price'].toString()));
                                      serviceNameControllersList.add(
                                          TextEditingController(
                                              text: element['ServiceName']
                                                  .toString()));
                                      listOFCheck.add(false);
                                    });
                                  }

                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
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
                                                                        index][
                                                                        'ServiceDuration']
                                                                    .toString()
                                                                    .isEmpty
                                                                ? '0'
                                                                : snapshot.data![
                                                                        index][
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
                                                                        index][
                                                                        'ServiceDuration']
                                                                    .toString()
                                                                    .isEmpty
                                                                ? '0'
                                                                : snapshot.data![
                                                                        index][
                                                                    'ServiceDuration']);
                                                      }

                                                      print(totalServiceDuration
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
                                                      const EdgeInsets.all(6.0),
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
                                                    decoration: InputDecoration(
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
                                                          if (listOFCheck[i] ==
                                                              true) {
                                                            totalBill += double.parse(
                                                                servicePriceControllersList[
                                                                        i]
                                                                    .text
                                                                    .toString());
                                                          }
                                                        }
                                                      }
                                                      totalCharges = totalBill;

                                                      totalChargesController
                                                              .text =
                                                          totalBill.toString();
                                                    },
                                                    decoration: InputDecoration(
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
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            )
                          : finalCombineData.isNotEmpty &&
                                  listOFCheck.isNotEmpty
                              ? ListView.builder(
                                  itemCount: finalCombineData.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
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
                                            listOFCheck.isNotEmpty
                                                ? Checkbox(
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
                                                        } else {
                                                          totalCharges = totalCharges -
                                                              double.parse(
                                                                  servicePriceControllersList[
                                                                          index]
                                                                      .text
                                                                      .toString());
                                                        }

                                                        totalChargesController
                                                                .text =
                                                            totalCharges
                                                                .toString();
                                                      });
                                                    })
                                                : SizedBox(),
                                            serviceNameControllersList
                                                    .isNotEmpty
                                                ? Expanded(
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
                                                                ? FontWeight
                                                                    .bold
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
                                                  )
                                                : SizedBox(),
                                            servicePriceControllersList
                                                    .isNotEmpty
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: SizedBox(
                                                      width: 100,
                                                      child: TextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            servicePriceControllersList[
                                                                index],
                                                        readOnly:
                                                            !listOFCheck[index],
                                                        onChanged: (value) {
                                                          print(value);
                                                          double totalBill = 0;
                                                          if (value
                                                              .isNotEmpty) {
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
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                    ],
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: statusController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text(
                    'Status',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      String details = '';

                      for (int i = 0; i < listOFCheck.length; i++) {
                        if (listOFCheck[i] == true) {
                          details +=
                              "${serviceNameControllersList[i].text}@${servicePriceControllersList[i].text}\n";
                        }
                      }

                      if (widget.data == null) {
                        var allDataForLengthTokenSerial = await country
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                            .collection('CountryUser')
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                            .collection('Client')
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId).toString()}')
                            .collection('Token')
                            .get();

                        var dateForTokenNo =
                            allDataForLengthTokenSerial.docs.where((element) {
                          return DateTime.now().day ==
                              DateTime.parse('${element['TokenDate']}').day;
                        });

                        DateTime now = DateTime.now();

                        int ID = await addNewBill(
                            BeauticianID: beauticianID,
                            CustomerName: nameController.text,
                            CustomerMobileNo: mobileController.text,
                            BillStatus: statusController.text,
                            ServicesDetail: details,
                            BillAmount: totalChargesController.text,
                            TokenNo: tokenNumberController.text,
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
                                '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId).toString()}')
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
                              '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId).toString()}',
                          'ClientUserid':
                              '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId).toString()}',
                          'Status': statusController.text,
                          'ServiceStartTime': '',
                          'ServiceEndTime': '',
                          'ServiceDuration': '$totalServiceDuration',
                        });

                        Navigator.pop(context);
                      } else {
                        await updateNewBill(
                          CustomerName: nameController.text,
                          BillStatus: statusController.text,
                          CustomerMobileNo: mobileController.text,
                          ServicesDetail: details,
                          BillAmount: totalChargesController.text,
                          TokenNo: tokenNumberController.text,
                          ID: widget.data!['ID'].toString(),
                        );

                        country
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                            .collection('CountryUser')
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                            .collection('Client')
                            .doc(
                                '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}')
                            .collection('Token')
                            .doc(widget.data!['ID'].toString())
                            .update({
                          'BillAmount': '${totalChargesController.text}',
                          'CustomerNumber': '${mobileController.text}',
                          'ServicesDetail': details,
                          'CustomerName': '${nameController.text}',
                          'Status': statusController.text,
                        });
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    child: Text('SAVE'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// List<String> allDataFromServicePriceList = [];
//
//
// List allSelectData = listOfServiceWithPrice
//     .getRange(0, listOfServiceWithPrice.length - 1)
//     .toList();
//
// List finalCombineData = listOfServiceWithPrice
//     .getRange(0, listOfServiceWithPrice.length - 1)
//     .toList();
//
// List data = await getAllServicePriceList();
//
// for (int i = 0; i < data.length; i++) {
//   allDataFromServicePriceList.add(
//       '${data[i]['ServiceName']}@${data[i]['Price']}');
// }
//
// print(allDataFromServicePriceList);
//
// bool check = true;
//
// for (int i = 0;
//     i < allDataFromServicePriceList.length;
//     i++) {
//   for (int j = 0; j < allSelectData.length; j++) {
//
//     if(allSelectData[j].toString().split('@').first.contains(allDataFromServicePriceList[i].toString().split('@').first)){
//       check = false;
//       break;
//     }else{
//       check = true;
//     }
//   }
//
//   if(check){
//     check = true;
//     finalCombineData.add(allDataFromServicePriceList[i]);
//   }
// }
//
// print(finalCombineData.toString());
