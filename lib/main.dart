import 'package:alergens/backend.dart';
import 'package:alergens/home_page.dart';
import 'package:alergens/report_allergen.dart';
import 'package:alergens/mapSuggestion.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // MapSuggestion bob = new MapSuggestion();


    // bob.searchNearby(33.6275,-117.8194083,"pizza").then((suggestions) {
    //   for (SuggestedDestination s in suggestions) {
    //     print(s.toString());
    //   }
    // });

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // Define the default Brightness and Colors
          brightness: Brightness.light,
          primaryColor: Colors.indigoAccent,
          accentColor: Colors.white,
          fontFamily: 'Sophia'),
      home: HomePage()
    );
  }
}
