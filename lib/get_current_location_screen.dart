import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GetCurrentLocationScreen extends StatefulWidget {
  const GetCurrentLocationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GetCurrentLocationScreenState createState() => _GetCurrentLocationScreenState();
}

class _GetCurrentLocationScreenState extends State<GetCurrentLocationScreen> {
  Position? currentPosition;
  String? currentLocationAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Geolocator'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentPosition != null)
                Text(
                  "LAT: ${currentPosition?.latitude}",
                  style: const TextStyle(fontSize: 23),
                ),
              const SizedBox(height: 15),
              if (currentPosition != null)
                Text(
                  "LONG: ${currentPosition?.longitude}",
                  style: const TextStyle(fontSize: 23),
                ),
              const SizedBox(height: 15),
              if (currentLocationAddress != null)
                Text(
                  currentLocationAddress!,
                  style: const TextStyle(fontSize: 23),
                ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  getCurrentLocation();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Get Current Location", style: TextStyle(fontSize: 22, color: Colors.white)),
              ),
            ],
          ),
        ));
  }

  Future<PermissionStatus> getLocationStatus() async {
    // Request for permission
    final status = await Permission.location.request();
    // change the location status
    //  var _locationStatus = status;
    //   debugPrint(_locationStatus);
    return status;
  }

  getCurrentLocation() async {
    // Call Location status function here
    final status = await getLocationStatus();
    // debugPrint("I am insdie get location");
    // if permission is granted or limited call function
    if (status == PermissionStatus.granted || status == PermissionStatus.limited) {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
          .then((Position position) {
        setState(() {
          currentPosition = position;
          getCurrentLocationAddress();
        });
      }).catchError((e) {
        // debugPrint(e);
      });
    }
  }

  getCurrentLocationAddress() async {
    try {
      List<Placemark> listPlaceMarks =
          await placemarkFromCoordinates(currentPosition!.latitude, currentPosition!.longitude);

      Placemark place = listPlaceMarks[0];

      setState(() {
        currentLocationAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      // debugPrint(e);
    }
  }
}
