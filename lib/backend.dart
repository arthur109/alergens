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

  Report(this.name, this.lat, this.lon);

  Report.fromJson(Map<String, dynamic> json) :
        name = json['name'],
        lat = json['lat'],
        lon = json['lon'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'lat': lat,
    'lon': lon
  };
}

final List<Allergen> allAllergens = [
  Allergen('Bee', Colors.amber, 'assets/bee.png'),
  Allergen('Peanut', Colors.red, 'assets/peanut.png'),
  Allergen('Pollen', Colors.purple, 'assets/pollen.png')
];

Future<void> reportAllergen(Report report) async {
  await FirebaseDatabase.instance.reference().child('reports').push().set(report.toJson());
}

Stream getNearbyAllergens(){
  return FirebaseDatabase.instance.reference()
      .child('reports')
      .onValue
      .map(
          (event) =>
              event.snapshot.value
              .map((json) => Report.fromJson(json)).toList()
      );
}