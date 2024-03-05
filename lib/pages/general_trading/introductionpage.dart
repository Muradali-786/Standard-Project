import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/pages/material/Toast.dart';

// import 'package:com/pages/restaurant/ResturantRefreshing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:com/main/tab_bar_pages/home/themedataclassforproject.dart';
import 'package:com/pages/general_trading/introductionclientPage.dart';
import 'package:com/pages/login/create_client.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Server/RefreshDataProvider.dart';
import '../../main/tab_bar_pages/home/Dashboard.dart';
import '../../main/tab_bar_pages/home/home_page.dart';
import '../../main/tab_bar_pages/home/home_page_code_provider.dart';
import '../../main/tab_bar_pages/home/themedataclass.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../shared_preferences/shared_preference_keys.dart';
import '../beauty_salon/refreshing_beauty_salon.dart';
import '../marriage_hall_booking/refreshing_marriage_hall.dart';
import '../patient_care_system/refeshing_patient_care_system.dart';
import '../school/refreshing.dart';
import '../tailor_shop_systom/refreshing_tailor_shop.dart';
import 'Accounts/AccountLedger.dart';

typedef Null ItemSelectedCallback(Widget value);

class IntroductionPage extends StatefulWidget {
  final ItemSelectedCallback? onItemSelected;
  final String title;
  final int projectID;
  final String createClientFor;

  const IntroductionPage({
    Key? key,
    this.onItemSelected,
    required this.title,
    required this.projectID,
    required this.createClientFor,
  }) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  PdfViewerController _pdfViewerController = PdfViewerController()
    ..zoomLevel = 2;
  SchServerRefreshing _schServerRefreshing = SchServerRefreshing();
  RefreshingBeautySalon refreshingBeautySalon = RefreshingBeautySalon();
  RefreshingMarriageHall refreshingMarriageHall = RefreshingMarriageHall();
  RefreshingPatientCareSystem refreshingPatientCareSystem =
      RefreshingPatientCareSystem();
  RefreshingTailorShop refreshingTailorShop = RefreshingTailorShop();

  CollectionReference country =
      FirebaseFirestore.instance.collection('Country');

  String dropdownValue = 'English';

  double currentLNG = 0;
  double currentLAT = 0;

  Location _location = Location();

