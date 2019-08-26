import 'package:poe_clicker/network/ninja_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';

class NinjaRequest {
  static const List<String> SUPPORTED_LEAGUES = [
    "Legion",
    "Hardcore Legion",
    "Standard",
    "Hardcore"
  ];

  static const String CURRENCY_BASE_URL = "https://poe.ninja/api/Data/GetCurrencyOverview?league=%";
  static const String ESSENCE_BASE_URL = "https://poe.ninja/api/Data/GetEssenceOverview?league=%";
  static const String FOSSIL_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Fossil";
  static const String BEAST_BASE_URL = "https://poe.ninja/api/data/itemoverview?league=%&type=Beast";

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
    return extractResponse(response);
  }

  static Future<List<NinjaItem>> getFossilRatios(String league) async {
    final String url = addLeague(FOSSIL_BASE_URL, league);
    final response = await http.get(url);
    return extractResponse(response);
  }

  static Future<List<NinjaItem>> getBeastRatios(String league) async {
    final String url = addLeague(BEAST_BASE_URL, league);
    final response = await http.get(url);
    return extractResponse(response);
  }

  static List<NinjaItem> extractResponse(Response response) {
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

  static String addLeague(String baseUrl, String league) {
    String url = Uri.encodeFull(baseUrl.replaceFirst("%", league));
    print(url);
    return url;
  }
}