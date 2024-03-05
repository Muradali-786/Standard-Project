import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:com/pages/free_classified_add/main_page_for_add.dart';
import 'package:com/pages/vehicle_booking_system/vehicle_booking_main_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:com/api/api_constants.dart';
import 'package:com/config/screen_config.dart';
import 'package:com/main/tab_bar_pages/home/home_page_code_provider.dart';
import 'package:com/main/tab_bar_pages/home/themedataclass.dart';
import 'package:com/pages/home/project_detail_page.dart';
import 'package:com/pages/general_trading/introductionpage.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../Server/RefreshDataProvider.dart';
import '../../../pages/beauty_salon/refreshing_beauty_salon.dart';
import '../../../pages/general_trading/Accounts/AccountLedger.dart';
import '../../../pages/general_trading/SalePur/sale_pur1_SQL.dart';
import '../../../pages/general_trading/introductionclientPage.dart';
import '../../../pages/home/Sub_menu_page.dart';
import '../../../pages/marriage_hall_booking/refreshing_marriage_hall.dart';
import '../../../pages/material/Toast.dart';

import '../../../pages/patient_care_system/refeshing_patient_care_system.dart';
import '../../../pages/school/refreshing.dart';
import '../../../pages/tailor_shop_systom/refreshing_tailor_shop.dart';
import 'themedataclassforproject.dart';
import 'clientAccount_code_provider.dart';

typedef Null ItemSelectedCallback(Widget value);

class DashboardHomePage extends StatefulWidget {
  final ItemSelectedCallback? onItemSelected;

  DashboardHomePage({
    this.onItemSelected,
  });

  @override
  _DashboardHomePageState createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  double column = 2;
  late int homeSliderValue = 3;
  String homePageViews = 'GridView';
  String clientSingleView = 'AllClient';
  SalePurSQLDataBase _salePurSQLDataBase = SalePurSQLDataBase();

  RefreshingBeautySalon refreshingBeautySalon = RefreshingBeautySalon();
  RefreshingMarriageHall refreshingMarriageHall = RefreshingMarriageHall();
  RefreshingPatientCareSystem refreshingPatientCareSystem =
      RefreshingPatientCareSystem();
  RefreshingTailorShop refreshingTailorShop = RefreshingTailorShop();

  DateTime currentDate = DateTime.now();
  double clientInfoHeight = 30;
  var clientInfoAxis = 'linear';
  bool clientInfoWrap = false;
  SchServerRefreshing _schServerRefreshing = SchServerRefreshing();

  // RestaurantRefreshing _refreshing = RestaurantRefreshing();
  bool checkRefresh = true;
  var arrowIcon = Icons.keyboard_arrow_down;
  var clientInfoPhy = BouncingScrollPhysics();

  double opacity = 0;

  @override
  void initState() {
    super.initState();

    print(
        '//////////////////${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.projectId)}/////////////////////////////');

    Future.delayed(Duration.zero, () {
      themeColorDataPickerForProjectMenu(context);
    });

    if (!SharedPreferencesKeys.prefs!.containsKey('slidValue')) {
      SharedPreferencesKeys.prefs!
          .setDouble('slidValue', homeSliderValue.toDouble());
    } else {
      homeSliderValue =
          SharedPreferencesKeys.prefs!.getDouble('slidValue')!.toInt();
    }

    if (!SharedPreferencesKeys.prefs!.containsKey('HomeSliderView')) {
      SharedPreferencesKeys.prefs!.setString('HomeSliderView', homePageViews);
    } else {
      homePageViews = SharedPreferencesKeys.prefs!.getString('HomeSliderView')!;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          SharedPreferencesKeys.prefs!
              .setInt(SharedPreferencesKeys.projectId, 0);
          SharedPreferencesKeys.prefs!
              .setInt(SharedPreferencesKeys.clinetId, 0);

          SharedPreferencesKeys.prefs!
              .setString(SharedPreferencesKeys.countryUserId2, '0');

          SharedPreferencesKeys.prefs!.remove('SingleView');
          Provider.of<ThemeDataHomePage>(context, listen: false)
              .borderTextAppBarColor = Colors.blue;

          Provider.of<ThemeDataHomePage>(context, listen: false)
              .backGroundColor = Colors.white;

          Provider.of<ThemeDataHomePage>(context, listen: false).projectName =
              'EasySoft';
          Provider.of<ThemeDataHomePage>(context, listen: false)
              .projectIconURL = '';
        });