  @override
  void initState() {
    super.initState();
    _location.requestPermission().then((PermissionStatus permissionStatus) => {
          _location.getLocation().then((value) {
            currentLNG = value.longitude!;
            currentLAT = value.latitude!;
            setState(() {});
          })
        });
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
        actions: [
          CachedNetworkImage(
            imageUrl:
                'https://www.api.easysoftapp.com/PhpApi1/ProjectImages/ProjectsLogo/${widget.projectID}.png',
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
        ],
        title: Text(
          widget.title,
          maxLines: 2,
        ),
        centerTitle: true,
      ),
      body: Consumer<ThemeDataHomePageForProject>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              key: UniqueKey(),
              children: [
                InkWell(
                    onTap: () {
                      if (Platform.isWindows) {
                        // widget.onItemSelected!(
                        //     CreateClient(
                        //         listOFClient: [],
                        //         status: 'ADD',
                        //         projectId: widget.projectID,
                        //         projectName: widget.title)
                        // );
                        noAvailableFeature(context);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateClient(
                                  listOFClient: [],
                                  status: 'ADD',
                                  projectId: widget.projectID,
                                  projectName: widget.title),
                            ));
                      }
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.create_new_folder,
                              color: Colors.yellow.shade200,
                              size: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                /// user login ////
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FutureBuilder(
                      future:
                          Provider.of<DashboardProvider>(context, listen: false)
                              .getClientTableById(widget.projectID.toString()),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          return ExpansionTile(
                            iconColor: Provider.of<ThemeDataHomePageForProject>(
                                    context,
                                    listen: false)
                                .backGroundColor,
                            initiallyExpanded: true,
                            collapsedIconColor:
                                Provider.of<ThemeDataHomePageForProject>(
                                        context,
                                        listen: false)
                                    .backGroundColor,
                            backgroundColor:
                                Provider.of<ThemeDataHomePageForProject>(
                                        context,
                                        listen: false)
                                    .borderTextAppBarColor,
                            collapsedBackgroundColor:
                                Provider.of<ThemeDataHomePageForProject>(
                                        context,
                                        listen: false)
                                    .borderTextAppBarColor,
                            title: Row(
                              children: [
                                Icon(
                                  Icons.key,
                                  color: Colors.green,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    'Login With',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => InkWell(
                                      onTap: () async {
                                        print(snapshot.data!);
                                        if (snapshot.data![index]
                                                ['UserRights'] ==
                                            'Statement View Only') {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountLedger(
                                                accountId: snapshot.data![index]
                                                    ['ClientUserID'],
                                              ),
                                            ),
                                          );
                                        } else {
                                          Provider.of<ThemeDataHomePage>(
                                                      context,
                                                      listen: false)
                                                  .projectIconURL =
                                              'https://www.api.easysoftapp.com/PhpApi1/ProjectImages/ProjectsLogo/${widget.projectID}.png';

                                          Provider.of<ThemeDataHomePage>(
                                                  context,
                                                  listen: false)
                                              .projectName = widget.title;

                                          SharedPreferencesKeys.prefs!
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .countryClientID2,
                                                snapshot.data![index]
                                                    ['CountryClientID'])
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .countryUserId2,
                                                snapshot.data![index]
                                                    ['CountryUserID'])
                                            ..setString(
                                                'SingleView', 'SingleView')
                                            ..setInt(
                                                SharedPreferencesKeys.clinetId,
                                                int.parse(snapshot.data![index]
                                                        ['ClientID']
                                                    .toString()))
                                            ..setInt(
                                                SharedPreferencesKeys
                                                    .clientUserId,
                                                int.parse(kIsWeb
                                                    ? snapshot.data![index]
                                                            ['UserID']
                                                        .toString()
                                                    : snapshot.data![index]
                                                            ['ClientUserID']
                                                        .toString()))
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .companyName,
                                                snapshot.data![index]
                                                    ['CompanyName'])
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .companyAddress,
                                                snapshot.data![index]
                                                        ['CompanyAddress']
                                                    .toString())
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .companyNumber,
                                                snapshot.data![index]
                                                        ['CompanyNumber']
                                                    .toString())
                                            ..setString(
                                                SharedPreferencesKeys.website,
                                                snapshot.data![index]
                                                    ['WebSite'])
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .emailClient,
                                                snapshot.data![index]['Email'])
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .nameOfPersonOwner,
                                                snapshot.data![index]
                                                    ['NameOfPerson'])
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .bussinessDescription,
                                                snapshot.data![index]
                                                        ['BusinessDescriptions']
                                                    .toString())
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .userRightsClient,
                                                snapshot.data![index]
                                                        ['UserRights'] ??
                                                    'N/A')
                                            ..setString(
                                                SharedPreferencesKeys.netcode,
                                                snapshot.data![index]['NetCode']
                                                    .toString())
                                            ..setString(
                                                SharedPreferencesKeys.sysCode,
                                                snapshot.data![index]['SysCode']
                                                    .toString())
                                            ..setInt(
                                                SharedPreferencesKeys.projectId,
                                                int.parse(snapshot.data![index]
                                                        ["ProjectID"]
                                                    .toString()))
                                            ..setString(
                                                SharedPreferencesKeys
                                                    .subMenuQuery,
                                                '0')
                                            ..setString(
                                                'UserName',
                                                snapshot.data![index]
                                                    ["UserName"]);
                                          themeColorDataPickerForProjectMenu(
                                              context);

                                          if (!kIsWeb) {
                                            List list2 = await Provider.of<
                                                        DashboardProvider>(
                                                    context,
                                                    listen: false)
                                                .checkAccount3Name(
                                                    SharedPreferencesKeys.prefs!
                                                        .getInt(
                                                            SharedPreferencesKeys
                                                                .clinetId)
                                                        .toString());

                                            if (SharedPreferencesKeys.prefs!
                                                    .getInt(
                                                        SharedPreferencesKeys
                                                            .projectId) !=
                                                0) {
                                              if (list2.length == 0) {
                                                if (Provider.of<ThemeDataHomePage>(
                                                            context,
                                                            listen: false)
                                                        .projectName ==
                                                    'Beauty Salon') {
                                                  await refreshingBeautySalon
                                                      .getAllUpdatedDataFromServer(
                                                          context);

                                                  await Provider.of<
                                                              RefreshDataProvider>(
                                                          context,
                                                          listen: false)
                                                      .getAllUpdatedDataFromServer(
                                                          context, false);
                                                } else if (Provider.of<
                                                                ThemeDataHomePage>(
                                                            context,
                                                            listen: false)
                                                        .projectName ==
                                                    'Marriage Hall Booking') {
                                                  refreshingMarriageHall
                                                      .getAllUpdatedDataFromServer(
                                                          context);

                                                  await Provider.of<
                                                              RefreshDataProvider>(
                                                          context,
                                                          listen: false)
                                                      .getAllUpdatedDataFromServer(
                                                          context, false);
                                                } else if (Provider.of<
                                                                ThemeDataHomePage>(
                                                            context,
                                                            listen: false)
                                                        .projectName ==
                                                    'Patient Care System') {
                                                  refreshingPatientCareSystem
                                                      .getAllUpdatedDataFromServer(
                                                          context);

                                                  await Provider.of<
                                                              RefreshDataProvider>(
                                                          context,
                                                          listen: false)
                                                      .getAllUpdatedDataFromServer(
                                                          context, false);
                                                } else if (Provider.of<
                                                                ThemeDataHomePage>(
                                                            context,
                                                            listen: false)
                                                        .projectName ==
                                                    'Tailor Shop ') {
                                                  refreshingTailorShop
                                                      .getAllUpdatedDataFromServer(
                                                          context);

                                                  await Provider.of<
                                                              RefreshDataProvider>(
                                                          context,
                                                          listen: false)
                                                      .getAllUpdatedDataFromServer(
                                                          context, false);
                                                } else {
                                                  await Provider.of<
                                                              RefreshDataProvider>(
                                                          context,
                                                          listen: false)
                                                      .getAllUpdatedDataFromServer(
                                                          context, false);
                                                  await _schServerRefreshing
                                                      .getAllUpdatedDataFromServer(
                                                    context,
                                                  );
                                                }
                                                // await _refreshing
                                                //     .getAllUpdatedDataFromServer(
                                                //         context);
                                              }
                                            }
                                          }

                                          country
                                              .doc(
                                                  '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                                              .collection('CountryUser')
                                              .doc(
                                                  '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                                              .collection('Client')
                                              .doc(
                                                  '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId).toString()}')
                                              .set({
                                            'Company Name':
                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyName)}',
                                            'Company Address':
                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyAddress)}',
                                            'Company Number':
                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.companyNumber)}',
                                            'Company Description':
                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.bussinessDescription)}',
                                          });

                                          country
                                              .doc(
                                                  '${SharedPreferencesKeys.prefs!.getString('CountryName')}')
                                              .collection('CountryUser')
                                              .doc(
                                                  '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryClientId)}')
                                              .collection('Client')
                                              .doc(
                                                  '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId).toString()}')
                                              .collection('ClientUser')
                                              .doc(
                                                  '${SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clientUserId)}')
                                              .set({
                                            'Client User Name':
                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.nameOfPersonOwner)}',
                                            'Mobile number':
                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.mobileNumber)}',
                                            'User Right':
                                                '${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.userRightsClient)}',
                                          });

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListWidget()));
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Provider.of<
                                                        ThemeDataHomePageForProject>(
                                                    context,
                                                    listen: false)
                                                .backGroundColor,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                                height: 50,
                                                width: 50,
                                                imageUrl:
                                                    'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${snapshot.data![index]['ClientID']}',
                                                alignment: Alignment.center,
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
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
                                          title: Text(
                                            snapshot.data![index]
                                                ['CompanyName'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                              '${snapshot.data![index]['UserRights']} '),
                                        ),
                                      ),
                                    )),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                ),

                ///  user ///////////////////////
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FutureBuilder(
                      future: kIsWeb
                          ? Provider.of<DashboardProvider>(context,
                                  listen: false)
                              .getClientTableById(widget.projectID.toString())
                          : Provider.of<DashboardProvider>(context,
                                  listen: false)
                              .getClientFromServer(
                                  widget.projectID.toString(), context),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          snapshot.data!.forEach((element) {
                            if (element['Lng'].toString().isNotEmpty) {
                              element['Lng'] =
                                  calculateDistance(element['Lng'].toString())
                                      .toStringAsFixed(1);
                            } else {
                              element['Lng'] = '0';
                            }
                          });

                          snapshot.data!.sort((a, b) =>
                              double.parse(a['Lng'].toString()).compareTo(
                                  double.parse(b['Lng'].toString())));

                          return ExpansionTile(
                            iconColor: Provider.of<ThemeDataHomePageForProject>(
                                    context,
                                    listen: false)
                                .backGroundColor,
                            initiallyExpanded: true,
                            collapsedIconColor:
                                Provider.of<ThemeDataHomePageForProject>(
                                        context,
                                        listen: false)
                                    .backGroundColor,
                            backgroundColor:
                                Provider.of<ThemeDataHomePageForProject>(
                                        context,
                                        listen: false)
                                    .borderTextAppBarColor,
                            collapsedBackgroundColor:
                                Provider.of<ThemeDataHomePageForProject>(
                                        context,
                                        listen: false)
                                    .borderTextAppBarColor,
                            title: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.person_2_fill,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Your Nearest ${widget.title}',
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => InkWell(
                                      onTap: () {
                                        // print(snapshot.data!);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  IntroductionClientPage(
                                                clientID: snapshot.data![index]
                                                    ['ClientID'],
                                                projectName: widget.title,
                                                projectID: widget.projectID,
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Provider.of<
                                                        ThemeDataHomePageForProject>(
                                                    context,
                                                    listen: false)
                                                .backGroundColor,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                                height: 50,
                                                width: 50,
                                                imageUrl:
                                                    'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/ClientLogo/${snapshot.data![index]['ClientID']}',
                                                alignment: Alignment.center,
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
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
                                          title: Text(
                                            snapshot.data![index]
                                                ['CompanyName'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                              '${snapshot.data![index]['Country']} , ${snapshot.data![index]['City']}'),
                                          trailing: snapshot.data![index]['Lng']
                                                  .toString()
                                                  .isEmpty
                                              ? Text('')
                                              : Text(
                                                  '${snapshot.data![index]['Lng'].toString()} KM'),
                                        ),
                                      ),
                                    )),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FutureBuilder(
                      future:
                          Provider.of<DashboardProvider>(context, listen: false)
                              .getALLURLForYouTubeVideo(
                                  widget.projectID.toString(), context),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          return ExpansionTile(
                              iconColor:
                                  Provider.of<ThemeDataHomePageForProject>(
                                          context,
                                          listen: false)
                                      .backGroundColor,
                              collapsedIconColor:
                                  Provider.of<ThemeDataHomePageForProject>(
                                          context,
                                          listen: false)
                                      .backGroundColor,
                              backgroundColor:
                                  Provider.of<ThemeDataHomePageForProject>(
                                          context,
                                          listen: false)
                                      .borderTextAppBarColor,
                              collapsedBackgroundColor:
                                  Provider.of<ThemeDataHomePageForProject>(
                                          context,
                                          listen: false)
                                      .borderTextAppBarColor,
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.red,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      'Training Video',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                FutureBuilder<List>(
                                  future: Provider.of<DashboardProvider>(
                                          context,
                                          listen: false)
                                      .getALLURLForYouTubeVideoIntro(
                                          widget.projectID.toString(), context),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return InkWell(
                                        onTap: () async {
                                          Uri _url = Uri.parse(snapshot.data![0]
                                                  ['ProjectVideo']
                                              .toString());
                                          await launchUrl(_url);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Provider.of<
                                                          ThemeDataHomePageForProject>(
                                                      context,
                                                      listen: false)
                                                  .backGroundColor,
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey))),
                                          child: ListTile(
                                            title: Text(
                                                '${snapshot.data![0]['ProjectName'].toString()}'),
                                            subtitle: Text(
                                              'Introduction',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            leading: Icon(
                                              Icons.play_circle_outline,
                                              color: Colors.red,
                                              size: 45,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Provider.of<
                                                  ThemeDataHomePageForProject>(
                                              context,
                                              listen: false)
                                          .backGroundColor,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        width: 2,
                                        color: Provider.of<
                                                    ThemeDataHomePageForProject>(
                                                context,
                                                listen: false)
                                            .borderTextAppBarColor,
                                      )),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 2 / 2.5,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20),
                                    itemBuilder: (context, index) {
                                      List list = snapshot.data!;
                                      list.sort((a, b) =>
                                          a["SortBy"].compareTo(b["SortBy"]));
                                      Map map = list[index];
                                      return InkWell(
                                        child: Card(
                                          elevation: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              side: BorderSide(
                                                  color: Provider.of<
                                                              ThemeDataHomePageForProject>(
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
                                                  imageUrl: map['ImageURL']
                                                      .toString(),
                                                  height: 50,
                                                  width: 50,
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
                                                    height: 50,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.play_arrow_rounded,
                                                color: Colors.red,
                                              ),
                                              Center(
                                                child: Text(
                                                  map["MenuName"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Provider.of<
                                                                ThemeDataHomePageForProject>(
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
                                          Uri _url = Uri.parse(
                                              map['ProjectMenuVideo']
                                                  .toString());
                                          await launchUrl(_url);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ]);
                        } else {
                          return SizedBox();
                        }
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ExpansionTile(
                      iconColor: Provider.of<ThemeDataHomePageForProject>(
                              context,
                              listen: false)
                          .backGroundColor,
                      collapsedIconColor:
                          Provider.of<ThemeDataHomePageForProject>(context,
                                  listen: false)
                              .backGroundColor,
                      backgroundColor: Provider.of<ThemeDataHomePageForProject>(
                              context,
                              listen: false)
                          .borderTextAppBarColor,
                      collapsedBackgroundColor:
                          Provider.of<ThemeDataHomePageForProject>(context,
                                  listen: false)
                              .borderTextAppBarColor,
                      title: Row(
                        children: [
                          Icon(
                            Icons.menu_book,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              'About',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          color: Provider.of<ThemeDataHomePageForProject>(
                                  context,
                                  listen: false)
                              .backGroundColor,
                          child: DropdownButton<String>(
                            dropdownColor:
                                Provider.of<ThemeDataHomePageForProject>(
                                        context,
                                        listen: false)
                                    .backGroundColor,
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;

                                // viewStatusPDF = '';

                                //   viewStatusPDF = newValue;
                              });
                            },
                            items: <String>['English', 'Urdu']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                            height: 400,
                            alignment: Alignment.center,
                            child: SfPdfViewer.network(
                              'https://api.easysoftapp.com/PhpApi1/ProjectProfile/${widget.title.replaceAll(' ', '')}/$dropdownValue.pdf',
                              controller: _pdfViewerController,
                            ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ExpansionTile(
                      iconColor: Provider.of<ThemeDataHomePageForProject>(
                              context,
                              listen: false)
                          .backGroundColor,
                      collapsedIconColor:
                          Provider.of<ThemeDataHomePageForProject>(context,
                                  listen: false)
                              .backGroundColor,
                      backgroundColor: Provider.of<ThemeDataHomePageForProject>(
                              context,
                              listen: false)
                          .borderTextAppBarColor,
                      collapsedBackgroundColor:
                          Provider.of<ThemeDataHomePageForProject>(context,
                                  listen: false)
                              .borderTextAppBarColor,
                      title: Row(
                        children: [
                          Icon(
                            Icons.privacy_tip,
                            color: Colors.yellow,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              'Privacy policy',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Container(
                            height: 400,
                            alignment: Alignment.center,
                            child: SfPdfViewer.network(
                              'https://api.easysoftapp.com/PhpApi1/ProjectProfile/PrivacyPolicies.pdf',
                              controller: _pdfViewerController,
                            ))
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculateDistance(String location) {
    if (location.isEmpty) {
      // Handle null or empty input string
      return 0.0; // Or any appropriate default value
    }

    List<String> list = location.split(',');
    if (list.length < 2) {
      // Handle case where location string doesn't contain both latitude and longitude
      return 0.0; // Or any appropriate default value
    }
    double lat2, lon2;
    try {
      lat2 = double.parse(list.last.trim());
      lon2 = double.parse(list.first.trim());
    } catch (e) {
      // Handle parsing errors
      print("Error parsing latitude or longitude: $e");
      return 0.0; // Or any appropriate default value
    }

    // this is the code for previous implementation
    // List<String> list = location.split(',');
    // double lat2 = double.parse(list.last.toString());
    // double lon2 = double.parse(list.first.toString());
    const double earthRadius = 6371.0; // Earth's radius in kilometers

    // Convert latitude and longitude from degrees to radians
    final double lat1Rad = degreesToRadians(currentLAT);
    final double lon1Rad = degreesToRadians(currentLNG);
    final double lat2Rad = degreesToRadians(lat2);
    final double lon2Rad = degreesToRadians(lon2);

    // Haversine formula
    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;
    final double a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c; // Distance in kilometers

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  Widget popUpButtonForItemEdit({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      icon: Icon(
        Icons.more_horiz,
        size: 20,
        color: Colors.grey,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text('English')),
          PopupMenuItem(value: 1, child: Text('Urdu')),
          // PopupMenuItem(value: 1, child: Text('Delete')),
        ];
      },
    );
  }
}
