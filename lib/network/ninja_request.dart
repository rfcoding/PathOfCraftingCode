import 'dart:ffi';

import 'package:poe_clicker/network/ninja_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';

class NinjaRequest {
  static const List<String> SUPPORTED_LEAGUES = [
    "Metamorph",
    "Hardcore Metamorph",
    "Standard",
    "Hardcore"
  ];

  static const String CURRENCY_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Currency";
  static const String ESSENCE_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Essence";
  static const String FOSSIL_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Fossil";
  static const String RESONATOR_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Resonator";
  static const String BEAST_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Beast";
  static const String ARMOUR_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=UniqueArmour";
  static const String WEAPON_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=UniqueWeapon";

  static Future<List<NinjaItem>> getCurrencyRatios(String league) async {
    final String url = addLeague(CURRENCY_BASE_URL, league);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<NinjaItem> ninjaCurrencies = List();
      var json = jsonDecode(response.body)['lines'];
      json.forEach((data) {
        NinjaItem item = NinjaItem.fromCurrencyJson(data);
        if (item != null) {
          ninjaCurrencies.add(item);
        }
      });
      ninjaCurrencies.add(NinjaItem(name: "Chaos Orb", chaosValue: 1));
      return ninjaCurrencies;
    }
    return List();
  }

  static Future<List<NinjaItem>> getEssenceRatios(String league) async {
    final String url = addLeague(ESSENCE_BASE_URL, league);
    final response = await http.get(url);
    return extractNinjaItemResponse(response);
  }

  static Future<List<NinjaItem>> getFossilRatios(String league) async {
    final String url = addLeague(FOSSIL_BASE_URL, league);
    final response = await http.get(url);
    return extractNinjaItemResponse(response);
  }

  static Future<List<NinjaItem>> getResonatorRatios(String league) async {
    final String url = addLeague(RESONATOR_BASE_URL, league);
    final response = await http.get(url);
    return extractNinjaItemResponse(response);
  }

  static Future<List<NinjaItem>> getBeastRatios(String league) async {
    final String url = addLeague(BEAST_BASE_URL, league);
    final response = await http.get(url);
    return extractNinjaItemResponse(response);
  }

  static Future<List<NinjaSixLink>> getSixLinkArmours(String league) async {
    final String url = addLeague(ARMOUR_BASE_URL, league);
    final response = await http.get(url);
    List<NinjaGear> armours = extractNinjaGearResponse(response);
    List<NinjaSixLink> sixLinks =  armours.where((armour) => armour.links == 6).map((sixLink) {
      if (armours.any((armour) => armour.links != 6 && armour.name == sixLink.name && armour.variant == sixLink.variant)) {
        NinjaGear baseArmour = armours.firstWhere((armour) => armour.links != 6 && armour.name == sixLink.name && armour.variant == sixLink.variant);
        return NinjaSixLink(sixLink.name, sixLink.chaosValue, sixLink.chaosValue - baseArmour.chaosValue, sixLink.variant);
      }
      return null;
    }).toList();
    sixLinks.removeWhere((item) => item == null);
    return sixLinks;
  }

  static Future<List<NinjaSixLink>> getSixLinkWeapons(String league) async {
    final String url = addLeague(WEAPON_BASE_URL, league);
    final response = await http.get(url);
    List<NinjaGear> weapons = extractNinjaGearResponse(response);
    List<NinjaSixLink> sixLinks =  weapons.where((weapon) => weapon.links == 6).map((sixLink) {
      if (weapons.any((weapon) => weapon.links != 6 && weapon.name == sixLink.name && weapon.variant == sixLink.variant)) {
        NinjaGear baseWeapon = weapons.firstWhere((weapon) => weapon.links != 6 && weapon.name == sixLink.name && weapon.variant == sixLink.variant);
        return NinjaSixLink(sixLink.name, sixLink.chaosValue, sixLink.chaosValue - baseWeapon.chaosValue, sixLink.variant);
      }
      return null;
    }).toList();
    sixLinks.removeWhere((item) => item == null);
    return sixLinks;
  }

  static List<NinjaItem> extractNinjaItemResponse(Response response) {
    var json = jsonDecode(response.body)['lines'];
    List<NinjaItem> ninjaItems = List();
    json.forEach((data) {
      final NinjaItem item = NinjaItem.fromJson(data);
      if (item != null) {
        ninjaItems.add(item);
      }
    });
    return ninjaItems;
  }

  static List<NinjaGear> extractNinjaGearResponse(Response response) {
    var json = jsonDecode(response.body)['lines'];
    List<NinjaGear> ninjaArmours = List();
    json.forEach((data) {
      List<double> sparklineData = new List<double>.from(data['sparkline']['data']);
      if (sparklineData.isNotEmpty) {
        final NinjaGear item = NinjaGear.fromJson(data);
        if (item != null) {
          ninjaArmours.add(item);
        }
      }
    });
    return ninjaArmours;
  }

  static String addLeague(String baseUrl, String league) {
    String url = Uri.encodeFull(baseUrl.replaceFirst("%", league));
    print(url);
    return url;
  }
}