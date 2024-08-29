import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../cons/const.dart';


class ChangeLocation extends StatefulWidget {
  const ChangeLocation({super.key});

  @override
  State<ChangeLocation> createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng cam;
  Set<Marker> _markers = {};

  void _onCameraMove(CameraPosition position) {
    setState(() {
      cam = position.target;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('picked_location'),
          position: cam,
        ),
      );
    });
  }

  void _ChangeLocation() {
    setState(() {
      showlat = cam.latitude;
      showlong = cam.longitude;
    });
    print('${userLat}, ${userLong}');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Change'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              mapToolbarEnabled: true,
              mapType: MapType.satellite,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(showlat!, showlong!),
                zoom: 20.0,
              ),
              onCameraMove: _onCameraMove,
              markers: _markers,
            ),
            Positioned(
              bottom: 16.0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      _ChangeLocation();
                    },
                    child: Text("CHANGE LOCATION", style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}