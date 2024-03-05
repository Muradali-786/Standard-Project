import 'package:cached_network_image/cached_network_image.dart';
import 'package:com/pages/vehicle_booking_system/single_vehicle_details_view.dart';
import 'package:com/pages/vehicle_booking_system/sql_file.dart';
import 'package:flutter/material.dart';

import '../../shared_preferences/shared_preference_keys.dart';

class VehicleDetailsListView extends StatefulWidget {
  const VehicleDetailsListView({super.key});

  @override
  State<VehicleDetailsListView> createState() => _VehicleDetailsListViewState();
}

class _VehicleDetailsListViewState extends State<VehicleDetailsListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List>(
          future: getVehicle2Name(context: context),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              print('${snapshot.data}..........................////////////////////////////////////////././././././.');
              return ListView.builder(
                itemCount: snapshot.data!.length, itemBuilder: (context, index) =>
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,

                      decoration: BoxDecoration(
                          border: Border.all()
                      ),

                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SingleVehicleDetailsView(data: snapshot.data![index]),));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              SizedBox(
                                width: 90,
                                child: CachedNetworkImage(
                                  imageUrl: 'http://api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/VehicleImages/${snapshot.data![index]['CountryUserID']}/0.jpg',
                                  height: 100,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
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
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Far :${snapshot.data![index]['PermanentLocation']}'),
                                    Text('Vehicle No : ${snapshot.data![index]['VehicleNo']}'),
                                    Text('Vehicle types : types'),
                                    Text('${snapshot.data![index]['Colour']}, ${snapshot.data![index]['Brand']}, ${snapshot.data![index]['Model']} '),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),);
            }else{
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
