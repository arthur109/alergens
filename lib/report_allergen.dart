import 'dart:async';
import 'package:alergens/backend.dart';
import 'package:alergens/select_location.dart';
import 'package:alergens/ui_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SelectAllergenType extends StatefulWidget {
  @override
  _SelectAllergenTypeState createState() => _SelectAllergenTypeState();
}

class _SelectAllergenTypeState extends State<SelectAllergenType> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: Main,
        children: <Widget>[
          SizedBox(
            height: 54,
          ),
          Center(child: UIGenerator.heading("Report Allergen")),
          Center(child: UIGenerator.subtitle("Select the type.")),
          Expanded(
              child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(allAllergens.length, (index) {
              Allergen allergen = allAllergens[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => SelectLocation(allergen)),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Image.asset(allergen.icon),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 8,
                              color: HSVColor.fromColor(allergen.color)
                                  .withValue(
                                      HSVColor.fromColor(allergen.color).value -
                                          0.1)
                                  .toColor()),
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            // 10% of the width, so there are ten blinds.
                            colors: [
                              allergen.color.withOpacity(0.8),
                              HSVColor.fromColor(allergen.color)
                                  .withHue(
                                      HSVColor.fromColor(allergen.color).hue +
                                          20)
                                  .toColor(),
                            ], // whitish to gray
                            tileMode: TileMode
                                .repeated, // repeats the gradient over the canvas
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Expanded(child: UIGenerator.normalText(allergen.name))
                    ],
                  ),
                ),
              );
            }),
          )),
        ],
      ),
    );
  }
}
