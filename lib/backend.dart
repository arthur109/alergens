import 'dart:ui';

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

