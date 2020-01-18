import 'dart:ui';

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
  int time;

  Report(this.name, this.lat, this.lon);
}

final List<Allergen> allAllergens = [
  Allergen('Bee', Colors.amber, 'assets/bee.png'),
  Allergen('Peanut', Colors.red, 'assets/peanut.png'),
  Allergen('Pollen', Colors.purple, 'assets/pollen.png')
];