        return false;
      },
      child: Scaffold(
        backgroundColor: Provider.of<ThemeDataHomePage>(context, listen: false)
            .backGroundColor,
        body: FutureBuilder(
          future: SharedPreferencesKeys.prefs!
                          .getInt(SharedPreferencesKeys.projectId) ==
                      null ||
                  SharedPreferencesKeys.prefs!
                          .getInt(SharedPreferencesKeys.projectId) ==
                      0
              ? Provider.of<DashboardProvider>(context, listen: false)
                  .getProjectTable()
              : Provider.of<ClientAccountProvider>(context, listen: false)
                  .getProjectTable1(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    /// client name ///////////////////////

                    FutureBuilder(
                      future:
                          Provider.of<DashboardProvider>(context, listen: false)
                              .getClientTable(),
                      builder: (context, AsyncSnapshot<List> snapshot) {
                        if (snapshot.hasData && snapshot.data!.length > 0) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: SharedPreferencesKeys.prefs!
                                        .getString('SingleView') ==
                                    null
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.center,
                            children: [
                              if (SharedPreferencesKeys.prefs!
                                      .getString('SingleView') ==
                                  null)
                                SizedBox(
                                  width: MediaQuery.of(context).size.width > 600
                                      ? MediaQuery.of(context).size.width * .25
                                      : MediaQuery.of(context).size.width * .8,
                                  child: FutureBuilder<List>(
                                      future: Provider.of<DashboardProvider>(
                                              context,
                                              listen: false)
                                          .getClientTable(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List list = List.from(snapshot.data!);

                                          return SharedPreferencesKeys.prefs!
                                                      .getString('linear') ==
                                                  null
                                              ? SizedBox(
                                                  height: 30,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: list.length,
                                                      //shrinkWrap: true,
                                                      physics: clientInfoPhy,
                                                      itemBuilder:
                                                          (context, index) {
                                                        Map map = list[index];
                                                        return InkWell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0),
                                                            child: Container(
                                                              height: 35,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          ScreenConfig.blockHeight *
                                                                              2.5),
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .blue),
                                                                  color: Colors
                                                                          .blue[
                                                                      100]),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: clientInfoAxis == Axis.horizontal
                                                                            ? 0.0
                                                                            : 1.0,
                                                                        top: 1,
                                                                        bottom:
                                                                            1),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50),
                                                                      child:
                                                                          // kIsWeb ? Image.network(
                                                                          //     'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${snapshot.data![index]['ClientID']}') :
                                                                          CachedNetworkImage(
                                                                              height: 20,
                                                                              width: 20,
                                                                              imageUrl: 'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${snapshot.data![index]['ClientID']}',
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
                                                                              errorWidget: (context, url, error) => Container(
                                                                                    color: Colors.grey,
                                                                                  )),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                    child: Text(
                                                                      map[(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.subMenuQuery) == null || SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.subMenuQuery) == '0')
                                                                              ? "CompanyName"
                                                                              : "SabMenuName"]
                                                                          .toString(),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            if (snapshot.data![
                                                                        index][
                                                                    'UserRights'] ==
                                                                'Statement View Only') {
                                                              await Navigator
                                                                  .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AccountLedger(
                                                                    accountId: int.parse(kIsWeb
                                                                        ? snapshot
                                                                            .data![index][
                                                                                'UserID']
                                                                            .toString()
                                                                        : snapshot
                                                                            .data![index]['ClientUserID']
                                                                            .toString()),
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              await SharedPreferencesKeys.prefs!.setInt(
                                                                  SharedPreferencesKeys
                                                                      .clinetId,
                                                                  int.parse(map[
                                                                          'ClientID']
                                                                      .toString()));
                                                              List listOfProjectName = await Provider.of<
                                                                          DashboardProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getProjectName(
                                                                      map['ProjectID']
                                                                          .toString());

                                                              Provider.of<ThemeDataHomePage>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .projectName = listOfProjectName[
                                                                      0][
                                                                  'ProjectName'];

                                                              if (!kIsWeb) {
                                                                List list2 = await Provider.of<
                                                                            DashboardProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .checkAccount3Name(SharedPreferencesKeys
                                                                        .prefs!
                                                                        .getInt(
                                                                            SharedPreferencesKeys.clinetId)
                                                                        .toString());

                                                                if (list2
                                                                        .length ==
                                                                    0) {
                                                                  if (Provider.of<ThemeDataHomePage>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .projectName ==
                                                                      'Beauty Salon') {
                                                                    await refreshingBeautySalon
                                                                        .getAllUpdatedDataFromServer(
                                                                            context);

                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  } else if (Provider.of<ThemeDataHomePage>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .projectName ==
                                                                      'Marriage Hall Booking') {
                                                                    refreshingMarriageHall
                                                                        .getAllUpdatedDataFromServer(
                                                                            context);

                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  } else if (Provider.of<ThemeDataHomePage>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .projectName ==
                                                                      'Patient Care System') {
                                                                    refreshingPatientCareSystem
                                                                        .getAllUpdatedDataFromServer(
                                                                            context);

                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  } else if (Provider.of<ThemeDataHomePage>(
                                                                              context,
                                                                              listen: false)
                                                                          .projectName ==
                                                                      'Tailor Shop ') {
                                                                    refreshingTailorShop
                                                                        .getAllUpdatedDataFromServer(
                                                                            context);

                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  } else {
                                                                    await _schServerRefreshing
                                                                        .getAllUpdatedDataFromServer(
                                                                      context,
                                                                    );
                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  }

                                                                  // await _refreshing
                                                                  //     .getAllUpdatedDataFromServer(
                                                                  //     context);
                                                                }
                                                              }

                                                              setState(() {
                                                                SharedPreferencesKeys
                                                                    .prefs!
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .countryClientID2,
                                                                      map['CountryClientID'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .countryUserId2,
                                                                      map['CountryUserID']
                                                                          .toString())
                                                                  ..setString(
                                                                      'SingleView',
                                                                      'SingleView')
                                                                  ..setInt(
                                                                      SharedPreferencesKeys
                                                                          .clientUserId,
                                                                      int.parse(kIsWeb
                                                                          ? snapshot.data![index]['UserID']
                                                                              .toString()
                                                                          : snapshot
                                                                              .data![index]['ClientUserID']
                                                                              .toString()))
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .companyName,
                                                                      map['CompanyName'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .companyAddress,
                                                                      map['CompanyAddress'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .companyNumber,
                                                                      map['CompanyNumber'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .website,
                                                                      map['WebSite'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .emailClient,
                                                                      map['Email'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .nameOfPersonOwner,
                                                                      map['NameOfPerson'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .bussinessDescription,
                                                                      map['BusinessDescriptions'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .userRightsClient,
                                                                      map['UserRights'] ??
                                                                          'N/A')
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .netcode,
                                                                      map['NetCode'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .sysCode,
                                                                      map['SysCode'])
                                                                  ..setInt(
                                                                      SharedPreferencesKeys
                                                                          .projectId,
                                                                      int.parse(
                                                                          map["ProjectID"]
                                                                              .toString()))
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .subMenuQuery,
                                                                      '0')
                                                                  ..setString(
                                                                      'UserName',
                                                                      map["UserName"]
                                                                          .toString());
                                                              });

                                                              await themeColorDataPickerForProjectMenu(
                                                                  context);
                                                            }
                                                          },
                                                        );
                                                      }),
                                                )

                                              /// grid view for client ........................................................
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: GridView.builder(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      shrinkWrap: true,
                                                      itemCount: list.length,
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: !SharedPreferencesKeys
                                                                  .prefs!
                                                                  .containsKey(
                                                                      'slidValue')
                                                              ? homeSliderValue
                                                              : SharedPreferencesKeys
                                                                  .prefs!
                                                                  .getDouble(
                                                                      'slidValue')!
                                                                  .toInt(),
                                                          childAspectRatio:
                                                              2 / 2.5,
                                                          crossAxisSpacing: 10,
                                                          mainAxisSpacing: 10),
                                                      itemBuilder:
                                                          (context, index) {
                                                        Map map = list[index];
                                                        return InkWell(
                                                          child: Card(
                                                            elevation: 15,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .blue
                                                                        .shade800,
                                                                    width: .5)),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              70),
                                                                  child: CachedNetworkImage(
                                                                      height: 40,
                                                                      width: 40,
                                                                      imageUrl: 'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${snapshot.data![index]['ClientID']}',
                                                                      alignment: Alignment.center,
                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(
                                                                                image: imageProvider,
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      placeholder: (context, url) => Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          ),
                                                                      errorWidget: (context, url, error) => Container(
                                                                            color:
                                                                                Colors.grey,
                                                                          )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          6.0),
                                                                  child: Text(
                                                                    list[index][(SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.subMenuQuery) == null ||
                                                                                SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.subMenuQuery) == '0')
                                                                            ? "CompanyName"
                                                                            : "SabMenuName"]
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 3,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            if (snapshot.data![
                                                                        index][
                                                                    'UserRights'] ==
                                                                'Statement View Only') {
                                                              await Navigator
                                                                  .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AccountLedger(
                                                                    accountId: int.parse(kIsWeb
                                                                        ? snapshot
                                                                            .data![index][
                                                                                'UserID']
                                                                            .toString()
                                                                        : snapshot
                                                                            .data![index]['ClientUserID']
                                                                            .toString()),
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              print(map);
                                                              print(
                                                                  '${map['ClientID']}');
                                                              await SharedPreferencesKeys.prefs!.setInt(
                                                                  SharedPreferencesKeys
                                                                      .clinetId,
                                                                  int.parse(map[
                                                                          'ClientID']
                                                                      .toString()));

                                                              List listOfProjectName = await Provider.of<
                                                                          DashboardProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getProjectName(
                                                                      map['ProjectID']
                                                                          .toString());

                                                              Provider.of<ThemeDataHomePage>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .projectName = listOfProjectName[
                                                                      0][
                                                                  'ProjectName'];

                                                              if (!kIsWeb) {
                                                                List list2 = await Provider.of<
                                                                            DashboardProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .checkAccount3Name(SharedPreferencesKeys
                                                                        .prefs!
                                                                        .getInt(
                                                                            SharedPreferencesKeys.clinetId)
                                                                        .toString());
                                                                if (list2
                                                                        .length ==
                                                                    0) {
                                                                  if (Provider.of<ThemeDataHomePage>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .projectName ==
                                                                      'Beauty Salon') {
                                                                    await refreshingBeautySalon
                                                                        .getAllUpdatedDataFromServer(
                                                                            context);

                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  } else if (Provider.of<ThemeDataHomePage>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .projectName ==
                                                                      'Marriage Hall Booking') {
                                                                    refreshingMarriageHall
                                                                        .getAllUpdatedDataFromServer(
                                                                            context);

                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  } else if (Provider.of<ThemeDataHomePage>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .projectName ==
                                                                      'Patient Care System') {
                                                                    refreshingPatientCareSystem
                                                                        .getAllUpdatedDataFromServer(
                                                                            context);

                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  } else if (Provider.of<ThemeDataHomePage>(
                                                                              context,
                                                                              listen: false)
                                                                          .projectName ==
                                                                      'Tailor Shop ') {
                                                                    refreshingTailorShop
                                                                        .getAllUpdatedDataFromServer(
                                                                            context);

                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  } else {
                                                                    await _schServerRefreshing
                                                                        .getAllUpdatedDataFromServer(
                                                                      context,
                                                                    );
                                                                    await Provider.of<RefreshDataProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getAllUpdatedDataFromServer(
                                                                            context,
                                                                            false);
                                                                  }

                                                                  // await _refreshing
                                                                  //     .getAllUpdatedDataFromServer(
                                                                  //     context);
                                                                }
                                                              }

                                                              setState(() {
                                                                SharedPreferencesKeys
                                                                    .prefs!
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .countryClientID2,
                                                                      map['CountryClientID'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .countryUserId2,
                                                                      map['CountryUserID']
                                                                          .toString())
                                                                  ..setString(
                                                                      'SingleView',
                                                                      'SingleView')
                                                                  ..setInt(
                                                                      SharedPreferencesKeys
                                                                          .clientUserId,
                                                                      int.parse(kIsWeb
                                                                          ? snapshot.data![index]['UserID']
                                                                              .toString()
                                                                          : snapshot
                                                                              .data![index]['ClientUserID']
                                                                              .toString()))
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .companyName,
                                                                      map['CompanyName'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .companyAddress,
                                                                      map['CompanyAddress'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .companyNumber,
                                                                      map['CompanyNumber'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .website,
                                                                      map['WebSite'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .emailClient,
                                                                      map['Email'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .nameOfPersonOwner,
                                                                      map['NameOfPerson'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .bussinessDescription,
                                                                      map['BusinessDescriptions'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .userRightsClient,
                                                                      map['UserRights'] ??
                                                                          'N/A')
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .netcode,
                                                                      map['NetCode'])
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .sysCode,
                                                                      map['SysCode'])
                                                                  ..setInt(
                                                                      SharedPreferencesKeys
                                                                          .projectId,
                                                                      int.parse(
                                                                          map["ProjectID"]
                                                                              .toString()))
                                                                  ..setString(
                                                                      SharedPreferencesKeys
                                                                          .subMenuQuery,
                                                                      '0')
                                                                  ..setString(
                                                                      'UserName',
                                                                      map["UserName"]
                                                                          .toString());
                                                              });

                                                              await themeColorDataPickerForProjectMenu(
                                                                  context);
                                                            }
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                        }
                                        if (snapshot.hasError) {
                                          Toast.buildErrorSnackBar(
                                              snapshot.error.toString());
                                        }
                                        return Container();
                                      }),
                                )
                              else
                                SizedBox(
                                  width: MediaQuery.of(context).size.width > 600
                                      ? MediaQuery.of(context).size.width * .25
                                      : MediaQuery.of(context).size.width,
                                  child: InkWell(
                                    onTap: () {
                                      if (Platform.isWindows) {
                                        widget.onItemSelected!(
                                            IntroductionClientPage(
                                                clientID: SharedPreferencesKeys
                                                    .prefs!
                                                    .getInt(SharedPreferencesKeys
                                                        .clinetId)!,
                                                projectName: Provider.of<
                                                            ThemeDataHomePage>(
                                                        context,
                                                        listen: false)
                                                    .projectName,
                                                projectID: SharedPreferencesKeys
                                                    .prefs!
                                                    .getInt(
                                                        SharedPreferencesKeys
                                                            .projectId)!));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => IntroductionClientPage(
                                                  clientID: SharedPreferencesKeys
                                                      .prefs!
                                                      .getInt(
                                                          SharedPreferencesKeys
                                                              .clinetId)!,
                                                  projectName: Provider.of<
                                                              ThemeDataHomePage>(
                                                          context,
                                                          listen: false)
                                                      .projectName,
                                                  projectID: SharedPreferencesKeys
                                                      .prefs!
                                                      .getInt(
                                                          SharedPreferencesKeys
                                                              .projectId)!),
                                            ));
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Provider.of<ThemeDataHomePage>(
                                                  context,
                                                  listen: false)
                                              .backGroundColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                  height: 50,
                                                  width: 50,
                                                  imageUrl:
                                                      'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId)}',
                                                  alignment: Alignment.center,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                            color: Colors.grey,
                                                          )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    SharedPreferencesKeys.prefs!
                                                        .getString(
                                                            SharedPreferencesKeys
                                                                .companyName)!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                600
                                                            ? 20
                                                            : 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    SharedPreferencesKeys.prefs!
                                                            .getString(
                                                                'UserName') ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                  Text(
                                                    '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.userRightsClient)}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              SharedPreferencesKeys.prefs!
                                          .getString('SingleView') ==
                                      null
                                  ? IconButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          if (SharedPreferencesKeys.prefs!
                                                  .getString('linear') ==
                                              null) {
                                            SharedPreferencesKeys.prefs!
                                                .setString('linear', 'grid');
                                            //  arrowIcon =Icons.keyboard_arrow_down;
                                          } else {
                                            SharedPreferencesKeys.prefs!
                                                .remove('linear');
                                            // arrowIcon =Icons.keyboard_arrow_up;
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        SharedPreferencesKeys.prefs!
                                                    .getString('linear') ==
                                                null
                                            ? Icons.keyboard_arrow_down
                                            : Icons.keyboard_arrow_up,
                                        size: 40,
                                        color: Colors.green,
                                      ))
                                  : SizedBox(),
                            ],
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),

                    kIsWeb
                        ? SharedPreferencesKeys.prefs!.getInt(
                                        SharedPreferencesKeys.projectId) ==
                                    null ||
                                SharedPreferencesKeys.prefs!.getInt(
                                        SharedPreferencesKeys.projectId) ==
                                    0
                            ? GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: Provider.of<DashboardProvider>(
                                        context,
                                        listen: false)
                                    .projectTableDetailList
                                    .length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  Map map = Provider.of<DashboardProvider>(
                                          context,
                                          listen: false)
                                      .projectTableDetailList[index];
                                  return InkWell(
                                    child: Card(
                                      elevation: 16,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(color: Colors.grey)),
                                      shadowColor: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  flex: 7,
                                                  child: Image.network(
                                                      '${ApiConstants.baseUrl}/PhpApi1/ProjectImages/ProjectsLogo/${map['ProjectID']}.png'),
                                                ),
                                                Flexible(
                                                  flex: 3,
                                                  child: Text(
                                                    map["ProjectName"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                    onTap: () async {
                                      switch (map["ProjectName"]) {
                                        case "General Trading System":
                                          {
                                            await SharedPreferencesKeys.prefs!
                                                .setInt(
                                                    SharedPreferencesKeys
                                                        .projectIdForProject,
                                                    int.parse(map["ProjectID"]
                                                        .toString()));
                                            await themeColorDataPickerForProject(
                                                context);

                                            widget.onItemSelected!(
                                                IntroductionPage(
                                              onItemSelected:
                                                  widget.onItemSelected,
                                              title: map["ProjectName"],
                                              projectID: int.parse(
                                                  map["ProjectID"].toString()),
                                              createClientFor:
                                                  "General Trading",
                                            ));
                                            break;
                                          }
                                        case 'School Management System':
                                          {
                                            await SharedPreferencesKeys.prefs!
                                                .setInt(
                                                    SharedPreferencesKeys
                                                        .projectIdForProject,
                                                    int.parse(map["ProjectID"]
                                                        .toString()));
                                            await themeColorDataPickerForProject(
                                                context);

                                            widget.onItemSelected!(
                                                IntroductionPage(
                                              onItemSelected:
                                                  widget.onItemSelected,
                                              title: map["ProjectName"],
                                              projectID: int.parse(
                                                  map["ProjectID"].toString()),
                                              createClientFor:
                                                  "General Trading",
                                            ));

                                            break;
                                          }
                                        case 'Restaurant Management System':
                                          {
                                            await SharedPreferencesKeys.prefs!
                                                .setInt(
                                                    SharedPreferencesKeys
                                                        .projectIdForProject,
                                                    int.parse(map["ProjectID"]
                                                        .toString()));
                                            await themeColorDataPickerForProject(
                                                context);

                                            widget.onItemSelected!(
                                                IntroductionPage(
                                              onItemSelected:
                                                  widget.onItemSelected,
                                              title: map["ProjectName"],
                                              projectID: int.parse(
                                                  map["ProjectID"].toString()),
                                              createClientFor:
                                                  "General Trading",
                                            ));

                                            break;
                                          }
                                        default:
                                          widget.onItemSelected!(
                                              ProjectDetailPage());
                                      }
                                    },
                                  );
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Provider.of<ThemeDataHomePage>(
                                            context,
                                            listen: false)
                                        .backGroundColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        Provider.of<ClientAccountProvider>(
                                                context,
                                                listen: false)
                                            .projectTableDetailList
                                            .length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemBuilder: (context, index) {
                                      Map map =
                                          Provider.of<ClientAccountProvider>(
                                                  context,
                                                  listen: false)
                                              .projectTableDetailList[index];

                                      return InkWell(
                                        child: Card(
                                          elevation: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              side: BorderSide(
                                                  color: Provider.of<
                                                              ThemeDataHomePage>(
                                                          context,
                                                          listen: false)
                                                      .borderTextAppBarColor,
                                                  width: 1)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15)),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '${ApiConstants.baseUrl}/PhpApi1/ProjectImages/MenuIcon/${map['ImageName']}.png',
                                                  height: homeSliderValue == 3
                                                      ? 50
                                                      : 150,
                                                  width: homeSliderValue == 3
                                                      ? 50
                                                      : 150,
                                                  alignment: Alignment.center,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,
                                                        // colorFilter:
                                                        // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/images/easysoft_logo.jpg',
                                                    alignment: Alignment.center,
                                                    height: homeSliderValue == 1
                                                        ? 150
                                                        : homeSliderValue == 2
                                                            ? 150
                                                            : 60,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  map["MenuName"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: homeSliderValue ==
                                                            3
                                                        ? 12
                                                        : homeSliderValue == 4
                                                            ? 10
                                                            : 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Provider.of<
                                                                ThemeDataHomePage>(
                                                            context,
                                                            listen: false)
                                                        .borderTextAppBarColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          widget.onItemSelected!(
                                            SubMenuPage(
                                              onItemSelected:
                                                  widget.onItemSelected,
                                              menuName: map["MenuName"],
                                              valuePass: map['ValuePass'],
                                              pageOpen: map['PageOpen'],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              )
                        : (Platform.isWindows)
                            ? FutureBuilder(
                                future: getApplicationDocumentsDirectory(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Directory? directory =
                                        snapshot.data as Directory?;
                                    String dir = directory!.path;
                                    return SharedPreferencesKeys.prefs!.getInt(
                                                    SharedPreferencesKeys
                                                        .projectId) ==
                                                null ||
                                            SharedPreferencesKeys.prefs!.getInt(
                                                    SharedPreferencesKeys
                                                        .projectId) ==
                                                0

                                        ///  home grid and listView //////////////////////////////////////////////
                                        ? GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount:
                                                Provider.of<DashboardProvider>(
                                                        context,
                                                        listen: false)
                                                    .projectTableDetailList
                                                    .length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                            ),
                                            itemBuilder: (context, index) {
                                              String projectImagesFolderPath =
                                                  '$dir/ProjectImages/ProjectsLogo/';
                                              Map map = Provider.of<
                                                          DashboardProvider>(
                                                      context,
                                                      listen: false)
                                                  .projectTableDetailList[index];
                                              return InkWell(
                                                child: Card(
                                                  elevation: 16,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      side: BorderSide(
                                                          color: Colors.grey)),
                                                  shadowColor: Colors.black,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                topRight: Radius
                                                                    .circular(
                                                                        5),
                                                              ),
                                                              child: File('$projectImagesFolderPath/${map['ProjectID']}.png')
                                                                      .existsSync()
                                                                  ? Image.file(
                                                                      File(
                                                                          '$projectImagesFolderPath/${map['ProjectID']}.png'),
                                                                      // height: 20,
                                                                      fit: BoxFit
                                                                          .fill)
                                                                  : CachedNetworkImage(
                                                                      imageUrl:
                                                                          '${ApiConstants.baseUrl}/PhpApi1/ProjectImages/ProjectsLogo/${map['ProjectID']}.png',
                                                                      height:
                                                                          130,
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
                                                                              Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image
                                                                              .asset(
                                                                        'assets/images/easysoft_logo.jpg',
                                                                        height:
                                                                            150,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    ),
                                                            ),
                                                            //SizedBox(height: 4),
                                                            Center(
                                                              child: Text(
                                                                map["ProjectName"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ),
                                                            //SizedBox(height: 5),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                                onTap: () async {
                                                  switch (map["ProjectName"]) {
                                                    case "General Trading System":
                                                      {
                                                        await SharedPreferencesKeys
                                                            .prefs!
                                                            .setInt(
                                                                SharedPreferencesKeys
                                                                    .projectIdForProject,
                                                                map["ProjectID"]);
                                                        await themeColorDataPickerForProject(
                                                            context);

                                                        widget.onItemSelected!(
                                                            IntroductionPage(
                                                          onItemSelected: widget
                                                              .onItemSelected,
                                                          title: map[
                                                              "ProjectName"],
                                                          projectID:
                                                              map["ProjectID"],
                                                          createClientFor:
                                                              "General Trading",
                                                        ));
                                                        break;
                                                      }
                                                    case 'School Management System':
                                                      {
                                                        await SharedPreferencesKeys
                                                            .prefs!
                                                            .setInt(
                                                                SharedPreferencesKeys
                                                                    .projectIdForProject,
                                                                map["ProjectID"]);
                                                        await themeColorDataPickerForProject(
                                                            context);

                                                        widget.onItemSelected!(
                                                            IntroductionPage(
                                                          onItemSelected: widget
                                                              .onItemSelected,
                                                          title: map[
                                                              "ProjectName"],
                                                          projectID:
                                                              map["ProjectID"],
                                                          createClientFor:
                                                              "General Trading",
                                                        ));

                                                        break;
                                                      }
                                                    case 'Restaurant Management System':
                                                      {
                                                        await SharedPreferencesKeys
                                                            .prefs!
                                                            .setInt(
                                                                SharedPreferencesKeys
                                                                    .projectIdForProject,
                                                                map["ProjectID"]);
                                                        await themeColorDataPickerForProject(
                                                            context);

                                                        widget.onItemSelected!(
                                                            IntroductionPage(
                                                          onItemSelected: widget
                                                              .onItemSelected,
                                                          title: map[
                                                              "ProjectName"],
                                                          projectID:
                                                              map["ProjectID"],
                                                          createClientFor:
                                                              "General Trading",
                                                        ));

                                                        break;
                                                      }
                                                    default:
                                                      widget.onItemSelected!(
                                                          ProjectDetailPage());
                                                  }
                                                },
                                              );
                                            },
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Provider.of<
                                                            ThemeDataHomePage>(
                                                        context,
                                                        listen: false)
                                                    .backGroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: Provider.of<
                                                            ClientAccountProvider>(
                                                        context,
                                                        listen: false)
                                                    .projectTableDetailList
                                                    .length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                ),
                                                itemBuilder: (context, index) {
                                                  String menuImagesFolderPath =
                                                      '$dir/ProjectImages/MenuIcon/';

                                                  Map map = Provider.of<
                                                              ClientAccountProvider>(
                                                          context,
                                                          listen: false)
                                                      .projectTableDetailList[index];

                                                  return InkWell(
                                                    child: Card(
                                                      elevation: 15,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15),
                                                          side: BorderSide(
                                                              color: Provider.of<
                                                                          ThemeDataHomePage>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .borderTextAppBarColor,
                                                              width: 1)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                topRight: Radius
                                                                    .circular(
                                                                        15)),
                                                            child: File('$menuImagesFolderPath/${map['ImageName']}.png')
                                                                    .existsSync()
                                                                ? SizedBox(
                                                                    height:
                                                                        homeSliderValue ==
                                                                                3
                                                                            ? 50
                                                                            : 150,
                                                                    width: homeSliderValue ==
                                                                            3
                                                                        ? 50
                                                                        : 150,
                                                                    child: Image
                                                                        .file(
                                                                      File(
                                                                          '$menuImagesFolderPath/${map['ImageName']}.png'),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  )
                                                                //'${ApiConstants.baseUrl}/PhpApi1/ProjectImages/MenuIcon/${map['ImageName']}.png'),
                                                                : CachedNetworkImage(
                                                                    imageUrl:
                                                                        '${ApiConstants.baseUrl}/PhpApi1/ProjectImages/MenuIcon/${map['ImageName']}.png',
                                                                    height:
                                                                        homeSliderValue ==
                                                                                3
                                                                            ? 50
                                                                            : 150,
                                                                    width: homeSliderValue ==
                                                                            3
                                                                        ? 50
                                                                        : 150,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          // colorFilter:
                                                                          // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/easysoft_logo.jpg',
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height: homeSliderValue ==
                                                                              1
                                                                          ? 150
                                                                          : homeSliderValue == 2
                                                                              ? 150
                                                                              : 60,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                          ),
                                                          Center(
                                                            child: Text(
                                                              map["MenuName"],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: homeSliderValue ==
                                                                        3
                                                                    ? 12
                                                                    : homeSliderValue ==
                                                                            4
                                                                        ? 10
                                                                        : 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Provider.of<
                                                                            ThemeDataHomePage>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .borderTextAppBarColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      widget.onItemSelected!(
                                                        SubMenuPage(
                                                          onItemSelected: widget
                                                              .onItemSelected,
                                                          menuName:
                                                              map["MenuName"],
                                                          valuePass:
                                                              map['ValuePass'],
                                                          pageOpen:
                                                              map['PageOpen'],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                })
                            : FutureBuilder(
                                future: getExternalStorageDirectories(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SharedPreferencesKeys.prefs!.getInt(
                                                    SharedPreferencesKeys
                                                        .projectId) ==
                                                null ||
                                            SharedPreferencesKeys.prefs!.getInt(
                                                    SharedPreferencesKeys
                                                        .projectId) ==
                                                0

                                        ///  home grid and listView //////////////////////////////////////////////
                                        ? homePageViews == 'GridView'
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: GridView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: Provider.of<
                                                                DashboardProvider>(
                                                            context,
                                                            listen: false)
                                                        .projectTableDetailList
                                                        .length,
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: !SharedPreferencesKeys
                                                                .prefs!
                                                                .containsKey(
                                                                    'slidValue')
                                                            ? homeSliderValue
                                                            : SharedPreferencesKeys
                                                                .prefs!
                                                                .getDouble(
                                                                    'slidValue')!
                                                                .toInt(),
                                                        childAspectRatio:
                                                            2 / 2.5,
                                                        crossAxisSpacing: 20,
                                                        mainAxisSpacing: 20),
                                                    itemBuilder:
                                                        (context, index) {
                                                      Map map = Provider.of<
                                                                  DashboardProvider>(
                                                              context,
                                                              listen: false)
                                                          .projectTableDetailList[index];

                                                      return InkWell(
                                                        child: Card(
                                                          elevation: 15,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade800,
                                                                  width: .5)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ClipRRect(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              15),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              15)),
                                                                  child: Image(
                                                                    image: AssetImage(
                                                                        'assets/ProjectImages/ProjectsLogo/${map['ProjectID']}.png'),
                                                                    height: 50,
                                                                  )),
                                                              // SizedBox(height: 4),
                                                              Center(
                                                                child: Text(
                                                                  map["ProjectName"],
                                                                  //maxLines: 3,                                                  ,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize: homeSliderValue == 3
                                                                          ? 12
                                                                          : homeSliderValue == 4
                                                                              ? 10
                                                                              : 13,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.blue.shade500),
                                                                  //maxLines: 3,
                                                                ),
                                                              ),
                                                              //SizedBox(height: 5),
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          print(
                                                              ',,,,,,${map["ProjectName"]},,,,,');
                                                          switch (map[
                                                              "ProjectName"]) {
                                                            case "Free Classified Add ":
                                                              {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              MainPAgeForAdd(
                                                                        title: map[
                                                                            "ProjectName"],
                                                                        projectID:
                                                                            map["ProjectID"],
                                                                      ),
                                                                    ));
                                                              }
                                                              break;
                                                            case "Vehicle Booking System":
                                                              {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              VehicleBookingMainPage(
                                                                        title: map[
                                                                            "ProjectName"],
                                                                        projectID:
                                                                            map["ProjectID"],
                                                                      ),
                                                                    ));
                                                              }
                                                              break;
                                                            case "Beauty Salon":
                                                              {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            IntroductionPage(
                                                                      title: map[
                                                                          "ProjectName"],
                                                                      projectID:
                                                                          map["ProjectID"],
                                                                      createClientFor:
                                                                          "BeautySalon",
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              break;
                                                            case "Tailor Shop ":
                                                              {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            IntroductionPage(
                                                                      title: map[
                                                                          "ProjectName"],
                                                                      projectID:
                                                                          map["ProjectID"],
                                                                      createClientFor:
                                                                          "TailorShop",
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              break;
                                                            case "Marriage Hall Booking":
                                                              {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            IntroductionPage(
                                                                      title: map[
                                                                          "ProjectName"],
                                                                      projectID:
                                                                          map["ProjectID"],
                                                                      createClientFor:
                                                                          "MarriageBoking",
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              break;
                                                            case "Patient Care System":
                                                              {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            IntroductionPage(
                                                                      title: map[
                                                                          "ProjectName"],
                                                                      projectID:
                                                                          map["ProjectID"],
                                                                      createClientFor:
                                                                          "CareSystem",
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              break;
                                                            case "General Trading System":
                                                              {
                                                                SharedPreferencesKeys
                                                                    .prefs!
                                                                    .setInt(
                                                                        SharedPreferencesKeys
                                                                            .projectIdForProject,
                                                                        map["ProjectID"]);

                                                                themeColorDataPickerForProject(
                                                                    context);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            IntroductionPage(
                                                                      title: map[
                                                                          "ProjectName"],
                                                                      projectID:
                                                                          map["ProjectID"],
                                                                      createClientFor:
                                                                          "General Trading",
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              break;
                                                            case "Restaurant Management System":
                                                              {
                                                                SharedPreferencesKeys
                                                                    .prefs!
                                                                    .setInt(
                                                                        SharedPreferencesKeys
                                                                            .projectIdForProject,
                                                                        map["ProjectID"]);

                                                                themeColorDataPickerForProject(
                                                                    context);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            IntroductionPage(
                                                                      title: map[
                                                                          "ProjectName"],
                                                                      projectID:
                                                                          map["ProjectID"],
                                                                      createClientFor:
                                                                          "Restaurant",
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              break;
                                                            case "School Management System":
                                                              {
                                                                setState(() {
                                                                  SharedPreferencesKeys
                                                                      .prefs!
                                                                      .setInt(
                                                                          SharedPreferencesKeys
                                                                              .projectIdForProject,
                                                                          map["ProjectID"]);

                                                                  themeColorDataPickerForProject(
                                                                      context);

                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              IntroductionPage(
                                                                        title: map[
                                                                            "ProjectName"],
                                                                        projectID:
                                                                            map["ProjectID"],
                                                                        createClientFor:
                                                                            "School",
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                              }
                                                              break;
                                                            default:
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  '/project_detail_page');
                                                          }
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: Provider.of<
                                                            DashboardProvider>(
                                                        context,
                                                        listen: false)
                                                    .projectTableDetailList
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  // String
                                                  //     projectImagesFolderPath =
                                                  //     '$dir/ProjectImages/ProjectsLogo/';
                                                  Map map = Provider.of<
                                                              DashboardProvider>(
                                                          context,
                                                          listen: false)
                                                      .projectTableDetailList[index];

                                                  return InkWell(
                                                    child: Card(
                                                      elevation: 2,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 16.0),
                                                            child: ClipRRect(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            15),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            15)),
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      'assets/ProjectImages/ProjectsLogo/${map['ProjectID']}.png'),
                                                                  height: 50,
                                                                )),
                                                          ),

                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          8.0),
                                                              child: Text(
                                                                map["ProjectName"],
                                                                //maxLines: 3,                                                  ,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green),
                                                                //maxLines: 3,
                                                              ),
                                                            ),
                                                          ),
                                                          //SizedBox(height: 5),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      switch (
                                                          map["ProjectName"]) {
                                                        case "General Trading System":
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  IntroductionPage(
                                                                title: map[
                                                                    "ProjectName"],
                                                                projectID: map[
                                                                    "ProjectID"],
                                                                createClientFor:
                                                                    "General Trading",
                                                              ),
                                                            ),
                                                          );
                                                          break;
                                                        case "Restaurant Management Ststem":
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  IntroductionPage(
                                                                title: map[
                                                                    "ProjectName"],
                                                                projectID: map[
                                                                    "ProjectID"],
                                                                createClientFor:
                                                                    "Restaurant",
                                                              ),
                                                            ),
                                                          );
                                                          break;
                                                        case "School Management System":
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  IntroductionPage(
                                                                title: map[
                                                                    "ProjectName"],
                                                                projectID: map[
                                                                    "ProjectID"],
                                                                createClientFor:
                                                                    "School",
                                                              ),
                                                            ),
                                                          );
                                                          break;
                                                        default:
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/project_detail_page');
                                                      }
                                                    },
                                                  );
                                                },
                                              )

                                        ///  menu grid and listView //////////////////////////////////////////////
                                        : homePageViews == 'GridView'
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Provider.of<
                                                                ThemeDataHomePage>(
                                                            context,
                                                            listen: false)
                                                        .backGroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: GridView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: Provider.of<
                                                                ClientAccountProvider>(
                                                            context,
                                                            listen: false)
                                                        .projectTableDetailList
                                                        .length,
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: !SharedPreferencesKeys
                                                                .prefs!
                                                                .containsKey(
                                                                    'slidValue')
                                                            ? homeSliderValue
                                                            : SharedPreferencesKeys
                                                                .prefs!
                                                                .getDouble(
                                                                    'slidValue')!
                                                                .toInt(),
                                                        childAspectRatio:
                                                            2 / 2.5,
                                                        crossAxisSpacing: 20,
                                                        mainAxisSpacing: 20),
                                                    itemBuilder:
                                                        (context, index) {
                                                      // String
                                                      //     menuImagesFolderPath =
                                                      //     '$dir/ProjectImages/MenuIcon/';

                                                      Map map = Provider.of<
                                                                  ClientAccountProvider>(
                                                              context,
                                                              listen: false)
                                                          .projectTableDetailList[index];

                                                      return InkWell(
                                                        child: Card(
                                                          elevation: 15,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              side: BorderSide(
                                                                  color: Provider.of<
                                                                              ThemeDataHomePage>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .borderTextAppBarColor,
                                                                  width: 1)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              ClipRRect(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              15),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              15)),
                                                                  child: Image(
                                                                    image: AssetImage(
                                                                        'assets/ProjectImages/MenuIcon/${map['ImageName']}.png'),
                                                                    height: 50,
                                                                  )),
                                                              Center(
                                                                child: Text(
                                                                  map["MenuName"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: homeSliderValue ==
                                                                            3
                                                                        ? 12
                                                                        : homeSliderValue ==
                                                                                4
                                                                            ? 10
                                                                            : 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Provider.of<ThemeDataHomePage>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .borderTextAppBarColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          int salePur1ID = 0;
                                                          if (map["MenuName"] ==
                                                              'Counter Sales') {
                                                            var dropDownMap = {
                                                              "ID": 1,
                                                              'Title': 'Sales',
                                                              'SubTitle': "SL",
                                                              "Value": ''
                                                            };
                                                            salePur1ID = await _salePurSQLDataBase.insertSalePur1(
                                                                currentDate
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10),
                                                                SharedPreferencesKeys
                                                                        .prefs!
                                                                        .getInt(
                                                                            SharedPreferencesKeys.defaultSaleTwoAccount) ??
                                                                    0,
                                                                'remarks',
                                                                'person',
                                                                'paymentAfterDate',
                                                                'contactNo',
                                                                dropDownMap);
                                                          }

                                                          print(
                                                              '..................................$salePur1ID');

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SubMenuPage(
                                                                salePurID:
                                                                    salePur1ID,
                                                                menuName: map[
                                                                    "MenuName"],
                                                                valuePass: map[
                                                                    'ValuePass'],
                                                                pageOpen: map[
                                                                    'PageOpen'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: Provider.of<
                                                            ClientAccountProvider>(
                                                        context,
                                                        listen: false)
                                                    .projectTableDetailList
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  // String menuImagesFolderPath =
                                                  //     '$dir/ProjectImages/MenuIcon/';
                                                  Map map = Provider.of<
                                                              ClientAccountProvider>(
                                                          context,
                                                          listen: false)
                                                      .projectTableDetailList[index];
                                                  return InkWell(
                                                    child: Card(
                                                      elevation: 3,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 18.0),
                                                            child: ClipRRect(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            15),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            15)),
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      'assets/ProjectImages/MenuIcon/${map['ImageName']}.png'),
                                                                  height: 50,
                                                                )),
                                                          ),
                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          8.0),
                                                              child: Text(
                                                                map["MenuName"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      if (SharedPreferencesKeys
                                                                  .prefs!
                                                                  .getInt(SharedPreferencesKeys
                                                                      .projectId) ==
                                                              null ||
                                                          SharedPreferencesKeys
                                                                  .prefs!
                                                                  .getInt(SharedPreferencesKeys
                                                                      .projectId) ==
                                                              0) {
                                                      } else {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    SubMenuPage(
                                                              menuName: map[
                                                                  "MenuName"],
                                                              valuePass: map[
                                                                  'ValuePass'],
                                                              pageOpen: map[
                                                                  'PageOpen'],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }),

                    Row(
                      children: [
                        popUpButtonForItemEdit(onSelected: (value) {
                          if (value == 0) {
                            setState(() {
                              homePageViews = 'GridView';
                              SharedPreferencesKeys.prefs!
                                  .setString('HomeSliderView', homePageViews);
                            });
                          }
                          if (value == 1) {
                            setState(() {
                              homePageViews = 'ListView';
                              SharedPreferencesKeys.prefs!
                                  .setString('HomeSliderView', homePageViews);
                            });
                          }
                          if (value == 2) {
                            homePageViews = 'TreeView';
                            SharedPreferencesKeys.prefs!
                                .setString('HomeSliderView', homePageViews);
                          }
                        }),
                        IconButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: StatefulBuilder(
                                        builder: (context, State) => Container(
                                          height: 80,
                                          width: 300,
                                          alignment: Alignment.center,
                                          child: Material(
                                            child: Slider(
                                                value: SharedPreferencesKeys
                                                    .prefs!
                                                    .getDouble('slidValue')!,
                                                min: 1.0,
                                                max: MediaQuery.of(context)
                                                            .size
                                                            .width <
                                                        420
                                                    ? 3.0
                                                    : 6,
                                                onChanged: (double value) {
                                                  State(() {});
                                                  setState(() {
                                                    homeSliderValue =
                                                        value.toInt();
                                                  });
                                                  SharedPreferencesKeys.prefs!
                                                      .setDouble(
                                                          'slidValue',
                                                          homeSliderValue
                                                              .toDouble());
                                                }),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            icon: Icon(Icons.settings)),
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      icon: Icon(
        Icons.more_vert_rounded,
        size: 20,
        color: Colors.grey,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('GridView')),
          PopupMenuItem(value: 1, child: Text('ListView')),
          PopupMenuItem(value: 2, child: Text('TreeView')),
        ];
      },
    );
  }
}

Future<void> themeColorDataPickerForProject(BuildContext context) async {
  Provider.of<ThemeDataHomePageForProject>(context, listen: false)
      .backGroundColor = SharedPreferencesKeys.prefs!
              .getInt(SharedPreferencesKeys.projectIdForProject) ==
          4
      ? Colors.brown.shade100
      : SharedPreferencesKeys.prefs!
                  .getInt(SharedPreferencesKeys.projectIdForProject) ==
              3
          ? Colors.orange.shade100
          : SharedPreferencesKeys.prefs!
                      .getInt(SharedPreferencesKeys.projectIdForProject) ==
                  2
              ? Colors.blue.shade100
              : Colors.white;

  Provider.of<ThemeDataHomePageForProject>(context, listen: false)
      .borderTextAppBarColor = SharedPreferencesKeys.prefs!
              .getInt(SharedPreferencesKeys.projectIdForProject) ==
          4
      ? Colors.brown.shade900
      : SharedPreferencesKeys.prefs!
                  .getInt(SharedPreferencesKeys.projectIdForProject) ==
              3
          ? Colors.orange.shade900
          : SharedPreferencesKeys.prefs!
                      .getInt(SharedPreferencesKeys.projectIdForProject) ==
                  2
              ? Colors.blue.shade900
              : Colors.blue;
}

Future<void> themeColorDataPickerForProjectMenu(BuildContext context) async {
  Provider.of<ThemeDataHomePage>(context, listen: false).backGroundColor =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.projectId) == 4
          ? Colors.brown.shade100
          : SharedPreferencesKeys.prefs!
                      .getInt(SharedPreferencesKeys.projectId) ==
                  3
              ? Colors.orange.shade100
              : SharedPreferencesKeys.prefs!
                          .getInt(SharedPreferencesKeys.projectId) ==
                      2
                  ? Colors.blue.shade100
                  : Colors.white;

  Provider.of<ThemeDataHomePage>(context, listen: false).borderTextAppBarColor =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.projectId) == 4
          ? Colors.brown.shade900
          : SharedPreferencesKeys.prefs!
                      .getInt(SharedPreferencesKeys.projectId) ==
                  3
              ? Colors.orange.shade900
              : SharedPreferencesKeys.prefs!
                          .getInt(SharedPreferencesKeys.projectId) ==
                      2
                  ? Colors.blue.shade900
                  : Colors.blue;

  Provider.of<ThemeDataHomePage>(context, listen: false).projectIconURL =
      '${ApiConstants.baseUrl}/PhpApi1/ProjectImages/ProjectsLogo/${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.projectId)}.png';

  List listOfProjectName =
      await Provider.of<DashboardProvider>(context, listen: false)
          .getProjectName(SharedPreferencesKeys.prefs!
              .getInt(SharedPreferencesKeys.projectId)
              .toString());

  if (listOfProjectName.length > 0) {
    Provider.of<ThemeDataHomePage>(context, listen: false).projectName =
        listOfProjectName[0]['ProjectName'];
  }
}
