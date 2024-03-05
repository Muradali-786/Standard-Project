import 'dart:io';
import 'package:com/pages/general_trading/Accounts/Account3Name.dart';
import 'package:com/pages/general_trading/CashBook/CashBookEntryDialogUI.dart';
import 'package:com/pages/general_trading/Items/Item2Group.dart';
import 'package:com/pages/general_trading/Items/Item3Name.dart';
import 'package:com/pages/home/project_detail_page.dart';
import 'package:com/pages/home/project_menu_dashboard_page.dart';
import 'package:com/pages/login/create_account_default_data_calling_provider.dart';
import 'package:com/pages/login/firebase_mobile_no_auth_design.dart';
import 'package:com/pages/login/login_selection_design.dart';
import 'package:com/pages/material/datepickerstyle1.dart';
import 'package:com/pages/material/datepickerstyle2.dart';
import 'package:com/pages/material/grid_column_quantity_picker.dart';
import 'package:com/pages/material/pdf_preview_page.dart';
import 'package:com/pages/material/table_view_page.dart';
import 'package:com/pages/sqlite_data_views/group_by_page.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/pages/sqlite_data_views/table_detail_design_page.dart';
import 'package:com/pages/sqlite_data_views/testing_button_page.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:com/utils/show_inserting_table_row_server.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdfViewer;
import 'package:provider/provider.dart';
import 'config/values.dart';
import 'main/tab_bar_pages/home/Dashboard.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      Provider.of<DatabaseProvider>(context, listen: false).init();
    }

    return


      // FutureBuilder<bool>(
      // future: Provider.of<MySqlProvider>(context, listen: false)
      //     .connectToServerDb(),
      // builder: (context, snapshot) {
      //   if(snapshot.hasData) {
      //     return snapshot.data! ?
          FutureBuilder(
            future: kIsWeb
                ? Future.delayed(Duration.zero)
                : Provider.of<SplashDataProvider>(context, listen: false)
                .callSplashApis(context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    navigatorKey: Values.navigatorKey,
                    home: Splash());
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Sqlite Db',
                  navigatorKey: Values.navigatorKey,
                  initialRoute: '/',
                  home: kIsWeb
                      ? (SharedPreferencesKeys.prefs!.getString(
                      SharedPreferencesKeys.countryClientId) ==
                      null &&
                      SharedPreferencesKeys.prefs!.getString(
                          SharedPreferencesKeys.clientUserId) ==
                          null)
                      ? LoginSelection()
                      : ListWidget()
                      : (Platform.isWindows || Platform.isLinux ||
                      Platform.isMacOS)
                      ? (SharedPreferencesKeys.prefs!.getString(
                      SharedPreferencesKeys.countryClientId) ==
                      null &&
                      SharedPreferencesKeys.prefs!.getString(
                          SharedPreferencesKeys.clientUserId) ==
                          null)
                      ? LoginSelection()
                      : ListWidget()
                      : (Platform.isAndroid || Platform.isIOS)
                      ? FutureBuilder(
                    future: Firebase.initializeApp(),
                    builder: (BuildContext context,
                        AsyncSnapshot<FirebaseApp> snapshot) {
                      if (snapshot.hasError) {
                        return Text("SomeThing went wrong");
                      } else if (snapshot.hasData) {
                        if (SharedPreferencesKeys.prefs!.getString(
                            SharedPreferencesKeys
                                .countryClientId) ==
                            null &&
                            SharedPreferencesKeys.prefs!.getString(
                                SharedPreferencesKeys
                                    .clientUserId) ==
                                null) {
                          return LoginSelection();
                        } else {
                          //return Dashboard();
                          return ListWidget();
                        }
                      }
                      return CircularProgressIndicator();
                    },
                  )
                      : (SharedPreferencesKeys.prefs!.getString(
                      SharedPreferencesKeys
                          .countryClientId) ==
                      null &&
                      SharedPreferencesKeys.prefs!.getString(
                          SharedPreferencesKeys.clientUserId) ==
                          null)
                      ? LoginSelection()
                      : ListWidget(),
                  onGenerateRoute: (RouteSettings settings) {
                    var routes = <String, WidgetBuilder>{
                      "/account3_name": (ctx) =>
                          Account3Name(
                            settings.arguments as List,
                          ),
                      '/home_page': (context) => HomePage(),
                      '/table_view_page': (context) => TableViewPage(),
                      '/table_detail_page': (context) => TableDetailPage(),
                      '/pdf_preview_page': (context) =>
                          PdfPreviewPage(
                            args: settings.arguments as pdfViewer.Document,
                          ),
                      '/column_slider': (context) =>
                          ColumnSlider(
                            totalColumns: 2,
                          ),
                      '/group_by_page': (context) =>
                          GroupByPage(columnName: settings.arguments as String),
                      //'/home_page':(context)=>HomePage(),
                      //'/dashboard_home_page':(context)=>DashboardHomePage(),
                      //'/dashboard_page': (context) => Dashboard(),
                      '/project_menu_dashboard_page': (context) =>
                          ProjectMenuDashboardPage(),
                      '/phone_number_auth_form': (context) =>
                          PhoneNumberAuthForm(),
                      '/login_selection_page': (context) => LoginSelection(),
                      //'/account2_group': (context) => Account2GroupDesign(),
                      '/item2_group': (context) => Item2Group(),
                      '/item3_name': (context) => Item3Name(),
                      '/cash_book': (context) =>
                          CashBook(
                            context: context,
                            list: settings.arguments as List,
                          ),
                      '/project_detail_page': (context) => ProjectDetailPage(),
                      '/database_Picker_Style_1': (context) =>
                          DatePickerStyle1(),
                      '/database_Picker_Style_2': (context) =>
                          DatePickerStyle2(),
                    };
                    WidgetBuilder? builder = routes[settings.name];
                    return MaterialPageRoute(builder: (ctx) => builder!(ctx));
                  },
                );
              }
            },
          );
        //       :
        //   MaterialApp(
        //     debugShowCheckedModeBanner: false,
        //     home: Container(
        //       color: Colors.white,
        //       child: TextButton(onPressed: (){
        //         setState(() {});
        //       }, child: Text('NetWork Connection Failed To Connect \n Click Here To Try Again', textAlign: TextAlign.center),),
        //     ),
        //   );
        // }else{
        //   return SizedBox();
        // }
     //},

  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<ShowInsertingTableRowTOServer>(
          builder: (context, value, child) =>  Container(
            padding: EdgeInsets.all(20),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 40),
                      Text('Processing Data From Server !! :'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${value.tableName}'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${value.status}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${value.totalNumberOfRow.toString()}/'),
                              Text('${value.count.toString()}'),
                            ],
                          ),
                        ],
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
}

class OfflineState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Text("Not connected to internet"),
        ),
      ),
    );
  }
}

class Online extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnlineState();
  }
}

class OnlineState extends State<Online> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
