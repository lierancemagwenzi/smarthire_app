import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smarthire/model/provider.dart';

class GoogleMapsDemo extends StatefulWidget {
  double lang;
  double lat;
  GoogleMapsDemo({@required this.lang, this.lat});

  @override
  _GoogleMapsDemoState createState() => _GoogleMapsDemoState();
}

class _GoogleMapsDemoState extends State<GoogleMapsDemo> {
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _kGooglePlex;
  static CameraPosition _kLake;
  List<Marker> _markers = <Marker>[];
  @override
  void initState() {
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.lat, widget.lang),
      zoom: 14.4746,
    );

    _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(widget.lat, widget.lang),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    _markers.add(Marker(
        markerId: MarkerId('SomeId'),
        position: LatLng(widget.lat, widget.lang),
        infoWindow: InfoWindow(title: 'The title of the marker')));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
//            label: Text('back'),
            heroTag: "1",
            child: Icon(Icons.arrow_back),
          ),
          FloatingActionButton.extended(
            onPressed: _goToTheLake,
            label: Text('show landmarks'),
            icon: Icon(Icons.directions_boat),
          ),
        ],
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
