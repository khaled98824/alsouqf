import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';

class LocationService {
  late String countryName;
  late String adminArea;

  late FirebaseFirestore _service ;

  sendLocationToDataBase(context) async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    final coordinates= Coordinates(_locationData.latitude, _locationData.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    countryName =address.first.countryName;
    adminArea = address.first.adminArea;
    print('feature${address.first.featureName}');
    print(address.first.countryName);
    print(address.first.addressLine);
    print(address.first.adminArea);



    FirebaseFirestore.instance.collection('sections')
        .doc().set(
      {
        'latitude': _locationData.latitude,
        'longitude': _locationData.longitude,
      },
    );
  }



  goToMaps(double latitude, double longitude) async {
    String mapLocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    final String encodedURl = Uri.encodeFull(mapLocationUrl);
    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
  }
}