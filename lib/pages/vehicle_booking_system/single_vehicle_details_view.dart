import 'package:cached_network_image/cached_network_image.dart';
import 'package:com/pages/vehicle_booking_system/sql_file.dart';
import 'package:flutter/material.dart';

import '../../shared_preferences/shared_preference_keys.dart';

class SingleVehicleDetailsView extends StatefulWidget {
   final Map data ;
  const SingleVehicleDetailsView({super.key,required this.data});

  @override
  State<SingleVehicleDetailsView> createState() => _SingleVehicleDetailsViewState();
}

class _SingleVehicleDetailsViewState extends State<SingleVehicleDetailsView> {

  List  allImage = [];
   @override
  void initState() {
    super.initState();

    allImages(widget.data['CountryUserID'].toString()).then((value) {
      setState(() {
        allImage = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all()
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: CachedNetworkImage(
                        imageUrl: 'https://www.api.easysoftapp.com/PhpApi1/ClientImages/${SharedPreferencesKeys.prefs!.getString('CountryName')}/UserLogo/${SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.countryUserId).toString()}',
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys.nameOfPerson) ??
                              "Not Available", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          Text(SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys
                              .mobileNumber)
                              .toString()
                              .length >
                              4 ? SharedPreferencesKeys.prefs!
                              .getString(SharedPreferencesKeys
                              .mobileNumber)!
                               :
                              "Not Available", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Vehicle No : ${widget.data['VehicleNo']}'),
                        Text('Color : ${widget.data['Colour']} '),
                        Text('Model : ${widget.data['Model']} '),
                        Text('Brand : ${widget.data['Brand']} '),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height *.3,
                    child: PageView.builder(
                      itemCount: allImage.length,
                      itemBuilder: (context, index) => Container(
                        color: Colors.grey,
                        child: Image.memory(allImage[index], fit: BoxFit.cover),
                      ),
                    )),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {



                      },
                      child: Text('WhatsApp')),),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {



                        },
                        child: Text('Call')),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
