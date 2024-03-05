import 'package:com/pages/place_finder_from_map/show_all_school.dart';
import 'package:com/pages/place_finder_from_map/utils.dart';


import 'package:flutter/material.dart';

import 'loading.dart';

class SchoolFinder extends StatefulWidget {
  const SchoolFinder({
    super.key,
  });

  @override
  State<SchoolFinder> createState() => _SchoolFinderState();
}

class _SchoolFinderState extends State<SchoolFinder> {
  List<SchoolInfo> schools = [];
  List<String> searchList = [];
  TextEditingController placeController = TextEditingController(text: 'school');
  TextEditingController locationCityController =
      TextEditingController(text: 'Karachi');
  // TextEditingController locationCountryController =
  //     TextEditingController(text: 'Pakistan');
  TextEditingController radiusController = TextEditingController(text: '5000');

  Future<void> fetchSchools(context) async {
    if(searchList.isNotEmpty) {
      LoadingView.onLoading(context);

      try {
     await fetchSchoolInfo(searchList, placeController.text,  context);



        LoadingView.hideDialog(context);
      } catch (e) {
        print('Error: $e');
      }
    }else{
      showToast(context: context, title: 'No Data For Search');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('School Finder'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: ListView(
          children: [
            const Padding(padding: EdgeInsets.all(12)),
            TextField(
              controller: placeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Enter Place'),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: locationCityController,
                decoration:  InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    searchList.add('${locationCityController.text.toString()} pakistan');
                    setState(() {

                    });
                    locationCityController.clear();
                  }, icon: Icon(Icons.add)),
                  border: OutlineInputBorder(),
                  label: Text('Enter City'),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),

            Text(searchList.toString()),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await fetchSchools(context);

                    setState(() {});
                  } catch (e) {
                    print('Error: $e');
                  }
                },
                child: const Text('Search')),


            ElevatedButton(
                onPressed: () async {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => ShowSchool(),));
                },
                child: const Text('Show All Data')),




            // ListView.builder(
            //   itemCount: schools.length,
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index) => Card(
            //     child: SizedBox(
            //       height: 130,
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text('School Name: ${schools[index].name}'),
            //             Text('Phone Number: ${schools[index].phoneNumber}'),
            //             Text('Latitude: ${schools[index].latitude}'),
            //             Text(' Longitude: ${schools[index].longitude}')
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        )),
      ),
    );
  }
}
