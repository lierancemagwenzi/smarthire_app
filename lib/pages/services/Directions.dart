//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:geocoder/geocoder.dart';
//import 'package:google_map_polyline/google_map_polyline.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:smarthire/constants/colors.dart';
//
//class DirectionsScreen extends StatefulWidget {
//  @override
//  _DirectionsScreenState createState() => _DirectionsScreenState();
//}
//
//class _DirectionsScreenState extends State<DirectionsScreen> {
//  LatLng _from = const LatLng(10.0244244, 105.7562064); //home
//  LatLng _to = const LatLng(-26.0767744, 28.0621021);
//
//  LatLng _center = const LatLng(-26.0767744, 28.0621021);
//  String city = "";
//  String state = "";
//  String pncode = "";
//
//  final Set<Marker> _markers = {};
//  //LatLng _lastMapPosition = const LatLng(10.020909, 105.786489);
//  var isLoading = false;
//  int _polylineCount = 1;
//  Completer<GoogleMapController> _controller = Completer();
//
//  double totaldistance = 0.0;
//  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
//  GoogleMapPolyline _googleMapPolyline =
//      new GoogleMapPolyline(apiKey: "AIzaSyBDYSnRBc7UxtDcLH1dWklVIi6NpUFhCts");
//  //Polyline patterns
//  List<List<PatternItem>> patterns = <List<PatternItem>>[
//    <PatternItem>[], //line
//    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
//    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
//    <PatternItem>[
//      //dash-dot
//      PatternItem.dash(30.0),
//      PatternItem.gap(20.0),
//      PatternItem.dot,
//      PatternItem.gap(20.0)
//    ],
//  ];
//
//  //Get polyline with Location (latitude and longitude)
//  _getPolylinesWithLocation(LatLng _from) async {
//    print('LOCATION FROM ${_from.toString()} TO: ${_to}');
//
//    //_setLoadingMenu(true);
//    List<LatLng> _coordinates =
//        await _googleMapPolyline.getCoordinatesWithLocation(
//            origin: _from, destination: _to, mode: RouteMode.driving);
//
//    print('LOCATION ${_coordinates.toString()}');
//
//    setState(() {
//      _polylines.clear();
//    });
//
//    double distanceis = (Geolocator.distanceBetween(
//            _from.latitude, _from.longitude, _to.latitude, _to.longitude) /
//        1000);
//
//    setState(() {
//      totaldistance = distanceis;
//    });
//
//    print('DISTANCE IS : ${distanceis}');
//
//    double lat = _to.latitude;
//    double lng = _to.longitude;
//
//    final coordinates = new Coordinates(_to.latitude, _to.longitude);
//
//    await Geocoder.local
//        .findAddressesFromCoordinates(coordinates)
//        .then((value) {
//      for (int i = 0; i < value.length; i++) {
//        print('${value[i].locality}');
//        if (value[i].locality != null && value[i].locality.length > 1) {
//          setState(() {
//            city = value[i].locality;
//            state = value[i].adminArea;
//          });
//          break;
//        }
//      }
//    });
//
//    _addPolyline(_coordinates);
//    //_setLoadingMenu(false);
//  }
//
//  Future<Position> _determinePosition() async {
//    bool serviceEnabled;
//    LocationPermission permission;
//
//    // Test if location services are enabled.
//    serviceEnabled = await Geolocator.isLocationServiceEnabled();
//    if (!serviceEnabled) {
//      // Location services are not enabled don't continue
//      // accessing the position and request users of the
//      // App to enable the location services.
//      return Future.error('Location services are disabled.');
//    }
//
//    permission = await Geolocator.checkPermission();
//    if (permission == LocationPermission.denied) {
//      permission = await Geolocator.requestPermission();
//      if (permission == LocationPermission.deniedForever) {
//        // Permissions are denied forever, handle appropriately.
//        return Future.error(
//            'Location permissions are permanently denied, we cannot request permissions.');
//      }
//
//      if (permission == LocationPermission.denied) {
//        // Permissions are denied, next time you could try
//        // requesting permissions again (this is also where
//        // Android's shouldShowRequestPermissionRationale
//        // returned true. According to Android guidelines
//        // your App should show an explanatory UI now.
//        return Future.error('Location permissions are denied');
//      }
//    } else {
//      // When we reach here, permissions are granted and we can
//      // continue accessing the position of the device.
//      setState(() {
//        isLoading = true;
//      });
//      Position position = await Geolocator.getCurrentPosition();
//      print("your postion" + position.longitude.toString());
//      LatLng from = LatLng(position.latitude, position.longitude);
//      setState(() {
//        isLoading = false;
//      });
//      draw(from);
//      return await Geolocator.getCurrentPosition();
//    }
//  }
//
//  _addPolyline(List<LatLng> _coordinates) {
//    PolylineId id = PolylineId("poly$_polylineCount");
//    Polyline polyline = Polyline(
//        polylineId: id,
//        patterns: patterns[0],
//        color: smarthireBlue,
//        points: _coordinates,
//        width: 5,
//        onTap: () {});
//
//    setState(() {
//      _polylines[id] = polyline;
//      _polylineCount++;
//    });
//  }
//
//  Geolocator _geolocator;
//  Position _position;
//
//  @override
//  void initState() {
//    super.initState();
//    _determinePosition();
//  }
//
//  draw(LatLng _from) {
//    _geolocator = Geolocator();
//    LocationOptions locationOptions =
//        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
//
//    setState(() {
//      _from = _from;
//      _to = _to;
//      _center = _center;
//    });
//    _getPolylinesWithLocation(_from);
//  }
//
//  void _onMapCreated(GoogleMapController controller) {
//    _controller.complete(controller);
//
//    setState(() {
//      _markers.add(Marker(
//        // This marker id can be anything that uniquely identifies each marker.
//        markerId: MarkerId(_from.toString()),
//        position: _from,
//
//        infoWindow: InfoWindow(
//          title: "",
//          //snippet: 'Đánh giá: 5*',
//        ),
//        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//      ));
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Stack(
//        children: <Widget>[
//          isLoading
//              ? Center(child: CircularProgressIndicator())
//              : GoogleMap(
//                  myLocationEnabled: true,
//                  myLocationButtonEnabled: true,
//                  onMapCreated: _onMapCreated,
//                  polylines: Set<Polyline>.of(_polylines.values),
//                  initialCameraPosition: CameraPosition(
//                    target: _center,
//                    zoom: 16.0,
//                  ),
//                  markers: _markers,
//                ),
//          Positioned(
//            top: 10.0,
//            left: 8.0,
//            child: SafeArea(
//              child: Column(
//                children: <Widget>[
//                  SizedBox(
//                    width: 100.0,
//                    child: Card(
//                        color: smarthireBlue,
//                        child: ListTile(
//                          title: Text(
//                            city,
//                            style: TextStyle(color: Colors.red),
//                          ),
//                        )),
//                  ),
//                  SizedBox(
//                    width: 100.0,
//                    child: Card(
//                        color: smarthireBlue,
//                        child: ListTile(
//                          title: Text(
//                            totaldistance.toStringAsFixed(2) + "KM",
//                            style: TextStyle(color: Colors.red),
//                          ),
//                        )),
//                  )
//                ],
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
