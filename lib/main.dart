import 'dart:io';
import 'package:com/app.dart';
import 'package:com/main/tab_bar_pages/chat/Controller/provider.dart';
import 'package:com/pages/login/create_account_and_login_code_provider.dart';
import 'package:com/pages/login/create_account_default_data_calling_provider.dart';
import 'package:com/pages/login/firebase_auth_provider.dart';
import 'package:com/pages/material/pdf_provider.dart';
import 'package:com/pages/place_finder_from_map/status_search.dart';
import 'package:com/pages/restaurant/resturantSQL.dart';
import 'package:com/pages/restaurant/total_amount.dart';
import 'package:com/pages/school/Sch5SectionStudrent.dart';
import 'package:com/pages/school/modelFeeDue.dart';
import 'package:com/pages/school/modelclasseducation.dart';
import 'package:com/pages/school/modelschoolbranch.dart';
import 'package:com/pages/school/modelsection.dart';
import 'package:com/pages/school/modelsectionstudent.dart';
import 'package:com/pages/school/modelshowyearlistview.dart';
import 'package:com/pages/school/modelyeareducation.dart';
import 'package:com/pages/sqlite_data_views/sqlite_database_code_provider.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:com/utils/show_inserting_table_row_server.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Server/RefreshDataProvider.dart';
import 'Server/create_client.dart';
import 'Server/mysql_provider.dart';
// import 'main/tab_bar_pages/chat/Controller/service_notification.dart';
import 'main/tab_bar_pages/home/clientAccount_code_provider.dart';
import 'main/tab_bar_pages/home/home_page_code_provider.dart';
import 'main/tab_bar_pages/home/themedataclass.dart';
import 'main/tab_bar_pages/home/themedataclassforproject.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp();
    } else {
      sqfliteFfiInit();
    }
  }
  SharedPreferencesKeys.prefs = await SharedPreferences.getInstance();

  /// for web
  if (kIsWeb) {
    debugPrint('------------- for web ------------');
    if (SharedPreferencesKeys.prefs?.getString(
            SharedPreferencesKeys.initializeFirebaseFirstTimeForWeb) ==
        null) {
      await Firebase.initializeApp(
        name: 'EasySoftWeb',
        options: FirebaseOptions(
          apiKey: 'AIzaSyD-4-L6w43BslULEg8whquomhbJDXeCVMg',
          appId: '1:962502297218:web:6c8f7cbe55d806bd01569b',
          messagingSenderId: '962502297218',
          projectId: 'easysoft-a4d6e',
        ),
      );

      SharedPreferencesKeys.prefs!.setString(
          SharedPreferencesKeys.initializeFirebaseFirstTimeForWeb, "true");
    }
  } else if (Platform.isAndroid || Platform.isIOS) {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    if (SharedPreferencesKeys.prefs?.getString(
            SharedPreferencesKeys.initializeFirebaseFirstTimeForMobile) ==
        null) {
      debugPrint('------------- for mobile------------');
      var res = SharedPreferencesKeys.prefs?.getString(
          SharedPreferencesKeys.initializeFirebaseFirstTimeForMobile);
      debugPrint(res);
      await Firebase.initializeApp(
        name: 'EasySoftMobile',
        options: FirebaseOptions(
          apiKey: 'AIzaSyD-4-L6w43BslULEg8whquomhbJDXeCVMg',
          appId: '1:962502297218:android:f433b550771fa95c01569b',
          messagingSenderId: '962502297218',
          projectId: 'easysoft-a4d6e',
        ),
      );

      SharedPreferencesKeys.prefs?.setString(
          SharedPreferencesKeys.initializeFirebaseFirstTimeForMobile, "true");
    } else {
      debugPrint('------------- for mobile else------------');
      var res = SharedPreferencesKeys.prefs?.getString(
          SharedPreferencesKeys.initializeFirebaseFirstTimeForMobile);
      debugPrint(res);
    }

    // final service = LocalNotificationService();
    // await service.intialize();

    var per = await FirebaseMessaging.instance.requestPermission();

    if (per.authorizationStatus == AuthorizationStatus.authorized) {
      print('...........................Notification is initialized!!!!!!!');

      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   print('Got a message whilst in the foreground!');
      //   print('Message data: ${message.data}');
      //
      //   if (message.notification != null) {
      //     print(
      //         'Message also contained a notification: ${message.notification}');
      //
      //     service.showNotification(
      //         id: 12,
      //         title: message.notification!.title!,
      //         body: message.notification!.body!);
      //   }
      // });
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print('Message data: ${event.data}');

        if (event.notification != null) {
          print(
              'Message also contained a notification: ${event.notification!.body}');
        }
      });
    }
  }
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => DatabaseProvider()),
      ChangeNotifierProvider(create: (context) => ModelSchoolBranchSystem()),
      ChangeNotifierProvider(create: (context) => ThemeDataHomePage()),
      ChangeNotifierProvider(
          create: (context) => ThemeDataHomePageForProject()),
      ChangeNotifierProvider(create: (context) => ModelShowYearListView()),
      ChangeNotifierProvider(create: (context) => TotalAmount()),
      ChangeNotifierProvider(create: (context) => ModelClassEducation()),
      ChangeNotifierProvider(create: (context) => ModelYearEducation()),
      ChangeNotifierProvider(create: (context) => PdfProvider()),
      ChangeNotifierProvider(create: (context) => SplashDataProvider()),
      ChangeNotifierProvider(create: (context) => DashboardProvider()),
      ChangeNotifierProvider(create: (context) => MyProvider()),
      ChangeNotifierProvider(create: (context) => ClientAccountProvider()),
      ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
      ChangeNotifierProvider(create: (context) => FirebaseAuthProvider()),
      ChangeNotifierProvider(create: (context) => MySqlProvider()),
      ChangeNotifierProvider(create: (context) => RefreshDataProvider()),
      ChangeNotifierProvider(create: (context) => CreateClientProvider()),
      ChangeNotifierProvider(create: (context) => ModelShowSectionListView()),
      ChangeNotifierProvider(create: (context) => ModelSectionStudentList()),
      ChangeNotifierProvider(create: (context) => ModelFeeDueList()),
      ChangeNotifierProvider(create: (context) => RestaurantDatabaseProvider()),
      ChangeNotifierProvider(
          create: (context) => ShowInsertingTableRowTOServer()),
      ChangeNotifierProvider(
          create: (context) => statusSearchForSchoolFinder()),
      ChangeNotifierProvider(create: (context) => StudentImageManagement()),
    ], child: MyApp()),
  );
}
