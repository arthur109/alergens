import 'dart:convert';
import 'package:http/http.dart' as http;

class MapSuggestion{
    static const String _API_KEY = 'AIzaSyDOiwhy1-wZlVMZOHwFn83geLFv6is9yk4';
    static final double SEARCH_RADIUS = 1000000;
    static final String baseUrl= 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    var data;

    MapSuggestion();

    Future<List<SuggestedDestination>> searchNearby(double latitude, double longitude, String phrase) async {
      String url =
          '$baseUrl?key=$_API_KEY&location=$latitude,$longitude&radius=$SEARCH_RADIUS&keyword=$phrase';
          
      final response = await http.get(url);

      if (response.statusCode == 200) {
          data = jsonDecode(response.body);
      } else {
          throw Exception('An error occurred getting places nearby');
      }

      return organizeData();
    }

    List<SuggestedDestination> organizeData(){
      List<SuggestedDestination> places;
      List<Map<String, dynamic>> results;

      print(data);
      if(data != null){
        results = new List();
        for (Map<String, dynamic> result in data['results']) {
          results.add(result);
        }

        for (Map<String, dynamic> result in results) {
          places.add(new SuggestedDestination(
              result["geometry"]["location"]["lng"],
              result["geometry"]["location"]["lat"],
              result["name"],
              result["id"],
              result["icon"]
            ),
          );
      }
      }else{
        print("no Data");
      }

      return places;
    }

}

class SuggestedDestination{
    double longitude;
    double latitude;
    String name; 
    String id;
    String icon;

    SuggestedDestination(double lon, double lat, String name, String markerId, String icon){
        this.longitude = lon;
        this.latitude = lat;
        this.name = name;
        this.id = markerId;
        this.icon = icon;
    }

    String toString(){
      return "Longitude: "+longitude.toString()+" Latitude: "+latitude.toString()+" name: "+name+" id: "+id;
    }
}

