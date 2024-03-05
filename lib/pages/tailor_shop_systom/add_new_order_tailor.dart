import 'dart:io';
import 'package:com/pages/tailor_shop_systom/image_processing_tailor.dart';
import 'package:com/pages/tailor_shop_systom/print_page.dart';
import 'package:com/pages/tailor_shop_systom/sql_file.dart';
import 'package:com/pages/tailor_shop_systom/widgets.dart';
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

class AddNewOrderTailor extends StatefulWidget {
  final Map? data;

  const AddNewOrderTailor({super.key, this.data});

  @override
  State<AddNewOrderTailor> createState() => _AddNewOrderTailorState();
}

class _AddNewOrderTailorState extends State<AddNewOrderTailor> {
  TextEditingController nameOFPersonController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController orderTitleController = TextEditingController();
  TextEditingController sizeAndDetailsController = TextEditingController();
  TextEditingController totalChargesController = TextEditingController();

  var orderDate = DateTime.now();
  var deliveryDate = DateTime.now();
  int orderID = 0;

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

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      print(widget.data);
      nameOFPersonController.text = widget.data!['CustomerName'];
      mobileController.text = widget.data!['CustomerMobileNo'];
      orderTitleController.text = widget.data!['OrderTitle'];
      sizeAndDetailsController.text = widget.data!['OBRemarks'];
      totalChargesController.text = widget.data!['BillAmount'].toString();
      orderDate = DateTime.parse(widget.data!['OrderDate'].toString());
      deliveryDate = DateTime.parse(widget.data!['DeliveryDate'].toString());
      orderID = widget.data!['TailorBooking1ID'] * -1;

      String phoneNumber = widget.data!['CustomerMobileNo'].toString();
      PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber).then((value) {
        countryCode = value.dialCode.toString();
        setState(() {});
      });

      if (widget.data!['TailorBooking1ID'] < 0) {
        getExternalStorageDirectory().then((value) {
          var docDIR = Directory(
              '${value!.path}/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}/TailorImages/${widget.data!['TailorBooking1ID']}');

          List<FileSystemEntity> list =
              docDIR.listSync(followLinks: false, recursive: true);
          for (int i = 0; i < list.length; i++) {
            imagesPicked.add(File(list[i].path));
          }
          setState(() {});
        });
      } else {
        TailorFileImages(widget.data!['TailorBooking1ID'].toString())
            .then((value) {
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
      appBar: AppBar(
        title: Text('Add Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.data == null
                    ? FutureBuilder<int>(
                        future: orderNewID(),
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
                            'Order No : ${orderID}',
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
                        'Order Date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    onTap: () async {
                      deliveryDate = await showDialog(
                          context: context,
                          builder: (context) {
                            return DatePickerStyle1();
                          });
                      setState(() {});
                    },
                    readOnly: true,
                    controller: TextEditingController(
                        text: '${DateFormat(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat)).format(DateTime(int.parse(deliveryDate.toString().substring(0, 4)), int.parse(deliveryDate.toString().substring(
                              5,
                              7,
                            )), int.parse(deliveryDate.toString().substring(8, 10)))).toString()}'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      label: Text(
                        'Order Date',
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
                        'Name of person',
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
                    controller: orderTitleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'Order title',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    maxLines: 4,
                    controller: sizeAndDetailsController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      label: Text(
                        'Sizing and Details',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Text('Total Charge : '),
                        Expanded(
                          child: TextField(
                            controller: totalChargesController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
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
                            File? file = await imageUploadingToServer(
                                status: '', mainContext: context);
                            if (file == null) return;
                            imagesPicked.add(file);
                            setState(() {});
                          },
                          child: Text('Pick Images')),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (mobileController.text.isNotEmpty &&
                                orderTitleController.text.isNotEmpty &&
                                totalChargesController.text.isNotEmpty) {
                              if (widget.data == null) {
                                orderID = await orderNewID() * -1;
                                bool insert = await addTailorBooking(
                                  context: context,
                                  CustomerMobileNo: mobileController.text,
                                  OBRemarks: sizeAndDetailsController.text,
                                  OrderStatus: 'New Order',
                                  docImage: imagesPicked,
                                  DeliveryDate: deliveryDate.toString(),
                                  DeliveredDate: '',
                                  OrderDate: orderDate.toString(),
                                  CuttingDate: '',
                                  SewingDate: '',
                                  FinishedDat: '',
                                  CuttingAccount3ID: 0,
                                  SweingAccount3ID: 0,
                                  FinshedAccunt3ID: 0,
                                  CustomerName: nameOFPersonController.text,
                                  OrderTitle: orderTitleController.text,
                                  BillAmount: totalChargesController.text,
                                );

                                if (insert) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Insert Successfully')));

                                  await showDialogForPrintCash(
                                      context: context,
                                      onPressedOtherExp: () {
                                        showGeneralDialog(
                                          context: context,
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) {
                                            return AnimatedContainer(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              alignment: Alignment.center,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 410,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Material(
                                                      child: CashBookDialog(
                                                          mode: 'ADD',
                                                          ID: orderID
                                                              .toString(),
                                                          tableName: 'TS_Rec'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      onPressedBack: () {
                                        Navigator.pop(context);
                                      },
                                      onPressedCashRec: () async {
                                        showGeneralDialog(
                                          context: context,
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) {
                                            return AnimatedContainer(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              alignment: Alignment.center,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 410,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Material(
                                                      child: CashBookDialog(
                                                          mode: 'ADD',
                                                          ID: orderID
                                                              .toString(),
                                                          tableName: 'TS_Rec'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      onPressedPrintPreview: () async {
                                        List data = await getSingleTailorData(
                                            id: orderID.toString());


                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                PrintPage(data: data[0],)
                                            ));
                                      },
                                      onPressedPrint: () async {},
                                      onPressedWhatsApp: () async {

                                      });

                                  Navigator.pop(context);
                                }
                              } else {
                                await updateOrderTailorShop(
                                  CustomerMobileNo: mobileController.text,
                                  ID: widget.data!['ID'].toString(),
                                  BillAmount: totalChargesController.text,
                                  CustomerName: nameOFPersonController.text,
                                  DeliveryDate: deliveryDate.toString(),
                                  OBRemarks: sizeAndDetailsController.text,
                                  OrderDate: orderDate.toString(),
                                  OrderStatus: widget.data!['OrderStatus'],
                                  OrderTitle: orderTitleController.text,
                                );

                                Navigator.pop(context);
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Please fill all Fields'),
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                          child: Text('SAVE'))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
