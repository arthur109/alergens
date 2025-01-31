import 'dart:async';
import 'package:alergens/backend.dart';
import 'package:alergens/report_allergen.dart';
import 'package:alergens/ui_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool panelOpen = false;
  GoogleMapController mapController;

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1);

  StreamSubscription<Position> positionStream;

  final LatLng _center = const LatLng(33.6191515, -117.8228972);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Circle> circles = Set.from([
    Circle(
      circleId: CircleId("john"),
      center: LatLng(45.6, -122.6),
      radius: 4000,
    )
  ]);

  Set<Circle> userPos = Set.from([
    Circle(
      circleId: CircleId("john"),
      center: LatLng(45.6, -122.6),
      radius: 4000,
    )
  ]);

  Set<Marker> markers = Set.from([]);

  @override
  Widget build(BuildContext context) {
    print("-------------------------------------------");
    print(circles.length);
    return MaterialApp(
        home: Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.black,
                child: Icon(Icons.gps_fixed),
                onPressed: () {
                  geolocator
                      .getLastKnownPosition(
                          desiredAccuracy: LocationAccuracy.best)
                      .then((data) {
                    setPosition(data.latitude, data.longitude);
                  });
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.new_releases,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    UIGenerator.coloredText("Report\nAllergen", Colors.white),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => SelectAllergenType()),
                );
              },
            ),
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        circles: circles,
        // markers: markers,
        compassEnabled: false,
        mapToolbarEnabled: false,
        trafficEnabled: false,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 30,
        ),
      ),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNearbyAllergens().listen((data) {
      print("--------------------");
      print(data);
      if (data != null && data.length > 0) {
        setState(() {
          circles = Set.from([]);
          int counter = 0;
          for (Report i in data) {
            counter++;
            circles.addAll([
              Circle(
                strokeColor: getAllergen(i.name).color.withOpacity(1),
                fillColor: getAllergen(i.name).color.withOpacity(0.6),
                circleId: CircleId(counter.toString()),
                center: LatLng(i.lat, i.lon),
                radius: i.radius,
              ),
              Circle(
                strokeColor: getAllergen(i.name).color.withOpacity(1),
                fillColor: getAllergen(i.name).color.withOpacity(1),
                circleId: CircleId((counter + 0.5).toString()),
                center: LatLng(i.lat, i.lon),
                radius: 1,
              )
            ]);
          }
        });
      }
    });

    // positionStream = geolocator
    //     .getPositionStream(locationOptions)
    //     .listen((Position position) {
    //   setState(() {
    //     circles.add(
    //       Circle(
    //         fillColor: Colors.blue,
    //         strokeColor: Colors.blueAccent,
    //         circleId: CircleId("john"),
    //         center: LatLng(position.latitude, position.longitude),
    //         radius: 2,
    //       )
    //     );
    //   });
    // });
  }

  // Widget openPanel() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: <Widget>[
  //       SizedBox(
  //         height: 16,
  //       ),
  //       UIGenerator.heading("Nearby Allergens")
  //     ],
  //   );
  // }

  // Widget collapsedPanel() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: <Widget>[
  //       SizedBox(
  //         height: 16,
  //       ),
  //       UIGenerator.heading("Nearby Allergens")
  //     ],
  //   );
  // }

  void setPosition(double lat, double long) {
    if (mapController != null) {
      mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    }
  }

  Allergen getAllergen(String name) {
    for (Allergen i in allAllergens) {
      if (i.name == name) {
        return i;
      }
    }
    return null;
  }
}
