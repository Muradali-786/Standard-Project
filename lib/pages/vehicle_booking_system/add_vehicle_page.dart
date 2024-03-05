import 'dart:convert';
import 'dart:io';

import 'package:com/pages/material/get_current_location_from_map.dart';
import 'package:com/pages/vehicle_booking_system/sql_file.dart';
import 'package:flutter/material.dart';


import '../../shared_preferences/shared_preference_keys.dart';
import '../../widgets/constants.dart';
import '../free_classified_add/image_upload_to_server/image_upload_to_server.dart';

class AddVehiclePage extends StatefulWidget {
  final Map data;
  final void Function(void Function()) setState;

  const AddVehiclePage({super.key, required this.data, required  this.setState});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  List<File> imagesPicked = [];

  String selectedStatus = 'Show my permanent location';
  List<String> status = [
    'Show my permanent location',
    'Show my current location',
    'Not Available'
  ];

  int VehicleGroupID = 1;

  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.data.isNotEmpty) {
      vehicleNumberController.text = widget.data['VehicleNo'].toString();
      colorController.text = widget.data['Colour'].toString();
      modelController.text = widget.data['Model'].toString();
      brandController.text = widget.data['Brand'].toString();
      locationController.text = widget.data['PermanentLocation'].toString();
      rateController.text = widget.data['ChargesPerKM'].toString();
      remarksController.text = widget.data['Remarks'].toString();
      selectedStatus = widget.data['Status'].toString();

      VehicleGroupID = widget.data['VehicleGroupID'];
      uint8ListToFileImages(widget.data['CountryUserID'].toString()).then((value) {
        setState(() {
          imagesPicked.addAll(value);
        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                children: [
                  imagesPicked.isNotEmpty
                      ? SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imagesPicked.length,
                      itemBuilder: (context, index) =>
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(imagesPicked[index]))),
                                ),
                              ),

                              InkWell(
                                onTap: () async{

                                 await  showDialog(context: context, builder: (context) => AlertDialog(
                                    content: Text('Do you rally want to delete this image'),
                                    actions: [
                                      TextButton(onPressed: () async {
                                        if(widget.data.isNotEmpty) {
                                          String delete = await deleteFolderFromServer(widget.data['CountryUserID'].toString(), index.toString());

                                          if(delete ==  'deleted'){
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Deleted')));
                                          }
                                        }
                                          imagesPicked.removeAt(index);

                                        Navigator.pop(context);
                                      }, child: Text('Delete')),
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text('Cancel'))
                                    ],
                                  ),);

                                setState(() { });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.cancel, color: Colors.red,),
                                ),
                              )
                            ],
                          ),
                    ),
                  )
                      : SizedBox(),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          File? file = await imageUploadingToServer(
                              status: '', mainContext: context);
                          if (file == null) return;
                          imagesPicked.add(file);


                            String base64Image =
                            base64Encode(file.readAsBytesSync());
                             vehicleImageUploadToServer(
                                base64Image,(imagesPicked.length -1).toString(), context);

                          setState(() {});
                        },
                        child: Text('Pick Image')),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                    controller: vehicleNumberController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        label: Text('Vehicle Number'))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                    controller: colorController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        label: Text('Color'))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                    controller: modelController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        label: Text('Model'))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                    controller: brandController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        label: Text('Brand'))),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: FutureBuilder<List>(
                  future: getVehicleGroupName(context: context),
                  builder: (context, snapshot) {
                    List<String> name = [];

                    if (snapshot.hasData) {
                      snapshot.data!.forEach((element) {
                        name.add(element['VehicleGroupName']);
                      });
                      return DropdownMenu<String>(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .95,
                        initialSelection: widget.data.isNotEmpty ? name[(widget
                            .data['VehicleGroupID']) - 1] : snapshot.data!
                            .first['VehicleGroupName'],
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            snapshot.data!.forEach((element) {
                              if (value == element['VehicleGroupName']) {
                                VehicleGroupID = element['VehicleGroupID'];
                              }
                            });
                            print(VehicleGroupID);
                          });
                        },
                        dropdownMenuEntries:
                        name.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 60,
                  child: TextField(
                      readOnly: true,
                      controller: locationController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffix: IconButton(
                              onPressed: () async {
                                List location = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GetCurrentLocation(),
                                    ));

                                if (location.isNotEmpty) {
                                  locationController.text =
                                  '${location[0]},${location[1]}';
                                }
                              },
                              icon: Icon(Icons.map)),
                          focusedBorder: OutlineInputBorder(),
                          label: Text('Location'))),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top : 8.0, ),
              //   child: DropdownMenu<String>(
              //
              //     width: MediaQuery.of(context).size.width * .95,
              //
              //     initialSelection: availableFor.first,
              //     onSelected: (String? value) {
              //       // This is called when the user selects an item.
              //       setState(() {
              //         selectedAvailable = value!;
              //       });
              //     },
              //     dropdownMenuEntries:
              //         availableFor.map<DropdownMenuEntry<String>>((String value) {
              //       return DropdownMenuEntry<String>(value: value, label: value);
              //     }).toList(),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: DropdownMenu<String>(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .95,
                  initialSelection: selectedStatus,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                  dropdownMenuEntries:
                  status.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                    controller: rateController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        label: Text('Rate per km'))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                    controller: remarksController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        label: Text('Remarks'))),
              ),

              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () async {
                            String insert = '';
                            Constants.onLoading(
                                context, 'Images is Uploading');

                            if (widget.data.isNotEmpty) {
                          insert =  await   editVehicle(context: context,
                                  VehicleName: vehicleNumberController.text,
                                  VehicleID: widget.data['VehicleID'],
                                  Brand: brandController.text,
                                  Model: modelController.text,
                                  Colour: colorController.text,
                                  VehicleGroupID: VehicleGroupID,
                                  Status: selectedStatus,
                                  LiveLocation: locationController.text,
                                  PermanentLocation: locationController.text,
                                  ContactNo: SharedPreferencesKeys.prefs!
                                      .getString(SharedPreferencesKeys
                                      .mobileNumber)
                                      .toString(),
                                  UpdatedDate: '',
                                  ChargesPerKM: rateController.text,
                                  Remarks: remarksController.text);
                            } else {
                               insert = await addVehicle(context: context,
                                  VehicleName: vehicleNumberController.text,
                                  Brand: brandController.text,
                                  Model: modelController.text,
                                  Colour: colorController.text,
                                  Account3ID: 0,
                                  VehicleGroupID: VehicleGroupID,
                                  Status: selectedStatus,
                                  LiveLocation: locationController.text,
                                  PermanentLocation: locationController.text,
                                  ContactNo: SharedPreferencesKeys.prefs!
                                      .getString(SharedPreferencesKeys
                                      .mobileNumber)
                                      .toString(),
                                  SerialNo: 0,
                                  CountryClientID: SharedPreferencesKeys.prefs!
                                      .getString(SharedPreferencesKeys
                                      .countryClientId)
                                      .toString(),
                                  CountryUserID: SharedPreferencesKeys.prefs!
                                      .getString(SharedPreferencesKeys
                                      .countryUserId)
                                      .toString(),
                                  UpdatedDate: '',
                                  ChargesPerKM: rateController.text,
                                  Remarks: remarksController.text);
                            }
                            Constants.hideDialog(context,);

                            widget.setState((){});
                            if (insert == 'Insert') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Vehicle added successfully')));
                            }
                          },
                          child: Text('SAVE')),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
