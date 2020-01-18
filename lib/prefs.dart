import 'package:shared_preferences/shared_preferences.dart';

class Prefs{
  static SharedPreferences prefs;


  @override
  Prefs() {
    setPrefs();
  }

  static void setPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  static List<String> getAllAllergens(){
    return prefs.getStringList('allergens');
  }

  static void addAllergen(String allergen){
    List<String> allergens = prefs.getStringList('allergens');
    if(!allergens.contains(allergen)){
      allergens.add(allergen);
    }
    prefs.setStringList('allergens', allergens);
  }

  static void removeAllergen(String allergen){
    List<String> allergens = prefs.getStringList('allergens');
    if(allergens.contains(allergen)){
      allergens.remove(allergens.indexOf(allergen));
    }
    prefs.setStringList('allergens', allergens);
  }

}