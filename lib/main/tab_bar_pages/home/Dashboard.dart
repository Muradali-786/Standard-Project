import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:com/main/tab_bar_pages/home/DetailPage.dart';
import 'package:com/main/tab_bar_pages/home/DetailWidget.dart';
import 'package:com/main/tab_bar_pages/home/clientAccount_code_provider.dart';
import 'package:com/main/tab_bar_pages/home/home_page.dart';
import 'package:com/main/tab_bar_pages/home/home_page_code_provider.dart';
import 'package:com/pages/material/image_uploading.dart';
import 'package:com/main/tab_bar_pages/home/themedataclass.dart';
import 'package:com/pages/login/create_account_default_data_calling_provider.dart';
import 'package:com/pages/material/Toast.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:com/widgets/constants.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../Server/RefreshDataProvider.dart';
import '../../../Server/mysql_provider.dart';
import '../../../pages/login/firebase_mobile_no_auth_design.dart';
import '../../../pages/restaurant/ResturantRefreshing.dart';
import '../../../pages/school/refreshing.dart';
import '../../../utils/verify_phone_dialog.dart';
import '../chat/screen/chart_portion_tab.dart';

List<Contact> contacts = [];
List dbSavedUsers = [];

class ListWidget extends StatefulWidget {
  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  var isLargeScreen = false;
  String viewHomeAndChat = 'Home';
  Widget selectedValue = Container();
  int initialIndex = 0;
  final globalKey = GlobalKey<FormState>();

  SchServerRefreshing _schServerRefreshing = SchServerRefreshing();
  RestaurantRefreshing _refreshing = RestaurantRefreshing();

  CollectionReference country = FirebaseFirestore.instance.collection(
      'Country');


