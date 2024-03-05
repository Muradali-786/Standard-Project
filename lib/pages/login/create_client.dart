
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:com/Server/RefreshDataProvider.dart';
import 'package:com/Server/create_client.dart';
import 'package:com/pages/material/image_uploading.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:provider/provider.dart';
import '../../main/tab_bar_pages/home/Dashboard.dart';
import '../../main/tab_bar_pages/home/home_page.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import '../../main/tab_bar_pages/home/themedataclassforproject.dart';
import '../material/get_current_location_from_map.dart';


class CreateClient extends StatefulWidget {
  final int projectId;
  final String projectName;
  final String status;
  final List listOFClient;

  CreateClient(
      {Key? key,
      required this.projectId,
      required this.listOFClient,
      required this.status,
      required this.projectName})
      : super(key: key);

  @override
  _CreateClientState createState() => _CreateClientState();
}

class _CreateClientState extends State<CreateClient> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController businessDescriptionsController =
      TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController companyNumberController = TextEditingController();
  TextEditingController nameOfPersonController = TextEditingController();
  TextEditingController loginMobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController passwordController = TextEditingController(text: "123");
  TextEditingController netCodeController = TextEditingController();
  TextEditingController sysCodeCodeController = TextEditingController();
  TextEditingController longLatController = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  CollectionReference country = FirebaseFirestore.instance.collection(
      'Country');

  String? query;
  String? imageURL;
  File? _image;
  String? imageBase64;

  @override
  void initState() {
    super.initState();
    print('/////////////whole list//////////${widget.listOFClient}');
    if (widget.status == 'EDIT') {
      print('/////////////whole list//////////${widget.listOFClient.length}');
      companyNameController.text =
          widget.listOFClient[0]['CompanyName'].toString();
      businessDescriptionsController.text =
          widget.listOFClient[0]['BusinessDescriptions'].toString();
      companyAddressController.text =
          widget.listOFClient[0]['CompanyAddress'].toString();
      companyNumberController.text =
          widget.listOFClient[0]['CompanyNumber'].toString();
      nameOfPersonController.text =
          widget.listOFClient[0]['NameOfPerson'].toString();
      websiteController.text = widget.listOFClient[0]['WebSite'].toString();
      facebookController.text = widget.listOFClient[0]['Facebook'].toString();
      longLatController.text = widget.listOFClient[0]['Lng'].toString();

      imageURL =
          'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${widget.listOFClient[0]['ClientID']}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeDataHomePageForProject>(context, listen: false)
              .backGroundColor,
      appBar: AppBar(
          backgroundColor:
              Provider.of<ThemeDataHomePageForProject>(context, listen: false)
                  .borderTextAppBarColor,
          title: widget.status == 'ADD'
              ? Text(
                  "Account Creating in ${widget.projectName}",
                  maxLines: 2,
                )
              : Text('Update Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: globalKey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        _image = await imageUploadingToServer(
                            mainContext: context, status: 'Profile');

                        if(_image != null){
                          imageBase64 = base64Encode(_image!.readAsBytesSync());
                        }


                        imageURL = '';
                        setState(() {});
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        child: widget.status == 'ADD'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: (_image == null)
                                    ? Container(
                                        color: Colors.blue,
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 30,
                                        ))
                                    : Image.file(
                                        _image!,
                                        fit: BoxFit.fill,
                                      ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: imageURL!,
                                  alignment: Alignment.center,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      (_image == null)
                                          ? Container(
                                              color: Colors.blue,
                                              child: Icon(
                                                Icons.add_a_photo,
                                                size: 30,
                                              ))
                                          : Image.file(
                                              _image!,
                                              fit: BoxFit.fill,
                                            ),
                                ),
                                //Image(image: NetworkImage(),)
                                //Image.network()
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextFormField(
                      validator: (value) {
                        if (companyNameController.text.isEmpty) {
                          return 'Required';
                        } else {
                          return null;
                        }
                      },
                      controller: companyNameController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text(
                            "Business Name",
                            style: TextStyle(color: Colors.black),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextField(
                      controller: businessDescriptionsController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text(
                            "Business Description",
                            style: TextStyle(color: Colors.black),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextField(
                      controller: companyAddressController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text(
                            "Company Address",
                            style: TextStyle(color: Colors.black),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextFormField(
                      controller: longLatController,
                      readOnly: true,
                      validator: (value) {
                        if (longLatController.text.isEmpty) {
                          return 'Required';
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {

                        List location = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GetCurrentLocation(),
                            ));

                        if (location.isNotEmpty) {
                          longLatController.text =
                          '${location[0]},${location[1]}';
                        }

                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          suffix: Icon(Icons.location_on_outlined),
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text(
                            "Map Location",
                            style: TextStyle(color: Colors.black),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextFormField(
                      controller: companyNumberController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text(
                            "Company Number",
                            style: TextStyle(color: Colors.black),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextFormField(
                      validator: (value) {
                        if (nameOfPersonController.text.isEmpty) {
                          return 'Required';
                        } else {
                          return null;
                        }
                      },
                      controller: nameOfPersonController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text(
                            "Person Name",
                            style: TextStyle(color: Colors.black),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextField(
                      controller: websiteController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text(
                            "WebSite",
                            style: TextStyle(color: Colors.black),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextField(
                      controller: facebookController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text(
                            "Facebook",
                            style: TextStyle(color: Colors.black),
                          ))),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ) // foreground
                                ),
                            onPressed: () async {
                              if (globalKey.currentState!.validate()) {
                                if (_image != null  || imageURL  != null) {
                                  if (widget.status == 'ADD') {

                                    Constants.onLoading(context, 'Client Creating........');

                                    if(imageBase64 != null) {
                                      int clientID =
                                      await Provider.of<CreateClientProvider>(
                                          context,
                                          listen: false)
                                          .clientID(context);

                                      await Provider.of<CreateClientProvider>(
                                          context,
                                          listen: false)
                                          .onPressedUploadToServer(
                                          imageBase64!, context);

                                      await Provider.of<CreateClientProvider>(
                                          context,
                                          listen: false)
                                          .createClient(
                                        facebookController.text.toString(),
                                        longLatController.text.toString(),
                                        netCodeController.text,
                                        sysCodeCodeController.text,
                                        companyNameController.text,
                                        companyAddressController.text,
                                        companyNumberController.text,
                                        nameOfPersonController.text,
                                        SharedPreferencesKeys.prefs!
                                            .getString(SharedPreferencesKeys
                                            .mobileNumber)
                                            .toString(),
                                        SharedPreferencesKeys.prefs!
                                            .getString(
                                            SharedPreferencesKeys.email)
                                            .toString(),
                                        'Pakistan',
                                        passwordController.text,
                                        'Karachi',
                                        'Saddar',
                                        websiteController.text,
                                        '5',
                                        '',
                                        '',
                                        '0',
                                        widget.projectId.toString(),
                                        businessDescriptionsController.text,
                                        '2021',
                                        SharedPreferencesKeys.prefs!
                                            .getString(SharedPreferencesKeys
                                            .countryUserId)
                                            .toString(),
                                        SharedPreferencesKeys.prefs!
                                            .getString(SharedPreferencesKeys
                                            .countryClientId)
                                            .toString(),
                                        context,
                                      );

                                      Constants.hideDialog(context);

                                      await Provider.of<RefreshDataProvider>(
                                          context,
                                          listen: false)
                                          .getAllUpdatedDataFromServer(
                                          context, true);


                                      var clientInfo =
                                      await Provider.of<CreateClientProvider>(
                                          context,
                                          listen: false)
                                          .getClientTableById(
                                          clientID.toString());

                                      print(
                                          '..........................................$clientID......... ${clientInfo}.............');

                                      Provider
                                          .of<ThemeDataHomePage>(context,
                                          listen: false)
                                          .projectIconURL =
                                      'https://www.api.easysoftapp.com/PhpApi1/ProjectImages/ProjectsLogo/${widget
                                          .projectId}.png';

                                      Provider
                                          .of<ThemeDataHomePage>(context,
                                          listen: false)
                                          .projectName = widget.projectName;

                                      await SharedPreferencesKeys.prefs!
                                        ..setString('SingleView',
                                            'SingleView')..setString(
                                            SharedPreferencesKeys.companyName,
                                            companyNameController.text
                                                .toString())..setString(
                                            SharedPreferencesKeys
                                                .companyAddress,
                                            companyAddressController.text
                                                .toString())..setString(
                                            SharedPreferencesKeys.companyNumber,
                                            companyNumberController.text
                                                .toString())..setString(
                                            SharedPreferencesKeys.website,
                                            websiteController.text
                                                .toString())..setString(
                                            SharedPreferencesKeys
                                                .nameOfPersonOwner,
                                            nameOfPersonController.text
                                                .toString())..setString(
                                            SharedPreferencesKeys
                                                .bussinessDescription,
                                            businessDescriptionsController.text
                                                .toString())
                                        ..setInt(
                                            SharedPreferencesKeys.projectId,
                                            widget.projectId)..setInt(
                                            SharedPreferencesKeys.clinetId,
                                            clientInfo[0]['ClientID'])..setInt(
                                            SharedPreferencesKeys.clientUserId,
                                            clientInfo[0]['ClientUserID'])
                                        ..setString(
                                            SharedPreferencesKeys
                                                .countryClientID2,
                                            clientInfo[0]['CountryClientID'])..setString(
                                            SharedPreferencesKeys
                                                .countryUserId2,
                                            clientInfo[0]['CountryUserID'])..setString(
                                            SharedPreferencesKeys
                                                .userRightsClient,
                                            clientInfo[0]['UserRights'] ??
                                                'N/A')..setString(
                                            'UserName',
                                            nameOfPersonController.text
                                                .toString());

                                      await themeColorDataPickerForProjectMenu(
                                          context);


                                      country.doc(
                                          '${SharedPreferencesKeys.prefs!.getString('CountryName')}').collection('CountryUser').doc('${SharedPreferencesKeys.prefs!.getString(
                                          SharedPreferencesKeys.countryClientId)}').collection('Client').doc('${SharedPreferencesKeys.prefs!.getInt(
                                          SharedPreferencesKeys.clinetId).toString()}').set({

                                        'Company Name' : '${SharedPreferencesKeys.prefs!.getString(
                                            SharedPreferencesKeys.companyName)}',
                                        'Company Address' : '${SharedPreferencesKeys.prefs!.getString(
                                            SharedPreferencesKeys.companyAddress)}',
                                        'Company Number' : '${SharedPreferencesKeys.prefs!.getString(
                                            SharedPreferencesKeys.companyNumber)}',
                                        'Company Description' : '${SharedPreferencesKeys.prefs!.getString(
                                            SharedPreferencesKeys.bussinessDescription)}',

                                      });

                                      country.doc(
                                          '${SharedPreferencesKeys.prefs!.getString('CountryName')}').collection('CountryUser').doc('${SharedPreferencesKeys.prefs!.getString(
                                          SharedPreferencesKeys.countryClientId)}').collection('Client').doc('${SharedPreferencesKeys.prefs!.getInt(
                                          SharedPreferencesKeys.clinetId).toString()}').collection('ClientUser').doc('${SharedPreferencesKeys.prefs!.getInt(
                                          SharedPreferencesKeys.clientUserId
                                      )}').set(
                                          {

                                            'Client User Name' : '${SharedPreferencesKeys.prefs!.getString(
                                                SharedPreferencesKeys.nameOfPersonOwner)}',
                                            'Mobile number' : '${SharedPreferencesKeys.prefs!.getString(
                                                SharedPreferencesKeys.mobileNumber)}',

                                            'User Right' : '${SharedPreferencesKeys.prefs!.getString(
                                                SharedPreferencesKeys.userRightsClient)}',
                                          }
                                      );

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListWidget()));

                                      print(
                                          '..................created account........................');
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Select image!!'), backgroundColor: Colors.red,));
                                    }
                                  } else {

                                    if(imageBase64 != null) {
                                      await Provider.of<CreateClientProvider>(
                                          context,
                                          listen: false)
                                          .updateOnPressedUploadToServer(
                                          imageBase64!,
                                          context,
                                          widget.listOFClient[0]['ClientID']);
                                    }

                                    await Provider.of<CreateClientProvider>(
                                            context,
                                            listen: false)
                                        .getClientDataFromServerToSqlite(
                                            context);

                                    await Provider.of<
                                                CreateClientProvider>(
                                            context,
                                            listen: false)
                                        .updateClient(
                                            facebook:
                                                facebookController
                                                    .text
                                                    .toString(),
                                            longLat:
                                                longLatController
                                                    .text
                                                    .toString(),
                                            companyName:
                                                companyNameController
                                                    .text
                                                    .toString(),
                                            companyAddress:
                                                companyAddressController
                                                    .text
                                                    .toString(),
                                            companyNumber:
                                                companyNumberController
                                                    .text
                                                    .toString(),
                                            nameOfPerson:
                                                nameOfPersonController
                                                    .text
                                                    .toString(),
                                            website: websiteController.text
                                                .toString(),
                                            clientID: widget.listOFClient[0]
                                                    ['ClientID']
                                                .toString(),
                                            businessDescriptions:
                                                businessDescriptionsController
                                                    .text
                                                    .toString(),
                                            financialYear: '2021',
                                            context: context);

                                    await Provider.of<RefreshDataProvider>(
                                            context,
                                            listen: false)
                                        .getAllUpdatedDataFromServer(
                                            context, true);
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Message"),
                                        content: Text('Please Select Image'),
                                        actions: [
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: widget.status == 'ADD'
                                ? Text(
                                    "Register",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Update",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ) // foreground
                                ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // static void navigateTo(double lat, double lng) async {
  //   var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  //   if (await canLaunch(uri.toString())) {
  //     await launch(uri.toString());
  //   } else {
  //     throw 'Could not launch ${uri.toString()}';
  //   }
  // }
  // clientCreateApi() async {
  //   // ignore: await_only_futures
  //   Uri url = await Uri.parse(
  //       '${ApiConstants.baseUrl}${ApiConstants.clientCreateApiUrl}');
  //   try {
  //     final response = await http.post(url, body: {
  //       'NetCode': netCodeController.text,
  //       'SysCode': sysCodeCodeController.text,
  //       'CompanyName': companyNameController.text,
  //       'CompanyAddress': companyAddressController.text,
  //       'CompanyNumber': companyNumberController.text,
  //       'CompanyName': companyNameController.text,
  //       'CompanyAddress': companyAddressController.text,
  //       'CompanyNumber': companyNumberController.text,
  //       'NameOfPerson': nameOfPersonController.text,
  //       'LoginMobileNo': SharedPreferencesKeys.prefs!
  //           .getString(SharedPreferencesKeys.mobileNumber),
  //       'Email':
  //           SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.email),
  //       'Country': 'Pakistan',
  //       'Password': passwordController.text,
  //       'City': 'Karachi',
  //       'SubCity': 'Sadar',
  //       'Website': websiteController.text,
  //       'CapacityOfPersons': '5',
  //       'CompanyLogo': 'da',
  //       'DisplayImage': 'das',
  //       'Lat': '0.0',
  //       'Lng': '0.0',
  //       'ProjectID': '2',
  //       'BusinessDescriptions': businessDescriptionsController.text,
  //       'FinancialYear': '2021',
  //       'CountryUserID': SharedPreferencesKeys.prefs!
  //           .getString(SharedPreferencesKeys.countryUserId),
  //       'CountryClientID': SharedPreferencesKeys.prefs!
  //           .getString(SharedPreferencesKeys.countryClientId),
  //     });
  //     print(response.body);
  //     setState(() {
  //       query = response.body;
  //     });
  //   } on Exception catch (e, stkTrace) {
  //     print(e);
  //     print(stkTrace);
  //   }
  // }
}
