import 'dart:async';
import 'package:alergens/backend.dart';
import 'package:alergens/ui_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SelectLocation extends StatefulWidget {
  Allergen allergen;
  SelectLocation(this.allergen);
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  bool panelOpen = false;
  double radius = 20;
  LatLng camPos;
  GoogleMapController mapController;

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1);

  final LatLng _center = const LatLng(33.6191515, -117.8228972);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Circle> circles = Set.from([
    Circle(
      circleId: CircleId("cursor"),
      center: LatLng(45.6, -122.6),
      radius: 4000,
    )
  ]);

  Set<Marker> icons;
  var myIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.bottomLeft,
            child: GoogleMap(
              mapType: MapType.normal,
              circles: circles,
              markers: icons,
              compassEnabled: false,
              mapToolbarEnabled: false,
              trafficEnabled: false,
              myLocationButtonEnabled: true,
              onMapCreated: _onMapCreated,
              onCameraMove: updateCircleCam,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 50,
              ),
            )),
        Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  UIGenerator.label("Radius: " + radius.toString() + "m"),
                  Slider(
                      divisions: 10,
                      activeColor: this.widget.allergen.color,
                      inactiveColor:
                          this.widget.allergen.color.withOpacity(0.3),
                      value: radius,
                      onChanged: updateCircleRad,
                      max: 200,
                      min: 10),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Icon(
                            Icons.gps_fixed,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          geolocator
                              .getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.best)
                              .then((data) {
                            setPosition(data.latitude, data.longitude);
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          "Select the Allergen location.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(91, 91, 111, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 2,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Sophia'),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              UIGenerator.coloredText("Confirm", Colors.white),
                            ],
                          ),
                        ),
                        onTap: () {
                         reportAllergen(Report(this.widget.allergen.name, camPos.latitude, camPos.longitude, radius));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    ));
  }

  void updateCircleRad(double value) {
    radius = value;
    updateCircle();
  }

  void updateCircleCam(CameraPosition cam) {
    camPos = cam.target;
    updateCircle();
  }

  void updateCircle() {
    setState(() {
      circles = Set.from([
        Circle(
          strokeColor: this.widget.allergen.color.withOpacity(1),
          fillColor: this.widget.allergen.color.withOpacity(0.6),
          circleId: CircleId("cursor"),
          center: camPos,
          radius: radius,
        ),
        Circle(
          strokeColor: this.widget.allergen.color.withOpacity(1),
          fillColor: this.widget.allergen.color.withOpacity(1),
          circleId: CircleId("john"),
          center: camPos,
          radius: 3,
        )
      ]);

      // icons = Set.from([
      //   Marker(
      //       markerId: MarkerId("hello"),
      //       position: camPos,
      //       icon: myIcon)
      // ]);
    });
  }

  void setPosition(double lat, double long) {
    if (mapController != null) {
      mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(size: Size(128, 128)), this.widget.allergen.icon)
    //     .then((onValue) {
    //   myIcon = onValue;
    // });
  }
}
