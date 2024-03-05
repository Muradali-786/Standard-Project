import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GetCurrentLocation extends StatefulWidget {
  const GetCurrentLocation({Key? key}) : super(key: key);

  @override
  _GetCurrentLocationState createState() => _GetCurrentLocationState();
}

class _GetCurrentLocationState extends State<GetCurrentLocation> {
  LatLng? _initialCameraPosition;

  final Set<Marker> markers = Set<Marker>();
  bool shouldAutoFocusOnUserLocation = true;

  GoogleMapController? controller;
  Location _location = Location();

  @override
  void initState() {
    super.initState();
    _location.getLocation().then((value) {
      _initialCameraPosition = LatLng(value.latitude!, value.longitude!);
      setState(() {});
    });
  }

  void _onMapCreated(GoogleMapController _value) async {
    print(
        '////////////////////////////////////////////////////////////////////////on create');
    LocationData locationData;
    locationData = await _location.getLocation();
    controller = _value;
    controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 20,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  // Function to update the camera position when needed
  void updateCameraPosition(LatLng newPosition) {
    if (shouldAutoFocusOnUserLocation) {
      controller!.animateCamera(
        CameraUpdate.newLatLng(newPosition),
      );
    }
  }

  // You can call this function when you receive new location updates
  void onLocationUpdate(LatLng newLocation) {
    updateCameraPosition(newLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              _initialCameraPosition == null
                  ? Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialCameraPosition!,
                      ),
                      mapType: MapType.normal,
                      markers: markers,
                      onCameraMove: (CameraPosition position) {
                        // Disable auto-focus when the user manually moves the map
                        shouldAutoFocusOnUserLocation = false;
                      },
                      onCameraIdle: () {
                        // Re-enable auto-focus when the user stops moving the map
                        shouldAutoFocusOnUserLocation = true;
                      },
                      onTap: (location) {
                        print(location.latitude);
                        markers.clear();
                        markers.add(
                          Marker(
                            markerId: MarkerId('marker1'),
                            position: LatLng(
                                location.latitude,
                                location
                                    .longitude), // Replace with your desired coordinates
                          ),
                        );
                        _initialCameraPosition = location;
                        onLocationUpdate(location);

                        setState(() {});
                      },
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                    ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 40, 60, 40),
                  height: 45,
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context, [
                        _initialCameraPosition!.longitude,
                        _initialCameraPosition!.latitude
                      ]);
                    },
                    color: Colors.grey[200],
                    child: const Text(
                      'Get Location',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
