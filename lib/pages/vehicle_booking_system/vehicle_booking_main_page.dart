import 'package:com/pages/vehicle_booking_system/add_vehicle_page.dart';
import 'package:com/pages/vehicle_booking_system/sql_file.dart';
import 'package:com/pages/vehicle_booking_system/vehicle_details_list_view.dart';
import 'package:com/pages/vehicle_booking_system/vehicle_details_map_view.dart';
import 'package:com/pages/vehicle_booking_system/widgets.dart';
import 'package:flutter/material.dart';

class VehicleBookingMainPage extends StatefulWidget {
  final String title;

  final int projectID;

  const VehicleBookingMainPage(
      {super.key, required this.title, required this.projectID});

  @override
  State<VehicleBookingMainPage> createState() => _VehicleBookingMAinPAgeState();
}

class _VehicleBookingMAinPAgeState extends State<VehicleBookingMainPage> {
  String intercity = '';
  List<String> intercityList = ['For under city', 'For out of city'];

  String view = '';
  List<String> viewList = ['Map', 'List'];

  String km = '';
  List<String> kmList = ['1 km', '2 km', '3 km', '10 km', '100 km'];

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            FutureBuilder<List>(
              future : getVehicle2NameForEdit(context: context),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return menuBTNForAddVehicle(onSelected: (value) {
                    if (value == 0) {


                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddVehiclePage(data: snapshot.data!.isEmpty ? {} : snapshot.data![0], setState: setState),
                          ));
                    }
                  });
                }else{
                  return SizedBox();
                }
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {



                        },
                        child: Text('POST Your Ride'))),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                        height: 50,
                        width: 60,
                        child: Icon(
                          Icons.car_crash_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width * .3,
                          initialSelection: intercityList.first,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              intercity = value!;
                            });
                          },
                          dropdownMenuEntries: intercityList
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        child: DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width * .3,
                          initialSelection: viewList.first,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              view = value!;
                            });
                          },
                          dropdownMenuEntries: viewList
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        child: DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width * .3,
                          initialSelection: kmList.first,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              km = value!;
                            });
                          },
                          dropdownMenuEntries: kmList
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                view == 'List'
                    ? Expanded(child: VehicleDetailsListView())
                    : Expanded(child: FutureBuilder<List>(
                    future:  getVehicle2Name(context: context),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return VehicleDetailsMapView(data: snapshot.data!,);
                      }else{
                        return Center(child: CircularProgressIndicator());
                      }
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
