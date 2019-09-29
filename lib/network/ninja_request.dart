import 'dart:ffi';

import 'package:poe_clicker/network/ninja_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';

class NinjaRequest {
  static const List<String> SUPPORTED_LEAGUES = [
    "Blight",
    "Hardcore Blight",
    "Standard",
    "Hardcore"
  ];

  static const String CURRENCY_BASE_URL = "https://poe.ninja/api/Data/GetCurrencyOverview?league=%";
  static const String ESSENCE_BASE_URL = "https://poe.ninja/api/Data/GetEssenceOverview?league=%";
  static const String FOSSIL_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Fossil";
  static const String RESONATOR_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Resonator";
  static const String BEAST_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Beast";
  static const String ARMOUR_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=UniqueArmour";

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
    List<NinjaArmour> armours = extractNinjaArmourResponse(response);
    List<NinjaSixLink> sixLinks =  armours.where((armour) => armour.links == 6).map((sixLink) {
      if (armours.any((armour) => armour.links != 6 && armour.name == sixLink.name)) {
        NinjaArmour baseArmour = armours.firstWhere((armour) => armour.links != 6 && armour.name == sixLink.name);
        return NinjaSixLink(sixLink.name, sixLink.chaosValue, sixLink.chaosValue - baseArmour.chaosValue);
      }
      return null;
    }).toList();
    sixLinks.removeWhere((item) => item == null);
    sixLinks.sort((a, b) => b.chaosProfit.compareTo(a.chaosProfit));
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

  static List<NinjaArmour> extractNinjaArmourResponse(Response response) {
    var json = jsonDecode(response.body)['lines'];
    List<NinjaArmour> ninjaArmours = List();
    json.forEach((data) {
      List<double> sparklineData = new List<double>.from(data['sparkline']['data']);
      if (sparklineData.isNotEmpty) {
        final NinjaArmour item = NinjaArmour.fromJson(data);
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