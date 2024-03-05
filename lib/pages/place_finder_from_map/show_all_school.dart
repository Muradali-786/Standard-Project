import 'package:com/pages/place_finder_from_map/sql_finder.dart';
import 'package:com/pages/place_finder_from_map/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'loading.dart';

class ShowSchool extends StatefulWidget {
  const ShowSchool({super.key});

  @override
  State<ShowSchool> createState() => _ShowSchoolState();
}

class _ShowSchoolState extends State<ShowSchool> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(

        actions: [
          IconButton(onPressed: (){
            deleteAllData();
            setState(() {

            });
          }, icon: Icon(Icons.delete))
        ],
      ),

      bottomNavigationBar: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder<List>(
              future:  selectAllDataFromContact(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return ElevatedButton(
                      onPressed: () async {
                        bool statuses;
                        final deviceInfoPlugin = DeviceInfoPlugin();
                        final deviceInfo = await deviceInfoPlugin.androidInfo;
                        final sdkInt = deviceInfo.version.sdkInt;
                        statuses = sdkInt < 29
                            ? await Permission.storage
                            .request()
                            .isGranted
                            : true;

                        if (statuses) {
                              () {
                             exportToExcel(snapshot.data!, context);
                          }();
                        }
                        // } else {
                        //   showToast(context: context, title: 'No Data');
                        // }
                      },
                      child: const Text('Export'));
                }else{
                  return SizedBox();
                }
              },
            ),
            ElevatedButton(
                onPressed: () async{
                  LoadingViewForInsertingContact.onLoading(context);
                  await   updateNumber(context);
                  LoadingViewForInsertingContact.hideDialog(context);
                  setState(() {

                  });
                },
                child: const Text('Update NO')),
            ElevatedButton(
                onPressed: () async{
                  LoadingViewForInsertingContact.onLoading(context);
                  if (await FlutterContacts.requestPermission()) {
                    await insertIntoBook(context);
                  }
                  LoadingViewForInsertingContact.hideDialog(context);
                  setState(() {

                  });
                },
                child: const Text('Insert')),



          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List>(
          future: selectAllDataFromContact(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'School Name: ${snapshot.data![index]['BusinessName']}'),
                          Text('Business Type: ${snapshot.data![index]['BusinessType']}'),
                           Text('Reference: ${snapshot.data![index]['RefranceKey']}'),
                           Text('Contact number: ${snapshot.data![index]['ContactNo']}')
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
