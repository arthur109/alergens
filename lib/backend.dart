import 'dart:convert';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Allergen {
  String name;
  Color color;
  String icon;

  Allergen(this.name, this.color, this.icon);

  Allergen.fromJson(Map<String, dynamic> json) :
        name = json['name'],
        color = json['color'],
        icon = json['icon'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color,
    'icon': icon
  };
}

class Report {
  String name;
  double lat;
  double lon;
  double radius;

  Report(this.name, this.lat, this.lon,  this.radius);

  Report.fromJson(Map<String, dynamic> json) :
        name = json['name'],
        lat = json['lat'] + 0.0,
        lon = json['lon'] + 0.0,
        radius = json['lon'] + 0.0;

  Map<String, dynamic> toJson() => {
    'name': name,
    'lat': lat,
    'lon': lon,
    'radius': radius
  };

  @override
  String toString() {
    return jsonEncode(this);
  }
}

final List<Allergen> allAllergens = [
  Allergen('Bee', Colors.amber, 'assets/bee.png'),
  Allergen('Peanut', Colors.red, 'assets/peanut.png'),
  Allergen('Pollen', Colors.purple, 'assets/pollen.png'),
  Allergen('Cat', Colors.white30, 'assets/cat.png'),
  Allergen('Dog', Colors.brown, 'assets/dog.png'),
  Allergen('Smoke', Colors.white12, 'assets/smoke.png'),
  Allergen('Radiation', Colors.green, 'assets/smoke.png')
];

Future<void> reportAllergen(Report report) async {
  await FirebaseDatabase.instance.reference().child('reports').push().set(report.toJson());
}

Stream getNearbyAllergens(){
  return FirebaseDatabase.instance.reference()
      .child('reports')
      .onValue
      .map(
          (event) {
            List<Report> reports = [];

            dynamic value = event.snapshot.value;

            for (String key in value.keys) {
              Map<String, dynamic> map = {};

              for (String innerKey in value[key].keys) {
                map[innerKey] = value[key][innerKey];
              }

              reports.add(Report.fromJson(map));
            }

            return reports;
          }
      );
}