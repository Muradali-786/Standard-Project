import 'package:com/pages/vehicle_booking_system/single_vehicle_details_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class VehicleDetailsMapView extends StatefulWidget {
  final List data;

  const VehicleDetailsMapView({super.key, required this.data});

  @override
  State<VehicleDetailsMapView> createState() => _VehicleDetailsMapViewState();
}

class _VehicleDetailsMapViewState extends State<VehicleDetailsMapView> {
  final Set<Marker> markers = Set<Marker>();
  final LatLng _initialCameraPosition = LatLng(20.5937, 78.9629);

  GoogleMapController? controller;
  Location _location = Location();

  @override
  void initState() {
    super.initState();
    widget.data.forEach((element) {
      print('${element['PermanentLocation'].toString().split(',')}');
      List logLat = element['PermanentLocation'].toString().split(',');
      if (logLat.length == 2) {
        double long = double.parse(logLat[0].toString());
        double lat = double.parse(logLat[1].toString());
        markers.add(
          Marker(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SingleVehicleDetailsView(data: element),
                  ));
            },
            markerId: MarkerId('marker1'),
            position:
                LatLng(lat, long), // Replace with your desired coordinates
          ),
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController _value) async {
    LocationData locationData;
    locationData = await _location.getLocation();
    controller = _value;
    controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 15,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          markers: markers,
          initialCameraPosition: CameraPosition(
            target: _initialCameraPosition,
          ),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
