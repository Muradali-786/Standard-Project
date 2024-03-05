import 'package:com/main/tab_bar_pages/home/themedataclass.dart';
import 'package:com/pages/beauty_salon/beauty_salon_main_dashboard.dart';
import 'package:com/pages/beauty_salon/token_main_screen.dart';
import 'package:com/pages/general_trading/Accounts/DefalutAccountPage.dart';
import 'package:com/pages/general_trading/CashBook/DefaultCashBookPage.dart';
import 'package:com/pages/general_trading/Items/DefaultItemsPage.dart';
import 'package:com/pages/general_trading/SalePur/DefaultSalePur1.dart';
import 'package:com/pages/marriage_hall_booking/marriage_hall_main_page.dart';
import 'package:com/pages/patient_care_system/doctor_screens/doctor_dashboard_screen.dart';
import 'package:com/pages/patient_care_system/price_list_screen/price_list_main_screen.dart';
import 'package:com/pages/restaurant/DefaultTableService.dart';
import 'package:com/pages/restaurant/Items/DefaultItemsPage.dart';
import 'package:com/pages/restaurant/SalePur/DefaultSalePur1.dart';
import 'package:com/pages/restaurant/SalePur/SalePur2AddItemBySelection.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/pages/tailor_shop_systom/all_orders_page.dart';
import 'package:com/pages/testing/table_testing_widget.dart';
import 'package:flutter/material.dart';
import 'package:com/config/screen_config.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Server/RefreshDataProvider.dart';
import '../../Server/mysql_provider.dart';
import '../../main/tab_bar_pages/home/home_page.dart';
import '../../main/tab_bar_pages/home/home_page_code_provider.dart';

import '../beauty_salon/beautician_main_screen.dart';
import '../beauty_salon/refreshing_beauty_salon.dart';
import '../beauty_salon/service_price_list.dart';
import '../general_trading/SalePur/sale_pur1_SQL.dart';
import '../general_trading/SalePurNewDesign/defualt_sale_purchase2.dart';
import '../marriage_hall_booking/refreshing_marriage_hall.dart';
import '../patient_care_system/patient_screens/patient_dashboard_screen.dart';
import '../patient_care_system/refeshing_patient_care_system.dart';
import '../restaurant/ResturantRefreshing.dart';
import '../school/DafaultSchoolPage.dart';
import '../school/FeeCollection.dart';
import '../school/defaultStudentPage.dart';
import '../school/refreshing.dart';
import '../tailor_shop_systom/refreshing_tailor_shop.dart';

class SubMenuPage extends StatefulWidget {
  final ItemSelectedCallback? onItemSelected;
  final String menuName;
  final String pageOpen;
  final String valuePass;
  final int? salePurID;

  const SubMenuPage({
    Key? key,
    this.onItemSelected,
    this.salePurID,
    required this.menuName,
    required this.pageOpen,
    required this.valuePass,
  }) : super(key: key);

  @override
  _SubMenuPageState createState() => _SubMenuPageState();
}

class _SubMenuPageState extends State<SubMenuPage> {
  bool isQueryGet = false;
  SchServerRefreshing _schServerRefreshing = SchServerRefreshing();
  RestaurantRefreshing _refreshing = RestaurantRefreshing();
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();
  RefreshingBeautySalon refreshingBeautySalon = RefreshingBeautySalon();
  RefreshingMarriageHall refreshingMarriageHall = RefreshingMarriageHall();
  RefreshingPatientCareSystem refreshingPatientCareSystem =
      RefreshingPatientCareSystem();
  RefreshingTailorShop refreshingTailorShop = RefreshingTailorShop();
  DateTime currentDate = DateTime.now();
  String? query;
  var salePur1ID;
  String clientId = SharedPreferencesKeys.prefs!
      .getInt(SharedPreferencesKeys.clinetId)!
      .toString();
  String date2 = '';
  String? editPageRoute;

  @override
  void initState() {
    super.initState();
    print(
        '////////////////////////////${widget.pageOpen}///////////////////////////////////////////');
    print(widget.menuName);
    print(widget.onItemSelected);
  }