  TextEditingController previousPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      icon: Icon(
        Icons.more_horiz,
        size: 20,
        color: Colors.white,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('Edit Picture')),
          PopupMenuItem(value: 1, child: Text('Edit Name')),
          PopupMenuItem(value: 2, child: Text('Change Password')),
        ];
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 8),
      () {
        if (mounted) {
          SharedPreferencesKeys.prefs!
                      .getString(SharedPreferencesKeys.mobileNumber)
                      .toString()
                      .length >
                  4
              ? null
              : showDialog<String>(
                  context: (context),
                  builder: (context) => Center(
                    child: SizedBox(
                        height: 250,
                        width: 300,
                        child: PhoneNumberAuthForm(
                          status: 'Update',
                        )),
                  ),
                );
        }
      },
    );

    country.doc(
        '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
        .set( {
      'Country' : '${SharedPreferencesKeys.prefs!.getString('CountryName')}'
    }
    );


    country.doc(
        '${SharedPreferencesKeys.prefs!.getString('CountryName')}').collection('CountryUser').doc('${SharedPreferencesKeys.prefs!.getString(
        SharedPreferencesKeys.countryClientId)}').set(
        {
          'Country User ID' : '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}',
          'Name' : '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.nameOfPerson)}' ,
          'Mobile Number' : '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.mobileNumber)}'

        }

    );

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Consumer<ThemeDataHomePage>(
            builder: (context, value, child) => Scaffold(
              backgroundColor:
                  Provider.of<ThemeDataHomePage>(context, listen: false)
                      .backGroundColor,
              appBar: AppBar(
                leading: SharedPreferencesKeys.prefs!
                                .getInt(SharedPreferencesKeys.projectId) !=
                            0 ||
                        SharedPreferencesKeys.prefs!
                                .getInt(SharedPreferencesKeys.projectId) ==
                            null
                    ? Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            print('.......................................');
                            Scaffold.of(context).openDrawer();
                          },
                          child: CachedNetworkImage(
                            imageUrl: Provider.of<ThemeDataHomePage>(context,
                                    listen: false)
                                .projectIconURL,
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            imageBuilder: (context, imageProvider) => Container(
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
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/easysoft_logo.jpg',
                              alignment: Alignment.center,
                              height: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      })
                    : Builder(builder: (context) {
                        return InkWell(
                            onTap: () async {
                              Scaffold.of(context).openDrawer();

                            },
                            child: Icon(Icons.menu));
                      }),
                backgroundColor:
                    Provider.of<ThemeDataHomePage>(context, listen: false)
                        .borderTextAppBarColor,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                        onTap: () async {
                          if (SharedPreferencesKeys.prefs!
                                  .getInt(SharedPreferencesKeys.projectId) !=
                              0) {
                            if (await Provider.of<MySqlProvider>(context,
                                    listen: false)
                                .connectToServerDb()) {
                              Map list = await Provider.of<DashboardProvider>(
                                      context,
                                      listen: false)
                                  .getURLForYouTube(
                                      SharedPreferencesKeys.prefs!
                                          .getInt(
                                              SharedPreferencesKeys.projectId)
                                          .toString(),
                                      context);

                              Uri _url = Uri.parse(
                                list['ProjectVideo'],
                              );

                              await launchUrl(_url,
                                  mode: LaunchMode.externalApplication);
                            }
                          } else {
                            if (await Provider.of<MySqlProvider>(context,
                                    listen: false)
                                .connectToServerDb()) {
                              Map list = await Provider.of<DashboardProvider>(
                                      context,
                                      listen: false)
                                  .getURLForYouTube('1', context);

                              Uri _url = Uri.parse(
                                list['ProjectVideo'],
                              );

                              await launchUrl(_url,
                                  mode: LaunchMode.externalApplication);
                            }
                          }
                        },
                        child: Icon(Icons.play_arrow_rounded,
                            color: Colors.red, size: 45)),
                  ),
                  IconButton(
                    onPressed: () async {
                      if(SharedPreferencesKeys.prefs!
                          .getInt(SharedPreferencesKeys.projectId) ==
                          0) {
                        if (await Provider.of<MySqlProvider>(context,
                            listen: false)
                            .connectToServerDb()) {
                          Constants.onLoading(context, 'Getting  Client Data');
                          await Provider.of<RefreshDataProvider>(
                              context, listen: false)
                              .getClientDataFromServerToSqlite(context);
                          Constants.hideDialog(context);
                          setState(() {});
                        }
                      }else{
                        if (Provider.of<ThemeDataHomePage>(context,
                            listen: false)
                            .projectName ==
                            'School Management System') {

                          print('......................runing school..............................');
                          await _schServerRefreshing
                              .getAllUpdatedDataFromServer(
                            context,
                          );

                          await Provider.of<RefreshDataProvider>(context,
                              listen: false)
                              .getAllUpdatedDataFromServer(context, false);
                        } else {
                          await Provider.of<RefreshDataProvider>(context,
                              listen: false)
                              .getAllUpdatedDataFromServer(context, false);
                          await _refreshing
                              .getAllUpdatedDataFromServer(context);
                        }
                      }


                        setState(() {});



                    },
                    icon: Icon(Icons.cloud_upload_sharp),
                  ),
                ],
                title: Text(
                  Provider.of<ThemeDataHomePage>(context, listen: false)
                      .projectName,
                  maxLines: 2,
                ),
                // centerTitle: true,
              ),
              drawer: Drawer(
                child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.nameOfPerson) ??
                          "Not Available"),
                      currentAccountPicture: CircleAvatar(
                          minRadius: 45,
                          backgroundImage: NetworkImage(
                            'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/UserLogo/${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}',
                          )),
                      accountEmail: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(SharedPreferencesKeys.prefs!
                                  .getString(SharedPreferencesKeys.email) ??
                              ""),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onLongPress: () {
                                    Navigator.pushNamed(context, '/home_page');
                                  },
                                  child: SharedPreferencesKeys.prefs!
                                              .getString(SharedPreferencesKeys
                                                  .mobileNumber)
                                              .toString()
                                              .length >
                                          4
                                      ? Text(SharedPreferencesKeys.prefs!
                                          .getString(SharedPreferencesKeys
                                              .mobileNumber)
                                          .toString())
                                      : InkWell(
                                          onTap: () async {
                                            final bool? verifyPhoneNUmber =
                                                await showDialog<bool>(
                                              context: (context),
                                              builder: (context) => Center(
                                                  child: SizedBox(
                                                      height: 180,
                                                      child:
                                                          VerifyPhoneDialog())),
                                            );
                                            if (verifyPhoneNUmber!) {
                                              await showDialog<String>(
                                                context: (context),
                                                builder: (context) => Center(
                                                  child: SizedBox(
                                                      height: 250,
                                                      width: 300,
                                                      child:
                                                          PhoneNumberAuthForm(
                                                        status: 'Update',
                                                      )),
                                                ),
                                              );
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Update Mobile Number',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              )
                                            ],
                                          ),
                                        )),
                              SizedBox(
                                height: 20,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: popUpButtonForItemEdit(
                                        onSelected: (value) {
                                      if (value == 0) {
                                        imageUploadingToServer(
                                            mainContext: context,
                                            status: 'Update');
                                      }
                                      if (value == 2) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Center(
                                                child: Material(
                                                  child: SizedBox(
                                                    height: 350,
                                                    width: 300,
                                                    child: Form(
                                                      key: globalKey,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    'Change Password')),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 6.0),
                                                              child:
                                                                  TextFormField(
                                                                obscureText:
                                                                    true,
                                                                controller:
                                                                    previousPasswordController,
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                      .isEmpty) {
                                                                    return 'required';
                                                                  } else {
                                                                    return null;
                                                                  }
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(),
                                                                        fillColor:
                                                                            Colors
                                                                                .white,
                                                                        filled:
                                                                            true,
                                                                        label:
                                                                            Text(
                                                                          'Old Password',
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        )),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                              child:
                                                                  TextFormField(
                                                                obscureText:
                                                                    true,
                                                                controller:
                                                                    newPasswordController,
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                      .isEmpty) {
                                                                    return 'required';
                                                                  } else {
                                                                    return null;
                                                                  }
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(),
                                                                        fillColor:
                                                                            Colors
                                                                                .white,
                                                                        filled:
                                                                            true,
                                                                        label:
                                                                            Text(
                                                                          'New Password',
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        )),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 6.0),
                                                              child:
                                                                  TextFormField(
                                                                obscureText:
                                                                    true,
                                                                controller:
                                                                    confirmPasswordController,
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                      .isEmpty) {
                                                                    return 'required';
                                                                  } else {
                                                                    if (value ==
                                                                        newPasswordController
                                                                            .text
                                                                            .toString()) {
                                                                      return null;
                                                                    } else {
                                                                      return 'Confirm Password is Not Matching';
                                                                    }
                                                                  }
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(),
                                                                        fillColor:
                                                                            Colors
                                                                                .white,
                                                                        filled:
                                                                            true,
                                                                        label:
                                                                            Text(
                                                                          'Confirm Password',
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        )),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          10.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Container(
                                                                    height: 30,
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors.green,
                                                                            foregroundColor: Colors.white,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                            ) // foreground
                                                                            ),
                                                                        onPressed: () {
                                                                          if (globalKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            Provider.of<ClientAccountProvider>(context, listen: false).updatePasswordFromServer(
                                                                                confirmPasswordController.text.toString(),
                                                                                previousPasswordController.text.toString().trim(),
                                                                                SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)!,
                                                                                SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString(),
                                                                                context);
                                                                          }
                                                                        },
                                                                        child: Text('Change Password')),
                                                                  ),
                                                                  Container(
                                                                    height: 30,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3,
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors.blue,
                                                                            foregroundColor: Colors.white,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                            ) // foreground
                                                                            ),
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                          'Cancel',
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    })),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      subtitle: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.currencySign)} 0.0 ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16),
                        ),
                      ),
                      leading: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.orange,
                      ),
                      title: Text("Account Balance"),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Material(
                                  child: SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Not Started',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.credit_card,
                        color: Colors.green,
                      ),
                      title: Text("Recharge"),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Material(
                                  child: SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Not Started',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        CupertinoIcons.arrow_left_right,
                        color: Colors.blue,
                      ),
                      title: Text("Transfer"),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Material(
                                  child: SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Not Started',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.library_books_sharp),
                      title: Text("View Statement"),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Material(
                                  child: SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Not Started',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                      title: Text("WhatsApp Support"),
                      onTap: () async {
                        //923138934156
                        await launchUrlString(
                            "whatsapp://send?phone=${'+923225313995'}&text=${'I need support'}");
                        // Uri uri = Uri.parse('https://wa.me/923138934156?vtext=I%27m interested in your car for sale');
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.policy,
                        color: Colors.green,
                      ),
                      title: Text("Terms and Policy"),
                      onTap: () async {
                        Uri uri = Uri.parse(
                            'https://easysoftapp.com/PrivacyPolicy/PrivacyPolicies.htm');
                        await launchUrl(uri);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: Text("LogOut"),
                      onTap: () async {
                        bool isClear =
                            await SharedPreferencesKeys.prefs!.clear();
                        if (isClear) {
                          try {
                            Constants.onLoading(context, 'we will logout you');

                            if (!Platform.isWindows) {
                              await GoogleSignIn().signOut();
                            }

                            await Provider.of<DatabaseProvider>(context,
                                    listen: false)
                                .init();

                            await Provider.of<SplashDataProvider>(context,
                                    listen: false)
                                .callSplashApis(context);

                            Constants.hideDialog(context);
                            Navigator.pushNamed(
                                context, '/login_selection_page');
                          } catch (e) {}
                        } else {
                          Toast.buildErrorSnackBar("Unable to logout");
                        }
                      },
                    ),
                  ],
                ),
              ),
              body: StatefulBuilder(
                builder: (context, setState) => OrientationBuilder(
                  builder: (BuildContext context, orientation) {
                    if (MediaQuery.of(context).size.width > 600) {
                      isLargeScreen = true;
                    } else {
                      isLargeScreen = false;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DefaultTabController(
                              length: 2,
                              child: Builder(
                                builder: (BuildContext context) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          /// home menu button ............................
                                          Flexible(
                                            flex: 5,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: viewHomeAndChat ==
                                                                  'Home'
                                                              ? Provider.of<
                                                                          ThemeDataHomePage>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .borderTextAppBarColor
                                                              : Provider.of<
                                                                          ThemeDataHomePage>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .backGroundColor))),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      viewHomeAndChat = 'Home';
                                                      setState(() {
                                                        selectedValue =
                                                            Container();
                                                      });

                                                      //callsColor = Colors.black;
                                                      if (SharedPreferencesKeys
                                                              .prefs!
                                                              .get(SharedPreferencesKeys
                                                                  .projectId) ==
                                                          0) {
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .setInt(
                                                                SharedPreferencesKeys
                                                                    .projectId,
                                                                0);
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .setString(
                                                                SharedPreferencesKeys
                                                                    .countryUserId,
                                                                '0');
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .setString(
                                                                SharedPreferencesKeys
                                                                    .countryUserId2,
                                                                '0');
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .remove(
                                                                'SingleView');
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .setInt(
                                                                SharedPreferencesKeys
                                                                    .clinetId,
                                                                0);
                                                        Provider.of<ThemeDataHomePage>(
                                                                    context,
                                                                    listen: false)
                                                                .borderTextAppBarColor =
                                                            Colors.blue;

                                                        Provider.of<ThemeDataHomePage>(
                                                                    context,
                                                                    listen: false)
                                                                .backGroundColor =
                                                            Colors.white;

                                                        Provider.of<ThemeDataHomePage>(
                                                                    context,
                                                                    listen: false)
                                                                .projectName =
                                                            'EasySoft';
                                                        Provider.of<ThemeDataHomePage>(
                                                                context,
                                                                listen: false)
                                                            .projectIconURL = '';
                                                      } else if (DefaultTabController
                                                                  .of(context)
                                                              .index ==
                                                          0) {
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .setInt(
                                                                SharedPreferencesKeys
                                                                    .projectId,
                                                                0);
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .setString(
                                                                SharedPreferencesKeys
                                                                    .countryUserId,
                                                                '0');
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .setString(
                                                                SharedPreferencesKeys
                                                                    .countryUserId2,
                                                                '0');
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .remove(
                                                                'SingleView');
                                                        SharedPreferencesKeys
                                                            .prefs!
                                                            .setInt(
                                                                SharedPreferencesKeys
                                                                    .clinetId,
                                                                0);
                                                        Provider.of<ThemeDataHomePage>(
                                                                    context,
                                                                    listen: false)
                                                                .borderTextAppBarColor =
                                                            Colors.blue;

                                                        Provider.of<ThemeDataHomePage>(
                                                                    context,
                                                                    listen: false)
                                                                .backGroundColor =
                                                            Colors.white;

                                                        Provider.of<ThemeDataHomePage>(
                                                                    context,
                                                                    listen: false)
                                                                .projectName =
                                                            'EasySoft';
                                                        Provider.of<ThemeDataHomePage>(
                                                                context,
                                                                listen: false)
                                                            .projectIconURL = '';
                                                      }
                                                    },
                                                  );
                                                  DefaultTabController.of(
                                                          context)
                                                      .animateTo(0);
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.home,
                                                        color: Provider.of<
                                                                    ThemeDataHomePage>(
                                                                context,
                                                                listen: false)
                                                            .borderTextAppBarColor),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Home',
                                                      style: TextStyle(
                                                        color: Provider.of<
                                                                    ThemeDataHomePage>(
                                                                context,
                                                                listen: false)
                                                            .borderTextAppBarColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          /// chart  button ............................
                                          Flexible(
                                            flex: 5,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: viewHomeAndChat ==
                                                                  'Chart'
                                                              ? Provider.of<
                                                                          ThemeDataHomePage>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .borderTextAppBarColor
                                                              : Provider.of<
                                                                          ThemeDataHomePage>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .backGroundColor))),
                                              child: InkWell(
                                                onTap: () async {
                                                  if (!Platform.isWindows) {
                                                    DefaultTabController.of(
                                                            context)
                                                        .animateTo(1);

                                                    if (SharedPreferencesKeys
                                                            .prefs!
                                                            .get(SharedPreferencesKeys
                                                                .mobileNumber) !=
                                                        null) {
                                                      FirebaseMessaging
                                                          messaging =
                                                          FirebaseMessaging
                                                              .instance;
                                                      messaging
                                                          .getToken()
                                                          .then((value) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("chats")
                                                            .doc(SharedPreferencesKeys
                                                                .prefs!
                                                                .getString(
                                                                    SharedPreferencesKeys
                                                                        .mobileNumber))
                                                            .set({
                                                          'deviceToken':
                                                              value.toString(),
                                                          "name": SharedPreferencesKeys
                                                              .prefs!
                                                              .getString(
                                                                  SharedPreferencesKeys
                                                                      .nameOfPerson),
                                                          "number": SharedPreferencesKeys
                                                              .prefs!
                                                              .getString(
                                                                  SharedPreferencesKeys
                                                                      .mobileNumber),
                                                          "statusOnline": true,
                                                          "lastSeen":
                                                              DateTime.now(),
                                                        });
                                                      });

                                                      setState(
                                                        () {
                                                          viewHomeAndChat =
                                                              'Chart';
                                                        },
                                                      );

                                                      if (contacts.length ==
                                                          0) {
                                                        await fetchContacts(
                                                            context, setState);
                                                      }
                                                    } else {
                                                      final bool?
                                                          verifyPhoneNUmber =
                                                          await showDialog<
                                                              bool>(
                                                        context: (context),
                                                        builder: (context) =>
                                                            Center(
                                                                child: SizedBox(
                                                                    height: 180,
                                                                    child:
                                                                        VerifyPhoneDialog())),
                                                      );
                                                      if (verifyPhoneNUmber!) {
                                                        await showDialog<
                                                            String>(
                                                          context: (context),
                                                          builder: (context) =>
                                                              Center(
                                                            child: SizedBox(
                                                                height: 250,
                                                                width: 300,
                                                                child:
                                                                    PhoneNumberAuthForm(
                                                                  status:
                                                                      'Update',
                                                                )),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    noAvailableFeature(context);
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    Icon(Icons.chat,
                                                        color: Provider.of<
                                                                    ThemeDataHomePage>(
                                                                context,
                                                                listen: false)
                                                            .borderTextAppBarColor),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Chat',
                                                      style: TextStyle(
                                                        color: Provider.of<
                                                                    ThemeDataHomePage>(
                                                                context,
                                                                listen: false)
                                                            .borderTextAppBarColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Expanded(
                                        child: TabBarView(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: [
                                              /// main home page ......................................
                                              DashboardHomePage(
                                                onItemSelected: (value) {
                                                  if (MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600) {
                                                    selectedValue = value;
                                                    setState(() {});
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return DetailPage(
                                                              selectedValue);
                                                        },
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),

                                              /// chart  page ......................................
                                              ChatsScreen(
                                                  contacts: contacts,
                                                  dbUser: dbSavedUsers),
                                              // /// call  page ......................................
                                              // CallPage(),
                                            ]),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          isLargeScreen
                              ? Expanded(
                                  flex: 7,
                                  child: Container(
                                    child: DetailWidget(selectedValue),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  fetchContacts(BuildContext buildContext, var state) async {
    if (!await Permission.contacts.isGranted) {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        color: Colors.blue,
                        child: Center(
                          child: Icon(
                            Icons.contacts,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                                'To use this chat Feature for communicate with relatives!\nPlease allow us to access contacts'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      state(() {
                                        viewHomeAndChat = 'Home';
                                      });

                                      DefaultTabController.of(buildContext)
                                          .animateTo(0);

                                      Navigator.pop(context);
                                    },
                                    child: Text('NOT NOW')),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      var status =
                                          await Permission.contacts.request();

                                      if (status.isGranted) {
                                        contacts =
                                            await FlutterContacts.getContacts(
                                                withProperties: true,
                                                withPhoto: true);

                                        await fetchDBUsers();
                                        setState(() {});
                                      } else {
                                        state(() {
                                          viewHomeAndChat = 'Home';
                                        });

                                        DefaultTabController.of(buildContext)
                                            .animateTo(0);
                                      }
                                    },
                                    child: Text('CONTINUE')),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      await fetchDBUsers();
      setState(() {});
    }
  }

  fetchDBUsers() {
    FirebaseFirestore.instance.collection('chats').snapshots().listen((event) {
      event.docs.forEach((element) {
        dbSavedUsers.add(element.id);
      });
    });
  }
}
