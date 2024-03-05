import 'package:flutter/material.dart';
import 'package:com/config/screen_config.dart';
import 'package:com/main/tab_bar_pages/home/Dashboard.dart';
import 'package:com/pages/login/login_selection_design.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';


class HomePage extends StatefulWidget {
  final String? fromPage;

  const HomePage({Key? key, this.fromPage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        widget.fromPage == 'Login'
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginSelection()))
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ListWidget()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Admin Dashboard"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/table_view_page');
                    },
                    child: Text("Table View Page")),
              ),
              // Center(
              //   child: ElevatedButton(
              //       onPressed: () {
              //
              //         Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolFinder() ,));
              //       },
              //       child: Text("School Finder")),
              // ),
              // ElevatedButton(
              //     onPressed: () {
              //       // Navigator.push(
              //       //   context,
              //       //  // MaterialPageRoute(builder: (context) => DropDownWidget()),
              //       // );
              //     },
              //     child: Text("Dropdown Search")),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/dashboard_page');
              //     },
              //     child: Text("Dashboard")),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/login_selection_page');
              //     },
              //     child: Text('Original app')),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/account2_group');
              //     },
              //     child: Text("Account2 Name")),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/account3_name');
              //     },
              //     child: Text("Account3 Name")),
              // ElevatedButton(
              //     onPressed: () async {
              //       Provider.of<RefreshDataProvider>(context, listen: false)
              //           .insertAccount2GroupDataToServer(context);
              //     },
              //     child: Text("Insert ")),
              // ElevatedButton(
              //     onPressed: () async {
              //       Provider.of<RefreshDataProvider>(context, listen: false)
              //           .updateAccount2GroupDataToServer(context);
              //     },
              //     child: Text("Update ")),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/item2_group');
              //     },
              //     child: Text("Item2 Group")),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/item3_name');
              //     },
              //     child: Text("Item3 Name")),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/cash_book');
              //     },
              //     child: Text("Cash Book")),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/database_Picker_Style_1');
              //     },
              //     child: Text("Date Picker1")),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/database_Picker_Style_2');
              //     },
              //     child: Text("Date Picker2")),
              // ElevatedButton(
              //     onPressed: () {
              //       print(SharedPreferencesKeys.prefs!
              //           .getString(SharedPreferencesKeys.countryUserId)
              //           .toString());
              //     },
              //     child: Text("Test")),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => CreateClient()),
              //       );
              //     },
              //     child: Text("Create Client")),
              // ElevatedButton(
              //     onPressed: () async {
              //              Provider.of<RefreshDataProvider>(context, listen: false)
              //           .getAllUpdatedDataFromServer(context, false);
              //     },
              //     child: Text("Refresh")),
              // ElevatedButton(
              //     onPressed: () async {
              //       await Provider.of<RefreshDataProvider>(context,
              //               listen: false)
              //           .account4UserRightsRefreshing(context);
              //     },
              //     child: Text("Refresh account4UserRights table")),

              ///  client info /////////////////////////////
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "CountryClientId " +
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.countryClientId)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "CountryUserId " +
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.countryUserId)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "CountryClientId2 " +
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.countryClientID2)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "countryUserId2 " +
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.countryUserId2)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),

                    Text(
                      "clinetId " +
                          SharedPreferencesKeys.prefs!
                              .getInt(SharedPreferencesKeys.clinetId)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "clientUserId " +
                          SharedPreferencesKeys.prefs!
                              .getInt(SharedPreferencesKeys.clientUserId)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "projectId " +
                          SharedPreferencesKeys.prefs!
                              .getInt(SharedPreferencesKeys.projectId)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "DateFormat " +
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.dateFormat)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "from Date " +
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.fromDate)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "To Date " +
                          SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.toDate)
                              .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