  @override
  Widget build(BuildContext context) {
    //  _refreshing.getAllUpdatedDataFromServer(context);

    ScreenConfig().init(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Scaffold(
              backgroundColor:
                  Provider.of<ThemeDataHomePage>(context, listen: false)
                      .backGroundColor,
              appBar: AppBar(
                backgroundColor:
                    Provider.of<ThemeDataHomePage>(context, listen: false)
                        .borderTextAppBarColor,
                title: Text("${widget.menuName}"),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                        onTap: () async {
                          print('............................slis');
                          Map list = await Provider.of<DashboardProvider>(
                                  context,
                                  listen: false)
                              .getURLForYouTubeForMenuName(
                                  widget.menuName, context);

                          print(list['ProjectMenuVideo']);

                          if (list.length > 0) {
                            Uri _url = Uri.parse(list['ProjectMenuVideo']);

                            await launchUrl(_url,
                                mode: LaunchMode.externalApplication);
                          }

                          print('..................$list');
                        },
                        child: Icon(Icons.play_arrow_rounded,
                            color: Colors.red, size: 35)),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (await Provider.of<MySqlProvider>(context,
                              listen: false)
                          .connectToServerDb()) {
                        if (Provider.of<ThemeDataHomePage>(context,
                                    listen: false)
                                .projectName ==
                            'School Management System') {
                          await _schServerRefreshing
                              .getAllUpdatedDataFromServer(
                            context,
                          );

                          await Provider.of<RefreshDataProvider>(context,
                                  listen: false)
                              .getAllUpdatedDataFromServer(context, false);
                        } else if (Provider.of<ThemeDataHomePage>(context,
                                    listen: false)
                                .projectName ==
                            'Beauty Salon') {
                          await refreshingBeautySalon
                              .getAllUpdatedDataFromServer(context);

                          await Provider.of<RefreshDataProvider>(context,
                                  listen: false)
                              .getAllUpdatedDataFromServer(context, false);
                        } else if (Provider.of<ThemeDataHomePage>(context,
                                    listen: false)
                                .projectName ==
                            'Marriage Hall Booking') {
                          refreshingMarriageHall
                              .getAllUpdatedDataFromServer(context);

                          await Provider.of<RefreshDataProvider>(context,
                                  listen: false)
                              .getAllUpdatedDataFromServer(context, false);
                        } else if (Provider.of<ThemeDataHomePage>(context,
                                    listen: false)
                                .projectName ==
                            'Patient Care System') {
                          refreshingPatientCareSystem
                              .getAllUpdatedDataFromServer(context);

                          // await Provider.of<RefreshDataProvider>(context,
                          //         listen: false)
                          //     .getAllUpdatedDataFromServer(context, false);
                        } else if (Provider.of<ThemeDataHomePage>(context,
                                    listen: false)
                                .projectName ==
                            'Tailor Shop ') {
                          refreshingTailorShop
                              .getAllUpdatedDataFromServer(context);

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
                        setState(() {});
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(
                                'Unable to connect to server please try again later'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'))
                            ],
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.cloud_upload_sharp),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _salePurSQLDataBase
                          .userRightsChecking(widget.menuName),
                      builder: (context, AsyncSnapshot<List> snapshot) {
                        if (snapshot.hasData) {
                          print(
                              '/////////////////////////////........${snapshot.data}........fff//////////////////////');
                          if (SharedPreferencesKeys.prefs!.getString(
                                      SharedPreferencesKeys.userRightsClient) ==
                                  'Admin' ||
                              (SharedPreferencesKeys.prefs!.getString(
                                          SharedPreferencesKeys
                                              .userRightsClient) ==
                                      'Custom Right' &&
                                  snapshot.data![0]['Reporting'] == 'true')) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Provider.of<ThemeDataHomePage>(context,
                                          listen: false)
                                      .borderTextAppBarColor,
                                )),
                                child: FutureBuilder<List>(
                                  future: rowCourtQuery(widget.menuName),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.length > 0) {
                                      return Row(
                                        children: [
                                          /////////////
                                          //Row Design
                                          ////////////
                                          Flexible(
                                            flex: 9,
                                            child: FutureBuilder<List>(
                                                future: rowCourtQuery(
                                                    widget.menuName),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    List list = List.from(
                                                        snapshot.data!);
                                                    return SizedBox(
                                                      height: ScreenConfig
                                                              .blockHeight *
                                                          5,
                                                      width: ScreenConfig
                                                          .safeWidth,
                                                      child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              list.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            Map map =
                                                                list[index];
                                                            return Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      elevation: 6,
                                                                      backgroundColor: Colors.white,
                                                                      foregroundColor: Colors.white,
                                                                      shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                Colors.black),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ) // foreground
                                                                      ),
                                                                  onPressed: () async {
                                                                    print(
                                                                        '...................................click...............');

                                                                    setState(
                                                                      () {
                                                                        print(
                                                                            map);
                                                                        //print(map['FlutterQuery']);
                                                                        query =
                                                                            map['FlutterQuery'];
                                                                        // query=query!.replaceAll('@ClientID', clientId);
                                                                        // query=query!.replaceAll('@Date2', date2);
                                                                        // query=query!.replaceAll('@Date1', date1);
                                                                        editPageRoute =
                                                                            map['AddEditPage'];

                                                                        isQueryGet =
                                                                            true;
                                                                        Provider.of<DatabaseProvider>(context, listen: false).layoutName =
                                                                            map["SabMenuName"];
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    map["SabMenuName"],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  )),
                                                            );
                                                          }),
                                                    );
                                                  }
                                                  return Container();
                                                }),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                icon: Icon(Icons.expand_more),
                                                onPressed: () async {
                                                  // List list = await rowCourtQuery(
                                                  //     widget.menuName);
                                                  // showMenu<String>(
                                                  //   context: context,
                                                  //   position:
                                                  //   RelativeRect.fromLTRB(40.0, 135.0, 30.0, 0.0),
                                                  //   //position where you want to show the menu on screen
                                                  //   items: [
                                                  //     PopupMenuItem<String>(
                                                  //         child:
                                                  //         const Text('Filter By Account Group'),
                                                  //         value: '1'),
                                                  //     PopupMenuItem<String>(
                                                  //         child: const Text(
                                                  //             'Filter By Account Type'),
                                                  //         value: '2'),
                                                  //     PopupMenuItem<String>(
                                                  //         child: const Text(
                                                  //             'Filter By User Rights'),
                                                  //         value: '3'),
                                                  //     PopupMenuItem<String>(
                                                  //         child: const Text(
                                                  //           'Clear All Filteration',
                                                  //           style: TextStyle(
                                                  //             color: Colors.red,
                                                  //           ),
                                                  //         ),
                                                  //         value: '4'),
                                                  //   ],
                                                  //   elevation: 8.0,
                                                  // ).then(
                                                  //       (value) async {
                                                  //     if (value == null) {}
                                                  //     if (value == '1') {}
                                                  //     if (value == '2') {}
                                                  //     if (value == '3') {}
                                                  //     if (value == '4') {}
                                                  //   },
                                                  // );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    SizedBox(
                      height: ScreenConfig.blockHeight * 90,
                      child: displayTable(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  displayTable(BuildContext context) {
    if (isQueryGet) {
      return FutureBuilder(
        future: Provider.of<DatabaseProvider>(context, listen: false)
            .getTableByQuery(query, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //return SelectableText(query!);
            return (Provider.of<DatabaseProvider>(context, listen: false)
                        .tableDetailList
                        .length >
                    0)
                ? TableTestingWidget(
                    editPageRoute: editPageRoute,
                    query: query!,
                  )
                : Center(
                    child: Text('No Data Available'),
                  );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    } else {
      // print('Page Open is ' + widget.pageOpen);
      // print("Menu name is " + widget.menuName);
      Map dropDownMap = {
        "ID": null,
        'Title': 'Account Name',
        'SubTitle': null,
        "Value": null
      };
      if (widget.menuName == 'Sale') {
        dropDownMap = {
          "ID": 1,
          'Title': 'Sales',
          'SubTitle': "SL",
          "Value": ''
        };
      } else if (widget.menuName == 'Purchase') {
        dropDownMap = {
          "ID": 2,
          'Title': 'Purchase',
          'SubTitle': "PU",
          "Value": ''
        };
      } else if (widget.menuName == 'Sale Return') {
        dropDownMap = {
          "ID": 3,
          'Title': 'Sales Return',
          'SubTitle': "SR",
          "Value": ''
        };
      } else if (widget.menuName == 'Purchase Return') {
        dropDownMap = {
          "ID": 4,
          'Title': 'Purchase Return',
          'SubTitle': "PR",
          "Value": ''
        };
      }
      switch (widget.pageOpen) {
        case "DefaultAccountsPage":
          {
            return DefaultPageAccounts(
              menuName: widget.menuName,
              onItemSelected: widget.onItemSelected,
            );
          }
        case "DefaultSalPur1Page":
          {

            return DefaultSalePurchase2(
              dropDownMap: dropDownMap,
              menuName: widget.menuName,
              onItemSelected: widget.onItemSelected,
            );
            // return
            //   SalesPur1(
            //   dropDownMap: dropDownMap,
            //   menuName: widget.menuName,
            //   onItemSelected: widget.onItemSelected,
            // );
          }

        case "DefaultItemsPage":
          {
            return DefaultItemsPage(
              menuName: widget.menuName,
            );
          }
        case "TailorJobEntry":
          {
            return AllOrderPages();
          }
        case "MarrHallBookingEntry":
          {
            return MarriageHallMainPage();
          }
        case "BeautySalonJobEntry":
          {
            return BeautySAlonMainDashBoard();
          }
        case "DefaultCashBookPage":
          return DefaultCashBookUI(menuName: widget.menuName);

        case 'RestaurantSalPur1Page':
          {
            return ResturantSalesPur1(
              dropDownMap: dropDownMap,
              menuName: widget.menuName,
              onItemSelected: widget.onItemSelected,
            );
          }
        case 'RestaurantItemsPage':
          {
            return ResturantDefaultItemsPage(menuName: widget.menuName);
          }
        case 'CounterSales':
          {
            return AddItemBySelection(
                openFor: 'Sales',
                id: 0,
                accountID: 12,
                accountName: 'Name',
                billAmount: 0,
                contactNo: 'contactNo',
                date: DateTime.now().toString(),
                entryType: 'SL',
                nameOfPerson: '',
                paymentAfterDate: DateTime.now().toString(),
                remarks: '',
                salePurId1: widget.salePurID!);
          }
        case "TableService":
          return DefaultTableService();
        case "CaseEntry":
          return PatientDashBoardScreen();
        case "BeautySalonToken":
          return TokenMainScreen();
        case "DoctorEntry":
          return DoctorDashBoardScreen();
        case "ClanicPriceList":
          return PriceListMainScreen();
        case "DefaultSchoolManagement":
          return DefaultSchoolPage(menuName: widget.menuName);
        case "BeautySalonBeautician":
          return BeauticianMainScreen();
        case "BeautySalonPriceList":
          return ServicePriceList();
        case "DefaultStudentPage":
          {
            return DefaultStudentPage(
              menuName: widget.menuName,
              onItemSelected: widget.onItemSelected,
            );
          }
        case "DefaultFeesCollectionPage":
          return FeeCollection(menuName: widget.menuName);
        default:
          return Scaffold(
            body: Center(
              child: Text("No Default Page is available"),
            ),
          );
      }
    }
  }

  //////////////////////////////////////////////////////
  /////////////   Sub Menu Row Buttons   ///////////////
  /////////////////////////////////////////////////////

  Future<List> rowCourtQuery(String menuName) async {
    print(menuName);
    var db = await DatabaseProvider().init();
    String query = '''
      SELECT * FROM ProjectMenuSub where MenuName='$menuName';
      ''';
    List list = await db.rawQuery(query);
    // db.close();
    return list;
  }
}
